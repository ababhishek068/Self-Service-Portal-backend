import { useEffect, useMemo } from 'react'
import { createPortal } from 'react-dom'
import { Download, FileQuestion, Loader2, X } from 'lucide-react'
import { Button } from '@/components/ui/button'

/** The browser can show these in the page; BC often stores attachments without a MIME type. */
function viewableType(fileName: string, fileType: string) {
  const extension = fileName.toLowerCase().split('.').pop() ?? ''
  if (fileType.startsWith('image/') || ['png', 'jpg', 'jpeg', 'gif', 'webp', 'bmp'].includes(extension)) {
    return fileType.startsWith('image/') ? fileType : `image/${extension === 'jpg' ? 'jpeg' : extension}`
  }
  if (fileType === 'application/pdf' || extension === 'pdf') return 'application/pdf'
  if (fileType.startsWith('text/') || extension === 'txt') return 'text/plain'
  return ''
}

/**
 * View an attachment in the portal (PDF, image, text) without downloading it; other files (Word,
 * Excel…) cannot be shown by the browser and offer Download instead.
 */
export function AttachmentViewer({
  fileName,
  fileType,
  blob,
  loading,
  error,
  onClose,
  onDownload,
}: {
  fileName: string
  fileType: string
  blob: Blob | null
  loading: boolean
  error?: string
  onClose: () => void
  onDownload: () => void
}) {
  const type = viewableType(fileName, fileType)
  const url = useMemo(() => (blob && type ? URL.createObjectURL(new Blob([blob], { type })) : ''), [blob, type])
  useEffect(() => () => {
    if (url) URL.revokeObjectURL(url)
  }, [url])
  useEffect(() => {
    const handler = (event: KeyboardEvent) => {
      if (event.key === 'Escape') onClose()
    }
    window.addEventListener('keydown', handler)
    return () => window.removeEventListener('keydown', handler)
  }, [onClose])

  return createPortal(
    <div className="fixed inset-0 z-[100] flex items-center justify-center p-2 sm:p-4">
      <button type="button" aria-label="Close" onClick={onClose} className="absolute inset-0 bg-slate-900/45 backdrop-blur-sm" />
      <div
        role="dialog"
        aria-modal="true"
        aria-label={fileName}
        className="relative mx-auto flex h-[94vh] w-[min(97vw,84rem)] flex-col overflow-hidden rounded-2xl border border-slate-200 bg-white shadow-2xl"
      >
        <div className="h-1.5 w-full shrink-0 bg-gradient-to-r from-[var(--portal-navy)] to-[var(--portal-green)]" />
        <div className="flex shrink-0 items-center justify-between gap-3 border-b border-slate-200 px-4 py-3">
          <p className="min-w-0 truncate text-sm font-semibold text-slate-900">{fileName}</p>
          <div className="flex shrink-0 items-center gap-1">
            <Button type="button" variant="outline" size="sm" onClick={onDownload} disabled={loading}>
              <Download className="h-4 w-4" />
              Download
            </Button>
            <Button type="button" variant="ghost" size="icon" aria-label="Close" onClick={onClose}>
              <X className="h-4 w-4" />
            </Button>
          </div>
        </div>
        <div className="flex min-h-0 flex-1 items-center justify-center bg-slate-100">
          {loading ? (
            <p className="flex items-center gap-2 text-sm text-slate-600">
              <Loader2 className="h-4 w-4 animate-spin" /> Opening…
            </p>
          ) : error ? (
            <p className="px-6 text-center text-sm text-red-700">{error}</p>
          ) : !type ? (
            <div className="px-6 text-center text-sm text-slate-600">
              <FileQuestion className="mx-auto mb-2 h-8 w-8 text-slate-400" />
              <p>This file type cannot be shown in the browser. Download it to open it.</p>
            </div>
          ) : type.startsWith('image/') ? (
            <img src={url} alt={fileName} className="max-h-full max-w-full object-contain" />
          ) : (
            <iframe title={fileName} src={url} className="h-full w-full bg-white" />
          )}
        </div>
      </div>
    </div>,
    document.body,
  )
}
