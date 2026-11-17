import { useEffect, useMemo, useRef, useState, type DragEvent, type ReactNode } from 'react'
import { createPortal } from 'react-dom'
import { zodResolver } from '@hookform/resolvers/zod'
import { useMutation, useQuery } from '@tanstack/react-query'
import { useForm, useWatch, type FieldValues, type Resolver } from 'react-hook-form'
import { addDays, differenceInCalendarDays, format as formatDay, parseISO } from 'date-fns'
import {
  BadgeCheck,
  Building2,
  CalendarClock,
  Check,
  CircleAlert,
  History,
  Landmark,
  Loader2,
  Monitor,
  Save,
  Send,
  Trash2,
  UploadCloud,
  UserCheck,
  X,
} from 'lucide-react'
import { AuthApiError } from '@/api/client/authClient'
import { getEmployeeProfileDetails } from '@/api/endpoints/profile'
import {
  addRequestLine,
  createModuleRequest,
  deleteModuleRequest,
  deleteRequestAttachment,
  deleteRequestLine,
  getModuleRequest,
  submitModuleRequest,
  updateRequestHeader,
  updateRequestLine,
  uploadRequestAttachment,
  type EndpointConfig,
} from '@/api/endpoints/requestEndpoint'
import type { LookupOption } from '@/api/endpoints/lookups'
import type { AdvanceOutstanding } from '@/api/endpoints/advanceOutstanding'
import { AdvanceOutstandingNotice } from '@/components/finance/AdvanceOutstandingNotice'
import { useConfirm } from '@/components/feedback/ConfirmProvider'
import { useToast } from '@/components/feedback/ToastProvider'
import { ApprovalHistorySection } from '@/components/shared/ApprovalHistory'
import { RequestProgress } from '@/components/shared/RequestProgress'
import { SentBackNotice } from '@/components/shared/SentBackNotice'
import type { TrackerStep } from '@/components/shared/ProcessTracker'
import { attachmentVisual, formatFileSize } from '@/components/shared/attachmentUi'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { MultiSelect } from '@/components/ui/multi-select'
import { Select } from '@/components/ui/select'
import { Textarea } from '@/components/ui/textarea'
import { purposeRequiresOtherDetails } from '@/data/advanceRequestPurpose'
import { advanceAttachmentCategories } from '@/data/essOptions'
import { useAuth } from '@/hooks/useAuth'
import { cn } from '@/lib/utils'
import { advanceRequestCreateSchema } from '@/schemas/requestSchemas'
import { formatDate, formatDateTime } from '@/utils/formatters'
import { approvalHistorySteps, canDeleteDocumentDraft, sentBackInfo } from '@/utils/requestStatus'
import type { Attachment, PortalRequest } from '@/types/erp.types'

const ALLOWED_EXTENSIONS = new Set(['pdf', 'doc', 'docx', 'jpg', 'png'])
const MAX_FILE_BYTES = 10_000_000
const TEXT_LIMIT = 250
/** The meter's scale: thresholds at ETB 50,000 and 100,000 sit at one and two thirds. */
const METER_MAX = 150_000

/** Developer handover §4.1: Line Manager first, then the final approver by amount. */
const APPROVAL_LIMITS = [
  { key: 'fad', range: 'Below ETB 50,000', phrase: 'below ETB 50,000', approver: 'FAD', matches: (amount: number) => amount > 0 && amount < 50_000 },
  { key: 'coo', range: 'ETB 50,000 – 100,000', phrase: 'ETB 50,000 – 100,000', approver: 'COO', matches: (amount: number) => amount >= 50_000 && amount <= 100_000 },
  { key: 'ceo', range: 'Above ETB 100,000', phrase: 'above ETB 100,000', approver: 'CEO', matches: (amount: number) => amount > 100_000 },
] as const

const SECTION_OF_FIELD: Record<string, string> = {
  requestPurpose: 'adv-s1',
  otherPurposeDetails: 'adv-s1',
  justification: 'adv-s1',
}

type PendingFile = { id: string; file: File; category: string; description: string }
/**
 * One chosen Advance Type and its amount — one Business Central advance line each (BC posts every line to its type's
 * account). `lineNo` once Business Central has it. With one type, the Requested Amount field is its amount.
 */
type CostItem = { key: string; lineNo: string; advanceType: string; amount: string }
type SavedLine = { lineNo: string; advanceType: string; amount: number; noOfDays: number }

const etb = new Intl.NumberFormat('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 })

function newRequestId() {
  // crypto.randomUUID needs a secure context; the portal also runs on plain http inside the LAN.
  return `adv-${Date.now().toString(36)}-${Math.random().toString(36).slice(2, 10)}`
}

function round2(value: number) {
  return Math.round(value * 100) / 100
}

function newItemKey() {
  return `item-${Date.now().toString(36)}-${Math.random().toString(36).slice(2, 8)}`
}

/** First non-empty payload value (BC returns 0001-01-01 for an unset date). */
function payloadText(payload: Record<string, unknown>, keys: string[]) {
  for (const key of keys) {
    const value = String(payload[key] ?? '').trim()
    if (value && !value.startsWith('0001-01-01')) return value
  }
  return ''
}

function payloadDate(payload: Record<string, unknown>, keys: string[]) {
  return payloadText(payload, keys).slice(0, 10)
}

/** The advance lines Business Central holds for a saved request. */
function savedLines(request: PortalRequest | undefined): SavedLine[] {
  const rows = Array.isArray(request?.payload?.lines) ? (request!.payload!.lines as Record<string, unknown>[]) : []
  return rows
    .map((row) => ({
      lineNo: String(row.lineNo ?? row.id ?? '').trim(),
      advanceType: String(row.advanceType ?? '').trim(),
      amount: Number(row.amount ?? 0) || 0,
      noOfDays: Number(row.noOfDays ?? 0) || 0,
    }))
    .filter((line) => line.lineNo)
}

/**
 * The chosen Advance Types of a saved request: one item per type, in line order. Lines of the same type (several cost
 * items of one type, before 17 Nov 2026) become one; the others are removed on the next save.
 */
function itemsFromLines(lines: SavedLine[]): CostItem[] {
  const items: CostItem[] = []
  for (const line of lines) {
    if (!line.advanceType) continue
    const index = items.findIndex((item) => item.advanceType === line.advanceType)
    if (index >= 0) {
      items[index] = { ...items[index]!, amount: String(round2((Number(items[index]!.amount) || 0) + line.amount)) }
    } else {
      items.push({ key: newItemKey(), lineNo: line.lineNo, advanceType: line.advanceType, amount: line.amount > 0 ? String(line.amount) : '' })
    }
  }
  return items
}

/** A comparable picture of the chosen types (and, with several, their amounts) to tell whether they changed. */
function itemsSignature(items: CostItem[]) {
  const several = items.length > 1
  return items.map((item) => `${item.lineNo}|${item.advanceType}|${several ? Number(item.amount) || 0 : ''}`).join(';')
}

/** Form values of a saved draft, from its Business Central header and its advance lines. */
function savedFormValues(request: PortalRequest, items: CostItem[]): FieldValues {
  const payload = request.payload ?? {}
  const total = round2(items.reduce((sum, item) => sum + (Number(item.amount) || 0), 0))
  return {
    requestDate: payloadDate(payload, ['Date', 'RequestDate']),
    dateRequired: payloadDate(payload, ['DateRequired', 'Date_Required', 'PaymentReleaseDate', 'Payment_Release_Date']),
    requestPurpose: payloadText(payload, ['RequestPurposeCode', 'Request_Purpose_Code']),
    otherPurposeDetails: payloadText(payload, ['OtherPurposeDetails', 'Other_Purpose_Details']),
    justification: payloadText(payload, ['RequestJustification', 'Request_Justification', 'Purpose']),
    activityStartDate: payloadDate(payload, ['ActivityStartDate', 'Activity_Start_Date']),
    activityEndDate: payloadDate(payload, ['ActivityEndDate', 'Activity_End_Date']),
    activityLocation: payloadText(payload, ['ActivityLocation', 'Activity_Location']),
    projectAssignment: payloadText(payload, ['ProjectAssignment', 'Project_Assignment']),
    requestedAmount: total > 0 ? String(total) : '',
    advanceType: items[0]?.advanceType ?? '',
    advanceTypeDetails: payloadText(payload, ['AdvanceTypeDetails', 'Advance_Type_Details']),
    purpose: '',
  }
}

function needsTypeDetails(option: LookupOption | undefined) {
  return option?.meta?.requiresOtherDetails === true || /^other\b/i.test(String(option?.label ?? ''))
}

function activityDays(start: string, end: string) {
  try {
    const days = differenceInCalendarDays(parseISO(end || start), parseISO(start)) + 1
    return Number.isFinite(days) && days > 0 ? days : 1
  } catch {
    return 1
  }
}

function readFileBase64(file: File): Promise<string> {
  return new Promise((resolve, reject) => {
    const reader = new FileReader()
    reader.onerror = () => reject(new Error(`Could not read ${file.name}`))
    reader.onload = () => {
      const content = String(reader.result ?? '').split(',')[1] ?? ''
      if (content) resolve(content)
      else reject(new Error(`Could not encode ${file.name}`))
    }
    reader.readAsDataURL(file)
  })
}

function prefersReducedMotion() {
  return typeof window !== 'undefined' && Boolean(window.matchMedia?.('(prefers-reduced-motion: reduce)').matches)
}

/** The amount figure eases to each new value (or jumps, with reduced motion). */
function useCountUp(target: number) {
  const [reduce] = useState(prefersReducedMotion)
  const [value, setValue] = useState(target)
  const current = useRef(target)
  useEffect(() => {
    if (reduce) return
    const from = current.current
    const started = performance.now()
    let frame = 0
    const tick = (now: number) => {
      // The first frame can be stamped before `started`: never below 0 (it dipped below the old value).
      const t = Math.max(0, Math.min(1, (now - started) / 520))
      const next = from + (target - from) * (1 - Math.pow(1 - t, 3))
      current.current = next
      setValue(next)
      if (t < 1) frame = requestAnimationFrame(tick)
    }
    frame = requestAnimationFrame(tick)
    return () => cancelAnimationFrame(frame)
  }, [target, reduce])
  return reduce ? target : value
}

function initials(name: string) {
  return (
    name
      .split(/\s+/)
      .filter(Boolean)
      .slice(0, 2)
      .map((part) => part[0]?.toUpperCase() ?? '')
      .join('') || '—'
  )
}

function Section({
  id,
  number,
  title,
  hint,
  done,
  shake,
  children,
}: {
  id: string
  number: number
  title: string
  hint: string
  done: boolean
  shake: boolean
  children: ReactNode
}) {
  return (
    <section id={id} className={cn('adv-section scroll-mt-24', done && 'is-done', shake && 'adv-shake')} aria-labelledby={`${id}-title`}>
      <header className="adv-section-head">
        <span className={cn('adv-step', done && 'is-done')} aria-hidden="true">
          {done ? <Check className="h-3.5 w-3.5" strokeWidth={3} /> : number}
        </span>
        <div className="min-w-0">
          <h3 id={`${id}-title`} className="text-[0.95rem] font-semibold leading-tight">
            {title}
          </h3>
          <p className="text-xs text-white/70">{hint}</p>
        </div>
        <span className="sr-only">{done ? 'Complete' : 'Not complete yet'}</span>
      </header>
      <div className="p-4 sm:p-5">{children}</div>
    </section>
  )
}

function Required() {
  return (
    <span className="text-rose-600" aria-hidden="true">
      {' '}
      *
    </span>
  )
}

function FieldError({ message }: { message?: unknown }) {
  return message ? (
    <p className="flex items-center gap-1 text-xs font-medium text-rose-600" role="alert">
      <CircleAlert className="h-3.5 w-3.5 shrink-0" />
      {String(message)}
    </p>
  ) : null
}

function Counter({ value }: { value: string }) {
  return (
    <span className={cn('text-[11px] tabular-nums', value.length >= TEXT_LIMIT ? 'text-rose-600' : 'text-[var(--portal-muted)]')}>
      {value.length}/{TEXT_LIMIT}
    </span>
  )
}

/**
 * New Advance Request on one page, laid out as the ABH "ESSP – Advance Request" developer handover. With `request`
 * it edits that draft (it opens in this same form, client 16 Nov 2026):
 * 1 Employee Information & Request Purpose · 2 Advance Request Details (Requested Amount in ETB)
 * · 3 Supporting Documents & Submission (Save as Draft / Submit for Approval / Cancel / View History)
 * · 4 Approval Workflow & Limits, a live route that follows the amount. Business Central creates the
 * advance, one line per chosen Advance Type (client, 17 Nov 2026: several types, each with its amount), the
 * attachments and — on Submit — starts its approval workflow. With BC 1.0.3.667 (`outstanding`), Submit is refused
 * while the employee has the maximum (4) advances not settled, and the settle-by date (activity end + 7 days) shows.
 */
export function AdvanceRequestCreate({
  module,
  purposeOptions,
  purposeHint,
  advanceTypes,
  supportsProject,
  outstanding,
  request,
  onCreated,
  onSaved,
  onDeleted,
  onCancel,
}: {
  module: EndpointConfig
  purposeOptions: LookupOption[]
  purposeHint: string
  advanceTypes: LookupOption[]
  supportsProject: boolean
  /** BC 1.0.3.667: advances not settled and whether a new one may be submitted (null on older BC). */
  outstanding?: AdvanceOutstanding | null
  /** A saved draft (or an advance reopened after a send back) to edit. */
  request?: PortalRequest
  onCreated?: (request: PortalRequest) => void
  /** Edit: saved (and maybe submitted); the page reloads the request. */
  onSaved?: () => void | Promise<void>
  /** Edit: the draft was deleted. */
  onDeleted?: () => void
  onCancel: () => void
}) {
  const toast = useToast()
  const confirm = useConfirm()
  const { employee } = useAuth()
  const profileQuery = useQuery({
    queryKey: ['profile', 'details'],
    queryFn: getEmployeeProfileDetails,
    staleTime: 5 * 60 * 1000,
  })
  const profile = profileQuery.data
  const editing = Boolean(request)
  const initialLines = useMemo(() => savedLines(request), [request])
  const initialItems = useMemo(() => itemsFromLines(initialLines), [initialLines])
  const sentBack = sentBackInfo(request)
  const historySteps = request ? approvalHistorySteps(request) : []
  const today = useMemo(() => new Date().toISOString().slice(0, 10), [])
  const requestDate = useMemo(
    () => (request ? payloadText(request.payload ?? {}, ['Date', 'RequestDate']) || request.createdAt || '' : new Date().toISOString()),
    [request],
  )
  const clientRequestId = useRef(newRequestId())
  const [typeItems, setTypeItems] = useState<CostItem[]>(initialItems)
  const [itemErrors, setItemErrors] = useState<Record<string, string>>({})
  const [savedAttachments, setSavedAttachments] = useState<Attachment[]>(() => request?.attachments ?? [])
  const [removingAttachment, setRemovingAttachment] = useState<string | null>(null)
  const fileInput = useRef<HTMLInputElement>(null)
  const [files, setFiles] = useState<PendingFile[]>([])
  const [dragOver, setDragOver] = useState(false)
  const [formError, setFormError] = useState<string | null>(null)
  const [shakeSection, setShakeSection] = useState<string | null>(null)
  const [success, setSuccess] = useState<{ request: PortalRequest; submit: boolean } | null>(null)

  const form = useForm<FieldValues>({
    // The schema coerces Requested Amount to a number; the form keeps plain field values.
    resolver: zodResolver(advanceRequestCreateSchema) as unknown as Resolver<FieldValues>,
    defaultValues: request
      ? savedFormValues(request, initialItems)
      : {
      requestDate: today,
      dateRequired: today,
      requestPurpose: '',
      otherPurposeDetails: '',
      justification: '',
      activityStartDate: '',
      activityEndDate: '',
      activityLocation: '',
      projectAssignment: '',
      requestedAmount: '',
      advanceType: '',
      advanceTypeDetails: '',
      purpose: '',
    },
  })
  const errors = form.formState.errors
  const watched = useWatch({ control: form.control }) as Record<string, unknown>
  const text = (name: string) => String(watched[name] ?? '')
  const purposeCode = text('requestPurpose')
  const activityStart = text('activityStartDate')
  const activityEnd = text('activityEndDate') || activityStart
  const firstAmount = Number(watched.requestedAmount ?? 0) > 0 ? Number(watched.requestedAmount) : 0
  // Several Advance Types (client, 17 Nov 2026): each has its amount and the Requested Amount is their total.
  const several = typeItems.length > 1
  const itemsTotal = round2(typeItems.reduce((sum, item) => sum + (Number(item.amount) > 0 ? Number(item.amount) : 0), 0))
  // The approval route follows the whole advance.
  const amount = several ? itemsTotal : round2(firstAmount)
  const firstType = typeItems[0]?.advanceType ?? ''
  const limitReached = Boolean(outstanding && !outstanding.canRequest)
  const settleBy =
    outstanding && activityEnd
      ? (() => {
          try {
            return formatDay(addDays(parseISO(activityEnd), outstanding.settlementDueDays), 'd MMM yyyy')
          } catch {
            return ''
          }
        })()
      : ''
  const needsOther = purposeRequiresOtherDetails(purposeCode, purposeOptions)
  const finalLimit = APPROVAL_LIMITS.find((limit) => limit.matches(amount))
  const days = activityStart ? activityDays(activityStart, activityEnd) : 0
  const shownAmount = useCountUp(amount)
  const purposeLabel = purposeOptions.find((option) => option.value === purposeCode)?.label ?? ''
  const typeLabel = (code: string) => advanceTypes.find((option) => option.value === code)?.label ?? code
  const advanceTypeLabel = firstType ? typeLabel(firstType) : ''
  // ESSP Advance Request Types (BC 1.0.3.653): Other (Specify) needs what the advance is for (one text per request).
  const typeNeedsDetails = typeItems.some((item) => needsTypeDetails(advanceTypes.find((option) => option.value === item.advanceType)))
  const itemsValid = !several || typeItems.every((item) => Number(item.amount) > 0)

  const section1Done =
    Boolean(purposeCode) && (!needsOther || text('otherPurposeDetails').trim().length > 0) && text('justification').trim().length >= 10
  const section2Done =
    Boolean(text('dateRequired')) &&
    text('dateRequired') >= today &&
    Boolean(activityStart) &&
    activityEnd >= activityStart &&
    text('dateRequired') <= activityStart &&
    amount > 0 &&
    typeItems.length > 0 &&
    itemsValid
  const itemsChanged = itemsSignature(typeItems) !== itemsSignature(initialItems)
  const dirty = form.formState.isDirty || files.length > 0 || itemsChanged

  const expectedApprovers: TrackerStep[] = [
    { key: 'line-manager', heading: 'Line Manager', owner: 'Approves every request first', icon: UserCheck },
    {
      key: 'final-approver',
      heading: finalLimit ? finalLimit.approver : 'FAD | COO | CEO',
      owner: finalLimit ? `Final approver, ${finalLimit.phrase}` : 'Final approver by amount',
      icon: Landmark,
    },
  ]

  // The form's Advance Type is the first chosen type and, with several, its Requested Amount is their total — so the
  // schema's checks (a type, an amount above zero) hold for one type and for many.
  useEffect(() => {
    if (String(form.getValues('advanceType') ?? '') !== firstType) {
      form.setValue('advanceType', firstType, { shouldDirty: true, shouldValidate: form.formState.isSubmitted })
    }
  }, [firstType, form])
  useEffect(() => {
    if (!several) return
    const total = itemsTotal > 0 ? String(itemsTotal) : ''
    if (String(form.getValues('requestedAmount') ?? '') !== total) {
      form.setValue('requestedAmount', total, { shouldDirty: true, shouldValidate: form.formState.isSubmitted })
    }
  }, [several, itemsTotal, form])

  // Leaving the page with unsaved entries asks first.
  useEffect(() => {
    if (!dirty || success) return
    const guard = (event: BeforeUnloadEvent) => {
      event.preventDefault()
      event.returnValue = ''
    }
    window.addEventListener('beforeunload', guard)
    return () => window.removeEventListener('beforeunload', guard)
  }, [dirty, success])

  // After the success moment, open the saved request.
  useEffect(() => {
    if (!success) return
    const timer = window.setTimeout(
      () => (editing ? void onSaved?.() : onCreated?.(success.request)),
      prefersReducedMotion() ? 400 : 1600,
    )
    return () => window.clearTimeout(timer)
  }, [success, onCreated, onSaved, editing])

  const encodeFiles = () =>
    Promise.all(
      files.map(async (item) => ({
        fileName: item.file.name,
        fileType: item.file.type || 'application/octet-stream',
        size: item.file.size,
        contentBase64: await readFileBase64(item.file),
        description: `${item.category}: ${item.description.trim() || item.file.name}`,
      })),
    )

  /** The header fields Business Central keeps (create and edit). */
  const headerBody = (values: FieldValues) => {
    const start = String(values.activityStartDate ?? '')
    const end = String(values.activityEndDate ?? '') || start
    const code = String(values.requestPurpose ?? '').trim()
    const label = purposeOptions.find((option) => option.value === code)?.label ?? code
    const justification = String(values.justification ?? '').trim()
    return {
      dateRequired: values.dateRequired,
      requestPurpose: code,
      purposeCode: code,
      otherPurposeDetails: needsOther ? String(values.otherPurposeDetails ?? '').trim() : '',
      justification,
      purpose: justification || label,
      title: justification || label || 'Advance Request',
      activityStartDate: start,
      activityEndDate: end,
      activityLocation: String(values.activityLocation ?? '').trim(),
      ...(supportsProject ? { projectAssignment: String(values.projectAssignment ?? '').trim() } : {}),
      ...(typeNeedsDetails ? { advanceTypeDetails: String(values.advanceTypeDetails ?? '').trim() } : {}),
    }
  }

  /** Every chosen Advance Type as a BC advance line: its amount over the activity days (no travel fields). */
  const lineBodies = (values: FieldValues) => {
    const start = String(values.activityStartDate ?? '')
    const lineDays = activityDays(start, String(values.activityEndDate ?? '') || start)
    const line = (advanceType: string, value: number) => ({
      advanceType,
      amount: round2(value),
      noOfDays: lineDays,
      dailyRate: round2(value / lineDays),
      destination: '',
      dutyArea: '',
    })
    if (several) return typeItems.map((item) => ({ lineNo: item.lineNo, ...line(item.advanceType, Number(item.amount)) }))
    return [{ lineNo: typeItems[0]?.lineNo ?? '', ...line(String(values.advanceType ?? ''), Number(values.requestedAmount)) }]
  }

  /** Edit: header, then the lines (removed, changed, new), new documents, and Submit when asked. */
  const saveDraft = async (values: FieldValues, submit: boolean) => {
    const id = request!.id
    let wrote = false
    try {
      await updateRequestHeader(id, headerBody(values))
      wrote = true
      const wanted = lineBodies(values)
      const keep = new Set(wanted.map((line) => line.lineNo).filter(Boolean))
      for (const saved of initialLines) {
        if (!keep.has(saved.lineNo)) await deleteRequestLine(id, saved.lineNo)
      }
      for (const { lineNo, ...line } of wanted) {
        const saved = initialLines.find((row) => row.lineNo === lineNo)
        if (!lineNo || !saved) {
          await addRequestLine(id, line)
        } else if (saved.advanceType !== line.advanceType || saved.amount !== line.amount || saved.noOfDays !== line.noOfDays) {
          await updateRequestLine(id, lineNo, line)
        }
      }
      for (const attachment of await encodeFiles()) await uploadRequestAttachment(id, attachment)
      if (submit) await submitModuleRequest(module, id)
    } catch (error) {
      // Part of it may be in BC already: reload the request so the form shows what BC holds.
      throw Object.assign(error instanceof Error ? error : new Error(String(error)), { partlySaved: wrote })
    }
    return request!
  }

  const create = useMutation({
    mutationFn: async ({ values, submit }: { values: FieldValues; submit: boolean }) => {
      if (request) return saveDraft(values, submit)
      const attachments = await encodeFiles()
      return createModuleRequest(
        module,
        {
          ...headerBody(values),
          // Each chosen Advance Type (with its amount in ETB) is an advance line: BC needs the type for the account.
          lines: lineBodies(values).map((line) => {
            const body: Record<string, unknown> = { ...line }
            delete body.lineNo
            return body
          }),
          attachments,
          submit,
          clientRequestId: clientRequestId.current,
        },
        // Header, line, attachments and the BC approval workflow in one call.
        { timeout: 120_000 },
      )
    },
    onSuccess: (saved, { submit }) => {
      toast.success(
        submit
          ? `${saved.requestNo} is with Business Central for approval: the Line Manager first, then ${finalLimit?.approver ?? 'the final approver'}.`
          : editing
            ? `${saved.requestNo} is saved. It is not sent for approval until you submit it.`
            : `${saved.requestNo} is saved as a draft. It is not sent for approval until you submit it.`,
        submit ? 'Submitted for approval' : editing ? 'Draft saved' : 'Saved as draft',
      )
      // Edit + Save as Draft: reload what BC now holds and stay in the form.
      if (editing && !submit) {
        void onSaved?.()
        return
      }
      setSuccess({ request: saved, submit })
    },
    onError: async (error) => {
      const message = error instanceof Error ? error.message : 'The advance request could not be saved.'
      if (editing) {
        if ((error as { partlySaved?: boolean }).partlySaved) {
          toast.error(`${message} Part of your changes may be saved; the form now shows what Business Central holds.`, 'Not fully saved')
          void onSaved?.()
          return
        }
        setFormError(message)
        return
      }
      const documentNo = error instanceof AuthApiError ? error.documentNo : undefined
      if (documentNo) {
        // BC saved the draft but a later step failed: keep it, open it, and say it was not submitted.
        toast.error(`${message} Open draft ${documentNo}, correct it and submit it again.`, `Saved as draft ${documentNo}, not submitted`)
        try {
          onCreated?.(await getModuleRequest(module, `${module.module}-${documentNo}`))
        } catch {
          setFormError(`Draft ${documentNo} was saved but could not be opened. Find it in My Advance Requests.`)
        }
        return
      }
      setFormError(message)
    },
  })

  const removeDraft = useMutation({
    mutationFn: () => deleteModuleRequest(module, request!.id),
    onSuccess: () => {
      toast.success(`${request!.requestNo} is deleted.`, 'Draft deleted')
      onDeleted?.()
    },
    onError: (error) => setFormError(error instanceof Error ? error.message : 'The draft could not be deleted.'),
  })

  const busy = create.isPending || removeDraft.isPending || Boolean(success)

  const flagSection = (sectionId: string) => {
    document.getElementById(sectionId)?.scrollIntoView({ behavior: prefersReducedMotion() ? 'auto' : 'smooth', block: 'start' })
    setShakeSection(null)
    window.requestAnimationFrame(() => setShakeSection(sectionId))
    window.setTimeout(() => setShakeSection(null), 650)
  }

  const amountErrors = () =>
    Object.fromEntries(typeItems.filter((item) => !(Number(item.amount) > 0)).map((item) => [item.key, 'Enter an amount above zero']))

  const run = (submit: boolean) => {
    setFormError(null)
    if (submit && limitReached) {
      setFormError(
        `You cannot submit a new advance while ${outstanding!.unsettledCount} of your advances are not settled (the limit is ${outstanding!.maxUnsettled}). Settle one first; you can save this request as a draft meanwhile.`,
      )
      return
    }
    void form.handleSubmit(
      (values) => {
        if (needsOther && !String(values.otherPurposeDetails ?? '').trim()) {
          form.setError('otherPurposeDetails', { type: 'manual', message: 'Describe the purpose when Other (Specify) is selected' })
          flagSection('adv-s1')
          return
        }
        if (!itemsValid) {
          setItemErrors(amountErrors())
          flagSection('adv-s2')
          return
        }
        if (typeNeedsDetails && String(values.advanceTypeDetails ?? '').trim().length < 3) {
          form.setError('advanceTypeDetails', { type: 'manual', message: 'Specify the advance type when Other (Specify) is selected' })
          flagSection('adv-s2')
          return
        }
        create.mutate({ values, submit })
      },
      (invalid) => {
        if (!itemsValid) setItemErrors(amountErrors())
        const first = Object.keys(invalid)[0] ?? ''
        setFormError('Some required details are missing or invalid. They are marked in red.')
        flagSection(SECTION_OF_FIELD[first] ?? 'adv-s2')
      },
    )()
  }

  const cancel = async () => {
    if (dirty) {
      const discard = await confirm(
        editing
          ? {
              title: 'Discard your changes?',
              message: `${request!.requestNo} stays as it was last saved. The changes and documents you added here will be lost.`,
              confirmLabel: 'Discard changes',
              tone: 'danger',
            }
          : {
              title: 'Discard this advance request?',
              message: 'Nothing has been saved yet. Your entries and documents will be lost.',
              confirmLabel: 'Discard',
              tone: 'danger',
            },
      )
      if (!discard) return
    }
    onCancel()
  }

  const deleteDraft = async () => {
    const yes = await confirm({
      title: `Delete draft ${request!.requestNo}?`,
      message: 'The draft, its advance lines and documents are deleted in Business Central. This cannot be undone.',
      confirmLabel: 'Delete draft',
      cancelLabel: 'Keep',
      tone: 'danger',
    })
    if (yes) removeDraft.mutate()
  }

  const removeSavedAttachment = async (attachment: Attachment) => {
    const yes = await confirm({
      title: `Remove ${attachment.fileName}?`,
      message: 'The document is removed from the request in Business Central.',
      confirmLabel: 'Remove',
      tone: 'danger',
    })
    if (!yes) return
    setRemovingAttachment(attachment.id)
    try {
      await deleteRequestAttachment(request!.id, attachment.id)
      setSavedAttachments((current) => current.filter((row) => row.id !== attachment.id))
    } catch (error) {
      toast.error(error instanceof Error ? error.message : 'The document could not be removed.', 'Not removed')
    } finally {
      setRemovingAttachment(null)
    }
  }

  /** The Advance Types chosen in the multi-select, in the order chosen; each keeps its amount and BC line. */
  const selectTypes = (codes: string[]) => {
    const single = several ? undefined : typeItems[0]
    const singleAmount = String(form.getValues('requestedAmount') ?? '')
    const next = codes.map((code) => {
      const existing = typeItems.find((item) => item.advanceType === code)
      if (!existing) return { key: newItemKey(), lineNo: '', advanceType: code, amount: '' }
      // One type becoming several: the amount entered for it stays with it.
      return single && existing.key === single.key && codes.length > 1 ? { ...existing, amount: singleAmount } : existing
    })
    // Several becoming one: the remaining type's amount is the Requested Amount again.
    if (several && next.length === 1) {
      form.setValue('requestedAmount', next[0]!.amount, { shouldDirty: true, shouldValidate: form.formState.isSubmitted })
    }
    setTypeItems(next)
    setItemErrors({})
  }

  const updateItemAmount = (key: string, value: string) => {
    setTypeItems((current) => current.map((item) => (item.key === key ? { ...item, amount: value } : item)))
    setItemErrors((current) => {
      if (!current[key]) return current
      const next = { ...current }
      delete next[key]
      return next
    })
  }

  const addFiles = (list: FileList | null) => {
    if (!list) return
    const next: PendingFile[] = []
    for (const file of Array.from(list)) {
      const extension = file.name.split('.').pop()?.toLowerCase() ?? ''
      if (!ALLOWED_EXTENSIONS.has(extension)) {
        toast.error(`${file.name} is a .${extension} file. Attach PDF, DOC, DOCX, JPG or PNG.`, 'File type not accepted')
        continue
      }
      if (file.size > MAX_FILE_BYTES) {
        toast.error(`${file.name} is ${formatFileSize(file.size)}. Each document can be up to 10 MB.`, 'File too large')
        continue
      }
      if (files.some((item) => item.file.name === file.name && item.file.size === file.size)) continue
      next.push({
        id: `${file.name}-${file.size}-${file.lastModified}-${Math.random().toString(36).slice(2, 6)}`,
        file,
        category: advanceAttachmentCategories[0]!.value,
        description: file.name.replace(/\.[^.]+$/, ''),
      })
    }
    if (next.length) setFiles((current) => [...current, ...next])
    if (fileInput.current) fileInput.current.value = ''
  }

  const onDrop = (event: DragEvent<HTMLElement>) => {
    event.preventDefault()
    setDragOver(false)
    if (!busy) addFiles(event.dataTransfer.files)
  }

  const employeeName = profile?.fullName || employee?.displayName || ''
  const meterPosition = Math.min(amount, METER_MAX) / METER_MAX
  const scrollTo = (id: string) =>
    document.getElementById(id)?.scrollIntoView({ behavior: prefersReducedMotion() ? 'auto' : 'smooth', block: 'start' })

  return (
    <div className="adv-form space-y-4">
      {/* Standard: Workflow Progress first. */}
      {request && sentBack ? (
        <RequestProgress
          status={request.status}
          hasLines={initialLines.length > 0}
          module="imprest"
          payload={request.payload}
          approvalSteps={request.approvalSteps}
          expectedApprovers={expectedApprovers}
        />
      ) : (
        <RequestProgress
          status="Draft"
          creating={editing ? 'edit' : 'new'}
          requiresLines={false}
          expectedApprovers={expectedApprovers}
        />
      )}

      <div className="flex flex-wrap items-end justify-between gap-3">
        <div>
          <h2 className="flex flex-wrap items-center gap-2 text-xl font-semibold tracking-tight text-[var(--portal-text)]">
            {request ? `Advance Request ${request.requestNo}` : 'New Advance Request'}
            {request ? (
              <span className="rounded-full bg-slate-100 px-2 py-0.5 text-xs font-semibold text-slate-600">
                {sentBack ? 'Sent back for correction' : 'Draft'}
              </span>
            ) : null}
          </h2>
          <p className="mt-0.5 text-sm text-[var(--portal-muted)]">
            {request
              ? 'Saved in Business Central, not sent for approval yet. Change what you need, then Save Draft or Submit for Approval.'
              : 'Funds for an approved business activity. You settle them later in Advance Settlement.'}
          </p>
        </div>
        <p className="text-xs text-[var(--portal-muted)]">
          Fields marked <span className="font-semibold text-rose-600">*</span> are required
        </p>
      </div>

      {sentBack ? <SentBackNotice sentBack={{ ...sentBack, reopenRequired: false }} submitLabel="Submit for Approval" /> : null}

      {/* Client, 17 Nov 2026 (BC 1.0.3.667): no new advance with 4 not settled; overdue settlements are named. */}
      <AdvanceOutstandingNotice outstanding={outstanding} />

      {formError ? (
        <div className="adv-reveal flex items-start gap-2 rounded-xl border border-rose-200 bg-rose-50 px-4 py-3 text-sm text-rose-800" role="alert">
          <CircleAlert className="mt-0.5 h-4 w-4 shrink-0" />
          {formError}
        </div>
      ) : null}

      <div className="grid gap-4 lg:grid-cols-[minmax(0,1fr)_22rem] lg:items-start">
        <div className="portal-rise-children space-y-4">
          <Section
            id="adv-s1"
            number={1}
            title="Employee Information & Activity / Purpose"
            hint="Your details come from your employee record"
            done={section1Done}
            shake={shakeSection === 'adv-s1'}
          >
            <div className="flex items-center gap-3">
              <span className="adv-avatar" aria-hidden="true">
                {initials(employeeName)}
              </span>
              <div className="min-w-0">
                <p className="truncate font-semibold text-[var(--portal-text)]">{employeeName || '—'}</p>
                <p className="truncate text-sm text-[var(--portal-muted)]">
                  {profile?.jobTitle || employee?.jobTitle || 'Job title not on record'}
                </p>
              </div>
            </div>
            <dl className="adv-facts mt-4">
              <div>
                <dt>Employee number</dt>
                <dd className="tabular-nums">{profile?.employeeNo || employee?.employeeNo || '—'}</dd>
              </div>
              <div>
                <dt>Department</dt>
                <dd>{profile?.department || employee?.departmentName || employee?.departmentCode || '—'}</dd>
              </div>
              <div>
                <dt>Division</dt>
                <dd>{profile?.division || '—'}</dd>
              </div>
              <div>
                <dt>Employment status</dt>
                <dd className="flex items-center gap-1.5">
                  {profile?.status ? (
                    <span
                      className={cn('h-2 w-2 rounded-full', /active/i.test(profile.status) ? 'bg-emerald-500' : 'bg-amber-500')}
                      aria-hidden="true"
                    />
                  ) : null}
                  {profile?.status || profile?.employmentType || '—'}
                </dd>
              </div>
            </dl>
            {profileQuery.isError ? (
              <p className="mt-2 text-xs text-rose-600">Your employee record could not be loaded from Business Central. Refresh the page.</p>
            ) : null}

            <div className="mt-5 grid gap-4">
              <div className="space-y-1.5">
                <Label htmlFor="adv-purpose">
                  Activity / Purpose of Assignment
                  <Required />
                </Label>
                <Select
                  id="adv-purpose"
                  options={purposeOptions}
                  placeholder="Choose the activity / purpose"
                  {...form.register('requestPurpose')}
                />
                <p className="text-xs text-[var(--portal-muted)]">{purposeHint}</p>
                <FieldError message={errors.requestPurpose?.message} />
              </div>
              {needsOther ? (
                <div className="adv-reveal space-y-1.5">
                  <div className="flex items-baseline justify-between">
                    <Label htmlFor="adv-other">
                      Other (specify) — describe the activity
                      <Required />
                    </Label>
                    <Counter value={text('otherPurposeDetails')} />
                  </div>
                  <Textarea id="adv-other" rows={2} maxLength={TEXT_LIMIT} placeholder="Describe the purpose" {...form.register('otherPurposeDetails')} />
                  <FieldError message={errors.otherPurposeDetails?.message} />
                </div>
              ) : null}
              <div className="space-y-1.5">
                <div className="flex items-baseline justify-between">
                  <Label htmlFor="adv-justification">
                    Request justification
                    <Required />
                  </Label>
                  <Counter value={text('justification')} />
                </div>
                <Textarea
                  id="adv-justification"
                  rows={3}
                  maxLength={TEXT_LIMIT}
                  placeholder="Explain why the advance is needed"
                  {...form.register('justification')}
                />
                <FieldError message={errors.justification?.message} />
              </div>
            </div>
          </Section>

          <Section
            id="adv-s2"
            number={2}
            title="Advance Request Details"
            hint="When, where and how much"
            done={section2Done}
            shake={shakeSection === 'adv-s2'}
          >
            <div className="grid gap-4 sm:grid-cols-2">
              <div className="space-y-1.5">
                <p className="text-sm font-medium text-[var(--portal-text)]">Request date</p>
                <p className="flex h-10 items-center gap-2 rounded-md bg-[var(--portal-surface-sunken)] px-3 text-sm text-[var(--portal-text-soft)]">
                  <CalendarClock className="h-4 w-4 shrink-0 text-[var(--portal-navy)]" aria-hidden="true" />
                  <span className="tabular-nums">{editing ? formatDate(requestDate) : formatDateTime(requestDate)}</span>
                </p>
                <p className="text-xs text-[var(--portal-muted)]">Set by the system</p>
              </div>
              <div className="space-y-1.5">
                <Label htmlFor="adv-required">
                  Required advance date
                  <Required />
                </Label>
                <Input id="adv-required" type="date" min={today} {...form.register('dateRequired')} />
                <p className="text-xs text-[var(--portal-muted)]">The day you need the funds, on or before the activity starts</p>
                <FieldError message={errors.dateRequired?.message} />
              </div>
              <div className="space-y-1.5">
                <Label htmlFor="adv-start">
                  Activity start date
                  <Required />
                </Label>
                <Input
                  id="adv-start"
                  type="date"
                  min={today}
                  {...form.register('activityStartDate', {
                    onChange: (event) => {
                      const start = String(event.target.value ?? '')
                      const end = String(form.getValues('activityEndDate') ?? '')
                      if (start && (!end || end < start)) form.setValue('activityEndDate', start)
                    },
                  })}
                />
                <FieldError message={errors.activityStartDate?.message} />
              </div>
              <div className="space-y-1.5">
                <div className="flex items-baseline justify-between">
                  <Label htmlFor="adv-end">Activity end date</Label>
                  {days > 0 ? (
                    <span key={days} className="adv-pill">
                      {days} {days === 1 ? 'day' : 'days'}
                    </span>
                  ) : null}
                </div>
                <Input id="adv-end" type="date" min={activityStart || today} {...form.register('activityEndDate')} />
                {settleBy ? (
                  <p className="text-xs text-[var(--portal-muted)]">
                    Settle the advance by <span className="font-medium text-[var(--portal-text-soft)]">{settleBy}</span>, within{' '}
                    {outstanding!.settlementDueDays} days of the activity end
                  </p>
                ) : null}
                <FieldError message={errors.activityEndDate?.message} />
              </div>
              <div className="space-y-1.5 sm:col-span-2">
                <Label htmlFor="adv-location">Activity location</Label>
                <Input id="adv-location" maxLength={TEXT_LIMIT} placeholder="Where the activity takes place, if relevant" {...form.register('activityLocation')} />
              </div>
              {supportsProject ? (
                <div className="space-y-1.5 sm:col-span-2">
                  <Label htmlFor="adv-project">Project or assignment</Label>
                  <Input id="adv-project" maxLength={100} placeholder="Optional" {...form.register('projectAssignment')} />
                  <FieldError message={errors.projectAssignment?.message} />
                </div>
              ) : null}
              <div className="space-y-1.5">
                <Label htmlFor="adv-amount">
                  {several ? 'Total requested amount' : 'Requested amount'}
                  <Required />
                </Label>
                <div className={cn('adv-amount', Boolean(errors.requestedAmount) && !several && 'is-invalid', several && 'is-readonly')}>
                  <span className="adv-amount-currency">ETB</span>
                  <input
                    id="adv-amount"
                    type="number"
                    min="0"
                    step="0.01"
                    inputMode="decimal"
                    placeholder="0.00"
                    readOnly={several}
                    tabIndex={several ? -1 : undefined}
                    aria-describedby="adv-amount-help"
                    aria-invalid={Boolean(errors.requestedAmount)}
                    {...form.register('requestedAmount')}
                  />
                </div>
                <p id="adv-amount-help" className="text-xs text-[var(--portal-muted)]">
                  {several ? 'The total of the amounts per advance type below.' : 'More than zero. Currency is ETB.'}
                </p>
                {several ? null : <FieldError message={errors.requestedAmount?.message} />}
              </div>
              <div className="space-y-1.5">
                <Label htmlFor="adv-type">
                  Advance type
                  <Required />
                </Label>
                <MultiSelect
                  id="adv-type"
                  options={advanceTypes}
                  value={typeItems.map((item) => item.advanceType)}
                  onChange={selectTypes}
                  placeholder="Choose one or more advance types"
                  disabled={busy}
                  invalid={Boolean(errors.advanceType)}
                  aria-describedby="adv-type-help"
                />
                <p id="adv-type-help" className="text-xs text-[var(--portal-muted)]">
                  Choose every type the advance covers. Each type is paid from its own Business Central account.
                </p>
                <FieldError message={errors.advanceType?.message} />
              </div>
              {typeNeedsDetails ? (
                <div className="space-y-1.5 sm:col-span-2">
                  <Label htmlFor="adv-type-details">
                    Specify the advance type
                    <Required />
                  </Label>
                  <Input
                    id="adv-type-details"
                    maxLength={100}
                    placeholder="What is this advance for?"
                    {...form.register('advanceTypeDetails')}
                  />
                  <FieldError message={errors.advanceTypeDetails?.message} />
                </div>
              ) : null}
            </div>
            {several ? (
              <div className="adv-reveal mt-4 border-t border-[var(--portal-card-border)] pt-4">
                <div className="flex items-baseline justify-between gap-2">
                  <p className="text-sm font-medium text-[var(--portal-text)]">
                    Amount per advance type
                    <Required />
                  </p>
                  <p className="text-xs text-[var(--portal-muted)]">{typeItems.length} types</p>
                </div>
                <ul className="mt-2 space-y-2" aria-label="Amount per advance type">
                  {typeItems.map((item) => {
                    const label = typeLabel(item.advanceType)
                    return (
                      <li key={item.key} className="space-y-1">
                        <div className="grid items-center gap-2 sm:grid-cols-[minmax(0,1fr)_minmax(0,15rem)_auto]">
                          <span className="truncate text-sm font-medium text-[var(--portal-text)]" title={label}>
                            {label}
                          </span>
                          <div className={cn('adv-amount', Boolean(itemErrors[item.key]) && 'is-invalid')}>
                            <span className="adv-amount-currency">ETB</span>
                            <input
                              type="number"
                              min="0"
                              step="0.01"
                              inputMode="decimal"
                              placeholder="0.00"
                              aria-label={`Amount for ${label}`}
                              aria-invalid={Boolean(itemErrors[item.key])}
                              value={item.amount}
                              disabled={busy}
                              onChange={(event) => updateItemAmount(item.key, event.target.value)}
                            />
                          </div>
                          <Button
                            type="button"
                            variant="ghost"
                            size="sm"
                            className="h-10 justify-self-end"
                            disabled={busy}
                            aria-label={`Remove ${label}`}
                            onClick={() => selectTypes(typeItems.filter((row) => row.key !== item.key).map((row) => row.advanceType))}
                          >
                            <Trash2 className="h-4 w-4" />
                          </Button>
                        </div>
                        <FieldError message={itemErrors[item.key]} />
                      </li>
                    )
                  })}
                </ul>
                <p className="mt-3 text-right text-sm text-[var(--portal-text)]">
                  Total requested <span className="font-semibold tabular-nums">ETB {etb.format(amount)}</span>
                </p>
              </div>
            ) : null}
          </Section>

          <Section
            id="adv-s3"
            number={3}
            title="Supporting Documents & Submission"
            hint={
              files.length + savedAttachments.length
                ? `${files.length + savedAttachments.length} ${files.length + savedAttachments.length === 1 ? 'document' : 'documents'} attached`
                : 'Documents are optional'
            }
            done={section1Done && section2Done}
            shake={false}
          >
            {savedAttachments.length ? (
              <ul className="mb-3 space-y-2" aria-label="Documents already on the request">
                {savedAttachments.map((attachment) => {
                  const { Icon, tone } = attachmentVisual(attachment.fileName)
                  return (
                    <li key={attachment.id} className="adv-file">
                      <span className={cn('flex h-9 w-9 shrink-0 items-center justify-center rounded-lg ring-1', tone)} aria-hidden="true">
                        <Icon className="h-4 w-4" />
                      </span>
                      <div className="min-w-0 flex-1">
                        <p className="truncate text-sm font-medium text-[var(--portal-text)]">{attachment.fileName}</p>
                        <p className="truncate text-[11px] text-[var(--portal-muted)]">
                          {attachment.description || 'Saved in Business Central'}
                        </p>
                      </div>
                      <Button
                        type="button"
                        variant="ghost"
                        size="sm"
                        disabled={busy || removingAttachment === attachment.id}
                        aria-label={`Remove ${attachment.fileName}`}
                        onClick={() => void removeSavedAttachment(attachment)}
                      >
                        {removingAttachment === attachment.id ? <Loader2 className="h-4 w-4 animate-spin" /> : <Trash2 className="h-4 w-4" />}
                      </Button>
                    </li>
                  )
                })}
              </ul>
            ) : null}
            <input
              ref={fileInput}
              type="file"
              multiple
              accept=".pdf,.doc,.docx,.jpg,.png"
              className="sr-only"
              tabIndex={-1}
              aria-hidden="true"
              onChange={(event) => addFiles(event.target.files)}
            />
            <button
              type="button"
              className={cn('adv-drop', dragOver && 'is-over')}
              disabled={busy}
              onClick={() => fileInput.current?.click()}
              onDragOver={(event) => {
                event.preventDefault()
                if (!dragOver) setDragOver(true)
              }}
              onDragLeave={() => setDragOver(false)}
              onDrop={onDrop}
            >
              <UploadCloud className="adv-drop-icon h-7 w-7" aria-hidden="true" />
              <span className="font-medium text-[var(--portal-text)]">Drop documents here, or browse</span>
              <span className="text-xs text-[var(--portal-muted)]">
                Activity plan, assignment approval, budget support or other evidence. PDF, DOC, DOCX, JPG or PNG, up to 10 MB each.
              </span>
            </button>

            {files.length ? (
              <ul className="mt-3 space-y-2">
                {files.map((item, index) => {
                  const { Icon, tone } = attachmentVisual(item.file.name)
                  return (
                    <li key={item.id} className="adv-file" style={{ animationDelay: `${Math.min(index, 4) * 40}ms` }}>
                      <span className={cn('flex h-9 w-9 shrink-0 items-center justify-center rounded-lg ring-1', tone)} aria-hidden="true">
                        <Icon className="h-4 w-4" />
                      </span>
                      <div className="grid min-w-0 flex-1 gap-2 sm:grid-cols-[11rem_minmax(0,1fr)]">
                        <Select
                          aria-label={`Category for ${item.file.name}`}
                          value={item.category}
                          options={advanceAttachmentCategories}
                          onChange={(event) =>
                            setFiles((current) => current.map((row) => (row.id === item.id ? { ...row, category: event.target.value } : row)))
                          }
                        />
                        <Input
                          aria-label={`Description for ${item.file.name}`}
                          value={item.description}
                          maxLength={200}
                          onChange={(event) =>
                            setFiles((current) => current.map((row) => (row.id === item.id ? { ...row, description: event.target.value } : row)))
                          }
                        />
                        <p className="truncate text-[11px] text-[var(--portal-muted)] sm:col-span-2">
                          {item.file.name}, {formatFileSize(item.file.size)}
                        </p>
                      </div>
                      <Button
                        type="button"
                        variant="ghost"
                        size="sm"
                        disabled={busy}
                        aria-label={`Remove ${item.file.name}`}
                        onClick={() => setFiles((current) => current.filter((row) => row.id !== item.id))}
                      >
                        <Trash2 className="h-4 w-4" />
                      </Button>
                    </li>
                  )
                })}
              </ul>
            ) : null}

            <div className="adv-actions">
              <div className="flex flex-wrap gap-2">
                <Button type="button" variant="ghost" disabled={create.isPending || removeDraft.isPending} onClick={() => void cancel()}>
                  <X className="mr-1.5 h-4 w-4" />
                  Cancel
                </Button>
                <Button
                  type="button"
                  variant="ghost"
                  disabled={!historySteps.length}
                  title={historySteps.length ? undefined : 'History appears once the request has been sent for approval'}
                  onClick={() => scrollTo('adv-history')}
                >
                  <History className="mr-1.5 h-4 w-4" />
                  View History
                </Button>
                {request && canDeleteDocumentDraft(request.status, 'imprest') ? (
                  <Button
                    type="button"
                    variant="ghost"
                    className="text-rose-700 hover:bg-rose-50 hover:text-rose-800"
                    disabled={busy}
                    onClick={() => void deleteDraft()}
                  >
                    {removeDraft.isPending ? <Loader2 className="mr-1.5 h-4 w-4 animate-spin" /> : <Trash2 className="mr-1.5 h-4 w-4" />}
                    {removeDraft.isPending ? 'Deleting…' : 'Delete Draft'}
                  </Button>
                ) : null}
              </div>
              <div className="adv-actions-main">
                <Button type="button" variant="outline" disabled={busy} onClick={() => run(false)}>
                  {create.isPending && !create.variables?.submit ? (
                    <Loader2 className="mr-1.5 h-4 w-4 animate-spin" />
                  ) : (
                    <Save className="mr-1.5 h-4 w-4" />
                  )}
                  {create.isPending && !create.variables?.submit ? 'Saving…' : editing ? 'Save Draft' : 'Save as Draft'}
                </Button>
                <Button
                  type="button"
                  className="adv-submit"
                  disabled={busy || limitReached}
                  title={limitReached ? 'Settle one of your advances first: the limit of advances not settled is reached' : undefined}
                  onClick={() => run(true)}
                >
                  {create.isPending && create.variables?.submit ? (
                    <Loader2 className="mr-1.5 h-4 w-4 animate-spin" />
                  ) : (
                    <Send className="mr-1.5 h-4 w-4" />
                  )}
                  {create.isPending && create.variables?.submit ? 'Submitting…' : 'Submit for Approval'}
                </Button>
              </div>
            </div>
            <p className="mt-2 text-[11px] text-[var(--portal-muted)] sm:text-right" aria-live="polite">
              {create.isPending
                ? 'Saving to Business Central. This can take a few seconds.'
                : 'A draft is saved without starting approval. If Business Central refuses a submission, the draft stays and opens for correction.'}
            </p>
          </Section>
        </div>

        <aside className="space-y-4 lg:sticky lg:top-20">
          <section className="adv-section" aria-labelledby="adv-s4-title">
            <header className="adv-section-head">
              <span className={cn('adv-step', amount > 0 && 'is-done')} aria-hidden="true">
                4
              </span>
              <div>
                <h3 id="adv-s4-title" className="text-[0.95rem] font-semibold leading-tight">
                  Approval Workflow & Approval Limits
                </h3>
                <p className="text-xs text-white/70">The amount decides the final approver</p>
              </div>
            </header>
            <div className="p-4 sm:p-5">
              <p className="text-xs text-[var(--portal-muted)]">Requested amount</p>
              <p className={cn('adv-figure', amount > 0 ? 'text-[var(--portal-text)]' : 'text-[var(--portal-muted)]')}>
                <span className="adv-figure-currency">ETB</span>
                {etb.format(shownAmount)}
              </p>

              <div
                className="mt-4"
                role="img"
                aria-label={finalLimit ? `${finalLimit.range}: the final approver is ${finalLimit.approver}` : 'No amount entered yet'}
              >
                <div className="adv-meter">
                  {APPROVAL_LIMITS.map((limit) => (
                    <span key={limit.key} className={cn('adv-zone', `adv-zone--${limit.key}`, finalLimit?.key === limit.key && 'is-active')} />
                  ))}
                  <span className={cn('adv-marker', amount > 0 && 'is-set')} style={{ left: `${meterPosition * 100}%` }} />
                </div>
                <div className="adv-scale" aria-hidden="true">
                  <span>0</span>
                  <span>50k</span>
                  <span>100k</span>
                  <span>150k+</span>
                </div>
              </div>

              <ol className="adv-route mt-5" aria-label="Approval route">
                {[
                  { key: 'essp', label: 'ESSP', icon: <Monitor className="h-4 w-4" /> },
                  { key: 'bc', label: 'Business Central', icon: <Building2 className="h-4 w-4" /> },
                  { key: 'lm', label: 'Line Manager', icon: <UserCheck className="h-4 w-4" /> },
                  { key: 'final', label: finalLimit?.approver ?? 'Final approver', icon: <Landmark className="h-4 w-4" /> },
                ].map((node, index, all) => (
                  <li key={node.key} className="contents">
                    <span
                      className={cn('adv-node', amount > 0 && 'is-lit', node.key === 'final' && 'is-final')}
                      style={{ ['--d' as string]: `${index * 110}ms` }}
                    >
                      <span className="adv-node-dot">{node.icon}</span>
                      <span key={node.label} className="adv-node-label">
                        {node.label}
                      </span>
                    </span>
                    {index < all.length - 1 ? (
                      <span className={cn('adv-link', amount > 0 && 'is-lit')} style={{ ['--d' as string]: `${index * 110}ms` }} aria-hidden="true" />
                    ) : null}
                  </li>
                ))}
              </ol>

              <ul className="mt-4 overflow-hidden rounded-xl border border-[var(--portal-card-border)] text-sm">
                {APPROVAL_LIMITS.map((limit) => {
                  const active = finalLimit?.key === limit.key
                  return (
                    <li key={limit.key} className={cn('adv-limit', active && 'is-active')}>
                      <span>{limit.range}</span>
                      <span className="flex items-center gap-1.5 font-semibold">
                        {limit.approver}
                        {active ? <BadgeCheck className="h-4 w-4" aria-label="applies to this request" /> : null}
                      </span>
                    </li>
                  )
                })}
              </ul>
              <p className="mt-3 text-xs text-[var(--portal-muted)]">
                Business Central runs the approval. You follow its status, comments and payment reference here.
              </p>
            </div>
          </section>

          <section className="adv-section p-4" aria-label="Request checklist">
            <p className="text-sm font-semibold text-[var(--portal-text)]">Before you submit</p>
            <ul className="mt-2 space-y-1">
              {[
                { id: 'adv-s1', label: 'Purpose and justification', done: section1Done, detail: purposeLabel },
                {
                  id: 'adv-s2',
                  label: 'Dates, amount and advance type',
                  done: section2Done,
                  detail: section2Done
                    ? `${days} ${days === 1 ? 'day' : 'days'}, ${several ? `${typeItems.length} advance types` : advanceTypeLabel}`
                    : '',
                },
                {
                  id: 'adv-s3',
                  label: 'Supporting documents',
                  done: true,
                  detail: files.length + savedAttachments.length ? `${files.length + savedAttachments.length} attached` : 'Optional',
                },
              ].map((item) => (
                <li key={item.id}>
                  <button type="button" className="adv-check" onClick={() => scrollTo(item.id)}>
                    <span className={cn('adv-check-dot', item.done && 'is-done')} aria-hidden="true">
                      {item.done ? <Check className="h-3 w-3" strokeWidth={3} /> : null}
                    </span>
                    <span className="min-w-0 flex-1 text-left">
                      <span className="block text-sm text-[var(--portal-text)]">{item.label}</span>
                      {item.detail ? <span className="block truncate text-xs text-[var(--portal-muted)]">{item.detail}</span> : null}
                    </span>
                    <span className="sr-only">{item.done ? 'complete' : 'not complete'}</span>
                  </button>
                </li>
              ))}
            </ul>
          </section>
        </aside>
      </div>

      {historySteps.length ? (
        <div id="adv-history" className="scroll-mt-24">
          <ApprovalHistorySection steps={historySteps} />
        </div>
      ) : null}

      {success
        ? createPortal(
            <div className="adv-success" role="status" aria-live="assertive">
              <div className="adv-success-card">
                <svg className="adv-success-mark" viewBox="0 0 52 52" aria-hidden="true">
                  <circle cx="26" cy="26" r="24" />
                  <path d="M15 27 l7 7 l15 -16" />
                </svg>
                <p className="mt-4 text-lg font-semibold text-[var(--portal-text)]">
                  {success.submit ? 'Submitted for approval' : 'Saved as draft'}
                </p>
                <p className="mt-1 text-sm tabular-nums text-[var(--portal-muted)]">
                  {success.request.requestNo}
                  {success.submit && finalLimit ? `, to the Line Manager and then ${finalLimit.approver}` : ''}
                </p>
                <p className="mt-3 text-xs text-[var(--portal-muted)]">Opening the request…</p>
              </div>
            </div>,
            document.body,
          )
        : null}
    </div>
  )
}
