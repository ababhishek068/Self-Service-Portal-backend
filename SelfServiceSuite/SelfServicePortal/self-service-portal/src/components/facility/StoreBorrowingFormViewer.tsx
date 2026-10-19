import { useEffect, type ReactNode } from 'react'
import { createPortal } from 'react-dom'
import { ExternalLink, X } from 'lucide-react'
import { Button } from '@/components/ui/button'

/**
 * In-page Item Borrowing Form (the Business Central report), shown before the
 * requester accepts the offered item — like Accept Item on the BC card, which
 * previews the form and then asks for confirmation.
 */
export function StoreBorrowingFormViewer({
  url,
  requestNo,
  onClose,
  actions,
}: {
  url: string
  requestNo: string
  onClose: () => void
  actions?: ReactNode
}) {
  useEffect(() => {
    const handler = (event: KeyboardEvent) => {
      if (event.key === 'Escape') onClose()
    }
    window.addEventListener('keydown', handler)
    return () => window.removeEventListener('keydown', handler)
  }, [onClose])

  return createPortal(
    <div className="fixed inset-0 z-[100] flex items-center justify-center p-2 sm:p-4">
      <button
        type="button"
        aria-label="Close the Item Borrowing Form"
        onClick={onClose}
        className="absolute inset-0 bg-slate-900/45 backdrop-blur-sm"
      />
      <div
        role="dialog"
        aria-modal="true"
        aria-label={`Item Borrowing Form ${requestNo}`}
        className="relative flex h-[min(92vh,56rem)] w-[min(96vw,60rem)] flex-col overflow-hidden rounded-2xl border border-slate-200 bg-white shadow-2xl"
      >
        <div className="h-1.5 w-full shrink-0 bg-gradient-to-r from-[var(--portal-navy)] to-[var(--portal-green)]" />
        <div className="flex shrink-0 items-center justify-between gap-3 border-b border-slate-200 px-4 py-3">
          <div className="min-w-0">
            <p className="text-sm font-semibold text-slate-900">Item Borrowing Form</p>
            <p className="truncate text-xs text-slate-500">Store requisition {requestNo}</p>
          </div>
          <div className="flex shrink-0 items-center gap-1">
            <a
              href={url}
              target="_blank"
              rel="noopener noreferrer"
              className="inline-flex h-8 items-center gap-1 rounded-md px-2 text-xs font-medium text-[var(--portal-navy)] hover:bg-slate-100"
            >
              <ExternalLink className="h-3.5 w-3.5" />
              Open in new tab
            </a>
            <Button type="button" variant="ghost" size="icon" aria-label="Close" onClick={onClose}>
              <X className="h-4 w-4" />
            </Button>
          </div>
        </div>
        <iframe title={`Item Borrowing Form ${requestNo}`} src={url} className="min-h-0 w-full flex-1 bg-slate-100" />
        {actions ? (
          <div className="flex shrink-0 flex-col-reverse gap-2 border-t border-slate-200 px-4 py-3 sm:flex-row sm:justify-end">
            {actions}
          </div>
        ) : null}
      </div>
    </div>,
    document.body,
  )
}
