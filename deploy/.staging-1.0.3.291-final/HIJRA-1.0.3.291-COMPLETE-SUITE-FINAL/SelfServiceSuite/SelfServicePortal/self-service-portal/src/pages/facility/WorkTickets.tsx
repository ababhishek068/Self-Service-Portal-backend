import { zodResolver } from '@hookform/resolvers/zod'
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { AlertCircle, ArrowLeft, Plus, Send, Trash2, XCircle } from 'lucide-react'
import { useEffect, useState } from 'react'
import { useForm, type Resolver } from 'react-hook-form'
import {
  addWorkTicketLine,
  cancelWorkTicketApproval,
  confirmWorkTicketBooking,
  createWorkTicket,
  deleteWorkTicketLine,
  getWorkTicket,
  listWorkTickets,
  saveWorkTicketFlight,
  submitWorkTicket,
  type WorkTicketLine,
  type WorkTicketRow,
} from '@/api/endpoints/workTickets'
import { useConfirm } from '@/components/feedback/ConfirmProvider'
import { useToast } from '@/components/feedback/ToastProvider'
import { PageWrapper } from '@/components/layout/PageWrapper'
import { DataTable, type DataTableColumn } from '@/components/shared/DataTable'
import { PortalFormCard } from '@/components/shared/PortalFormCard'
import { PortalNewButton } from '@/components/shared/PortalNewButton'
import { StatusBadge } from '@/components/shared/StatusBadge'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Select } from '@/components/ui/select'
import { Textarea } from '@/components/ui/textarea'
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
  { id: 'type', header: 'Type', cell: (row) => row.type },
  { id: 'department', header: 'Department', cell: (row) => row.department },
]

export function WorkTickets() {
  const [selectedNo, setSelectedNo] = useState('')
  const [mode, setMode] = useState<'list' | 'create'>('list')
  const [showLineForm, setShowLineForm] = useState(false)
  const [showFlightForm, setShowFlightForm] = useState(false)
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
    defaultValues: { previousTicketNo: '', gkNo: '', type: '' },
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

  const [flightFrom, setFlightFrom] = useState('')
  const [flightTo, setFlightTo] = useState('')
  const [departureDate, setDepartureDate] = useState('')
  const [returnDate, setReturnDate] = useState('')
  const [ticketClass, setTicketClass] = useState<'Economy' | 'Business'>('Economy')
  const [airlinePreference, setAirlinePreference] = useState('')
  const [justification, setJustification] = useState('')
  const [travelerEmployeeNo, setTravelerEmployeeNo] = useState('')

  useEffect(() => {
    const ticket = detailQuery.data
    if (!ticket) return
    setFlightFrom(ticket.flightFrom || '')
    setFlightTo(ticket.flightTo || '')
    setDepartureDate((ticket.departureDate || '').slice(0, 10))
    setReturnDate((ticket.returnDate || '').slice(0, 10))
    setTicketClass(ticket.ticketClass?.toLowerCase().includes('business') ? 'Business' : 'Economy')
    setAirlinePreference(ticket.airlinePreference || '')
    setJustification(ticket.justification || '')
    setTravelerEmployeeNo(ticket.travelerEmployeeNo || '')
    setConfirmationNo(ticket.bookingConfirmationNo || '')
  }, [detailQuery.data])

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

  const flightMutation = useMutation({
    mutationFn: () =>
      saveWorkTicketFlight(selectedNo, {
        travelerEmployeeNo,
        flightFrom,
        flightTo,
        departureDate,
        returnDate,
        ticketClass,
        airlinePreference,
        justification,
      }),
    onSuccess: async () => {
      await queryClient.invalidateQueries({ queryKey: ['facility', 'work-tickets', selectedNo] })
      toast.success('Flight booking details saved')
      setShowFlightForm(false)
    },
    onError: (error) =>
      toast.error(error instanceof Error ? error.message : 'Could not save flight details', 'Save failed'),
  })

  const confirmBookingMutation = useMutation({
    mutationFn: () => confirmWorkTicketBooking(selectedNo, confirmationNo),
    onSuccess: async () => {
      await queryClient.invalidateQueries({ queryKey: ['facility', 'work-tickets', selectedNo] })
      toast.success('Booking confirmation recorded')
    },
    onError: (error) =>
      toast.error(error instanceof Error ? error.message : 'Could not confirm booking', 'Save failed'),
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
    const createError =
      createMutation.error instanceof Error ? createMutation.error.message : createMutation.error ? 'Could not create work ticket' : ''
    const needsTicketSeries = /Work Ticket No|FLT-Fleet Mgt Setup/i.test(createError)

    return (
      <PageWrapper title="New Work Ticket" showPageHeading={false}>
        <Button type="button" variant="ghost" className="mb-3 -ml-2" onClick={() => setMode('list')}>
          <ArrowLeft className="h-4 w-4" />
          Back to tickets
        </Button>
        <PortalFormCard title="New Work Ticket" className="max-w-3xl">
          <form
            className="space-y-4"
            onSubmit={(event) => {
              event.preventDefault()
              void headerForm.handleSubmit((values) => createMutation.mutate(values))()
            }}
          >
            <div className="grid grid-cols-1 gap-x-3 gap-y-3 sm:grid-cols-2">
              <div className="flex min-w-0 flex-col gap-1.5">
                <Label htmlFor="previousTicketNo" className="h-5 leading-5">
                  Previous Ticket No.
                </Label>
                <Input id="previousTicketNo" placeholder="Optional" {...headerForm.register('previousTicketNo')} />
              </div>
              <div className="flex min-w-0 flex-col gap-1.5">
                <Label htmlFor="gkNo" className="h-5 leading-5">
                  GK No.
                </Label>
                <Input id="gkNo" required placeholder="Required" {...headerForm.register('gkNo')} />
              </div>
              <div className="flex min-w-0 flex-col gap-1.5 sm:col-span-2">
                <Label htmlFor="type" className="h-5 leading-5">
                  Type
                </Label>
                <Input id="type" placeholder="e.g. Local, Flight" {...headerForm.register('type')} />
              </div>
            </div>

            {createError ? (
              <div className="flex items-start gap-2 rounded-md border border-red-200 bg-red-50 p-3 text-sm text-red-700">
                <AlertCircle className="mt-0.5 h-4 w-4 shrink-0" />
                <div className="min-w-0 space-y-1">
                  <p>{createError}</p>
                  {needsTicketSeries ? (
                    <p className="text-xs text-red-600/90">
                      In Business Central open <span className="font-semibold">FLT-Fleet Mgt Setup</span> and set a
                      number series on <span className="font-semibold">Work Ticket No.</span>, then try again.
                    </p>
                  ) : null}
                </div>
              </div>
            ) : null}

            <div className="flex flex-wrap justify-center gap-2 border-t border-slate-100 pt-3">
              <Button type="button" variant="outline" className="rounded-full" disabled={createMutation.isPending} onClick={() => setMode('list')}>
                Cancel
              </Button>
              <Button type="submit" variant="accent" className="rounded-full" disabled={createMutation.isPending}>
                {createMutation.isPending ? 'Saving…' : 'Create Work Ticket'}
              </Button>
            </div>
          </form>
        </PortalFormCard>
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
              <div><p className="text-xs text-slate-500">Type</p><p className="font-semibold">{ticket.type || '-'}</p></div>
              <div><p className="text-xs text-slate-500">Department</p><p className="font-semibold">{ticket.department || '-'}</p></div>
              <div><p className="text-xs text-slate-500">Status</p><StatusBadge status={ticket.status} /></div>
            </div>

            <div className="portal-card mb-4 space-y-3 p-4">
              <div className="flex flex-wrap items-center justify-between gap-2">
                <h3 className="text-sm font-semibold text-slate-700">Flight booking (R45–R48)</h3>
                <Button type="button" size="sm" variant="outline" onClick={() => setShowFlightForm((open) => !open)}>
                  {showFlightForm ? 'Hide form' : 'Edit flight details'}
                </Button>
              </div>
              <div className="grid gap-3 sm:grid-cols-3">
                <div><p className="text-xs text-slate-500">From</p><p className="font-semibold">{ticket.flightFrom || '-'}</p></div>
                <div><p className="text-xs text-slate-500">To</p><p className="font-semibold">{ticket.flightTo || '-'}</p></div>
                <div><p className="text-xs text-slate-500">Class</p><p className="font-semibold">{ticket.ticketClass || '-'}</p></div>
                <div><p className="text-xs text-slate-500">Departure</p><p className="font-semibold">{ticket.departureDate || '-'}</p></div>
                <div><p className="text-xs text-slate-500">Return</p><p className="font-semibold">{ticket.returnDate || '-'}</p></div>
                <div><p className="text-xs text-slate-500">Traveler</p><p className="font-semibold">{ticket.travelerName || ticket.travelerEmployeeNo || '-'}</p></div>
                <div><p className="text-xs text-slate-500">Confirmation</p><p className="font-semibold">{ticket.bookingConfirmationNo || '-'}</p></div>
                <div><p className="text-xs text-slate-500">Confirmed</p><p className="font-semibold">{ticket.bookingConfirmed ? 'Yes' : 'No'}</p></div>
              </div>
              {showFlightForm ? (
                <form
                  className="grid gap-3 border-t border-slate-200 pt-3 md:grid-cols-2 xl:grid-cols-3"
                  onSubmit={(event) => {
                    event.preventDefault()
                    flightMutation.mutate()
                  }}
                >
                  <div className="space-y-1.5">
                    <Label>Traveler</Label>
                    <Select
                      placeholder="Select traveler"
                      options={employees.options}
                      value={travelerEmployeeNo}
                      onChange={(event) => setTravelerEmployeeNo(event.target.value)}
                    />
                  </div>
                  <div className="space-y-1.5">
                    <Label>Flight from</Label>
                    <Input value={flightFrom} onChange={(e) => setFlightFrom(e.target.value)} required />
                  </div>
                  <div className="space-y-1.5">
                    <Label>Flight to</Label>
                    <Input value={flightTo} onChange={(e) => setFlightTo(e.target.value)} required />
                  </div>
                  <div className="space-y-1.5">
                    <Label>Departure date</Label>
                    <Input type="date" value={departureDate} onChange={(e) => setDepartureDate(e.target.value)} required />
                  </div>
                  <div className="space-y-1.5">
                    <Label>Return date</Label>
                    <Input type="date" value={returnDate} onChange={(e) => setReturnDate(e.target.value)} />
                  </div>
                  <div className="space-y-1.5">
                    <Label>Ticket class</Label>
                    <Select
                      options={[
                        { label: 'Economy', value: 'Economy' },
                        { label: 'Business', value: 'Business' },
                      ]}
                      value={ticketClass}
                      onChange={(e) => setTicketClass(e.target.value as 'Economy' | 'Business')}
                    />
                  </div>
                  <div className="space-y-1.5">
                    <Label>Airline preference</Label>
                    <Input value={airlinePreference} onChange={(e) => setAirlinePreference(e.target.value)} />
                  </div>
                  <div className="space-y-1.5 md:col-span-2">
                    <Label>Justification</Label>
                    <Textarea value={justification} onChange={(e) => setJustification(e.target.value)} />
                  </div>
                  <div className="flex items-end">
                    <Button type="submit" size="sm" disabled={flightMutation.isPending}>
                      {flightMutation.isPending ? 'Saving…' : 'Save flight details'}
                    </Button>
                  </div>
                </form>
              ) : null}
              {!ticket.bookingConfirmed &&
              (ticket.status === 'Approved' || ticket.status === 'Posted' || ticket.status === 'Released') ? (
                <div className="flex flex-wrap items-end gap-2 border-t border-slate-200 pt-3">
                  <div className="space-y-1.5">
                    <Label>Booking confirmation No.</Label>
                    <Input value={confirmationNo} onChange={(e) => setConfirmationNo(e.target.value)} />
                  </div>
                  <Button
                    type="button"
                    size="sm"
                    variant="outline"
                    disabled={!confirmationNo || confirmBookingMutation.isPending}
                    onClick={() => confirmBookingMutation.mutate()}
                  >
                    {confirmBookingMutation.isPending ? 'Saving…' : 'Confirm booking receipt'}
                  </Button>
                </div>
              ) : null}
            </div>

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
      description="Create work tickets and manage lines in Business Central."
      actions={<PortalNewButton label="New Work Ticket" onClick={() => setMode('create')} />}
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
