import {
  Banknote,
  CheckCircle2,
  ClipboardList,
  FileText,
  Handshake,
  PackageCheck,
  Scale,
  ShoppingCart,
  UserCheck,
  UserCog,
  Warehouse,
  type LucideIcon,
} from 'lucide-react'
import { ProcessTracker } from '@/components/shared/ProcessTracker'
import type { ProcurementProcessIcon, ProcurementProcessStep } from '@/data/procurementProcessFlows'
import type { ProcessStage } from '@/data/processStages'

interface ProcurementProcessBannerProps {
  title: string
  steps: ProcurementProcessStep[]
  note?: string
  flows?: string[]
  /** Where the open document is (processStages). Without it the banner shows the process only. */
  stage?: ProcessStage
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
 * The process of a store or local purchase request, as a picture: one numbered category per phase
 * with who acts in it (ABH Operations feedback, Nov 2026), drawn by ProcessTracker. On an open
 * document it shows where the document is. The written phase steps, the text flow and the note
 * open with View details, so the page starts short.
 */
export function ProcurementProcessBanner({ title, steps, note, flows, stage }: ProcurementProcessBannerProps) {
  return (
    <ProcessTracker
      className="mb-4"
      title={title}
      stage={stage}
      steps={steps.map((step) => ({
        key: `${step.phase}-${step.owner}-${step.action.slice(0, 24)}`,
        heading: step.heading || `Phase ${step.phase}`,
        owner: step.owner,
        icon: STEP_ICONS[step.icon ?? 'request'],
        badge: step.phase,
      }))}
      details={
        <>
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
        </>
      }
    />
  )
}
