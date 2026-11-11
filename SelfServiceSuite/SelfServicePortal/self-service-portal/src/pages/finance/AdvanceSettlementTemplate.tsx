import { useMemo, useRef, useState, type FormEvent } from 'react'
import { ArrowLeft, CalendarDays, Check, CloudUpload, Loader2, Plus, Trash2 } from 'lucide-react'
import { useQuery, useQueryClient } from '@tanstack/react-query'
import {
  createModuleRequest,
  getModuleRequest,
  uploadRequestAttachment,
} from '@/api/endpoints/requestEndpoint'
import {
  addAdvanceSettlementExpense,
  fetchAdvanceSettlementContext,
  saveAdvanceSettlementDetails,
} from '@/api/endpoints/advanceSettlement'
import { fetchPettyCashExpenseCategories } from '@/api/endpoints/pettyCashCategories'
import { useAuth } from '@/hooks/useAuth'
import { useToast } from '@/components/feedback/ToastProvider'
import { brand } from '@/config/brand'
import { imprestTypeOptions } from '@/data/essOptions'
import { cn } from '@/lib/utils'
import { formatAmount, formatDate, isPlaceholderErpDate } from '@/utils/formatters'
import { readFileAsBase64 } from '@/utils/readFileAsBase64'
import type { PortalRequest } from '@/types/erp.types'

const module = { module: 'imprestSurrender' as const, entity: 'selfServiceImprestSurrenders' }
const MAX_FILE_BYTES = 10 * 1024 * 1024

const fieldClass =
  'w-full rounded-xl border border-transparent bg-slate-100 px-3.5 py-3 text-sm text-slate-900 outline-none transition placeholder:text-slate-400 focus:border-teal-300 focus:bg-white focus:ring-2 focus:ring-teal-100 disabled:cursor-not-allowed disabled:opacity-70'
const labelClass = 'mb-1.5 block text-sm font-medium text-slate-700'

type ExpenseLine = {
  id: string
  category: string
  description: string
  amount: string
  files: File[]
}

type Props = {
  onCreated: (request: PortalRequest) => void
  onCancel: () => void
}

function newExpenseLine(): ExpenseLine {
  return {
    id: `${Date.now()}-${Math.random().toString(36).slice(2, 8)}`,
    category: '',
    description: '',
    amount: '',
    files: [],
  }
}

function isBlockedPaymentCode(value: string, label: string) {
  const hay = `${value} ${label}`.toUpperCase()
  return (
    hay.includes('SUPPLIER') ||
    hay.includes('VEND') ||
    hay.includes('WHT') ||
    hay.includes('WITHHOLD')
  )
}

export function AdvanceSettlementTemplate({ onCreated, onCancel }: Props) {
  const { employee } = useAuth()
  const toast = useToast()
  const queryClient = useQueryClient()
  const fileRefs = useRef<Record<string, HTMLInputElement | null>>({})
  const refundFileRef = useRef<HTMLInputElement>(null)
  const claimFileRef = useRef<HTMLInputElement>(null)

  const contextQuery = useQuery({
    queryKey: ['finance', 'advance-settlement', 'context', employee?.employeeNo ?? ''],
    queryFn: () => fetchAdvanceSettlementContext('', employee?.employeeNo ?? ''),
    enabled: Boolean(employee?.employeeNo),
  })
  const categoriesQuery = useQuery({
    queryKey: ['advance-settlement-expense-categories'],
    queryFn: fetchPettyCashExpenseCategories,
    staleTime: 5 * 60 * 1000,
  })

  const settleable = contextQuery.data?.settleableAdvances ?? []

  const [advanceNo, setAdvanceNo] = useState('')
  const [expenseLines, setExpenseLines] = useState<ExpenseLine[]>([newExpenseLine()])
  const [refundDate, setRefundDate] = useState('')
  const [refundReference, setRefundReference] = useState('')
  const [refundFiles, setRefundFiles] = useState<File[]>([])
  const [claimJustification, setClaimJustification] = useState('')
  const [claimFiles, setClaimFiles] = useState<File[]>([])
  const [remarks, setRemarks] = useState('')
  const [agreed, setAgreed] = useState(false)
  const [showSummary, setShowSummary] = useState(true)
  const [submitting, setSubmitting] = useState(false)
  const [error, setError] = useState('')

  const selectedAdvance = settleable.find((row) => row.advanceNo === advanceNo)
  const advanceAmount = Number(selectedAdvance?.amount ?? 0)
  const advancePurpose =
    selectedAdvance?.requestPurposeText || selectedAdvance?.purpose || 'Official business / activity'
  const paymentDateRaw = String(selectedAdvance?.date ?? '')
  const paymentDate =
    paymentDateRaw && !isPlaceholderErpDate(paymentDateRaw) ? formatDate(paymentDateRaw) : ''
  const employeeName = employee?.displayName ?? ''
  const staffNo = employee?.employeeNo ?? ''
  const department = employee?.departmentName || employee?.departmentCode || ''

  const totalExpenses = expenseLines.reduce((sum, line) => sum + (Number(line.amount) || 0), 0)
  const balance = advanceAmount - totalExpenses
  const outcome =
    !advanceNo || !(advanceAmount > 0) || !(totalExpenses > 0)
      ? 'pending'
      : Math.abs(balance) < 0.005
        ? 'fullySettled'
        : balance > 0
          ? 'refundDue'
          : 'additionalClaim'
  const refundDue = outcome === 'refundDue' ? balance : 0
  const claimDue = outcome === 'additionalClaim' ? Math.abs(balance) : 0

  const categoryOptions = useMemo(() => {
    const fromBc = (categoriesQuery.data?.rows ?? []).filter(
      (row) => !isBlockedPaymentCode(row.value, row.label),
    )
    if (fromBc.length > 0) return fromBc
    return imprestTypeOptions.filter((row) => !isBlockedPaymentCode(row.value, row.label))
  }, [categoriesQuery.data?.rows])

  const emptyAdvanceHint = contextQuery.isLoading
    ? 'Loading settleable advances…'
    : contextQuery.isError
      ? 'Could not load settleable advances from Business Central.'
      : settleable.length === 0
        ? 'No approved and paid advance is available to settle.'
        : 'Select / Search document number'

  const canSubmit = useMemo(() => {
    if (!agreed || submitting || !advanceNo) return false
    if (
      expenseLines.some(
        (line) =>
          !line.category.trim() ||
          line.description.trim().length < 3 ||
          !(Number(line.amount) > 0) ||
          line.files.length === 0,
      )
    ) {
      return false
    }
    if (outcome === 'refundDue' && (!refundDate || !refundReference.trim() || refundFiles.length === 0)) {
      return false
    }
    if (
      outcome === 'additionalClaim' &&
      (claimJustification.trim().length < 3 || claimFiles.length === 0)
    ) {
      return false
    }
    return outcome !== 'pending'
  }, [
    agreed,
    advanceNo,
    claimFiles.length,
    claimJustification,
    expenseLines,
    outcome,
    refundDate,
    refundFiles.length,
    refundReference,
    submitting,
  ])

  const pickFiles = (list: FileList | null, apply: (files: File[]) => void) => {
    if (!list?.length) return
    const next: File[] = []
    for (const file of Array.from(list)) {
      if (file.size > MAX_FILE_BYTES) {
        toast.error(`${file.name} is larger than 10 MB.`, 'File too large')
        continue
      }
      next.push(file)
    }
    apply(next)
  }

  const updateExpense = (id: string, patch: Partial<ExpenseLine>) => {
    setExpenseLines((rows) => rows.map((row) => (row.id === id ? { ...row, ...patch } : row)))
  }

  const handleSubmit = async (event: FormEvent) => {
    event.preventDefault()
    setError('')
    if (!canSubmit) {
      setError('Complete all required settlement fields before submitting.')
      return
    }

    setSubmitting(true)
    try {
      let request = await createModuleRequest(module, {
        imprest: advanceNo,
        imprestIssueDocNo: advanceNo,
        title: `Settlement for ${advanceNo}`,
      })

      const surrenderNo = String(request.requestNo ?? '').trim()
      if (!surrenderNo) {
        throw new Error('Business Central did not return a settlement document number.')
      }

      for (const line of expenseLines) {
        await addAdvanceSettlementExpense({
          surrenderNo,
          expenseCategory: line.category.trim(),
          expenseDescription: line.description.trim(),
          expenseAmount: Number(line.amount) || 0,
        })
      }

      await saveAdvanceSettlementDetails({
        surrenderNo,
        refundDateText: outcome === 'refundDue' ? refundDate : '',
        refundPaymentReference: outcome === 'refundDue' ? refundReference.trim() : '',
        additionalClaimJustification:
          outcome === 'additionalClaim' ? claimJustification.trim() : '',
        declarationConfirmed: true,
        settlementRemarks: remarks.trim(),
      })

      const allFiles: Array<{ file: File; description: string }> = []
      for (const line of expenseLines) {
        for (const file of line.files) {
          allFiles.push({
            file,
            description: `Expense: ${line.category} — ${line.description}`.slice(0, 100),
          })
        }
      }
      for (const file of refundFiles) {
        allFiles.push({ file, description: 'Refund proof of payment' })
      }
      for (const file of claimFiles) {
        allFiles.push({ file, description: 'Additional reimbursement supporting document' })
      }

      for (const item of allFiles) {
        const contentBase64 = await readFileAsBase64(item.file)
        request = await uploadRequestAttachment(request.id, {
          fileName: item.file.name,
          fileType: item.file.type || 'application/octet-stream',
          size: item.file.size,
          contentBase64,
          description: item.description,
        })
      }

      request = await getModuleRequest(module, request.id).catch(() => request)

      await queryClient.invalidateQueries({ queryKey: ['finance', 'advance-settlement'] })
      toast.success('Advance settlement draft created. Review and request approval.')
      onCreated(request)
    } catch (err) {
      const message = err instanceof Error ? err.message : 'Could not create advance settlement.'
      setError(message)
      toast.error(message, 'Submit failed')
    } finally {
      setSubmitting(false)
    }
  }

  return (
    <div className="mx-auto w-full max-w-3xl">
      <button
        type="button"
        onClick={onCancel}
        className="mb-4 inline-flex items-center gap-1.5 text-sm font-medium text-slate-600 hover:text-slate-900"
      >
        <ArrowLeft className="h-4 w-4" />
        Back to list
      </button>

      <form
        onSubmit={(event) => void handleSubmit(event)}
        className="overflow-hidden rounded-2xl border border-slate-200/80 bg-white shadow-[0_18px_50px_-28px_rgba(15,23,42,0.35)]"
      >
        <div className="border-b border-slate-100 px-6 py-5 sm:px-8">
          <div className="flex items-start justify-between gap-3">
            <p className="text-sm font-semibold tracking-wide text-slate-800">{brand.company.toUpperCase()}</p>
            <span className="rounded-full bg-sky-100 px-2.5 py-0.5 text-[11px] font-semibold uppercase tracking-wide text-sky-700">
              ESSP
            </span>
          </div>
          <h1 className="mt-4 text-2xl font-bold tracking-tight text-slate-900 sm:text-[1.75rem]">
            Advance Settlement
          </h1>
          <p className="mt-1.5 text-sm text-slate-500">
            Settle a paid Advance Payment by submitting actual expenses and reconciling the balance.
          </p>
        </div>

        <div className="space-y-8 px-6 py-6 sm:px-8 sm:py-7">
          <section>
            <h2 className="mb-4 text-base font-semibold text-slate-900">Advance Payment Information</h2>
            <div className="space-y-4">
              <div>
                <label className={labelClass} htmlFor="as-advance-no">
                  Advance Payment Request Document No.
                </label>
                <select
                  id="as-advance-no"
                  className={cn(fieldClass, 'appearance-none')}
                  value={advanceNo}
                  onChange={(event) => setAdvanceNo(event.target.value)}
                  required
                >
                  <option value="">{emptyAdvanceHint}</option>
                  {settleable.map((row) => (
                    <option key={row.advanceNo} value={row.advanceNo}>
                      {row.advanceNo} — {formatAmount(row.amount)}
                    </option>
                  ))}
                </select>
                <p className="mt-1.5 text-xs text-slate-500">
                  Only approved and paid advance documents from Business Central are listed.
                </p>
              </div>

              <div className="grid gap-4 sm:grid-cols-2">
                <div>
                  <label className={labelClass} htmlFor="as-employee">
                    Employee Name
                  </label>
                  <input id="as-employee" className={fieldClass} value={employeeName} readOnly disabled />
                </div>
                <div>
                  <label className={labelClass} htmlFor="as-staff">
                    Staff Number
                  </label>
                  <input id="as-staff" className={fieldClass} value={staffNo} readOnly disabled />
                </div>
                <div>
                  <label className={labelClass} htmlFor="as-department">
                    Department
                  </label>
                  <input id="as-department" className={fieldClass} value={department} readOnly disabled />
                </div>
                <div>
                  <label className={labelClass} htmlFor="as-purpose">
                    Advance Purpose
                  </label>
                  <input id="as-purpose" className={fieldClass} value={advancePurpose} readOnly disabled />
                </div>
                <div>
                  <label className={labelClass} htmlFor="as-amount">
                    Advance Amount
                  </label>
                  <input
                    id="as-amount"
                    className={fieldClass}
                    value={advanceNo ? formatAmount(advanceAmount) : ''}
                    placeholder="Auto-populated"
                    readOnly
                    disabled
                  />
                </div>
                <div>
                  <label className={labelClass} htmlFor="as-payment-date">
                    Payment Date
                  </label>
                  <input
                    id="as-payment-date"
                    className={fieldClass}
                    value={paymentDate}
                    placeholder="Auto-populated"
                    readOnly
                    disabled
                  />
                </div>
              </div>
            </div>
          </section>

          <section>
            <h2 className="mb-4 text-base font-semibold text-slate-900">Actual Expense Details</h2>
            <div className="space-y-4">
              {expenseLines.map((line, index) => (
                <div key={line.id} className="space-y-4 rounded-xl border border-slate-200 bg-slate-50/60 p-4">
                  <div className="flex items-center justify-between gap-3">
                    <p className="text-sm font-semibold text-slate-800">Expense Line {index + 1}</p>
                    {expenseLines.length > 1 ? (
                      <button
                        type="button"
                        className="inline-flex items-center gap-1 text-xs font-medium text-red-600 hover:text-red-700"
                        onClick={() =>
                          setExpenseLines((rows) => rows.filter((row) => row.id !== line.id))
                        }
                      >
                        <Trash2 className="h-3.5 w-3.5" />
                        Remove
                      </button>
                    ) : null}
                  </div>

                  <div>
                    <label className={labelClass} htmlFor={`as-cat-${line.id}`}>
                      Expense Category
                    </label>
                    <select
                      id={`as-cat-${line.id}`}
                      className={cn(fieldClass, 'appearance-none')}
                      value={line.category}
                      onChange={(event) => updateExpense(line.id, { category: event.target.value })}
                      required
                    >
                      <option value="">
                        {categoriesQuery.isLoading ? 'Loading categories…' : 'Select expense category'}
                      </option>
                      {categoryOptions.map((option) => (
                        <option key={option.value} value={option.value}>
                          {option.label}
                        </option>
                      ))}
                    </select>
                    <p className="mt-1.5 text-xs text-slate-500">
                      Categories come from Business Central Receipts &amp; Payment Types with a G/L
                      account.
                    </p>
                  </div>

                  <div>
                    <label className={labelClass} htmlFor={`as-desc-${line.id}`}>
                      Expense Description
                    </label>
                    <textarea
                      id={`as-desc-${line.id}`}
                      className={cn(fieldClass, 'min-h-[88px] resize-y')}
                      placeholder="Describe the expense…"
                      value={line.description}
                      onChange={(event) => updateExpense(line.id, { description: event.target.value })}
                      required
                    />
                  </div>

                  <div>
                    <label className={labelClass} htmlFor={`as-amt-${line.id}`}>
                      Expense Amount
                    </label>
                    <input
                      id={`as-amt-${line.id}`}
                      type="number"
                      min="0.01"
                      step="0.01"
                      className={fieldClass}
                      placeholder="Enter amount"
                      value={line.amount}
                      onChange={(event) => updateExpense(line.id, { amount: event.target.value })}
                      required
                    />
                  </div>

                  <div>
                    <label className={labelClass}>Supporting Documents</label>
                    <input
                      ref={(node) => {
                        fileRefs.current[line.id] = node
                      }}
                      type="file"
                      className="hidden"
                      multiple
                      onChange={(event) => {
                        pickFiles(event.target.files, (files) =>
                          updateExpense(line.id, { files: [...line.files, ...files] }),
                        )
                        event.target.value = ''
                      }}
                    />
                    <button
                      type="button"
                      onClick={() => fileRefs.current[line.id]?.click()}
                      className="flex w-full flex-col items-center justify-center rounded-xl border border-dashed border-slate-300 bg-white px-4 py-6 text-center transition hover:border-teal-300 hover:bg-teal-50/40"
                    >
                      <CloudUpload className="mb-2 h-7 w-7 text-slate-400" />
                      <p className="text-sm font-medium text-slate-700">Upload receipts / invoices</p>
                      <p className="mt-1 text-xs text-slate-500">
                        Attach supporting documents for this expense line.
                      </p>
                    </button>
                    {line.files.length > 0 ? (
                      <ul className="mt-2 space-y-1.5">
                        {line.files.map((file, fileIndex) => (
                          <li
                            key={`${file.name}-${fileIndex}`}
                            className="flex items-center justify-between rounded-lg bg-white px-3 py-2 text-xs text-slate-700"
                          >
                            <span className="truncate pr-3">
                              {file.name} · {(file.size / 1024).toFixed(0)} KB
                            </span>
                            <button
                              type="button"
                              className="font-medium text-red-600"
                              onClick={() =>
                                updateExpense(line.id, {
                                  files: line.files.filter((_, i) => i !== fileIndex),
                                })
                              }
                            >
                              Remove
                            </button>
                          </li>
                        ))}
                      </ul>
                    ) : null}
                  </div>
                </div>
              ))}

              <button
                type="button"
                onClick={() => setExpenseLines((rows) => [...rows, newExpenseLine()])}
                className="inline-flex w-full items-center justify-center gap-2 rounded-xl border border-slate-300 bg-white px-4 py-3 text-sm font-semibold text-slate-800 transition hover:border-teal-300 hover:bg-teal-50/50"
              >
                <Plus className="h-4 w-4" />
                Add More Expense Lines
              </button>
            </div>
          </section>

          <section className="rounded-xl border border-slate-200 px-4 py-4 sm:px-5">
            <h2 className="mb-2 text-base font-semibold text-slate-900">Financial Reconciliation</h2>
            <p className="mb-3 text-xs text-slate-500">
              Calculated from the selected advance and the expense amounts below.
            </p>
            <div className="space-y-2 text-sm">
              <div className="flex justify-between gap-3">
                <span className="text-slate-600">Total advance received</span>
                <span className="font-semibold">{formatAmount(advanceAmount || 0)}</span>
              </div>
              <div className="flex justify-between gap-3">
                <span className="text-slate-600">Total actual expenses</span>
                <span className="font-semibold">{formatAmount(totalExpenses)}</span>
              </div>
              <div className="flex justify-between gap-3 border-t border-slate-200 pt-2">
                <span className="text-slate-600">Settlement balance</span>
                <span className="text-lg font-bold text-slate-900">
                  {formatAmount(Math.abs(balance) || 0)}
                </span>
              </div>
            </div>
            <div className="mt-3">
              {outcome === 'fullySettled' ? (
                <span className="inline-flex rounded-full bg-emerald-100 px-2.5 py-1 text-xs font-semibold text-emerald-800">
                  Fully Settled
                </span>
              ) : null}
              {outcome === 'refundDue' ? (
                <span className="inline-flex rounded-full bg-orange-100 px-2.5 py-1 text-xs font-semibold text-orange-800">
                  Refund due to organization
                </span>
              ) : null}
              {outcome === 'additionalClaim' ? (
                <span className="inline-flex rounded-full bg-amber-100 px-2.5 py-1 text-xs font-semibold text-amber-900">
                  Additional Reimbursement Claim
                </span>
              ) : null}
            </div>
          </section>

          {outcome === 'refundDue' ? (
            <section>
              <h2 className="mb-4 text-base font-semibold text-slate-900">Advance Refund Details</h2>
              <div className="space-y-4">
                <div>
                  <label className={labelClass} htmlFor="as-refund-amount">
                    Amount to be refunded
                  </label>
                  <input
                    id="as-refund-amount"
                    className={fieldClass}
                    value={formatAmount(refundDue)}
                    readOnly
                    disabled
                  />
                </div>
                <div>
                  <label className={labelClass} htmlFor="as-refund-date">
                    Repayment Date
                  </label>
                  <div className="relative">
                    <input
                      id="as-refund-date"
                      type="date"
                      className={cn(fieldClass, 'pr-10')}
                      value={refundDate}
                      onChange={(event) => setRefundDate(event.target.value)}
                      required
                    />
                    <CalendarDays className="pointer-events-none absolute right-3 top-1/2 h-4 w-4 -translate-y-1/2 text-slate-400" />
                  </div>
                </div>
                <div>
                  <label className={labelClass} htmlFor="as-refund-ref">
                    Refund Payment Reference
                  </label>
                  <input
                    id="as-refund-ref"
                    className={fieldClass}
                    placeholder="Enter payment receipt/reference"
                    value={refundReference}
                    onChange={(event) => setRefundReference(event.target.value)}
                    required
                  />
                </div>
                <div>
                  <label className={labelClass}>Refund Receipt / Proof of Payment</label>
                  <input
                    ref={refundFileRef}
                    type="file"
                    className="hidden"
                    multiple
                    onChange={(event) => {
                      pickFiles(event.target.files, (files) =>
                        setRefundFiles((prev) => [...prev, ...files]),
                      )
                      event.target.value = ''
                    }}
                  />
                  <button
                    type="button"
                    onClick={() => refundFileRef.current?.click()}
                    className="flex w-full flex-col items-center justify-center rounded-xl border border-dashed border-slate-300 bg-slate-50 px-4 py-6 text-center"
                  >
                    <CloudUpload className="mb-2 h-7 w-7 text-slate-400" />
                    <p className="text-sm font-medium text-slate-700">Attach proof of refund</p>
                  </button>
                  {refundFiles.length > 0 ? (
                    <ul className="mt-2 space-y-1.5">
                      {refundFiles.map((file, index) => (
                        <li
                          key={`${file.name}-${index}`}
                          className="flex items-center justify-between rounded-lg bg-slate-50 px-3 py-2 text-xs"
                        >
                          <span className="truncate pr-3">{file.name}</span>
                          <button
                            type="button"
                            className="font-medium text-red-600"
                            onClick={() => setRefundFiles((prev) => prev.filter((_, i) => i !== index))}
                          >
                            Remove
                          </button>
                        </li>
                      ))}
                    </ul>
                  ) : null}
                </div>
              </div>
            </section>
          ) : null}

          {outcome === 'additionalClaim' ? (
            <section>
              <h2 className="mb-4 text-base font-semibold text-slate-900">
                Additional Reimbursement Claim
              </h2>
              <div className="space-y-4">
                <div>
                  <label className={labelClass} htmlFor="as-claim-amount">
                    Additional amount claimed
                  </label>
                  <input
                    id="as-claim-amount"
                    className={fieldClass}
                    value={formatAmount(claimDue)}
                    readOnly
                    disabled
                  />
                </div>
                <div>
                  <label className={labelClass} htmlFor="as-claim-justification">
                    Justification for exceeding the advance
                  </label>
                  <textarea
                    id="as-claim-justification"
                    className={cn(fieldClass, 'min-h-[88px] resize-y')}
                    placeholder="Explain why expenses exceeded the advance…"
                    value={claimJustification}
                    onChange={(event) => setClaimJustification(event.target.value)}
                    required
                  />
                </div>
                <div>
                  <label className={labelClass}>Supporting receipts / documents</label>
                  <input
                    ref={claimFileRef}
                    type="file"
                    className="hidden"
                    multiple
                    onChange={(event) => {
                      pickFiles(event.target.files, (files) =>
                        setClaimFiles((prev) => [...prev, ...files]),
                      )
                      event.target.value = ''
                    }}
                  />
                  <button
                    type="button"
                    onClick={() => claimFileRef.current?.click()}
                    className="flex w-full flex-col items-center justify-center rounded-xl border border-dashed border-slate-300 bg-slate-50 px-4 py-6 text-center"
                  >
                    <CloudUpload className="mb-2 h-7 w-7 text-slate-400" />
                    <p className="text-sm font-medium text-slate-700">Attach supporting documents</p>
                  </button>
                  {claimFiles.length > 0 ? (
                    <ul className="mt-2 space-y-1.5">
                      {claimFiles.map((file, index) => (
                        <li
                          key={`${file.name}-${index}`}
                          className="flex items-center justify-between rounded-lg bg-slate-50 px-3 py-2 text-xs"
                        >
                          <span className="truncate pr-3">{file.name}</span>
                          <button
                            type="button"
                            className="font-medium text-red-600"
                            onClick={() => setClaimFiles((prev) => prev.filter((_, i) => i !== index))}
                          >
                            Remove
                          </button>
                        </li>
                      ))}
                    </ul>
                  ) : null}
                </div>
              </div>
            </section>
          ) : null}

          <section className="rounded-xl bg-slate-50 px-4 py-4 sm:px-5">
            <h2 className="mb-2 text-base font-semibold text-slate-900">Declaration</h2>
            <p className="text-sm leading-relaxed text-slate-600">
              I confirm that the expenses submitted are actual expenses incurred for the approved
              purpose and that the attached supporting documents are genuine and accurate.
            </p>
            <button
              type="button"
              onClick={() => setAgreed((value) => !value)}
              className="mt-4 flex items-center gap-2.5 text-sm font-medium text-slate-800"
            >
              <span
                className={cn(
                  'flex h-5 w-5 items-center justify-center rounded-full border-2 transition',
                  agreed
                    ? 'border-teal-600 bg-teal-600 text-white'
                    : 'border-slate-300 bg-white text-transparent',
                )}
                aria-hidden
              >
                <Check className="h-3 w-3" strokeWidth={3} />
              </span>
              I confirm the accuracy of the information submitted.
            </button>

            <div className="mt-4">
              <label className={labelClass} htmlFor="as-remarks">
                Additional Remarks
              </label>
              <textarea
                id="as-remarks"
                className={cn(fieldClass, 'min-h-[80px] resize-y')}
                placeholder="Enter any additional remarks…"
                value={remarks}
                onChange={(event) => setRemarks(event.target.value)}
              />
            </div>

            <button
              type="button"
              onClick={() => setShowSummary((value) => !value)}
              className="mt-4 w-full rounded-xl bg-slate-900 px-4 py-3 text-sm font-semibold text-white"
            >
              {showSummary ? 'Hide submission summary' : 'Show submission summary'}
            </button>

            {showSummary ? (
              <div className="mt-3 rounded-xl border border-slate-200 bg-white px-4 py-4 text-sm">
                <p className="mb-3 font-semibold text-slate-900">Settlement Summary</p>
                <div className="space-y-1.5 text-slate-700">
                  <div className="flex justify-between gap-3">
                    <span>Advance</span>
                    <span>{formatAmount(advanceAmount || 0)}</span>
                  </div>
                  <div className="flex justify-between gap-3">
                    <span>Expenses</span>
                    <span>{formatAmount(totalExpenses)}</span>
                  </div>
                  <div className="flex justify-between gap-3">
                    <span>Outcome</span>
                    <span>
                      {outcome === 'refundDue'
                        ? 'Refund'
                        : outcome === 'additionalClaim'
                          ? 'Additional Claim'
                          : outcome === 'fullySettled'
                            ? 'Fully Settled'
                            : '—'}
                    </span>
                  </div>
                  <div className="flex justify-between gap-3 border-t border-slate-200 pt-2 font-semibold text-slate-900">
                    <span>Balance</span>
                    <span>{formatAmount(Math.abs(balance) || 0)}</span>
                  </div>
                </div>
              </div>
            ) : null}
          </section>

          {error ? (
            <div className="rounded-xl border border-red-200 bg-red-50 px-3 py-2 text-sm text-red-700">
              {error}
            </div>
          ) : null}

          <button
            type="submit"
            disabled={!canSubmit}
            className={cn(
              'flex w-full items-center justify-center gap-2 rounded-xl px-4 py-3.5 text-sm font-semibold transition',
              canSubmit
                ? 'bg-[var(--portal-navy,#0f766e)] text-white hover:opacity-95'
                : 'cursor-not-allowed bg-slate-200 text-slate-500',
            )}
          >
            {submitting ? <Loader2 className="h-4 w-4 animate-spin" /> : null}
            {submitting ? 'Submitting…' : 'Submit Advance Settlement'}
          </button>

          <p className="text-center text-[11px] text-slate-400">ESSP Advance Settlement</p>
        </div>
      </form>
    </div>
  )
}
