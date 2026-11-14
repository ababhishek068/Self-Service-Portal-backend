import { Calculator, FileCheck2, FileSearch, ListPlus, Send } from 'lucide-react'
import { ProcessTracker, type TrackerStep } from '@/components/shared/ProcessTracker'
import type { ProcessStage } from '@/data/processStages'
import { SETTLEMENT_SCENARIOS, settlementMissing, useAdvanceSettlementContext } from '@/hooks/useAdvanceSettlementContext'
import type { AdvanceSettlementContext } from '@/api/endpoints/advanceSettlement'
import type { PortalRequest } from '@/types/erp.types'
import { formatAmount } from '@/utils/formatters'

/** ESSP spec section 5 — the Advance Settlement process flow. */
function steps(request: PortalRequest | null, ctx: AdvanceSettlementContext | undefined): TrackerStep[] {
  const outcome = ctx?.settlementOutcome ? SETTLEMENT_SCENARIOS[ctx.settlementOutcome] : undefined
  const advanceNo = ctx?.advanceNo || ctx?.advance?.advanceNo
  return [
    {
      key: 'select',
      heading: 'Select Original Advance',
      owner: advanceNo ? `Advance ${advanceNo}` : 'Approved & paid only',
      icon: FileSearch,
    },
    {
      key: 'expenses',
      heading: 'Actual Expenses & Documents',
      owner: ctx && ctx.totalActualExpenses > 0 ? `${formatAmount(ctx.totalActualExpenses)} entered` : 'Enter & attach',
      icon: ListPlus,
    },
    {
      key: 'outcome',
      heading: 'Settlement Outcome',
      owner: outcome ? `${outcome.letter}. ${outcome.title}` : 'Calculated by the system',
      icon: Calculator,
    },
    {
      key: 'submit',
      heading: 'Processing in Business Central',
      owner: request && request.status !== 'Draft' ? 'Finance approval' : 'Submit for Processing',
      icon: Send,
    },
    {
      key: 'status',
      heading: 'Settlement Status & Reference',
      owner: request?.requestNo ? `Settlement ${request.requestNo}` : 'Shown here in ESSP',
      icon: FileCheck2,
    },
  ]
}

function stageOf(request: PortalRequest | null, ctx: AdvanceSettlementContext | undefined): ProcessStage | undefined {
  if (!request) return { index: 0, state: 'active', caption: 'Select the approved and paid advance' }
  const status = request.status.trim().toLowerCase()
  if (status === 'posted' || status === 'completed' || status === 'closed') return { index: 5, state: 'active' }
  if (status === 'approved') return { index: 4, state: 'active', caption: 'Approved · Finance finalizes the reconciliation' }
  if (status.includes('reject')) return { index: 3, state: 'rejected', caption: 'Rejected' }
  if (status.includes('cancel')) return { index: 3, state: 'cancelled', caption: 'Cancelled' }
  if (status.includes('pending') || status === 'submitted') return { index: 3, state: 'active', caption: 'Pending approval in Business Central' }
  if (!ctx) return undefined
  if (!(ctx.totalActualExpenses > 0)) return { index: 1, state: 'active', caption: 'Enter the actual expenses' }
  const missing = settlementMissing(ctx)
  if (missing.length) return { index: 2, state: 'active', caption: 'Complete the settlement details' }
  return { index: 3, state: 'active', caption: 'Ready · Submit for Processing' }
}

/**
 * The live Advance Settlement process (spec section 5) at the very top of the form and the document:
 * Select advance → Actual expenses → Outcome → Processing in BC → Status & reference.
 */
export function AdvanceSettlementProcessBanner({ request }: { request: PortalRequest | null }) {
  const contextQuery = useAdvanceSettlementContext(request)
  const ctx = contextQuery.data?.surrenderNo ? contextQuery.data : undefined
  return (
    <ProcessTracker
      title="Advance Settlement Process"
      steps={steps(request, ctx)}
      stage={stageOf(request, ctx)}
    />
  )
}
