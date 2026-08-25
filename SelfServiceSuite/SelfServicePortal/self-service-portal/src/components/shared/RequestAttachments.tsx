import { useCallback, useRef, useState } from 'react'
import { FileUp, Upload, X } from 'lucide-react'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { useToast } from '@/components/feedback/ToastProvider'
import { useConfirm } from '@/components/feedback/ConfirmProvider'
import {
  deleteRequestAttachment,
  downloadRequestAttachment,
  uploadRequestAttachment,
} from '@/api/endpoints/requestEndpoint'
import { fetchLeaveRequestDetail, uploadLeaveDocumentAttachment } from '@/api/endpoints/leave'
import type { Attachment, PortalRequest } from '@/types/erp.types'
import { cn } from '@/lib/utils'
import { AttachmentPanel } from './AttachmentPanel'
import { attachmentVisual, formatFileSize } from './attachmentUi'

const ALLOWED = new Set(['pdf', 'doc', 'docx', 'jpg', 'png'])

interface RequestAttachmentsProps {
  requestId: string
  attachments: Attachment[]
  canUpload: boolean
  canDelete: boolean
  onUpdated: (request: PortalRequest) => void
  /** When set, user picks a template category before uploading. */
  categoryOptions?: Array<{ label: string; value: string }>
  categoryHint?: string
}

function readFileBase64(file: File): Promise<string> {
  return new Promise((resolve, reject) => {
    const reader = new FileReader()
    reader.onerror = () => reject(new Error(`Could not read ${file.name}`))
    reader.onload = () => {
      const contentBase64 = String(reader.result ?? '').split(',')[1] ?? ''
      if (!contentBase64) {
        reject(new Error(`Could not encode ${file.name}`))
        return
      }
      resolve(contentBase64)
    }
    reader.readAsDataURL(file)
  })
}

function validateFile(file: File): string | null {
  const extension = file.name.split('.').pop()?.toLowerCase() ?? ''
  if (!ALLOWED.has(extension)) {
    return `${file.name} is not an allowed file type.`
  }
  if (file.size > 10_000_000) {
    return `${file.name} exceeds 10 MB.`
  }
  return null
}

export function RequestAttachments({
  requestId,
  attachments,
  canUpload,
  canDelete,
  onUpdated,
  categoryOptions,
  categoryHint,
}: RequestAttachmentsProps) {
  const toast = useToast()
  const confirm = useConfirm()
  const fileRef = useRef<HTMLInputElement>(null)
  const [category, setCategory] = useState(categoryOptions?.[0]?.value ?? '')
  const [description, setDescription] = useState('')
  const [selectedFile, setSelectedFile] = useState<File | null>(null)
  const [progress, setProgress] = useState(0)
  const [uploading, setUploading] = useState(false)
  const [activeId, setActiveId] = useState<string | null>(null)
  const [isDragging, setIsDragging] = useState(false)

  const pickFile = useCallback(
    (file: File | null) => {
      if (!file) return
      const error = validateFile(file)
      if (error) {
        toast.error(error, 'Invalid file')
        return
      }
      setSelectedFile(file)
      if (!description.trim()) {
        setDescription(file.name.replace(/\.[^.]+$/, ''))
      }
    },
    [description, toast],
  )

  const submitAttachment = async () => {
    if (!canUpload || uploading) return
    const categoryPrefix = categoryOptions?.length ? category.trim() : ''
    const desc = description.trim()
    if (categoryOptions?.length && !categoryPrefix) {
      toast.error('Select an attachment category first.', 'Category required')
      return
    }
    if (!desc) {
      toast.error('Enter attachment description / remarks first.', 'Description required')
      return
    }
    const attachmentDescription = categoryPrefix ? `${categoryPrefix}: ${desc}` : desc
    if (!selectedFile) {
      toast.error('Choose a file to upload.', 'File required')
      return
    }
    const fileError = validateFile(selectedFile)
    if (fileError) {
      toast.error(fileError, 'Invalid file')
      return
    }

    const yes = await confirm({
      title: 'Submit attachment',
      message: 'Upload this attachment to Business Central?',
      confirmLabel: 'Submit',
    })
    if (!yes) return

    setUploading(true)
    setProgress(8)
    const timer = window.setInterval(() => {
      setProgress((value) => Math.min(value + 7, 92))
    }, 120)

    try {
      const contentBase64 = await readFileBase64(selectedFile)
      const updated = requestId.startsWith('leave-')
        ? await (async () => {
            const documentNo = requestId.replace(/^leave-/i, '')
            await uploadLeaveDocumentAttachment(documentNo, {
              fileName: selectedFile.name,
              fileType: selectedFile.type || 'application/octet-stream',
              size: selectedFile.size,
              contentBase64,
              description: attachmentDescription,
            })
            return fetchLeaveRequestDetail(documentNo)
          })()
        : await uploadRequestAttachment(requestId, {
            fileName: selectedFile.name,
            fileType: selectedFile.type || 'application/octet-stream',
            size: selectedFile.size,
            contentBase64,
            description: attachmentDescription,
          })
      setProgress(100)
      onUpdated(updated)
      setDescription('')
      setSelectedFile(null)
      if (fileRef.current) fileRef.current.value = ''
      toast.success('Saved successfully')
    } catch (err) {
      toast.error(err instanceof Error ? err.message : 'Upload failed', 'Upload failed')
    } finally {
      window.clearInterval(timer)
      setUploading(false)
      setProgress(0)
    }
  }

  const handleDownload = async (attachment: Attachment) => {
    setActiveId(attachment.id)
    try {
      await downloadRequestAttachment(requestId, attachment)
    } catch (err) {
      toast.error(err instanceof Error ? err.message : 'Download failed', 'Download failed')
    } finally {
      setActiveId(null)
    }
  }

  const handleDelete = async (attachment: Attachment) => {
    const yes = await confirm({
      title: 'Delete attachment',
      message: 'Delete this attachment?',
      confirmLabel: 'Delete',
      tone: 'danger',
    })
    if (!yes) return
    setActiveId(attachment.id)
    try {
      const updated = await deleteRequestAttachment(requestId, attachment.id)
      onUpdated(updated)
      toast.success('Deleted successfully')
    } catch (err) {
      toast.error(err instanceof Error ? err.message : 'Delete failed', 'Delete failed')
    } finally {
      setActiveId(null)
    }
  }

  const selectedVisual = selectedFile ? attachmentVisual(selectedFile.name) : null

  const uploadSlot = canUpload ? (
    <div className="space-y-3">
      {categoryOptions?.length ? (
        <div className="space-y-1.5">
          <Label htmlFor={`attachment-category-${requestId}`} className="text-slate-700">
            Attachment type
          </Label>
          <select
            id={`attachment-category-${requestId}`}
            value={category}
            onChange={(event) => setCategory(event.target.value)}
            disabled={uploading}
            className="flex h-10 w-full rounded-md border border-slate-200 bg-white px-3 text-sm"
          >
            {categoryOptions.map((option) => (
              <option key={option.value} value={option.value}>
                {option.label}
              </option>
            ))}
          </select>
          {categoryHint ? <p className="text-xs text-slate-500">{categoryHint}</p> : null}
        </div>
      ) : null}
      <div className="space-y-1.5">
        <Label htmlFor={`attachment-desc-${requestId}`} className="text-slate-700">
          Attachment description / remarks
        </Label>
        <Input
          id={`attachment-desc-${requestId}`}
          value={description}
          onChange={(event) => setDescription(event.target.value)}
          placeholder="Brief note about this file"
          disabled={uploading}
          className="bg-white"
        />
      </div>

      <div
        role="button"
        tabIndex={0}
        onKeyDown={(event) => {
          if (event.key === 'Enter' || event.key === ' ') {
            event.preventDefault()
            fileRef.current?.click()
          }
        }}
        onDragEnter={(event) => {
          event.preventDefault()
          if (!uploading) setIsDragging(true)
        }}
        onDragOver={(event) => {
          event.preventDefault()
          if (!uploading) setIsDragging(true)
        }}
        onDragLeave={(event) => {
          event.preventDefault()
          setIsDragging(false)
        }}
        onDrop={(event) => {
          event.preventDefault()
          setIsDragging(false)
          if (uploading) return
          pickFile(event.dataTransfer.files?.[0] ?? null)
        }}
        onClick={() => {
          if (!uploading && !selectedFile) fileRef.current?.click()
        }}
        className={cn(
          'relative rounded-xl border-2 border-dashed transition-all duration-200',
          isDragging
            ? 'border-emerald-500 bg-emerald-50/80'
            : 'border-slate-300 bg-white hover:border-emerald-400/70 hover:bg-emerald-50/30',
          uploading && 'pointer-events-none opacity-60',
          selectedFile ? 'p-3' : 'cursor-pointer px-4 py-8 text-center',
        )}
      >
        <input
          ref={fileRef}
          className="sr-only"
          type="file"
          accept=".pdf,.doc,.docx,.jpg,.png"
          disabled={uploading}
          onChange={(event) => pickFile(event.target.files?.[0] ?? null)}
        />

        {selectedFile && selectedVisual ? (
          <div className="flex items-center gap-3 rounded-lg border border-slate-200 bg-slate-50/80 p-3">
            <div
              className={cn(
                'flex h-10 w-10 shrink-0 items-center justify-center rounded-lg ring-1',
                selectedVisual.tone,
              )}
            >
              <selectedVisual.Icon className="h-5 w-5" />
            </div>
            <div className="min-w-0 flex-1 text-left">
              <p className="truncate text-sm font-semibold text-slate-900">{selectedFile.name}</p>
              <p className="text-xs text-slate-500">{formatFileSize(selectedFile.size)}</p>
            </div>
            {!uploading ? (
              <Button
                type="button"
                variant="ghost"
                size="icon"
                className="h-8 w-8 shrink-0"
                onClick={(event) => {
                  event.stopPropagation()
                  setSelectedFile(null)
                  if (fileRef.current) fileRef.current.value = ''
                }}
                aria-label="Clear selected file"
              >
                <X className="h-4 w-4" />
              </Button>
            ) : null}
          </div>
        ) : (
          <>
            <FileUp className="mx-auto h-8 w-8 text-emerald-700" />
            <p className="mt-2 text-sm font-medium text-slate-800">Drop a file here or click to browse</p>
            <p className="mt-1 text-xs text-slate-500">PDF, DOC, DOCX, JPG or PNG · Max 10 MB</p>
          </>
        )}
      </div>

      <div className="flex justify-end">
        <Button
          type="button"
          className="gap-2 rounded-full px-5"
          disabled={uploading || !selectedFile || !description.trim()}
          onClick={() => void submitAttachment()}
        >
          <Upload className="h-4 w-4" />
          {uploading ? 'Submitting…' : 'Submit attachment'}
        </Button>
      </div>
    </div>
  ) : undefined

  const pendingUpload = uploading && selectedFile
    ? [
        {
          id: 'pending-upload',
          fileName: selectedFile.name,
          description: description.trim() || selectedFile.name,
          size: selectedFile.size,
          progress,
        },
      ]
    : []

  return (
    <AttachmentPanel
      attachments={attachments}
      uploading={pendingUpload}
      isUploading={uploading}
      canDelete={canDelete}
      activeId={activeId}
      onDownload={(attachment) => void handleDownload(attachment)}
      onDelete={(attachment) => void handleDelete(attachment)}
      uploadSlot={uploadSlot}
      emptyText="No attachments yet"
    />
  )
}
