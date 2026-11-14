import { useMemo, useRef, useState, type ReactNode } from 'react'
import { zodResolver } from '@hookform/resolvers/zod'
import { useMutation, useQuery } from '@tanstack/react-query'
import { useForm, useWatch, type FieldValues, type Resolver } from 'react-hook-form'
import { differenceInCalendarDays, parseISO } from 'date-fns'
import {
  ArrowRight,
  Building2,
  CheckCircle2,
  Coins,
  FileStack,
  History,
  Info,
  Landmark,
  Loader2,
  Monitor,
  Paperclip,
  Save,
  Send,
  Trash2,
  UserCheck,
  UserRound,
  X,
} from 'lucide-react'
import { AuthApiError } from '@/api/client/authClient'
import { getEmployeeProfileDetails } from '@/api/endpoints/profile'
import { createModuleRequest, getModuleRequest, type EndpointConfig } from '@/api/endpoints/requestEndpoint'
import type { LookupOption } from '@/api/endpoints/lookups'
import { useToast } from '@/components/feedback/ToastProvider'
import { RequestProgress } from '@/components/shared/RequestProgress'
import type { TrackerStep } from '@/components/shared/ProcessTracker'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Select } from '@/components/ui/select'
import { Textarea } from '@/components/ui/textarea'
import { purposeRequiresOtherDetails } from '@/data/advanceRequestPurpose'
import { advanceAttachmentCategories } from '@/data/essOptions'
import { useAuth } from '@/hooks/useAuth'
import { cn } from '@/lib/utils'
import { advanceRequestCreateSchema } from '@/schemas/requestSchemas'
import { formatAmount, formatDateTime } from '@/utils/formatters'
import type { PortalRequest } from '@/types/erp.types'

const ALLOWED_EXTENSIONS = new Set(['pdf', 'doc', 'docx', 'jpg', 'png'])
const MAX_FILE_BYTES = 10_000_000

/** Developer handover §4.1: Line Manager first, then the final approver by amount. */
const APPROVAL_LIMITS = [
  { key: 'fad', range: '< ETB 50,000', approver: 'FAD', matches: (amount: number) => amount > 0 && amount < 50_000 },
  { key: 'coo', range: 'ETB 50,000 – 100,000', approver: 'COO', matches: (amount: number) => amount >= 50_000 && amount <= 100_000 },
  { key: 'ceo', range: '> ETB 100,000', approver: 'CEO', matches: (amount: number) => amount > 100_000 },
]

type PendingFile = { id: string; file: File; category: string; description: string }

function newRequestId() {
  // crypto.randomUUID needs a secure context; the portal also runs on plain http inside the LAN.
  return `adv-${Date.now().toString(36)}-${Math.random().toString(36).slice(2, 10)}`
}

function round2(value: number) {
  return Math.round(value * 100) / 100
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

function Section({ number, title, children, className }: { number: number; title: string; children: ReactNode; className?: string }) {
  return (
    <section className={cn('overflow-hidden rounded-xl border border-slate-200 bg-white shadow-sm', className)}>
      <header className="flex items-center gap-2 bg-[var(--portal-navy)] px-4 py-2.5 text-sm font-semibold text-white">
        <span className="flex h-6 w-6 items-center justify-center rounded-full bg-white/20 text-xs font-bold">{number}</span>
        {title}
      </header>
      <div className="p-4">{children}</div>
    </section>
  )
}

function ReadOnly({ label, value }: { label: string; value?: string }) {
  return (
    <div>
      <p className="text-xs text-slate-500">{label}</p>
      <p className="mt-0.5 rounded-md border border-slate-200 bg-slate-50 px-3 py-2 text-sm text-slate-900">{value?.trim() || '—'}</p>
    </div>
  )
}

function FieldError({ message }: { message?: unknown }) {
  return message ? <p className="text-xs text-red-600">{String(message)}</p> : null
}

/**
 * New Advance Request on one page, laid out as the ABH "ESSP – Advance Request" developer handover:
 * 1 Employee Information & Request Purpose · 2 Advance Request Details (Requested Amount in ETB)
 * · 3 Supporting Documents & Submission (Save as Draft / Submit for Approval / Cancel / View History)
 * · 4 Approval Workflow & Limits. Business Central creates the advance, its first line (the requested
 * amount on the chosen Advance Type), the attachments and — on Submit — starts its approval workflow.
 */
export function AdvanceRequestCreate({
  module,
  purposeOptions,
  purposeHint,
  advanceTypes,
  supportsProject,
  onCreated,
  onCancel,
}: {
  module: EndpointConfig
  purposeOptions: LookupOption[]
  purposeHint: string
  advanceTypes: LookupOption[]
  supportsProject: boolean
  onCreated: (request: PortalRequest) => void
  onCancel: () => void
}) {
  const toast = useToast()
  const { employee } = useAuth()
  const profileQuery = useQuery({
    queryKey: ['profile', 'details'],
    queryFn: getEmployeeProfileDetails,
    staleTime: 5 * 60 * 1000,
  })
  const profile = profileQuery.data
  const requestDate = useMemo(() => new Date().toISOString(), [])
  const today = requestDate.slice(0, 10)
  const clientRequestId = useRef(newRequestId())
  const [files, setFiles] = useState<PendingFile[]>([])
  const [formError, setFormError] = useState<string | null>(null)
  const fileInput = useRef<HTMLInputElement>(null)

  const form = useForm<FieldValues>({
    // The schema coerces Requested Amount to a number; the form keeps plain field values.
    resolver: zodResolver(advanceRequestCreateSchema) as unknown as Resolver<FieldValues>,
    defaultValues: {
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
      purpose: '',
    },
  })
  const errors = form.formState.errors
  const purposeCode = String(useWatch({ control: form.control, name: 'requestPurpose' }) ?? '')
  const activityStart = String(useWatch({ control: form.control, name: 'activityStartDate' }) ?? '')
  const amount = Number(useWatch({ control: form.control, name: 'requestedAmount' }) ?? 0) || 0
  const needsOther = purposeRequiresOtherDetails(purposeCode, purposeOptions)
  const finalLimit = APPROVAL_LIMITS.find((limit) => limit.matches(amount))
  const expectedApprovers: TrackerStep[] = [
    { key: 'line-manager', heading: 'Line Manager', owner: 'Approves every request first', icon: UserCheck },
    {
      key: 'final-approver',
      heading: finalLimit ? finalLimit.approver : 'FAD | COO | CEO',
      owner: finalLimit ? `Final approver · ${finalLimit.range}` : 'Final approver by amount',
      icon: Landmark,
    },
  ]

  const create = useMutation({
    mutationFn: async ({ values, submit }: { values: FieldValues; submit: boolean }) => {
      const attachments = await Promise.all(
        files.map(async (item) => ({
          fileName: item.file.name,
          fileType: item.file.type || 'application/octet-stream',
          size: item.file.size,
          contentBase64: await readFileBase64(item.file),
          description: `${item.category}: ${item.description.trim()}`,
        })),
      )
      const start = String(values.activityStartDate ?? '')
      const end = String(values.activityEndDate ?? '') || start
      const days = activityDays(start, end)
      const requested = round2(Number(values.requestedAmount))
      const code = String(values.requestPurpose ?? '').trim()
      const label = purposeOptions.find((option) => option.value === code)?.label ?? code
      const justification = String(values.justification ?? '').trim()
      return createModuleRequest(
        module,
        {
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
          // The requested amount (ETB) on the chosen Advance Type: BC needs the type for the account.
          lines: [
            {
              advanceType: values.advanceType,
              amount: requested,
              noOfDays: days,
              dailyRate: round2(requested / days),
              destination: '',
              dutyArea: '',
            },
          ],
          attachments,
          submit,
          clientRequestId: clientRequestId.current,
        },
        // Header, line, attachments and the BC approval workflow in one call.
        { timeout: 120_000 },
      )
    },
    onSuccess: (request, { submit }) => {
      toast.success(
        submit
          ? `${request.requestNo} was sent to Business Central for approval (Line Manager, then ${finalLimit?.approver ?? 'the final approver'}).`
          : `${request.requestNo} is saved as a draft. Nothing was sent for approval yet.`,
        submit ? 'Submitted for approval' : 'Saved as draft',
      )
      onCreated(request)
    },
    onError: async (error) => {
      const message = error instanceof Error ? error.message : 'Could not save the advance request.'
      const documentNo = error instanceof AuthApiError ? error.documentNo : undefined
      if (documentNo) {
        // BC saved the draft but a later step failed: keep it, open it, and say it was not submitted.
        toast.error(`${message} Open draft ${documentNo}, correct it and submit again.`, `Saved as draft ${documentNo} — not submitted`)
        try {
          onCreated(await getModuleRequest(module, `${module.module}-${documentNo}`))
        } catch {
          setFormError(`Draft ${documentNo} was saved, but could not be opened. Find it in My Advance Requests.`)
        }
        return
      }
      setFormError(message)
    },
  })

  const run = (submit: boolean) => {
    setFormError(null)
    void form.handleSubmit(
      (values) => {
        if (needsOther && !String(values.otherPurposeDetails ?? '').trim()) {
          form.setError('otherPurposeDetails', { type: 'manual', message: 'Enter details when Other (Specify) is selected' })
          return
        }
        create.mutate({ values, submit })
      },
      () => setFormError('Complete the fields marked in red. All mandatory fields must be completed and validated.'),
    )()
  }

  const addFiles = (list: FileList | null) => {
    if (!list) return
    const next: PendingFile[] = []
    for (const file of Array.from(list)) {
      const extension = file.name.split('.').pop()?.toLowerCase() ?? ''
      if (!ALLOWED_EXTENSIONS.has(extension)) {
        toast.error(`${file.name} is not an allowed file type (PDF, DOC, DOCX, JPG, PNG).`, 'Invalid file')
        continue
      }
      if (file.size > MAX_FILE_BYTES) {
        toast.error(`${file.name} exceeds 10 MB.`, 'File too large')
        continue
      }
      next.push({
        id: `${file.name}-${file.size}-${file.lastModified}-${Math.random().toString(36).slice(2, 6)}`,
        file,
        category: advanceAttachmentCategories[0]!.value,
        description: file.name.replace(/\.[^.]+$/, ''),
      })
    }
    setFiles((current) => [...current, ...next])
    if (fileInput.current) fileInput.current.value = ''
  }

  const busy = create.isPending
  const busyLabel = create.variables?.submit ? 'Submitting…' : 'Saving…'

  return (
    <div className="space-y-4">
      {/* Standard: Workflow Progress first. */}
      <RequestProgress status="Draft" creating="new" requiresLines={false} expectedApprovers={expectedApprovers} />

      <div className="flex flex-wrap items-center justify-between gap-2">
        <h2 className="text-lg font-semibold text-slate-900">New Advance Request</h2>
        <p className="text-xs text-slate-500">
          Fields marked <span className="font-semibold text-red-600">*</span> are mandatory. Settlement is not part of this form.
        </p>
      </div>

      {formError ? (
        <div className="rounded-lg border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-700">{formError}</div>
      ) : null}

      <div className="grid gap-4 xl:grid-cols-2">
        <Section number={1} title="Employee Information & Request Purpose">
          <p className="mb-2 text-xs font-semibold uppercase tracking-wide text-slate-500">Employee information (auto-filled)</p>
          <div className="grid gap-3 sm:grid-cols-2">
            <ReadOnly label="Employee Name" value={profile?.fullName || employee?.displayName} />
            <ReadOnly label="Employee Number" value={profile?.employeeNo || employee?.employeeNo} />
            <ReadOnly label="Designation / Job Title" value={profile?.jobTitle || employee?.jobTitle} />
            <ReadOnly label="Department" value={profile?.department || employee?.departmentName || employee?.departmentCode} />
            <ReadOnly label="Division" value={profile?.division} />
            <ReadOnly label="Employment Status" value={profile?.status || profile?.employmentType} />
          </div>
          {profileQuery.isError ? (
            <p className="mt-2 text-xs text-red-600">Employee details could not be loaded from Business Central.</p>
          ) : null}

          <div className="mt-4 grid gap-3">
            <div className="space-y-1.5">
              <Label htmlFor="adv-purpose">
                Request Purpose <span className="text-red-600">*</span>
              </Label>
              <Select id="adv-purpose" options={purposeOptions} placeholder="Select purpose (based on your division)" {...form.register('requestPurpose')} />
              <p className="text-xs text-slate-500">{purposeHint}</p>
              <FieldError message={errors.requestPurpose?.message} />
            </div>
            {needsOther ? (
              <div className="space-y-1.5">
                <Label htmlFor="adv-other">
                  Other Purpose Details <span className="text-red-600">*</span>
                </Label>
                <Textarea id="adv-other" rows={2} maxLength={250} placeholder="Describe the purpose" {...form.register('otherPurposeDetails')} />
                <FieldError message={errors.otherPurposeDetails?.message} />
              </div>
            ) : (
              <p className="flex items-center gap-1.5 text-xs text-slate-500">
                <Info className="h-3.5 w-3.5" /> If “Other (Specify)” is selected, Other Purpose Details is mandatory.
              </p>
            )}
            <div className="space-y-1.5">
              <Label htmlFor="adv-justification">
                Request Justification <span className="text-red-600">*</span>
              </Label>
              <Textarea id="adv-justification" rows={3} maxLength={250} placeholder="Explain why the advance is needed" {...form.register('justification')} />
              <FieldError message={errors.justification?.message} />
            </div>
          </div>
        </Section>

        <Section number={2} title="Advance Request Details">
          <div className="grid gap-3 sm:grid-cols-2">
            <div className="space-y-1.5">
              <Label>Request Date</Label>
              <p className="rounded-md border border-slate-200 bg-slate-50 px-3 py-2 text-sm text-slate-900">{formatDateTime(requestDate)}</p>
              <p className="text-xs text-slate-500">System generated (read-only)</p>
            </div>
            <div className="space-y-1.5">
              <Label htmlFor="adv-required">
                Required Advance Date <span className="text-red-600">*</span>
              </Label>
              <Input id="adv-required" type="date" min={today} {...form.register('dateRequired')} />
              <p className="text-xs text-slate-500">When you need the funds: today or later, on or before the activity start.</p>
              <FieldError message={errors.dateRequired?.message} />
            </div>
            <div className="space-y-1.5">
              <Label htmlFor="adv-start">
                Activity Start Date <span className="text-red-600">*</span>
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
              <Label htmlFor="adv-end">Activity End Date</Label>
              <Input id="adv-end" type="date" min={activityStart || today} {...form.register('activityEndDate')} />
              <p className="text-xs text-slate-500">End Date ≥ Start Date</p>
              <FieldError message={errors.activityEndDate?.message} />
            </div>
            <div className="space-y-1.5 sm:col-span-2">
              <Label htmlFor="adv-location">Activity Location</Label>
              <Input id="adv-location" maxLength={250} placeholder="Where the activity will take place (where relevant)" {...form.register('activityLocation')} />
            </div>
            {supportsProject ? (
              <div className="space-y-1.5 sm:col-span-2">
                <Label htmlFor="adv-project">Project / Assignment (optional)</Label>
                <Input id="adv-project" maxLength={100} placeholder="Related project or assignment, if applicable" {...form.register('projectAssignment')} />
                <FieldError message={errors.projectAssignment?.message} />
              </div>
            ) : null}
            <div className="space-y-1.5">
              <Label htmlFor="adv-amount">
                Requested Amount <span className="text-red-600">*</span>
              </Label>
              <div className="flex">
                <Input id="adv-amount" type="number" min="0" step="0.01" inputMode="decimal" placeholder="0.00" className="rounded-r-none" {...form.register('requestedAmount')} />
                <span className="inline-flex items-center rounded-r-md border border-l-0 border-slate-200 bg-slate-100 px-3 text-sm font-semibold text-slate-700">
                  ETB
                </span>
              </div>
              <p className="text-xs text-slate-500">Greater than 0. Currency: ETB (default).</p>
              <FieldError message={errors.requestedAmount?.message} />
            </div>
            <div className="space-y-1.5">
              <Label htmlFor="adv-type">
                Advance Type <span className="text-red-600">*</span>
              </Label>
              <Select id="adv-type" options={advanceTypes} placeholder="Select advance type" {...form.register('advanceType')} />
              <p className="text-xs text-slate-500">The Business Central account the advance is paid from.</p>
              <FieldError message={errors.advanceType?.message} />
            </div>
          </div>
          <p className="mt-3 flex items-center gap-1.5 rounded-lg bg-sky-50 px-3 py-2 text-xs text-sky-900">
            <Info className="h-3.5 w-3.5 shrink-0" /> All mandatory fields must be completed and validated. You can add more advance
            lines (for example per diem and transport) after saving.
          </p>
        </Section>

        <Section number={3} title="Supporting Documents & Submission">
          <div className="grid gap-4 md:grid-cols-[1fr_13rem]">
            <div>
              <p className="text-sm font-medium text-slate-800">Supporting documents</p>
              <p className="text-xs text-slate-500">
                Activity plan, assignment approval, budget support or other evidence. Multiple attachments allowed (PDF, DOC,
                DOCX, JPG, PNG; up to 10 MB each).
              </p>
              <input
                ref={fileInput}
                type="file"
                multiple
                accept=".pdf,.doc,.docx,.jpg,.png"
                className="hidden"
                onChange={(event) => addFiles(event.target.files)}
              />
              <Button type="button" variant="outline" className="mt-2" disabled={busy} onClick={() => fileInput.current?.click()}>
                <Paperclip className="mr-2 h-4 w-4" />
                Add documents
              </Button>
              {files.length ? (
                <ul className="mt-3 space-y-2">
                  {files.map((item) => (
                    <li key={item.id} className="grid gap-2 rounded-lg border border-slate-200 bg-slate-50/80 p-2 sm:grid-cols-[10rem_1fr_auto] sm:items-center">
                      <Select
                        aria-label="Document category"
                        value={item.category}
                        options={advanceAttachmentCategories}
                        onChange={(event) =>
                          setFiles((current) => current.map((row) => (row.id === item.id ? { ...row, category: event.target.value } : row)))
                        }
                      />
                      <Input
                        aria-label="Document description"
                        value={item.description}
                        maxLength={200}
                        onChange={(event) =>
                          setFiles((current) => current.map((row) => (row.id === item.id ? { ...row, description: event.target.value } : row)))
                        }
                      />
                      <Button
                        type="button"
                        variant="ghost"
                        size="sm"
                        aria-label={`Remove ${item.file.name}`}
                        onClick={() => setFiles((current) => current.filter((row) => row.id !== item.id))}
                      >
                        <Trash2 className="h-4 w-4" />
                      </Button>
                      <p className="truncate text-[11px] text-slate-500 sm:col-span-3">
                        <FileStack className="mr-1 inline h-3 w-3" />
                        {item.file.name} · {(item.file.size / 1024).toFixed(0)} KB
                      </p>
                    </li>
                  ))}
                </ul>
              ) : (
                <p className="mt-2 text-xs text-slate-500">No documents added yet (optional).</p>
              )}
            </div>
            <div className="flex flex-col gap-2">
              <p className="text-sm font-medium text-slate-800">Actions</p>
              <Button type="button" variant="outline" disabled={busy} onClick={() => run(false)}>
                {busy && !create.variables?.submit ? <Loader2 className="mr-2 h-4 w-4 animate-spin" /> : <Save className="mr-2 h-4 w-4" />}
                {busy && !create.variables?.submit ? busyLabel : 'Save as Draft'}
              </Button>
              <Button type="button" className="bg-emerald-600 text-white hover:bg-emerald-700" disabled={busy} onClick={() => run(true)}>
                {busy && create.variables?.submit ? <Loader2 className="mr-2 h-4 w-4 animate-spin" /> : <Send className="mr-2 h-4 w-4" />}
                {busy && create.variables?.submit ? busyLabel : 'Submit for Approval'}
              </Button>
              <Button type="button" variant="outline" disabled={busy} onClick={onCancel}>
                <X className="mr-2 h-4 w-4" />
                Cancel
              </Button>
              <Button type="button" variant="outline" disabled title="History is available once the request is saved.">
                <History className="mr-2 h-4 w-4" />
                View History
              </Button>
              <p className="text-[11px] leading-snug text-slate-500">
                Save as Draft keeps your entries without starting approval. If Business Central rejects a submission, the
                draft is kept and opened so you can correct it.
              </p>
            </div>
          </div>
        </Section>

        <Section number={4} title="Approval Workflow & Approval Limits">
          <ol className="flex flex-wrap items-center gap-2 text-center text-xs font-semibold text-slate-700">
            {[
              { icon: <Monitor className="h-5 w-5" />, label: 'ESSP Submission' },
              { icon: <Building2 className="h-5 w-5" />, label: 'Microsoft Dynamics 365 Business Central' },
              { icon: <UserRound className="h-5 w-5" />, label: 'Line Manager Approval' },
            ].map((step, index) => (
              <li key={step.label} className="flex items-center gap-2">
                <span className="flex w-28 flex-col items-center gap-1 rounded-lg border border-slate-200 bg-slate-50 px-2 py-2 text-[var(--portal-navy)]">
                  {step.icon}
                  <span className="text-slate-700">{step.label}</span>
                </span>
                {index < 2 ? <ArrowRight className="h-4 w-4 text-slate-400" /> : null}
              </li>
            ))}
          </ol>
          <div className="mt-3 overflow-hidden rounded-lg border border-slate-200">
            <p className="flex items-center gap-2 bg-slate-50 px-3 py-2 text-xs font-semibold uppercase tracking-wide text-slate-600">
              <Coins className="h-4 w-4" /> Final approver (by amount)
            </p>
            <table className="w-full text-sm">
              <tbody>
                {APPROVAL_LIMITS.map((limit) => {
                  const active = finalLimit?.key === limit.key
                  return (
                    <tr key={limit.key} className={cn('border-t border-slate-100', active && 'bg-teal-50 font-semibold text-teal-900')}>
                      <td className="px-3 py-2">{limit.range}</td>
                      <td className="px-3 py-2 text-right">
                        → {limit.approver}
                        {active ? <CheckCircle2 className="ml-1.5 inline h-4 w-4 text-teal-600" /> : null}
                      </td>
                    </tr>
                  )
                })}
              </tbody>
            </table>
          </div>
          <p className="mt-2 text-xs text-slate-500">
            {amount > 0
              ? `For ${formatAmount(amount)} the Line Manager approves first, then ${finalLimit?.approver}. Business Central runs the workflow; ESSP shows its status.`
              : 'The Line Manager approves every request first, then the final approver by amount. Business Central runs the workflow; ESSP shows its status.'}
          </p>
        </Section>
      </div>
    </div>
  )
}
