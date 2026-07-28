import {
  CheckCircle2,
  Download,
  File,
  FileImage,
  FileText,
  Loader2,
  Trash2,
  X,
} from 'lucide-react'
import { Button } from '@/components/ui/button'
import { cn } from '@/lib/utils'

export function formatFileSize(bytes: number | undefined) {
  if (!bytes || bytes <= 0) return ''
  if (bytes < 1024) return `${bytes} B`
  if (bytes < 1024 * 1024) return `${(bytes / 1024).toFixed(1)} KB`
  return `${(bytes / (1024 * 1024)).toFixed(1)} MB`
}

function fileExtension(fileName: string) {
  return fileName.split('.').pop()?.toLowerCase() ?? ''
}

export function attachmentVisual(fileName: string) {
  const ext = fileExtension(fileName)
  if (['jpg', 'jpeg', 'png', 'gif', 'webp'].includes(ext)) {
    return { Icon: FileImage, tone: 'bg-sky-100 text-sky-700 ring-sky-200/80' }
  }
  if (ext === 'pdf') {
    return { Icon: FileText, tone: 'bg-rose-100 text-rose-700 ring-rose-200/80' }
  }
  if (['doc', 'docx'].includes(ext)) {
    return { Icon: FileText, tone: 'bg-blue-100 text-blue-700 ring-blue-200/80' }
  }
  return { Icon: File, tone: 'bg-slate-100 text-slate-700 ring-slate-200/80' }
}

export function AttachmentFileCard({
  title,
  subtitle,
  meta,
  state,
  progress,
  active,
  canDelete,
  onDownload,
  onDelete,
  onRemove,
}: {
  title: string
  subtitle?: string
  meta?: string
  state: 'ready' | 'uploading' | 'success' | 'pending'
  progress?: number
  active?: boolean
  canDelete?: boolean
  onDownload?: () => void
  onDelete?: () => void
  onRemove?: () => void
}) {
  const { Icon, tone } = attachmentVisual(title)
  const showProgress = state === 'uploading' && typeof progress === 'number'

  return (
    <article
      className={cn(
        'portal-attachment-card group relative overflow-hidden rounded-xl border bg-white p-3 shadow-sm transition-all duration-300',
        state === 'uploading'
          ? 'border-emerald-300 ring-2 ring-emerald-200/60'
          : 'border-slate-200 hover:border-[var(--portal-navy)]/25 hover:shadow-md',
        active && 'opacity-70',
      )}
    >
      {state === 'uploading' && !showProgress ? (
        <span className="portal-attachment-progress absolute inset-x-0 top-0 h-0.5 bg-gradient-to-r from-emerald-400 via-emerald-600 to-emerald-400" />
      ) : null}
      <div className="flex items-start gap-3">
        <div
          className={cn(
            'flex h-11 w-11 shrink-0 items-center justify-center rounded-lg ring-1 transition-transform duration-300 group-hover:scale-105',
            tone,
          )}
        >
          {state === 'uploading' ? (
            <Loader2 className="h-5 w-5 animate-spin text-emerald-600" />
          ) : state === 'success' ? (
            <CheckCircle2 className="h-5 w-5 animate-check-pop text-emerald-600" />
          ) : (
            <Icon className="h-5 w-5" />
          )}
        </div>
        <div className="min-w-0 flex-1">
          <p className="truncate text-sm font-semibold text-slate-900">{title}</p>
          {subtitle ? <p className="truncate text-xs text-slate-500">{subtitle}</p> : null}
          {meta ? (
            <p className="mt-1 text-[11px] font-medium uppercase tracking-wide text-slate-400">{meta}</p>
          ) : null}
          {showProgress ? (
            <div className="mt-2 space-y-1">
              <div className="h-1.5 overflow-hidden rounded-full bg-slate-100">
                <div
                  className="h-full rounded-full bg-emerald-600 transition-[width] duration-200 ease-out"
                  style={{ width: `${Math.min(100, Math.max(0, progress))}%` }}
                />
              </div>
              <p className="text-[11px] font-medium text-emerald-700">{Math.round(progress)}% uploaded</p>
            </div>
          ) : null}
        </div>
        {state === 'ready' ? (
          <div className="flex shrink-0 gap-1 opacity-100 transition-opacity sm:opacity-80 sm:group-hover:opacity-100">
            {onDownload ? (
              <Button
                type="button"
                variant="outline"
                size="icon"
                className="h-8 w-8"
                disabled={active}
                onClick={onDownload}
                aria-label="Download attachment"
              >
                <Download className="h-4 w-4" />
              </Button>
            ) : null}
            {canDelete && onDelete ? (
              <Button
                type="button"
                variant="ghost"
                size="icon"
                className="h-8 w-8 text-red-600 hover:bg-red-50 hover:text-red-700"
                disabled={active}
                onClick={onDelete}
                aria-label="Delete attachment"
              >
                <Trash2 className="h-4 w-4" />
              </Button>
            ) : null}
          </div>
        ) : null}
        {state === 'pending' && onRemove ? (
          <Button
            type="button"
            variant="ghost"
            size="icon"
            className="h-8 w-8 shrink-0 text-slate-500 hover:text-slate-800"
            onClick={onRemove}
            aria-label="Remove file"
          >
            <X className="h-4 w-4" />
          </Button>
        ) : null}
      </div>
    </article>
  )
}
