import { useEffect } from 'react'
import { createPortal } from 'react-dom'
import { ClipboardList, PackageCheck, X } from 'lucide-react'
import { Button } from '@/components/ui/button'
import { StatusBadge } from '@/components/shared/StatusBadge'
import { CardSection, type CardField } from '@/components/facility/BcCard'
import { dateTimeValue, dateValue, pick } from '@/components/facility/bcCardValues'
import { storeRequestFromRequisition, useLprStoreRequisition } from '@/components/facility/lprStoreRequisition'
import { storeOfferLines } from '@/components/facility/storeOfferLines'
import { RequestedSummary } from '@/components/facility/StoreStockPill'

type Row = Record<string, unknown>

const PRIORITY_LABELS: Record<string, string> = { '0': 'Low', '1': 'Normal', '2': 'High', '3': 'Urgent' }

function requestTypeLabel(value: unknown) {
  const raw = pick(value).toLowerCase()
  if (!raw) return ''
  return /asset|^1$/.test(raw) ? 'Fixed Asset' : 'Consumable'
}

/**
 * Store requisition card opened from an LPR, laid out like BC "Store Req Header Approved":
 * General, Issue, Issue Hand-Over and the requested lines. Read-only.
 */
export function StoreRequisitionCardDialog({
  lprRequestId,
  storeRequisitionNo,
  onClose,
}: {
  lprRequestId: string
  storeRequisitionNo: string
  onClose: () => void
}) {
  const query = useLprStoreRequisition(lprRequestId, true)
  useEffect(() => {
    const onKey = (event: KeyboardEvent) => {
      if (event.key === 'Escape') onClose()
    }
    window.addEventListener('keydown', onKey)
    return () => window.removeEventListener('keydown', onKey)
  }, [onClose])

  const request = query.data?.request
  const process = (query.data?.process ?? null) as Row | null
  const payload = (request?.payload ?? {}) as Row
  const links = (process?.links ?? {}) as Row
  const store = request ? storeRequestFromRequisition(request, process) : {}
  const { requestedLines, offers } = request
    ? storeOfferLines(request)
    : { requestedLines: [], offers: [] }

  const general: CardField[] = [
    { label: 'No.', value: pick(store.no) || storeRequisitionNo, emphasis: 'strong' },
    { label: 'Request date', value: dateValue(pick(store.requestDate)) },
    { label: 'Required Date', value: dateValue(pick(store.requiredDate)) },
    { label: 'Division Code', value: pick(store.divisionCode) },
    { label: 'Department Code', value: pick(store.departmentCode) },
    { label: 'Request Description', value: pick(store.requestDescription) },
    { label: 'Purpose / Justification', value: pick(store.purpose), emphasis: 'strong' },
    { label: 'Priority', value: PRIORITY_LABELS[pick(payload.Priority)] ?? pick(payload.Priority) },
    { label: 'Responsibility Center', value: pick(payload.ResponsibilityCenter, payload.Responsibility_Center) },
    { label: 'Status', value: request ? <StatusBadge status={request.status} /> : '' },
    { label: 'Linked LPR No.', value: pick(links.lprNo), emphasis: 'user' },
    { label: 'LPR Requested By', value: pick(store.lprRequestedBy) },
    { label: 'Requester ID', value: pick(store.requesterId), emphasis: 'user' },
    { label: 'Employee No', value: pick(store.employeeNo) },
    { label: 'Approver 1', value: pick(store.approver1), emphasis: 'user' },
    { label: 'Approver 1 Date', value: dateTimeValue(pick(store.approver1Date)) },
    { label: 'Approver 2', value: pick(store.approver2), emphasis: 'user' },
    { label: 'Approver 2 Date', value: dateTimeValue(pick(store.approver2Date)) },
  ]
  const issue: CardField[] = [
    { label: 'Request Type', value: requestTypeLabel(pick(payload.StoreRequisitionType, payload.RequisitionType)) },
    { label: 'Store', value: pick(payload.StoreCode) },
    { label: 'Store Name', value: pick(payload.StoreName) },
    { label: 'Issuing Store', value: pick(store.issuingStore) },
    { label: 'Posting Date', value: dateValue(pick(payload.IssueDate)) },
    { label: 'Store Issue No.', value: pick(payload.StoreIssueNo, payload.Store_Issue_No) },
  ]
  const handOver: CardField[] = [
    { label: 'Issue Stage', value: pick(store.issueStage), emphasis: 'strong' },
    { label: 'Stage', value: pick(process?.stageLabel) },
    { label: 'Prepared By', value: pick(payload.PreparedBy), emphasis: 'user' },
    { label: 'Accepted By', value: pick(payload.AcceptedBy), emphasis: 'user' },
    { label: 'Accepted Date', value: dateTimeValue(pick(payload.AcceptedDateTime)) },
    { label: 'Requester Decision', value: pick(payload.RequesterDecision) },
    { label: 'Received By', value: pick(payload.ReceivedBy), emphasis: 'user' },
    { label: 'Received Date', value: dateTimeValue(pick(payload.ReceivedDateTime)) },
  ]

  return createPortal(
    <div className="fixed inset-0 z-[100] flex items-center justify-center p-2 sm:p-4">
      <button
        type="button"
        aria-label="Close"
        onClick={onClose}
        className="absolute inset-0 bg-slate-900/45 backdrop-blur-sm"
      />
      <div
        role="dialog"
        aria-modal="true"
        aria-label={`Store Requisition ${storeRequisitionNo}`}
        className="relative flex max-h-[92vh] w-[min(96vw,64rem)] flex-col overflow-hidden rounded-2xl border border-slate-200 bg-white shadow-2xl"
      >
        <div className="h-1.5 w-full shrink-0 bg-gradient-to-r from-[var(--portal-navy)] to-[var(--portal-green)]" />
        <div className="flex shrink-0 items-start justify-between gap-3 border-b border-slate-100 px-5 py-4">
          <div className="flex min-w-0 items-start gap-3">
            <span className="flex h-10 w-10 shrink-0 items-center justify-center rounded-full bg-[var(--portal-navy)]/10 text-[var(--portal-navy-dark)]">
              <ClipboardList className="h-5 w-5" />
            </span>
            <div className="min-w-0">
              <p className="text-xs text-slate-500">Store Requisition (opened from the LPR)</p>
              <h2 className="truncate text-xl font-semibold text-slate-900">{storeRequisitionNo}</h2>
            </div>
          </div>
          <button
            type="button"
            onClick={onClose}
            aria-label="Close"
            className="rounded-full p-2 text-slate-500 transition hover:bg-slate-100 hover:text-slate-800"
          >
            <X className="h-5 w-5" />
          </button>
        </div>

        <div className="min-h-0 flex-1 space-y-6 overflow-y-auto px-5 py-5">
          {query.isLoading ? <p className="text-sm text-slate-600">Loading the store requisition from Business Central…</p> : null}
          {query.isError ? (
            <p className="rounded-lg border border-red-200 bg-red-50 px-3 py-2 text-sm text-red-800">
              {query.error instanceof Error ? query.error.message : 'Could not load the store requisition.'}
            </p>
          ) : null}
          {request ? (
            <>
              <CardSection title="General" fields={general} showAll />
              <CardSection title="Issue" fields={issue} showAll />
              <CardSection title="Issue Hand-Over" fields={handOver} showAll />
              <section>
                <h3 className="border-b-2 border-slate-700/80 pb-1.5 text-base font-semibold text-slate-900">Lines</h3>
                <div className="mt-3 grid gap-3 md:grid-cols-2">
                  <div className="rounded-lg border border-dashed border-slate-200 bg-slate-50/70 px-3 py-2.5">
                    <p className="flex items-center gap-1.5 text-[11px] font-semibold uppercase tracking-wide text-slate-500">
                      <ClipboardList className="h-3.5 w-3.5" /> Requested by the employee
                    </p>
                    <div className="mt-1.5">
                      {requestedLines.length ? (
                        <RequestedSummary lines={requestedLines} />
                      ) : (
                        <p className="text-sm text-slate-500">—</p>
                      )}
                    </div>
                  </div>
                  <div className="rounded-lg border border-slate-200 px-3 py-2.5">
                    <p className="flex items-center gap-1.5 text-[11px] font-semibold uppercase tracking-wide text-slate-500">
                      <PackageCheck className="h-3.5 w-3.5" /> Offered by the store
                    </p>
                    <div className="mt-1.5">
                      {offers.length ? (
                        <RequestedSummary
                          lines={offers.map((offer) => ({
                            key: offer.lineNo,
                            itemName: [offer.itemName, offer.itemNo].filter(Boolean).join(' · '),
                            details: offer.specification,
                            brand: offer.brandModel,
                            unitOfMeasure: offer.unitOfMeasure,
                            quantity: offer.quantity,
                          }))}
                        />
                      ) : (
                        <p className="text-sm text-slate-500">No store offer — the item is bought through this LPR.</p>
                      )}
                    </div>
                  </div>
                </div>
              </section>
            </>
          ) : null}
        </div>

        <div className="flex shrink-0 justify-end border-t border-slate-100 bg-slate-50/70 px-5 py-3">
          <Button type="button" variant="outline" onClick={onClose}>
            Close
          </Button>
        </div>
      </div>
    </div>,
    document.body,
  )
}
