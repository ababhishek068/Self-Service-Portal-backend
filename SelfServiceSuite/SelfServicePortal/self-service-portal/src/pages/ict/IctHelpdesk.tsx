import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { useMemo, useState, type ReactNode } from 'react'
import {
  cancelIctHelpdeskTicket,
  confirmIctHelpdeskTicket,
  createIctHelpdeskTicket,
  fetchIctHelpdeskMeta,
  getIctHelpdeskTicket,
  listIctHelpdeskTickets,
  updateIctHelpdeskTicket,
  type IctHelpdeskTicket,
} from '@/api/endpoints/ictHelpdesk'
import { AuthApiError } from '@/api/client/authClient'
import { useToast } from '@/components/feedback/ToastProvider'
import { PageWrapper } from '@/components/layout/PageWrapper'
import { DataTable, type DataTableColumn } from '@/components/shared/DataTable'
import { PortalNewButton } from '@/components/shared/PortalNewButton'
import { StatusBadge } from '@/components/shared/StatusBadge'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Select } from '@/components/ui/select'
import { Textarea } from '@/components/ui/textarea'
import { useAuth } from '@/hooks/useAuth'
import { usePermissions } from '@/hooks/usePermissions'

const DASH = '—'

const fallbackRequestTypes = [
  'Incident / Problem',
  'Service Request',
  'Access Request',
  'Hardware',
  'Software',
  'Network',
  'ERP / Application',
  'Email',
  'Printer',
  'Other',
]

const fallbackPriorities = ['Critical', 'High', 'Medium', 'Low']

const fallbackStatuses = [
  { value: 'NEW', label: 'New' },
  { value: 'ASSIGNED', label: 'Assigned' },
  { value: 'IN_PROGRESS', label: 'In Progress' },
  { value: 'PENDING_USER', label: 'Pending User' },
  { value: 'PENDING_VENDOR', label: 'Pending Vendor' },
  { value: 'RESOLVED', label: 'Resolved' },
  { value: 'CLOSED', label: 'Closed' },
  { value: 'CANCELLED', label: 'Cancelled' },
]

function formatWhen(value: string) {
  if (!value || value.startsWith('0001-01-01')) return DASH
  const date = new Date(value)
  if (Number.isNaN(date.getTime())) return value
  return date.toLocaleString()
}

function errorMessage(error: unknown) {
  if (error instanceof AuthApiError) return error.message
  return String((error as { message?: string } | null)?.message ?? error ?? 'Request failed')
}

type CreateForm = {
  subject: string
  description: string
  requestType: string
  priority: string
  contactPhone: string
  contactEmail: string
  locationBranch: string
  attachmentName: string
}

type DeskForm = {
  trackingStatus: string
  assignee: string
  ictTeam: string
  expectedResolutionDate: string
  actionTaken: string
  rootCause: string
  resolutionRemarks: string
  closureReason: string
}

export function IctHelpdesk() {
  const { employee } = useAuth()
  const { has } = usePermissions()
  const toast = useToast()
  const queryClient = useQueryClient()
  const [mode, setMode] = useState<'list' | 'create' | 'detail'>('list')
  const [selectedNo, setSelectedNo] = useState('')
  const [confirmRemarks, setConfirmRemarks] = useState('')
  const [confirmRating, setConfirmRating] = useState('5')
  const [cancelRemarks, setCancelRemarks] = useState('')

  const roleIsIctAdmin = has('ictAdmin')
  const metaQuery = useQuery({
    queryKey: ['ict', 'helpdesk', 'meta'],
    queryFn: fetchIctHelpdeskMeta,
  })
  // Desk: ictAdmin role, API meta, IT Manager title, or Hermon ABH-114.
  // Do not match bare "IT" (Zerihun "Media and IT Expert" stays staff).
  const titleIsIctDesk = /\bit\s*manag|\bict\s*(officer|admin|administrator)?\b|\bhelp\s*desk\b/i.test(
    String(employee?.jobTitle ?? ''),
  )
  const canManageDesk =
    roleIsIctAdmin ||
    Boolean(metaQuery.data?.canManageDesk) ||
    titleIsIctDesk ||
    String(employee?.employeeNo ?? '').toUpperCase() === 'ABH-114'
  const ticketsQuery = useQuery({
    queryKey: ['ict', 'helpdesk', 'tickets', canManageDesk ? 'desk' : 'mine'],
    queryFn: () => listIctHelpdeskTickets(canManageDesk ? 'desk' : 'mine'),
    // Wait for meta so Hermon does not briefly fetch "mine" and keep an empty cache key race.
    enabled: !metaQuery.isLoading,
  })

  const [createForm, setCreateForm] = useState<CreateForm>({
    subject: '',
    description: '',
    requestType: 'Incident / Problem',
    priority: 'Medium',
    contactPhone: employee?.phoneNumber ?? '',
    contactEmail: employee?.email ?? '',
    locationBranch: employee?.branchName || employee?.branchCode || '',
    attachmentName: '',
  })

  const [deskForm, setDeskForm] = useState<DeskForm>({
    trackingStatus: 'NEW',
    assignee: '',
    ictTeam: '',
    expectedResolutionDate: '',
    actionTaken: '',
    rootCause: '',
    resolutionRemarks: '',
    closureReason: '',
  })

  const rows = ticketsQuery.data?.rows ?? []
  const detailQuery = useQuery({
    queryKey: ['ict', 'helpdesk', 'ticket', selectedNo],
    queryFn: () => getIctHelpdeskTicket(selectedNo),
    enabled: mode === 'detail' && Boolean(selectedNo),
  })
  const selected = useMemo(() => {
    if (detailQuery.data?.ticket?.no === selectedNo) return detailQuery.data.ticket
    return rows.find((row) => row.no === selectedNo) ?? null
  }, [detailQuery.data, rows, selectedNo])
  const ticketIsFinal = Boolean(
    selected &&
      ['CLOSED', 'CANCELLED', 'CANCELED'].includes(
        String(selected.trackingStatus || selected.status || '')
          .toUpperCase()
          .replace(/\s+/g, '_'),
      ),
  )

  const requestTypeOptions = (
    metaQuery.data?.requestTypes?.map((row) => row.description || row.code).filter(Boolean) ??
    fallbackRequestTypes
  ).map((value) => ({ value, label: value }))
  const priorityOptions = (metaQuery.data?.priorities?.map((row) => row.value) ?? fallbackPriorities).map(
    (value) => ({ value, label: value }),
  )
  const statusOptions = (metaQuery.data?.statuses ?? fallbackStatuses).filter((row) => {
    const value = String(row.value || '').toUpperCase()
    // ICT never reopens from Closed/Cancelled via status dropdown.
    if (ticketIsFinal) return value === String(selected?.trackingStatus || '').toUpperCase()
    // Staff tickets should not jump back to New once work started.
    if (value === 'NEW' && selected && String(selected.trackingStatus || '').toUpperCase() !== 'NEW') {
      return false
    }
    // Closed is set by requester confirm — ICT marks Resolved instead.
    if (value === 'CLOSED') return false
    return true
  })
  const officerOptions = [
    { value: '', label: 'Select ICT officer' },
    ...(metaQuery.data?.officers ?? []).map((officer) => ({
      value: officer.employeeNo,
      label: `${officer.name} (${officer.employeeNo})`,
    })),
  ]
  if (
    employee?.employeeNo &&
    !officerOptions.some(
      (row) => row.value.toUpperCase() === employee.employeeNo.toUpperCase(),
    )
  ) {
    officerOptions.push({
      value: employee.employeeNo,
      label: `${employee.displayName || 'Me'} (${employee.employeeNo})`,
    })
  }

  const invalidate = async () => {
    await queryClient.invalidateQueries({ queryKey: ['ict', 'helpdesk'] })
  }

  function setDeskFormFromTicket(ticket: IctHelpdeskTicket) {
    setDeskForm({
      trackingStatus: ticket.trackingStatus || 'NEW',
      assignee: ticket.assignee,
      ictTeam: ticket.ictTeam || ticket.requisitionCategory,
      expectedResolutionDate: ticket.expectedResolutionDate?.slice(0, 10) || '',
      actionTaken: ticket.actionTaken,
      rootCause: ticket.rootCause,
      resolutionRemarks: ticket.resolutionRemarks,
      closureReason: ticket.closureReason,
    })
  }

  const createMutation = useMutation({
    mutationFn: createIctHelpdeskTicket,
    onSuccess: async (result) => {
      toast.success(`ICT ticket ${result.ticket.no} submitted`)
      await invalidate()
      setSelectedNo(result.ticket.no)
      setMode('detail')
      setDeskFormFromTicket(result.ticket)
    },
    onError: (error) => toast.error(errorMessage(error)),
  })

  const updateMutation = useMutation({
    mutationFn: (input: DeskForm) => updateIctHelpdeskTicket(selectedNo, input),
    onSuccess: async (result) => {
      toast.success(`Ticket ${result.ticket.no} updated`)
      await invalidate()
      setDeskFormFromTicket(result.ticket)
      setSelectedNo(result.ticket.no)
    },
    onError: (error) => toast.error(errorMessage(error)),
  })

  function saveDeskUpdate() {
    const status = String(deskForm.trackingStatus || '').toUpperCase().replace(/\s+/g, '_')
    let assignee = String(deskForm.assignee || '').trim()
    if (!assignee && employee?.employeeNo) {
      assignee = employee.employeeNo
    }
    if (
      ['ASSIGNED', 'IN_PROGRESS', 'RESOLVED'].includes(status) &&
      !assignee
    ) {
      toast.error('Select Assigned ICT Staff before saving')
      return
    }
    updateMutation.mutate({ ...deskForm, assignee, trackingStatus: status || deskForm.trackingStatus })
  }

  const confirmMutation = useMutation({
    mutationFn: () =>
      confirmIctHelpdeskTicket(selectedNo, confirmRemarks, Number(confirmRating) || 5),
    onSuccess: async (result) => {
      toast.success(`Ticket ${result.ticket.no} closed`)
      await invalidate()
      setDeskFormFromTicket(result.ticket)
      setConfirmRemarks('')
    },
    onError: (error) => toast.error(errorMessage(error)),
  })

  const cancelMutation = useMutation({
    mutationFn: () => cancelIctHelpdeskTicket(selectedNo, cancelRemarks),
    onSuccess: async (result) => {
      toast.success(`Ticket ${result.ticket.no} cancelled`)
      await invalidate()
      setDeskFormFromTicket(result.ticket)
      setCancelRemarks('')
    },
    onError: (error) => toast.error(errorMessage(error)),
  })

  const columns: DataTableColumn<IctHelpdeskTicket>[] = [
    { id: 'no', header: 'ID', cell: (row) => row.no },
    { id: 'date', header: 'Date / Time', cell: (row) => formatWhen(row.date) },
    { id: 'subject', header: 'Subject', cell: (row) => row.subject || row.description || DASH },
    { id: 'type', header: 'Type', cell: (row) => row.requestType || row.requisitionCategory || DASH },
    { id: 'priority', header: 'Priority', cell: (row) => row.priority || DASH },
    {
      id: 'status',
      header: 'Status',
      cell: (row) => <StatusBadge status={row.status || row.trackingStatus || 'New'} />,
    },
    {
      id: 'assignee',
      header: 'Assigned ICT',
      cell: (row) => row.assigneeName || row.assignee || DASH,
    },
  ]

  const isOwner = selected?.requestedBy?.toUpperCase() === employee?.employeeNo?.toUpperCase()
  const trackingCode = String(selected?.trackingStatus || '')
    .toUpperCase()
    .replace(/\s+/g, '_')
    .trim()
  const statusLabel = String(selected?.status || '').toLowerCase()
  const resolutionLabel = String(selected?.resolutionStatus || '').toLowerCase()
  const hasResolvedDate =
    Boolean(selected?.dateResolved) && !String(selected?.dateResolved).startsWith('0001-01-01')
  const isResolvedWaitingConfirm =
    trackingCode === 'RESOLVED' ||
    statusLabel === 'resolved' ||
    resolutionLabel.includes('resolved waiting') ||
    resolutionLabel.includes('waiting user') ||
    (hasResolvedDate && trackingCode !== 'CLOSED' && trackingCode !== 'CANCELLED')
  const canConfirm =
    Boolean(selected) && isOwner && !ticketIsFinal && isResolvedWaitingConfirm
  const ownerTracking = trackingCode
  const canCancel =
    Boolean(selected) &&
    !ticketIsFinal &&
    (canManageDesk ||
      (isOwner && ['NEW', 'SUBMITTED', ''].includes(ownerTracking)))
  const showDeskPanel = canManageDesk && Boolean(selected) && !ticketIsFinal
  const showUserConfirmPanel = canConfirm
  const showClosedSummary =
    Boolean(selected) &&
    ticketIsFinal &&
    (Number(selected?.satisfaction ?? 0) > 0 ||
      Boolean(selected?.userClosingRemarks) ||
      Boolean(selected?.dateUserConfirmed))

  return (
    <PageWrapper
      title="ICT Helpdesk"
      description="Submit ICT incidents and service requests. ICT officers assign, track, resolve, and close tickets."
      actions={
        mode === 'list' ? (
          <PortalNewButton label="New ICT Request" onClick={() => setMode('create')} />
        ) : (
          <Button variant="outline" onClick={() => setMode('list')}>
            Back to list
          </Button>
        )
      }
    >
      {mode === 'list' ? (
        <DataTable
          rows={rows}
          columns={columns}
          getRowId={(row) => row.no}
          emptyTitle="No ICT Helpdesk tickets yet"
          emptyAction={<PortalNewButton label="New ICT Request" onClick={() => setMode('create')} />}
          onRowClick={(row) => {
            setSelectedNo(row.no)
            setDeskFormFromTicket(row)
            setMode('detail')
          }}
        />
      ) : null}

      {mode === 'create' ? (
        <form
          className="mx-auto max-w-3xl space-y-6 rounded-2xl border border-[var(--portal-card-border)] bg-white p-6 shadow-sm"
          onSubmit={(event) => {
            event.preventDefault()
            createMutation.mutate({
              ...createForm,
              department: employee?.departmentCode || employee?.departmentName || '',
              division: employee?.branchCode || '',
            })
          }}
        >
          <section className="space-y-3">
            <h2 className="text-sm font-semibold uppercase tracking-wide text-slate-500">
              1. Basic information
            </h2>
            <div className="grid gap-3 md:grid-cols-2">
              <Field label="Requester Name">
                <Input value={employee?.displayName || ''} disabled />
              </Field>
              <Field label="Employee ID">
                <Input value={employee?.employeeNo || ''} disabled />
              </Field>
              <Field label="Division / Department">
                <Input
                  value={[
                    employee?.branchName || employee?.branchCode,
                    employee?.departmentName || employee?.departmentCode,
                  ]
                    .filter(Boolean)
                    .join(' / ')}
                  disabled
                />
              </Field>
              <Field label="Location / Branch">
                <Input
                  value={createForm.locationBranch}
                  onChange={(event) =>
                    setCreateForm((prev) => ({ ...prev, locationBranch: event.target.value }))
                  }
                />
              </Field>
              <Field label="Phone">
                <Input
                  value={createForm.contactPhone}
                  onChange={(event) =>
                    setCreateForm((prev) => ({ ...prev, contactPhone: event.target.value }))
                  }
                />
              </Field>
              <Field label="Email">
                <Input
                  type="email"
                  value={createForm.contactEmail}
                  onChange={(event) =>
                    setCreateForm((prev) => ({ ...prev, contactEmail: event.target.value }))
                  }
                />
              </Field>
            </div>
          </section>

          <section className="space-y-3">
            <h2 className="text-sm font-semibold uppercase tracking-wide text-slate-500">
              2. Request details
            </h2>
            <div className="grid gap-3 md:grid-cols-2">
              <Field label="Request Type">
                <Select
                  options={requestTypeOptions}
                  value={createForm.requestType}
                  onChange={(event) =>
                    setCreateForm((prev) => ({ ...prev, requestType: event.target.value }))
                  }
                />
              </Field>
              <Field label="Priority">
                <Select
                  options={priorityOptions}
                  value={createForm.priority}
                  onChange={(event) =>
                    setCreateForm((prev) => ({ ...prev, priority: event.target.value }))
                  }
                />
              </Field>
            </div>
            <Field label="Subject / Title">
              <Input
                required
                value={createForm.subject}
                onChange={(event) =>
                  setCreateForm((prev) => ({ ...prev, subject: event.target.value }))
                }
                placeholder="Short summary of the issue"
              />
            </Field>
            <Field label="Description of Issue">
              <Textarea
                required
                rows={5}
                value={createForm.description}
                onChange={(event) =>
                  setCreateForm((prev) => ({ ...prev, description: event.target.value }))
                }
                placeholder="Describe the problem, when it started, and any error messages"
              />
            </Field>
            <Field label="Attachment / Screenshot file name (optional)">
              <Input
                value={createForm.attachmentName}
                onChange={(event) =>
                  setCreateForm((prev) => ({ ...prev, attachmentName: event.target.value }))
                }
                placeholder="e.g. screenshot-login-error.png"
              />
            </Field>
          </section>

          <div className="flex justify-end gap-2">
            <Button type="button" variant="outline" onClick={() => setMode('list')}>
              Cancel
            </Button>
            <Button type="submit" disabled={createMutation.isPending}>
              {createMutation.isPending ? 'Submitting…' : 'Submit request'}
            </Button>
          </div>
        </form>
      ) : null}

      {mode === 'detail' && selected ? (
        <div className="mx-auto grid max-w-5xl gap-6 lg:grid-cols-[1.1fr_0.9fr]">
          <section className="space-y-4 rounded-2xl border border-[var(--portal-card-border)] bg-white p-6 shadow-sm">
            <div className="flex flex-wrap items-start justify-between gap-3">
              <div>
                <p className="text-xs font-semibold uppercase tracking-wide text-slate-500">Ticket</p>
                <h2 className="text-xl font-semibold text-slate-900">{selected.no}</h2>
                <p className="mt-1 text-sm text-slate-600">{selected.subject || selected.description}</p>
              </div>
              <StatusBadge status={selected.status || selected.trackingStatus} />
            </div>

            <dl className="grid gap-3 text-sm md:grid-cols-2">
              <Detail label="Date / Time" value={formatWhen(selected.date)} />
              <Detail
                label="Requester"
                value={`${selected.requestorName || DASH} (${selected.requestedBy})`}
              />
              <Detail label="Department" value={selected.department || DASH} />
              <Detail label="Location / Branch" value={selected.locationBranch || DASH} />
              <Detail
                label="Phone / Email"
                value={`${selected.contactPhone || DASH} / ${selected.contactEmail || DASH}`}
              />
              <Detail
                label="Request Type"
                value={selected.requestType || selected.requisitionCategory || DASH}
              />
              <Detail label="Priority" value={selected.priority || DASH} />
              <Detail label="Attachment" value={selected.attachmentName || DASH} />
              <Detail label="Assigned ICT" value={selected.assigneeName || selected.assignee || DASH} />
              <Detail label="ICT Team" value={selected.ictTeam || DASH} />
              <Detail label="Date Assigned" value={formatWhen(selected.dateAssigned)} />
              <Detail label="Expected Resolution" value={formatWhen(selected.expectedResolutionDate)} />
            </dl>

            <div>
              <p className="text-xs font-semibold uppercase tracking-wide text-slate-500">Description</p>
              <p className="mt-1 whitespace-pre-wrap text-sm text-slate-700">
                {selected.description || DASH}
              </p>
            </div>

            {(selected.actionTaken ||
              selected.rootCause ||
              selected.resolutionRemarks ||
              selected.closureReason) && (
              <div className="space-y-2 rounded-xl border border-slate-200 bg-slate-50 p-4 text-sm">
                <Detail label="Action Taken" value={selected.actionTaken || DASH} />
                <Detail label="Root Cause" value={selected.rootCause || DASH} />
                <Detail label="Resolution / Workaround" value={selected.resolutionRemarks || DASH} />
                <Detail label="Closure Reason" value={selected.closureReason || DASH} />
                <Detail label="Date Resolved" value={formatWhen(selected.dateResolved)} />
                <Detail label="Resolved By" value={selected.resolvedBy || DASH} />
              </div>
            )}

            {canConfirm ? (
              <div className="space-y-3 rounded-xl border border-emerald-200 bg-emerald-50/60 p-4">
                <h3 className="text-sm font-semibold text-emerald-900">
                  5. User confirmation &amp; 6. Closure
                </h3>
                <p className="text-xs text-emerald-800">
                  ICT marked this ticket Resolved. Rate the service (1–5), add comments, then confirm
                  to close.
                </p>
                <Field label="User Satisfaction Rating (1–5)">
                  <div className="flex flex-wrap gap-2">
                    {[1, 2, 3, 4, 5].map((value) => (
                      <Button
                        key={value}
                        type="button"
                        variant={confirmRating === String(value) ? 'default' : 'outline'}
                        className="min-w-10"
                        onClick={() => setConfirmRating(String(value))}
                      >
                        {value}★
                      </Button>
                    ))}
                  </div>
                </Field>
                <Field label="User Comments">
                  <Textarea
                    rows={3}
                    value={confirmRemarks}
                    onChange={(event) => setConfirmRemarks(event.target.value)}
                    placeholder="Confirm the fix and add any comments"
                  />
                </Field>
                <Button onClick={() => confirmMutation.mutate()} disabled={confirmMutation.isPending}>
                  {confirmMutation.isPending ? 'Closing…' : 'Confirm & close ticket'}
                </Button>
              </div>
            ) : null}

            {showClosedSummary ? (
              <div className="space-y-2 rounded-xl border border-slate-200 bg-slate-50 p-4 text-sm">
                <h3 className="text-sm font-semibold text-slate-800">Closure</h3>
                <Detail
                  label="User Satisfaction Rating"
                  value={selected?.satisfaction ? `${selected.satisfaction} / 5` : DASH}
                />
                <Detail label="User Comments" value={selected?.userClosingRemarks || DASH} />
                <Detail label="Date Closed" value={formatWhen(selected?.dateUserConfirmed || '')} />
                <Detail label="Closure Reason" value={selected?.closureReason || DASH} />
              </div>
            ) : null}

            {canCancel ? (
              <div className="space-y-3 rounded-xl border border-rose-200 bg-rose-50/50 p-4">
                <h3 className="text-sm font-semibold text-rose-900">Cancel ticket</h3>
                <Field label="Cancellation reason">
                  <Textarea
                    rows={2}
                    value={cancelRemarks}
                    onChange={(event) => setCancelRemarks(event.target.value)}
                  />
                </Field>
                <Button
                  variant="outline"
                  onClick={() => {
                    if (!cancelRemarks.trim()) {
                      toast.error('Cancellation remarks are required')
                      return
                    }
                    cancelMutation.mutate()
                  }}
                  disabled={cancelMutation.isPending}
                >
                  {cancelMutation.isPending ? 'Cancelling…' : 'Cancel ticket'}
                </Button>
              </div>
            ) : null}
          </section>

          {showDeskPanel ? (
            <section className="space-y-4 rounded-2xl border border-[var(--portal-card-border)] bg-white p-6 shadow-sm">
              <h3 className="text-sm font-semibold uppercase tracking-wide text-slate-500">
                ICT assignment & resolution
              </h3>
              <Field label="Status">
                <Select
                  options={statusOptions}
                  value={deskForm.trackingStatus}
                  onChange={(event) =>
                    setDeskForm((prev) => ({ ...prev, trackingStatus: event.target.value }))
                  }
                />
              </Field>
              <Field label="Assigned ICT Staff">
                <Select
                  options={officerOptions}
                  value={deskForm.assignee}
                  onChange={(event) =>
                    setDeskForm((prev) => ({ ...prev, assignee: event.target.value }))
                  }
                />
              </Field>
              <Field label="ICT Team / Category">
                <Input
                  value={deskForm.ictTeam}
                  onChange={(event) =>
                    setDeskForm((prev) => ({ ...prev, ictTeam: event.target.value }))
                  }
                />
              </Field>
              <Field label="Expected Resolution Date">
                <Input
                  type="date"
                  value={deskForm.expectedResolutionDate}
                  onChange={(event) =>
                    setDeskForm((prev) => ({ ...prev, expectedResolutionDate: event.target.value }))
                  }
                />
              </Field>
              <Field label="Troubleshooting / Action Taken">
                <Textarea
                  rows={3}
                  value={deskForm.actionTaken}
                  onChange={(event) =>
                    setDeskForm((prev) => ({ ...prev, actionTaken: event.target.value }))
                  }
                />
              </Field>
              <Field label="Root Cause">
                <Textarea
                  rows={2}
                  value={deskForm.rootCause}
                  onChange={(event) =>
                    setDeskForm((prev) => ({ ...prev, rootCause: event.target.value }))
                  }
                />
              </Field>
              <Field label="Resolution / Workaround">
                <Textarea
                  rows={3}
                  value={deskForm.resolutionRemarks}
                  onChange={(event) =>
                    setDeskForm((prev) => ({ ...prev, resolutionRemarks: event.target.value }))
                  }
                />
              </Field>
              <Field label="Closure Reason">
                <Input
                  value={deskForm.closureReason}
                  onChange={(event) =>
                    setDeskForm((prev) => ({ ...prev, closureReason: event.target.value }))
                  }
                />
              </Field>
              <Button
                className="w-full"
                onClick={() => saveDeskUpdate()}
                disabled={updateMutation.isPending}
              >
                {updateMutation.isPending ? 'Saving…' : 'Save ICT update'}
              </Button>
            </section>
          ) : showUserConfirmPanel ? (
            <section className="space-y-4 rounded-2xl border border-emerald-200 bg-emerald-50/70 p-6 shadow-sm">
              <h3 className="text-sm font-semibold uppercase tracking-wide text-emerald-900">
                User confirmation &amp; closure
              </h3>
              <p className="text-sm text-emerald-900">
                Rate this resolution (1–5 stars), add comments, then confirm to close the ticket.
              </p>
              <Field label="User Satisfaction Rating">
                <div className="flex flex-wrap gap-2">
                  {[1, 2, 3, 4, 5].map((value) => (
                    <Button
                      key={value}
                      type="button"
                      variant={confirmRating === String(value) ? 'default' : 'outline'}
                      className="min-w-10"
                      onClick={() => setConfirmRating(String(value))}
                    >
                      {value}★
                    </Button>
                  ))}
                </div>
              </Field>
              <Field label="User Comments">
                <Textarea
                  rows={4}
                  value={confirmRemarks}
                  onChange={(event) => setConfirmRemarks(event.target.value)}
                  placeholder="Optional comments about the fix"
                />
              </Field>
              <Button
                className="w-full"
                onClick={() => confirmMutation.mutate()}
                disabled={confirmMutation.isPending}
              >
                {confirmMutation.isPending ? 'Closing…' : 'Confirm & close ticket'}
              </Button>
            </section>
          ) : (
            <section className="rounded-2xl border border-dashed border-slate-300 bg-slate-50 p-6 text-sm text-slate-600">
              {ticketIsFinal ? (
                <>
                  This ticket is <strong>{selected?.status || selected?.trackingStatus}</strong> and
                  cannot be reopened.
                </>
              ) : (
                <>
                  ICT officers will assign, track, and resolve this ticket. When status is{' '}
                  <strong>Resolved</strong>, confirm closure here with a satisfaction rating (1–5).
                </>
              )}
            </section>
          )}
        </div>
      ) : null}
    </PageWrapper>
  )
}

function Field({ label, children }: { label: string; children: ReactNode }) {
  return (
    <label className="block space-y-1.5">
      <Label className="text-xs font-medium text-slate-600">{label}</Label>
      {children}
    </label>
  )
}

function Detail({ label, value }: { label: string; value: string }) {
  return (
    <div>
      <dt className="text-xs font-semibold uppercase tracking-wide text-slate-500">{label}</dt>
      <dd className="mt-0.5 text-slate-800">{value}</dd>
    </div>
  )
}
