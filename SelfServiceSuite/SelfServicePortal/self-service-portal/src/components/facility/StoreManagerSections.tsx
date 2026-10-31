import { useQuery } from '@tanstack/react-query'
import type { ReactNode } from 'react'
import { ArrowRight, BadgeCheck, CheckCircle2, ClipboardList, Globe2, MapPin, PackageSearch, PencilLine, ShoppingCart, UserCheck } from 'lucide-react'
import { Button } from '@/components/ui/button'
import { Select } from '@/components/ui/select'
import { getLocalPurchaseProjects, type LprOfficers } from '@/api/endpoints/requestEndpoint'
import { cn } from '@/lib/utils'
import type { PortalRequest } from '@/types/erp.types'
import { quantityLabel, storeOfferLines, text } from './storeOfferLines'
import { RequestedSummary, StoreStockPill } from './StoreStockPill'
import { StatusNotice } from '@/components/feedback/StatusNotice'

function CardShell({
  icon,
  title,
  subtitle,
  badge,
  children,
  footer,
}: {
  icon: ReactNode
  title: string
  subtitle: string
  badge?: ReactNode
  children: ReactNode
  footer: ReactNode
}) {
  return (
    <div className="mt-4 overflow-hidden rounded-xl border border-[var(--portal-card-border)] bg-white shadow-sm">
      <div className="flex flex-wrap items-start justify-between gap-3 border-b border-slate-100 bg-gradient-to-r from-teal-50 via-white to-white px-4 py-3">
        <div className="flex items-start gap-3">
          <span className="flex h-9 w-9 shrink-0 items-center justify-center rounded-full bg-[var(--portal-navy)]/10 text-[var(--portal-navy-dark)]">
            {icon}
          </span>
          <div>
            <p className="text-sm font-semibold text-slate-900">{title}</p>
            <p className="text-xs text-slate-500">{subtitle}</p>
          </div>
        </div>
        {badge}
      </div>
      <div className="space-y-4 px-4 py-4">{children}</div>
      <div className="flex flex-wrap items-center justify-between gap-3 border-t border-slate-100 bg-slate-50/70 px-4 py-3">
        {footer}
      </div>
    </div>
  )
}

function SectionLabel({ icon, children }: { icon: ReactNode; children: ReactNode }) {
  return (
    <p className="flex items-center gap-1.5 text-[11px] font-semibold uppercase tracking-wide text-slate-500">
      {icon}
      {children}
    </p>
  )
}

/**
 * Store Manager on a prepared issue (BC Store Req Header Approved → Accept Item (Store Manager)):
 * what the employee asked for next to what the store keeper offers, then accept.
 */
export function StoreManagerReviewCard({
  request,
  available,
  storeName,
  canAccept,
  busy,
  onAccept,
  onChangeItem,
}: {
  request: PortalRequest
  /** Stock at the issuing store per offered item No. */
  available: Record<string, number>
  storeName: string
  /** BC 1.0.3.544+ accepts from the portal; older apps accept on the BC card. */
  canAccept: boolean
  busy: boolean
  onAccept: () => void
  onChangeItem: () => void
}) {
  const { offers, requestedLines } = storeOfferLines(request)
  const preparedBy = text(request.payload?.PreparedBy ?? request.payload?.Prepared_By)
  const shortItems = offers.filter((offer) => {
    // An asset card is not stock: it is in the store or BC refuses the offer.
    if (offer.isAsset) return false
    const onHand = available[offer.itemNo.toUpperCase()]
    return onHand !== undefined && onHand < offer.quantity
  })

  return (
    <CardShell
      icon={<BadgeCheck className="h-4 w-4" />}
      title="Review the store offer"
      subtitle={`${preparedBy ? `Prepared by ${preparedBy}` : 'Prepared by the store keeper'}${storeName ? ` · ${storeName}` : ''}. Accepting creates no voucher yet.`}
      badge={
        <span className="rounded-full bg-amber-50 px-2.5 py-1 text-[11px] font-semibold text-amber-800 ring-1 ring-amber-200">
          Waiting for you
        </span>
      }
      footer={
        <>
          <StatusNotice className="min-w-[16rem] flex-1">
            {canAccept
              ? 'After you accept, the requester checks the Item Borrowing Form and accepts or declines the item.'
              : 'Accept in Business Central: Store Req Header Approved → Accept Item (Store Manager).'}
          </StatusNotice>
          <div className="flex flex-wrap items-center gap-2">
            <Button type="button" variant="outline" disabled={busy} onClick={onChangeItem}>
              <PencilLine className="h-4 w-4" /> Change the item
            </Button>
            {canAccept ? (
              <Button type="button" variant="gradient" disabled={busy || offers.length === 0} onClick={onAccept}>
                <CheckCircle2 className="h-4 w-4" /> Accept Item (Store Manager)
              </Button>
            ) : null}
          </div>
        </>
      }
    >
      <div className="grid items-stretch gap-3 md:grid-cols-[1fr_auto_1fr]">
        <div className="rounded-lg border border-dashed border-slate-200 bg-slate-50/70 px-3 py-2.5">
          <SectionLabel icon={<ClipboardList className="h-3.5 w-3.5" />}>Requested by the employee</SectionLabel>
          <div className="mt-1.5">
            <RequestedSummary lines={requestedLines} />
          </div>
        </div>
        <div className="hidden items-center justify-center text-slate-300 md:flex">
          <ArrowRight className="h-5 w-5" />
        </div>
        <div className="rounded-lg border border-emerald-200 bg-emerald-50/40 px-3 py-2.5">
          <SectionLabel icon={<PackageSearch className="h-3.5 w-3.5" />}>Offered by the store keeper</SectionLabel>
          {offers.length ? (
            <ul className="mt-1.5 space-y-2">
              {offers.map((offer) => {
                const onHand = offer.isAsset ? undefined : available[offer.itemNo.toUpperCase()]
                return (
                  <li key={offer.lineNo} className="text-sm text-slate-800">
                    <div className="flex flex-wrap items-center gap-2">
                      <span className="font-semibold">{offer.itemName || offer.itemNo}</span>
                      <span className="font-mono text-[11px] text-slate-500">{offer.itemNo}</span>
                      {offer.isAsset ? (
                        <span className="rounded bg-sky-100 px-1.5 py-0.5 text-[10px] font-semibold text-sky-800">Asset</span>
                      ) : null}
                      {onHand !== undefined ? (
                        <StoreStockPill atStore={onHand} unit={offer.unitOfMeasure} low={onHand < offer.quantity} />
                      ) : null}
                    </div>
                    <p className="text-xs text-slate-500">
                      {offer.isAsset
                        ? 'One asset card; the requester becomes its custodian'
                        : `Issue ${quantityLabel(offer.quantity)} ${offer.unitOfMeasure}`}
                      {offer.brandModel ? ` · ${offer.brandModel}` : ''}
                    </p>
                    {offer.specification ? <p className="text-xs text-slate-500">{offer.specification}</p> : null}
                  </li>
                )
              })}
            </ul>
          ) : (
            <p className="mt-1.5 text-sm text-slate-500">No item offered.</p>
          )}
        </div>
      </div>
      {shortItems.length ? (
        <StatusNotice tone="warning" className="">
          Not enough stock for {shortItems.map((offer) => offer.itemNo).join(', ')}. Ask the store keeper to change the item,
          or use Request for LPR.
        </StatusNotice>
      ) : null}
    </CardShell>
  )
}

type OfficerKind = 'PROCUREMENT' | 'PROJECT'

/**
 * Store Manager: Start Local Purchase (LPR) with the BC card prompts — source, project, then the
 * procurement officer — and a summary of who handles it next.
 */
export function StartLprCard({
  requestNo,
  requesterId,
  request,
  showChoices,
  officers,
  source,
  onSourceChange,
  projectNo,
  onProjectChange,
  officerKind,
  onOfficerChange,
  busy,
  onStart,
}: {
  requestNo: string
  requesterId: string
  request: PortalRequest
  /** BC 1.0.3.544+: Local / Foreign and the officer can be chosen; older apps follow the project. */
  showChoices: boolean
  officers: LprOfficers | null
  source: 'LOCAL' | 'FOREIGN'
  onSourceChange: (source: 'LOCAL' | 'FOREIGN') => void
  projectNo: string
  onProjectChange: (projectNo: string) => void
  officerKind: OfficerKind
  onOfficerChange: (kind: OfficerKind) => void
  busy: boolean
  onStart: () => void
}) {
  const { requestedLines } = storeOfferLines(request)
  const projectsQuery = useQuery({
    queryKey: ['local-purchase', 'projects'],
    queryFn: getLocalPurchaseProjects,
    retry: false,
    staleTime: 5 * 60_000,
  })
  const projects = projectsQuery.data?.projects ?? []
  const projectLabel = projectNo
    ? (() => {
        const project = projects.find((row) => row.no === projectNo)
        return project?.description ? `${projectNo} — ${project.description}` : projectNo
      })()
    : 'Non-project'
  const officerOptions: Array<{ kind: OfficerKind; title: string; userId: string; note: string }> = [
    {
      kind: 'PROCUREMENT',
      title: 'Procurement Officer',
      userId: officers?.procurementOfficer ?? '',
      note: projectNo ? 'Optional for a project purchase' : 'Default for a non-project purchase',
    },
    {
      kind: 'PROJECT',
      title: 'Project Procurement Officer',
      userId: officers?.projectProcurementOfficer ?? '',
      note: projectNo ? 'Default for a project purchase' : 'Needs a project',
    },
  ]
  const chosenOfficer = officerOptions.find((option) => option.kind === officerKind)

  const sourceOptions = [
    { value: 'LOCAL' as const, title: 'Local', note: 'Inhouse Local', icon: <MapPin className="h-4 w-4" /> },
    { value: 'FOREIGN' as const, title: 'Foreign', note: 'Inhouse / Salable Foreign', icon: <Globe2 className="h-4 w-4" /> },
  ]

  return (
    <CardShell
      icon={<ShoppingCart className="h-4 w-4" />}
      title="Start Local Purchase (LPR)"
      subtitle={`Not in store — store requisition ${requestNo}${requesterId ? ` for ${requesterId}` : ''} needs a local purchase.`}
      badge={
        <span className="rounded-full bg-amber-50 px-2.5 py-1 text-[11px] font-semibold text-amber-800 ring-1 ring-amber-200">
          Waiting for you
        </span>
      }
      footer={
        <>
          <p className="text-xs text-slate-600">
            <span className="font-semibold text-slate-700">{source === 'FOREIGN' ? 'Foreign' : 'Local'}</span> ·{' '}
            {projectLabel} ·{' '}
            <span className="font-semibold text-slate-700">
              {chosenOfficer?.title}
              {chosenOfficer?.userId ? ` ${chosenOfficer.userId}` : ''}
            </span>{' '}
            prepares it → {officers?.operationsManager ? `Operations Manager ${officers.operationsManager}` : 'Operations Manager'} → FAD
          </p>
          <Button type="button" variant="gradient" disabled={busy} onClick={onStart}>
            <ShoppingCart className="h-4 w-4" /> Start Local Purchase (LPR)
          </Button>
        </>
      }
    >
      {requestedLines.length ? (
        <div className="rounded-lg border border-dashed border-slate-200 bg-slate-50/70 px-3 py-2.5">
          <SectionLabel icon={<ClipboardList className="h-3.5 w-3.5" />}>To buy for the employee</SectionLabel>
          <div className="mt-1.5">
            <RequestedSummary lines={requestedLines} />
          </div>
        </div>
      ) : null}

      <div className={cn('grid gap-4', showChoices ? 'lg:grid-cols-3' : 'lg:grid-cols-1')}>
        {showChoices ? (
          <fieldset className="space-y-2">
            <legend className="mb-2 text-xs font-semibold text-slate-700">
              <span className="mr-1.5 inline-flex h-5 w-5 items-center justify-center rounded-full bg-[var(--portal-navy)] text-[11px] text-white">1</span>
              Source
            </legend>
            <div className="grid grid-cols-2 gap-2">
              {sourceOptions.map((option) => {
                const active = source === option.value
                return (
                  <button
                    key={option.value}
                    type="button"
                    disabled={busy}
                    onClick={() => onSourceChange(option.value)}
                    className={cn(
                      'flex flex-col items-start gap-1 rounded-lg border p-2.5 text-left transition',
                      active
                        ? 'border-[var(--portal-navy)] bg-teal-50/70 ring-2 ring-[var(--portal-navy)]/20'
                        : 'border-slate-200 bg-white hover:border-teal-300',
                    )}
                  >
                    <span className={cn('flex items-center gap-1.5 text-sm font-semibold', active ? 'text-[var(--portal-navy-dark)]' : 'text-slate-800')}>
                      {option.icon}
                      {option.title}
                    </span>
                    <span className="text-[11px] text-slate-500">{option.note}</span>
                  </button>
                )
              })}
            </div>
          </fieldset>
        ) : null}

        <div className="space-y-2">
          <p className="mb-2 text-xs font-semibold text-slate-700">
            <span className="mr-1.5 inline-flex h-5 w-5 items-center justify-center rounded-full bg-[var(--portal-navy)] text-[11px] text-white">
              {showChoices ? 2 : 1}
            </span>
            Project
          </p>
          <Select
            id={`lpr-project-${requestNo}`}
            options={[
              { value: '', label: 'Non-project purchase' },
              ...projects.map((project) => ({
                value: project.no,
                label: project.description ? `${project.no} — ${project.description}` : project.no,
              })),
            ]}
            value={projectNo}
            placeholder={projectsQuery.isLoading ? 'Loading projects…' : 'Non-project purchase'}
            onChange={(event) => onProjectChange(event.target.value)}
            disabled={busy || projectsQuery.isLoading}
          />
          {projectsQuery.isError ? (
            <p className="text-xs text-red-700">Could not load projects from Business Central.</p>
          ) : (
            <p className="text-[11px] text-slate-500">A project purchase goes to the Project Procurement Officer.</p>
          )}
        </div>

        {showChoices ? (
          <fieldset className="space-y-2">
            <legend className="mb-2 text-xs font-semibold text-slate-700">
              <span className="mr-1.5 inline-flex h-5 w-5 items-center justify-center rounded-full bg-[var(--portal-navy)] text-[11px] text-white">3</span>
              Procurement officer
            </legend>
            <div className="space-y-2">
              {officerOptions.map((option) => {
                const active = officerKind === option.kind
                const blocked = option.kind === 'PROJECT' && !projectNo
                return (
                  <button
                    key={option.kind}
                    type="button"
                    disabled={busy || blocked}
                    onClick={() => onOfficerChange(option.kind)}
                    className={cn(
                      'flex w-full items-center gap-2.5 rounded-lg border p-2.5 text-left transition',
                      active
                        ? 'border-[var(--portal-navy)] bg-teal-50/70 ring-2 ring-[var(--portal-navy)]/20'
                        : blocked
                          ? 'cursor-not-allowed border-slate-100 bg-slate-50 opacity-60'
                          : 'border-slate-200 bg-white hover:border-teal-300',
                    )}
                  >
                    <UserCheck className={cn('h-4 w-4 shrink-0', active ? 'text-[var(--portal-navy)]' : 'text-slate-400')} />
                    <span className="min-w-0">
                      <span className="block text-sm font-semibold text-slate-800">
                        {option.title}
                        {option.userId ? <span className="ml-1.5 font-mono text-[11px] font-normal text-slate-500">{option.userId}</span> : null}
                      </span>
                      <span className="block text-[11px] text-slate-500">{option.note}</span>
                    </span>
                  </button>
                )
              })}
            </div>
          </fieldset>
        ) : null}
      </div>
    </CardShell>
  )
}
