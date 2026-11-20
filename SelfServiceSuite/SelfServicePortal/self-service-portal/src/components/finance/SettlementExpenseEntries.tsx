import { useRef, useState } from 'react'
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { FileUp, Loader2, Plus, Save, Trash2 } from 'lucide-react'
import {
  deleteAdvanceSettlementExpense,
  saveAdvanceSettlementExpense,
  type AdvanceSettlementContext,
  type SettlementLine,
} from '@/api/endpoints/advanceSettlement'
import { fetchPettyCashExpenseCategories } from '@/api/endpoints/pettyCashCategories'
import { deleteRequestAttachment, downloadRequestAttachment, uploadRequestAttachment } from '@/api/endpoints/requestEndpoint'
import { useConfirm } from '@/components/feedback/ConfirmProvider'
import { useToast } from '@/components/feedback/ToastProvider'
import { attachmentVisual, formatFileSize } from '@/components/shared/attachmentUi'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Select } from '@/components/ui/select'
import { SETTLEMENT_QUERY_ROOT } from '@/hooks/useAdvanceSettlementContext'
import { cn } from '@/lib/utils'
import { formatAmount } from '@/utils/formatters'
import type { Attachment, PortalRequest } from '@/types/erp.types'

const ALLOWED_EXTENSIONS = new Set(['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'])
const MAX_FILE_BYTES = 10_000_000
/** A supporting document belongs to an expense entry through its BC attachment description: `[E<entry no>] …`. */
const ENTRY_TAG = /^\[E(\d+)\]\s*/

/** The expense entry an attachment belongs to (0: the settlement as a whole). */
function attachmentEntryNo(attachment: Attachment) {
  const match = ENTRY_TAG.exec(String(attachment.description ?? ''))
  return match ? Number(match[1]) : 0
}

function attachmentNote(attachment: Attachment) {
  return String(attachment.description ?? '').replace(ENTRY_TAG, '').trim()
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

async function uploadDocument(requestId: string, file: File, description: string) {
  return uploadRequestAttachment(requestId, {
    fileName: file.name,
    fileType: file.type || 'application/octet-stream',
    size: file.size,
    contentBase64: await readFileBase64(file),
    description: description.slice(0, 250),
  })
}

function lineSignature(line: SettlementLine) {
  return [line.lineNo, line.expenseCategory, line.expenseDescription, line.actualSpent, line.referenceNo].join('|')
}

/**
 * Section 2 of the Advance Settlement (client redesign, 16 Nov 2026): one card per expense — purpose, category,
 * amount (ETB), receipt / reference no. and its own supporting documents — and Add Expense Entry for as many as
 * needed. Lines copied from the advance are entries too (their category stays). Needs BC 1.0.3.663.
 */
export function SettlementExpenseEntries({
  request,
  ctx,
  editable,
}: {
  request: PortalRequest
  ctx: AdvanceSettlementContext
  editable: boolean
}) {
  const [newEntries, setNewEntries] = useState<string[]>(() => (ctx.lines.length ? [] : ['new-1']))
  const counter = useRef(1)
  const attachments = request.attachments ?? []
  const generalDocuments = attachments.filter((attachment) => attachmentEntryNo(attachment) === 0)
  const categoriesQuery = useQuery({
    queryKey: ['finance', 'advance-settlement', 'expense-categories'],
    queryFn: fetchPettyCashExpenseCategories,
    enabled: editable,
    staleTime: 5 * 60_000,
  })
  const categories = (categoriesQuery.data?.rows ?? [])
    .filter((row) => String(row.meta?.accountNo ?? '').trim())
    .map((row) => ({ value: String(row.value), label: String(row.label) }))

  const addEntry = () => {
    counter.current += 1
    setNewEntries((current) => [...current, `new-${counter.current}`])
  }

  return (
    <div className="space-y-4">
      <div>
        <p className="text-sm font-semibold text-slate-900">Expense Details</p>
        <p className="text-xs text-slate-500">Each entry represents one expense incurred from the advance.</p>
      </div>
      {editable && !categoriesQuery.isLoading && categories.length === 0 ? (
        <p className="rounded-lg border border-amber-200 bg-amber-50 px-3 py-2 text-xs text-amber-900">
          No expense category has a G/L account in Business Central yet, so new expenses cannot be added. Finance sets the G/L
          Account on the expense categories (Receipts and Payment Types).
        </p>
      ) : null}

      {ctx.lines.map((line, index) => (
        <ExpenseEntryCard
          key={`entry-${String(line.lineNo)}-${lineSignature(line)}`}
          number={index + 1}
          line={line}
          request={request}
          surrenderNo={ctx.surrenderNo}
          categories={categories}
          documents={attachments.filter((attachment) => attachmentEntryNo(attachment) === Number(line.lineNo))}
          editable={editable}
        />
      ))}
      {editable
        ? newEntries.map((key, index) => (
            <ExpenseEntryCard
              key={key}
              number={ctx.lines.length + index + 1}
              request={request}
              surrenderNo={ctx.surrenderNo}
              categories={categories}
              documents={[]}
              editable
              onDiscard={() => setNewEntries((current) => current.filter((row) => row !== key))}
              onCreated={() => setNewEntries((current) => current.filter((row) => row !== key))}
            />
          ))
        : null}
      {!ctx.lines.length && !editable ? <p className="text-sm text-slate-500">No expense entries.</p> : null}

      {editable ? (
        <div className="flex justify-end">
          <Button type="button" variant="gradient" disabled={categories.length === 0} onClick={addEntry}>
            <Plus className="mr-1.5 h-4 w-4" />
            Add Expense Entry
          </Button>
        </div>
      ) : null}

      <div className="rounded-xl border border-slate-200 bg-white px-4 py-3">
        <p className="text-sm font-semibold text-slate-900">Other supporting documents</p>
        <p className="text-xs text-slate-500">
          Documents for the settlement as a whole, for example the refund payment receipt for an Advance Surrender.
        </p>
        <DocumentList
          request={request}
          documents={generalDocuments}
          editable={editable}
          onFiles={(files) => Promise.all(files.map((file) => uploadDocument(request.id, file, `Supporting document: ${file.name}`)))}
          uploadLabel="Upload a supporting document"
        />
      </div>
    </div>
  )
}

function ExpenseEntryCard({
  number,
  line,
  request,
  surrenderNo,
  categories,
  documents,
  editable,
  onDiscard,
  onCreated,
}: {
  number: number
  line?: SettlementLine
  request: PortalRequest
  surrenderNo: string
  categories: Array<{ value: string; label: string }>
  documents: Attachment[]
  editable: boolean
  onDiscard?: () => void
  onCreated?: () => void
}) {
  const toast = useToast()
  const confirm = useConfirm()
  const queryClient = useQueryClient()
  const entryNo = line ? Number(line.lineNo) || 0 : 0
  // A line copied from the advance keeps its category (BC account); the employee's own entries can change it.
  const fromAdvance = Boolean(line) && line?.esspEntry !== true
  const savedPurpose = String(line?.expenseDescription || (fromAdvance ? '' : line?.accountName) || '')
  const savedAmount = line ? String(Number(line.actualSpent ?? 0) || '') : ''
  const [purpose, setPurpose] = useState(savedPurpose)
  const [category, setCategory] = useState(String(line?.expenseCategory ?? ''))
  const [amount, setAmount] = useState(savedAmount)
  const [referenceNo, setReferenceNo] = useState(String(line?.referenceNo ?? ''))
  const [pendingFiles, setPendingFiles] = useState<File[]>([])
  const [problem, setProblem] = useState('')
  const categoryLabel =
    categories.find((option) => option.value === category)?.label || String(line?.accountName || line?.expenseCategory || '')
  const dirty =
    !line ||
    purpose.trim() !== savedPurpose ||
    category !== String(line.expenseCategory ?? '') ||
    Number(amount || 0) !== Number(line.actualSpent ?? 0) ||
    referenceNo.trim() !== String(line.referenceNo ?? '') ||
    pendingFiles.length > 0

  const refresh = () => queryClient.invalidateQueries({ queryKey: [...SETTLEMENT_QUERY_ROOT] })

  const save = useMutation({
    mutationFn: async () => {
      const saved = await saveAdvanceSettlementExpense({
        surrenderNo,
        entryNo,
        expenseCategory: category,
        expenseDescription: purpose.trim(),
        expenseAmount: Number(amount || 0),
        referenceNo: referenceNo.trim(),
      })
      const savedEntryNo = Number(saved.entryNo ?? saved.lineNo) || entryNo
      const label = `[E${savedEntryNo}] ${referenceNo.trim() ? `Receipt ${referenceNo.trim()} · ` : ''}${purpose.trim()}`
      for (const file of pendingFiles) await uploadDocument(request.id, file, label)
      return savedEntryNo
    },
    onSuccess: async () => {
      setPendingFiles([])
      toast.success(`Expense entry ${number} is saved. Business Central recalculated the settlement.`, 'Saved')
      onCreated?.()
      await refresh()
    },
    onError: (error) => setProblem(error instanceof Error ? error.message : 'The expense entry could not be saved.'),
  })

  const remove = useMutation({
    mutationFn: async () => {
      await deleteAdvanceSettlementExpense(surrenderNo, entryNo)
      for (const document of documents) await deleteRequestAttachment(request.id, document.id).catch(() => undefined)
    },
    onSuccess: async () => {
      toast.success(`Expense entry ${number} is removed.`, 'Removed')
      await refresh()
    },
    onError: (error) => setProblem(error instanceof Error ? error.message : 'The expense entry could not be removed.'),
  })

  const submit = () => {
    setProblem('')
    if (purpose.trim().length < 3) return setProblem('Enter the purpose of the expense (at least 3 characters).')
    if (!fromAdvance && !category) return setProblem('Choose the expense category.')
    const value = Number(amount || 0)
    if (!Number.isFinite(value) || value < 0 || (!fromAdvance && value <= 0)) {
      return setProblem(fromAdvance ? 'Enter the amount spent (0 when nothing was spent on it).' : 'Enter an amount above 0.')
    }
    save.mutate()
  }

  const removeEntry = async () => {
    if (!line) {
      onDiscard?.()
      return
    }
    const yes = await confirm({
      title: `Remove expense entry ${number}?`,
      message: 'The expense and its supporting documents are removed from the settlement.',
      confirmLabel: 'Remove',
      tone: 'danger',
    })
    if (yes) remove.mutate()
  }

  const busy = save.isPending || remove.isPending
  const disabled = !editable || busy

  return (
    <article className="rounded-xl border border-slate-200 bg-white px-4 py-4 shadow-sm" aria-label={`Expense entry ${number}`}>
      <div className="flex flex-wrap items-center justify-between gap-2">
        <p className="text-sm font-semibold text-slate-900">
          Expense Entry {number}
          {fromAdvance ? <span className="ml-2 rounded-full bg-sky-50 px-2 py-0.5 text-[11px] font-medium text-sky-800">From the advance</span> : null}
        </p>
        {editable && (!line || line.esspEntry === true) ? (
          <Button type="button" variant="ghost" size="sm" disabled={busy} onClick={() => void removeEntry()} aria-label={`Remove expense entry ${number}`}>
            {remove.isPending ? <Loader2 className="h-4 w-4 animate-spin" /> : <Trash2 className="h-4 w-4" />}
          </Button>
        ) : null}
      </div>

      <div className="mt-3 grid gap-3 md:grid-cols-2">
        <div className="space-y-1.5 md:col-span-2">
          <Label htmlFor={`exp-purpose-${number}`}>Expense Purpose *</Label>
          <Input
            id={`exp-purpose-${number}`}
            value={purpose}
            maxLength={250}
            disabled={disabled}
            placeholder="Enter purpose of expense"
            onChange={(event) => setPurpose(event.target.value)}
          />
        </div>
        <div className="space-y-1.5">
          <Label htmlFor={`exp-category-${number}`}>Expense Category *</Label>
          {fromAdvance || !editable ? (
            <p className="flex h-10 items-center rounded-md border border-slate-200 bg-slate-50 px-3 text-sm text-slate-800">
              {categoryLabel || '—'}
            </p>
          ) : (
            <Select
              id={`exp-category-${number}`}
              value={category}
              options={categories}
              disabled={disabled}
              placeholder="Select expense category"
              onChange={(event) => setCategory(event.target.value)}
            />
          )}
        </div>
        <div className="space-y-1.5">
          <Label htmlFor={`exp-amount-${number}`}>Expense Amount (ETB) *</Label>
          <Input
            id={`exp-amount-${number}`}
            type="number"
            min="0"
            step="0.01"
            inputMode="decimal"
            value={amount}
            disabled={disabled}
            placeholder="0.00"
            onChange={(event) => setAmount(event.target.value)}
          />
          {fromAdvance && line ? (
            <p className="text-[11px] text-slate-500">Advance line {formatAmount(Number(line.issuedAmount ?? 0))}. Enter 0 if nothing was spent on it.</p>
          ) : null}
        </div>
        <div className="space-y-1.5 md:col-span-2">
          <Label htmlFor={`exp-ref-${number}`}>Receipt / Reference Number</Label>
          <Input
            id={`exp-ref-${number}`}
            value={referenceNo}
            maxLength={50}
            disabled={disabled}
            placeholder="Enter receipt number"
            onChange={(event) => setReferenceNo(event.target.value)}
          />
        </div>
      </div>

      <div className="mt-4 border-t border-slate-200 pt-3">
        <p className="text-sm font-semibold text-slate-900">Supporting Documents</p>
        <DocumentList
          request={request}
          documents={documents}
          pending={pendingFiles}
          onRemovePending={(file) => setPendingFiles((current) => current.filter((row) => row !== file))}
          editable={editable}
          onFiles={async (files) => {
            // A saved entry uploads at once; a new entry uploads with its first Save.
            if (!line) {
              setPendingFiles((current) => [...current, ...files])
              return
            }
            const label = `[E${entryNo}] ${line.referenceNo ? `Receipt ${line.referenceNo} · ` : ''}${savedPurpose || categoryLabel}`
            await Promise.all(files.map((file) => uploadDocument(request.id, file, label)))
          }}
          uploadLabel="Upload receipt or supporting document"
        />
      </div>

      {problem ? <p className="mt-3 text-xs font-medium text-rose-600" role="alert">{problem}</p> : null}
      {editable && dirty ? (
        <div className="mt-3 flex flex-wrap justify-end gap-2">
          {!line ? (
            <Button type="button" variant="outline" size="sm" disabled={busy} onClick={() => onDiscard?.()}>
              Cancel
            </Button>
          ) : null}
          <Button type="button" size="sm" disabled={busy} onClick={submit}>
            {save.isPending ? <Loader2 className="mr-1.5 h-4 w-4 animate-spin" /> : <Save className="mr-1.5 h-4 w-4" />}
            {save.isPending ? 'Saving…' : 'Save entry'}
          </Button>
        </div>
      ) : null}
    </article>
  )
}

/** The documents of one expense entry (or of the settlement), with an upload area while it is a draft. */
export function DocumentList({
  request,
  documents,
  pending = [],
  onRemovePending,
  editable,
  onFiles,
  uploadLabel,
}: {
  request: PortalRequest
  documents: Attachment[]
  pending?: File[]
  onRemovePending?: (file: File) => void
  editable: boolean
  onFiles: (files: File[]) => Promise<unknown>
  uploadLabel: string
}) {
  const toast = useToast()
  const confirm = useConfirm()
  const queryClient = useQueryClient()
  const input = useRef<HTMLInputElement>(null)
  const [busy, setBusy] = useState<string | null>(null)
  const [dragOver, setDragOver] = useState(false)

  const accept = async (list: FileList | null) => {
    if (!list?.length) return
    const files: File[] = []
    for (const file of Array.from(list)) {
      const extension = file.name.split('.').pop()?.toLowerCase() ?? ''
      if (!ALLOWED_EXTENSIONS.has(extension)) {
        toast.error(`${file.name}: attach PDF, DOC, DOCX, JPG or PNG.`, 'File type not accepted')
        continue
      }
      if (file.size > MAX_FILE_BYTES) {
        toast.error(`${file.name} is ${formatFileSize(file.size)}. Each document can be up to 10 MB.`, 'File too large')
        continue
      }
      files.push(file)
    }
    if (input.current) input.current.value = ''
    if (!files.length) return
    setBusy('upload')
    try {
      await onFiles(files)
      await queryClient.invalidateQueries({ queryKey: [...SETTLEMENT_QUERY_ROOT] })
    } catch (error) {
      toast.error(error instanceof Error ? error.message : 'The document could not be uploaded.', 'Upload failed')
    } finally {
      setBusy(null)
    }
  }

  const removeDocument = async (document: Attachment) => {
    const yes = await confirm({
      title: `Remove ${document.fileName}?`,
      message: 'The document is removed from the settlement in Business Central.',
      confirmLabel: 'Remove',
      tone: 'danger',
    })
    if (!yes) return
    setBusy(document.id)
    try {
      await deleteRequestAttachment(request.id, document.id)
      await queryClient.invalidateQueries({ queryKey: [...SETTLEMENT_QUERY_ROOT] })
    } catch (error) {
      toast.error(error instanceof Error ? error.message : 'The document could not be removed.', 'Not removed')
    } finally {
      setBusy(null)
    }
  }

  return (
    <div className="mt-2 space-y-2">
      {documents.length || pending.length ? (
        <ul className="space-y-1.5">
          {documents.map((document) => {
            const { Icon, tone } = attachmentVisual(document.fileName)
            return (
              <li key={document.id} className="flex items-center gap-2 rounded-lg border border-slate-200 px-2.5 py-1.5">
                <span className={cn('flex h-7 w-7 shrink-0 items-center justify-center rounded-md ring-1', tone)} aria-hidden="true">
                  <Icon className="h-3.5 w-3.5" />
                </span>
                <button
                  type="button"
                  className="min-w-0 flex-1 truncate text-left text-sm text-[var(--portal-navy)] hover:underline"
                  title={attachmentNote(document) || document.fileName}
                  onClick={() => void downloadRequestAttachment(request.id, document)}
                >
                  {document.fileName}
                </button>
                {editable ? (
                  <Button
                    type="button"
                    variant="ghost"
                    size="sm"
                    disabled={busy === document.id}
                    aria-label={`Remove ${document.fileName}`}
                    onClick={() => void removeDocument(document)}
                  >
                    {busy === document.id ? <Loader2 className="h-4 w-4 animate-spin" /> : <Trash2 className="h-4 w-4" />}
                  </Button>
                ) : null}
              </li>
            )
          })}
          {pending.map((file) => (
            <li key={`${file.name}-${file.size}`} className="flex items-center gap-2 rounded-lg border border-dashed border-slate-300 px-2.5 py-1.5 text-sm">
              <span className="min-w-0 flex-1 truncate text-slate-700">{file.name}</span>
              <span className="text-[11px] text-slate-500">uploads with Save entry</span>
              <Button type="button" variant="ghost" size="sm" aria-label={`Remove ${file.name}`} onClick={() => onRemovePending?.(file)}>
                <Trash2 className="h-4 w-4" />
              </Button>
            </li>
          ))}
        </ul>
      ) : !editable ? (
        <p className="text-xs text-slate-500">No documents.</p>
      ) : null}
      {editable ? (
        <>
          <input
            ref={input}
            type="file"
            multiple
            accept=".pdf,.doc,.docx,.jpg,.jpeg,.png"
            className="sr-only"
            tabIndex={-1}
            aria-hidden="true"
            onChange={(event) => void accept(event.target.files)}
          />
          <button
            type="button"
            disabled={busy === 'upload'}
            onClick={() => input.current?.click()}
            onDragOver={(event) => {
              event.preventDefault()
              if (!dragOver) setDragOver(true)
            }}
            onDragLeave={() => setDragOver(false)}
            onDrop={(event) => {
              event.preventDefault()
              setDragOver(false)
              void accept(event.dataTransfer.files)
            }}
            className={cn(
              'flex w-full flex-col items-center gap-1 rounded-lg border border-dashed px-3 py-4 text-center transition',
              dragOver ? 'border-[var(--portal-navy)] bg-teal-50' : 'border-slate-300 bg-slate-50/60 hover:bg-slate-50',
            )}
          >
            {busy === 'upload' ? <Loader2 className="h-5 w-5 animate-spin text-[var(--portal-navy)]" /> : <FileUp className="h-5 w-5 text-[var(--portal-navy)]" />}
            <span className="text-sm font-medium text-slate-900">{busy === 'upload' ? 'Uploading…' : uploadLabel}</span>
            <span className="text-[11px] text-slate-500">PDF, DOC, DOCX, JPG or PNG · up to 10 MB</span>
          </button>
        </>
      ) : null}
    </div>
  )
}
