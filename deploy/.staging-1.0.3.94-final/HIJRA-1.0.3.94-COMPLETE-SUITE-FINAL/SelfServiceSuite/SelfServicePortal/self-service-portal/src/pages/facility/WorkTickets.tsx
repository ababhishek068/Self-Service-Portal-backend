import { zodResolver } from '@hookform/resolvers/zod'
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { ArrowLeft, CheckCircle2, Plus, Send, Trash2, XCircle } from 'lucide-react'
import { useState } from 'react'
import { useForm, type Resolver } from 'react-hook-form'
import {
  addWorkTicketLine,
  cancelWorkTicketApproval,
  confirmWorkTicketBooking,
  createWorkTicket,
  deleteWorkTicketLine,
  getWorkTicket,
  listWorkTickets,
  submitWorkTicket,
  type WorkTicketLine,
  type WorkTicketRow,
} from '@/api/endpoints/workTickets'
import { useConfirm } from '@/components/feedback/ConfirmProvider'
import { useToast } from '@/components/feedback/ToastProvider'
import { PageWrapper } from '@/components/layout/PageWrapper'
import { DataTable, type DataTableColumn } from '@/components/shared/DataTable'
import { PortalNewButton } from '@/components/shared/PortalNewButton'
import { StatusBadge } from '@/components/shared/StatusBadge'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Select } from '@/components/ui/select'
import { useLookupOptions } from '@/hooks/useLookupOptions'
import {
  workTicketHeaderSchema,
  workTicketLineSchema,
  type WorkTicketHeaderForm,
  type WorkTicketLineForm,
} from '@/schemas/requestSchemas'

const columns: DataTableColumn<WorkTicketRow>[] = [
  { id: 'ticketNo', header: 'Ticket No.', cell: (row) => row.ticketNo },
  { id: 'previous', header: 'Previous Ticket No.', cell: (row) => row.previousTicketNo },
  { id: 'gkNo', header: 'GK No.', cell: (row) => row.gkNo },
  { id: 'traveler', header: 'Traveler', cell: (row) => row.travelerName || row.travelerEmployeeNo },
  { id: 'route', header: 'Flight Route', cell: (row) => [row.flightFrom, row.flightTo].filter(Boolean).join(' → ') },
  { id: 'departure', header: 'Departure', cell: (row) => row.departureDate },
  { id: 'department', header: 'Department', cell: (row) => row.department },
  { id: 'status', header: 'Status', cell: (row) => <StatusBadge status={row.bookingConfirmed ? 'Booking Confirmed' : row.status} /> },
]

export function WorkTickets() {
  const [selectedNo, setSelectedNo] = useState('')
  const [mode, setMode] = useState<'list' | 'create'>('list')
  const [showLineForm, setShowLineForm] = useState(false)
  const [confirmationNo, setConfirmationNo] = useState('')
  const queryClient = useQueryClient()
  const confirm = useConfirm()
  const toast = useToast()
  const employees = useLookupOptions('employees')

  const query = useQuery({ queryKey: ['facility', 'work-tickets'], queryFn: listWorkTickets })
  const detailQuery = useQuery({
    queryKey: ['facility', 'work-tickets', selectedNo],
    queryFn: () => getWorkTicket(selectedNo),
    enabled: Boolean(selectedNo),
  })

  const headerForm = useForm<WorkTicketHeaderForm>({
    resolver: zodResolver(workTicketHeaderSchema) as Resolver<WorkTicketHeaderForm>,
    defaultValues: {
      previousTicketNo: '',
      gkNo: '',
      type: 'Flight Booking',
      travelerEmployeeNo: '',
      flightFrom: '',
      flightTo: '',
      departureDate: '',
      returnDate: '',
      ticketClass: '1',
      airlinePreference: '',
      justification: '',
    },
  })

  const lineForm = useForm<WorkTicketLineForm>({
    resolver: zodResolver(workTicketLineSchema) as Resolver<WorkTicketLineForm>,
    defaultValues: {
      driverName: '',
      departureFrom: '',
      destination: '',
      workDate: '',
      authorizingOfficer: '',
    },
  })

  const createMutation = useMutation({
    mutationFn: createWorkTicket,
    onSuccess: async (ticket) => {
      await queryClient.invalidateQueries({ queryKey: ['facility', 'work-tickets'] })
      toast.success('Work ticket created')
      setMode('list')
      setSelectedNo(ticket.ticketNo)
      headerForm.reset()
    },
    onError: (error) =>
      toast.error(error instanceof Error ? error.message : 'Could not create work ticket', 'Save failed'),
  })

  const addLineMutation = useMutation({
    mutationFn: (values: WorkTicketLineForm) => addWorkTicketLine(selectedNo, values),
    onSuccess: async () => {
      await queryClient.invalidateQueries({ queryKey: ['facility', 'work-tickets', selectedNo] })
      toast.success('Work ticket line added')
      lineForm.reset()
      setShowLineForm(false)
    },
    onError: (error) =>
      toast.error(error instanceof Error ? error.message : 'Could not add line', 'Save failed'),
  })

  const deleteMutation = useMutation({
    mutationFn: (lineNo: string) => deleteWorkTicketLine(selectedNo, lineNo),
    onSuccess: async () => {
      await queryClient.invalidateQueries({ queryKey: ['facility', 'work-tickets', selectedNo] })
      toast.success('Work-ticket line deleted')
    },
    onError: (error) =>
      toast.error(error instanceof Error ? error.message : 'Could not delete the line', 'Delete failed'),
  })

  const confirmationMutation = useMutation({
    mutationFn: () => confirmWorkTicketBooking(selectedNo, confirmationNo),
    onSuccess: async () => {
      await Promise.all([
        queryClient.invalidateQueries({ queryKey: ['facility', 'work-tickets'] }),
        queryClient.invalidateQueries({ queryKey: ['facility', 'work-tickets', selectedNo] }),
      ])
      toast.success('Flight booking confirmation saved')
      setConfirmationNo('')
    },
    onError: (error) =>
      toast.error(error instanceof Error ? error.message : 'Could not confirm the booking', 'Confirmation failed'),
  })

  const approvalMutation = useMutation({
    mutationFn: (action: 'submit' | 'cancel') =>
      action === 'submit' ? submitWorkTicket(selectedNo) : cancelWorkTicketApproval(selectedNo),
    onSuccess: async (_result, action) => {
      await Promise.all([
        queryClient.invalidateQueries({ queryKey: ['facility', 'work-tickets'] }),
        queryClient.invalidateQueries({ queryKey: ['facility', 'work-tickets', selectedNo] }),
      ])
      toast.success(action === 'submit' ? 'Work ticket submitted for approval' : 'Approval request cancelled')
    },
    onError: (error) =>
      toast.error(error instanceof Error ? error.message : 'Approval action failed', 'Approval failed'),
  })

  const removeLine = async (line: WorkTicketLine) => {
    const yes = await confirm({
      title: 'Delete work-ticket line',
      message: 'Are you sure you want to delete this line?',
      confirmLabel: 'Delete',
      tone: 'danger',
    })
    if (yes) deleteMutation.mutate(line.lineNo)
  }

  if (mode === 'create') {
    return (
      <PageWrapper title="New Work Ticket">
        <Button type="button" variant="ghost" onClick={() => setMode('list')}>
          <ArrowLeft className="h-4 w-4" />
          Back to tickets
        </Button>
        <form
          className="portal-card mt-4 grid max-w-4xl gap-4 p-4 md:grid-cols-2"
          onSubmit={(event) => {
            event.preventDefault()
            void headerForm.handleSubmit((values) => createMutation.mutate(values))()
          }}
        >
          <div className="space-y-1.5">
            <Label htmlFor="previousTicketNo">Previous Ticket No. (optional)</Label>
            <Input id="previousTicketNo" {...headerForm.register('previousTicketNo')} />
          </div>
          <div className="space-y-1.5">
            <Label htmlFor="gkNo">GK No. (optional)</Label>
            <Input id="gkNo" {...headerForm.register('gkNo')} />
          </div>
          <input type="hidden" {...headerForm.register('type')} />
          <div className="space-y-1.5">
            <Label htmlFor="travelerEmployeeNo">Traveler</Label>
            <Select
              id="travelerEmployeeNo"
              required
              placeholder="Select employee"
              options={employees.options}
              {...headerForm.register('travelerEmployeeNo')}
            />
            {headerForm.formState.errors.travelerEmployeeNo ? (
              <p className="text-xs font-medium text-red-600">{headerForm.formState.errors.travelerEmployeeNo.message}</p>
            ) : null}
          </div>
          <div className="space-y-1.5">
            <Label htmlFor="ticketClass">Ticket Class</Label>
            <Select
              id="ticketClass"
              required
              options={[
                { label: 'Economy', value: '1' },
                { label: 'Business', value: '2' },
              ]}
              {...headerForm.register('ticketClass')}
            />
          </div>
          <div className="space-y-1.5">
            <Label htmlFor="flightFrom">Flight From</Label>
            <Input id="flightFrom" required {...headerForm.register('flightFrom')} />
          </div>
          <div className="space-y-1.5">
            <Label htmlFor="flightTo">Flight To</Label>
            <Input id="flightTo" required {...headerForm.register('flightTo')} />
          </div>
          <div className="space-y-1.5">
            <Label htmlFor="departureDate">Departure Date</Label>
            <Input id="departureDate" type="date" required {...headerForm.register('departureDate')} />
          </div>
          <div className="space-y-1.5">
            <Label htmlFor="returnDate">Return Date (optional)</Label>
            <Input id="returnDate" type="date" {...headerForm.register('returnDate')} />
          </div>
          <div className="space-y-1.5">
            <Label htmlFor="airlinePreference">Airline Preference (optional)</Label>
            <Input id="airlinePreference" {...headerForm.register('airlinePreference')} />
          </div>
          <div className="space-y-1.5 md:col-span-2">
            <Label htmlFor="justification">Booking Justification</Label>
            <Input id="justification" required {...headerForm.register('justification')} />
          </div>
          {createMutation.error ? (
            <p className="text-sm font-medium text-red-600 md:col-span-2">
              {createMutation.error instanceof Error ? createMutation.error.message : 'Could not create work ticket'}
            </p>
          ) : null}
          <div className="md:col-span-2">
            <Button type="submit" variant="accent" className="rounded-full" disabled={createMutation.isPending}>
              {createMutation.isPending ? 'Saving…' : 'Create Flight Booking Work Ticket'}
            </Button>
          </div>
        </form>
      </PageWrapper>
    )
  }

  if (selectedNo) {
    const ticket = detailQuery.data
    const lineColumns: DataTableColumn<WorkTicketLine>[] = [
      { id: 'driver', header: 'Driver Name', cell: (row) => row.driverName },
      { id: 'from', header: 'Departure From', cell: (row) => row.departureFrom },
      { id: 'destination', header: 'Destination', cell: (row) => row.destination },
      { id: 'date', header: 'Work Date', cell: (row) => row.workDate },
      { id: 'officer', header: 'Authorizing Officer Name', cell: (row) => row.authorizingOfficerName },
      ...(ticket?.status === 'Open'
        ? [{
            id: 'action',
            header: 'Action',
            cell: (row: WorkTicketLine) => (
              <Button
                type="button"
                variant="ghost"
                size="sm"
                className="text-red-600"
                disabled={deleteMutation.isPending}
                onClick={() => void removeLine(row)}
              >
                <Trash2 className="h-4 w-4" />
                Delete
              </Button>
            ),
          }]
        : []),
    ]
    return (
      <PageWrapper title="Work Ticket Details">
        <div className="flex flex-wrap items-center justify-between gap-2">
          <Button type="button" variant="ghost" onClick={() => setSelectedNo('')}>
            <ArrowLeft className="h-4 w-4" />
            Back to tickets
          </Button>
          {ticket?.status === 'Open' || ticket?.status === 'Draft' ? (
            <Button
              type="button"
              variant="accent"
              disabled={approvalMutation.isPending}
              onClick={() => approvalMutation.mutate('submit')}
            >
              <Send className="h-4 w-4" />
              {approvalMutation.isPending ? 'Submitting…' : 'Request Approval'}
            </Button>
          ) : ticket?.status === 'Pending Approval' ? (
            <Button
              type="button"
              variant="outline"
              disabled={approvalMutation.isPending}
              onClick={() => approvalMutation.mutate('cancel')}
            >
              <XCircle className="h-4 w-4" />
              {approvalMutation.isPending ? 'Cancelling…' : 'Cancel Approval'}
            </Button>
          ) : null}
        </div>
        {ticket ? (
          <>
            <div className="portal-card my-4 grid gap-3 p-4 sm:grid-cols-3">
              <div><p className="text-xs text-slate-500">Ticket No.</p><p className="font-semibold">{ticket.ticketNo}</p></div>
              <div><p className="text-xs text-slate-500">Previous Ticket</p><p className="font-semibold">{ticket.previousTicketNo || '-'}</p></div>
              <div><p className="text-xs text-slate-500">GK No.</p><p className="font-semibold">{ticket.gkNo || '-'}</p></div>
              <div><p className="text-xs text-slate-500">Traveler</p><p className="font-semibold">{ticket.travelerName || ticket.travelerEmployeeNo || '-'}</p></div>
              <div><p className="text-xs text-slate-500">Flight From</p><p className="font-semibold">{ticket.flightFrom || '-'}</p></div>
              <div><p className="text-xs text-slate-500">Flight To</p><p className="font-semibold">{ticket.flightTo || '-'}</p></div>
              <div><p className="text-xs text-slate-500">Departure Date</p><p className="font-semibold">{ticket.departureDate || '-'}</p></div>
              <div><p className="text-xs text-slate-500">Return Date</p><p className="font-semibold">{ticket.returnDate || '-'}</p></div>
              <div><p className="text-xs text-slate-500">Ticket Class</p><p className="font-semibold">{ticket.ticketClass || '-'}</p></div>
              <div><p className="text-xs text-slate-500">Airline Preference</p><p className="font-semibold">{ticket.airlinePreference || '-'}</p></div>
              <div><p className="text-xs text-slate-500">Justification</p><p className="font-semibold">{ticket.justification || '-'}</p></div>
              <div><p className="text-xs text-slate-500">Department</p><p className="font-semibold">{ticket.department || '-'}</p></div>
              <div><p className="text-xs text-slate-500">Status</p><StatusBadge status={ticket.status} /></div>
              <div>
                <p className="text-xs text-slate-500">Booking Confirmation</p>
                <p className="font-semibold">{ticket.bookingConfirmationNo || 'Not confirmed'}</p>
              </div>
            </div>
            {!ticket.bookingConfirmed ? (
              <div className="portal-card mb-4 flex flex-wrap items-end gap-3 p-4">
                <div className="min-w-64 flex-1 space-y-1.5">
                  <Label htmlFor="bookingConfirmationNo">Booking Confirmation No.</Label>
                  <Input
                    id="bookingConfirmationNo"
                    value={confirmationNo}
                    onChange={(event) => setConfirmationNo(event.target.value)}
                    placeholder="Enter airline / agent confirmation number"
                  />
                </div>
                <Button
                  type="button"
                  variant="accent"
                  disabled={!confirmationNo.trim() || confirmationMutation.isPending}
                  onClick={() => confirmationMutation.mutate()}
                >
                  <CheckCircle2 className="h-4 w-4" />
                  {confirmationMutation.isPending ? 'Confirming…' : 'Confirm Booking'}
                </Button>
              </div>
            ) : null}
            <div className="mb-3 flex items-center justify-between gap-3">
              <h3 className="text-sm font-semibold text-slate-700">Work Ticket Lines</h3>
              {ticket.status === 'Open' ? (
                <Button type="button" size="sm" variant="accent" className="rounded-full" onClick={() => setShowLineForm((open) => !open)}>
                  <Plus className="h-4 w-4" />
                  New Line
                </Button>
              ) : null}
            </div>
            {showLineForm ? (
              <form
                className="portal-card mb-4 grid gap-3 p-4 md:grid-cols-2 xl:grid-cols-3"
                onSubmit={(event) => {
                  event.preventDefault()
                  void lineForm.handleSubmit((values) => addLineMutation.mutate(values))()
                }}
              >
                <div className="space-y-1.5">
                  <Label htmlFor="driverName">Driver Name</Label>
                  <Input id="driverName" {...lineForm.register('driverName')} />
                </div>
                <div className="space-y-1.5">
                  <Label htmlFor="departureFrom">Departure From</Label>
                  <Input id="departureFrom" {...lineForm.register('departureFrom')} />
                </div>
                <div className="space-y-1.5">
                  <Label htmlFor="destination">Destination</Label>
                  <Input id="destination" {...lineForm.register('destination')} />
                </div>
                <div className="space-y-1.5">
                  <Label htmlFor="workDate">Work Date</Label>
                  <Input id="workDate" type="date" {...lineForm.register('workDate')} />
                </div>
                <div className="space-y-1.5">
                  <Label htmlFor="authorizingOfficer">Authorizing Officer</Label>
                  <Select
                    id="authorizingOfficer"
                    placeholder="Select officer"
                    options={employees.options}
                    {...lineForm.register('authorizingOfficer')}
                  />
                </div>
                <div className="flex items-end gap-2 md:col-span-2 xl:col-span-3">
                  <Button type="submit" size="sm" disabled={addLineMutation.isPending}>
                    {addLineMutation.isPending ? 'Saving…' : 'Add line'}
                  </Button>
                  <Button type="button" size="sm" variant="outline" onClick={() => setShowLineForm(false)}>
                    Cancel
                  </Button>
                </div>
                {addLineMutation.error ? (
                  <p className="text-sm font-medium text-red-600 md:col-span-2 xl:col-span-3">
                    {addLineMutation.error instanceof Error ? addLineMutation.error.message : 'Could not add line'}
                  </p>
                ) : null}
              </form>
            ) : null}
            <DataTable
              rows={ticket.lines}
              columns={lineColumns}
              getRowId={(row) => row.id}
              emptyTitle="No work-ticket lines found"
              compact
            />
          </>
        ) : (
          <p className="mt-4 text-sm text-slate-500">
            {detailQuery.isLoading ? 'Loading work ticket...' : 'Work ticket could not be loaded.'}
          </p>
        )}
      </PageWrapper>
    )
  }

  return (
    <PageWrapper
      title="Work Tickets"
      description="Create flight-booking work tickets, manage lines, and record booking confirmation in Business Central."
      actions={<PortalNewButton label="New Flight Booking" onClick={() => setMode('create')} />}
    >
      <DataTable
        rows={query.data ?? []}
        columns={columns}
        getRowId={(row) => row.id}
        onRowClick={(row) => setSelectedNo(row.ticketNo)}
        emptyTitle={query.isLoading ? 'Loading work tickets...' : 'No work tickets found'}
        compact
      />
    </PageWrapper>
  )
}
