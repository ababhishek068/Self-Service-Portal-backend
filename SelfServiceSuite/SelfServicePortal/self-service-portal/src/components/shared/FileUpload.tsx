import { CheckCircle2, FileUp, Loader2, Paperclip, X } from 'lucide-react'
import { useRef, useState } from 'react'
import { Button } from '@/components/ui/button'
import type { Attachment, AttachmentStatus } from '@/types/erp.types'

interface FileUploadProps {
  files: Attachment[]
  onChange: (files: Attachment[]) => void
  readyHint?: string
}

function createAttachmentId() {
  if (typeof crypto !== 'undefined' && typeof crypto.randomUUID === 'function') {
    try {
      return crypto.randomUUID()
    } catch {
      /* fall through — randomUUID is unavailable on plain HTTP hosts */
    }
  }
  return `att-${Date.now()}-${Math.random().toString(36).slice(2, 10)}`
}

function statusLabel(status: AttachmentStatus | undefined, progress: number) {
  if (status === 'reading') return progress < 100 ? `Reading… ${progress}%` : 'Processing…'
  if (status === 'uploading') return progress < 100 ? `Uploading… ${progress}%` : 'Finishing…'
  if (status === 'uploaded') return 'Uploaded'
  if (status === 'error') return 'Failed'
  return 'Ready to upload'
}

function statusTone(status: AttachmentStatus | undefined) {
  if (status === 'uploaded') return 'text-emerald-700 bg-emerald-50'
  if (status === 'uploading' || status === 'reading') return 'text-blue-700 bg-blue-50'
  if (status === 'error') return 'text-red-700 bg-red-50'
  return 'text-slate-600 bg-slate-100'
}

export function UploadProgressBar({
  label,
  percent,
  tone = 'emerald',
}: {
  label: string
  percent: number
  tone?: 'emerald' | 'blue'
}) {
  const barTone = tone === 'blue' ? 'bg-blue-600' : 'bg-emerald-600'
  return (
    <div className="space-y-1.5">
      <div className="flex items-center justify-between gap-2 text-xs">
        <span className="truncate font-medium text-slate-700">{label}</span>
        <span className="shrink-0 text-slate-500">{Math.min(100, Math.max(0, percent))}%</span>
      </div>
      <div className="h-2 overflow-hidden rounded-full bg-slate-100">
        <div
          className={`h-full rounded-full transition-all duration-200 ${barTone}`}
          style={{ width: `${Math.min(100, Math.max(0, percent))}%` }}
        />
      </div>
    </div>
  )
}

export function FileUpload({ files, onChange, readyHint }: FileUploadProps) {
  const [error, setError] = useState('')
  const inputRef = useRef<HTMLInputElement>(null)
  const readyCount = files.filter((file) => file.status === 'ready' || (!file.status && file.progress === 100)).length
  const busy = files.some((file) => file.status === 'reading' || file.status === 'uploading')

  const addFiles = async (fileList: FileList | null) => {
    if (!fileList) return
    setError('')
    const selected = Array.from(fileList)
    const allowed = new Set(['pdf', 'doc', 'docx', 'jpeg', 'jpg', 'png'])
    const invalid = selected.find((file) => !allowed.has(file.name.split('.').pop()?.toLowerCase() ?? ''))
    if (invalid) {
      setError(`${invalid.name} is not an allowed file type.`)
      return
    }
    const oversized = selected.find((file) => file.size > 10_000_000)
    if (oversized) {
      setError(`${oversized.name} exceeds the 10 MB limit.`)
      return
    }
    const totalSize = [...files, ...selected].reduce((total, file) => total + file.size, 0)
    if (totalSize > 20_000_000) {
      setError('Combined attachments cannot exceed 20 MB.')
      return
    }

    const placeholders: Attachment[] = selected.map((file) => ({
      id: createAttachmentId(),
      fileName: file.name,
      fileType: file.type || 'application/octet-stream',
      size: file.size,
      progress: 0,
      uploadedAt: new Date().toISOString(),
      description: file.name.replace(/\.[^.]+$/, ''),
      status: 'reading',
    }))
    let working = [...files, ...placeholders]
    onChange(working)

    const updateFile = (id: string, patch: Partial<Attachment>) => {
      working = working.map((file) => (file.id === id ? { ...file, ...patch } : file))
      onChange(working)
    }

    for (let index = 0; index < selected.length; index += 1) {
      const file = selected[index]!
      const placeholder = placeholders[index]!
      try {
        const attachment = await new Promise<Attachment>((resolve, reject) => {
          const reader = new FileReader()
          reader.onerror = () => reject(new Error(`Could not read ${file.name}`))
          reader.onprogress = (event) => {
            if (!event.lengthComputable) return
            const progress = Math.round((event.loaded / event.total) * 100)
            updateFile(placeholder.id, { progress, status: 'reading' })
          }
          reader.onload = () =>
            resolve({
              ...placeholder,
              progress: 100,
              status: 'ready',
              contentBase64: String(reader.result ?? '').split(',')[1] ?? '',
            })
          reader.readAsDataURL(file)
        })
        updateFile(placeholder.id, attachment)
      } catch (reason: unknown) {
        const message = reason instanceof Error ? reason.message : `Could not read ${file.name}`
        updateFile(placeholder.id, { status: 'error', errorMessage: message, progress: 0 })
        setError(message)
      }
    }

    if (inputRef.current) inputRef.current.value = ''
  }

  const removeFile = (id: string) => onChange(files.filter((file) => file.id !== id))

  return (
    <div className="space-y-3">
      <label className="flex cursor-pointer flex-col items-center justify-center rounded-lg border border-dashed border-slate-300 bg-slate-50 px-4 py-6 text-center transition hover:border-emerald-500 hover:bg-emerald-50">
        <FileUp className="h-6 w-6 text-emerald-700" />
        <span className="mt-2 text-sm font-medium text-slate-800">Upload supporting files</span>
        <span className="text-xs text-slate-500">PDF, DOC, DOCX, JPG or PNG. Maximum 10 MB each.</span>
        <input
          ref={inputRef}
          className="sr-only"
          type="file"
          multiple
          accept=".pdf,.doc,.docx,.jpeg,.jpg,.png"
          onChange={(event) => void addFiles(event.target.files)}
        />
      </label>

      {files.length > 0 ? (
        <div className="rounded-md border border-emerald-200 bg-emerald-50 px-3 py-2 text-sm text-emerald-800">
          {busy
            ? 'Preparing selected files…'
            : readyHint ??
              `${readyCount || files.length} file${files.length === 1 ? '' : 's'} selected — click Upload attachments to save.`}
        </div>
      ) : (
        <p className="text-xs text-slate-500">No files selected yet.</p>
      )}

      {error ? <p className="text-sm text-red-600">{error}</p> : null}

      {files.length > 0 ? (
        <div className="space-y-2">
          {files.map((file) => {
            const status = file.status ?? (file.progress === 100 ? 'ready' : 'reading')
            const isBusy = status === 'reading' || status === 'uploading'
            return (
              <div key={file.id} className="rounded-md border border-slate-200 bg-white p-3">
                <div className="flex items-start justify-between gap-3">
                  <div className="flex min-w-0 items-start gap-2">
                    {status === 'uploaded' ? (
                      <CheckCircle2 className="mt-0.5 h-4 w-4 shrink-0 text-emerald-600" />
                    ) : isBusy ? (
                      <Loader2 className="mt-0.5 h-4 w-4 shrink-0 animate-spin text-blue-600" />
                    ) : (
                      <Paperclip className="mt-0.5 h-4 w-4 shrink-0 text-slate-500" />
                    )}
                    <div className="min-w-0">
                      <p className="truncate text-sm font-medium text-slate-800">{file.fileName}</p>
                      <p className="text-xs text-slate-500">{(file.size / 1024).toFixed(1)} KB</p>
                      <span
                        className={`mt-1 inline-flex rounded-full px-2 py-0.5 text-[11px] font-medium ${statusTone(status)}`}
                      >
                        {statusLabel(status, file.progress)}
                      </span>
                    </div>
                  </div>
                  {!isBusy && status !== 'uploaded' ? (
                    <Button
                      type="button"
                      variant="ghost"
                      size="icon"
                      aria-label="Remove file"
                      onClick={() => removeFile(file.id)}
                    >
                      <X className="h-4 w-4" />
                    </Button>
                  ) : null}
                </div>
                {isBusy || status === 'ready' ? (
                  <div className="mt-3">
                    <UploadProgressBar
                      label={file.fileName}
                      percent={status === 'ready' ? 100 : file.progress}
                      tone={status === 'uploading' ? 'blue' : status === 'reading' ? 'blue' : 'emerald'}
                    />
                  </div>
                ) : null}
                {file.errorMessage ? (
                  <p className="mt-2 text-xs text-red-600">{file.errorMessage}</p>
                ) : null}
              </div>
            )
          })}
        </div>
      ) : null}
    </div>
  )
}
