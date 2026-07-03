import { FileUp, Paperclip, Plus } from 'lucide-react'
import { useCallback, useRef, useState } from 'react'
import type { Attachment } from '@/types/erp.types'
import { cn, createLocalId } from '@/lib/utils'
import { AttachmentFileCard, formatFileSize } from './attachmentUi'

export type FileUploadItemState = 'pending' | 'uploading' | 'success' | 'error'

interface FileUploadProps {
  files: Attachment[]
  onChange: (files: Attachment[]) => void
  emptyHint?: string
  hideHeader?: boolean
  /** Hide the dashed empty placeholder when there are no files yet. */
  hideEmptyState?: boolean
  /** Shrink the drop zone after the first file is selected. */
  compactWhenHasFiles?: boolean
  fileStates?: Record<string, FileUploadItemState>
  fileProgress?: Record<string, number>
}

const ALLOWED = new Set(['pdf', 'doc', 'docx', 'jpeg', 'jpg', 'png'])

export function FileUpload({
  files,
  onChange,
  emptyHint,
  hideHeader = false,
  hideEmptyState = false,
  compactWhenHasFiles = true,
  fileStates = {},
  fileProgress = {},
}: FileUploadProps) {
  const [error, setError] = useState('')
  const [isDragging, setIsDragging] = useState(false)
  const inputRef = useRef<HTMLInputElement>(null)

  const addFiles = useCallback(
    async (fileList: FileList | null) => {
      if (!fileList || fileList.length === 0) return
      setError('')
      const selected = Array.from(fileList)
      const invalid = selected.find((file) => !ALLOWED.has(file.name.split('.').pop()?.toLowerCase() ?? ''))
      if (invalid) {
        setError(`${invalid.name} is not an allowed file type. Use PDF, DOC, DOCX, JPG, or PNG.`)
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

      const uploaded: Attachment[] = []
      for (const file of selected) {
        try {
          const contentBase64 = await readFileAsBase64(file)
          uploaded.push({
            id: createLocalId('att'),
            fileName: file.name,
            fileType: file.type || 'application/octet-stream',
            size: file.size,
            progress: 100,
            uploadedAt: new Date().toISOString(),
            description: file.name.replace(/\.[^.]+$/, ''),
            contentBase64,
          })
        } catch (err: unknown) {
          setError(err instanceof Error ? err.message : `Could not read ${file.name}.`)
          return
        }
      }

      if (uploaded.length) {
        onChange([...files, ...uploaded])
      }
    },
    [files, onChange],
  )

  const removeFile = (id: string) => onChange(files.filter((file) => file.id !== id))

  const openPicker = () => inputRef.current?.click()

  const hasFiles = files.length > 0
  const showCompactPicker = hasFiles && compactWhenHasFiles

  return (
    <section className="space-y-3">
      {!hideHeader ? (
        <div className="mb-1 flex items-center justify-between gap-2">
          <p className="text-sm font-semibold text-[var(--portal-navy)]">Attachments</p>
          {hasFiles ? (
            <span className="inline-flex items-center gap-1 rounded-full bg-slate-100 px-2.5 py-0.5 text-xs font-semibold text-slate-600">
              <Paperclip className="h-3 w-3" />
              {files.length}
            </span>
          ) : null}
        </div>
      ) : null}

      <input
        ref={inputRef}
        className="sr-only"
        type="file"
        multiple
        accept=".pdf,.doc,.docx,.jpeg,.jpg,.png"
        onChange={(event) => {
          void addFiles(event.target.files)
          event.target.value = ''
        }}
      />

      {showCompactPicker ? (
        <button
          type="button"
          onClick={openPicker}
          className="inline-flex items-center gap-2 rounded-lg border border-dashed border-emerald-300 bg-white px-3 py-2 text-sm font-medium text-emerald-800 transition hover:bg-emerald-50"
        >
          <Plus className="h-4 w-4" />
          Add another file
        </button>
      ) : (
        <div
          role="button"
          tabIndex={0}
          onKeyDown={(event) => {
            if (event.key === 'Enter' || event.key === ' ') {
              event.preventDefault()
              openPicker()
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
          onClick={openPicker}
          className={cn(
            'cursor-pointer overflow-hidden rounded-xl border-2 border-dashed bg-gradient-to-br from-slate-50 to-white px-4 py-8 text-center shadow-inner transition-all duration-200',
            isDragging
              ? 'border-emerald-500 bg-emerald-50/80'
              : 'border-slate-300 hover:border-emerald-400/70 hover:bg-emerald-50/30',
          )}
        >
          <FileUp className="mx-auto h-8 w-8 text-emerald-700" />
          <p className="mt-2 text-sm font-medium text-slate-800">Drop files here or click to browse</p>
          <p className="mt-1 text-xs text-slate-500">PDF, DOC, DOCX, JPG or PNG · Max 10 MB each · 20 MB total</p>
        </div>
      )}

      {error ? <p className="text-sm text-red-600">{error}</p> : null}

      {hasFiles ? (
        <div className="portal-attachment-grid grid gap-3 sm:grid-cols-2">
          {files.map((file, index) => {
            const state = fileStates[file.id] ?? 'pending'
            const cardState =
              state === 'uploading' ? 'uploading' : state === 'success' ? 'success' : 'pending'
            return (
              <div
                key={file.id}
                className="portal-attachment-enter"
                style={{ animationDelay: `${index * 60}ms` }}
              >
                <AttachmentFileCard
                  title={file.description || file.fileName}
                  subtitle={file.fileName}
                  meta={
                    state === 'uploading'
                      ? 'Uploading to Business Central…'
                      : state === 'success'
                        ? 'Uploaded'
                        : formatFileSize(file.size)
                  }
                  state={cardState}
                  progress={fileProgress[file.id]}
                  onRemove={state === 'uploading' ? undefined : () => removeFile(file.id)}
                />
              </div>
            )
          })}
        </div>
      ) : hideEmptyState ? null : (
        <div className="portal-attachment-empty flex flex-col items-center justify-center rounded-xl border border-dashed border-slate-200 bg-slate-50/80 px-4 py-8 text-center">
          <div className="mb-2 flex h-10 w-10 items-center justify-center rounded-full bg-white shadow-sm ring-1 ring-slate-200">
            <Paperclip className="h-4 w-4 text-slate-400" />
          </div>
          <p className="text-sm text-slate-500">
            {emptyHint ?? 'Files will be uploaded when you submit the request'}
          </p>
        </div>
      )}
    </section>
  )
}

function readFileAsBase64(file: File) {
  return new Promise<string>((resolve, reject) => {
    const reader = new FileReader()
    reader.onerror = () => reject(new Error(`Could not read ${file.name}`))
    reader.onload = () => {
      const raw = String(reader.result ?? '')
      const base64 = raw.includes(',') ? raw.split(',')[1] ?? '' : raw
      if (!base64) {
        reject(new Error(`Could not read ${file.name}`))
        return
      }
      resolve(base64)
    }
    reader.readAsDataURL(file)
  })
}
