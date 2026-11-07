import { useState } from 'react'
import { useQuery } from '@tanstack/react-query'
import { CheckCircle2, Store, Warehouse } from 'lucide-react'
import { Button } from '@/components/ui/button'
import { CardEditor } from '@/components/facility/BcCard'
import { StatusNotice } from '@/components/feedback/StatusNotice'
import { useConfirm } from '@/components/feedback/ConfirmProvider'
import { PoReceiveItemSetup } from '@/components/facility/PoReceiveItemSetup'
import { getLprReceivingStores } from '@/api/endpoints/requestEndpoint'
import type { PurchaseLine } from '@/components/facility/bcPurchaseLines'
import { cn } from '@/lib/utils'

function text(value: unknown) {
  return String(value ?? '').trim()
}

function StepBadge({ index, done, active }: { index: number; done: boolean; active: boolean }) {
  return (
    <span
      className={cn(
        'flex h-7 w-7 shrink-0 items-center justify-center rounded-full text-xs font-bold',
        done ? 'bg-emerald-600 text-white' : active ? 'bg-[var(--portal-navy)] text-white' : 'bg-slate-200 text-slate-600',
      )}
    >
      {done ? <CheckCircle2 className="h-4 w-4" /> : index}
    </span>
  )
}

/**
 * Store Manager, after FAD approves a Local PO (BC 1.0.3.613): 1. assign the store the goods are
 * received into (ASSIGN_STORE), 2. set up the new items bought by name (SET_RECEIVE_ITEM), 3. confirm
 * (CONFIRM_STORE). Only then can the store keeper prepare and post the receipt.
 */
export function PoAssignStore({
  poNo,
  po,
  lines,
  busy,
  onAction,
  onSaveItem,
}: {
  poNo: string
  po: Record<string, unknown>
  lines: PurchaseLine[]
  busy: boolean
  onAction: (actionCode: 'ASSIGN_STORE' | 'CONFIRM_STORE', payload: Record<string, unknown>, success: string) => Promise<boolean>
  onSaveItem: (payload: Record<string, unknown>) => Promise<boolean>
}) {
  const confirm = useConfirm()
  const storesQuery = useQuery({
    queryKey: ['local-purchase', 'receiving-stores'],
    queryFn: getLprReceivingStores,
    staleTime: 5 * 60_000,
    retry: false,
  })
  const stores = (storesQuery.data?.stores ?? []).filter((store) => store.allowReceive)
  const current = text(po.locationCode)
  const [chosen, setChosen] = useState('')
  // The store assigned in this visit; after a reload Assign Store is pressed again (BC repeats it safely).
  const [assignedTo, setAssignedTo] = useState('')
  const selected = chosen || (stores.some((store) => store.locationCode === current) ? current : '')
  const pending = lines.filter((line) => String(line.needsItemSetup).toLowerCase() === 'true')
  const assigned = Boolean(assignedTo) && assignedTo === selected
  const storeName = (code: string) => {
    const store = stores.find((entry) => entry.locationCode === code)
    return store ? `${store.name || store.storeCode} (${store.locationCode})` : code
  }

  const assign = async () => {
    if (!selected) return
    const yes = await confirm({
      title: 'Assign Store',
      message: `Receive the goods of ${poNo} into ${storeName(selected)}? Items bought by name become items of that store.`,
      confirmLabel: 'Assign Store',
    })
    if (!yes) return
    const ok = await onAction('ASSIGN_STORE', { locationCode: selected }, `${storeName(selected)} assigned to ${poNo}.`)
    if (ok) setAssignedTo(selected)
  }

  const confirmStore = async () => {
    const yes = await confirm({
      title: 'Confirm Store',
      message: `Confirm ${storeName(selected)} for ${poNo}? The store keeper can then prepare and post the receipt (GRN), and the store requisition issues from this store.`,
      confirmLabel: 'Confirm Store',
    })
    if (!yes) return
    await onAction(
      'CONFIRM_STORE',
      {},
      `Store confirmed for ${poNo}. The store keeper can now receive the goods.`,
    )
  }

  const storeOptions = [
    { value: '', label: storesQuery.isLoading ? 'Loading the stores…' : 'Choose the receiving store' },
    ...(selected && !stores.some((store) => store.locationCode === selected) ? [{ value: selected, label: selected }] : []),
    ...stores.map((store) => ({
      value: store.locationCode,
      label: `${store.name || store.storeCode} (${store.locationCode})${store.centralStore ? ' · central store' : ''}`,
    })),
  ]

  return (
    <section className="mt-4 rounded-xl border border-[var(--portal-navy)]/20 bg-[var(--portal-navy)]/[0.03] p-4">
      <div className="flex items-start gap-3">
        <Warehouse className="mt-0.5 h-5 w-5 shrink-0 text-[var(--portal-navy)]" />
        <div className="min-w-0">
          <p className="text-sm font-semibold text-slate-900">Assign Store (Store Manager) · {poNo}</p>
          <p className="mt-0.5 text-xs text-slate-600">
            FAD approved this purchase order. Choose the store the goods go into, set up any new items, then confirm. The store
            keeper can receive the goods only after you confirm.
          </p>
        </div>
      </div>

      {storesQuery.data && !storesQuery.data.available ? (
        <StatusNotice tone="attention" className="mt-3">
          <p>The store list could not be read from Business Central.</p>
          <p className="mt-1 text-xs font-normal">
            {storesQuery.data.message || 'This needs Business Central 1.0.3.613.'} You can also assign the store in Business Central:
            Purchase Order {poNo} → Assign Store (Store Manager).
          </p>
        </StatusNotice>
      ) : null}

      <ol className="mt-4 space-y-4">
        <li className="flex gap-3">
          <StepBadge index={1} done={assigned} active={!assigned} />
          <div className="min-w-0 flex-1">
            <p className="text-sm font-medium text-slate-900">Receiving store</p>
            <div className="mt-2 flex flex-wrap items-center gap-2">
              <div className="w-full max-w-md">
                <CardEditor
                  kind="select"
                  label="Receiving store"
                  options={storeOptions}
                  value={selected}
                  disabled={busy || storesQuery.isLoading}
                  onChange={(value) => setChosen(value)}
                />
              </div>
              <Button type="button" size="sm" variant={assigned ? 'outline' : 'gradient'} disabled={busy || !selected} onClick={() => void assign()}>
                <Store className="mr-1.5 h-4 w-4" />
                {assigned ? 'Assign again' : 'Assign Store'}
              </Button>
            </div>
            <p className="mt-1 text-xs text-slate-500">
              {assigned
                ? `Assigned: ${storeName(assignedTo)}.`
                : current
                  ? `The PO now says ${storeName(current)}. Press Assign Store to use it, or choose another store.`
                  : 'Press Assign Store after choosing the store.'}
            </p>
          </div>
        </li>

        <li className="flex gap-3">
          <StepBadge index={2} done={assigned && pending.length === 0} active={assigned && pending.length > 0} />
          <div className="min-w-0 flex-1">
            <p className="text-sm font-medium text-slate-900">New items</p>
            {!assigned ? (
              <p className="mt-1 text-xs text-slate-500">Shown after the store is assigned: lines bought by name become items of that store.</p>
            ) : pending.length ? (
              <PoReceiveItemSetup poNo={poNo} lines={lines} busy={busy} onSave={onSaveItem} embedded />
            ) : (
              <p className="mt-1 text-xs text-emerald-700">Every line is an item of the store. Nothing to set up.</p>
            )}
          </div>
        </li>

        <li className="flex gap-3">
          <StepBadge index={3} done={false} active={assigned && pending.length === 0} />
          <div className="min-w-0 flex-1">
            <p className="text-sm font-medium text-slate-900">Confirm</p>
            <div className="mt-2 flex flex-wrap items-center gap-2">
              <Button
                type="button"
                size="sm"
                variant="gradient"
                disabled={busy || !assigned || pending.length > 0}
                onClick={() => void confirmStore()}
              >
                <CheckCircle2 className="mr-1.5 h-4 w-4" />
                Confirm Store
              </Button>
              <span className="text-xs text-slate-500">
                {!assigned
                  ? 'Assign the store first.'
                  : pending.length
                    ? `Set up ${pending.length} new item${pending.length === 1 ? '' : 's'} first.`
                    : 'Ready: the store keeper receives once you confirm.'}
              </span>
            </div>
          </div>
        </li>
      </ol>
    </section>
  )
}
