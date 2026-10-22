import type { ReactNode } from 'react'
import { AlertTriangle, CheckCircle2, Clock, Info } from 'lucide-react'

type StoreNoticeTone = 'waiting' | 'info' | 'success' | 'warning'

const toneStyles: Record<StoreNoticeTone, { box: string; icon: string; Icon: typeof Info }> = {
  waiting: { box: 'border-teal-200 border-l-teal-600 bg-teal-50 text-teal-900', icon: 'text-teal-600', Icon: Clock },
  info: { box: 'border-teal-200 border-l-teal-600 bg-teal-50 text-teal-900', icon: 'text-teal-600', Icon: Info },
  success: {
    box: 'border-emerald-200 border-l-emerald-600 bg-emerald-50 text-emerald-900',
    icon: 'text-emerald-600',
    Icon: CheckCircle2,
  },
  warning: { box: 'border-red-200 border-l-red-600 bg-red-50 text-red-900', icon: 'text-red-600', Icon: AlertTriangle },
}

/** Highlighted status line in the Store status panel: what is happening and who acts next. */
export function StoreNotice({ tone = 'info', children }: { tone?: StoreNoticeTone; children: ReactNode }) {
  const style = toneStyles[tone]
  return (
    <div
      role={tone === 'warning' ? 'alert' : 'status'}
      className={`mt-3 flex items-start gap-2.5 rounded-lg border border-l-4 px-3.5 py-2.5 text-sm font-medium leading-relaxed ${style.box}`}
    >
      <style.Icon className={`mt-0.5 h-4 w-4 shrink-0 ${style.icon}`} aria-hidden="true" />
      <div>{children}</div>
    </div>
  )
}
