import { useRef, useState } from 'react'
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { Download, FileText, FileUp, ShieldCheck, Trash2 } from 'lucide-react'
import {
  deletePolicyDocument,
  downloadPolicyDocument,
  listPolicyDocuments,
  uploadPolicyDocument,
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
  const [downloadingId, setDownloadingId] = useState('')

  const query = useQuery({ queryKey: ['downloads', 'documents'], queryFn: listPolicyDocuments })
  const documents = query.data?.rows ?? []
  const canManage = permissions.isHR && query.data?.canManage === true

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
    if (downloadingId) return
    setDownloadingId(document.id)
    try {
      await downloadPolicyDocument(document)
    } catch (error) {
      toast.error(error instanceof Error ? error.message : 'The document could not be downloaded.', 'Download failed')
    } finally {
      setDownloadingId('')
    }
  }

  return (
    <PageWrapper
      title="HR Policies & Forms"
      description="Published HR policies, forms and guidelines available to all employees."
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
                disabled={Boolean(downloadingId)}
                onClick={() => void downloadDocument(document)}
                aria-label={`Download ${document.title}`}
              >
                <Download className="h-4 w-4" />
                <span className="hidden sm:inline">
                  {downloadingId === document.id ? 'Downloading…' : 'Download'}
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
    </PageWrapper>
  )
}
