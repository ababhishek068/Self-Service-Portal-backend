import { useId, useState } from 'react'
import {
  ArrowRight,
  Banknote,
  CheckCircle2,
  ChevronDown,
  ClipboardList,
  FileText,
  Handshake,
  PackageCheck,
  Scale,
  ShoppingCart,
  UserCheck,
  UserCog,
  Warehouse,
  Workflow,
  type LucideIcon,
} from 'lucide-react'
import { cn } from '@/lib/utils'
import type { ProcurementProcessIcon, ProcurementProcessStep } from '@/data/procurementProcessFlows'

interface ProcurementProcessBannerProps {
  title: string
  steps: ProcurementProcessStep[]
  note?: string
  flows?: string[]
}

const STEP_ICONS: Record<ProcurementProcessIcon, LucideIcon> = {
  request: ClipboardList,
  approval: UserCheck,
  quotation: FileText,
  evaluation: Scale,
  order: ShoppingCart,
  store: Warehouse,
  storeManager: UserCog,
  receiving: PackageCheck,
  accept: Handshake,
  payment: Banknote,
  done: CheckCircle2,
}

/**
 * The process of a request, as a picture: one numbered category per phase with who acts in it
 * (ABH Operations feedback, Nov 2026). The written phase steps, the text flow and the note open
 * with View details, so the page starts short.
 */
export function ProcurementProcessBanner({
  title,
  steps,
  note,
  flows,
}: ProcurementProcessBannerProps) {
  const [open, setOpen] = useState(false)
  const detailsId = useId()

  return (
    <section
      className="mb-4 overflow-hidden rounded-xl border border-slate-200 bg-white text-sm text-slate-800 shadow-sm"
      aria-label={title}
    >
      <header className="flex flex-wrap items-center justify-between gap-x-4 gap-y-1 bg-[var(--portal-navy)] px-4 py-2.5 text-white">
        <p className="flex min-w-0 items-center gap-2 text-sm font-semibold">
          <Workflow className="h-4 w-4 shrink-0" aria-hidden="true" />
          {title}
        </p>
        <button
          type="button"
          className="inline-flex shrink-0 items-center gap-1 rounded-full bg-white/15 px-3 py-1 text-xs font-semibold hover:bg-white/25 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-white"
          aria-expanded={open}
          aria-controls={detailsId}
          onClick={() => setOpen((value) => !value)}
        >
          {open ? 'Hide details' : 'View details'}
          <ChevronDown className={cn('h-4 w-4 transition-transform', open && 'rotate-180')} aria-hidden="true" />
        </button>
      </header>

      <ol className="grid grid-cols-2 gap-x-3 gap-y-5 px-4 py-4 sm:grid-cols-3 lg:flex lg:items-start lg:gap-1">
        {steps.map((step, index) => {
          const Icon = STEP_ICONS[step.icon ?? 'request']
          return (
            <li
              key={`${step.phase}-${step.owner}-${step.action.slice(0, 24)}`}
              className="flex min-w-0 items-start gap-1 lg:flex-1"
            >
              <div className="flex min-w-0 flex-1 flex-col items-center text-center">
                <span className="relative flex h-11 w-11 items-center justify-center rounded-full bg-slate-100 text-slate-600 shadow-sm">
                  <Icon className="h-5 w-5" aria-hidden="true" />
                  <span className="absolute -right-1 -top-1 flex h-5 w-5 items-center justify-center rounded-full bg-white text-[10px] font-bold text-[var(--portal-navy)] ring-1 ring-slate-200">
                    {step.phase}
                  </span>
                </span>
                <p className="mt-2 text-sm font-semibold leading-snug text-slate-900">
                  {step.heading || `Phase ${step.phase}`}
                </p>
                {step.owner && step.owner !== step.heading ? (
                  <p className="mt-0.5 text-xs leading-snug text-slate-500">{step.owner}</p>
                ) : null}
              </div>
              {index < steps.length - 1 ? (
                <ArrowRight className="mt-3 hidden h-5 w-5 shrink-0 text-slate-400 lg:block" aria-hidden="true" />
              ) : null}
            </li>
          )
        })}
      </ol>

      {open ? (
        <div id={detailsId} className="border-t border-slate-200 bg-teal-50/60 px-4 py-3">
          <ol className="space-y-2 pl-6 marker:font-semibold marker:text-slate-800">
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
        </div>
      ) : null}
    </section>
  )
}
