import type { ProcurementProcessStep } from '@/data/procurementProcessFlows'

interface ProcurementProcessBannerProps {
  title: string
  steps: ProcurementProcessStep[]
  note?: string
  flows?: string[]
}

export function ProcurementProcessBanner({
  title,
  steps,
  note,
  flows,
}: ProcurementProcessBannerProps) {
  return (
    <section
      className="mb-4 rounded-lg border border-teal-200 bg-teal-50/70 px-4 py-3 text-sm text-slate-800"
      aria-label={title}
    >
      <p className="font-semibold text-[var(--portal-navy)]">{title}</p>
      <ol className="mt-2 space-y-2 pl-6 marker:font-semibold marker:text-slate-800">
        {steps.map((step) => (
          <li
            key={`${step.phase}-${step.owner}-${step.action.slice(0, 24)}`}
            className="list-decimal pl-1 leading-relaxed"
          >
            <span className="font-semibold text-slate-900">
              Phase {step.phase} –{step.heading ? ` ${step.heading}:` : ''}
            </span>{' '}
            {step.action}
          </li>
        ))}
      </ol>
      {flows && flows.length > 0 ? (
        <div className="mt-4 border-t border-teal-200 pt-3 text-sm text-slate-800">
          <p className="font-semibold text-slate-900">Process Flow</p>
          <div className="mt-2 space-y-3">
            {flows.map((flow) => {
              const unavailableLabel = 'If Stock Is Unavailable:'
              const unavailable = flow.startsWith(unavailableLabel)
              const text = unavailable ? flow.slice(unavailableLabel.length).trim() : flow
              return (
                <div key={flow}>
                  {unavailable ? (
                    <p className="mb-1 font-semibold text-slate-900">{unavailableLabel}</p>
                  ) : null}
                  <p className="font-medium leading-relaxed">{text}</p>
                </div>
              )
            })}
          </div>
        </div>
      ) : null}
      {note ? <p className="mt-3 text-xs text-slate-600">{note}</p> : null}
    </section>
  )
}
