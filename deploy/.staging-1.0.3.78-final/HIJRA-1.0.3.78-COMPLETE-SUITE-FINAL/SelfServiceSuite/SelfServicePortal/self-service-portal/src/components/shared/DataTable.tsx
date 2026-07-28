import { useEffect, useMemo, useState, type ReactNode } from 'react'
import { Search, X } from 'lucide-react'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table'
import { cn } from '@/lib/utils'
import { matchesSearchQuery } from '@/utils/tableSearch'

export interface DataTableColumn<T> {
  id: string
  header: string
  cell: (row: T) => ReactNode
  sortValue?: (row: T) => string | number
  /** Optional value to include in the shared table search. */
  searchValue?: (row: T) => unknown
  /** Set to false when this column must not contribute to search. */
  searchable?: boolean
}

interface DataTableProps<T> {
  rows: T[]
  columns: DataTableColumn<T>[]
  getRowId: (row: T) => string
  emptyTitle?: string
  /** Set to null to suppress the secondary empty-state hint. */
  emptyHint?: ReactNode | null
  emptyAction?: ReactNode
  selectedRowId?: string
  compact?: boolean
  /** When provided, rows become clickable with hover affordance. */
  onRowClick?: (row: T) => void
  /** Set to false when the parent page already provides its own search control. */
  searchable?: boolean
  searchPlaceholder?: string
}

export function DataTable<T>({
  rows,
  columns,
  getRowId,
  emptyTitle,
  emptyHint,
  emptyAction,
  selectedRowId,
  compact = false,
  onRowClick,
  searchable = true,
  searchPlaceholder = 'Search records...',
}: DataTableProps<T>) {
  const [page, setPage] = useState(1)
  const [search, setSearch] = useState('')
  const pageSize = compact ? 20 : 10
  const filteredRows = useMemo(() => {
    if (!searchable || !search.trim()) return rows

    return rows.filter((row) => {
      const columnValues = columns
        .filter((column) => column.searchable !== false)
        .map((column) => column.searchValue?.(row) ?? column.sortValue?.(row))
      return matchesSearchQuery(row, search, columnValues)
    })
  }, [columns, rows, search, searchable])
  const pageCount = Math.max(1, Math.ceil(filteredRows.length / pageSize))
  const safePage = Math.min(page, pageCount)
  const pagedRows = useMemo(
    () => filteredRows.slice((safePage - 1) * pageSize, safePage * pageSize),
    [filteredRows, pageSize, safePage],
  )
  const showSearch = searchable && (rows.length > 1 || search.length > 0)

  useEffect(() => {
    setPage(1)
  }, [search])

  return (
    <div className="animate-page-in space-y-3 transition-opacity duration-300">
      {showSearch ? (
        <div className="flex flex-col gap-2 sm:flex-row sm:items-center sm:justify-between">
          <label className="relative block w-full sm:max-w-md">
            <span className="sr-only">Search table records</span>
            <Search className="pointer-events-none absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-slate-400" />
            <Input
              type="search"
              value={search}
              onChange={(event) => setSearch(event.target.value)}
              placeholder={searchPlaceholder}
              aria-label="Search table records"
              className="pr-10 pl-9"
            />
            {search ? (
              <button
                type="button"
                onClick={() => setSearch('')}
                aria-label="Clear table search"
                className="absolute right-2 top-1/2 flex h-7 w-7 -translate-y-1/2 items-center justify-center rounded-full text-slate-400 transition hover:bg-slate-100 hover:text-slate-700"
              >
                <X className="h-4 w-4" />
              </button>
            ) : null}
          </label>
          <p className="text-xs text-slate-500" aria-live="polite">
            {search ? `${filteredRows.length} of ${rows.length} records` : `${rows.length} records`}
          </p>
        </div>
      ) : null}

      <Table>
        <TableHeader>
          <TableRow className="hover:bg-transparent">
            {columns.map((column) => (
              <TableHead key={column.id}>{column.header}</TableHead>
            ))}
          </TableRow>
        </TableHeader>
        <TableBody key={`${safePage}-${search}`} className="portal-row-stagger">
          {pagedRows.length > 0 ? (
            pagedRows.map((row) => {
              const rowId = getRowId(row)
              return (
                <TableRow
                  key={rowId}
                  onClick={onRowClick ? () => onRowClick(row) : undefined}
                  className={cn(
                    onRowClick && 'portal-row-click',
                    selectedRowId === rowId && 'bg-[var(--portal-green-light)]! text-white hover:bg-[var(--portal-green-light)]!',
                  )}
                >
                  {columns.map((column) => (
                    <TableCell key={column.id} className={selectedRowId === rowId ? 'text-white' : undefined}>
                      {column.cell(row)}
                    </TableCell>
                  ))}
                </TableRow>
              )
            })
          ) : (
            <TableRow className="hover:bg-transparent">
              <TableCell colSpan={columns.length} className="py-12 text-center">
                <p className="text-base font-medium italic text-slate-500">
                  {search ? `No records match "${search.trim()}"` : (emptyTitle ?? '*** No records Found ***')}
                </p>
                {emptyHint !== null ? (
                  <p className="mt-1 text-xs text-slate-400">
                    {search ? 'Try another request number, employee, description, date, or status.' : (emptyHint ?? 'Create a new request to get started')}
                  </p>
                ) : null}
                {search ? (
                  <Button type="button" variant="outline" size="sm" className="mt-3" onClick={() => setSearch('')}>
                    Clear search
                  </Button>
                ) : emptyAction ? <div className="mt-3">{emptyAction}</div> : null}
              </TableCell>
            </TableRow>
          )}
        </TableBody>
      </Table>

      {filteredRows.length > pageSize ? (
        <div className="flex flex-col gap-2 sm:flex-row sm:items-center sm:justify-between">
          <p className="text-xs text-slate-600 sm:text-sm">
            Page {safePage} of {pageCount}
          </p>
          <div className="flex gap-2">
            <Button
              type="button"
              variant="outline"
              size="sm"
              className="flex-1 sm:flex-initial"
              disabled={safePage === 1}
              onClick={() => setPage((value) => Math.max(1, value - 1))}
            >
              Previous
            </Button>
            <Button
              type="button"
              variant="outline"
              size="sm"
              className="flex-1 sm:flex-initial"
              disabled={safePage === pageCount}
              onClick={() => setPage((value) => Math.min(pageCount, value + 1))}
            >
              Next
            </Button>
          </div>
        </div>
      ) : null}
    </div>
  )
}
