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

/** Step icon colours, in turn along the flow (the dashboard hero's teal, blue, lime, orange, indigo). */
const STEP_TONES = ['teal', 'blue', 'lime', 'orange', 'indigo'] as const

/**
 * The process of a request, as a picture: one numbered category per phase with who acts in it
 * (ABH Operations feedback, Nov 2026), on the dashboard hero's brand gradient. The written phase
 * steps, the text flow and the note open with View details, so the page starts short.
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
      className="mb-4 overflow-hidden rounded-xl bg-white text-sm text-slate-800 shadow-sm"
      aria-label={title}
    >
      <div className="portal-band">
        <div className="portal-hero-aurora" aria-hidden>
          <span />
          <span />
          <span />
        </div>
        <div className="portal-hero-grid" aria-hidden />

        <header className="flex flex-wrap items-center justify-between gap-x-4 gap-y-1 border-b border-white/10 px-4 py-2.5">
          <p className="flex min-w-0 items-center gap-2 text-sm font-semibold">
            <span className="flex h-7 w-7 shrink-0 items-center justify-center rounded-lg bg-white/12 ring-1 ring-inset ring-white/20">
              <Workflow className="h-4 w-4" aria-hidden="true" />
            </span>
            {title}
          </p>
          <button
            type="button"
            className="portal-hero-cta inline-flex shrink-0 items-center gap-1 rounded-full bg-white/12 px-3 py-1 text-xs font-semibold ring-1 ring-inset ring-white/25 backdrop-blur hover:bg-white/20 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-white"
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
            const tone = STEP_TONES[index % STEP_TONES.length]
            return (
              <li
                key={`${step.phase}-${step.owner}-${step.action.slice(0, 24)}`}
                className="flex min-w-0 items-start gap-1 lg:flex-1"
              >
                <div className="flex min-w-0 flex-1 flex-col items-center text-center">
                  <span className={cn('portal-band-step', `portal-band-step--${tone}`)}>
                    <Icon className="h-5 w-5" aria-hidden="true" />
                    <span className="absolute -right-1 -top-1 flex h-5 w-5 items-center justify-center rounded-full bg-[#d2d741] text-[10px] font-bold text-[#26225b] shadow-md shadow-black/25">
                      {step.phase}
                    </span>
                  </span>
                  <p className="mt-2 text-sm font-semibold leading-snug text-white">
                    {step.heading || `Phase ${step.phase}`}
                  </p>
                  {step.owner && step.owner !== step.heading ? (
                    <p className="mt-0.5 text-xs leading-snug text-white/80">{step.owner}</p>
                  ) : null}
                </div>
                {index < steps.length - 1 ? (
                  <ArrowRight className="mt-3 hidden h-5 w-5 shrink-0 text-white/45 lg:block" aria-hidden="true" />
                ) : null}
              </li>
            )
          })}
        </ol>
      </div>

      {open ? (
        <div id={detailsId} className="rounded-b-xl border-x border-b border-slate-200 bg-teal-50/60 px-4 py-3">
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
