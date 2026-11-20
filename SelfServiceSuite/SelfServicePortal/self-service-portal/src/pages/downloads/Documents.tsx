import { useRef, useState } from 'react'
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { Download, Eye, FileText, FileUp, ShieldCheck, Trash2 } from 'lucide-react'
import {
  deletePolicyDocument,
  downloadPolicyDocument,
  fetchPolicyAcknowledgment,
  listPolicyDocuments,
  submitPolicyAcknowledgment,
  uploadPolicyDocument,
  viewPolicyDocument,
  type PolicyDocument,
} from '@/api/endpoints/documents'
import { PageWrapper } from '@/components/layout/PageWrapper'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Select } from '@/components/ui/select'
import { useConfirm } from '@/components/feedback/ConfirmProvider'
import { useToast } from '@/components/feedback/ToastProvider'
import { usePermissions } from '@/hooks/usePermissions'

const MAX_DOCUMENT_BYTES = 10_000_000
const ALLOWED_EXTENSIONS = new Set(['pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx'])
const CATEGORY_OPTIONS = [
  { label: 'Policy Document', value: 'Policy Document' },
  { label: 'Contract', value: 'Contract' },
  { label: 'PIN', value: 'PIN' },
  { label: 'Exit Form', value: 'Exit Form' },
]

function readFileBase64(file: File): Promise<string> {
  return new Promise((resolve, reject) => {
    const reader = new FileReader()
    reader.onerror = () => reject(new Error(`Could not read ${file.name}`))
    reader.onload = () => {
      const content = String(reader.result ?? '').split(',')[1] ?? ''
      if (!content) reject(new Error(`Could not encode ${file.name}`))
      else resolve(content)
    }
    reader.readAsDataURL(file)
  })
}

function fileValidationMessage(file: File) {
  const extension = file.name.split('.').pop()?.toLowerCase() ?? ''
  if (!ALLOWED_EXTENSIONS.has(extension)) {
    return 'Only PDF, Word, Excel, and PowerPoint documents are allowed.'
  }
  if (file.size <= 0) return 'The selected document is empty.'
  if (file.size > MAX_DOCUMENT_BYTES) return 'The selected document exceeds the 10 MB limit.'
  return ''
}

export function Documents() {
  const permissions = usePermissions()
  const confirm = useConfirm()
  const toast = useToast()
  const queryClient = useQueryClient()
  const fileInput = useRef<HTMLInputElement>(null)
  const [title, setTitle] = useState('')
  const [category, setCategory] = useState('Policy Document')
  const [published, setPublished] = useState(true)
  const [file, setFile] = useState<File | null>(null)
  const [busyId, setBusyId] = useState('')
  const [checks, setChecks] = useState<Record<string, boolean>>({})

  const query = useQuery({ queryKey: ['downloads', 'documents'], queryFn: listPolicyDocuments })
  const acknowledgmentQuery = useQuery({
    queryKey: ['downloads', 'acknowledgment'],
    queryFn: fetchPolicyAcknowledgment,
  })
  const documents = query.data?.rows ?? []
  const canManage = permissions.isHR && query.data?.canManage === true
  const acknowledgment = acknowledgmentQuery.data
  const acknowledged = acknowledgment?.status === 'Acknowledged'
  const commitmentIds = (acknowledgment?.commitments ?? []).map((row) => row.id)
  const allChecked = commitmentIds.length > 0 && commitmentIds.every((id) => checks[id] === true)

  const uploadMutation = useMutation({
    mutationFn: async () => {
      const cleanTitle = title.trim()
      if (!cleanTitle) throw new Error('Enter a document title.')
      if (cleanTitle.length > 150) throw new Error('Document title cannot exceed 150 characters.')
      if (!file) throw new Error('Choose a document to upload.')
      const fileError = fileValidationMessage(file)
      if (fileError) throw new Error(fileError)
      const contentBase64 = await readFileBase64(file)
      return uploadPolicyDocument({
        title: cleanTitle,
        category,
        published,
        fileName: file.name,
        contentBase64,
      })
    },
    onSuccess: async () => {
      await queryClient.invalidateQueries({ queryKey: ['downloads', 'documents'] })
      setTitle('')
      setCategory('Policy Document')
      setPublished(true)
      setFile(null)
      if (fileInput.current) fileInput.current.value = ''
      toast.success('The HR document is now stored in Business Central.', 'Upload complete')
    },
    onError: (error) => {
      toast.error(error instanceof Error ? error.message : 'The document could not be uploaded.', 'Upload failed')
    },
  })

  const deleteMutation = useMutation({
    mutationFn: deletePolicyDocument,
    onSuccess: async () => {
      await queryClient.invalidateQueries({ queryKey: ['downloads', 'documents'] })
      toast.success('The HR document was permanently deleted.', 'Document deleted')
    },
    onError: (error) => {
      toast.error(error instanceof Error ? error.message : 'The document could not be deleted.', 'Delete failed')
    },
  })

  const acknowledgmentMutation = useMutation({
    mutationFn: () => submitPolicyAcknowledgment(checks),
    onSuccess: async () => {
      await queryClient.invalidateQueries({ queryKey: ['downloads', 'acknowledgment'] })
      toast.success('Your policy acknowledgment was recorded.', 'Acknowledgment submitted')
    },
    onError: (error) => {
      toast.error(error instanceof Error ? error.message : 'Acknowledgment could not be saved.', 'Submit failed')
    },
  })

  const submitUpload = async () => {
    if (!canManage || uploadMutation.isPending) return
    if (!title.trim()) {
      toast.error('Enter a clear document title.', 'Title required')
      return
    }
    if (!file) {
      toast.error('Choose a document to upload.', 'File required')
      return
    }
    const fileError = fileValidationMessage(file)
    if (fileError) {
      toast.error(fileError, 'Invalid document')
      return
    }
    const approved = await confirm({
      title: 'Upload HR document',
      message: published
        ? 'Upload and publish this document for all portal employees?'
        : 'Upload this document as an unpublished HR draft?',
      confirmLabel: published ? 'Upload & Publish' : 'Upload Draft',
    })
    if (approved) uploadMutation.mutate()
  }

  const removeDocument = async (document: PolicyDocument) => {
    if (!canManage || deleteMutation.isPending) return
    const approved = await confirm({
      title: 'Delete HR document',
      message: `Permanently delete “${document.title}” from Business Central? This cannot be undone.`,
      confirmLabel: 'Delete permanently',
      tone: 'danger',
    })
    if (approved) deleteMutation.mutate(document.id)
  }

  const downloadDocument = async (document: PolicyDocument) => {
    if (busyId) return
    setBusyId(`dl-${document.id}`)
    try {
      await downloadPolicyDocument(document)
    } catch (error) {
      toast.error(error instanceof Error ? error.message : 'The document could not be downloaded.', 'Download failed')
    } finally {
      setBusyId('')
    }
  }

  const viewDocument = async (document: PolicyDocument) => {
    if (busyId) return
    setBusyId(`view-${document.id}`)
    try {
      await viewPolicyDocument(document)
    } catch (error) {
      toast.error(error instanceof Error ? error.message : 'The document could not be opened.', 'View failed')
    } finally {
      setBusyId('')
    }
  }

  return (
    <PageWrapper
      title="HR Policies & Forms"
      description="Published HR policies, forms and guidelines available to all employees. View online or download; then submit your acknowledgment."
    >
      {canManage ? (
        <section className="portal-panel mb-6 overflow-visible p-4 sm:p-5" aria-labelledby="hr-document-upload-title">
          <div className="flex items-start gap-3">
            <span className="portal-card-icon shrink-0">
              <ShieldCheck className="h-5 w-5 text-[var(--portal-navy)]" />
            </span>
            <div>
              <h2 id="hr-document-upload-title" className="text-sm font-semibold text-[var(--portal-navy)]">
                HR document administration
              </h2>
              <p className="mt-1 text-xs text-slate-500">
                Only authorized HR employees can upload or remove documents. Files are stored in Business Central.
              </p>
            </div>
          </div>

          <div className="mt-5 grid gap-4 lg:grid-cols-[minmax(0,1.3fr)_minmax(0,0.8fr)_minmax(0,1fr)]">
            <div className="space-y-2">
              <Label htmlFor="hr-policy-title">Document title</Label>
              <Input
                id="hr-policy-title"
                value={title}
                maxLength={150}
                onChange={(event) => setTitle(event.target.value)}
                placeholder="e.g. Annual Leave Policy 2026"
                disabled={uploadMutation.isPending}
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="hr-policy-category">Category</Label>
              <Select
                id="hr-policy-category"
                value={category}
                onChange={(event) => setCategory(event.target.value)}
                options={CATEGORY_OPTIONS}
                disabled={uploadMutation.isPending}
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="hr-policy-file">Document file</Label>
              <Input
                ref={fileInput}
                id="hr-policy-file"
                type="file"
                accept=".pdf,.doc,.docx,.xls,.xlsx,.ppt,.pptx"
                onChange={(event) => setFile(event.target.files?.[0] ?? null)}
                disabled={uploadMutation.isPending}
              />
              <p className="text-[11px] text-slate-500">PDF or Microsoft Office, maximum 10 MB.</p>
            </div>
          </div>

          <div className="mt-4 flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
            <label className="inline-flex cursor-pointer items-center gap-2 text-sm text-slate-700">
              <input
                type="checkbox"
                checked={published}
                onChange={(event) => setPublished(event.target.checked)}
                disabled={uploadMutation.isPending}
                className="h-4 w-4 rounded border-slate-300 accent-[var(--portal-navy)]"
              />
              Publish immediately for all employees
            </label>
            <Button type="button" onClick={() => void submitUpload()} disabled={uploadMutation.isPending}>
              <FileUp className="h-4 w-4" />
              {uploadMutation.isPending ? 'Uploading…' : published ? 'Upload & Publish' : 'Upload Draft'}
            </Button>
          </div>
        </section>
      ) : null}

      {query.isLoading ? <div className="portal-panel p-4 text-sm text-slate-600">Loading documents…</div> : null}
      {query.isError ? (
        <div className="portal-panel border-red-200 p-4 text-sm text-red-700">
          HR documents could not be loaded. Confirm the Business Central HR Downloads web service is available.
        </div>
      ) : null}

      <div className="grid gap-3 sm:grid-cols-2 xl:grid-cols-3">
        {documents.map((document) => (
          <article key={document.id} className="portal-card flex items-center gap-3 p-4">
            <div className="portal-card-icon">
              <FileText className="h-6 w-6 text-[var(--portal-navy)]" />
            </div>
            <div className="min-w-0 flex-1">
              <p className="truncate text-sm font-semibold text-[var(--portal-navy)]" title={document.title}>
                {document.title}
              </p>
              <p className="mt-0.5 truncate text-xs text-slate-500">
                {document.category}{document.updated ? ` • Updated ${document.updated}` : ''}
              </p>
              {canManage ? (
                <span className={`mt-2 inline-flex rounded-full px-2 py-0.5 text-[10px] font-semibold ${
                  document.published
                    ? 'bg-emerald-50 text-emerald-700 ring-1 ring-emerald-200'
                    : 'bg-amber-50 text-amber-700 ring-1 ring-amber-200'
                }`}>
                  {document.published ? 'Published' : 'HR draft'}
                </span>
              ) : null}
            </div>
            <div className="flex shrink-0 items-center gap-1.5">
              <Button
                type="button"
                variant="outline"
                size="sm"
                className="rounded-full"
                disabled={Boolean(busyId)}
                onClick={() => void viewDocument(document)}
                aria-label={`View ${document.title}`}
              >
                <Eye className="h-4 w-4" />
                <span className="hidden sm:inline">
                  {busyId === `view-${document.id}` ? 'Opening…' : 'View'}
                </span>
              </Button>
              <Button
                type="button"
                variant="outline"
                size="sm"
                className="rounded-full"
                disabled={Boolean(busyId)}
                onClick={() => void downloadDocument(document)}
                aria-label={`Download ${document.title}`}
              >
                <Download className="h-4 w-4" />
                <span className="hidden sm:inline">
                  {busyId === `dl-${document.id}` ? 'Downloading…' : 'Download'}
                </span>
              </Button>
              {canManage ? (
                <Button
                  type="button"
                  variant="outline"
                  size="sm"
                  className="rounded-full border-red-200 text-red-600 hover:bg-red-50 hover:text-red-700"
                  disabled={deleteMutation.isPending}
                  onClick={() => void removeDocument(document)}
                  aria-label={`Delete ${document.title}`}
                >
                  <Trash2 className="h-4 w-4" />
                </Button>
              ) : null}
            </div>
          </article>
        ))}
      </div>

      {!query.isLoading && !query.isError && documents.length === 0 ? (
        <div className="portal-panel p-4 text-sm text-slate-600">
          No published HR policies or forms are available yet.
        </div>
      ) : null}

      <section className="portal-panel mt-6 p-4 sm:p-5" aria-labelledby="policy-ack-title">
        <div className="flex flex-wrap items-start justify-between gap-3">
          <div>
            <h2 id="policy-ack-title" className="text-sm font-semibold text-[var(--portal-navy)]">
              Employee Policy Acknowledgment
            </h2>
            <p className="mt-1 text-xs text-slate-500">
              Please read each published policy carefully and confirm your acknowledgment.
            </p>
          </div>
          <span
            className={`inline-flex rounded-full px-2.5 py-0.5 text-[11px] font-semibold ${
              acknowledged
                ? 'bg-emerald-50 text-emerald-700 ring-1 ring-emerald-200'
                : 'bg-amber-50 text-amber-800 ring-1 ring-amber-200'
            }`}
          >
            {acknowledged ? 'Acknowledged' : 'Pending'}
          </span>
        </div>

        {acknowledgmentQuery.isLoading ? (
          <p className="mt-4 text-sm text-slate-600">Loading acknowledgment…</p>
        ) : acknowledgmentQuery.isError ? (
          <p className="mt-4 text-sm text-red-700">Acknowledgment status could not be loaded.</p>
        ) : acknowledged ? (
          <p className="mt-4 text-sm text-slate-700">
            You acknowledged the published HR policies
            {acknowledgment?.acknowledgedAt
              ? ` on ${new Date(acknowledgment.acknowledgedAt).toLocaleString()}`
              : ''}
            .
          </p>
        ) : (
          <>
            <p className="mt-4 text-xs font-medium uppercase tracking-wide text-slate-500">
              Policy acknowledgment status
            </p>
            <ul className="mt-3 space-y-3">
              {(acknowledgment?.commitments ?? []).map((item) => (
                <li key={item.id}>
                  <label className="flex cursor-pointer items-start gap-3 text-sm text-slate-800">
                    <input
                      type="checkbox"
                      checked={checks[item.id] === true}
                      onChange={(event) =>
                        setChecks((current) => ({ ...current, [item.id]: event.target.checked }))
                      }
                      className="mt-0.5 h-4 w-4 rounded-full border-slate-300 accent-[var(--portal-navy)]"
                    />
                    <span>{item.label}</span>
                  </label>
                </li>
              ))}
            </ul>
            <div className="mt-5">
              <Button
                type="button"
                disabled={!allChecked || acknowledgmentMutation.isPending}
                onClick={() => acknowledgmentMutation.mutate()}
              >
                {acknowledgmentMutation.isPending ? 'Submitting…' : 'Submit Policy Acknowledgment'}
              </Button>
              <p className="mt-2 text-[11px] text-slate-500">
                Submission is enabled only after all required confirmations are checked.
              </p>
            </div>
          </>
        )}
      </section>
    </PageWrapper>
  )
}
