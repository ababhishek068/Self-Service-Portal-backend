import { Calculator, FileSearch, ListPlus, Paperclip, Send } from 'lucide-react'
import { ProcessTracker, type TrackerStep } from '@/components/shared/ProcessTracker'
import type { ProcessStage } from '@/data/processStages'
import { SETTLEMENT_SCENARIOS, settlementMissing, useAdvanceSettlementContext } from '@/hooks/useAdvanceSettlementContext'
import type { AdvanceSettlementContext } from '@/api/endpoints/advanceSettlement'
import type { PortalRequest } from '@/types/erp.types'
import { formatAmount } from '@/utils/formatters'

/**
 * The client's recommended workflow (16 Nov 2026): Advance Summary → Expense Entries → Supporting Documents →
 * Reconciliation → Submit for Processing.
 */
function steps(request: PortalRequest | null, ctx: AdvanceSettlementContext | undefined): TrackerStep[] {
  const outcome = ctx?.settlementOutcome ? SETTLEMENT_SCENARIOS[ctx.settlementOutcome] : undefined
  const advanceNo = ctx?.advanceNo || ctx?.advance?.advanceNo
  const documents = request?.attachments?.length ?? 0
  const status = request?.status.trim().toLowerCase() ?? ''
  return [
    {
      key: 'summary',
      heading: 'Advance Summary',
      owner: advanceNo ? `Advance ${advanceNo}` : 'Approved and paid advance',
      icon: FileSearch,
    },
    {
      key: 'expenses',
      heading: 'Expense Entries',
      owner: ctx && ctx.totalActualExpenses > 0 ? `${formatAmount(ctx.totalActualExpenses)} entered` : 'Add each expense',
      icon: ListPlus,
    },
    {
      key: 'documents',
      heading: 'Supporting Documents',
      owner: documents ? `${documents} attached` : 'Receipts and evidence',
      icon: Paperclip,
    },
    {
      key: 'reconciliation',
      heading: 'Reconciliation',
      owner: outcome ? `${outcome.letter}. ${outcome.title}` : 'Calculated automatically',
      icon: Calculator,
    },
    {
      key: 'submit',
      heading: 'Submit for Processing',
      owner:
        status === 'posted' || status === 'completed' || status === 'closed'
          ? `Settled · ${request?.requestNo ?? ''}`
          : request && status !== 'draft'
            ? 'Business Central review'
            : 'Declaration and submit',
      icon: Send,
    },
  ]
}

function stageOf(request: PortalRequest | null, ctx: AdvanceSettlementContext | undefined): ProcessStage | undefined {
  if (!request) return { index: 0, state: 'active', caption: 'Select the approved and paid advance' }
  const status = request.status.trim().toLowerCase()
  if (status === 'posted' || status === 'completed' || status === 'closed') return { index: 5, state: 'active' }
  if (status === 'approved') return { index: 4, state: 'active', caption: 'Approved · Finance finalizes the reconciliation' }
  if (status.includes('reject')) return { index: 4, state: 'rejected', caption: 'Rejected' }
  if (status.includes('cancel')) return { index: 4, state: 'cancelled', caption: 'Cancelled' }
  if (status.includes('pending') || status === 'submitted') return { index: 4, state: 'active', caption: 'Pending approval in Business Central' }
  if (!ctx) return undefined
  if (!(ctx.totalActualExpenses > 0)) return { index: 1, state: 'active', caption: 'Add the expense entries' }
  if (!(request.attachments?.length ?? 0)) return { index: 2, state: 'active', caption: 'Attach the receipts' }
  if (settlementMissing(ctx).length) return { index: 3, state: 'active', caption: 'Complete the settlement details' }
  return { index: 4, state: 'active', caption: 'Ready · Submit for Processing' }
}

/**
 * The live Advance Settlement process at the very top of the form and the document: Advance Summary → Expense
 * Entries → Supporting Documents → Reconciliation → Submit for Processing.
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
