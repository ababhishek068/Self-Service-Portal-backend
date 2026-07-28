import { useQuery } from '@tanstack/react-query'
import { getGatePassLogReport } from '@/api/endpoints/employee'
import { PageWrapper } from '@/components/layout/PageWrapper'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { Skeleton } from '@/components/ui/skeleton'
import { DataTable, type DataTableColumn } from '@/components/shared/DataTable'
import { StatusBadge } from '@/components/shared/StatusBadge'
import { formatDate } from '@/utils/formatters'

interface GatePassLogRow {
  gatePassNo: string
  sourceDocumentNo: string
  type: string
  assetTag: string
  description: string
  fromLocation: string
  destination: string
  dateOut: string
  timeOut: string
  returnable: string
  returned: string
  returnDate: string
  employee: string
  status: string
}

export function GatePassLog() {
  const report = useQuery({ queryKey: ['reports', 'gate-pass-log'], queryFn: getGatePassLogReport })
  const columns: DataTableColumn<GatePassLogRow>[] = [
    { id: 'gatePassNo', header: 'Gate pass no', cell: (row) => row.gatePassNo, sortValue: (row) => row.gatePassNo },
    { id: 'type', header: 'Type', cell: (row) => row.type, sortValue: (row) => row.type },
    { id: 'sourceDocumentNo', header: 'Source document', cell: (row) => row.sourceDocumentNo || '-', sortValue: (row) => row.sourceDocumentNo },
    { id: 'assetTag', header: 'Asset / vehicle', cell: (row) => row.assetTag, sortValue: (row) => row.assetTag },
    { id: 'description', header: 'Description', cell: (row) => row.description, sortValue: (row) => row.description },
    { id: 'fromLocation', header: 'From', cell: (row) => row.fromLocation, sortValue: (row) => row.fromLocation },
    { id: 'destination', header: 'Destination', cell: (row) => row.destination, sortValue: (row) => row.destination },
    { id: 'dateOut', header: 'Date out', cell: (row) => formatDate(row.dateOut), sortValue: (row) => row.dateOut },
    { id: 'timeOut', header: 'Time out', cell: (row) => row.timeOut || '-', sortValue: (row) => row.timeOut },
    { id: 'returnable', header: 'Returnable', cell: (row) => row.returnable, sortValue: (row) => row.returnable },
    { id: 'returned', header: 'Returned', cell: (row) => row.returned, sortValue: (row) => row.returned },
    { id: 'returnDate', header: 'Return date', cell: (row) => formatDate(row.returnDate), sortValue: (row) => row.returnDate },
    { id: 'employee', header: 'Employee', cell: (row) => row.employee, sortValue: (row) => row.employee },
    { id: 'status', header: 'Status', cell: (row) => <StatusBadge status={row.status} />, sortValue: (row) => row.status },
  ]

  return (
    <PageWrapper title="Gate Pass Log" description="Returnable and non-returnable gate pass movement log.">
      <Card>
        <CardHeader>
          <CardTitle>Gate pass log</CardTitle>
          <CardDescription>Generated from gate pass source documents and asset movement entries.</CardDescription>
        </CardHeader>
        <CardContent>
          {report.isLoading ? (
            <Skeleton className="h-64" />
          ) : (
            <DataTable rows={(report.data ?? []) as GatePassLogRow[]} columns={columns} getRowId={(row) => row.gatePassNo} />
          )}
        </CardContent>
      </Card>
    </PageWrapper>
  )
}
