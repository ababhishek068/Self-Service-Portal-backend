import { useEffect, useRef } from 'react'
import { createPortal } from 'react-dom'
import { MessageSquareText } from 'lucide-react'
import { Button } from '@/components/ui/button'
import { Label } from '@/components/ui/label'
import { Textarea } from '@/components/ui/textarea'

/** BC keeps the Local Purchase comment as Text[250] in the LPR Approval Log. */
export const LPR_COMMENT_MAX = 250

/**
 * The comment box BC opens before a Local Purchase approve, send back or reject: the action runs
 * only with a comment, which goes to the Approval History (and to Rejection Reason / Send Back
 * Comment). The button stays disabled until there is text.
 */
export function LprCommentDialog({
  open,
  title,
  documentNo,
  label,
  value,
  busy,
  danger,
  onChange,
  onConfirm,
  onCancel,
}: {
  open: boolean
  title: string
  documentNo: string
  label: string
  value: string
  busy: boolean
  danger: boolean
  onChange: (value: string) => void
  onConfirm: () => void
  onCancel: () => void
}) {
  const fieldRef = useRef<HTMLTextAreaElement>(null)
  useEffect(() => {
    if (open) fieldRef.current?.focus()
  }, [open])
  if (!open) return null
  const ready = value.trim().length > 0

  // On the page body, so it is centred on the screen whatever section opens it.
  return createPortal(
    <div
      className="fixed inset-0 z-50 flex items-center justify-center bg-slate-950/40 p-4"
      role="dialog"
      aria-modal="true"
      aria-labelledby="lpr-comment-title"
      onKeyDown={(event) => {
        if (event.key === 'Escape' && !busy) onCancel()
      }}
    >
      <div className="w-full max-w-lg rounded-lg bg-white p-5 shadow-xl">
        <div className="flex gap-3">
          <div className="flex h-10 w-10 shrink-0 items-center justify-center rounded-full bg-teal-50">
            <MessageSquareText className="h-5 w-5 text-teal-700" />
          </div>
          <div className="min-w-0">
            <h2 id="lpr-comment-title" className="text-lg font-semibold text-slate-950">
              {title}
            </h2>
            <p className="mt-0.5 text-sm text-slate-600">{documentNo}</p>
          </div>
        </div>
        <div className="mt-4 space-y-1.5">
          <Label htmlFor="lpr-comment-text">{label}</Label>
          <Textarea
            ref={fieldRef}
            id="lpr-comment-text"
            value={value}
            maxLength={LPR_COMMENT_MAX}
            rows={4}
            disabled={busy}
            onChange={(event) => onChange(event.target.value)}
          />
          <p className="flex justify-between gap-2 text-xs text-slate-500">
            <span>Recorded with your name in the Approval History.</span>
            <span className="tabular-nums">
              {value.length}/{LPR_COMMENT_MAX}
            </span>
          </p>
        </div>
        <div className="mt-5 flex justify-end gap-2">
          <Button type="button" variant="outline" onClick={onCancel} disabled={busy}>
            Cancel
          </Button>
          <Button
            type="button"
            variant={danger ? 'destructive' : 'gradient'}
            onClick={onConfirm}
            disabled={!ready || busy}
          >
            {busy ? 'Working…' : title}
          </Button>
        </div>
      </div>
    </div>,
    document.body,
  )
}
