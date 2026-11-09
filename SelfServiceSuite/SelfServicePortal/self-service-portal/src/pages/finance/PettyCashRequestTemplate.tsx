import { useMemo, useRef, useState, type FormEvent } from 'react'
import { formatISO } from 'date-fns'
import { ArrowLeft, CalendarDays, Check, CloudUpload, Loader2 } from 'lucide-react'
import { useQueryClient } from '@tanstack/react-query'
import {
  addRequestLine,
  createModuleRequest,
  uploadRequestAttachment,
} from '@/api/endpoints/requestEndpoint'
import { useLookupOptions } from '@/hooks/useLookupOptions'
import { useAuth } from '@/hooks/useAuth'
import { useToast } from '@/components/feedback/ToastProvider'
import { brand } from '@/config/brand'
import {
  pettyCashExpenseCategories,
  pettyCashTypeOptions,
} from '@/data/essOptions'
import type { LookupOption } from '@/api/endpoints/lookups'
import { cn } from '@/lib/utils'
import { readFileAsBase64 } from '@/utils/readFileAsBase64'
import type { PortalRequest } from '@/types/erp.types'

const module = { module: 'pettyCash' as const, entity: 'selfServicePettyCashRequests' }
const today = formatISO(new Date(), { representation: 'date' })
const MAX_FILE_BYTES = 10 * 1024 * 1024

const fieldClass =
  'w-full rounded-xl border border-transparent bg-slate-100 px-3.5 py-3 text-sm text-slate-900 outline-none transition placeholder:text-slate-400 focus:border-teal-300 focus:bg-white focus:ring-2 focus:ring-teal-100 disabled:cursor-not-allowed disabled:opacity-70'
const labelClass = 'mb-1.5 block text-sm font-medium text-slate-700'

const CATEGORY_BC_KEYWORDS: Record<string, string[]> = {
  OFFICE_SUPPLIES: ['stationer', 'supply', 'office'],
  OFFICE_MAINTENANCE: ['maintenance', 'repair'],
  CLEANING_SANITATION: ['clean', 'sanit'],
  TRANSPORTATION: ['transport', 'taxi', 'travel'],
  FUEL_LUBRICANTS: ['fuel', 'lubric'],
  COMMUNICATION: ['mobile', 'postage', 'airtime', 'courier', 'communic'],
  MEALS_REFRESHMENTS: ['refresh', 'meal', 'tea', 'coffee'],
  MEETING_EXPENSES: ['meeting'],
  MEDICAL_FIRST_AID: ['medical', 'first'],
  PRINTING_PHOTOCOPYING: ['print', 'photocop', 'copy'],
  BANK_CHARGES: ['bank'],
  STAFF_WELFARE: ['welfare'],
  GUEST_HOSPITALITY: ['guest', 'hospital'],
  IT_COMPUTER_ACCESSORIES: ['it', 'computer', 'cable', 'mouse'],
  MISCELLANEOUS: ['other', 'misc'],
}

function resolveBcPaymentType(esspCode: string, bcOptions: LookupOption[]) {
  if (!bcOptions.length) return esspCode
  const essp = pettyCashExpenseCategories.find((row) => row.value === esspCode)
  const label = (essp?.label ?? esspCode).toLowerCase()
  const byLabel = bcOptions.find((option) => {
    const optionLabel = option.label.toLowerCase()
    const optionValue = option.value.toLowerCase()
    return optionLabel === label || optionValue === esspCode.toLowerCase() || optionLabel.includes(label)
  })
  if (byLabel) return byLabel.value

  const keywords = CATEGORY_BC_KEYWORDS[esspCode] ?? []
  for (const keyword of keywords) {
    const match = bcOptions.find((option) => {
      const hay = `${option.value} ${option.label}`.toLowerCase()
      return hay.includes(keyword)
    })
    if (match) return match.value
  }

  return (
    bcOptions.find((option) => /other|misc/i.test(`${option.value} ${option.label}`))?.value ??
    bcOptions[0]?.value ??
    esspCode
  )
}

type Props = {
  onCreated: (request: PortalRequest) => void
  onCancel: () => void
}

export function PettyCashRequestTemplate({ onCreated, onCancel }: Props) {
  const { employee } = useAuth()
  const toast = useToast()
  const queryClient = useQueryClient()
  const bcPaymentTypes = useLookupOptions('petty-cash-types', pettyCashTypeOptions)
  const fileRef = useRef<HTMLInputElement>(null)

  const [requestDate, setRequestDate] = useState(today)
  const [expenseCategory, setExpenseCategory] = useState('')
  const [miscSpecify, setMiscSpecify] = useState('')
  const [purpose, setPurpose] = useState('')
  const [amount, setAmount] = useState('')
  const [requiredDate, setRequiredDate] = useState('')
  const [files, setFiles] = useState<File[]>([])
  const [agreed, setAgreed] = useState(false)
  const [submitting, setSubmitting] = useState(false)
  const [error, setError] = useState('')

  const employeeName = employee?.displayName ?? ''
  const staffNo = employee?.employeeNo ?? ''
  const department = employee?.departmentName || employee?.departmentCode || ''
  const selectedCategory = pettyCashExpenseCategories.find((row) => row.value === expenseCategory)
  const requiresSpecify = Boolean(
    selectedCategory && 'requiresSpecify' in selectedCategory && selectedCategory.requiresSpecify,
  )

  const canSubmit = useMemo(() => {
    return (
      agreed &&
      Boolean(expenseCategory.trim()) &&
      (!requiresSpecify || miscSpecify.trim().length >= 3) &&
      purpose.trim().length >= 3 &&
      Number(amount) > 0 &&
      Boolean(requiredDate) &&
      !submitting
    )
  }, [
    agreed,
    amount,
    expenseCategory,
    miscSpecify,
    purpose,
    requiredDate,
    requiresSpecify,
    submitting,
  ])

  const onPickFiles = (list: FileList | null) => {
    if (!list?.length) return
    const next: File[] = []
    for (const file of Array.from(list)) {
      if (file.size > MAX_FILE_BYTES) {
        toast.error(`${file.name} is larger than 10 MB.`, 'File too large')
        continue
      }
      next.push(file)
    }
    setFiles((prev) => [...prev, ...next])
    if (fileRef.current) fileRef.current.value = ''
  }

  const removeFile = (index: number) => {
    setFiles((prev) => prev.filter((_, i) => i !== index))
  }

  const handleSubmit = async (event: FormEvent) => {
    event.preventDefault()
    setError('')
    if (!agreed) {
      setError('Please agree to the declaration before submitting.')
      return
    }
    if (!expenseCategory.trim()) {
      setError('Select an expense category.')
      return
    }
    if (requiresSpecify && miscSpecify.trim().length < 3) {
      setError('Specify the miscellaneous expense details.')
      return
    }
    if (purpose.trim().length < 3) {
      setError('Enter the purpose of the request.')
      return
    }
    const requestedAmount = Number(amount)
    if (!(requestedAmount > 0)) {
      setError('Enter a requested amount greater than zero.')
      return
    }
    if (!requiredDate) {
      setError('Select the required date.')
      return
    }

    const categoryLabel = selectedCategory?.label ?? expenseCategory
    const narration = [
      categoryLabel,
      requiresSpecify && miscSpecify.trim() ? `Specify: ${miscSpecify.trim()}` : '',
      purpose.trim(),
    ]
      .filter(Boolean)
      .join(' — ')
      .slice(0, 250)
    const bcType = resolveBcPaymentType(expenseCategory, bcPaymentTypes.options)

    setSubmitting(true)
    try {
      let request = await createModuleRequest(module, {
        dateNeeded: requiredDate,
        requestDate,
        description: narration,
        purpose: narration,
        narration,
        expenseCategory,
        title: `${categoryLabel} — ${purpose.trim()}`.slice(0, 80) || 'Petty Cash Request',
        amount: requestedAmount,
      })

      request = await addRequestLine(request.id, {
        type: bcType,
        name: categoryLabel,
        amount: requestedAmount,
        action: 'create',
      })

      for (const file of files) {
        const contentBase64 = await readFileAsBase64(file)
        request = await uploadRequestAttachment(request.id, {
          fileName: file.name,
          fileType: file.type || 'application/octet-stream',
          size: file.size,
          contentBase64,
          description: 'Supporting document',
        })
      }

      await queryClient.invalidateQueries({ queryKey: ['finance', 'petty-cash'] })
      toast.success('Petty cash request draft created. Review and request approval.')
      onCreated(request)
    } catch (err) {
      const message = err instanceof Error ? err.message : 'Could not create petty cash request.'
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
            Petty Cash Request
          </h1>
          <p className="mt-1.5 text-sm text-slate-500">
            Submit a request for petty cash to cover official business expenses.
          </p>
        </div>

        <div className="space-y-8 px-6 py-6 sm:px-8 sm:py-7">
          <section>
            <h2 className="mb-4 text-base font-semibold text-slate-900">Employee Information</h2>
            <div className="grid gap-4 sm:grid-cols-2">
              <div>
                <label className={labelClass} htmlFor="pc-employee-name">
                  Employee Name
                </label>
                <input
                  id="pc-employee-name"
                  className={fieldClass}
                  value={employeeName}
                  placeholder="Auto-filled"
                  readOnly
                  disabled
                />
              </div>
              <div>
                <label className={labelClass} htmlFor="pc-staff-no">
                  Staff Number
                </label>
                <input
                  id="pc-staff-no"
                  className={fieldClass}
                  value={staffNo}
                  placeholder="Auto-filled"
                  readOnly
                  disabled
                />
              </div>
              <div>
                <label className={labelClass} htmlFor="pc-department">
                  Department
                </label>
                <input
                  id="pc-department"
                  className={fieldClass}
                  value={department}
                  placeholder="Auto-filled"
                  readOnly
                  disabled
                />
              </div>
              <div>
                <label className={labelClass} htmlFor="pc-request-date">
                  Request Date
                </label>
                <div className="relative">
                  <input
                    id="pc-request-date"
                    type="date"
                    className={cn(fieldClass, 'pr-10')}
                    value={requestDate}
                    onChange={(event) => setRequestDate(event.target.value)}
                    required
                  />
                  <CalendarDays className="pointer-events-none absolute right-3 top-1/2 h-4 w-4 -translate-y-1/2 text-slate-400" />
                </div>
              </div>
            </div>
          </section>

          <section>
            <h2 className="mb-4 text-base font-semibold text-slate-900">Request Details</h2>
            <div className="space-y-4">
              <div>
                <label className={labelClass} htmlFor="pc-category">
                  Expense Category
                </label>
                <select
                  id="pc-category"
                  className={cn(fieldClass, 'appearance-none')}
                  value={expenseCategory}
                  onChange={(event) => {
                    setExpenseCategory(event.target.value)
                    if (event.target.value !== 'MISCELLANEOUS') setMiscSpecify('')
                  }}
                  required
                >
                  <option value="">Select category</option>
                  {pettyCashExpenseCategories.map((option) => (
                    <option key={option.value} value={option.value}>
                      {option.label}
                    </option>
                  ))}
                </select>
                {selectedCategory ? (
                  <p className="mt-1.5 text-xs text-slate-500">
                    Examples: {selectedCategory.examples}
                  </p>
                ) : (
                  <p className="mt-1.5 text-xs text-slate-500">
                    Choose the category that best matches this petty cash spend.
                  </p>
                )}
              </div>

              {requiresSpecify ? (
                <div>
                  <label className={labelClass} htmlFor="pc-misc-specify">
                    Specify Miscellaneous Expense
                  </label>
                  <textarea
                    id="pc-misc-specify"
                    className={cn(fieldClass, 'min-h-[80px] resize-y')}
                    placeholder="Describe the other approved minor expense..."
                    value={miscSpecify}
                    onChange={(event) => setMiscSpecify(event.target.value)}
                    maxLength={200}
                    required
                  />
                </div>
              ) : null}

              <div>
                <label className={labelClass} htmlFor="pc-purpose">
                  Purpose of Request
                </label>
                <textarea
                  id="pc-purpose"
                  className={cn(fieldClass, 'min-h-[110px] resize-y')}
                  placeholder="Explain the purpose of the cash request..."
                  value={purpose}
                  onChange={(event) => setPurpose(event.target.value)}
                  maxLength={250}
                  required
                />
              </div>

              <div className="grid gap-4 sm:grid-cols-2">
                <div>
                  <label className={labelClass} htmlFor="pc-amount">
                    Requested Amount
                  </label>
                  <input
                    id="pc-amount"
                    type="number"
                    min="0.01"
                    step="0.01"
                    className={fieldClass}
                    placeholder="Enter amount"
                    value={amount}
                    onChange={(event) => setAmount(event.target.value)}
                    required
                  />
                </div>
                <div>
                  <label className={labelClass} htmlFor="pc-currency">
                    Currency
                  </label>
                  <input id="pc-currency" className={fieldClass} value="ETB" readOnly disabled />
                </div>
              </div>

              <div>
                <label className={labelClass} htmlFor="pc-required-date">
                  Required Date
                </label>
                <div className="relative">
                  <input
                    id="pc-required-date"
                    type="date"
                    className={cn(fieldClass, 'pr-10')}
                    value={requiredDate}
                    onChange={(event) => setRequiredDate(event.target.value)}
                    placeholder="Select required date"
                    required
                  />
                  <CalendarDays className="pointer-events-none absolute right-3 top-1/2 h-4 w-4 -translate-y-1/2 text-slate-400" />
                </div>
              </div>

              <div>
                <label className={labelClass}>Supporting Documents</label>
                <input
                  ref={fileRef}
                  type="file"
                  className="hidden"
                  multiple
                  onChange={(event) => onPickFiles(event.target.files)}
                />
                <button
                  type="button"
                  onClick={() => fileRef.current?.click()}
                  onDragOver={(event) => event.preventDefault()}
                  onDrop={(event) => {
                    event.preventDefault()
                    onPickFiles(event.dataTransfer.files)
                  }}
                  className="flex w-full flex-col items-center justify-center rounded-xl border border-dashed border-slate-300 bg-slate-50 px-4 py-8 text-center transition hover:border-teal-300 hover:bg-teal-50/40"
                >
                  <CloudUpload className="mb-2 h-8 w-8 text-slate-400" />
                  <p className="text-sm font-medium text-slate-700">Upload supporting documents</p>
                  <p className="mt-1 text-xs text-slate-500">
                    Attach quotations or other relevant documents
                  </p>
                </button>
                {files.length > 0 ? (
                  <ul className="mt-3 space-y-1.5">
                    {files.map((file, index) => (
                      <li
                        key={`${file.name}-${index}`}
                        className="flex items-center justify-between rounded-lg bg-slate-50 px-3 py-2 text-xs text-slate-700"
                      >
                        <span className="truncate pr-3">
                          {file.name} · {(file.size / 1024).toFixed(0)} KB
                        </span>
                        <button
                          type="button"
                          className="font-medium text-red-600 hover:text-red-700"
                          onClick={() => removeFile(index)}
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

          <section className="rounded-xl bg-slate-50 px-4 py-4 sm:px-5">
            <h2 className="mb-2 text-base font-semibold text-slate-900">Declaration</h2>
            <p className="text-sm leading-relaxed text-slate-600">
              I confirm that this request is for official business purposes and that I will provide
              supporting receipts and settle the cash advance according to company policy.
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
              I agree to the declaration.
            </button>
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
            {submitting ? 'Submitting…' : 'Submit Petty Cash Request'}
          </button>

          <p className="text-center text-[11px] text-slate-400">ESSP Petty Cash Request</p>
        </div>
      </form>
    </div>
  )
}
