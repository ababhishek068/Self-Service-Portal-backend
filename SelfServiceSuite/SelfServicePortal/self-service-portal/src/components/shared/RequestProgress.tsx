import { Check, FileCheck2, ListPlus, Send } from 'lucide-react'
import type { CSSProperties } from 'react'

interface RequestProgressProps {
  status: string
  hasLines?: boolean
  requiresLines?: boolean
}

export function RequestProgress({ status, hasLines = false, requiresLines = false }: RequestProgressProps) {
  const approvalRequested = ['Pending Approval', 'Submitted', 'Approved', 'Rejected', 'Cancelled', 'Posted'].includes(status)
  const detailReady = !requiresLines || hasLines
  const workflowNote = approvalRequested ? status : 'Not requested yet'
  const completedWorkflow = ['Approved', 'Rejected', 'Cancelled', 'Posted'].includes(status)
  const steps = [
    { label: 'Draft created', note: 'Header saved in Business Central', done: true, active: false, icon: FileCheck2 },
    {
      label: requiresLines ? 'Lines & attachments' : 'Review details',
      note: detailReady ? 'Ready for approval' : 'Add at least one line',
      done: detailReady,
      active: detailReady && !approvalRequested,
      icon: ListPlus,
    },
    {
      label: 'Approval workflow',
      note: workflowNote,
      done: completedWorkflow,
      active: ['Pending Approval', 'Submitted'].includes(status),
      icon: Send,
    },
  ]
  const reachedIndex = approvalRequested || completedWorkflow ? 2 : detailReady ? 1 : 0
  const progressWidth = `${Math.max(0, Math.min(100, (reachedIndex / (steps.length - 1)) * 100))}%`

  return (
    <div
      className="portal-flow-stepper rounded-lg border border-slate-200 bg-white px-3 py-4 shadow-sm sm:px-4"
      style={{ '--portal-flow-progress': progressWidth } as CSSProperties}
    >
      <div className="relative grid gap-4 sm:grid-cols-3 sm:gap-3">
        <div className="absolute left-5 top-5 bottom-5 w-0.5 rounded-full bg-slate-200 sm:left-[12.5%] sm:right-[12.5%] sm:top-6 sm:bottom-auto sm:h-0.5 sm:w-auto" />
        <div className="portal-flow-rail absolute left-5 top-5 w-0.5 rounded-full sm:left-[12.5%] sm:top-6 sm:h-0.5 sm:w-auto" />
        {steps.map((step, index) => {
          const Icon = step.icon
          const complete = step.done || (index === 1 && detailReady && approvalRequested)
          const stateClass = complete
            ? 'border-emerald-500 bg-emerald-600 text-white shadow-emerald-100'
            : step.active
              ? 'border-[var(--portal-blue-action)] bg-[var(--portal-blue-action)] text-white shadow-blue-100 portal-flow-node-active'
              : 'border-slate-300 bg-white text-slate-500 shadow-slate-100'
          const textClass = complete || step.active ? 'text-[var(--portal-navy)]' : 'text-slate-600'
          return (
            <div
              key={step.label}
              className="portal-flow-step relative grid grid-cols-[2.75rem_1fr] items-center gap-3 sm:grid-cols-1 sm:justify-items-center sm:text-center"
              style={{ animationDelay: `${index * 90}ms` }}
            >
              <span
                className={`relative z-10 flex h-10 w-10 shrink-0 items-center justify-center rounded-full border-2 shadow-lg transition-all duration-300 ${stateClass}`}
              >
                {complete ? <Check className="h-4 w-4" /> : <Icon className="h-4 w-4" />}
              </span>
              <div className="min-w-0 rounded-md bg-white/85 py-0.5 sm:bg-transparent">
                <p className={`text-sm font-semibold leading-tight ${textClass}`}>
                  <span className="mr-1.5 text-[10px] font-bold uppercase text-slate-400">
                    0{index + 1}
                  </span>
                  {step.label}
                </p>
                <p className="mt-1 truncate text-xs font-medium text-slate-500">{step.note}</p>
              </div>
            </div>
          )
        })}
      </div>
    </div>
  )
}
