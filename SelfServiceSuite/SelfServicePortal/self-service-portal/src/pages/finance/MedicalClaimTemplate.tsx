import { useEffect, useMemo, useRef, useState, type FormEvent } from 'react'
import { AlertTriangle, ArrowLeft, Check, CloudUpload, Loader2, Plus, Trash2 } from 'lucide-react'
import { useQuery, useQueryClient } from '@tanstack/react-query'
import {
  addRequestLine,
  createModuleRequest,
  getModuleRequest,
  uploadRequestAttachment,
} from '@/api/endpoints/requestEndpoint'
import { validateHospitalCategory } from '@/api/endpoints/claimCalc'
import { getEmployeeMedicalBalances } from '@/api/endpoints/profile'
import { fetchMonthlySalaryBase } from '@/api/endpoints/hrServiceLetters'
import type { LookupOption } from '@/api/endpoints/lookups'
import { useAuth } from '@/hooks/useAuth'
import { useToast } from '@/components/feedback/ToastProvider'
import { brand } from '@/config/brand'
import { hospitalCategoryOptions } from '@/data/essOptions'
import { cn } from '@/lib/utils'
import { formatAmount, formatDate } from '@/utils/formatters'
import { readFileAsBase64 } from '@/utils/readFileAsBase64'
import { todayIsoDate } from '@/utils/validators'
import {
  annualMedicalEntitlement,
  calculateMedicalClaim,
  categoryAllocation,
  MEDICAL_POLICY,
  type MedicalCategory,
} from '@/utils/medicalClaimPolicy'
import type { PortalRequest } from '@/types/erp.types'

const module = { module: 'staffClaim' as const, entity: 'selfServiceStaffClaims' }
const MAX_FILE_BYTES = 10 * 1024 * 1024

const fieldClass =
  'w-full rounded-xl border border-transparent bg-slate-100 px-3.5 py-3 text-sm text-slate-900 outline-none transition placeholder:text-slate-400 focus:border-teal-300 focus:bg-white focus:ring-2 focus:ring-teal-100 disabled:cursor-not-allowed disabled:opacity-70'
const labelClass = 'mb-1.5 block text-sm font-medium text-slate-700'

type Receipt = {
  id: string
  hospitalCategory: string
  receiptNo: string
  description: string
  amount: string
  files: File[]
}

/** Per-receipt refund from BC FetchMedicalClaimAmountPolicy (1.0.3.631+). */
type BcReceiptRefund = {
  reimbursement: number
  availableBalance: number | null
  remainingBalance: number | null
  budgetCapped: boolean
  usedBcPolicy: boolean
}

type Props = {
  /** Business Central MEDICAL claim type code. */
  claimType: string
  /** G/L account of the claim type (or Medical Allowance); blank lets the backend resolve it. */
  accountNo: string
  dependants: LookupOption[]
  dependantsLoading: boolean
  onCreated: (request: PortalRequest) => void
  onCancel: () => void
}

function newReceipt(): Receipt {
  return {
    id: `${Date.now()}-${Math.random().toString(36).slice(2, 8)}`,
    hospitalCategory: '',
    receiptNo: '',
    description: '',
    amount: '',
    files: [],
  }
}

function finite(value: unknown): number | null {
  const parsed = Number(value)
  return value === undefined || value === null || value === '' || !Number.isFinite(parsed) ? null : parsed
}

function money(value: number | null) {
  return value === null ? '—' : formatAmount(value)
}

export function MedicalClaimTemplate({
  claimType,
  accountNo,
  dependants,
  dependantsLoading,
  onCreated,
  onCancel,
}: Props) {
  const { employee } = useAuth()
  const toast = useToast()
  const queryClient = useQueryClient()
  const fileRefs = useRef<Record<string, HTMLInputElement | null>>({})
  const claimDate = todayIsoDate()

  const balancesQuery = useQuery({
    queryKey: ['profile', 'medical-balances'],
    queryFn: getEmployeeMedicalBalances,
    staleTime: 30_000,
  })
  const salaryQuery = useQuery({
    queryKey: ['hr', 'monthly-salary-base'],
    queryFn: fetchMonthlySalaryBase,
    staleTime: 5 * 60_000,
    // Only needed when Business Central does not return the allocation (before BC 1.0.3.638).
    enabled: balancesQuery.isSuccess && finite(balancesQuery.data?.entitlement) === null,
  })

  const [patient, setPatient] = useState<MedicalCategory>('self')
  const [dependant, setDependant] = useState('')
  const [receipts, setReceipts] = useState<Receipt[]>([newReceipt()])
  const [bcRefunds, setBcRefunds] = useState<Record<string, BcReceiptRefund>>({})
  const [policyLoading, setPolicyLoading] = useState(false)
  const [agreed, setAgreed] = useState(false)
  const [submitting, setSubmitting] = useState(false)
  const [error, setError] = useState('')
  const policyRequest = useRef(0)

  const employeeName = employee?.displayName ?? ''
  const staffNo = employee?.employeeNo ?? ''
  const department = employee?.departmentName || employee?.departmentCode || ''

  const selectedDependant = dependants.find((option) => option.value === dependant)
  const dependantName = selectedDependant?.label.replace(/\s*\([^)]*\)\s*$/, '') ?? ''
  const relationship = String(selectedDependant?.meta?.relationship ?? '')
  const dateOfBirth = String(selectedDependant?.meta?.dateOfBirth ?? '')

  // Policy sections 1–2: entitlement and the two separate budgets.
  const balances = balancesQuery.data
  const entitlement =
    finite(balances?.entitlement) ??
    (finite(balances?.selfAllocation) !== null && finite(balances?.dependantAllocation) !== null
      ? (finite(balances?.selfAllocation) ?? 0) + (finite(balances?.dependantAllocation) ?? 0)
      : salaryQuery.data
        ? annualMedicalEntitlement(salaryQuery.data)
        : null)
  const budget = {
    self: {
      allocation: finite(balances?.selfAllocation) ?? (entitlement === null ? null : categoryAllocation(entitlement)),
      used: finite(balances?.selfUsed),
      available: finite(balances?.self),
    },
    dependant: {
      allocation:
        finite(balances?.dependantAllocation) ?? (entitlement === null ? null : categoryAllocation(entitlement)),
      used: finite(balances?.dependantUsed),
      available: finite(balances?.dependant),
    },
  }
  const categoryLabel = patient === 'dependant' ? 'Dependents' : 'Self'

  // Local preview (same 80% + budget arithmetic) when BC policy is unreachable.
  const calc = useMemo(
    () => calculateMedicalClaim(receipts.map((row) => Number(row.amount) || 0), budget[patient].available),
    // budget[patient].available is a primitive derived from balances
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [receipts, patient, balances?.self, balances?.dependant],
  )

  // Nitish 1.0.3.631: call FetchMedicalClaimAmountPolicy as each receipt amount/category is entered.
  useEffect(() => {
    if (patient === 'dependant' && !dependant) {
      setBcRefunds({})
      return
    }
    const ready = receipts.filter((row) => row.hospitalCategory && Number(row.amount) > 0)
    if (!ready.length) {
      setBcRefunds({})
      return
    }
    const requestKey = ++policyRequest.current
    setPolicyLoading(true)
    void (async () => {
      const next: Record<string, BcReceiptRefund> = {}
      let remaining: number | null = budget[patient].available
      for (const row of ready) {
        try {
          const data = await validateHospitalCategory({
            medicalAmount: Number(row.amount),
            hospitalCategory: row.hospitalCategory,
            patient,
            dependant: patient === 'dependant' ? dependant : '',
          })
          if (requestKey !== policyRequest.current) return
          let reimbursement = Number(data.AmountToRefund ?? data.amountToRefund ?? data.Amount ?? data.amount ?? 0)
          if (!Number.isFinite(reimbursement) || reimbursement < 0) reimbursement = 0
          // Draft lines are not yet in BC — keep sequential cap across this form.
          if (remaining !== null && Number.isFinite(remaining)) {
            reimbursement = Math.min(reimbursement, Math.max(0, remaining))
            remaining = Math.round((remaining - reimbursement) * 100) / 100
          }
          const available = Number(data.availableBalance)
          next[row.id] = {
            reimbursement,
            availableBalance: Number.isFinite(available) ? available : null,
            remainingBalance: remaining,
            budgetCapped: Boolean(data.budgetCapped) || reimbursement < Number(row.amount) * 0.8 - 0.01,
            usedBcPolicy: Boolean(data.usedBcPolicy ?? true),
          }
        } catch {
          // Keep local calc for this row.
        }
      }
      if (requestKey !== policyRequest.current) return
      setBcRefunds(next)
      setPolicyLoading(false)
    })()
    return () => {
      policyRequest.current += 1
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [
    patient,
    dependant,
    budget.self.available,
    budget.dependant.available,
    receipts.map((row) => `${row.id}:${row.hospitalCategory}:${row.amount}`).join('|'),
  ])

  const reimbursementFor = (rowId: string, index: number) => {
    const bc = bcRefunds[rowId]
    if (bc) return bc.reimbursement
    return calc.receipts[index]?.reimbursement ?? 0
  }

  const totalBcReimbursement = receipts.reduce(
    (sum, row, index) => sum + reimbursementFor(row.id, index),
    0,
  )
  const totalEmployeeContribution = Math.max(
    0,
    Math.round((calc.totalReceipts - totalBcReimbursement) * 100) / 100,
  )

  const receiptProblem = (row: Receipt) => {
    if (!row.hospitalCategory) return 'hospital category'
    if (!row.receiptNo.trim()) return 'receipt number'
    if (row.description.trim().length < 3) return 'description of the treatment'
    if (!(Number(row.amount) > 0)) return 'accepted receipt amount'
    if (row.files.length === 0) return 'a copy of the receipt'
    return ''
  }

  const blocker = (() => {
    if (patient === 'dependant' && !dependant) return 'Select the dependent the claim is for.'
    const index = receipts.findIndex((row) => receiptProblem(row))
    if (index >= 0) return `Receipt ${index + 1}: enter the ${receiptProblem(receipts[index]!)}.`
    if (calc.exhausted) {
      return `The ${categoryLabel} medical claim budget is fully used. No further reimbursement is allowed this benefit period.`
    }
    if (!agreed) return 'Confirm the declaration.'
    return ''
  })()
  const canSubmit = !blocker && !submitting

  const updateReceipt = (id: string, patch: Partial<Receipt>) => {
    setReceipts((rows) => rows.map((row) => (row.id === id ? { ...row, ...patch } : row)))
  }

  const pickFiles = (id: string, list: FileList | null) => {
    if (!list?.length) return
    const next: File[] = []
    for (const file of Array.from(list)) {
      if (file.size > MAX_FILE_BYTES) {
        toast.error(`${file.name} is larger than 10 MB.`, 'File too large')
        continue
      }
      next.push(file)
    }
    setReceipts((rows) => rows.map((row) => (row.id === id ? { ...row, files: [...row.files, ...next] } : row)))
  }

  const handleSubmit = async (event: FormEvent) => {
    event.preventDefault()
    setError('')
    if (blocker) {
      setError(blocker)
      return
    }
    setSubmitting(true)
    let draftNo = ''
    try {
      const forWhom = patient === 'dependant' ? dependantName || 'Dependent' : 'Self'
      const purpose = `Medical Claim — ${forWhom}`.slice(0, 100)
      let request = await createModuleRequest(module, { claimDate, purpose, title: purpose })
      draftNo = String(request.requestNo ?? '')

      for (const [index, row] of receipts.entries()) {
        request = await addRequestLine(request.id, {
          action: 'create',
          claimType,
          accountNo,
          hospitalCategory: row.hospitalCategory,
          patient,
          relationship: patient === 'dependant' ? relationship : '',
          dependant: patient === 'dependant' ? dependant : '',
          dependantDateOfBirth: patient === 'dependant' ? dateOfBirth : '',
          medicalAmount: Number(row.amount),
          // Prefer FetchMedicalClaimAmountPolicy preview; BC revalidates again on line save / approval.
          amountToRefund: reimbursementFor(row.id, index),
          amount: reimbursementFor(row.id, index),
          claimReceiptNo: row.receiptNo.trim(),
          expenditureDate: claimDate,
          expenditureDescription: row.description.trim(),
        })
      }

      for (const row of receipts) {
        for (const file of row.files) {
          const contentBase64 = await readFileAsBase64(file)
          request = await uploadRequestAttachment(request.id, {
            fileName: file.name,
            fileType: file.type || 'application/octet-stream',
            size: file.size,
            contentBase64,
            description: `Medical receipt ${row.receiptNo.trim()}`.slice(0, 100),
          })
        }
      }

      request = await getModuleRequest(module, request.id).catch(() => request)
      await queryClient.invalidateQueries({ queryKey: ['hr', 'staff-medical-claim'] })
      await queryClient.invalidateQueries({ queryKey: ['profile', 'medical-balances'] })
      toast.success('Medical claim draft created. Review the amounts from Business Central and request approval.')
      onCreated(request)
    } catch (err) {
      const message = err instanceof Error ? err.message : 'Could not create the medical claim.'
      const full = draftNo ? `${message} (Draft ${draftNo} was created — open it from the list to complete it.)` : message
      setError(full)
      toast.error(full, 'Submit failed')
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
          <h1 className="mt-4 text-2xl font-bold tracking-tight text-slate-900 sm:text-[1.75rem]">Medical Claim</h1>
          <p className="mt-1.5 text-sm text-slate-500">
            Claim reimbursement of accepted medical receipts under the Medical Claim and Reimbursement Policy.
          </p>
        </div>

        <div className="space-y-8 px-6 py-6 sm:px-8 sm:py-7">
          <section>
            <h2 className="mb-4 text-base font-semibold text-slate-900">Employee Information</h2>
            <div className="grid gap-4 sm:grid-cols-2">
              <div>
                <label className={labelClass} htmlFor="mc-employee">Employee Name</label>
                <input id="mc-employee" className={fieldClass} value={employeeName} placeholder="Auto-filled" readOnly disabled />
              </div>
              <div>
                <label className={labelClass} htmlFor="mc-staff">Staff Number</label>
                <input id="mc-staff" className={fieldClass} value={staffNo} placeholder="Auto-filled" readOnly disabled />
              </div>
              <div>
                <label className={labelClass} htmlFor="mc-department">Department</label>
                <input id="mc-department" className={fieldClass} value={department} placeholder="Auto-filled" readOnly disabled />
              </div>
              <div>
                <label className={labelClass} htmlFor="mc-date">Claim Date</label>
                <input id="mc-date" className={fieldClass} value={formatDate(claimDate)} readOnly disabled />
              </div>
            </div>
          </section>

          <section>
            <h2 className="mb-1 text-base font-semibold text-slate-900">Medical Claim Budget</h2>
            <p className="mb-4 text-xs text-slate-500">
              Annual entitlement = Basic salary × 12 × {MEDICAL_POLICY.entitlementPercent}%, split{' '}
              {MEDICAL_POLICY.categorySharePercent}% Self and {MEDICAL_POLICY.categorySharePercent}% Dependents. Each is a
              separate budget for the benefit period.
            </p>
            {balancesQuery.isLoading ? (
              <p className="flex items-center gap-2 text-sm text-slate-500">
                <Loader2 className="h-4 w-4 animate-spin" /> Loading your medical budget from Business Central…
              </p>
            ) : balancesQuery.isError ? (
              <p className="rounded-xl border border-amber-200 bg-amber-50 px-3 py-2 text-sm text-amber-900">
                Business Central did not return your medical budget. The reimbursement is still capped by Business
                Central when the claim is saved.
              </p>
            ) : (
              <div className="grid gap-3 sm:grid-cols-3">
                <div className="rounded-xl bg-slate-50 px-4 py-3">
                  <p className="text-xs text-slate-500">Annual entitlement</p>
                  <p className="mt-1 text-lg font-semibold text-slate-900">{money(entitlement)}</p>
                </div>
                {(['self', 'dependant'] as const).map((key) => (
                  <div
                    key={key}
                    className={cn(
                      'rounded-xl px-4 py-3',
                      patient === key ? 'bg-teal-50 ring-1 ring-teal-200' : 'bg-slate-50',
                    )}
                  >
                    <p className="text-xs text-slate-500">
                      {key === 'self' ? 'Self (Employee)' : 'Dependents'} · {MEDICAL_POLICY.categorySharePercent}%
                    </p>
                    <p className="mt-1 text-lg font-semibold text-slate-900">{money(budget[key].available)}</p>
                    <p className="text-xs text-slate-500">
                      available of {money(budget[key].allocation)}
                      {budget[key].used !== null ? ` · used ${formatAmount(budget[key].used ?? 0)}` : ''}
                    </p>
                  </div>
                ))}
              </div>
            )}
          </section>

          <section>
            <h2 className="mb-4 text-base font-semibold text-slate-900">Patient</h2>
            <div className="space-y-4">
              <div className="grid grid-cols-2 gap-3">
                {(['self', 'dependant'] as const).map((key) => (
                  <button
                    key={key}
                    type="button"
                    onClick={() => {
                      setPatient(key)
                      if (key === 'self') setDependant('')
                    }}
                    className={cn(
                      'rounded-xl border px-4 py-3 text-left text-sm font-medium transition',
                      patient === key
                        ? 'border-teal-500 bg-teal-50 text-teal-900'
                        : 'border-slate-200 bg-white text-slate-700 hover:border-teal-300',
                    )}
                  >
                    {key === 'self' ? 'Self (Employee)' : 'Dependent'}
                    <span className="mt-0.5 block text-xs font-normal text-slate-500">
                      Uses the {key === 'self' ? 'Self' : 'Dependents'} budget
                    </span>
                  </button>
                ))}
              </div>
              {patient === 'dependant' ? (
                <div className="grid gap-4 sm:grid-cols-2">
                  <div className="sm:col-span-2">
                    <label className={labelClass} htmlFor="mc-dependant">Dependent</label>
                    <select
                      id="mc-dependant"
                      className={cn(fieldClass, 'appearance-none')}
                      value={dependant}
                      onChange={(event) => setDependant(event.target.value)}
                      required
                    >
                      <option value="">
                        {dependantsLoading
                          ? 'Loading dependents from Business Central…'
                          : dependants.length
                            ? 'Select dependent'
                            : 'No dependents on your HR record — ask HR to add them'}
                      </option>
                      {dependants.map((option) => (
                        <option key={option.value} value={option.value}>{option.label}</option>
                      ))}
                    </select>
                  </div>
                  <div>
                    <label className={labelClass} htmlFor="mc-relationship">Relationship</label>
                    <input id="mc-relationship" className={fieldClass} value={relationship} placeholder="From HR record" readOnly disabled />
                  </div>
                  <div>
                    <label className={labelClass} htmlFor="mc-dob">Date of Birth</label>
                    <input
                      id="mc-dob"
                      className={fieldClass}
                      value={dateOfBirth ? formatDate(dateOfBirth) : ''}
                      placeholder="From HR record"
                      readOnly
                      disabled
                    />
                  </div>
                </div>
              ) : null}
            </div>
          </section>

          <section>
            <h2 className="mb-4 text-base font-semibold text-slate-900">Medical Receipts</h2>
            <div className="space-y-4">
              {receipts.map((row, index) => {
                const line = calc.receipts[index]
                return (
                  <div key={row.id} className="space-y-4 rounded-xl border border-slate-200 bg-slate-50/60 p-4">
                    <div className="flex items-center justify-between gap-3">
                      <p className="text-sm font-semibold text-slate-800">Receipt {index + 1}</p>
                      {receipts.length > 1 ? (
                        <button
                          type="button"
                          className="inline-flex items-center gap-1 text-xs font-medium text-red-600 hover:text-red-700"
                          onClick={() => setReceipts((rows) => rows.filter((item) => item.id !== row.id))}
                        >
                          <Trash2 className="h-3.5 w-3.5" />
                          Remove
                        </button>
                      ) : null}
                    </div>
                    <div className="grid gap-4 sm:grid-cols-2">
                      <div>
                        <label className={labelClass} htmlFor={`mc-cat-${row.id}`}>Hospital / Facility</label>
                        <select
                          id={`mc-cat-${row.id}`}
                          className={cn(fieldClass, 'appearance-none')}
                          value={row.hospitalCategory}
                          onChange={(event) => updateReceipt(row.id, { hospitalCategory: event.target.value })}
                          required
                        >
                          <option value="">Select category</option>
                          {hospitalCategoryOptions.map((option) => (
                            <option key={option.value} value={option.value}>{option.label}</option>
                          ))}
                        </select>
                      </div>
                      <div>
                        <label className={labelClass} htmlFor={`mc-receipt-${row.id}`}>Receipt No.</label>
                        <input
                          id={`mc-receipt-${row.id}`}
                          className={fieldClass}
                          maxLength={20}
                          placeholder="Enter receipt number"
                          value={row.receiptNo}
                          onChange={(event) => updateReceipt(row.id, { receiptNo: event.target.value })}
                          required
                        />
                      </div>
                    </div>
                    <div>
                      <label className={labelClass} htmlFor={`mc-desc-${row.id}`}>Treatment / Expense Description</label>
                      <textarea
                        id={`mc-desc-${row.id}`}
                        className={cn(fieldClass, 'min-h-[80px] resize-y')}
                        maxLength={250}
                        placeholder="e.g. Outpatient consultation and laboratory tests"
                        value={row.description}
                        onChange={(event) => updateReceipt(row.id, { description: event.target.value })}
                        required
                      />
                    </div>
                    <div className="grid gap-4 sm:grid-cols-2">
                      <div>
                        <label className={labelClass} htmlFor={`mc-amount-${row.id}`}>Accepted Receipt Amount</label>
                        <input
                          id={`mc-amount-${row.id}`}
                          type="number"
                          min="0.01"
                          step="0.01"
                          className={fieldClass}
                          placeholder="Enter amount"
                          value={row.amount}
                          onChange={(event) => updateReceipt(row.id, { amount: event.target.value })}
                          required
                        />
                      </div>
                      <div>
                        <label className={labelClass} htmlFor={`mc-reimb-${row.id}`}>Company Reimbursement</label>
                        <input
                          id={`mc-reimb-${row.id}`}
                          className={fieldClass}
                          value={
                            Number(row.amount) > 0
                              ? formatAmount(reimbursementFor(row.id, index))
                              : ''
                          }
                          placeholder={
                            policyLoading
                              ? 'Calculating from Business Central…'
                              : `${MEDICAL_POLICY.companyCoveragePercent}% of the receipt`
                          }
                          readOnly
                          disabled
                        />
                        {bcRefunds[row.id]?.budgetCapped || line?.capped ? (
                          <p className="mt-1.5 text-xs text-amber-700">
                            Limited to the remaining {categoryLabel} budget (FetchMedicalClaimAmountPolicy
                            {bcRefunds[row.id]?.availableBalance != null
                              ? ` · available ${formatAmount(bcRefunds[row.id]!.availableBalance!)}`
                              : ''}
                            ).
                          </p>
                        ) : null}
                      </div>
                    </div>
                    <div>
                      <label className={labelClass}>Medical Receipt</label>
                      <input
                        ref={(node) => {
                          fileRefs.current[row.id] = node
                        }}
                        type="file"
                        className="hidden"
                        multiple
                        accept=".pdf,.jpg,.jpeg,.png,.doc,.docx"
                        onChange={(event) => {
                          pickFiles(row.id, event.target.files)
                          event.target.value = ''
                        }}
                      />
                      <button
                        type="button"
                        onClick={() => fileRefs.current[row.id]?.click()}
                        onDragOver={(event) => event.preventDefault()}
                        onDrop={(event) => {
                          event.preventDefault()
                          pickFiles(row.id, event.dataTransfer.files)
                        }}
                        className="flex w-full flex-col items-center justify-center rounded-xl border border-dashed border-slate-300 bg-white px-4 py-6 text-center transition hover:border-teal-300 hover:bg-teal-50/40"
                      >
                        <CloudUpload className="mb-2 h-7 w-7 text-slate-400" />
                        <p className="text-sm font-medium text-slate-700">Upload the medical receipt</p>
                        <p className="mt-1 text-xs text-slate-500">A valid receipt is required for reimbursement.</p>
                      </button>
                      {row.files.length > 0 ? (
                        <ul className="mt-2 space-y-1.5">
                          {row.files.map((file, fileIndex) => (
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
                                onClick={() => updateReceipt(row.id, { files: row.files.filter((_, i) => i !== fileIndex) })}
                              >
                                Remove
                              </button>
                            </li>
                          ))}
                        </ul>
                      ) : null}
                    </div>
                  </div>
                )
              })}
              <button
                type="button"
                onClick={() => setReceipts((rows) => [...rows, newReceipt()])}
                className="inline-flex w-full items-center justify-center gap-2 rounded-xl border border-slate-300 bg-white px-4 py-3 text-sm font-semibold text-slate-800 transition hover:border-teal-300 hover:bg-teal-50/50"
              >
                <Plus className="h-4 w-4" />
                Add Another Receipt
              </button>
            </div>
          </section>

          <section className="rounded-xl border border-slate-200 px-4 py-4 sm:px-5">
            <h2 className="mb-1 text-base font-semibold text-slate-900">Reimbursement Calculation</h2>
            <p className="mb-3 text-xs text-slate-500">
              The company covers {MEDICAL_POLICY.companyCoveragePercent}% of accepted receipts, up to the remaining{' '}
              {categoryLabel} budget. Business Central confirms the amount when the claim is saved.
            </p>
            <dl className="space-y-2 text-sm">
              <div className="flex justify-between gap-3">
                <dt className="text-slate-600">Accepted medical receipts</dt>
                <dd className="font-semibold">{formatAmount(calc.totalReceipts)}</dd>
              </div>
              <div className="flex justify-between gap-3">
                <dt className="text-slate-600">Company coverage ({MEDICAL_POLICY.companyCoveragePercent}%)</dt>
                <dd className="font-semibold">{formatAmount(calc.totalCompanyCoverage)}</dd>
              </div>
              <div className="flex justify-between gap-3">
                <dt className="text-slate-600">Employee contribution</dt>
                <dd className="font-semibold">{formatAmount(totalEmployeeContribution)}</dd>
              </div>
              <div className="flex justify-between gap-3">
                <dt className="text-slate-600">Available {categoryLabel} budget</dt>
                <dd className="font-semibold">{money(calc.availableBefore)}</dd>
              </div>
              {calc.totalReceipts - totalBcReimbursement > 0.009 || calc.capped ? (
                <div className="flex justify-between gap-3 text-amber-800">
                  <dt>Not reimbursed (employee share + above remaining budget)</dt>
                  <dd className="font-semibold">
                    {formatAmount(Math.max(0, calc.totalReceipts - totalBcReimbursement))}
                  </dd>
                </div>
              ) : null}
              <div className="flex justify-between gap-3 border-t border-slate-200 pt-2">
                <dt className="font-medium text-slate-900">Company reimbursement</dt>
                <dd className="text-lg font-bold text-slate-900">{formatAmount(totalBcReimbursement)}</dd>
              </div>
              <div className="flex justify-between gap-3">
                <dt className="text-slate-600">Remaining {categoryLabel} budget after this claim</dt>
                <dd className="font-semibold">
                  {money(
                    calc.availableBefore === null
                      ? null
                      : Math.max(0, Math.round((calc.availableBefore - totalBcReimbursement) * 100) / 100),
                  )}
                </dd>
              </div>
            </dl>
            {calc.exhausted ? (
              <p className="mt-3 flex items-start gap-2 rounded-lg border border-red-200 bg-red-50 px-3 py-2 text-sm text-red-800">
                <AlertTriangle className="mt-0.5 h-4 w-4 shrink-0" />
                The {categoryLabel} medical claim budget is fully used. No further reimbursement is permitted for this
                category during the benefit period.
              </p>
            ) : calc.capped ? (
              <p className="mt-3 flex items-start gap-2 rounded-lg border border-amber-200 bg-amber-50 px-3 py-2 text-sm text-amber-900">
                <AlertTriangle className="mt-0.5 h-4 w-4 shrink-0" />
                Reimbursement is limited to the remaining {categoryLabel} budget. Nothing is paid beyond the available
                entitlement.
              </p>
            ) : null}
          </section>

          <section className="rounded-xl bg-slate-50 px-4 py-4 sm:px-5">
            <h2 className="mb-2 text-base font-semibold text-slate-900">Declaration</h2>
            <p className="text-sm leading-relaxed text-slate-600">
              I confirm that the attached receipts are valid medical receipts for the patient named above, that the
              expenses were actually incurred, and that they have not been claimed elsewhere.
            </p>
            <button
              type="button"
              onClick={() => setAgreed((value) => !value)}
              className="mt-4 flex items-center gap-2.5 text-sm font-medium text-slate-800"
            >
              <span
                className={cn(
                  'flex h-5 w-5 items-center justify-center rounded-full border-2 transition',
                  agreed ? 'border-teal-600 bg-teal-600 text-white' : 'border-slate-300 bg-white text-transparent',
                )}
                aria-hidden
              >
                <Check className="h-3 w-3" strokeWidth={3} />
              </span>
              I agree to the declaration.
            </button>
          </section>

          {error ? (
            <div className="rounded-xl border border-red-200 bg-red-50 px-3 py-2 text-sm text-red-700">{error}</div>
          ) : blocker && agreed ? (
            <p className="text-center text-xs text-slate-500">{blocker}</p>
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
            {submitting ? 'Submitting…' : 'Submit Medical Claim'}
          </button>

          <p className="text-center text-[11px] text-slate-400">ESSP Medical Claim</p>
        </div>
      </form>
    </div>
  )
}
