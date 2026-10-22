import type { ReactNode } from 'react'
import { AlertTriangle, CheckCircle2, Clock, Info, XCircle } from 'lucide-react'

export type StatusNoticeTone = 'waiting' | 'info' | 'success' | 'attention' | 'warning'

const toneStyles: Record<StatusNoticeTone, { box: string; icon: string; Icon: typeof Info }> = {
  waiting: { box: 'border-teal-300 border-l-teal-600 bg-teal-100/70 text-teal-950', icon: 'text-teal-600', Icon: Clock },
  info: { box: 'border-teal-300 border-l-teal-600 bg-teal-100/70 text-teal-950', icon: 'text-teal-600', Icon: Info },
  success: {
    box: 'border-emerald-200 border-l-emerald-600 bg-emerald-50 text-emerald-900',
    icon: 'text-emerald-600',
    Icon: CheckCircle2,
  },
  attention: {
    box: 'border-amber-200 border-l-amber-500 bg-amber-50 text-amber-950',
    icon: 'text-amber-600',
    Icon: AlertTriangle,
  },
  warning: { box: 'border-red-200 border-l-red-600 bg-red-50 text-red-900', icon: 'text-red-600', Icon: XCircle },
}

/**
 * Highlighted status line: what is happening and who acts next (waiting, next step, done,
 * needs attention, problem). `className` replaces the default top margin.
 */
export function StatusNotice({
  tone = 'info',
  className = 'mt-3',
  children,
}: {
  tone?: StatusNoticeTone
  className?: string
  children: ReactNode
}) {
  const style = toneStyles[tone]
  return (
    <div
      role={tone === 'warning' || tone === 'attention' ? 'alert' : 'status'}
      className={`flex items-start gap-2.5 rounded-lg border border-l-4 px-3.5 py-2.5 text-sm font-medium leading-relaxed ${style.box} ${className}`}
    >
      <style.Icon className={`mt-0.5 h-4 w-4 shrink-0 ${style.icon}`} aria-hidden="true" />
      <div className="min-w-0">{children}</div>
    </div>
  )
}
