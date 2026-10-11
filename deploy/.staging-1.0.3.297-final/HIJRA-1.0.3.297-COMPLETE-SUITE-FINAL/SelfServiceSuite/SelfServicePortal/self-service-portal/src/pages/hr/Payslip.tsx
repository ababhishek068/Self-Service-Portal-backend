import { useEffect, useMemo, useState } from 'react'
import { useQuery } from '@tanstack/react-query'
import { Download } from 'lucide-react'
import { listPayrollPeriods, openPayslipPdf } from '@/api/endpoints/payroll'
import { PageWrapper } from '@/components/layout/PageWrapper'
import { PortalFormCard } from '@/components/shared/PortalFormCard'
import { Button } from '@/components/ui/button'
import { Label } from '@/components/ui/label'
import { Select } from '@/components/ui/select'

const monthNames = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December',
]

function monthSortKey(value: string) {
  const numeric = Number(value)
  if (Number.isInteger(numeric) && numeric >= 1 && numeric <= 12) return numeric
  const byName = monthNames.findIndex((name) => name.toLowerCase() === value.trim().toLowerCase())
  return byName >= 0 ? byName + 1 : 99
}

function monthLabel(value: string) {
  const numeric = Number(value)
  if (Number.isInteger(numeric) && numeric >= 1 && numeric <= 12) return monthNames[numeric - 1]!
  const byName = monthNames.find((name) => name.toLowerCase() === value.trim().toLowerCase())
  return byName ?? value
}

export function Payslip() {
  const [year, setYear] = useState('')
  const [month, setMonth] = useState('')
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')
  const periodsQuery = useQuery({ queryKey: ['payroll', 'periods'], queryFn: listPayrollPeriods })
  const periods = periodsQuery.data ?? []
  const years = useMemo(
    () => [...new Set(periods.map((period) => String(period.year)))].sort(),
    [periods],
  )
  const months = useMemo(
    () =>
      periods
        .filter((period) => !year || String(period.year) === year)
        .map((period) => ({
          value: String(period.month),
          label: monthLabel(String(period.month)),
        }))
        .filter((period, index, rows) => rows.findIndex((row) => row.value === period.value) === index)
        .sort((left, right) => monthSortKey(left.value) - monthSortKey(right.value)),
    [periods, year],
  )

  useEffect(() => {
    if (!year && years.length === 1) setYear(years[0]!)
  }, [year, years])

  useEffect(() => {
    if (month && !months.some((option) => option.value === month)) setMonth('')
  }, [month, months])

  const generate = async () => {
    setLoading(true)
    setError('')
    try {
      await openPayslipPdf(year, month)
    } catch (reason) {
      setError(reason instanceof Error ? reason.message : 'Payslip generation failed.')
    } finally {
      setLoading(false)
    }
  }

  return (
    <PageWrapper title="Payslip" showPageHeading={false}>
      <PortalFormCard title="Payslip">
        <div className="space-y-4">
          <p className="text-sm text-slate-600">
            Only <span className="font-medium">closed</span> payroll periods from Business Central are listed.
            Choose year and month, then open the payslip as a PDF (it is not shown on this page).
          </p>
          {periodsQuery.isLoading ? (
            <p className="text-sm text-slate-500">Loading closed payroll periods…</p>
          ) : null}
          {!periodsQuery.isLoading && periods.length === 0 ? (
            <p className="rounded-md border border-amber-200 bg-amber-50 p-3 text-sm text-amber-800">
              No closed payroll periods were returned from Business Central. Confirm periods are closed in BC
              and that OData query <span className="font-medium">QyPayrollPeriods</span> is published.
            </p>
          ) : null}
          <div className="grid gap-4 sm:grid-cols-2">
            <div className="space-y-1.5">
              <Label htmlFor="year">Payroll Period Year</Label>
              <Select
                id="year"
                value={year}
                onChange={(event) => {
                  setYear(event.target.value)
                  setMonth('')
                }}
                placeholder="Select year"
                options={years.map((value) => ({ label: value, value }))}
              />
            </div>
            <div className="space-y-1.5">
              <Label htmlFor="month">Period Month</Label>
              <Select
                id="month"
                value={month}
                onChange={(event) => setMonth(event.target.value)}
                placeholder={year ? 'Select month' : 'Select year first'}
                options={months}
                disabled={!year}
              />
            </div>
          </div>
          {year && months.length > 0 ? (
            <p className="text-xs text-slate-500">
              Available for {year}: {months.map((option) => option.label).join(', ')}
            </p>
          ) : null}
          <div className="flex justify-center pt-2">
            <Button
              type="button"
              className="min-w-[120px] rounded-full"
              onClick={() => void generate()}
              disabled={loading || !year || !month}
            >
              <Download className="h-4 w-4" />
              {loading ? 'Generating...' : 'View PDF'}
            </Button>
          </div>
          {error ? <p className="text-center text-sm text-red-600">{error}</p> : null}
        </div>
      </PortalFormCard>
    </PageWrapper>
  )
}
