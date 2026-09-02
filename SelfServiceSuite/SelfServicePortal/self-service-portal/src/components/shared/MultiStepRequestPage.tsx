import { zodResolver } from '@hookform/resolvers/zod'
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { AlertCircle, ArrowLeft, Pencil, Plus, Send, Trash2 } from 'lucide-react'
import { useEffect, useMemo, useRef, useState, type ReactNode } from 'react'
import {
  type FieldValues,
  type Resolver,
  type UseFormReturn,
  useForm,
  useWatch,
} from 'react-hook-form'
import { PageWrapper } from '@/components/layout/PageWrapper'
import { PortalFormCard } from '@/components/shared/PortalFormCard'
import { PortalNewButton } from '@/components/shared/PortalNewButton'
import { useToast } from '@/components/feedback/ToastProvider'
import { useConfirm } from '@/components/feedback/ConfirmProvider'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Select } from '@/components/ui/select'
import { Skeleton } from '@/components/ui/skeleton'
import { Textarea } from '@/components/ui/textarea'
import { DataTable, type DataTableColumn } from './DataTable'
import { RequestAttachments } from './RequestAttachments'
import { StatusBadge } from './StatusBadge'
import { RequestProgress } from './RequestProgress'
import { ApprovalHistory } from './ApprovalHistory'
import {
  normalizeAndValidateSelectValues,
  type DetailFieldConfig,
  type FieldConfig,
} from './RequestFormPage'
import {
  addRequestLine,
  cancelModuleRequest,
  createModuleRequest,
  deleteModuleRequest,
  deleteRequestLine,
  getModuleRequest,
  postStoreRequestReceipt,
  receiveStoreRequestLine,
  setRequestLines,
  submitModuleRequest,
  updateRequestHeader,
  updateRequestLine,
  type EndpointConfig,
} from '@/api/endpoints/requestEndpoint'
import { formatCurrency, formatDate } from '@/utils/formatters'
import { cn } from '@/lib/utils'
import { canDeleteDocumentDraft, canDeleteRequestItems, canRequestApproval, canUploadRequestAttachments, isEditableRequestStatus, PORTAL_ATTACHMENT_MODULES, shouldShowApprovalHistory } from '@/utils/requestStatus'
import type { PortalRequest } from '@/types/erp.types'

export interface LineColumn {
  key: string
  header: string
  format?: (value: unknown, line: Record<string, unknown>) => ReactNode
  /** Hide workflow-specific columns when none of the current lines uses them. */
  visibleWhen?: (lines: Record<string, unknown>[]) => boolean
}

interface MultiStepDetailFieldConfig extends DetailFieldConfig {
  /** Resolve a display value from the complete request when payload paths are not enough. */
  resolve?: (request: PortalRequest) => unknown
}

export interface MultiStepLineConfig {
  /** Section heading, e.g. "Claim Lines". */
  label: string
  addLabel?: string
  schema: Parameters<typeof zodResolver>[0]
  defaultValues: FieldValues
  fields: FieldConfig[]
  /** Resolve fields/options after the header is saved (for header-scoped lookups). */
  fieldsFromRequest?: (request: PortalRequest) => FieldConfig[]
  /** Hook variant of fieldsFromRequest — use when line fields need their own lookup queries. */
  useLineFieldsFromRequest?: (request: PortalRequest | undefined) => FieldConfig[]
  columns: LineColumn[]
  /** Map line form values to the API payload (defaults to identity). */
  buildLinePayload?: (values: FieldValues) => Record<string, unknown>
  /** When false, lines are created by the backend and only edited inline (e.g. imprest surrender). */
  canAdd?: boolean
  /** ESS modules without a line-update SOAP method can still add/delete lines. */
  canEdit?: boolean
  /** Inline-editable cell fields for backend-generated lines (keyed by line property). */
  editableFields?: FieldConfig[]
  /** Resolve editable fields from the saved request (e.g. gate on header Actual Return Date). */
  editableFieldsFromRequest?: (request: PortalRequest) => FieldConfig[]
  /** Only show lines matching this filter in the inline editor (save still sends all rows). */
  linesFilter?: (row: Record<string, unknown>) => boolean
  /** Hint shown above the inline line editor. */
  lineHint?: string
  lineHintFromRequest?: (request: PortalRequest) => string | undefined
  /** Replace the default inline line table (e.g. imprest surrender expenditure form). */
  customLineEditor?: (ctx: { request: PortalRequest; onChanged: () => void }) => ReactNode
  /** React to line field changes (ESS auto-calculations). */
  onValuesChange?: (
    values: FieldValues,
    form: UseFormReturn<FieldValues>,
    requestId: string,
  ) => void | Promise<void>
  /** Seed new line defaults from the saved request header (e.g. travel destination). */
  defaultValuesFromRequest?: (request: PortalRequest) => FieldValues
  emptyText?: string
  /** Some documents may legitimately have no child lines. Defaults to true. */
  required?: boolean
  /** Override the toast shown when Request Approval is clicked with zero lines. */
  requiredMessage?: string
}

export interface MultiStepRequestConfig {
  title: string
  description?: string
  /** Optional process-flow banner shown on list, create, and detail views. */
  processBanner?: ReactNode
  /** Some workflows should show the process only after a request is started. */
  showProcessBannerOnList?: boolean
  module: EndpointConfig
  queryKey: readonly unknown[]
  listRequests: () => Promise<PortalRequest[]>
  /** Header create form. */
  headerSchema: Parameters<typeof zodResolver>[0]
  headerDefaults: FieldValues
  headerFields: FieldConfig[]
  /** Optional read-only content derived from the current header form values. */
  headerSupplement?: (values: FieldValues) => ReactNode
  /** Keep derived header fields in sync (e.g. Expected Return after Travel Start). */
  headerOnValuesChange?: (
    values: FieldValues,
    form: UseFormReturn<FieldValues>,
  ) => void | Promise<void>
  /** Map header form values to the create payload (defaults to identity). */
  buildHeaderPayload?: (values: FieldValues) => Record<string, unknown>
  line?: MultiStepLineConfig
  newButtonLabel?: string
  headerLabel?: string
  initialMode?: 'list' | 'create'
  /** Curated fields shown on the detail screen. Undefined values are hidden. */
  detailFields?: MultiStepDetailFieldConfig[]
  /** Custom line section on the detail screen (overrides default line table). */
  customLineSection?: (ctx: { request: PortalRequest; onChanged: () => void }) => ReactNode
  /** Statuses from which Business Central allows cancellation. */
  cancelStatuses?: PortalRequest['status'][]
  /** Optional status chips on the list view (All / Pending / Approved / Rejected / Draft). */
  listStatusFilter?: boolean
  /** Extra list-row values included in the search box (e.g. ERP destination on imprest). */
  listSearchExtra?: (row: PortalRequest) => Array<string | number | undefined | null>
  /**
   * Replaces the generic Amount column. Use false for flows with no meaningful
   * list metric, or provide a quantity/asset/value column appropriate to the
   * Business Central document.
   */
  listValueColumn?: DataTableColumn<PortalRequest> | false
  /** When false, hides BC document attachments (fuel, store, etc.). Defaults from module key. */
  supportsAttachments?: boolean
  /** Template attachment categories (e.g. store requisition spec / drawing / photo). */
  attachmentCategoryOptions?: Array<{ label: string; value: string }>
  attachmentCategoryHint?: string
  /** Prevent approval until at least one BC document attachment exists. */
  requiresAttachmentBeforeSubmit?: boolean
  requiredAttachmentMessage?: string
  /** Extra validation before Request Approval (return an error message or null). */
  validateBeforeSubmit?: (request: PortalRequest) => string | null
  /** Extra block on the detail screen (e.g. Operations stock check on purchase requests). */
  detailSupplement?: (ctx: { request: PortalRequest }) => ReactNode
  /** Module-specific detail actions (e.g. Post Asset Transfer). */
  extraDetailActions?: Array<{
    id: string
    label: string
    visibleWhen?: (request: PortalRequest) => boolean
    confirm?: { title: string; message: string; confirmLabel?: string }
    run: (requestId: string) => Promise<unknown>
    successMessage?: string
  }>
  /** Keep the default top action bar or place it after all detail sections. */
  detailActionsPlacement?: 'top' | 'bottom'
}

function pathValue(source: unknown, path: string) {
  return path.split('.').reduce<unknown>((current, part) => {
    if (!current || typeof current !== 'object') return undefined
    return (current as Record<string, unknown>)[part]
  }, source)
}

function firstPathValue(source: unknown, paths: string[], format: DetailFieldConfig['format'] = 'text') {
  for (const path of paths) {
    const value = pathValue(source, path)
    if (value === undefined || value === null || String(value).trim() === '') continue
    // BC returns 0 for uncalculated FlowFields and 0001-01-01 for unset dates —
    // keep searching the fallback chain; hide the field when nothing real is found.
    if (format === 'currency' && Number(value) === 0) continue
    if (format === 'date' && String(value).trim().startsWith('0001-01-01')) continue
    return value
  }
  return undefined
}

function detailValue(value: unknown, format: DetailFieldConfig['format'] = 'text') {
  if (format === 'status') return <StatusBadge status={String(value ?? '-')} />
  if (format === 'date') return formatDate(value === undefined ? undefined : String(value))
  if (format === 'currency') return formatCurrency(Number(value ?? 0))
  if (format === 'percentage') return `${Number(value ?? 0)}%`
  if (format === 'storePriority') {
    const key = String(value ?? '').trim().toLowerCase()
    const labels: Record<string, string> = {
      '0': 'Low',
      '1': 'Normal',
      '2': 'High',
      '3': 'Urgent',
      low: 'Low',
      normal: 'Normal',
      high: 'High',
      urgent: 'Urgent',
    }
    return labels[key] ?? String(value ?? '-')
  }
  if (format === 'purchasePriority') {
    const key = String(value ?? '').trim().toLowerCase()
    const labels: Record<string, string> = {
      '0': 'Low (legacy)',
      '1': 'Normal',
      '2': 'Critical',
      '3': 'Urgent',
      low: 'Low (legacy)',
      normal: 'Normal',
      high: 'Critical',
      critical: 'Critical',
      urgent: 'Urgent',
    }
    return labels[key] ?? String(value ?? '-')
  }
  if (format === 'purchaseRequestType') {
    const key = String(value ?? '').trim().toLowerCase()
    const labels: Record<string, string> = {
      '0': 'Goods',
      '1': 'Services',
      '2': 'Asset (legacy)',
      '3': 'Consultancy',
      '4': 'Other',
      goods: 'Goods',
      service: 'Services',
      services: 'Services',
      asset: 'Asset (legacy)',
      consultancy: 'Consultancy',
      other: 'Other',
      item: 'Goods',
    }
    return labels[key] ?? String(value ?? '-')
  }
  if (format === 'returned') {
    const returned = value === true || ['true', 'yes', '1'].includes(String(value ?? '').toLowerCase())
    return returned ? 'Returned' : 'Not Returned'
  }
  return String(value ?? '-')
}

function storeRequisitionApprovalComplete(request: PortalRequest | undefined) {
  if (!request) return false
  const normalized = request.status.trim().toLowerCase()
  if (['approved', 'posted', 'released'].includes(normalized)) return true
  const steps = request.approvalSteps ?? []
  if (!steps.length) return false
  return steps.every((step) => step.status === 'Approved')
}

function storeLineNeedsReceipt(row: Record<string, unknown>) {
  const received = Number(row.quantityReceived ?? 0)
  const issued = Number(row.quantityIssued ?? 0)
  // Receipt confirmation is only meaningful after store has issued stock.
  return issued > 0 && received < issued
}

function storeRequisitionHasIssuedLines(lines: Record<string, unknown>[]) {
  return lines.some((line) => Number(line.quantityIssued ?? 0) > 0)
}

function normalizedFieldName(value: string) {
  return value.replace(/[^a-z0-9]/gi, '').toLowerCase()
}

function normalizeEditFieldValue(field: FieldConfig, value: unknown) {
  if (value === undefined || value === null) return value
  if (field.type === 'date') {
    const raw = String(value).trim()
    if (!raw || raw.startsWith('0001-01-01')) return ''
    return raw.slice(0, 10)
  }
  if (field.type === 'select' || field.type === 'text' || field.type === 'textarea') {
    const raw = String(value).trim()
    return raw
  }
  return value
}

function initialFieldValue(source: Record<string, unknown>, field: FieldConfig, fallback: unknown) {
  const mapped = (value: unknown) => {
    const normalized = normalizeEditFieldValue(field, value)
    if (normalized === '' || normalized === undefined || normalized === null) return normalized
    const key = String(normalized ?? '').trim().toLowerCase()
    return field.valueMap?.[key] ?? normalized
  }
  for (const path of field.valuePaths ?? [field.name]) {
    const value = pathValue(source, path)
    if (value === undefined || value === null) continue
    const mappedValue = mapped(value)
    // Skip blank / unset so later valuePaths (and fallbacks) can still match.
    if (mappedValue === '' || mappedValue === undefined || mappedValue === null) continue
    if (field.type === 'date' && String(mappedValue).startsWith('0001-01-01')) continue
    return mappedValue
  }
  const target = normalizedFieldName(field.name)
  const key = Object.keys(source).find((candidate) => normalizedFieldName(candidate) === target)
  if (key) {
    const mappedValue = mapped(source[key])
    if (mappedValue !== '' && mappedValue !== undefined && mappedValue !== null) return mappedValue
  }
  return fallback
}

function fieldRenderer(form: UseFormReturn<FieldValues>, prefix = '', watchedValues: FieldValues = {}) {
  return function renderField(field: FieldConfig) {
    if (field.visibleWhen && !field.visibleWhen(watchedValues)) return null
    const name = prefix ? `${prefix}.${field.name}` : field.name
    const inputId = name.replaceAll('.', '-')
    const error = form.formState.errors?.[field.name]
    const message = error && typeof error === 'object' && 'message' in error ? String((error as { message?: unknown }).message ?? '') : ''
    const options = field.optionsByField
      ? field.optionsByField.options[String(pathValue(watchedValues, field.optionsByField.field) ?? '')] ?? []
      : field.options ?? []
    const readOnly = field.readOnly || Boolean(field.readOnlyWhen?.(watchedValues))
    const spanFull = field.fullWidth || field.type === 'textarea'
    return (
      <div
        key={name}
        className={
          field.type === 'checkbox'
            ? 'flex items-center gap-2'
            : spanFull
              ? 'space-y-1.5 md:col-span-2'
              : 'space-y-1.5'
        }
      >
        {field.type !== 'checkbox' ? <Label htmlFor={inputId}>{field.label}</Label> : null}
        {field.type === 'textarea' ? (
          <Textarea
            id={inputId}
            placeholder={field.placeholder}
            readOnly={readOnly}
            rows={3}
            className="min-h-[4.5rem]"
            {...form.register(name)}
          />
        ) : null}
        {field.type === 'select' ? (
          <Select
            id={inputId}
            placeholder={field.placeholder ?? 'Select'}
            options={
              (() => {
                const current = String(pathValue(watchedValues, field.name) ?? form.getValues(name) ?? '')
                if (!current || options.some((option) => option.value === current)) return options
                return [{ label: current, value: current }, ...options]
              })()
            }
            disabled={readOnly}
            className="w-full"
            {...form.register(name)}
            value={String(pathValue(watchedValues, field.name) ?? form.getValues(name) ?? '')}
            onChange={(event) => {
              form.setValue(name, event.target.value, { shouldDirty: true, shouldValidate: true })
            }}
          />
        ) : null}
        {['text', 'number', 'date'].includes(field.type) ? (
          <Input
            id={inputId}
            type={field.type}
            placeholder={field.placeholder}
            readOnly={readOnly}
            min={field.type === 'number' ? 0 : undefined}
            step={field.type === 'number' ? 'any' : undefined}
            {...form.register(
              name,
              field.type === 'number'
                ? {
                    setValueAs: (value) => {
                      if (value === '' || value === null || value === undefined) return ''
                      const parsed = Number(value)
                      return Number.isFinite(parsed) ? parsed : ''
                    },
                  }
                : undefined,
            )}
          />
        ) : null}
        {field.type === 'checkbox' ? (
          <>
            <input id={inputId} type="checkbox" className="h-4 w-4 rounded border-slate-300" {...form.register(name)} />
            <Label htmlFor={inputId}>{field.label}</Label>
          </>
        ) : null}
        {message ? <p className="text-xs font-medium text-red-600">{message}</p> : null}
      </div>
    )
  }
}

function HeaderForm({
  config,
  request,
  onCreated,
  onCancel,
}: {
  config: MultiStepRequestConfig
  request?: PortalRequest
  onCreated: (request: PortalRequest) => void
  onCancel: () => void
}) {
  const initialValues = request
    ? Object.fromEntries(
        config.headerFields.map((field) => [
          field.name,
          initialFieldValue(request.payload ?? {}, field, config.headerDefaults[field.name]),
        ]),
      )
    : config.headerDefaults
  const form = useForm<FieldValues>({
    resolver: zodResolver(config.headerSchema) as Resolver<FieldValues>,
    defaultValues: initialValues,
    mode: 'onBlur',
  })
  const watchedValues = useWatch({ control: form.control })
  const render = fieldRenderer(form, '', watchedValues)
  const toast = useToast()
  const singleColumnHeader = config.headerFields.length <= 1
  const headerOnValuesChange = config.headerOnValuesChange
  useEffect(() => {
    if (request) return
    const fillKeys = ['division', 'requestedBy', 'requestingDepartment']
    for (const key of fillKeys) {
      const next = config.headerDefaults[key]
      if (next === undefined || next === null || String(next).trim() === '') continue
      const current = form.getValues(key)
      if (!String(current ?? '').trim()) {
        form.setValue(key, next, { shouldValidate: false })
      }
    }
  }, [
    config.headerDefaults.division,
    config.headerDefaults.requestedBy,
    config.headerDefaults.requestingDepartment,
    form,
    request,
  ])
  useEffect(() => {
    if (!headerOnValuesChange) return
    void headerOnValuesChange(watchedValues as FieldValues, form)
  }, [watchedValues, form, headerOnValuesChange])
  const mutation = useMutation({
    mutationFn: (values: FieldValues) => {
      const payload = config.buildHeaderPayload ? config.buildHeaderPayload(values) : values
      return request
        ? updateRequestHeader(request.id, payload)
        : createModuleRequest(config.module, { ...payload, submit: false })
    },
    onSuccess: (savedRequest) => {
      toast.success(
        request ? 'Request updated successfully.' : 'Draft created. Add lines, then request approval.',
        `${config.title} saved`,
      )
      onCreated(savedRequest)
    },
    onError: (error) =>
      toast.error(error instanceof Error ? error.message : 'Could not create the request', 'Save failed'),
  })

  return (
    <PageWrapper title={request ? `Edit ${config.title}` : config.headerLabel ?? config.title} showPageHeading={false}>
      <PortalFormCard
        title={request ? `Edit ${config.title}` : config.headerLabel ?? config.title}
        allowOverflow
      >
        <form className="space-y-4" onSubmit={(event) => event.preventDefault()}>
          {config.description ? <p className="text-sm text-slate-600">{config.description}</p> : null}
          {config.processBanner}
          <div
            className={cn(
              'grid gap-3 sm:gap-4',
              singleColumnHeader ? 'mx-auto w-full max-w-xl grid-cols-1' : 'sm:grid-cols-1 md:grid-cols-2',
            )}
          >
            {config.headerFields.map((field) => render(field))}
          </div>
          {config.headerSupplement ? config.headerSupplement(watchedValues) : null}
          {mutation.error ? (
            <div className="flex items-start gap-2 rounded-md border border-red-200 bg-red-50 p-3 text-sm text-red-700">
              <AlertCircle className="mt-0.5 h-4 w-4" />
              {mutation.error instanceof Error ? mutation.error.message : 'Request failed'}
            </div>
          ) : null}
          <div className="grid grid-cols-1 gap-2 pt-2 sm:flex sm:flex-wrap sm:justify-center">
            <Button type="button" variant="outline" className="rounded-full" disabled={mutation.isPending} onClick={onCancel}>
              Cancel
            </Button>
            <Button
              type="button"
              className="rounded-full"
              disabled={mutation.isPending}
              onClick={() => {
                const currentValues = form.getValues()
                if (!normalizeAndValidateSelectValues(config.headerFields, currentValues, form)) return
                void form.handleSubmit((values) => mutation.mutate(values))()
              }}
            >
              {mutation.isPending ? 'Saving…' : request ? 'Save changes' : 'Create draft'}
            </Button>
          </div>
        </form>
      </PortalFormCard>
    </PageWrapper>
  )
}

function AddLineForm({
  line,
  requestId,
  request,
  initialLine,
  onChanged,
  onCancel,
}: {
  line: MultiStepLineConfig
  requestId: string
  request?: PortalRequest
  initialLine?: Record<string, unknown>
  onChanged: () => void
  onCancel?: () => void
}) {
  const lineFields = line.useLineFieldsFromRequest
    ? line.useLineFieldsFromRequest(request)
    : request && line.fieldsFromRequest
      ? line.fieldsFromRequest(request)
      : line.fields
  const initialValues = initialLine
    ? Object.fromEntries(
        lineFields.map((field) => [
          field.name,
          initialFieldValue(initialLine, field, line.defaultValues[field.name]),
        ]),
      )
    : {
        ...line.defaultValues,
        ...(request && line.defaultValuesFromRequest
          ? line.defaultValuesFromRequest(request)
          : {}),
      }
  const form = useForm<FieldValues>({
    resolver: zodResolver(line.schema) as Resolver<FieldValues>,
    defaultValues: initialValues,
    mode: 'onSubmit',
    reValidateMode: 'onSubmit',
  })
  const watchedValues = useWatch({ control: form.control }) as FieldValues
  const render = fieldRenderer(form, '', watchedValues)
  const toast = useToast()
  const onValuesChange = line.onValuesChange
  const parentFieldValuesRef = useRef<Record<string, string>>({})
  useEffect(() => {
    for (const field of lineFields) {
      if (!field.optionsByField) continue
      const parentField = field.optionsByField.field
      const parentValue = String(pathValue(watchedValues, parentField) ?? '')
      const previous = parentFieldValuesRef.current[parentField]
      if (previous !== undefined && previous !== parentValue) {
        form.setValue(field.name, '', { shouldValidate: false })
        if (field.name === 'itemNo') {
          form.setValue('description', '', { shouldValidate: false })
        }
      }
      parentFieldValuesRef.current[parentField] = parentValue
    }
  }, [watchedValues, lineFields, form])
  useEffect(() => {
    if (!onValuesChange) return
    void onValuesChange(watchedValues, form, requestId)
  }, [watchedValues, form, onValuesChange, requestId])
  const mutation = useMutation({
    mutationFn: async (values: FieldValues) => {
      const payload = line.buildLinePayload ? line.buildLinePayload(values) : values
      if (!initialLine) {
        return addRequestLine(requestId, { ...payload, action: 'create', lineNo: 0 })
      }
      const lineId = String(initialLine.lineNo ?? initialLine.id ?? '')
      try {
        return await updateRequestLine(requestId, lineId, {
          ...payload,
          action: 'edit',
          lineNo: Number(initialLine.lineNo ?? initialLine.id ?? 0),
        })
      } catch (error: unknown) {
        const message = error instanceof Error ? error.message : String(error)
        // Stale edit form after Delete — recreate the line instead of failing.
        if (/no longer editable|does not exist|was not found/i.test(message)) {
          return addRequestLine(requestId, { ...payload, action: 'create', lineNo: 0 })
        }
        throw error
      }
    },
    onSuccess: () => {
      toast.success(initialLine ? 'Line saved' : 'Line added')
      form.reset(line.defaultValues)
      onCancel?.()
      onChanged()
    },
    onError: (error) =>
      toast.error(error instanceof Error ? error.message : 'Could not add line', 'Line failed'),
  })
  return (
    <div className="rounded-md border border-slate-200 bg-slate-50 p-3">
      <p className="mb-3 text-sm font-semibold text-[var(--portal-navy)]">
        {initialLine ? 'Edit line' : line.addLabel ?? 'Add line'}
      </p>
      <div className="grid gap-3 md:grid-cols-2 xl:grid-cols-3">{lineFields.map((field) => render(field))}</div>
      {mutation.error ? (
        <p className="mt-2 text-xs font-medium text-red-600">
          {mutation.error instanceof Error ? mutation.error.message : 'Could not add line'}
        </p>
      ) : null}
      <div className="mt-3">
        <div className="flex flex-wrap gap-2">
          <Button
            type="button"
            size="sm"
            disabled={mutation.isPending}
            onClick={() => {
              const currentValues = form.getValues()
              if (!normalizeAndValidateSelectValues(lineFields, currentValues, form)) return
              void form.handleSubmit((values) => mutation.mutate(values))()
            }}
          >
            {mutation.isPending ? 'Submitting…' : initialLine ? 'Save' : 'Submit'}
          </Button>
          {onCancel ? (
            <Button type="button" size="sm" variant="outline" disabled={mutation.isPending} onClick={onCancel}>
              Cancel
            </Button>
          ) : null}
        </div>
      </div>
    </div>
  )
}

function EditableLines({
  line,
  request,
  onChanged,
}: {
  line: MultiStepLineConfig
  request: PortalRequest
  onChanged: () => void
}) {
  const editableFields = line.editableFieldsFromRequest?.(request) ?? line.editableFields ?? []
  const initial = useMemo(
    () => (Array.isArray(request.payload?.lines) ? (request.payload.lines as Record<string, unknown>[]) : []),
    [request.payload],
  )
  const [rows, setRows] = useState<Record<string, unknown>[]>(initial)
  useEffect(() => setRows(initial), [initial])
  const filteredIndices = useMemo(() => {
    const filter = line.linesFilter
    if (!filter) return rows.map((_, index) => index)
    return rows.map((row, index) => (filter(row) ? index : -1)).filter((index) => index >= 0)
  }, [rows, line.linesFilter])
  const displayRows = filteredIndices.map((index) => rows[index])
  const toast = useToast()
  const mutation = useMutation({
    mutationFn: (next: Record<string, unknown>[]) => setRequestLines(request.id, next),
    onSuccess: () => {
      toast.success('Lines updated successfully')
      onChanged()
    },
    onError: (error) =>
      toast.error(error instanceof Error ? error.message : 'Could not update lines', 'Update failed'),
  })
  const editableNames = editableFields.map((field) => field.name)
  const columns = line.columns.filter((column) => column.visibleWhen?.(rows) ?? true)
  const setCell = (displayIndex: number, key: string, value: unknown) => {
    const fullIndex = filteredIndices[displayIndex]
    if (fullIndex === undefined) return
    setRows((current) =>
      current.map((row, i) => {
        if (i !== fullIndex) return row
        const next = { ...row, [key]: value }
        if (key === 'actualSpent' || key === 'cashReceiptAmount' || key === 'cashReceiptNo') {
          const amount = Number(next.amount ?? 0)
          const spent = Number(next.actualSpent ?? 0)
          const receipt = Number(next.cashReceiptAmount ?? 0)
          next.outstandingAmount = Math.max(0, amount - spent - receipt)
        }
        return next
      }),
    )
  }
  const lineHint = line.lineHintFromRequest?.(request) ?? line.lineHint

  return (
    <div className="space-y-3 overflow-x-auto">
      {lineHint ? (
        <div className="rounded-md border border-amber-200 bg-amber-50 p-3 text-sm text-amber-950">
          {lineHint}
        </div>
      ) : null}
      <table className="w-full text-left text-sm">
        <thead className="border-b border-slate-200 text-xs text-slate-500">
          <tr>{columns.map((column) => <th key={column.key} className="px-2 py-2">{column.header}</th>)}</tr>
        </thead>
        <tbody>
          {displayRows.map((row, displayIndex) => (
            <tr
              key={String(row.id ?? row.lineNo ?? displayIndex)}
              className="border-b border-slate-100 bg-emerald-50/40"
            >
              {columns.map((column) => {
                const editable = editableFields.find((field) => field.name === column.key)
                if (editable) {
                  const disabled = editable.disabledWhen?.(row) ?? false
                  if (disabled) {
                    return (
                      <td key={column.key} className="px-2 py-2 text-xs text-slate-500">
                        Set Actual Return Date first
                      </td>
                    )
                  }
                  return (
                    <td key={column.key} className="relative min-w-[11rem] px-2 py-2 align-top">
                      {editable.type === 'select' ? (
                        <Select
                          className="min-w-[10rem]"
                          options={editable.options ?? []}
                          placeholder={editable.placeholder ?? 'Select'}
                          value={String(row[column.key] ?? '')}
                          onChange={(event) => setCell(displayIndex, column.key, event.target.value)}
                        />
                      ) : (
                        <Input
                          type={editable.type === 'number' ? 'number' : 'text'}
                          placeholder={editable.placeholder}
                          value={String(row[column.key] ?? '')}
                          onChange={(event) => setCell(displayIndex, column.key, event.target.value)}
                        />
                      )}
                    </td>
                  )
                }
                return (
                  <td key={column.key} className="px-2 py-2">
                    {column.format ? column.format(row[column.key], row) : String(row[column.key] ?? '')}
                  </td>
                )
              })}
            </tr>
          ))}
          {displayRows.length === 0 ? (
            <tr>
              <td colSpan={columns.length} className="px-2 py-4 text-center text-slate-500">
                {line.emptyText ?? 'No lines.'}
              </td>
            </tr>
          ) : null}
        </tbody>
      </table>
      {editableNames.length && displayRows.length ? (
        <Button type="button" size="sm" disabled={mutation.isPending} onClick={() => mutation.mutate(rows)}>
          Save
        </Button>
      ) : null}
    </div>
  )
}

export function MultiStepRequestPage(config: MultiStepRequestConfig) {
  const queryClient = useQueryClient()
  const toast = useToast()
  const confirm = useConfirm()
  const [mode, setMode] = useState<'list' | 'create'>(config.initialMode ?? 'list')
  const [selectedId, setSelectedId] = useState<string | null>(null)
  const [actionId, setActionId] = useState<string | null>(null)
  const [editingHeader, setEditingHeader] = useState(false)
  const [editingLine, setEditingLine] = useState<Record<string, unknown> | null>(null)
  const [showLineForm, setShowLineForm] = useState(false)
  const [receiveLine, setReceiveLine] = useState<Record<string, unknown> | null>(null)
  const [receiveQuantity, setReceiveQuantity] = useState('')
  const [receiveReason, setReceiveReason] = useState('')

  const [listSearch, setListSearch] = useState('')
  const [listStatus, setListStatus] = useState('all')
  const requestsQuery = useQuery({ queryKey: config.queryKey, queryFn: config.listRequests })

  const filteredRequests = useMemo(() => {
    const rows = requestsQuery.data ?? []
    const statusFiltered =
      !config.listStatusFilter || listStatus === 'all'
        ? rows
        : rows.filter((row) => {
            const status = String(row.status ?? '').toLowerCase()
            if (listStatus === 'pending') return status.includes('pending')
            if (listStatus === 'approved') return status === 'approved' || status === 'posted'
            if (listStatus === 'rejected') return status === 'rejected'
            if (listStatus === 'draft') return status === 'draft' || status === 'open'
            return true
          })
    const term = listSearch.trim().toLowerCase()
    if (!term) return statusFiltered
    return statusFiltered.filter((row) => {
      const payload = row.payload ?? {}
      const extras = config.listSearchExtra?.(row) ?? []
      const haystack = [
        row.requestNo,
        row.title,
        row.status,
        row.createdAt,
        row.makerName,
        row.departmentName,
        row.departmentCode,
        row.responsibleCenter,
        String(row.amount ?? ''),
        ...extras,
        ...Object.values(payload).slice(0, 24),
      ]
      return haystack
        .filter((field) => field !== undefined && field !== null && String(field).trim() !== '')
        .some((field) => String(field).toLowerCase().includes(term))
    })
  }, [config.listSearchExtra, config.listStatusFilter, listSearch, listStatus, requestsQuery.data])

  const detailQuery = useQuery({
    queryKey: [...config.queryKey, 'detail', selectedId],
    queryFn: () => getModuleRequest(config.module, selectedId!),
    enabled: Boolean(selectedId),
  })

  const refresh = async () => {
    await queryClient.invalidateQueries({ queryKey: config.queryKey })
    if (['storeRequisition', 'transferOrder'].includes(config.module.module)) {
      await queryClient.invalidateQueries({ queryKey: ['facility', 'gate-pass'] })
    }
    await queryClient.invalidateQueries({ queryKey: ['dashboard'] })
    await queryClient.invalidateQueries({ queryKey: ['approvals'] })
    if (selectedId) await detailQuery.refetch()
  }

  const headerCreated = (request: PortalRequest) => {
    void queryClient.invalidateQueries({ queryKey: config.queryKey })
    if (['storeRequisition', 'transferOrder'].includes(config.module.module)) {
      void queryClient.invalidateQueries({ queryKey: ['facility', 'gate-pass'] })
    }
    setMode('list')
    setSelectedId(request.id)
  }

  const runAction = async (
    id: string,
    action: () => Promise<unknown>,
    errorLabel: string,
    successMessage?: string,
  ) => {
    setActionId(id)
    try {
      await action()
      await refresh()
      if (successMessage) toast.success(successMessage)
    } catch (err: unknown) {
      toast.error(err instanceof Error ? err.message : errorLabel, 'Action failed')
    } finally {
      setActionId(null)
    }
  }

  const selected = detailQuery.data
  const editable = selected
    ? isEditableRequestStatus(selected.status, config.module.module)
    : false
  const submittable = selected
    ? editable && canRequestApproval(config.module.module, selected.payload as Record<string, unknown> | undefined)
    : false
  // UAT 18/07/2026: users must be able to cancel a wrong document BEFORE approval as well,
  // not only once it is pending. BC exposes CancelImprestSurrender / CancelPettyCashRequest /
  // CancelImprestRequisition / CancelClaimRequisition for exactly this.
  const cancelStatuses: PortalRequest['status'][] = config.cancelStatuses ?? ['Draft', 'Pending Approval']
  const supportsAttachments =
    config.supportsAttachments ?? PORTAL_ATTACHMENT_MODULES.has(config.module.module)
  // ERP parity: show receipt confirmation only after approval AND store issue.
  const storeApprovalDone = storeRequisitionApprovalComplete(selected)
  const selectedLines = Array.isArray(selected?.payload?.lines)
    ? (selected!.payload!.lines as Record<string, unknown>[])
    : []
  useEffect(() => {
    if (!editingLine) return
    const editingId = String(editingLine.lineNo ?? editingLine.id ?? '')
    if (!editingId) return
    const stillThere = selectedLines.some(
      (row) => String(row.lineNo ?? row.id ?? '') === editingId,
    )
    if (!stillThere) {
      // Line was deleted (or list refreshed empty) — close stale edit form.
      setEditingLine(null)
      setShowLineForm(false)
    }
  }, [editingLine, selectedLines])
  const storeHasIssued = storeRequisitionHasIssuedLines(selectedLines)
  const canReceiveStoreLines =
    config.module.module === 'storeRequisition' &&
    (storeApprovalDone || selected?.status === 'Posted') &&
    storeHasIssued

  const beginReceiveLine = (line: Record<string, unknown>) => {
    setReceiveLine(line)
    const received = Number(line.quantityReceived ?? 0)
    const issued = Number(line.quantityIssued ?? 0)
    const outstanding = Math.max(0, issued - received)
    setReceiveQuantity(
      String(
        outstanding > 0
          ? outstanding
          : line.quantityToReceive ?? issued,
      ),
    )
    setReceiveReason(String(line.reason ?? ''))
  }

  const submitReceiveLine = async () => {
    if (!selected || !receiveLine) return
    const lineId = String(receiveLine.id ?? receiveLine.lineNo ?? '')
    const quantityToReceive = Number(receiveQuantity)
    if (!lineId || !Number.isFinite(quantityToReceive) || quantityToReceive < 0) {
      toast.error('Enter a valid quantity to receive.', 'Receive failed')
      return
    }
    const issued = Number(receiveLine.quantityIssued ?? 0)
    if (issued <= 0) {
      toast.error('Store has not issued this line yet. Wait for store issue in Business Central.', 'Receive failed')
      return
    }
    await runAction(
      `receive-${lineId}`,
      async () => {
        await receiveStoreRequestLine(selected.id, lineId, {
          quantityToReceive,
          reason: receiveReason,
        })
        // BC stages Qty to receive on ReceiveStoreLineItems; post commits Quantity Received.
        return postStoreRequestReceipt(selected.id)
      },
      'Receive failed',
      'Store line received and posted',
    )
    setReceiveLine(null)
    setReceiveQuantity('')
    setReceiveReason('')
  }

  const postStoreReceipt = async () => {
    if (!selected) return
    const yes = await confirm({
      title: 'Receive items',
      message: 'Are you sure you would like to receive items?',
      confirmLabel: 'Yes',
    })
    if (!yes) return
    await runAction(
      `post-${selected.id}`,
      () => postStoreRequestReceipt(selected.id),
      'Post failed',
      'Store requisition posted to receive',
    )
  }

  // Detail view
  if (selectedId) {
    const payload = selected?.payload ?? {}
    const lines = Array.isArray(payload.lines) ? (payload.lines as Record<string, unknown>[]) : []
    const lineColumns =
      config.line?.columns.filter((column) => column.visibleWhen?.(lines) ?? true) ?? []
    const detailSource = { request: selected, payload }
    const detailFields = (config.detailFields ?? [])
      .map((field) => ({
        field,
        value:
          field.resolve && selected
            ? field.resolve(selected)
            : firstPathValue(detailSource, field.paths, field.format),
      }))
      .filter(({ value }) => value !== undefined)
    const headerFields = config.headerFields
      .map((field) => ({
        field,
        value: initialFieldValue(payload, field, undefined),
      }))
      .filter(({ value }) => value !== null && value !== undefined && value !== '')

    if (selected && editingHeader) {
      return (
        <HeaderForm
          config={config}
          request={selected}
          onCreated={() => {
            setEditingHeader(false)
            void refresh()
          }}
          onCancel={() => setEditingHeader(false)}
        />
      )
    }

    return (
      <PageWrapper title={`${config.title} Details`} showPageHeading={false}>
        <PortalFormCard title={`${config.title} Details`}>
          <div
            className={cn(
              'space-y-6',
              config.detailActionsPlacement === 'bottom' && 'flex flex-col gap-6 space-y-0',
            )}
          >
            {config.processBanner}
            <div
              className={cn(
                'flex flex-wrap items-center justify-between gap-3 border-b border-slate-200 pb-4',
                config.detailActionsPlacement === 'bottom' && 'contents',
              )}
            >
              <Button
                type="button"
                variant="outline"
                className={cn(config.detailActionsPlacement === 'bottom' && 'self-start')}
                onClick={() => { setSelectedId(null); setEditingLine(null); setShowLineForm(false); setEditingHeader(false); setMode('list') }}
              >
                <ArrowLeft className="h-4 w-4" />
                Back
              </Button>
              {selected ? (
                <div
                  className={cn(
                    'flex flex-wrap gap-2',
                    config.detailActionsPlacement === 'bottom' &&
                      'order-last justify-end border-t border-slate-200 pt-4',
                  )}
                >
                  {editable ? (
                    <Button
                      type="button"
                      variant="outline"
                      onClick={() => setEditingHeader(true)}
                    >
                      <Pencil className="h-4 w-4" />
                      Edit
                    </Button>
                  ) : null}
                  {submittable ? (
                    <Button
                      type="button"
                      variant="gradient"
                      disabled={actionId === selected.id}
                      onClick={() => {
                        if (config.line && config.line.required !== false && lines.length === 0) {
                          toast.warning(
                            config.line.requiredMessage ||
                              `Add at least one ${config.line.label.toLowerCase()} entry before requesting approval.`,
                            'Lines required',
                          )
                          return
                        }
                        if (config.requiresAttachmentBeforeSubmit && selected.attachments.length === 0) {
                          toast.warning(
                            config.requiredAttachmentMessage ||
                              'Attach at least one supporting document before requesting approval.',
                            'Attachment required',
                          )
                          return
                        }
                        const submitValidation = config.validateBeforeSubmit?.(selected)
                        if (submitValidation) {
                          toast.warning(submitValidation, 'Cannot request approval')
                          return
                        }
                        void confirm({
                          title: 'Request approval',
                          message: 'Send this request into the approval workflow?',
                          confirmLabel: 'Request Approval',
                        }).then((yes) => {
                          if (yes)
                            void runAction(
                              selected.id,
                              () => submitModuleRequest(config.module, selected.id),
                              'Submission failed',
                              'Request sent for approval',
                            )
                        })
                      }}
                    >
                      <Send className="h-4 w-4" />
                      Request Approval
                    </Button>
                  ) : null}
                  {cancelStatuses.includes(selected.status) ? (
                    <Button
                      type="button"
                      variant="outline"
                      disabled={actionId === selected.id}
                      onClick={() =>
                        void confirm({
                          title: 'Cancel request',
                          message: 'Are you sure you want to cancel this request?',
                          confirmLabel: 'Cancel Request',
                          cancelLabel: 'Keep',
                          tone: 'danger',
                        }).then((yes) => {
                          if (yes)
                            void runAction(
                              selected.id,
                              () => cancelModuleRequest(config.module, selected.id),
                              'Cancel failed',
                              'Request cancelled',
                            )
                        })
                      }
                    >
                      Cancel
                    </Button>
                  ) : null}
                  {canDeleteDocumentDraft(selected.status, config.module.module) ? (
                    <Button
                      type="button"
                      variant="destructive"
                      disabled={actionId === `delete:${selected.id}`}
                      onClick={() =>
                        void confirm({
                          title: 'Permanently delete draft',
                          message: `Delete draft ${selected.requestNo}? This cannot be undone.`,
                          confirmLabel: 'Delete draft',
                          cancelLabel: 'Keep',
                          tone: 'danger',
                        }).then((yes) => {
                          if (!yes) return
                          void runAction(
                            `delete:${selected.id}`,
                            async () => {
                              await deleteModuleRequest(config.module, selected.id)
                              setSelectedId(null)
                              setMode('list')
                            },
                            'Delete failed',
                            'Draft permanently deleted',
                          )
                        })
                      }
                    >
                      <Trash2 className="h-4 w-4" />
                      Delete Draft
                    </Button>
                  ) : null}
                  {canReceiveStoreLines ? (
                    <Button
                      type="button"
                      variant="outline"
                      disabled={actionId === `post-${selected.id}`}
                      onClick={() => void postStoreReceipt()}
                    >
                      Post to receive
                    </Button>
                  ) : null}
                  {(config.extraDetailActions ?? [])
                    .filter((action) => !action.visibleWhen || action.visibleWhen(selected))
                    .map((action) => (
                      <Button
                        key={action.id}
                        type="button"
                        variant="outline"
                        disabled={actionId === `${action.id}-${selected.id}`}
                        onClick={() => {
                          const execute = () =>
                            void runAction(
                              `${action.id}-${selected.id}`,
                              () => action.run(selected.id),
                              `${action.label} failed`,
                              action.successMessage ?? `${action.label} completed`,
                            )
                          if (action.confirm) {
                            void confirm({
                              title: action.confirm.title,
                              message: action.confirm.message,
                              confirmLabel: action.confirm.confirmLabel ?? action.label,
                            }).then((yes) => {
                              if (yes) execute()
                            })
                          } else {
                            execute()
                          }
                        }}
                      >
                        {action.label}
                      </Button>
                    ))}
                </div>
              ) : null}
            </div>

            {detailQuery.isLoading ? <Skeleton className="h-56 w-full" /> : null}
            {detailQuery.isError ? (
              <div className="rounded-lg border border-red-200 bg-red-50 p-4 text-sm text-red-700">
                {detailQuery.error instanceof Error ? detailQuery.error.message : 'Could not load this request.'}
              </div>
            ) : null}

            {selected ? (
              <>
                {(() => {
                  const rejectionNote =
                    String(
                      payload.RejectionReason ??
                        payload.rejectionReason ??
                        selected.approvalSteps?.find((step) =>
                          /reject|declin/i.test(String(step.status ?? '')),
                        )?.note ??
                        '',
                    ).trim()
                  if (selected.status !== 'Rejected' && !rejectionNote) return null
                  if (!rejectionNote && selected.status !== 'Rejected') return null
                  return (
                    <div className="rounded-lg border border-red-200 bg-red-50 p-4 text-sm text-red-900">
                      <p className="font-semibold">Rejection reason</p>
                      <p className="mt-1 whitespace-pre-wrap">
                        {rejectionNote || 'This request was rejected. No rejection comment was recorded in Business Central.'}
                      </p>
                    </div>
                  )
                })()}
                <RequestProgress
                  status={selected.status}
                  hasLines={lines.length > 0}
                  requiresLines={Boolean(config.line && config.line.required !== false)}
                  module={config.module.module}
                  lines={lines}
                  payload={payload}
                  approvalSteps={selected.approvalSteps}
                />
                {config.detailSupplement ? config.detailSupplement({ request: selected }) : null}
                <section>
                  <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
                    {detailFields.length ? detailFields.map(({ field, value }) => (
                      <div key={field.label}>
                        <p className="text-xs text-slate-500">{field.label}</p>
                        <div className="font-semibold">{detailValue(value, field.format)}</div>
                      </div>
                    )) : (
                      <>
                        <div><p className="text-xs text-slate-500">Request No.</p><p className="font-semibold">{selected.requestNo}</p></div>
                        <div><p className="text-xs text-slate-500">Status</p><StatusBadge status={selected.status} /></div>
                        <div><p className="text-xs text-slate-500">Created</p><p className="font-semibold">{formatDate(selected.createdAt)}</p></div>
                      </>
                    )}
                  </div>
                </section>

                {!detailFields.length && headerFields.length ? (
                  <section className="border-t border-slate-200 pt-4">
                    <h3 className="mb-3 text-sm font-semibold text-[var(--portal-navy)]">Request Information</h3>
                    <dl className="grid gap-3 sm:grid-cols-2 lg:grid-cols-3">
                      {headerFields.map(({ field, value }) => (
                        <div key={field.name}>
                          <dt className="text-xs text-slate-500">{field.label}</dt>
                          <dd className="break-words text-sm font-medium">
                            {field.type === 'date' ? formatDate(String(value)) : String(value)}
                          </dd>
                        </div>
                      ))}
                    </dl>
                  </section>
                ) : null}

                {/* Lines before attachments so settlement/line totals are visible without scrolling past empty attachments */}
                {config.line ? (
                  <section className="border-t border-slate-200 pt-4">
                    <h3 className="mb-3 text-sm font-semibold text-[var(--portal-navy)]">{config.line.label}</h3>
                    {editable && config.line.canAdd !== false ? (
                      <div className="mb-4">
                        {showLineForm || editingLine ? (
                          <AddLineForm
                            key={editingLine ? `edit-${String(editingLine.lineNo ?? editingLine.id)}` : 'add-line'}
                            line={config.line}
                            requestId={selected.id}
                            request={selected}
                            initialLine={editingLine ?? undefined}
                            onCancel={() => {
                              setEditingLine(null)
                              setShowLineForm(false)
                            }}
                            onChanged={() => {
                              setEditingLine(null)
                              setShowLineForm(false)
                              void refresh()
                            }}
                          />
                        ) : (
                          <Button type="button" size="sm" variant="outline" onClick={() => setShowLineForm(true)}>
                            <Plus className="h-4 w-4" />
                            {config.line.addLabel ?? 'Add line'}
                          </Button>
                        )}
                      </div>
                    ) : null}
                    {canReceiveStoreLines ? (
                      <div className="mb-4 rounded-md border border-blue-200 bg-blue-50 p-3 text-sm text-blue-900">
                        <p className="font-semibold">Receipt confirmation</p>
                        <p className="mt-1 text-blue-800">
                          Store has issued items. Click <strong>Receive Items</strong> on each line to confirm
                          quantity (partial receipts need a reason), or use <strong>Post to receive</strong> to
                          confirm all outstanding issued quantities at once.
                        </p>
                      </div>
                    ) : null}
                    {canReceiveStoreLines && receiveLine ? (
                      <div className="mb-4 rounded-md border border-slate-200 bg-slate-50 p-3">
                        <div className="mb-3 text-sm font-semibold text-[var(--portal-navy)]">
                          Receive line {String(receiveLine.lineNo ?? receiveLine.id ?? '')}
                        </div>
                        <div className="grid gap-3 md:grid-cols-2">
                          <div className="space-y-1.5">
                            <Label htmlFor="receive-quantity">Quantity To Receive</Label>
                            <Input
                              id="receive-quantity"
                              type="number"
                              min="0"
                              value={receiveQuantity}
                              onChange={(event) => setReceiveQuantity(event.target.value)}
                            />
                          </div>
                          <div className="space-y-1.5">
                            <Label htmlFor="receive-reason">Reason</Label>
                            <Input
                              id="receive-reason"
                              value={receiveReason}
                              onChange={(event) => setReceiveReason(event.target.value)}
                              placeholder="Optional reason"
                            />
                          </div>
                        </div>
                        <div className="mt-3 flex flex-wrap gap-2">
                          <Button
                            type="button"
                            size="sm"
                            disabled={actionId === `receive-${String(receiveLine.id ?? receiveLine.lineNo ?? '')}`}
                            onClick={() => void submitReceiveLine()}
                          >
                            Submit
                          </Button>
                          <Button type="button" size="sm" variant="outline" onClick={() => setReceiveLine(null)}>
                            Cancel
                          </Button>
                        </div>
                      </div>
                    ) : null}
                    {config.customLineSection ? (
                      config.customLineSection({ request: selected, onChanged: () => void refresh() })
                    ) : config.line.editableFields?.length || config.line.editableFieldsFromRequest ? (
                      <EditableLines line={config.line} request={selected} onChanged={() => void refresh()} />
                    ) : (
                      <div className="overflow-x-auto">
                        <table className="w-full text-left text-sm">
                          <thead className="border-b border-slate-200 text-xs text-slate-500">
                            <tr>
                              {lineColumns.map((column) => <th key={column.key} className="px-2 py-2">{column.header}</th>)}
                              {editable || canReceiveStoreLines ? <th className="px-2 py-2">Action</th> : null}
                            </tr>
                          </thead>
                          <tbody>
                            {lines.map((row, index) => (
                              <tr key={String(row.id ?? row.lineNo ?? index)} className="border-b border-slate-100">
                                {lineColumns.map((column) => (
                                  <td key={column.key} className="px-2 py-2">
                                    {column.format ? column.format(row[column.key], row) : String(row[column.key] ?? '')}
                                  </td>
                                ))}
                                {editable ? (
                                  <td className="px-2 py-2">
                                    <div className="flex flex-wrap gap-1">
                                      {config.line!.canEdit !== false ? (
                                        <Button type="button" variant="ghost" size="sm" onClick={() => { setEditingLine(row); setShowLineForm(true) }}>
                                          <Pencil className="h-4 w-4" />
                                          Edit
                                        </Button>
                                      ) : null}
                                      <Button type="button" variant="ghost" size="sm" className="text-red-600" disabled={actionId === String(row.id)} onClick={() => void runAction(String(row.id), async () => {
                                        await deleteRequestLine(selected.id, String(row.id ?? row.lineNo))
                                        setEditingLine(null)
                                        setShowLineForm(false)
                                      }, 'Delete failed', 'Line deleted')}>
                                        <Trash2 className="h-4 w-4" />
                                        Delete
                                      </Button>
                                    </div>
                                  </td>
                                ) : canReceiveStoreLines ? (
                                  <td className="px-2 py-2">
                                    {storeLineNeedsReceipt(row) ? (
                                      <Button
                                        type="button"
                                        variant="outline"
                                        size="sm"
                                        disabled={actionId === `receive-${String(row.id ?? row.lineNo ?? '')}`}
                                        onClick={() => beginReceiveLine(row)}
                                      >
                                        Receive Items
                                      </Button>
                                    ) : (
                                      <span className="text-xs text-emerald-700">Received</span>
                                    )}
                                  </td>
                                ) : null}
                              </tr>
                            ))}
                            {lines.length === 0 ? (
                              <tr>
                                <td colSpan={lineColumns.length + (editable || canReceiveStoreLines ? 1 : 0)} className="px-2 py-4 text-center text-slate-500">
                                  {config.line.emptyText ?? '*** No lines found ***'}
                                </td>
                              </tr>
                            ) : null}
                          </tbody>
                        </table>
                      </div>
                    )}
                  </section>
                ) : null}

                {supportsAttachments && selected ? (
                  <RequestAttachments
                    requestId={selected.id}
                    attachments={selected.attachments}
                    canUpload={canUploadRequestAttachments(selected.status, config.module.module)}
                    canDelete={canDeleteRequestItems(selected.status, config.module.module)}
                    categoryOptions={config.attachmentCategoryOptions}
                    categoryHint={config.attachmentCategoryHint}
                    onUpdated={() => {
                      void refresh()
                    }}
                  />
                ) : null}

                {shouldShowApprovalHistory(selected.status) ? (
                  <section className="border-t border-slate-200 pt-4">
                    <h3 className="mb-3 text-sm font-semibold text-[var(--portal-navy)]">Approval History</h3>
                    <ApprovalHistory steps={selected.approvalSteps} />
                  </section>
                ) : null}
              </>
            ) : null}
          </div>
        </PortalFormCard>
      </PageWrapper>
    )
  }

  if (mode === 'create') {
    return <HeaderForm config={config} onCreated={headerCreated} onCancel={() => setMode('list')} />
  }

  const columns: DataTableColumn<PortalRequest>[] = [
    { id: 'requestNo', header: 'No.', cell: (row) => row.requestNo },
    { id: 'date', header: 'Date', cell: (row) => formatDate(row.createdAt) },
    { id: 'status', header: 'Status', cell: (row) => <StatusBadge status={row.status} /> },
    { id: 'title', header: 'Description', cell: (row) => row.title },
    ...(config.listValueColumn === false
      ? []
      : [
          config.listValueColumn ?? {
            id: 'amount',
            header: 'Amount',
            cell: (row) => formatCurrency(row.amount),
          },
        ]),
    {
      id: 'actions',
      header: 'Actions',
      cell: (row) => (
        <div className="flex flex-wrap gap-1">
          <Button type="button" variant="ghost" size="sm" onClick={() => setSelectedId(row.id)}>
            View
          </Button>
          {cancelStatuses.includes(row.status) ? (
            <Button
              type="button"
              variant="ghost"
              size="sm"
              className="text-amber-700"
              disabled={actionId === row.id}
              onClick={() =>
                void confirm({
                  title: 'Cancel request',
                  message: 'Are you sure you want to cancel this request?',
                  confirmLabel: 'Cancel Request',
                  cancelLabel: 'Keep',
                  tone: 'danger',
                }).then((yes) => {
                  if (yes) {
                    void runAction(
                      row.id,
                      () => cancelModuleRequest(config.module, row.id),
                      'Cancel failed',
                      'Request cancelled',
                    )
                  }
                })
              }
            >
              Cancel
            </Button>
          ) : null}
          {canDeleteDocumentDraft(row.status, config.module.module) ? (
            <Button
              type="button"
              variant="ghost"
              size="sm"
              className="text-red-700 hover:bg-red-50 hover:text-red-800"
              disabled={actionId === `delete:${row.id}`}
              onClick={(event) => {
                event.stopPropagation()
                void confirm({
                  title: 'Permanently delete draft',
                  message: `Delete draft ${row.requestNo}? This cannot be undone.`,
                  confirmLabel: 'Delete draft',
                  cancelLabel: 'Keep',
                  tone: 'danger',
                }).then((yes) => {
                  if (!yes) return
                  void runAction(
                    `delete:${row.id}`,
                    () => deleteModuleRequest(config.module, row.id),
                    'Delete failed',
                    'Draft permanently deleted',
                  )
                })
              }}
            >
              <Trash2 className="h-4 w-4" />
              Delete
            </Button>
          ) : null}
        </div>
      ),
    },
  ]

  return (
    <PageWrapper title={config.title} actions={<PortalNewButton label={config.newButtonLabel ?? 'New Request'} onClick={() => setMode('create')} />}>
      {config.processBanner && config.showProcessBannerOnList !== false ? (
        <div className="mb-4">{config.processBanner}</div>
      ) : null}
      {requestsQuery.isLoading ? (
        <Skeleton className="h-48 w-full" />
      ) : requestsQuery.isError ? (
        <div className="rounded border-l-4 border-red-500 bg-red-50 p-4 text-sm text-red-700">
          Could not load requests. Check the selected backend and apply pending database migrations.
        </div>
      ) : (
        <>
          <div className="mb-3 space-y-2">
            <Input
              type="search"
              value={listSearch}
              onChange={(event) => setListSearch(event.target.value)}
              placeholder="Search by request no., description, status or date…"
              className="max-w-md"
            />
            {config.listStatusFilter ? (
              <div className="flex flex-wrap gap-1.5">
                {[
                  { value: 'all', label: 'All' },
                  { value: 'pending', label: 'Pending Approval' },
                  { value: 'approved', label: 'Approved' },
                  { value: 'rejected', label: 'Rejected' },
                  { value: 'draft', label: 'Draft' },
                ].map((chip) => (
                  <button
                    key={chip.value}
                    type="button"
                    onClick={() => setListStatus(chip.value)}
                    className={cn(
                      'rounded-full px-3 py-1 text-xs font-medium transition-colors',
                      listStatus === chip.value
                        ? 'bg-[var(--portal-navy)] text-white'
                        : 'bg-slate-100 text-slate-600 hover:bg-slate-200',
                    )}
                  >
                    {chip.label}
                  </button>
                ))}
              </div>
            ) : null}
            {listSearch.trim() || (config.listStatusFilter && listStatus !== 'all') ? (
              <p className="text-xs text-slate-500">
                {filteredRequests.length} of {requestsQuery.data?.length ?? 0} shown
              </p>
            ) : null}
          </div>
          <DataTable
            rows={filteredRequests}
            columns={columns}
            getRowId={(row) => row.id}
            onRowClick={(row) => setSelectedId(row.id)}
            compact
          />
        </>
      )}
    </PageWrapper>
  )
}
