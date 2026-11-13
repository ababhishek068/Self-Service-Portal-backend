import { createElement, isValidElement, useId, useState, type CSSProperties, type ReactElement, type ReactNode } from 'react'
import { Check, ChevronDown, Sparkles, Workflow, X, type LucideIcon } from 'lucide-react'
import { cn } from '@/lib/utils'
import type { ProcessStage } from '@/data/processStages'

/** One step of a process or workflow, as the tracker draws it. */
export type TrackerStep = {
  key: string
  heading: string
  /** Who acts, or a short note (an approver's name, "Ready for approval"). */
  owner?: string
  /** A lucide icon, or an icon element a page already builds (h-5 w-5). */
  icon: LucideIcon | ReactElement
  /** The number on the badge; defaults to the step's position. */
  badge?: string
}

interface ProcessTrackerProps {
  title: string
  steps: TrackerStep[]
  /** Where the document is. Without it the tracker shows the process only (flowing connectors). */
  stage?: ProcessStage
  /** The written steps; with it the header has View details. */
  details?: ReactNode
  className?: string
}

/** Step icon colours, in turn along the flow (the dashboard hero's teal, blue, lime, orange, indigo). */
const STEP_TONES = ['teal', 'blue', 'lime', 'orange', 'indigo'] as const

type StepState = 'flow' | 'done' | 'current' | 'rejected' | 'todo'

function stepState(index: number, stage: ProcessStage | undefined): StepState {
  if (!stage) return 'flow'
  if (index < stage.index) return 'done'
  if (index > stage.index) return 'todo'
  return stage.state === 'active' ? 'current' : 'rejected'
}

/** The connector after a step: drawn when done, marching toward the current step, dashed ahead. */
function linkState(index: number, stage: ProcessStage | undefined) {
  if (!stage) return 'flow'
  if (index + 1 < stage.index) return 'done'
  if (index + 1 === stage.index) return stage.state === 'active' ? 'next' : 'done'
  return 'todo'
}

const STATE_LABEL: Record<StepState, string> = {
  flow: '',
  done: 'completed',
  current: 'current step',
  rejected: 'stopped here',
  todo: 'not started',
}

/**
 * A document's process or approval workflow on the dashboard hero's brand gradient (ABH Operations
 * feedback, Nov 2026). With a stage it tracks the document live: done steps filled with a check,
 * the current step glowing with BC's stage under it, later steps dimmed, and the connectors drawn
 * up to where the document is. Steps pop in one after another; all motion stops for reduced motion.
 */
export function ProcessTracker({ title, steps, stage, details, className }: ProcessTrackerProps) {
  const [open, setOpen] = useState(false)
  const detailsId = useId()
  const complete = Boolean(stage && stage.index >= steps.length)
  const stopped = stage && stage.state !== 'active' ? stage : undefined
  const progress = stage ? Math.min(stage.index, steps.length) / steps.length : 0

  return (
    <section className={cn('overflow-hidden rounded-xl bg-white text-sm text-slate-800 shadow-sm', className)} aria-label={title}>
      <div className={cn('portal-band', complete && 'portal-band--complete')}>
        <div className="portal-hero-aurora" aria-hidden>
          <span />
          <span />
          <span />
        </div>
        <div className="portal-hero-grid" aria-hidden />

        <header className="flex flex-wrap items-center justify-between gap-x-4 gap-y-2 border-b border-white/10 px-4 py-2.5">
          <p className="flex min-w-0 items-center gap-2 text-sm font-semibold">
            <span className="portal-band-title-icon flex h-7 w-7 shrink-0 items-center justify-center rounded-lg bg-white/12 ring-1 ring-inset ring-white/20">
              <Workflow className="h-4 w-4" aria-hidden="true" />
            </span>
            {title}
          </p>
          <div className="flex shrink-0 flex-wrap items-center gap-2">
            {stage ? (
              <span
                className={cn(
                  'portal-band-progress-chip inline-flex items-center gap-1.5 rounded-full px-2.5 py-1 text-xs font-bold',
                  stopped
                    ? 'bg-rose-500 text-white'
                    : complete
                      ? 'bg-[#d2d741] text-[#26225b]'
                      : 'bg-white/12 text-white ring-1 ring-inset ring-white/25',
                )}
              >
                {complete ? (
                  <>
                    <Sparkles className="h-3.5 w-3.5" aria-hidden="true" />
                    All steps done
                  </>
                ) : stopped ? (
                  <>
                    <X className="h-3.5 w-3.5" aria-hidden="true" />
                    {stopped.state === 'rejected' ? 'Rejected' : 'Cancelled'} at step {stopped.index + 1}
                  </>
                ) : (
                  <>
                    <span className="portal-band-live-dot" aria-hidden="true" />
                    Step {stage.index + 1} of {steps.length}
                  </>
                )}
              </span>
            ) : null}
            {details ? (
              <button
                type="button"
                className="portal-hero-cta inline-flex items-center gap-1 rounded-full bg-white/12 px-3 py-1 text-xs font-semibold ring-1 ring-inset ring-white/25 backdrop-blur hover:bg-white/20 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-white"
                aria-expanded={open}
                aria-controls={detailsId}
                onClick={() => setOpen((value) => !value)}
              >
                {open ? 'Hide details' : 'View details'}
                <ChevronDown className={cn('h-4 w-4 transition-transform', open && 'rotate-180')} aria-hidden="true" />
              </button>
            ) : null}
          </div>
        </header>

        {stage ? (
          <div className="portal-band-meter lg:hidden" aria-hidden="true">
            <span style={{ '--p': progress } as CSSProperties} />
          </div>
        ) : null}

        <ol className="grid grid-cols-2 gap-x-3 gap-y-6 px-4 pb-5 pt-5 sm:grid-cols-3 lg:flex lg:items-start lg:gap-0">
          {steps.map((step, index) => {
            const icon = isValidElement(step.icon)
              ? step.icon
              : createElement(step.icon as LucideIcon, { className: 'h-5 w-5', 'aria-hidden': true })
            const tone = STEP_TONES[index % STEP_TONES.length]
            const state = stepState(index, stage)
            const link = linkState(index, stage)
            const order = { '--i': index } as CSSProperties
            return (
              <li
                key={step.key}
                className="portal-band-li relative flex min-w-0 flex-col items-center px-1 text-center lg:flex-1"
                style={order}
                data-state={state}
                aria-current={state === 'current' ? 'step' : undefined}
              >
                {index < steps.length - 1 ? (
                  <span className={cn('portal-band-link', `portal-band-link--${link}`)} style={order} aria-hidden="true">
                    <span />
                  </span>
                ) : null}
                <span className={cn('portal-band-step', `portal-band-step--${tone}`, `is-${state}`)}>
                  {state === 'rejected' ? <X className="h-5 w-5" aria-hidden="true" /> : icon}
                  <span className="portal-band-badge" aria-hidden="true">
                    {state === 'done' ? <Check className="h-3 w-3" strokeWidth={3.5} /> : step.badge ?? index + 1}
                  </span>
                </span>
                <p className="portal-band-heading mt-2.5 text-sm font-semibold leading-snug">
                  {step.heading}
                  {STATE_LABEL[state] ? <span className="sr-only"> ({STATE_LABEL[state]})</span> : null}
                </p>
                {step.owner && step.owner !== step.heading ? (
                  <p className="portal-band-owner mt-0.5 break-words text-xs leading-snug">{step.owner}</p>
                ) : null}
                {(state === 'current' || state === 'rejected') && stage?.caption ? (
                  <span className={cn('portal-band-now', state === 'rejected' && 'portal-band-now--stopped')}>
                    {state === 'current' ? 'Now · ' : ''}
                    {stage.caption}
                  </span>
                ) : null}
              </li>
            )
          })}
        </ol>
      </div>

      {open && details ? (
        <div id={detailsId} className="animate-page-in-subtle rounded-b-xl border-x border-b border-slate-200 bg-teal-50/60 px-4 py-3">
          {details}
        </div>
      ) : null}
    </section>
  )
}
