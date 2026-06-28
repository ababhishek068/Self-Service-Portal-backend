import { zodResolver } from '@hookform/resolvers/zod'
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { ArrowLeft, Plus, Trash2 } from 'lucide-react'
import { useState } from 'react'
import { useForm, type Resolver } from 'react-hook-form'
import {
  addWorkTicketLine,
  createWorkTicket,
  deleteWorkTicketLine,
  getWorkTicket,
  listWorkTickets,
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
  { id: 'type', header: 'Type', cell: (row) => row.type },
  { id: 'department', header: 'Department', cell: (row) => row.department },
]

export function WorkTickets() {
  const [selectedNo, setSelectedNo] = useState('')
  const [mode, setMode] = useState<'list' | 'create'>('list')
  const [showLineForm, setShowLineForm] = useState(false)
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
          className="portal-card mt-4 grid max-w-2xl gap-4 p-4"
          onSubmit={(event) => {
            event.preventDefault()
            void headerForm.handleSubmit((values) => createMutation.mutate(values))()
          }}
        >
          <div className="space-y-1.5">
            <Label htmlFor="previousTicketNo">Previous Ticket No.</Label>
            <Input id="previousTicketNo" {...headerForm.register('previousTicketNo')} />
          </div>
          <div className="space-y-1.5">
            <Label htmlFor="gkNo">GK No.</Label>
            <Input id="gkNo" required {...headerForm.register('gkNo')} />
          </div>
          <div className="space-y-1.5">
            <Label htmlFor="type">Type</Label>
            <Input id="type" {...headerForm.register('type')} />
          </div>
          {createMutation.error ? (
            <p className="text-sm font-medium text-red-600">
              {createMutation.error instanceof Error ? createMutation.error.message : 'Could not create work ticket'}
            </p>
          ) : null}
          <div>
            <Button type="submit" variant="accent" className="rounded-full" disabled={createMutation.isPending}>
              {createMutation.isPending ? 'Saving…' : 'Create Work Ticket'}
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
        <Button type="button" variant="ghost" onClick={() => setSelectedNo('')}>
          <ArrowLeft className="h-4 w-4" />
          Back to tickets
        </Button>
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
