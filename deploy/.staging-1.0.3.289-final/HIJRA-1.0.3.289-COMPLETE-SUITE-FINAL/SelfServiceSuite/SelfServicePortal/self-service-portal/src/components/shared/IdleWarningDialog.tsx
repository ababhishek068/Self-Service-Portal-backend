import { ShieldAlert } from 'lucide-react'
import { Button } from '@/components/ui/button'

interface IdleWarningDialogProps {
  open: boolean
  secondsLeft: number
  onStayLoggedIn: () => void
}

function formatTime(seconds: number) {
  const m = Math.floor(seconds / 60)
  const s = seconds % 60
  return m > 0 ? `${m}:${String(s).padStart(2, '0')} min` : `${s}s`
}

export function IdleWarningDialog({ open, secondsLeft, onStayLoggedIn }: IdleWarningDialogProps) {
  if (!open) return null
  return (
    <div className="fixed inset-0 z-[9999] flex items-center justify-center bg-black/50 backdrop-blur-sm">
      <div className="mx-4 w-full max-w-sm rounded-xl border border-amber-200 bg-white p-6 shadow-2xl">
        <div className="mb-4 flex items-center gap-3">
          <div className="flex h-10 w-10 flex-shrink-0 items-center justify-center rounded-full bg-amber-100">
            <ShieldAlert className="h-5 w-5 text-amber-600" />
          </div>
          <div>
            <h2 className="text-base font-semibold text-slate-900">Session expiring soon</h2>
            <p className="text-xs text-slate-500">You have been inactive</p>
          </div>
        </div>
        <p className="mb-1 text-sm text-slate-700">
          For security, your session will automatically log out in:
        </p>
        <p className="mb-5 text-center text-3xl font-bold tabular-nums text-amber-600">
          {formatTime(secondsLeft)}
        </p>
        <p className="mb-5 text-xs text-slate-500">
          Click below to stay logged in, or you will be logged out automatically when the timer
          reaches zero.
        </p>
        <Button className="w-full" onClick={onStayLoggedIn}>
          Stay logged in
        </Button>
      </div>
    </div>
  )
}
