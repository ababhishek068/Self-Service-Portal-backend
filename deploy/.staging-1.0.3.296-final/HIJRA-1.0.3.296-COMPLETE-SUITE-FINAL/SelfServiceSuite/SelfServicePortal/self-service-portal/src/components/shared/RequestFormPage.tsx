import { zodResolver } from '@hookform/resolvers/zod'
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { AlertCircle, ArrowLeft, Eye, Pencil, Plus, Save, Send, Trash2 } from 'lucide-react'
import { useEffect, useMemo, useState, type ReactElement, type ReactNode } from 'react'
import {
  Controller,
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
import { Select, type SelectOption } from '@/components/ui/select'
import { Skeleton } from '@/components/ui/skeleton'
import { Textarea } from '@/components/ui/textarea'
import { TimePicker } from '@/components/ui/time-picker'
import { DataTable, type DataTableColumn } from './DataTable'
import { FileUpload } from './FileUpload'
import { ListSearch } from './ListSearch'
import { RequestAttachments } from './RequestAttachments'
import { StatusBadge } from './StatusBadge'
import { RequestProgress } from './RequestProgress'
import { ApprovalHistory } from './ApprovalHistory'
import {
  cancelModuleRequest,
  getModuleRequest,
  submitModuleRequest,
  updateRequestHeader,
  type EndpointConfig,
} from '@/api/endpoints/requestEndpoint'
import { formatCurrency, formatDate, isPlaceholderErpDate, toHtmlDateInputValue } from '@/utils/formatters'
import {
  canDeleteRequestItems,
  canRequestApproval,
  canUploadRequestAttachments,
  isEditableRequestStatus,
  PORTAL_ATTACHMENT_MODULES,
  shouldShowApprovalHistory,
} from '@/utils/requestStatus'
import type { Attachment, PortalRequest } from '@/types/erp.types'
import { matchesSearchQuery } from '@/utils/tableSearch'
import { shouldShowFinanceOrgDetailField, matchesRequestListStatus } from '@/utils/financeOrgDisplay'
import { cn } from '@/lib/utils'

type BasicFieldType = 'text' | 'number' | 'date' | 'time' | 'textarea' | 'select' | 'checkbox' | 'files'

export interface FieldConfig {
  name: string
  label: string
  type: BasicFieldType
  placeholder?: string
  /** Short helper text shown under the control (production UX). */
  hint?: string
  options?: SelectOption[]
  /** Resolve select options from the current form values (for linked ERP lookups). */
  optionsWhen?: (values: FieldValues) => SelectOption[]
  optionsByField?: {
    field: string
    options: Record<string, SelectOption[]>
  }
  readOnly?: boolean
  readOnlyWhen?: (values: FieldValues) => boolean
  /** Hide the field unless this returns true (ESS conditional line fields). */
  visibleWhen?: (values: FieldValues) => boolean
  /** Disable editing for this line row (e.g. zero-amount surrender lines). */
  disabledWhen?: (row: Record<string, unknown>) => boolean
  /** Business Central payload paths used to prefill the edit form. */
  valuePaths?: string[]
  /** Maps Business Central option captions back to the form's option values. */
  valueMap?: Record<string, string>
  /** Span both columns in two-column forms. */
  fullWidth?: boolean
}

export interface LineItemsConfig {
  name: string
  label: string
  type: 'lineItems'
  defaultLine: Record<string, unknown>
  fields: FieldConfig[]
}

export type RequestFieldConfig = FieldConfig | LineItemsConfig

export interface DetailFieldConfig {
  label: string
  paths: string[]
  format?: 'text' | 'date' | 'currency' | 'status' | 'percentage' | 'returned' | 'closure' | 'km'
  /** Hide the field when the resolved value is 0 / "0" (e.g. unused odometer on FA jobs). */
  hideZero?: boolean
}

interface RequestFormPageProps {
  title: string
  description?: string
  schema: Parameters<typeof zodResolver>[0]
  defaultValues: FieldValues
  fields: RequestFieldConfig[]
  queryKey: readonly unknown[]
  listRequests: () => Promise<PortalRequest[]>
  createRequest: (values: Record<string, unknown>) => Promise<unknown>
  source?: string
  listOnly?: boolean
  newButtonLabel?: string
  /** When set, list rows get Cancel / Delete actions wired to the mock/ERP backend. */
  moduleConfig?: EndpointConfig
  listContent?: ReactNode
  detailFields?: DetailFieldConfig[]
  detailLineColumns?: DetailFieldConfig[]
  detailLineLabel?: string
  hideDetailAttachments?: boolean
  listActions?: ReactNode
  listColumns?: DataTableColumn<PortalRequest>[]
  /** Replaces the default Amount column; false hides it for non-financial flows. */
  listValueColumn?: DataTableColumn<PortalRequest> | false
  emptyListText?: string
  cancelStatuses?: PortalRequest['status'][]
  /** Show Draft / Pending / Rejected / Approved chips on the request list. */
  listStatusFilter?: boolean
  refetchOnMount?: boolean | 'always'
  onValuesChange?: (values: FieldValues, form: UseFormReturn<FieldValues>) => void | Promise<void>
  /** Content rendered above the create/edit form fields (guides, tips). */
  formPreface?: ReactNode
  /** Read-only ERP summary shown below the create/edit form fields. */
  createSupplement?: (values: FieldValues) => ReactNode
  /** Module-specific workflow controls rendered on the Business Central detail view. */
  detailContent?: (request: PortalRequest, refresh: () => Promise<void>) => ReactNode
}

function firstPathValue(
  source: unknown,
  paths: string[],
  format: DetailFieldConfig['format'] = 'text',
  hideZero = false,
) {
  for (const path of paths) {
    const value = getPathValue(source, path)
    if (value === undefined || value === null || String(value).trim() === '') continue
    if (format === 'currency' && Number(value) === 0) continue
    if (format === 'date' && isPlaceholderErpDate(String(value))) continue
    if (format === 'km' && Number.isFinite(Number(value)) && Number(value) <= 0) continue
    if (hideZero && Number.isFinite(Number(value)) && Number(value) === 0) continue
    return value
  }
  return undefined
}

function lineDetailValue(
  line: Record<string, unknown>,
  column: DetailFieldConfig,
  requestAmount?: number,
  detailSource?: unknown,
) {
  const direct = firstPathValue(line, column.paths, column.format)
  if (direct !== undefined) return direct
  if (column.format === 'currency') {
    const percentage = Number(
      firstPathValue(
        line,
        ['PercentageofSalary', 'PercentageOfSalary', 'Percentage_of_Salary', 'PercentageSalary'],
        'percentage',
      ) ?? 0,
    )
    const salaryBase = Number(
      getPathValue(detailSource, 'payload.monthlySalaryBase') ??
        getPathValue(detailSource, 'payload.Basic_Salary') ??
        getPathValue(detailSource, 'payload.MonthlySalary') ??
        0,
    )
    if (percentage > 0 && salaryBase > 0) {
      return Math.round(((salaryBase * percentage) / 100) * 100) / 100
    }
  }
  if (column.format === 'currency' && requestAmount && requestAmount > 0) return requestAmount
  return undefined
}

function renderDetailValue(value: unknown, format: DetailFieldConfig['format'] = 'text') {
  if (format === 'status') return <StatusBadge status={String(value ?? '-')} />
  if (format === 'date') return formatDate(value === undefined ? undefined : String(value))
  if (format === 'currency') return formatCurrency(Number(value ?? 0))
  if (format === 'percentage') return `${Number(value ?? 0)}%`
  if (format === 'returned') {
    const returned = value === true || ['true', 'yes', '1'].includes(String(value ?? '').toLowerCase())
    return returned ? 'Returned' : 'Not Returned'
  }
  if (format === 'closure') {
    const closed = value === true || ['true', 'yes', '1', 'closed'].includes(String(value ?? '').toLowerCase())
    return closed ? 'Closed' : 'Open'
  }
  if (format === 'km') {
    const reading = Number(value)
    if (!Number.isFinite(reading) || reading <= 0) return 'Not recorded'
    return `${reading.toLocaleString()} km`
  }
  return String(value ?? '-')
}

function getPathValue(source: unknown, path: string) {
  return path.split('.').reduce<unknown>((current, part) => {
    if (!current || typeof current !== 'object') return undefined
    if (Array.isArray(current)) return current[Number(part)]
    return (current as Record<string, unknown>)[part]
  }, source)
}

function setPathValue(target: FieldValues, path: string, value: unknown) {
  const parts = path.split('.')
  let current: Record<string, unknown> | unknown[] = target
  for (let index = 0; index < parts.length - 1; index += 1) {
    const part = parts[index]!
    const nextPart = parts[index + 1]!
    const existing = Array.isArray(current)
      ? current[Number(part)]
      : current[part]
    if (!existing || typeof existing !== 'object') {
      const replacement: Record<string, unknown> | unknown[] = /^\d+$/.test(nextPart) ? [] : {}
      if (Array.isArray(current)) current[Number(part)] = replacement
      else current[part] = replacement
      current = replacement
    } else {
      current = existing as Record<string, unknown> | unknown[]
    }
  }
  const finalPart = parts[parts.length - 1]!
  if (Array.isArray(current)) current[Number(finalPart)] = value
  else current[finalPart] = value
}

function normalizedSelectValue(value: unknown) {
  return String(value ?? '').trim().replace(/\s+/g, ' ').toLowerCase()
}

/**
 * Business Central relations require the option key/code, never its caption.
 * Normalize cached captions to their current key and reject values removed
 * from the live lookup before a SOAP request can lose or reject user input.
 */
export function normalizeAndValidateSelectValues(
  fields: FieldConfig[],
  values: FieldValues,
  form: UseFormReturn<FieldValues>,
) {
  let valid = true
  for (const field of fields) {
    if (field.type !== 'select') continue
    if (field.visibleWhen && !field.visibleWhen(values)) continue
    const currentValue = getPathValue(values, field.name)
    if (normalizedSelectValue(currentValue) === '') continue
    const options = field.optionsWhen
      ? field.optionsWhen(values)
      : field.optionsByField
        ? field.optionsByField.options[
            String(getPathValue(values, field.optionsByField.field) ?? '')
          ] ?? []
        : field.options ?? []
    const normalizedCurrent = normalizedSelectValue(currentValue)
    const valueMatch = options.find(
      (option) => normalizedSelectValue(option.value) === normalizedCurrent,
    )
    if (valueMatch) {
      form.clearErrors(field.name)
      continue
    }
    const labelMatch = options.find(
      (option) => normalizedSelectValue(option.label) === normalizedCurrent,
    )
    if (labelMatch) {
      setPathValue(values, field.name, labelMatch.value)
      form.setValue(field.name, labelMatch.value, {
        shouldDirty: true,
        shouldValidate: false,
      })
      form.clearErrors(field.name)
      continue
    }
    form.setError(field.name, {
      type: 'validate',
      message: `Select ${field.label} again from the current Business Central list.`,
    })
    valid = false
  }
  return valid
}

function normalizedFieldName(value: string) {
  return value.replace(/[^a-z0-9]/gi, '').toLowerCase()
}

function initialFieldValue(
  payload: Record<string, unknown>,
  field: FieldConfig,
  fallback: unknown,
) {
  const mapped = (value: unknown) => {
    const key = String(value ?? '').trim().toLowerCase()
    return field.valueMap?.[key] ?? value
  }
  for (const path of field.valuePaths ?? [field.name]) {
    const value = getPathValue(payload, path)
    if (value !== undefined && value !== null) {
      const resolved = mapped(value)
      return field.type === 'date' ? toHtmlDateInputValue(resolved) : resolved
    }
  }
  const target = normalizedFieldName(field.name)
  const matchingKey = Object.keys(payload).find((key) => normalizedFieldName(key) === target)
  if (!matchingKey) return fallback
  const resolved = mapped(payload[matchingKey])
  return field.type === 'date' ? toHtmlDateInputValue(resolved) : resolved
}

function LineItemsField({
  field,
  form,
  renderField,
}: {
  field: LineItemsConfig
  form: UseFormReturn<FieldValues>
  renderField: (field: FieldConfig) => ReactElement
}) {
  const watchedRows = useWatch({ control: form.control, name: field.name })
  const rows = (Array.isArray(watchedRows) ? watchedRows : []) as Record<string, unknown>[]
  const [search, setSearch] = useState('')
  const filteredRows = useMemo(
    () =>
      rows
        .map((row, index) => ({ row, index }))
        .filter(({ row }) => matchesSearchQuery(row, search)),
    [rows, search],
  )
  const addLine = () => form.setValue(field.name, [...rows, field.defaultLine], { shouldDirty: true, shouldValidate: true })
  const removeLine = (index: number) =>
    form.setValue(
      field.name,
      rows.filter((_, currentIndex) => currentIndex !== index),
      { shouldDirty: true, shouldValidate: true },
    )

  return (
    <div className="col-span-full space-y-3 rounded border border-slate-200 p-3">
      <div className="flex items-center justify-between">
        <Label>{field.label}</Label>
        <Button type="button" variant="outline" size="sm" onClick={addLine}>
          <Plus className="h-4 w-4" />
          Add line
        </Button>
      </div>
      <ListSearch
        value={search}
        onChange={setSearch}
        total={rows.length}
        shown={filteredRows.length}
        placeholder={`Search ${field.label.toLowerCase()}...`}
        ariaLabel={`Search ${field.label.toLowerCase()}`}
      />
      <div className="space-y-3">
        {filteredRows.map(({ index }) => (
          <div key={`${field.name}-${index}`} className="rounded-md bg-slate-50 p-3">
            <div className="grid gap-3 md:grid-cols-2 xl:grid-cols-4">
              {field.fields.map((item) => renderField({ ...item, name: `${field.name}.${index}.${item.name}` }))}
            </div>
            {rows.length > 1 ? (
              <Button type="button" variant="ghost" size="sm" className="mt-2 text-red-600" onClick={() => removeLine(index)}>
                <Trash2 className="h-4 w-4" />
                Remove line
              </Button>
            ) : null}
          </div>
        ))}
        {filteredRows.length === 0 && search ? (
          <p className="rounded-md bg-slate-50 px-3 py-4 text-center text-sm text-slate-500">
            No lines match &quot;{search.trim()}&quot;.
          </p>
        ) : null}
      </div>
    </div>
  )
}

export function RequestFormPage({
  title,
  description,
  schema,
  defaultValues,
  fields,
  queryKey,
  listRequests,
  createRequest,
  listOnly = false,
  newButtonLabel = 'New Request',
  moduleConfig,
  listContent,
  detailFields,
  detailLineColumns,
  detailLineLabel = 'Lines',
  hideDetailAttachments = false,
  listActions,
  listColumns,
  listValueColumn,
  emptyListText,
  cancelStatuses = ['Pending Approval'],
  listStatusFilter = false,
  refetchOnMount,
  onValuesChange,
  formPreface,
  createSupplement,
  detailContent,
}: RequestFormPageProps) {
  const queryClient = useQueryClient()
  const toast = useToast()
  const confirm = useConfirm()
  const [showForm, setShowForm] = useState(false)
  const [selectedId, setSelectedId] = useState<string | null>(null)
  const [editingRequestId, setEditingRequestId] = useState<string | null>(null)
  const [actionId, setActionId] = useState<string | null>(null)
  const [detailLineSearch, setDetailLineSearch] = useState('')
  const [listStatus, setListStatus] = useState('all')
  const requestsQuery = useQuery({ queryKey, queryFn: listRequests, refetchOnMount })
  const detailQuery = useQuery({
    queryKey: [...queryKey, 'detail', selectedId],
    queryFn: () => getModuleRequest(moduleConfig!, selectedId!),
    enabled: Boolean(moduleConfig && selectedId),
  })

  useEffect(() => {
    setDetailLineSearch('')
  }, [selectedId])

  const refreshLists = async () => {
    await queryClient.invalidateQueries({ queryKey })
    await queryClient.invalidateQueries({ queryKey: ['dashboard'] })
    await queryClient.invalidateQueries({ queryKey: ['approvals'] })
  }

  const refreshDetail = async () => {
    await refreshLists()
    await detailQuery.refetch()
  }

  const handleCancel = async (id: string) => {
    if (!moduleConfig) return
    const yes = await confirm({
      title: 'Cancel request',
      message: 'Are you sure you want to cancel this request?',
      confirmLabel: 'Cancel Request',
      cancelLabel: 'Keep',
      tone: 'danger',
    })
    if (!yes) return
    setActionId(id)
    try {
      await cancelModuleRequest(moduleConfig, id)
      await refreshLists()
      toast.success('Request cancelled')
    } catch (err: unknown) {
      toast.error(err instanceof Error ? err.message : 'Cancel failed', 'Action failed')
    } finally {
      setActionId(null)
    }
  }

  const handleSubmitDraft = async (id: string) => {
    if (!moduleConfig) return
    const yes = await confirm({
      title: 'Request approval',
      message: 'Submit this draft into the approval workflow?',
      confirmLabel: 'Request Approval',
    })
    if (!yes) return
    setActionId(id)
    try {
      await submitModuleRequest(moduleConfig, id)
      await refreshLists()
      await detailQuery.refetch()
      toast.success('Request sent for approval')
    } catch (err: unknown) {
      toast.error(err instanceof Error ? err.message : 'Submission failed', 'Action failed')
    } finally {
      setActionId(null)
    }
  }

  const form = useForm<FieldValues>({
    resolver: zodResolver(schema) as Resolver<FieldValues>,
    defaultValues,
    mode: 'onBlur',
  })
  const watchedValues = useWatch({ control: form.control }) as FieldValues

  useEffect(() => {
    if (!onValuesChange) return
    void onValuesChange(watchedValues, form)
  }, [watchedValues, form, onValuesChange])

  const mutation = useMutation({
    mutationFn: (values: Record<string, unknown>) =>
      editingRequestId ? updateRequestHeader(editingRequestId, values) : createRequest(values),
    onSuccess: async (data, variables) => {
      const editedId = editingRequestId
      form.reset(defaultValues)
      setShowForm(false)
      setEditingRequestId(null)
      if (editedId) {
        setSelectedId(editedId)
      } else if (moduleConfig && data && typeof data === 'object' && 'id' in data) {
        setSelectedId(String((data as { id: unknown }).id))
      }
      await refreshLists()
      const submitted = (variables as { submit?: boolean })?.submit
      toast.success(editedId ? `${title} updated` : submitted ? `${title} submitted for approval` : `${title} saved as draft`)
    },
    onError: (error) =>
      toast.error(error instanceof Error ? error.message : 'Could not save the request', 'Save failed'),
  })

  const errorFor = (name: string) => {
    const error = getPathValue(form.formState.errors, name)
    if (error && typeof error === 'object' && 'message' in error) {
      return String((error as { message?: unknown }).message ?? '')
    }
    return ''
  }

  const submit = (submitForApproval: boolean) => {
    const currentValues = form.getValues()
    const formFields = fields.filter((field): field is FieldConfig => field.type !== 'lineItems')
    if (!normalizeAndValidateSelectValues(formFields, currentValues, form)) return
    return form.handleSubmit((values) => {
      mutation.mutate(editingRequestId ? values : { ...values, submit: submitForApproval })
    })()
  }

  const renderField = (field: FieldConfig) => {
    if (field.visibleWhen && !field.visibleWhen(watchedValues)) {
      return <></>
    }
    const error = errorFor(field.name)
    const inputId = field.name.replaceAll('.', '-')
    const options = field.optionsWhen
      ? field.optionsWhen(watchedValues)
      : field.optionsByField
        ? field.optionsByField.options[String(getPathValue(watchedValues, field.optionsByField.field) ?? '')] ?? []
        : field.options ?? []
    const readOnly = field.readOnly || Boolean(field.readOnlyWhen?.(watchedValues))

    return (
      <div key={field.name} className={field.type === 'checkbox' ? 'flex items-center gap-2' : 'space-y-1.5'}>
        {field.type !== 'checkbox' ? <Label htmlFor={inputId}>{field.label}</Label> : null}
        {field.type === 'textarea' ? (
          <Textarea id={inputId} placeholder={field.placeholder} readOnly={readOnly} {...form.register(field.name)} />
        ) : null}
        {field.type === 'select' ? (
          <Select
            id={inputId}
            placeholder={field.placeholder ?? 'Select'}
            options={options}
            disabled={readOnly}
            {...form.register(field.name)}
          />
        ) : null}
        {field.type === 'time' ? (
          <Controller
            control={form.control}
            name={field.name}
            render={({ field: timeField }) => (
              <TimePicker
                ref={timeField.ref}
                id={inputId}
                name={timeField.name}
                value={String(timeField.value ?? '')}
                placeholder={field.placeholder}
                disabled={readOnly}
                onChange={timeField.onChange}
                onBlur={timeField.onBlur}
              />
            )}
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
              field.name,
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
            <input id={inputId} type="checkbox" className="h-4 w-4 rounded border-slate-300" {...form.register(field.name)} />
            <Label htmlFor={inputId}>{field.label}</Label>
          </>
        ) : null}
        {field.type === 'files' ? (
          <Controller
            control={form.control}
            name={field.name}
            render={({ field: fileField }) => (
              <FileUpload files={(fileField.value as Attachment[] | undefined) ?? []} onChange={fileField.onChange} />
            )}
          />
        ) : null}
        {error ? <p className="text-xs font-medium text-red-600">{error}</p> : null}
        {!error && field.hint ? <p className="text-xs text-slate-500">{field.hint}</p> : null}
      </div>
    )
  }

  const defaultColumns: DataTableColumn<PortalRequest>[] = [
    { id: 'requestNo', header: 'No.', cell: (row) => row.requestNo },
    { id: 'date', header: 'Date', cell: (row) => formatDate(row.createdAt) },
    { id: 'status', header: 'Status', cell: (row) => <StatusBadge status={row.status} /> },
    { id: 'title', header: 'Description', cell: (row) => row.title },
    ...(listValueColumn === false
      ? []
      : [
          listValueColumn ?? {
            id: 'amount',
            header: 'Amount',
            cell: (row) => formatCurrency(row.amount),
          },
        ]),
  ]
  const columns: DataTableColumn<PortalRequest>[] = [
    ...(listColumns ?? defaultColumns),
    ...(moduleConfig
      ? [
          {
            id: 'actions',
            header: 'Actions',
            cell: (row: PortalRequest) => (
              <div className="flex gap-1">
                <Button
                  type="button"
                  variant="ghost"
                  size="sm"
                  onClick={() => setSelectedId(row.id)}
                >
                  <Eye className="h-4 w-4" />
                  View
                </Button>
                {cancelStatuses.includes(row.status) ? (
                  <Button
                    type="button"
                    variant="ghost"
                    size="sm"
                    className="text-amber-700"
                    disabled={actionId === row.id}
                    onClick={() => handleCancel(row.id)}
                  >
                    Cancel
                  </Button>
                ) : null}
              </div>
            ),
          } satisfies DataTableColumn<PortalRequest>,
        ]
      : []),
  ]

  const selected = detailQuery.data
  if (selectedId && moduleConfig) {
    const payload = selected?.payload ?? {}
    const lines = Array.isArray(payload.lines)
      ? (payload.lines as Record<string, unknown>[])
      : []
    const filteredLines = lines.filter((line) => matchesSearchQuery(line, detailLineSearch))
    const headerFields = fields
      .filter((field): field is FieldConfig => field.type !== 'lineItems' && field.type !== 'files')
      .map((field) => ({
        field,
        value: initialFieldValue(payload, field, undefined),
      }))
      .filter(({ value }) => value !== null && value !== undefined && value !== '')
    const detailSource = { request: selected, payload }
    const supportsAttachments =
      !hideDetailAttachments &&
      Boolean(
        moduleConfig &&
          (PORTAL_ATTACHMENT_MODULES.has(moduleConfig.module) ||
            fields.some((field) => field.type === 'files')),
      )
    return (
      <PageWrapper title={`${title} Details`} showPageHeading={false}>
        <PortalFormCard title={`${title} Details`}>
          <div className="space-y-6">
            <div className="flex flex-wrap items-center justify-between gap-3 border-b border-slate-200 pb-4">
              <Button type="button" variant="outline" onClick={() => setSelectedId(null)}>
                <ArrowLeft className="h-4 w-4" />
                Back
              </Button>
              {selected ? (
                <div className="flex flex-wrap gap-2">
                  {isEditableRequestStatus(selected.status, moduleConfig?.module) && !listOnly && fields.length > 0 ? (
                    <Button
                      type="button"
                      variant="outline"
                      onClick={() => {
                        const nextValues = Object.fromEntries(
                          fields
                            .filter((field): field is FieldConfig => field.type !== 'lineItems')
                            .map((field) => [
                              field.name,
                              initialFieldValue(selected.payload ?? {}, field, defaultValues[field.name]),
                            ]),
                        )
                        form.reset(nextValues)
                        setEditingRequestId(selected.id)
                        setSelectedId(null)
                        setShowForm(true)
                      }}
                    >
                      <Pencil className="h-4 w-4" />
                      Edit
                    </Button>
                  ) : null}
                  {isEditableRequestStatus(selected.status, moduleConfig?.module) &&
                  canRequestApproval(moduleConfig?.module, selected.payload) ? (
                    <Button
                      type="button"
                      disabled={actionId === selected.id}
                      onClick={() => void handleSubmitDraft(selected.id)}
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
                      onClick={() => void handleCancel(selected.id)}
                    >
                      Cancel
                    </Button>
                  ) : null}
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
                  const payload = selected.payload ?? {}
                  const rejectionNote = String(
                    payload.RejectionReason ??
                      payload.rejectionReason ??
                      selected.approvalSteps?.find((step) =>
                        /reject|declin/i.test(String(step.status ?? '')),
                      )?.note ??
                      '',
                  ).trim()
                  if (selected.status !== 'Rejected' && !rejectionNote) return null
                  return (
                    <div className="rounded-lg border border-red-200 bg-red-50 p-4 text-sm text-red-900">
                      <p className="font-semibold">Rejection reason</p>
                      <p className="mt-1 whitespace-pre-wrap">
                        {rejectionNote ||
                          'This request was rejected. No rejection comment was recorded in Business Central.'}
                      </p>
                    </div>
                  )
                })()}
                <RequestProgress status={selected.status} hasLines={lines.length > 0} requiresLines={false} />
                <section>
                  <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
                    {detailFields
                      ? detailFields
                          .map((field) => ({
                            field,
                            value: firstPathValue(
                              detailSource,
                              field.paths,
                              field.format,
                              Boolean(field.hideZero),
                            ),
                          }))
                          .filter(({ field, value }) => {
                            if (value === undefined) return false
                            return shouldShowFinanceOrgDetailField(
                              field.label,
                              value,
                              payload as Record<string, unknown>,
                            )
                          })
                          .map(({ field, value }) => (
                            <div key={field.label}>
                              <p className="text-xs text-slate-500">{field.label}</p>
                              <div className="font-semibold">
                                {renderDetailValue(value, field.format)}
                              </div>
                            </div>
                          ))
                      : (
                      <>
                        <div><p className="text-xs text-slate-500">Request No.</p><p className="font-semibold">{selected.requestNo}</p></div>
                        <div><p className="text-xs text-slate-500">Status</p><StatusBadge status={selected.status} /></div>
                        <div><p className="text-xs text-slate-500">Created</p><p className="font-semibold">{formatDate(selected.createdAt)}</p></div>
                      </>
                    )}
                  </div>
                </section>

                {!detailFields && headerFields.length ? (
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

                {detailContent ? detailContent(selected, refreshDetail) : null}

                {lines.length && detailLineColumns?.length ? (
                  <section className="border-t border-slate-200 pt-4">
                    <h3 className="mb-3 text-sm font-semibold text-[var(--portal-navy)]">{detailLineLabel}</h3>
                    <div className="mb-3">
                      <ListSearch
                        value={detailLineSearch}
                        onChange={setDetailLineSearch}
                        total={lines.length}
                        shown={filteredLines.length}
                        placeholder={`Search ${detailLineLabel.toLowerCase()}...`}
                        ariaLabel={`Search ${detailLineLabel.toLowerCase()}`}
                      />
                    </div>
                    <div className="overflow-x-auto">
                      <table className="w-full text-left text-sm">
                        <thead className="border-b border-slate-200 text-xs text-slate-500">
                          <tr>
                            {detailLineColumns.map((column) => <th key={column.label} className="px-2 py-2">{column.label}</th>)}
                          </tr>
                        </thead>
                        <tbody>
                          {filteredLines.map((line, index) => (
                            <tr key={String(line.id ?? line.lineNo ?? index)} className="border-b border-slate-100">
                              {detailLineColumns.map((column) => (
                                <td key={column.label} className="px-2 py-2">
                                  {renderDetailValue(lineDetailValue(line, column, selected?.amount, detailSource), column.format)}
                                </td>
                              ))}
                            </tr>
                          ))}
                          {filteredLines.length === 0 ? (
                            <tr>
                              <td colSpan={detailLineColumns.length} className="px-2 py-4 text-center text-slate-500">
                                No lines match &quot;{detailLineSearch.trim()}&quot;.
                              </td>
                            </tr>
                          ) : null}
                        </tbody>
                      </table>
                    </div>
                  </section>
                ) : null}

                {supportsAttachments && selected ? (
                  <RequestAttachments
                    requestId={selected.id}
                    attachments={selected.attachments}
                    canUpload={canUploadRequestAttachments(selected.status, moduleConfig?.module)}
                    canDelete={canDeleteRequestItems(selected.status, moduleConfig?.module)}
                    onUpdated={() => {
                      void refreshLists()
                      void detailQuery.refetch()
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

  if (showForm && !listOnly) {
    return (
      <PageWrapper title={editingRequestId ? `Edit ${title}` : title} showPageHeading={false}>
        <PortalFormCard title={editingRequestId ? `Edit ${title}` : title}>
          <form className="space-y-4" onSubmit={(event) => event.preventDefault()}>
            {formPreface}
            <div className="grid gap-3 sm:grid-cols-1 sm:gap-4 md:grid-cols-2">
              {fields.map((field) =>
                field.type === 'lineItems' ? (
                  <LineItemsField key={field.name} field={field} form={form} renderField={renderField} />
                ) : (
                  renderField(field)
                ),
              )}
            </div>
            {createSupplement ? createSupplement(watchedValues) : null}
            {description ? <p className="text-sm text-slate-600">{description}</p> : null}
            {mutation.error ? (
              <div className="flex items-start gap-2 rounded-md border border-red-200 bg-red-50 p-3 text-sm text-red-700">
                <AlertCircle className="mt-0.5 h-4 w-4" />
                {mutation.error instanceof Error ? mutation.error.message : 'Request failed'}
              </div>
            ) : null}
            <div className="grid grid-cols-1 gap-2 pt-2 sm:flex sm:flex-wrap sm:justify-center">
              <Button
                type="button"
                variant="outline"
                className="rounded-full sm:order-1"
                disabled={mutation.isPending}
                onClick={() => {
                  const editedId = editingRequestId
                  setEditingRequestId(null)
                  setShowForm(false)
                  form.reset(defaultValues)
                  if (editedId) setSelectedId(editedId)
                }}
              >
                Cancel
              </Button>
              {editingRequestId ? (
                <Button
                  type="button"
                  className="rounded-full sm:order-2"
                  disabled={mutation.isPending}
                  onClick={() => submit(false)}
                >
                  <Save className="h-4 w-4" />
                  {mutation.isPending ? 'Saving…' : 'Save changes'}
                </Button>
              ) : moduleConfig ? (
                <Button
                  type="button"
                  className="rounded-full sm:order-2"
                  disabled={mutation.isPending}
                  onClick={() => submit(false)}
                >
                  <Save className="h-4 w-4" />
                  {mutation.isPending ? 'Creating draft…' : 'Create draft'}
                </Button>
              ) : (
                <>
                  <Button
                    type="button"
                    variant="outline"
                    className="rounded-full sm:order-2"
                    disabled={mutation.isPending}
                    onClick={() => submit(false)}
                  >
                    <Save className="h-4 w-4" />
                    Save draft
                  </Button>
                  <Button
                    type="button"
                    className="rounded-full sm:order-3"
                    disabled={mutation.isPending}
                    onClick={() => submit(true)}
                  >
                    <Send className="h-4 w-4" />
                    Submit
                  </Button>
                </>
              )}
            </div>
          </form>
        </PortalFormCard>
      </PageWrapper>
    )
  }

  return (
    <PageWrapper
      title={title}
      actions={listActions ?? (listOnly ? undefined : <PortalNewButton label={newButtonLabel} onClick={() => {
          setEditingRequestId(null)
          form.reset(defaultValues)
          setShowForm(true)
        }} />)}
    >
      {listContent}
      {requestsQuery.isLoading ? (
        <Skeleton className="h-48 w-full" />
      ) : requestsQuery.isError ? (
        <div className="rounded border-l-4 border-red-500 bg-red-50 p-4 text-sm text-red-700">
          {requestsQuery.error instanceof Error
            ? requestsQuery.error.message
            : 'Could not load requests. Check the Business Central connection and try again.'}
        </div>
      ) : (
        <>
          {listStatusFilter ? (
            <div className="mb-3 flex flex-wrap gap-1.5">
              {[
                { value: 'all', label: 'All' },
                { value: 'draft', label: 'Draft' },
                { value: 'pending', label: 'Pending' },
                { value: 'rejected', label: 'Rejected' },
                { value: 'approved', label: 'Approved' },
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
          <DataTable
            rows={(requestsQuery.data ?? []).filter((row) =>
              listStatusFilter ? matchesRequestListStatus(row.status, listStatus) : true,
            )}
            columns={columns}
            getRowId={(row) => row.id}
            compact
            emptyTitle={emptyListText}
          />
        </>
      )}
    </PageWrapper>
  )
}
