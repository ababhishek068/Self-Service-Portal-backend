import { useMemo, useState } from 'react'
import { useQuery } from '@tanstack/react-query'
import { getStoreUsageReport } from '@/api/endpoints/employee'
import { PageWrapper } from '@/components/layout/PageWrapper'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Skeleton } from '@/components/ui/skeleton'
import { DataTable, type DataTableColumn } from '@/components/shared/DataTable'
import { formatCurrency, formatDate } from '@/utils/formatters'

interface StoreUsageRow {
  requisitionNo: string
  lineNo: string
  type: string
  itemCode: string
  description: string
  tagNo: string
  issuingStore: string
  quantityRequested: number
  quantityIssued: number
  unitOfMeasure: string
  unitCost: number
  lineAmount: number
  department: string
  issueDate: string
  budgetName: string
  voteAccount: string
  requestStatus: string
}

export function StoreUsageReport() {
  const [from, setFrom] = useState('')
  const [to, setTo] = useState('')
  const [department, setDepartment] = useState('')
  const [type, setType] = useState('')

  const report = useQuery({
    queryKey: ['reports', 'store-usage', from, to, department, type],
    queryFn: () =>
      getStoreUsageReport({
        from: from || undefined,
        to: to || undefined,
        department: department || undefined,
        type: type || undefined,
      }),
  })

  const rows = (report.data ?? []) as StoreUsageRow[]
  const totals = useMemo(
    () => ({
      issuedQty: rows.reduce((sum, row) => sum + Number(row.quantityIssued ?? 0), 0),
      amount: rows.reduce((sum, row) => sum + Number(row.lineAmount ?? 0), 0),
    }),
    [rows],
  )

  const columns: DataTableColumn<StoreUsageRow>[] = [
    { id: 'requisitionNo', header: 'Requisition No.', cell: (row) => row.requisitionNo, sortValue: (row) => row.requisitionNo },
    { id: 'issueDate', header: 'Issue Date', cell: (row) => formatDate(row.issueDate), sortValue: (row) => row.issueDate },
    { id: 'type', header: 'Type', cell: (row) => row.type, sortValue: (row) => row.type },
    { id: 'itemCode', header: 'Item / FA No.', cell: (row) => row.itemCode, sortValue: (row) => row.itemCode },
    { id: 'description', header: 'Description', cell: (row) => row.description, sortValue: (row) => row.description },
    { id: 'tagNo', header: 'Tag No.', cell: (row) => row.tagNo || '—', sortValue: (row) => row.tagNo },
    { id: 'department', header: 'Department', cell: (row) => row.department || '—', sortValue: (row) => row.department },
    { id: 'issuingStore', header: 'Issuing Store', cell: (row) => row.issuingStore || '—', sortValue: (row) => row.issuingStore },
    {
      id: 'quantityIssued',
      header: 'Qty Issued',
      cell: (row) => row.quantityIssued,
      sortValue: (row) => row.quantityIssued,
    },
    {
      id: 'lineAmount',
      header: 'Amount',
      cell: (row) => (row.lineAmount > 0 ? formatCurrency(row.lineAmount) : '—'),
      sortValue: (row) => row.lineAmount,
    },
    { id: 'unitOfMeasure', header: 'UOM', cell: (row) => row.unitOfMeasure || '—', sortValue: (row) => row.unitOfMeasure },
    { id: 'requestStatus', header: 'Status', cell: (row) => row.requestStatus || '—', sortValue: (row) => row.requestStatus },
  ]

  return (
    <PageWrapper
      title="Store Issue Report"
      description="Line-level store issue detail from Business Central — filter by date, department, and line type."
    >
      <Card>
        <CardHeader>
          <CardTitle>Store issue lines</CardTitle>
          <CardDescription>
            Generated from QyStoreRequisitionLines with header department and issue dates. Use filters to
            segregate Item vs Fixed Asset lines.
          </CardDescription>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="grid gap-4 md:grid-cols-4">
            <div className="space-y-2">
              <Label htmlFor="store-usage-from">Issue date from</Label>
              <Input id="store-usage-from" type="date" value={from} onChange={(event) => setFrom(event.target.value)} />
            </div>
            <div className="space-y-2">
              <Label htmlFor="store-usage-to">Issue date to</Label>
              <Input id="store-usage-to" type="date" value={to} onChange={(event) => setTo(event.target.value)} />
            </div>
            <div className="space-y-2">
              <Label htmlFor="store-usage-department">Department</Label>
              <Input
                id="store-usage-department"
                placeholder="Filter by department code or name"
                value={department}
                onChange={(event) => setDepartment(event.target.value)}
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="store-usage-type">Line type</Label>
              <select
                id="store-usage-type"
                className="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm"
                value={type}
                onChange={(event) => setType(event.target.value)}
              >
                <option value="">All types</option>
                <option value="item">Item</option>
                <option value="asset">Fixed Asset</option>
              </select>
            </div>
          </div>

          <div className="rounded-lg border bg-muted/40 p-3 text-sm">
            <span className="font-medium">{rows.length}</span> line(s) · Issued qty{' '}
            <span className="font-medium">{totals.issuedQty}</span> · Total amount{' '}
            <span className="font-medium">{formatCurrency(totals.amount)}</span>
          </div>

          {report.isLoading ? (
            <Skeleton className="h-64" />
          ) : (
            <DataTable
              rows={rows}
              columns={columns}
              getRowId={(row) => `${row.requisitionNo}-${row.lineNo}-${row.itemCode}`}
            />
          )}
        </CardContent>
      </Card>
    </PageWrapper>
  )
}
