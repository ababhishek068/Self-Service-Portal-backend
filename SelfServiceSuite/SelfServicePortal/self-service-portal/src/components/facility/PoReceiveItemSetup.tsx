import { useState } from 'react'
import { useQuery } from '@tanstack/react-query'
import { Button } from '@/components/ui/button'
import { CardEditor } from '@/components/facility/BcCard'
import { LookupCombobox } from '@/components/shared/LookupCombobox'
import { StatusNotice } from '@/components/feedback/StatusNotice'
import { useLookupOptions } from '@/hooks/useLookupOptions'
import { getReceiveItemOptions } from '@/api/endpoints/requestEndpoint'
import { pick, text } from '@/components/facility/bcCardValues'
import type { PurchaseLine } from '@/components/facility/bcPurchaseLines'

type LineDraft = {
  mode: 'existing' | 'new'
  existingItemNo: string
  itemCategoryCode: string
  itemSubCategory: string
  vatProdPostingGroup: string
  faPostingGroup: string
  newItemCode: string
}

const BLANK: LineDraft = {
  mode: 'new',
  existingItemNo: '',
  itemCategoryCode: '',
  itemSubCategory: '',
  vatProdPostingGroup: '',
  faPostingGroup: '',
  newItemCode: '',
}

function isTrue(value: unknown) {
  return String(value).toLowerCase() === 'true'
}

/**
 * Store keeper, before Post Receive (BC SET_RECEIVE_ITEM): an LPR line bought by name becomes an
 * existing store item, or a new item with its category, sub-category and VAT; a fixed asset line
 * becomes one FA card per unit (category with Finance Class Fixed Asset, FA posting group).
 */
export function PoReceiveItemSetup({
  poNo,
  lines,
  busy,
  onSave,
}: {
  poNo: string
  lines: PurchaseLine[]
  busy: boolean
  onSave: (payload: Record<string, unknown>) => Promise<boolean>
}) {
  const optionsQuery = useQuery({
    queryKey: ['local-purchase', 'receive-item-options'],
    queryFn: getReceiveItemOptions,
    staleTime: 5 * 60_000,
    retry: false,
  })
  const items = useLookupOptions('items')
  const [drafts, setDrafts] = useState<Record<string, LineDraft>>({})
  const pending = lines.filter((line) => isTrue(line.needsItemSetup))
  if (!pending.length) return null
  const options = optionsQuery.data

  if (!optionsQuery.isLoading && !options?.available) {
    return (
      <StatusNotice tone="attention" className="">
        <p>
          Set the item before receiving on{' '}
          {pending.map((line) => `line ${text(line.lineNo)} (${pick(line.bcDescription, line.bcNo)})`).join(', ')}. Post
          Receive is blocked until it is set.
        </p>
        <p className="mt-1 text-xs font-normal">
          This Business Central does not send the lists to the portal yet (1.0.3.593). Set it in Business Central:
          Purchase Order {poNo} → Prepare Local Receive.
        </p>
      </StatusNotice>
    )
  }

  const categoryOptions = [
    { value: '', label: 'Choose the item category' },
    ...(options?.itemCategories ?? []).map((category) => ({
      value: category.code,
      label: [category.code, category.description, category.financeClass.trim() ? `(${category.financeClass})` : '']
        .filter(Boolean)
        .join(' — '),
    })),
  ]
  const vatOptions = [
    { value: '', label: 'Choose the VAT group' },
    ...(options?.vatProdPostingGroups ?? []).map((group) => ({
      value: group.code,
      label: group.description ? `${group.code} — ${group.description}` : group.code,
    })),
  ]
  const faOptions = [
    { value: '', label: 'From the item category' },
    ...(options?.faPostingGroups ?? []).map((group) => ({ value: group.code, label: group.code })),
  ]

  return (
    <section className="mt-4 rounded-lg border border-amber-200 bg-amber-50/60 p-4">
      <p className="text-sm font-semibold text-amber-900">Set the item before receiving ({poNo})</p>
      <p className="mt-0.5 text-xs text-amber-900/80">
        Pick an existing store item, or give the new item its category, sub-category and VAT. A fixed asset becomes
        one asset card per unit. Post Receive is possible once every line is set.
      </p>
      <ul className="mt-3 space-y-4">
        {pending.map((line) => {
          const lineNo = text(line.lineNo)
          const draft = drafts[lineNo] ?? BLANK
          const setDraft = (change: Partial<LineDraft>) =>
            setDrafts((all) => ({ ...all, [lineNo]: { ...(all[lineNo] ?? BLANK), ...change } }))
          const category = options?.itemCategories.find((entry) => entry.code === draft.itemCategoryCode)
          const fixedAsset = isTrue(line.isFixedAsset) || /fixed asset/i.test(category?.financeClass ?? '')
          const subCategoryOptions = [
            { value: '', label: fixedAsset ? 'Choose the sub-category' : 'No sub-category' },
            ...(options?.itemSubCategories ?? [])
              .filter((sub) => sub.categoryCode === draft.itemCategoryCode)
              .map((sub) => ({ value: sub.code, label: sub.description ? `${sub.code} — ${sub.description}` : sub.code })),
          ]
          const missing =
            draft.mode === 'existing'
              ? !draft.existingItemNo.trim()
              : !draft.itemCategoryCode || !draft.vatProdPostingGroup || (fixedAsset && !draft.itemSubCategory)
          const save = () => {
            const payload =
              draft.mode === 'existing'
                ? { lineNo: Number(line.lineNo), existingItemNo: draft.existingItemNo.trim() }
                : {
                    lineNo: Number(line.lineNo),
                    itemCategoryCode: draft.itemCategoryCode,
                    ...(draft.itemSubCategory ? { itemSubCategory: draft.itemSubCategory } : {}),
                    vatProdPostingGroup: draft.vatProdPostingGroup,
                    ...(fixedAsset && draft.faPostingGroup ? { faPostingGroup: draft.faPostingGroup } : {}),
                    ...(draft.newItemCode.trim() ? { newItemCode: draft.newItemCode.trim() } : {}),
                  }
            void onSave(payload).then((saved) => {
              if (saved) setDrafts((all) => ({ ...all, [lineNo]: BLANK }))
            })
          }
          return (
            <li key={lineNo} className="rounded-md border border-amber-200 bg-white p-3">
              <p className="text-sm font-medium text-slate-900">
                Line {lineNo}: {pick(line.bcDescription, line.bcNo)} · Qty {text(line.quantity)}
                {fixedAsset ? <span className="ml-2 rounded bg-sky-100 px-1.5 py-0.5 text-xs font-semibold text-sky-800">Fixed asset</span> : null}
              </p>
              <div className="mt-2 flex flex-wrap gap-4 text-sm">
                <label className="flex items-center gap-1.5">
                  <input
                    type="radio"
                    className="accent-teal-600"
                    checked={draft.mode === 'existing'}
                    onChange={() => setDraft({ mode: 'existing' })}
                    disabled={busy}
                  />
                  Existing store item
                </label>
                <label className="flex items-center gap-1.5">
                  <input
                    type="radio"
                    className="accent-teal-600"
                    checked={draft.mode === 'new'}
                    onChange={() => setDraft({ mode: 'new' })}
                    disabled={busy}
                  />
                  New item
                </label>
              </div>
              {draft.mode === 'existing' ? (
                <div className="mt-2 max-w-xl">
                  <LookupCombobox
                    id={`receive-item-${lineNo}`}
                    options={items.options}
                    value={draft.existingItemNo}
                    onChange={(value) => setDraft({ existingItemNo: value })}
                    loading={items.isLoading}
                    disabled={busy}
                    placeholder="Search the store item by No. or name"
                    emptyText="Could not load the items from Business Central. Type the item No."
                  />
                </div>
              ) : (
                <div className="mt-2 grid grid-cols-[repeat(auto-fill,minmax(min(100%,14rem),1fr))] gap-3">
                  <label className="block space-y-1">
                    <span className="text-xs font-medium text-slate-600">Item Category</span>
                    <CardEditor
                      kind="select"
                      label="Item Category"
                      options={categoryOptions}
                      value={draft.itemCategoryCode}
                      disabled={busy}
                      onChange={(value) => setDraft({ itemCategoryCode: value, itemSubCategory: '' })}
                    />
                  </label>
                  <label className="block space-y-1">
                    <span className="text-xs font-medium text-slate-600">Item Sub-Category{fixedAsset ? '' : ' (optional)'}</span>
                    <CardEditor
                      kind="select"
                      label="Item Sub-Category"
                      options={subCategoryOptions}
                      value={draft.itemSubCategory}
                      disabled={busy || !draft.itemCategoryCode}
                      onChange={(value) => setDraft({ itemSubCategory: value })}
                    />
                  </label>
                  <label className="block space-y-1">
                    <span className="text-xs font-medium text-slate-600">VAT Prod. Posting Group</span>
                    <CardEditor
                      kind="select"
                      label="VAT Prod. Posting Group"
                      options={vatOptions}
                      value={draft.vatProdPostingGroup}
                      disabled={busy}
                      onChange={(value) => setDraft({ vatProdPostingGroup: value })}
                    />
                  </label>
                  {fixedAsset ? (
                    <label className="block space-y-1">
                      <span className="text-xs font-medium text-slate-600">FA Posting Group</span>
                      <CardEditor
                        kind="select"
                        label="FA Posting Group"
                        options={faOptions}
                        value={draft.faPostingGroup}
                        disabled={busy}
                        onChange={(value) => setDraft({ faPostingGroup: value })}
                      />
                    </label>
                  ) : (
                    <label className="block space-y-1">
                      <span className="text-xs font-medium text-slate-600">New item code (optional)</span>
                      <CardEditor
                        kind="code"
                        label="New item code"
                        value={draft.newItemCode}
                        disabled={busy}
                        onChange={(value) => setDraft({ newItemCode: value })}
                      />
                    </label>
                  )}
                </div>
              )}
              <div className="mt-3 flex justify-end">
                <Button type="button" size="sm" variant="gradient" disabled={busy || missing} onClick={save}>
                  {busy ? 'Saving…' : 'Set item'}
                </Button>
              </div>
            </li>
          )
        })}
      </ul>
    </section>
  )
}
