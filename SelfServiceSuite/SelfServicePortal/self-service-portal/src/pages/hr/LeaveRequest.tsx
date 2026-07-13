import { useQuery, useQueryClient } from '@tanstack/react-query'
import { useEffect, useRef, useState } from 'react'
import { format, parseISO } from 'date-fns'
import { PageWrapper } from '@/components/layout/PageWrapper'
import { DataTable, type DataTableColumn } from '@/components/shared/DataTable'
import { FileUpload, type FileUploadItemState } from '@/components/shared/FileUpload'
import { RequestAttachments } from '@/components/shared/RequestAttachments'
import { PortalNewButton } from '@/components/shared/PortalNewButton'
import { useToast } from '@/components/feedback/ToastProvider'
import { useConfirm } from '@/components/feedback/ConfirmProvider'
import { useProgress } from '@/components/feedback/ProgressProvider'
import { StatusBadge } from '@/components/shared/StatusBadge'
import { ApprovalTimeline } from '@/components/shared/ApprovalTimeline'
import { RequestProgress } from '@/components/shared/RequestProgress'
import { Button } from '@/components/ui/button'
import { Badge } from '@/components/ui/badge'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Select } from '@/components/ui/select'
import { Skeleton } from '@/components/ui/skeleton'
import { Textarea } from '@/components/ui/textarea'
import {
  fetchLeaveTypes,
  fetchRelievers,
  cancelLeaveRequest,
  fetchLeaveRequestDetail,
  getLeaveBalance,
  getLeaveDates,
  listLeaveRequests,
  requestLeaveApproval,
  submitLeaveRequest,
  uploadLeaveDocumentAttachment,
  type LeaveListRow,
  type LeaveType,
} from '@/api/endpoints/leave'
import { AuthApiError } from '@/api/client/authClient'
import {
  getModuleRequest,
} from '@/api/endpoints/requestEndpoint'
import type { PortalRequest } from '@/types/erp.types'
import { env } from '@/config/env'
import type { Attachment } from '@/types/erp.types'
import { canDeleteRequestItems, canUploadRequestAttachments } from '@/utils/requestStatus'

const DASH = '—'

const halfDayOptions = [
  { value: '0', label: 'Normal' },
  { value: '1', label: 'Half Day (Morning)' },
  { value: '2', label: 'Half Day (Evening)' },
] as const

type HalfDayValue = (typeof halfDayOptions)[number]['value']

function formatPretty(iso: string): string {
  if (!iso) return ''
  try {
    return format(parseISO(iso), 'd MMM yyyy')
  } catch {
    return iso
  }
}

function formatDays(value: number | null | undefined): string {
  if (value === null || value === undefined || !Number.isFinite(value)) return DASH
  return Number.isInteger(value) ? String(value) : value.toFixed(2).replace(/\.?0+$/, '')
}

function payloadValue(payload: Record<string, unknown>, keys: string[], fallback = DASH) {
  for (const key of keys) {
    const value = payload[key]
    if (value !== undefined && value !== null && String(value) !== '') return String(value)
  }
  return fallback
}

function resolveCreatedLeaveRequestId(result: {
  request?: { id?: string; requestNo?: string }
  documentNo?: string
  returnValue?: string
}) {
  if (result.request?.id) return result.request.id
  if (result.documentNo) return `leave-${result.documentNo}`
  if (result.request?.requestNo) return `leave-${result.request.requestNo}`
  const raw = String(result.returnValue ?? '').trim()
  if (raw && !['true', 'false', '1', '0', 'yes', 'no'].includes(raw.toLowerCase())) {
    return `leave-${raw}`
  }
  return ''
}

function resolveCreatedLeaveDocumentNo(result: {
  request?: { requestNo?: string }
  documentNo?: string
  returnValue?: string
}) {
  if (result.documentNo) return result.documentNo
  if (result.request?.requestNo) return result.request.requestNo
  const raw = String(result.returnValue ?? '').trim()
  if (raw && !['true', 'false', '1', '0', 'yes', 'no'].includes(raw.toLowerCase())) {
    return raw
  }
  return ''
}

async function uploadLeaveAttachments(
  documentNo: string,
  files: Attachment[],
  onFileState?: (fileId: string, state: FileUploadItemState) => void,
) {
  let lastError: Error | null = null
  for (let attempt = 0; attempt < 3; attempt += 1) {
    try {
      if (attempt > 0) {
        await new Promise((resolve) => setTimeout(resolve, 900 * attempt))
      } else {
        await new Promise((resolve) => setTimeout(resolve, 800))
      }
      for (const file of files) {
        if (!file.contentBase64) {
          throw new Error(`${file.fileName} could not be read. Please re-select the file.`)
        }
        onFileState?.(file.id, 'uploading')
        await uploadLeaveDocumentAttachment(documentNo, {
          fileName: file.fileName,
          fileType: file.fileType,
          size: file.size,
          contentBase64: file.contentBase64,
          description: file.description || 'Leave Attachment',
        })
        onFileState?.(file.id, 'success')
      }
      return
    } catch (err: unknown) {
      lastError = err instanceof Error ? err : new Error('Attachment upload failed.')
      for (const file of files) {
        onFileState?.(file.id, 'error')
      }
    }
  }
  throw lastError ?? new Error('Attachment upload failed.')
}

async function syncLeaveStatusFromBc(
  requestNo: string,
  requestId: string,
  queryClient: ReturnType<typeof useQueryClient>,
) {
  // Gentle background reconcile: a handful of checks spaced out, not a
  // rapid poll. The backend already confirms pending before responding, so
  // this only covers the case where BC is still catching up.
  for (let attempt = 0; attempt < 6; attempt += 1) {
    await new Promise((resolve) => setTimeout(resolve, 4000))
    try {
      const detail = await fetchLeaveRequestDetail(requestNo, { silent: true })
      if (['Pending Approval', 'Approved'].includes(detail.status)) {
        queryClient.setQueryData(['hr', 'leave-detail', requestId], detail)
        queryClient.setQueryData<LeaveListRow[]>(['hr', 'leave-list'], (rows) =>
          (rows ?? []).map((row) =>
            row.ApplicationCode === requestNo ? { ...row, Status: detail.status } : row,
          ),
        )
        return
      }
    } catch {
      // keep polling until BC reflects the approval
    }
  }
  void queryClient.invalidateQueries({ queryKey: ['hr', 'leave-list'] })
  void queryClient.invalidateQueries({ queryKey: ['hr', 'leave-detail', requestId] })
}

export function LeaveRequest() {
  const queryClient = useQueryClient()
  const toast = useToast()
  const confirm = useConfirm()
  const progress = useProgress()
  const leaveListQuery = useQuery({ queryKey: ['hr', 'leave-list'], queryFn: listLeaveRequests })
  const [selectedRequestId, setSelectedRequestId] = useState<string | null>(null)
  const [creationAttachments, setCreationAttachments] = useState<Attachment[]>([])
  const [creationAttachmentStates, setCreationAttachmentStates] = useState<Record<string, FileUploadItemState>>({})
  const [detailAction, setDetailAction] = useState<string | null>(null)
  const detailQuery = useQuery({
    queryKey: ['hr', 'leave-detail', selectedRequestId],
    queryFn: async (): Promise<PortalRequest> => {
      const requestNo = selectedRequestId!.replace(/^leave-/i, '')
      try {
        return await fetchLeaveRequestDetail(requestNo)
      } catch {
        return getModuleRequest({ module: 'leave', entity: 'leave' }, selectedRequestId!)
      }
    },
    enabled: Boolean(selectedRequestId),
  })
  const [leaveType, setLeaveType] = useState('')
  const [entitlement, setEntitlement] = useState<number | null>(null)
  const [balance, setBalance] = useState<number | null>(null)
  const [earnedLeaveDays, setEarnedLeaveDays] = useState<number | null>(null)
  const [applicationLimit, setApplicationLimit] = useState<number | null>(null)
  const [isHourly, setIsHourly] = useState(false)
  const [pendingDuplicate, setPendingDuplicate] = useState(false)
  const [balanceLoading, setBalanceLoading] = useState(false)
  const [types, setTypes] = useState<LeaveType[]>([])
  const [relievers, setRelievers] = useState<Array<{ value: string; label: string }>>([])
  const [submittingForm, setSubmittingForm] = useState(false)
  const [submitPhase, setSubmitPhase] = useState<'idle' | 'creating' | 'uploading' | 'approval'>('idle')
  const availableTypes = types

  useEffect(() => {
    fetchLeaveTypes()
      .then(setTypes)
      .catch(() => setTypes([]))
    fetchRelievers()
      .then(setRelievers)
      .catch(() => setRelievers([]))
  }, [])

  const [appliedDays, setAppliedDays] = useState('')
  const [appliedHours, setAppliedHours] = useState('')
  const [halfDay, setHalfDay] = useState<HalfDayValue>('0')
  const [startDate, setStartDate] = useState('')
  const [startDateTime, setStartDateTime] = useState('')
  const [endDate, setEndDate] = useState('')
  const [returnDate, setReturnDate] = useState('')
  const [datesLoading, setDatesLoading] = useState(false)
  const [reliever, setReliever] = useState('')
  const [reason, setReason] = useState('')
  const [error, setError] = useState<string | null>(null)
  const [success, setSuccess] = useState<string | null>(null)

  const duplicatePendingBlocked = env.BLOCK_DUPLICATE_PENDING_LEAVE && pendingDuplicate
  const showSecondary = leaveType !== '' && balance !== null && !duplicatePendingBlocked && !balanceLoading
  const canSubmit = showSecondary && applicationLimit !== null && applicationLimit > 0

  useEffect(() => {
    setEndDate('')
    setReturnDate('')
    setAppliedDays('')
    setAppliedHours('')
    setStartDate('')
    setStartDateTime('')
    setHalfDay('0')
    setError(null)
    setSuccess(null)
    if (!leaveType) {
      setEntitlement(null)
      setBalance(null)
      setEarnedLeaveDays(null)
      setApplicationLimit(null)
      return
    }
    const type = types.find((t) => t.code === leaveType)
    setEntitlement(type?.days ?? null)
    setEarnedLeaveDays(null)
    setApplicationLimit(null)
    setBalanceLoading(true)
    getLeaveBalance(leaveType)
      .then((res) => {
        setBalance(res.balance)
        setEntitlement(res.entitlement ?? type?.days ?? null)
        setEarnedLeaveDays(res.earnedLeaveDays ?? null)
        setApplicationLimit(res.applicationLimit ?? res.balance)
        setIsHourly(res.isHourly)
        setPendingDuplicate(res.pendingCount > 0)
        if (env.BLOCK_DUPLICATE_PENDING_LEAVE && res.pendingCount > 0) {
          setError(
            'You cannot apply a new leave while there is another one of the same type that is pending approval.',
          )
        }
      })
      .finally(() => setBalanceLoading(false))
  }, [leaveType])

  const leaveDatesRequestId = useRef(0)

  useEffect(() => {
    setEndDate('')
    setReturnDate('')

    const duration = isHourly
      ? Number(appliedHours)
      : halfDay !== '0'
        ? 0.5
        : Number(appliedDays)
    const starting = isHourly ? startDateTime : startDate
    if (!duration || !starting || !leaveType) return

    if (entitlement !== null && duration > entitlement) {
      setError(`The maximum number of days you can apply for is ${entitlement}`)
      return
    }
    if (isHourly && duration > 4) {
      setError('Oops! you cannot apply more than 4 hours on half-day leave.')
      return
    }

    const dateOnly = isHourly ? starting.slice(0, 10) : starting
    const requestId = ++leaveDatesRequestId.current
    setError(null)
    setDatesLoading(true)
    getLeaveDates(leaveType, duration, dateOnly, halfDay)
      .then((res) => {
        if (requestId !== leaveDatesRequestId.current) return
        if (res.isWeekend) {
          setError('Leave start date cannot be on a weekend')
          if (isHourly) setStartDateTime('')
          else setStartDate('')
          return
        }
        setEndDate(res.endDate)
        setReturnDate(res.returnDate)
      })
      .catch((err: unknown) => {
        if (requestId !== leaveDatesRequestId.current) return
        const message =
          err instanceof AuthApiError
            ? err.message
            : 'Could not calculate leave dates. Check start date and applied days.'
        setError(message)
      })
      .finally(() => {
        if (requestId === leaveDatesRequestId.current) setDatesLoading(false)
      })
  }, [appliedDays, appliedHours, startDate, startDateTime, halfDay, leaveType, isHourly, entitlement])

  useEffect(() => {
    if (halfDay === '1' || halfDay === '2') {
      setAppliedDays('0.5')
    }
  }, [halfDay])

  const resetForm = () => {
    setLeaveType('')
    setAppliedDays('')
    setAppliedHours('')
    setHalfDay('0')
    setStartDate('')
    setStartDateTime('')
    setEndDate('')
    setReturnDate('')
    setReliever('')
    setReason('')
    setCreationAttachments([])
    setCreationAttachmentStates({})
    setError(null)
    setSuccess(null)
  }

  const leaveColumns: DataTableColumn<LeaveListRow>[] = [
    { id: 'code', header: 'Application No.', cell: (row) => row.ApplicationCode },
    { id: 'type', header: 'Leave Type', cell: (row) => row.LeaveType },
    { id: 'days', header: 'Days', cell: (row) => row.DaysApplied ?? '—' },
    { id: 'start', header: 'Start', cell: (row) => row.StartDate ?? '—' },
    { id: 'status', header: 'Status', cell: (row) => <StatusBadge status={row.Status} /> },
  ]

  const handleSubmit = async (event: React.FormEvent) => {
    event.preventDefault()
    const submittedStartDate = isHourly ? startDateTime.slice(0, 10) : startDate
    const submittedDays = isHourly
      ? Number(appliedHours || 0)
      : halfDay !== '0'
        ? 0.5
        : Number(appliedDays || 0)
    if (!leaveType || !reason.trim() || !endDate || !submittedStartDate || !submittedDays) {
      setError('Please complete all required fields.')
      return
    }
    if (leaveType === 'SICK' && creationAttachments.length === 0) {
      setError('A supporting attachment is required for sick leave.')
      return
    }
    if (creationAttachments.some((file) => file.size > 10_000_000)) {
      setError('Leave attachments cannot exceed 10 MB each.')
      return
    }
    if (applicationLimit !== null && submittedDays > applicationLimit) {
      setError(`Business Central allows up to ${formatDays(applicationLimit)} day(s) for this application.`)
      return
    }
    const confirmed = await confirm({
      title: 'Create leave application',
      message:
        creationAttachments.length > 0
          ? 'Create this leave application and upload the selected file(s)? You can then request approval below.'
          : 'Create this leave application as a draft? You can then request approval below.',
      confirmLabel: 'Create application',
    })
    if (!confirmed) return
    setSubmittingForm(true)
    setSubmitPhase('creating')
    setCreationAttachmentStates({})
    const hasAttachments = creationAttachments.length > 0
    const progressId = progress.show({
      title: 'Creating leave application…',
      message: 'Saving your request — please wait.',
      blocking: true,
    })
    try {
      // Step 1 — always create the draft first. Approval is a separate, explicit step.
      const result = await submitLeaveRequest({
        leaveType,
        appliedDays: submittedDays,
        startDate: submittedStartDate,
        isHalfDayLeave: halfDay,
        reliever,
        reason,
        requestApproval: false,
      })
      if (result.ok) {
        const documentNo = resolveCreatedLeaveDocumentNo(result)
        const createdRequestId = documentNo
          ? `leave-${documentNo}`
          : resolveCreatedLeaveRequestId(result)
        let attachmentError = ''
        const finalStatus = result.request?.status ?? 'Open'

        // Step 2 — upload selected attachments onto the freshly created draft (BC needs the document no first).
        if (hasAttachments) {
          try {
            if (!documentNo) {
              throw new Error('The document number was not returned. Refresh the list and open the latest application.')
            }
            setSubmitPhase('uploading')
            progress.update(progressId, {
              title: 'Uploading attachments…',
              message: 'Sending your files — please wait.',
            })
            await uploadLeaveAttachments(documentNo, creationAttachments, (fileId, state) => {
              setCreationAttachmentStates((current) => ({ ...current, [fileId]: state }))
            })
          } catch (err: unknown) {
            attachmentError = err instanceof Error ? err.message : 'Attachment upload failed.'
          }
        }

        await queryClient.invalidateQueries({ queryKey: ['dashboard'] })
        await queryClient.invalidateQueries({ queryKey: ['hr', 'leave-list'] })
        await queryClient.invalidateQueries({ queryKey: ['hr', 'leave-schedule'] })

        if (createdRequestId && documentNo) {
          setSelectedRequestId(createdRequestId)
          let detail: PortalRequest | null = null
          for (let attempt = 0; attempt < 4; attempt += 1) {
            try {
              detail = await fetchLeaveRequestDetail(documentNo)
              break
            } catch {
              if (attempt < 3) {
                await new Promise((resolve) => setTimeout(resolve, 500 * (attempt + 1)))
              }
            }
          }
          if (detail) {
            queryClient.setQueryData(['hr', 'leave-detail', createdRequestId], {
              ...detail,
              status: finalStatus,
            })
          }
        }

        setSuccess(
          attachmentError
            ? 'Leave application created, but the attachment could not be uploaded. Open it below, retry the upload, then click Request Approval.'
            : documentNo
              ? hasAttachments
                ? 'Leave application created and attachment uploaded. Review it below, then click Request Approval.'
                : 'Leave application created as a draft. Review it below, then click Request Approval.'
              : result.message,
        )
        setError(null)
        toast.success(
          attachmentError
            ? 'Leave created, but attachment upload failed.'
            : documentNo
              ? 'Leave application created. Click Request Approval below.'
              : result.message ?? 'Leave application processed.',
        )
        if (attachmentError) toast.error(attachmentError, 'Attachment not uploaded')
      } else {
        setError(result.message ?? 'Submission failed.')
        toast.error(result.message ?? 'Submission failed.', 'Leave not submitted')
      }
    } catch (err: unknown) {
      setError(err instanceof Error ? err.message : 'Submission failed.')
      toast.error(err instanceof Error ? err.message : 'Submission failed.', 'Leave not submitted')
    } finally {
      progress.hide(progressId)
      setSubmittingForm(false)
      setSubmitPhase('idle')
    }
  }

  const refreshLeave = async () => {
    await queryClient.invalidateQueries({ queryKey: ['hr', 'leave-list'] })
    await queryClient.invalidateQueries({ queryKey: ['dashboard'] })
    if (selectedRequestId) await detailQuery.refetch()
  }

  const cancelSelectedLeave = async () => {
    const selected = detailQuery.data
    if (!selected) return
    const confirmed = await confirm({
      title: 'Cancel leave application',
      message: `Cancel leave application ${selected.requestNo}?`,
      confirmLabel: 'Cancel application',
      tone: 'danger',
    })
    if (!confirmed) return
    setDetailAction('cancel')
    const progressId = progress.show({
      title: 'Cancelling leave…',
      message: 'Updating your request — please wait.',
      blocking: true,
    })
    try {
      const result = await cancelLeaveRequest(selected.requestNo)
      if (!result.ok) throw new Error(result.message || 'Leave cancellation failed')
      await refreshLeave()
      toast.success(result.message || 'Leave application cancelled')
    } catch (err: unknown) {
      toast.error(err instanceof Error ? err.message : 'Leave cancellation failed', 'Cancel failed')
    } finally {
      progress.hide(progressId)
      setDetailAction(null)
    }
  }

  const requestSelectedLeaveApproval = async () => {
    const selected = detailQuery.data
    if (!selected) return
    const confirmed = await confirm({
      title: 'Request leave approval',
      message: `Send leave application ${selected.requestNo} for approval?`,
      confirmLabel: 'Request approval',
    })
    if (!confirmed) return
    setDetailAction('approval')
    const progressId = progress.show({
      title: 'Sending for approval…',
      message: 'Submitting your request — please wait.',
      blocking: true,
    })
    try {
      const result = await requestLeaveApproval(selected.requestNo)
      if (!result.ok) throw new Error(result.message || 'Approval request failed')
      const confirmed =
        result.confirmedInBc ?? ['Pending Approval', 'Approved'].includes(result.status ?? '')
      if (!confirmed && result.diagnostic) {
        // Ground-truth from BC so we can tell a workflow issue (senderAll=0)
        // apart from a detection issue (senderAll>0 but no match for this leave).
        console.warn(
          `[leave-approval] ${selected.requestNo}: BC returned "${result.diagnostic.soapReturnValue}" ` +
            `but no pending entry detected. senderAll=${result.diagnostic.senderAll} ` +
            `byDoc=${result.diagnostic.byDoc} senderMatches=${result.diagnostic.senderMatches} ` +
            `headerStatus="${result.diagnostic.headerStatus}"`,
          result.diagnostic.senderDocs,
        )
      }
      const nextStatus =
        confirmed && result.status && result.status !== 'Open'
          ? result.status
          : confirmed
            ? 'Pending Approval'
            : selected.status
      const nextApprovalSteps =
        result.approvalSteps && result.approvalSteps.length > 0
          ? result.approvalSteps
          : selected.approvalSteps.length > 0
            ? selected.approvalSteps
            : confirmed
              ? [
                  {
                    id: 'pending-approval',
                    actorName: 'Awaiting approver assignment',
                    role: 'Approver',
                    status: 'Pending Approval',
                    timestamp: new Date().toISOString(),
                    sequenceNo: 1,
                  },
                ]
              : selected.approvalSteps
      queryClient.setQueryData(['hr', 'leave-detail', selected.id], {
        ...selected,
        status: nextStatus,
        approvalSteps: nextApprovalSteps,
      })
      if (confirmed) {
        queryClient.setQueryData<LeaveListRow[]>(['hr', 'leave-list'], (rows) =>
          (rows ?? []).map((row) =>
            row.ApplicationCode === selected.requestNo ? { ...row, Status: nextStatus } : row,
          ),
        )
      }
      toast.success(result.message || 'Leave application sent for approval')
      if (!confirmed) {
        void syncLeaveStatusFromBc(selected.requestNo, selected.id, queryClient)
      }
      try {
        const detail = await fetchLeaveRequestDetail(selected.requestNo)
        const mergedApprovalSteps =
          detail.approvalSteps.length > 0
            ? detail.approvalSteps.map((step, index) => {
                const previous = nextApprovalSteps[index]
                if (
                  previous &&
                  previous.actorName &&
                  previous.actorName !== 'Awaiting approver assignment' &&
                  (!step.actorName ||
                    step.actorName === 'Awaiting approver assignment' ||
                    step.actorName === step.actorEmployeeNo)
                ) {
                  return {
                    ...step,
                    actorName: previous.actorName,
                    actorEmployeeNo: step.actorEmployeeNo || ('actorEmployeeNo' in previous ? previous.actorEmployeeNo : undefined),
                  }
                }
                return step
              })
            : nextApprovalSteps
        const detailStatus = ['Pending Approval', 'Approved'].includes(detail.status)
          ? detail.status
          : nextStatus
        queryClient.setQueryData(['hr', 'leave-detail', selected.id], {
          ...detail,
          status: detailStatus,
          approvalSteps: mergedApprovalSteps,
          approverName:
            detail.approverName ||
            mergedApprovalSteps[0]?.actorName ||
            selected.approverName ||
            '',
        })
        if (['Pending Approval', 'Approved'].includes(detail.status)) {
          queryClient.setQueryData<LeaveListRow[]>(['hr', 'leave-list'], (rows) =>
            (rows ?? []).map((row) =>
              row.ApplicationCode === selected.requestNo ? { ...row, Status: detail.status } : row,
            ),
          )
        }
      } catch {
        // keep cached state when detail refresh fails
      }
      void queryClient.invalidateQueries({ queryKey: ['hr', 'leave-list'] })
    } catch (err: unknown) {
      toast.error(err instanceof Error ? err.message : 'Approval request failed', 'Approval not requested')
    } finally {
      progress.hide(progressId)
      setDetailAction(null)
    }
  }

  const selected = detailQuery.data
  const selectedPayload = selected?.payload ?? {}
  const detailApprovalSteps = selected?.approvalSteps ?? []
  const selectedIsMutable = selected
    ? ['Open', 'Draft', 'Pending Approval'].includes(selected.status)
    : false
  const selectedCanRequestApproval = selected
    ? ['Open', 'Draft'].includes(selected.status) &&
      !selected.approvalSteps.some((step) =>
        ['Pending Approval', 'Submitted', 'Approved'].includes(step.status),
      )
    : false

  return (
    <PageWrapper
      title="Leave Requisition"
      showPageHeading={false}
      actions={<PortalNewButton label="New Request" onClick={resetForm} />}
    >
      <form
        onSubmit={handleSubmit}
        className="portal-form-card portal-form-card--select-overflow animate-page-in w-full"
      >
        <div className="portal-form-card-header relative px-4 py-3 text-center text-sm font-semibold tracking-wide text-white sm:text-base">
          New Leave Request
        </div>

        <div className="space-y-4 p-4 sm:p-6">
          {error ? (
            <div className="rounded border-l-4 border-red-500 bg-red-50 px-3 py-2 text-sm text-red-700">{error}</div>
          ) : null}
          {success ? (
            <div className="rounded border-l-4 border-emerald-500 bg-emerald-50 px-3 py-2 text-sm text-emerald-700">
              {success}
            </div>
          ) : null}

          <div className="grid gap-3 sm:grid-cols-2 sm:gap-4 lg:grid-cols-4">
            <div className="space-y-1.5">
              <Label htmlFor="leaveType">Leave Type</Label>
              <Select
                id="leaveType"
                value={leaveType}
                onChange={(e) => setLeaveType(e.target.value)}
                placeholder="--select--"
                options={availableTypes.map((t) => ({
                  value: t.code,
                  label: `${t.description} (Entitlement: ${formatDays(t.days)})`,
                }))}
              />
            </div>
            <div className="space-y-1.5">
              <Label>Leave Entitlement</Label>
              <p className="flex h-10 items-center text-sm font-semibold text-slate-700">
                {entitlement !== null ? `${formatDays(entitlement)} days` : DASH}
              </p>
            </div>
            <div className="space-y-1.5">
              <Label>Employee Card Balance</Label>
              <div className="flex h-10 items-center">
                {balanceLoading ? (
                  <Skeleton className="h-6 w-16" />
                ) : balance !== null ? (
                  <Badge variant="green" className="px-4 py-1 text-sm">
                    {formatDays(balance)}
                  </Badge>
                ) : (
                  <span className="text-sm text-slate-400">{DASH}</span>
                )}
              </div>
            </div>
            <div className="space-y-1.5">
              <Label>Earned Leave Days</Label>
              <p className="flex h-10 items-center text-sm font-semibold text-slate-700">
                {earnedLeaveDays !== null ? formatDays(earnedLeaveDays) : DASH}
              </p>
            </div>
          </div>

          {showSecondary ? (
            <div className="space-y-4 border-t border-slate-200 pt-4">
              {applicationLimit !== null && applicationLimit <= 0 ? (
                <div className="rounded border-l-4 border-amber-500 bg-amber-50 px-3 py-2 text-sm text-amber-800">
                  Business Central currently allows no days for this leave type. The Employee Card balance and earned leave are shown above for reference.
                </div>
              ) : earnedLeaveDays !== null && applicationLimit !== null && applicationLimit < balance ? (
                <div className="rounded border-l-4 border-sky-500 bg-sky-50 px-3 py-2 text-sm text-sky-800">
                  BC application limit: {formatDays(applicationLimit)} day(s), based on the lower of Employee Card Balance and Earned Leave Days.
                </div>
              ) : null}
              <div className="grid gap-3 sm:grid-cols-3 sm:gap-4">
                {!isHourly ? (
                  <div className="space-y-1.5">
                    <Label htmlFor="appliedDays">Applied Days</Label>
                    <Input
                      id="appliedDays"
                      type="number"
                      step="0.5"
                      min="0.5"
                      value={appliedDays}
                      onChange={(e) => setAppliedDays(e.target.value)}
                      disabled={halfDay !== '0'}
                    />
                  </div>
                ) : (
                  <div className="space-y-1.5">
                    <Label htmlFor="appliedHours">Applied Hours</Label>
                    <Input
                      id="appliedHours"
                      type="number"
                      step="0.5"
                      min="0.5"
                      max="4"
                      value={appliedHours}
                      onChange={(e) => setAppliedHours(e.target.value)}
                    />
                  </div>
                )}

                <div className="space-y-1.5">
                  <Label htmlFor="halfDay">Select Whether Half Day</Label>
                  <Select
                    id="halfDay"
                    value={halfDay}
                    onChange={(e) => setHalfDay(e.target.value as HalfDayValue)}
                    options={halfDayOptions.map((o) => ({ value: o.value, label: o.label }))}
                  />
                </div>

                {!isHourly ? (
                  <div className="space-y-1.5">
                    <Label htmlFor="startDate">Start Date</Label>
                    <Input
                      id="startDate"
                      type="date"
                      value={startDate}
                      onChange={(e) => setStartDate(e.target.value)}
                    />
                  </div>
                ) : (
                  <div className="space-y-1.5">
                    <Label htmlFor="startDateTime">Start Date Time</Label>
                    <Input
                      id="startDateTime"
                      type="datetime-local"
                      value={startDateTime}
                      onChange={(e) => setStartDateTime(e.target.value)}
                    />
                  </div>
                )}
              </div>

              <div className="grid gap-3 sm:grid-cols-3 sm:gap-4">
                <div className="space-y-1.5">
                  <Label>Applied Days</Label>
                  <p className="flex h-10 items-center text-sm font-semibold text-slate-700">
                    {appliedDays || appliedHours || DASH}
                  </p>
                </div>
                <div className="space-y-1.5">
                  <Label>End Date</Label>
                  <p className="flex h-10 items-center text-sm font-semibold text-slate-700">
                    {datesLoading ? <Skeleton className="h-5 w-32" /> : endDate ? formatPretty(endDate) : DASH}
                  </p>
                </div>
                <div className="space-y-1.5">
                  <Label>Return Date</Label>
                  <p className="flex h-10 items-center text-sm font-semibold text-slate-700">
                    {datesLoading ? <Skeleton className="h-5 w-32" /> : returnDate ? formatPretty(returnDate) : DASH}
                  </p>
                </div>
                <div className="space-y-1.5">
                  <Label htmlFor="reliever">Reliever</Label>
                  <Select
                    id="reliever"
                    value={reliever}
                    onChange={(e) => setReliever(e.target.value)}
                    placeholder="select"
                    options={relievers}
                  />
                </div>
              </div>

              <div className="space-y-1.5">
                <Label htmlFor="reason">Leave Reason</Label>
                <Textarea
                  id="reason"
                  rows={5}
                  value={reason}
                  onChange={(e) => setReason(e.target.value)}
                  required
                />
              </div>

              <div className="space-y-3 rounded-xl border-l-4 border-orange-500 bg-orange-50 p-4 text-sm text-orange-900">
                <div className="flex flex-wrap items-center justify-between gap-2">
                  <p className="font-bold">
                    Leave Attachments{leaveType === 'SICK' ? ' (Required)' : ' (Optional)'}
                  </p>
                  {creationAttachments.length > 0 ? (
                    <span className="rounded-full bg-white px-2.5 py-0.5 text-xs font-semibold text-orange-700">
                      {creationAttachments.length} file{creationAttachments.length === 1 ? '' : 's'} selected
                    </span>
                  ) : null}
                </div>
                <p className="text-xs text-orange-800/90">
                  {creationAttachments.length > 0
                    ? 'Selected files are listed below. They upload to Business Central right after the draft is created. You then click Request Approval below.'
                    : 'Choose your files first — they appear here immediately, then upload automatically once the draft is created.'}
                </p>
                <FileUpload
                  files={creationAttachments}
                  onChange={(files) => {
                    setCreationAttachments(files)
                    setCreationAttachmentStates({})
                  }}
                  hideHeader
                  hideEmptyState
                  compactWhenHasFiles
                  fileStates={creationAttachmentStates}
                  emptyHint="No files selected yet. Choose PDF, DOC, DOCX, JPG, or PNG up to 10 MB each."
                />
                {submitPhase === 'uploading' ? (
                  <p className="rounded-lg border border-emerald-200 bg-emerald-50 px-3 py-2 text-xs font-medium text-emerald-800">
                    Uploading selected file(s) to the leave draft…
                  </p>
                ) : null}
                <p className="text-xs text-orange-800/90">Maximum 10 MB per file for leave attachments.</p>
              </div>

              <div className="flex justify-center pt-2">
                <Button
                  type="submit"
                  variant="accent"
                  className="min-w-[180px] rounded-full"
                  disabled={submittingForm || !canSubmit}
                >
                  {submitPhase === 'creating'
                    ? 'Creating draft…'
                    : submitPhase === 'uploading'
                      ? 'Uploading attachments…'
                      : submittingForm
                        ? 'Saving…'
                        : 'Create Leave Application'}
                </Button>
              </div>
            </div>
          ) : null}
        </div>
      </form>

      <div className="mt-6">
        <h2 className="portal-page-title mb-3 text-base font-semibold">My Leave Applications</h2>
        <DataTable
          rows={leaveListQuery.data ?? []}
          columns={leaveColumns}
          getRowId={(row) => row.ApplicationCode}
          selectedRowId={selected?.requestNo}
          onRowClick={(row) => {
            setSelectedRequestId(`leave-${row.ApplicationCode}`)
          }}
          compact
          emptyTitle="No leave applications yet."
        />
      </div>

      {selectedRequestId ? (
        <div className="portal-form-card mt-6 overflow-hidden">
          <div className="portal-form-card-header flex items-center justify-between gap-3 px-4 py-3 text-white">
            <h2 className="font-semibold">Leave Application Details</h2>
            <Button
              type="button"
              variant="outline"
              size="sm"
              onClick={() => {
                setSelectedRequestId(null)
              }}
            >
              Close
            </Button>
          </div>
          <div className="space-y-5 p-4 sm:p-6">
            {detailQuery.isLoading ? (
              <Skeleton className="h-40 w-full" />
            ) : detailQuery.isError || !selected ? (
              <p className="rounded border-l-4 border-red-500 bg-red-50 p-3 text-sm text-red-700">
                Could not load this leave application.
              </p>
            ) : (
              <>
                <RequestProgress status={selected.status} />
                <div className="flex flex-wrap items-center justify-between gap-3">
                  <div>
                    <p className="text-xs text-slate-500">Application No.</p>
                    <p className="font-semibold text-slate-900">{selected.requestNo}</p>
                  </div>
                  <StatusBadge status={selected.status} />
                </div>

                <dl className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
                  <div>
                    <dt className="text-xs text-slate-500">Leave Type</dt>
                    <dd className="text-sm font-medium">
                      {payloadValue(selectedPayload, ['LeaveType', 'Leave_Type', 'leaveTypeDescription', 'leaveType'])}
                    </dd>
                  </div>
                  <div>
                    <dt className="text-xs text-slate-500">Days Applied</dt>
                    <dd className="text-sm font-medium">
                      {payloadValue(selectedPayload, ['DaysApplied', 'Days_Applied', 'appliedDays'])}
                    </dd>
                  </div>
                  <div>
                    <dt className="text-xs text-slate-500">Start Date</dt>
                    <dd className="text-sm font-medium">
                      {payloadValue(selectedPayload, ['StartDate', 'Start_Date', 'startDate'])}
                    </dd>
                  </div>
                  <div>
                    <dt className="text-xs text-slate-500">End Date</dt>
                    <dd className="text-sm font-medium">
                      {payloadValue(selectedPayload, ['EndDate', 'End_Date', 'endDate'])}
                    </dd>
                  </div>
                  <div>
                    <dt className="text-xs text-slate-500">Return Date</dt>
                    <dd className="text-sm font-medium">
                      {payloadValue(selectedPayload, ['ReturnDate', 'Return_Date', 'returnDate'])}
                    </dd>
                  </div>
                  <div>
                    <dt className="text-xs text-slate-500">Reliever</dt>
                    <dd className="text-sm font-medium">
                      {payloadValue(selectedPayload, ['RelieverName', 'Reliever_Name', 'Reliever'])}
                    </dd>
                  </div>
                  <div>
                    <dt className="text-xs text-slate-500">Reason</dt>
                    <dd className="text-sm font-medium">
                      {payloadValue(selectedPayload, ['Reason', 'reason'])}
                    </dd>
                  </div>
                </dl>

                {detailApprovalSteps.length > 0 ? (
                  <section>
                    <h3 className="mb-3 text-sm font-semibold text-slate-900">Approval workflow</h3>
                    <ApprovalTimeline steps={detailApprovalSteps} />
                  </section>
                ) : null}

                <RequestAttachments
                  requestId={selected.id}
                  attachments={selected.attachments}
                  canUpload={canUploadRequestAttachments(selected.status)}
                  canDelete={canDeleteRequestItems(selected.status)}
                  onUpdated={async (request) => {
                    queryClient.setQueryData(['hr', 'leave-detail', selected.id], request)
                    try {
                      const detail = await fetchLeaveRequestDetail(selected.requestNo)
                      queryClient.setQueryData(['hr', 'leave-detail', selected.id], detail)
                    } catch {
                      // keep portal request payload when staff detail refresh fails
                    }
                    void refreshLeave()
                  }}
                />

                {selectedIsMutable ? (
                  <div className="flex flex-wrap justify-end gap-2 border-t border-slate-200 pt-4">
                    {selectedCanRequestApproval ? (
                      <Button
                        type="button"
                        disabled={detailAction === 'approval'}
                        onClick={() => void requestSelectedLeaveApproval()}
                      >
                        {detailAction === 'approval' ? 'Requesting…' : 'Request Approval'}
                      </Button>
                    ) : null}
                    <Button
                      type="button"
                      variant="destructive"
                      disabled={detailAction === 'cancel'}
                      onClick={() => void cancelSelectedLeave()}
                    >
                      {detailAction === 'cancel'
                        ? 'Cancelling…'
                        : selectedCanRequestApproval
                          ? 'Discard Application'
                          : 'Cancel Application'}
                    </Button>
                  </div>
                ) : null}
              </>
            )}
          </div>
        </div>
      ) : null}
    </PageWrapper>
  )
}
