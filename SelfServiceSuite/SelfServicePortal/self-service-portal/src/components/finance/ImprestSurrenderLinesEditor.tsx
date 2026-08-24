import { formatISO } from 'date-fns'
import { useEffect, useMemo, useState } from 'react'
import { useMutation } from '@tanstack/react-query'
import { setRequestLines, updateRequestHeader } from '@/api/endpoints/requestEndpoint'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Select, type SelectOption } from '@/components/ui/select'
import { useToast } from '@/components/feedback/ToastProvider'
import type { PortalRequest } from '@/types/erp.types'
import { formatCurrency, formatDate } from '@/utils/formatters'
import { isEditableRequestStatus } from '@/utils/requestStatus'

type SurrenderLine = {
  lineNo: number
  accountNo: string
  accountName: string
  surrenderDocNo: string
  amount: number
  actualSpent: number
  cashReceiptNo: string
  cashReceiptAmount: number
  outstandingAmount: number
  editable: boolean
}

function allLinesFromRequest(request: PortalRequest): SurrenderLine[] {
  const raw = Array.isArray(request.payload?.lines)
    ? (request.payload.lines as Record<string, unknown>[])
    : []
  return raw.map((line, index) => {
    const amount = Number(line.amount ?? 0)
    const lineNo = Number(line.lineNo ?? line.id ?? (index + 1) * 10000)
    const actualSpent = Number(line.actualSpent ?? 0)
    const cashReceiptAmount = Number(line.cashReceiptAmount ?? 0)
    const outstandingAmount = Number(
      line.outstandingAmount ?? line.bcOutstandingAmount ?? 0,
    )
    return {
      lineNo,
      accountNo: String(line.accountNo ?? ''),
      accountName: String(line.accountName ?? line.accountNo ?? '—'),
      surrenderDocNo: String(line.surrenderDocNo ?? request.requestNo ?? ''),
      amount,
      actualSpent,
      cashReceiptNo: String(line.cashReceiptNo ?? ''),
      cashReceiptAmount,
      outstandingAmount,
      editable: amount > 0,
    }
  })
}

function remainingForLine(line: SurrenderLine) {
  const calculated = Math.max(0, line.amount - line.actualSpent - line.cashReceiptAmount)
  if (line.actualSpent > 0) return calculated
  if (line.outstandingAmount > 0 && line.outstandingAmount < line.amount) {
    return line.outstandingAmount
  }
  return calculated
}

function firstPayloadValue(payload: Record<string, unknown>, keys: string[]) {
  for (const key of keys) {
    const value = String(payload[key] ?? '').trim()
    if (value && !value.startsWith('0001-01-01') && !value.startsWith('01 Jan 0001')) {
      return value
    }
  }
  return ''
}

function inclusiveTravelDays(start: string, end: string) {
  const from = Date.parse(`${start.slice(0, 10)}T00:00:00`)
  const to = Date.parse(`${end.slice(0, 10)}T00:00:00`)
  if (!Number.isFinite(from) || !Number.isFinite(to) || to < from) return 0
  return Math.round((to - from) / 86_400_000) + 1
}

function defaultReturnDate(payload: Record<string, unknown>) {
  return (
    firstPayloadValue(payload, [
      'ActualReturnDate',
      'Actual_Return_Date',
      'actualReturnDate',
      'ExpectedReturnDate',
      'Expected_Return_Date',
      'ReturnDate',
      'Return_Date',
    ]) || formatISO(new Date(), { representation: 'date' })
  )
}

function duplicateAccountLabels(lines: SurrenderLine[]): string[] {
  const counts = new Map<string, number>()
  for (const line of lines) {
    if (!line.editable || !line.accountNo) continue
    counts.set(line.accountNo, (counts.get(line.accountNo) ?? 0) + 1)
  }
  return [...counts.entries()]
    .filter(([, count]) => count > 1)
    .map(([accountNo]) => {
      const name = lines.find((line) => line.accountNo === accountNo)?.accountName ?? accountNo
      return `${name} (${accountNo})`
    })
}

export function ImprestSurrenderLinesEditor({
  request,
  receiptOptions,
  onChanged,
}: {
  request: PortalRequest
  receiptOptions: SelectOption[]
  onChanged: () => void
}) {
  const payload = (request.payload ?? {}) as Record<string, unknown>
  const initial = useMemo(() => allLinesFromRequest(request), [request])
  const [lines, setLines] = useState<SurrenderLine[]>(initial)
  useEffect(() => setLines(initial), [initial])
  const toast = useToast()
  const editable = isEditableRequestStatus(request.status, 'imprestSurrender')
  // Excel UAT: Actual Spent must always be enterable on Draft — never lock the grid.
  const canEditSpend = editable
  const editableLines = lines.filter((line) => line.editable)
  const duplicateAccounts = useMemo(() => duplicateAccountLabels(lines), [lines])
  const savedReturnDate = firstPayloadValue(payload, [
    'ActualReturnDate',
    'Actual_Return_Date',
    'actualReturnDate',
  ])
  const [returnDateDraft, setReturnDateDraft] = useState(() => defaultReturnDate(payload))
  const savedTravelStart = firstPayloadValue(payload, [
    'TravelStartDate',
    'Travel_Start_Date',
    'TravelDate',
    'Travel_Date',
    'DateRequired',
    'Date_Required',
  ])
  const travelDays =
    savedTravelStart && (savedReturnDate || returnDateDraft)
      ? inclusiveTravelDays(savedTravelStart, savedReturnDate || returnDateDraft)
      : 0
  const oneDayStamp =
    Boolean(savedTravelStart) &&
    Boolean(savedReturnDate) &&
    savedTravelStart.slice(0, 10) === savedReturnDate.slice(0, 10)
  useEffect(() => setReturnDateDraft(defaultReturnDate(payload)), [payload])

  const headerMutation = useMutation({
    mutationFn: () =>
      updateRequestHeader(request.id, {
        actualReturnDate: returnDateDraft,
        ActualReturnDate: returnDateDraft,
        imprest:
          firstPayloadValue(payload, ['ImprestIssueDocNo', 'Imprest_Issue_Doc_No', 'ImprestNo']) ||
          undefined,
        imprestIssueDocNo:
          firstPayloadValue(payload, ['ImprestIssueDocNo', 'Imprest_Issue_Doc_No', 'ImprestNo']) ||
          undefined,
      }),
    onSuccess: () => {
      toast.success('Actual Return Date saved')
      onChanged()
    },
    onError: (error) =>
      toast.error(
        error instanceof Error ? error.message : 'Could not save Actual Return Date',
        'Save failed',
      ),
  })

  const mutation = useMutation({
    mutationFn: (next: SurrenderLine[]) =>
      setRequestLines(
        request.id,
        next.map((line) => ({
          lineNo: line.lineNo,
          accountNo: line.accountNo,
          amount: line.amount,
          actualSpent: line.actualSpent,
          cashReceiptNo: line.cashReceiptNo,
          cashReceiptAmount: line.cashReceiptAmount,
        })),
      ),
    onSuccess: (updated) => {
      toast.success('Expenditure saved to Business Central')
      setLines(allLinesFromRequest(updated))
      onChanged()
    },
    onError: (error) =>
      toast.error(
        error instanceof Error ? error.message : 'Could not save lines',
        'Save failed',
      ),
  })

  if (lines.length === 0) {
    return (
      <p className="text-sm text-slate-500">
        No surrender lines in Business Central yet. Re-open the surrender or check the source
        imprest.
      </p>
    )
  }

  const setLineField = (line: SurrenderLine, patch: Partial<SurrenderLine>) =>
    setLines((current) =>
      current.map((row) =>
        row.lineNo === line.lineNo && row.accountNo === line.accountNo ? { ...row, ...patch } : row,
      ),
    )

  return (
    <div className="space-y-4">
      <div className="flex flex-wrap items-center justify-between gap-2">
        <div>
          <h4 className="text-sm font-semibold text-[var(--portal-navy)]">
            Enter Actual Spent
          </h4>
          <p className="mt-0.5 text-xs text-slate-500">
            Type the amount spent on each line, save expenditure, then request approval. Per diem
            is allowed for Actual Travel Days (travel start through actual return), not one day
            only.
          </p>
        </div>
        {savedReturnDate ? (
          <span className="rounded-full bg-slate-50 px-2.5 py-1 text-xs font-medium text-slate-700 ring-1 ring-slate-200">
            Returned {formatDate(savedReturnDate)}
            {travelDays > 0 ? ` · ${travelDays} travel day${travelDays === 1 ? '' : 's'}` : ''}
          </span>
        ) : null}
      </div>

      {oneDayStamp ? (
        <div className="rounded-lg border border-amber-200 bg-amber-50 px-3 py-2 text-sm text-amber-950">
          Travel start and actual return are the same date, so Business Central currently counts{' '}
          <strong>1 travel day</strong>. Click Save expenditure again after the finance AL is
          published — it copies Travel Start Date from the source imprest (the original trip), then
          recalculates days.
        </div>
      ) : savedTravelStart ? (
        <p className="text-xs text-slate-600">
          Travel start {formatDate(savedTravelStart)}
          {savedReturnDate ? ` → return ${formatDate(savedReturnDate)}` : ''}
          {travelDays > 0 ? ` (${travelDays} day${travelDays === 1 ? '' : 's'})` : ''}.
        </p>
      ) : null}

      {editable && !savedReturnDate ? (
        <div className="rounded-lg border border-slate-200 bg-slate-50 px-3 py-3">
          <Label htmlFor="surrender-actual-return-date" className="text-sm font-medium text-slate-800">
            Confirm Actual Return Date
          </Label>
          <p className="mt-1 text-xs text-slate-500">
            Required by Business Central before Actual Spent is stored. Defaults to Expected Return
            Date.
          </p>
          <div className="mt-2 flex flex-wrap items-end gap-2">
            <Input
              id="surrender-actual-return-date"
              type="date"
              className="h-9 w-44"
              value={returnDateDraft.slice(0, 10)}
              onChange={(event) => setReturnDateDraft(event.target.value)}
            />
            <Button
              type="button"
              disabled={headerMutation.isPending || !returnDateDraft}
              onClick={() => headerMutation.mutate()}
            >
              {headerMutation.isPending ? 'Saving…' : 'Save return date'}
            </Button>
          </div>
        </div>
      ) : null}

      {duplicateAccounts.length > 0 ? (
        <div className="rounded-lg border border-amber-200 bg-amber-50 px-3 py-2 text-sm text-amber-950">
          Duplicate accounts on this draft: {duplicateAccounts.join(', ')}. After the finance AL
          hotfix is published, Save expenditure once to clear extras (or create a new surrender).
        </div>
      ) : null}

      {!editable ? (
        <p className="text-sm text-slate-600">
          This surrender is {request.status.toLowerCase()}. Expenditure below is read-only.
        </p>
      ) : null}

      <div className="overflow-x-auto rounded-xl border border-slate-200 bg-white">
        <table className="w-full text-left text-sm">
          <thead className="border-b border-slate-200 bg-slate-50 text-xs uppercase tracking-wide text-slate-500">
            <tr>
              <th className="px-3 py-2.5">Account</th>
              <th className="px-3 py-2.5">Issued</th>
              <th className="px-3 py-2.5">Actual Spent</th>
              <th className="px-3 py-2.5">Cash Receipt</th>
              <th className="px-3 py-2.5">Receipt Amt</th>
              <th className="px-3 py-2.5">Remaining</th>
            </tr>
          </thead>
          <tbody>
            {lines.map((line) => (
              <tr
                key={`${line.lineNo}-${line.accountNo}`}
                className={`border-b border-slate-100 ${line.editable ? '' : 'opacity-60'}`}
              >
                <td className="px-3 py-2.5">
                  <p className="font-medium text-slate-900">{line.accountName}</p>
                  <p className="text-xs text-slate-500">{line.accountNo || '—'}</p>
                </td>
                <td className="px-3 py-2.5">{formatCurrency(line.amount)}</td>
                <td className="min-w-[9rem] px-3 py-2.5">
                  {line.editable && canEditSpend ? (
                    <Input
                      type="number"
                      min="0"
                      step="0.01"
                      className="h-9"
                      aria-label={`Actual Spent ${line.accountName}`}
                      value={String(line.actualSpent)}
                      onChange={(event) =>
                        setLineField(line, {
                          actualSpent: Number(event.target.value || 0),
                        })
                      }
                    />
                  ) : (
                    <span className="font-medium text-slate-800">
                      {line.editable ? formatCurrency(line.actualSpent) : '—'}
                    </span>
                  )}
                </td>
                <td className="min-w-[11rem] px-3 py-2.5">
                  {line.editable && canEditSpend ? (
                    <Select
                      className="min-w-[10rem]"
                      options={receiptOptions}
                      placeholder="Select"
                      value={line.cashReceiptNo}
                      onChange={(event) =>
                        setLineField(line, { cashReceiptNo: event.target.value })
                      }
                    />
                  ) : (
                    <span className="text-slate-800">{line.cashReceiptNo || '—'}</span>
                  )}
                </td>
                <td className="min-w-[9rem] px-3 py-2.5">
                  {line.editable && canEditSpend ? (
                    <Input
                      type="number"
                      min="0"
                      step="0.01"
                      className="h-9"
                      value={String(line.cashReceiptAmount)}
                      onChange={(event) =>
                        setLineField(line, {
                          cashReceiptAmount: Number(event.target.value || 0),
                        })
                      }
                    />
                  ) : (
                    <span className="text-slate-800">
                      {line.editable ? formatCurrency(line.cashReceiptAmount) : '—'}
                    </span>
                  )}
                </td>
                <td className="px-3 py-2.5 font-medium text-slate-900">
                  {formatCurrency(remainingForLine(line))}
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {canEditSpend && editableLines.length ? (
        <div className="flex flex-wrap items-center gap-3">
          <Button
            type="button"
            disabled={mutation.isPending}
            onClick={() => mutation.mutate(lines.filter((line) => line.editable))}
          >
            {mutation.isPending ? 'Saving…' : 'Save expenditure'}
          </Button>
          <p className="text-xs text-slate-500">
            Saves Actual Spent into Business Central, then request approval.
          </p>
        </div>
      ) : null}
    </div>
  )
}
