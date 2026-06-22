import { zodResolver } from '@hookform/resolvers/zod'
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { AlertCircle, ArrowLeft, Download, Eye, Plus, Save, Send, Trash2 } from 'lucide-react'
import { useState, type ReactElement, type ReactNode } from 'react'
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
import { DataTable, type DataTableColumn } from './DataTable'
import { FileUpload } from './FileUpload'
import { StatusBadge } from './StatusBadge'
import {
  cancelModuleRequest,
  downloadRequestAttachment,
  getModuleRequest,
  submitModuleRequest,
  type EndpointConfig,
} from '@/api/endpoints/requestEndpoint'
import { formatCurrency, formatDate } from '@/utils/formatters'
import type { Attachment, PortalRequest } from '@/types/erp.types'

type BasicFieldType = 'text' | 'number' | 'date' | 'textarea' | 'select' | 'checkbox' | 'files'

export interface FieldConfig {
  name: string
  label: string
  type: BasicFieldType
  placeholder?: string
  options?: SelectOption[]
  readOnly?: boolean
}

export interface LineItemsConfig {
  name: string
  label: string
  type: 'lineItems'
  defaultLine: Record<string, unknown>
  fields: FieldConfig[]
}

export type RequestFieldConfig = FieldConfig | LineItemsConfig

interface RequestFormPageProps {
  title: string
  description?: string
  schema: Parameters<typeof zodResolver>[0]
  defaultValues: FieldValues
  fields: RequestFieldConfig[]
  queryKey: readonly unknown[]
  listRequests: () => Promise<PortalRequest[]>
  createRequest: (values: Record<string, unknown>) => Promise<unknown>
  businessRules?: string[]
  source?: string
  listOnly?: boolean
  newButtonLabel?: string
  /** When set, list rows get Cancel / Delete actions wired to the mock/ERP backend. */
  moduleConfig?: EndpointConfig
  listContent?: ReactNode
}

function getPathValue(source: unknown, path: string) {
  return path.split('.').reduce<unknown>((current, part) => {
    if (!current || typeof current !== 'object') return undefined
    if (Array.isArray(current)) return current[Number(part)]
    return (current as Record<string, unknown>)[part]
  }, source)
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
      <div className="space-y-3">
        {rows.map((_, index) => (
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
  businessRules,
  listOnly = false,
  newButtonLabel = 'New Request',
  moduleConfig,
  listContent,
}: RequestFormPageProps) {
  const queryClient = useQueryClient()
  const toast = useToast()
  const confirm = useConfirm()
  const [showForm, setShowForm] = useState(false)
  const [selectedId, setSelectedId] = useState<string | null>(null)
  const [actionId, setActionId] = useState<string | null>(null)
  const requestsQuery = useQuery({ queryKey, queryFn: listRequests })
  const detailQuery = useQuery({
    queryKey: [...queryKey, 'detail', selectedId],
    queryFn: () => getModuleRequest(moduleConfig!, selectedId!),
    enabled: Boolean(moduleConfig && selectedId),
  })

  const refreshLists = async () => {
    await queryClient.invalidateQueries({ queryKey })
    await queryClient.invalidateQueries({ queryKey: ['dashboard'] })
    await queryClient.invalidateQueries({ queryKey: ['approvals'] })
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

  const handleDownload = async (requestId: string, attachment: Attachment) => {
    setActionId(attachment.id)
    try {
      await downloadRequestAttachment(requestId, attachment)
    } catch (err: unknown) {
      toast.error(err instanceof Error ? err.message : 'Attachment download failed', 'Download failed')
    } finally {
      setActionId(null)
    }
  }
  const form = useForm<FieldValues>({
    resolver: zodResolver(schema) as Resolver<FieldValues>,
    defaultValues,
    mode: 'onBlur',
  })

  const mutation = useMutation({
    mutationFn: createRequest,
    onSuccess: async (_data, variables) => {
      form.reset(defaultValues)
      setShowForm(false)
      await refreshLists()
      const submitted = (variables as { submit?: boolean })?.submit
      toast.success(submitted ? `${title} submitted for approval` : `${title} saved as draft`)
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

  const submit = (submitForApproval: boolean) =>
    form.handleSubmit((values) => {
      mutation.mutate({ ...values, submit: submitForApproval })
    })()

  const renderField = (field: FieldConfig) => {
    const error = errorFor(field.name)
    const inputId = field.name.replaceAll('.', '-')

    return (
      <div key={field.name} className={field.type === 'checkbox' ? 'flex items-center gap-2' : 'space-y-1.5'}>
        {field.type !== 'checkbox' ? <Label htmlFor={inputId}>{field.label}</Label> : null}
        {field.type === 'textarea' ? (
          <Textarea id={inputId} placeholder={field.placeholder} readOnly={field.readOnly} {...form.register(field.name)} />
        ) : null}
        {field.type === 'select' ? (
          <Select
            id={inputId}
            placeholder={field.placeholder ?? 'Select'}
            options={field.options ?? []}
            disabled={field.readOnly}
            {...form.register(field.name)}
          />
        ) : null}
        {['text', 'number', 'date'].includes(field.type) ? (
          <Input
            id={inputId}
            type={field.type}
            placeholder={field.placeholder}
            readOnly={field.readOnly}
            {...form.register(field.name)}
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
      </div>
    )
  }

  const columns: DataTableColumn<PortalRequest>[] = [
    { id: 'requestNo', header: 'No.', cell: (row) => row.requestNo },
    { id: 'date', header: 'Date', cell: (row) => formatDate(row.createdAt) },
    { id: 'status', header: 'Status', cell: (row) => <StatusBadge status={row.status} /> },
    { id: 'title', header: 'Description', cell: (row) => row.title },
    { id: 'amount', header: 'Amount', cell: (row) => formatCurrency(row.amount) },
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
                {['Draft', 'Pending Approval'].includes(row.status) ? (
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
    const lineKeys = Object.keys(lines[0] ?? {}).filter((key) => key !== 'id')
    const headerFields = Object.entries(payload).filter(
      ([key, value]) =>
        key !== 'lines' &&
        key !== 'attachments' &&
        value !== null &&
        value !== undefined &&
        ['string', 'number', 'boolean'].includes(typeof value),
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
                  {selected.status === 'Draft' ? (
                    <Button
                      type="button"
                      disabled={actionId === selected.id}
                      onClick={() => void handleSubmitDraft(selected.id)}
                    >
                      <Send className="h-4 w-4" />
                      Request Approval
                    </Button>
                  ) : null}
                  {['Draft', 'Pending Approval'].includes(selected.status) ? (
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
              <p className="text-sm text-red-600">Could not load this request.</p>
            ) : null}
            {selected ? (
              <>
                <section>
                  <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
                    <div><p className="text-xs text-slate-500">Request No.</p><p className="font-semibold">{selected.requestNo}</p></div>
                    <div><p className="text-xs text-slate-500">Status</p><StatusBadge status={selected.status} /></div>
                    <div><p className="text-xs text-slate-500">Created</p><p className="font-semibold">{formatDate(selected.createdAt)}</p></div>
                    <div><p className="text-xs text-slate-500">Employee</p><p className="font-semibold">{selected.makerName || selected.makerEmployeeNo}</p></div>
                    <div><p className="text-xs text-slate-500">Department</p><p className="font-semibold">{selected.departmentName || selected.departmentCode || '-'}</p></div>
                    <div><p className="text-xs text-slate-500">Amount</p><p className="font-semibold">{formatCurrency(selected.amount)}</p></div>
                  </div>
                </section>

                {headerFields.length ? (
                  <section className="border-t border-slate-200 pt-4">
                    <h3 className="mb-3 text-sm font-semibold text-[var(--portal-navy)]">Request Information</h3>
                    <dl className="grid gap-3 sm:grid-cols-2 lg:grid-cols-3">
                      {headerFields.map(([key, value]) => (
                        <div key={key}>
                          <dt className="text-xs text-slate-500">{key.replace(/([A-Z])/g, ' $1').replaceAll('_', ' ')}</dt>
                          <dd className="break-words text-sm font-medium">{String(value)}</dd>
                        </div>
                      ))}
                    </dl>
                  </section>
                ) : null}

                {lines.length ? (
                  <section className="border-t border-slate-200 pt-4">
                    <h3 className="mb-3 text-sm font-semibold text-[var(--portal-navy)]">Lines</h3>
                    <div className="overflow-x-auto">
                      <table className="w-full text-left text-sm">
                        <thead className="border-b border-slate-200 text-xs text-slate-500">
                          <tr>
                            {lineKeys.map((key) => <th key={key} className="px-2 py-2">{key.replace(/([A-Z])/g, ' $1').replaceAll('_', ' ')}</th>)}
                          </tr>
                        </thead>
                        <tbody>
                          {lines.map((line, index) => (
                            <tr key={String(line.id ?? line.lineNo ?? index)} className="border-b border-slate-100">
                              {lineKeys.map((key) => <td key={key} className="px-2 py-2">{String(line[key] ?? '')}</td>)}
                            </tr>
                          ))}
                        </tbody>
                      </table>
                    </div>
                  </section>
                ) : null}

                <section className="border-t border-slate-200 pt-4">
                  <h3 className="mb-3 text-sm font-semibold text-[var(--portal-navy)]">Attachments</h3>
                  {selected.attachments.length ? (
                    <div className="divide-y divide-slate-100 border-y border-slate-200">
                      {selected.attachments.map((attachment) => (
                        <div key={attachment.id} className="flex items-center justify-between gap-3 py-3">
                          <div className="min-w-0">
                            <p className="truncate text-sm font-medium">{attachment.fileName}</p>
                            <p className="text-xs text-slate-500">{attachment.description || attachment.fileType}</p>
                          </div>
                          <Button
                            type="button"
                            variant="outline"
                            size="sm"
                            disabled={actionId === attachment.id}
                            onClick={() => void handleDownload(selected.id, attachment)}
                          >
                            <Download className="h-4 w-4" />
                            Download
                          </Button>
                        </div>
                      ))}
                    </div>
                  ) : <p className="text-sm italic text-slate-500">No attachments.</p>}
                </section>

                <section className="border-t border-slate-200 pt-4">
                  <h3 className="mb-3 text-sm font-semibold text-[var(--portal-navy)]">Approval History</h3>
                  {selected.approvalSteps.length ? (
                    <div className="space-y-2">
                      {selected.approvalSteps.map((step) => (
                        <div key={step.id} className="flex flex-wrap items-center justify-between gap-2 border-b border-slate-100 py-2 text-sm">
                          <span>{step.actorName || step.actorEmployeeNo} - {step.role}</span>
                          <StatusBadge status={step.status} />
                        </div>
                      ))}
                    </div>
                  ) : <p className="text-sm italic text-slate-500">No approval entries yet.</p>}
                </section>
              </>
            ) : null}
          </div>
        </PortalFormCard>
      </PageWrapper>
    )
  }

  if (showForm && !listOnly) {
    return (
      <PageWrapper title={title} showPageHeading={false}>
        <PortalFormCard title={title}>
          <form className="space-y-4" onSubmit={(event) => event.preventDefault()}>
            <div className="grid gap-3 sm:grid-cols-1 sm:gap-4 md:grid-cols-2">
              {fields.map((field) =>
                field.type === 'lineItems' ? (
                  <LineItemsField key={field.name} field={field} form={form} renderField={renderField} />
                ) : (
                  renderField(field)
                ),
              )}
            </div>
            {description ? <p className="text-sm text-slate-600">{description}</p> : null}
            {businessRules?.length ? (
              <div className="rounded-md border border-blue-200 bg-blue-50 p-3 text-sm text-blue-900">
                <p className="font-semibold">Business rules</p>
                <ul className="mt-1 list-inside list-disc space-y-0.5 text-blue-800">
                  {businessRules.map((rule) => (
                    <li key={rule}>{rule}</li>
                  ))}
                </ul>
              </div>
            ) : null}
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
                onClick={() => setShowForm(false)}
              >
                Cancel
              </Button>
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
            </div>
          </form>
        </PortalFormCard>
      </PageWrapper>
    )
  }

  return (
    <PageWrapper
      title={title}
      actions={listOnly ? undefined : <PortalNewButton label={newButtonLabel} onClick={() => setShowForm(true)} />}
    >
      {listContent}
      {requestsQuery.isLoading ? (
        <Skeleton className="h-48 w-full" />
      ) : requestsQuery.isError ? (
        <div className="rounded border-l-4 border-red-500 bg-red-50 p-4 text-sm text-red-700">
          Could not load requests. Check the selected backend and apply pending database migrations.
        </div>
      ) : (
        <DataTable rows={requestsQuery.data ?? []} columns={columns} getRowId={(row) => row.id} compact />
      )}
    </PageWrapper>
  )
}
