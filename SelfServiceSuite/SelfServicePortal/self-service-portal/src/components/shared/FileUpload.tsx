import { FileUp, Paperclip } from 'lucide-react'
import { useCallback, useRef, useState } from 'react'
import type { Attachment } from '@/types/erp.types'
import { cn } from '@/lib/utils'
import { AttachmentFileCard, formatFileSize } from './attachmentUi'

interface FileUploadProps {
  files: Attachment[]
  onChange: (files: Attachment[]) => void
}

const ALLOWED = new Set(['pdf', 'doc', 'docx', 'jpeg', 'jpg', 'png'])

export function FileUpload({ files, onChange }: FileUploadProps) {
  const [error, setError] = useState('')
  const [isDragging, setIsDragging] = useState(false)
  const inputRef = useRef<HTMLInputElement>(null)

  const addFiles = useCallback(
    async (fileList: FileList | null) => {
      if (!fileList) return
      setError('')
      const selected = Array.from(fileList)
      const invalid = selected.find((file) => !ALLOWED.has(file.name.split('.').pop()?.toLowerCase() ?? ''))
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
      const uploaded = await Promise.all(
        selected.map(
          (file) =>
            new Promise<Attachment>((resolve, reject) => {
              const reader = new FileReader()
              reader.onerror = () => reject(new Error(`Could not read ${file.name}`))
              reader.onload = () =>
                resolve({
                  id: crypto.randomUUID(),
                  fileName: file.name,
                  fileType: file.type || 'application/octet-stream',
                  size: file.size,
                  progress: 100,
                  uploadedAt: new Date().toISOString(),
                  description: file.name.replace(/\.[^.]+$/, ''),
                  contentBase64: String(reader.result ?? '').split(',')[1] ?? '',
                })
              reader.readAsDataURL(file)
            }),
        ),
      ).catch((reason: unknown) => {
        setError(reason instanceof Error ? reason.message : 'Could not read the selected files.')
        return []
      })
      if (uploaded.length) onChange([...files, ...uploaded])
    },
    [files, onChange],
  )

  const removeFile = (id: string) => onChange(files.filter((file) => file.id !== id))

  return (
    <section className="space-y-3">
      <div className="mb-1 flex items-center justify-between gap-2">
        <p className="text-sm font-semibold text-[var(--portal-navy)]">Attachments</p>
        {files.length > 0 ? (
          <span className="inline-flex items-center gap-1 rounded-full bg-slate-100 px-2.5 py-0.5 text-xs font-semibold text-slate-600">
            <Paperclip className="h-3 w-3" />
            {files.length}
          </span>
        ) : null}
      </div>

      <div
        role="button"
        tabIndex={0}
        onKeyDown={(event) => {
          if (event.key === 'Enter' || event.key === ' ') {
            event.preventDefault()
            inputRef.current?.click()
          }
        }}
        onDragEnter={(event) => {
          event.preventDefault()
          setIsDragging(true)
        }}
        onDragOver={(event) => {
          event.preventDefault()
          setIsDragging(true)
        }}
        onDragLeave={(event) => {
          event.preventDefault()
          setIsDragging(false)
        }}
        onDrop={(event) => {
          event.preventDefault()
          setIsDragging(false)
          void addFiles(event.dataTransfer.files)
        }}
        onClick={() => inputRef.current?.click()}
        className={cn(
          'cursor-pointer overflow-hidden rounded-xl border-2 border-dashed bg-gradient-to-br from-slate-50 to-white px-4 py-8 text-center shadow-inner transition-all duration-200',
          isDragging
            ? 'border-emerald-500 bg-emerald-50/80'
            : 'border-slate-300 hover:border-emerald-400/70 hover:bg-emerald-50/30',
        )}
      >
        <input
          ref={inputRef}
          className="sr-only"
          type="file"
          multiple
          accept=".pdf,.doc,.docx,.jpeg,.jpg,.png"
          onChange={(event) => void addFiles(event.target.files)}
        />
        <FileUp className="mx-auto h-8 w-8 text-emerald-700" />
        <p className="mt-2 text-sm font-medium text-slate-800">Drop files here or click to browse</p>
        <p className="mt-1 text-xs text-slate-500">PDF, DOC, DOCX, JPG or PNG · Max 10 MB each · 20 MB total</p>
      </div>

      {error ? <p className="text-sm text-red-600">{error}</p> : null}

      {files.length > 0 ? (
        <div className="portal-attachment-grid grid gap-3 sm:grid-cols-2">
          {files.map((file, index) => (
            <div
              key={file.id}
              className="portal-attachment-enter"
              style={{ animationDelay: `${index * 60}ms` }}
            >
              <AttachmentFileCard
                title={file.description || file.fileName}
                subtitle={file.fileName}
                meta={formatFileSize(file.size)}
                state="pending"
                onRemove={() => removeFile(file.id)}
              />
            </div>
          ))}
        </div>
      ) : (
        <div className="portal-attachment-empty flex flex-col items-center justify-center rounded-xl border border-dashed border-slate-200 bg-slate-50/80 px-4 py-8 text-center">
          <div className="mb-2 flex h-10 w-10 items-center justify-center rounded-full bg-white shadow-sm ring-1 ring-slate-200">
            <Paperclip className="h-4 w-4 text-slate-400" />
          </div>
          <p className="text-sm text-slate-500">Files will be uploaded when you submit the request</p>
        </div>
      )}
    </section>
  )
}
