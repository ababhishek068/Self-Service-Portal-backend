import { Loader2, Paperclip } from 'lucide-react'
import type { ReactNode } from 'react'
import type { Attachment } from '@/types/erp.types'
import { formatDate } from '@/utils/formatters'
import { AttachmentFileCard, formatFileSize } from './attachmentUi'

export interface UploadingAttachment {
  id: string
  fileName: string
  description?: string
  size?: number
  progress?: number
}

interface AttachmentPanelProps {
  attachments: Attachment[]
  uploading?: UploadingAttachment[]
  isUploading?: boolean
  canDelete?: boolean
  activeId?: string | null
  onDownload: (attachment: Attachment) => void
  onDelete?: (attachment: Attachment) => void
  uploadSlot?: ReactNode
  title?: string
  emptyText?: string
}

export function AttachmentPanel({
  attachments,
  uploading = [],
  isUploading = false,
  canDelete = false,
  activeId = null,
  onDownload,
  onDelete,
  uploadSlot,
  title = 'Attachments',
  emptyText = 'No attachments yet',
}: AttachmentPanelProps) {
  const totalCount = attachments.length + uploading.length
  const showEmpty = totalCount === 0 && !isUploading && !uploadSlot

  return (
    <section className="border-t border-slate-200 pt-4">
      <div className="mb-3 flex items-center justify-between gap-2">
        <h3 className="text-sm font-semibold text-[var(--portal-navy)]">{title}</h3>
        {totalCount > 0 ? (
          <span className="inline-flex items-center gap-1 rounded-full bg-slate-100 px-2.5 py-0.5 text-xs font-semibold text-slate-600">
            <Paperclip className="h-3 w-3" />
            {totalCount}
          </span>
        ) : null}
      </div>

      {uploadSlot ? (
        <div className="mb-4 overflow-hidden rounded-xl border border-dashed border-slate-300 bg-gradient-to-br from-slate-50 to-white p-4 shadow-inner transition-all duration-300 hover:border-emerald-400/60">
          {uploadSlot}
          {isUploading ? (
            <p className="mt-3 flex items-center gap-2 text-xs font-medium text-emerald-700">
              <Loader2 className="h-3.5 w-3.5 animate-spin" />
              Saving to Business Central…
            </p>
          ) : null}
        </div>
      ) : null}

      {showEmpty ? (
        <div className="portal-attachment-empty flex flex-col items-center justify-center rounded-xl border border-dashed border-slate-200 bg-slate-50/80 px-4 py-10 text-center">
          <div className="mb-3 flex h-12 w-12 items-center justify-center rounded-full bg-white shadow-sm ring-1 ring-slate-200">
            <Paperclip className="h-5 w-5 text-slate-400" />
          </div>
          <p className="text-sm font-medium text-slate-600">{emptyText}</p>
          <p className="mt-1 text-xs text-slate-400">PDF, DOC, DOCX, JPG or PNG up to 10 MB</p>
        </div>
      ) : totalCount > 0 ? (
        <div className="portal-attachment-grid grid gap-3 sm:grid-cols-2">
          {uploading.map((file, index) => (
            <div
              key={file.id}
              className="portal-attachment-enter"
              style={{ animationDelay: `${index * 60}ms` }}
            >
              <AttachmentFileCard
                title={file.description || file.fileName}
                subtitle={file.fileName !== (file.description || file.fileName) ? file.fileName : undefined}
                meta={formatFileSize(file.size)}
                state="uploading"
                progress={file.progress}
              />
            </div>
          ))}
          {attachments.map((attachment, index) => (
            <div
              key={attachment.id}
              className="portal-attachment-enter"
              style={{ animationDelay: `${(uploading.length + index) * 60}ms` }}
            >
              <AttachmentFileCard
                title={attachment.description || attachment.fileName}
                subtitle={
                  attachment.description && attachment.fileName !== attachment.description
                    ? attachment.fileName
                    : undefined
                }
                meta={[
                  formatFileSize(attachment.size),
                  attachment.uploadedAt ? formatDate(attachment.uploadedAt) : '',
                ]
                  .filter(Boolean)
                  .join(' · ')}
                state="ready"
                active={activeId === attachment.id}
                canDelete={canDelete}
                onDownload={() => onDownload(attachment)}
                onDelete={onDelete ? () => onDelete(attachment) : undefined}
              />
            </div>
          ))}
        </div>
      ) : null}
    </section>
  )
}
