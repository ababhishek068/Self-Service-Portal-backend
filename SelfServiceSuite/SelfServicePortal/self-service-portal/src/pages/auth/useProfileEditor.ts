import { useMemo, useState } from 'react'
import {
  deleteProfileDocument,
  discardProfileDraft,
  saveProfileChanges,
  uploadProfileDocument,
  withdrawProfileChange,
  type ProfileChangeRequest,
  type ProfileChanges,
  type ProfileEditContext,
  type ProfileFieldDef,
  type ProfileRowArea,
  type ProfileRowChange,
} from '@/api/endpoints/profileChanges'
import { useToast } from '@/components/feedback/ToastProvider'
import { formatDate } from '@/utils/formatters'

// ------------------------------------------------------------------------------------------------
// Draft state
// ------------------------------------------------------------------------------------------------

interface DraftState {
  fields: Record<string, string>
  rows: ProfileRowChange[]
  note: string
}

const EMPTY_DRAFT: DraftState = { fields: {}, rows: [], note: '' }

/** The draft or the request waiting for HR; after a rejection the same changes, to correct and resubmit. */
function draftFromRequest(request: ProfileChangeRequest | null): DraftState {
  if (!request || request.status === 'Approved') return EMPTY_DRAFT
  return {
    fields: Object.fromEntries(request.changes.fields.map((field) => [field.key, field.value])),
    rows: request.changes.rows,
    note: request.note,
  }
}

function snapshot(draft: DraftState) {
  const fields = Object.keys(draft.fields)
    .sort()
    .map((key) => [key, draft.fields[key]])
  return JSON.stringify({ fields, rows: draft.rows, note: draft.note.trim() })
}

export function errorText(error: unknown) {
  return error instanceof Error && error.message ? error.message : 'Please try again.'
}

function newRowRef() {
  return `new-${Date.now().toString(36)}${Math.random().toString(36).slice(2, 6)}`
}

/**
 * The employee's edits on top of what BC has: changed employee fields, added / changed / removed
 * list rows and a note to HR. Saving replaces the BC draft; submitting sends it to HR.
 */
export function useProfileEditor(context: ProfileEditContext | undefined, reload: () => Promise<unknown>) {
  const toast = useToast()
  const [loadedFrom, setLoadedFrom] = useState<ProfileEditContext | null>(null)
  const [draft, setDraft] = useState<DraftState>(EMPTY_DRAFT)
  const [saved, setSaved] = useState(snapshot(EMPTY_DRAFT))
  const [request, setRequest] = useState<ProfileChangeRequest | null>(null)
  const [busy, setBusy] = useState<'save' | 'submit' | 'withdraw' | 'discard' | 'upload' | null>(null)
  // The profile is read only until the employee clicks Edit.
  const [editing, setEditing] = useState(false)

  // Load BC's state when the edit context arrives (the query only refetches after our own actions).
  if (context && context !== loadedFrom) {
    const fromServer = draftFromRequest(context.request)
    setLoadedFrom(context)
    setEditing(false)
    setDraft(fromServer)
    // A rejected request is not a draft: its changes show as not saved until the employee saves or submits.
    setSaved(snapshot(context.request?.status === 'Rejected' ? EMPTY_DRAFT : fromServer))
    setRequest(context.request)
  }

  const baseline = useMemo(
    () => Object.fromEntries((context?.fields ?? []).map((field) => [field.key, field.value])),
    [context],
  )
  const locked = request?.status === 'Waiting for HR'
  const startEditing = () => {
    if (!locked) setEditing(true)
  }
  const stopEditing = () => setEditing(false)
  const changeCount = Object.keys(draft.fields).length + draft.rows.length
  const dirty = !locked && snapshot(draft) !== saved
  const hasDraft = request?.status === 'Draft'

  const value = (key: string) => draft.fields[key] ?? baseline[key] ?? ''

  const setField = (key: string, next: string) =>
    setDraft((current) => {
      const fields = { ...current.fields }
      if (next === (baseline[key] ?? '')) delete fields[key]
      else fields[key] = next
      return { ...current, fields }
    })

  const setNote = (note: string) => setDraft((current) => ({ ...current, note }))

  /** A new row keeps only what the employee filled in (no empty choices, no "No"). */
  const filledValues = (area: ProfileRowArea, values: Record<string, string>) => {
    const defs = context?.areas[area].fields ?? []
    return Object.fromEntries(
      Object.entries(values).filter(([key, entry]) => {
        const def = defs.find((field) => field.key === key)
        if (!entry) return false
        if (def?.type === 'option' && entry === '0') return false
        if (def?.type === 'boolean' && entry === 'false') return false
        return true
      }),
    )
  }

  const addRow = (area: ProfileRowArea, values: Record<string, string>) =>
    setDraft((current) => ({
      ...current,
      rows: [...current.rows, { area, action: 'add', ref: newRowRef(), values: filledValues(area, values) }],
    }))

  /** A new row is replaced; an existing one keeps only the values that differ from BC. */
  const editRow = (area: ProfileRowArea, ref: string, values: Record<string, string>) =>
    setDraft((current) => {
      const existing = context?.areas[area].rows.find((row) => row.ref === ref)
      const others = current.rows.filter((row) => !(row.area === area && row.ref === ref))
      if (!existing) return { ...current, rows: [...others, { area, action: 'add', ref, values: filledValues(area, values) }] }
      const changed = Object.fromEntries(
        Object.entries(values).filter(([key, entry]) => entry !== (existing.values[key] ?? '')),
      )
      if (!Object.keys(changed).length) return { ...current, rows: others }
      return { ...current, rows: [...others, { area, action: 'change', ref, values: changed }] }
    })

  const removeRow = (area: ProfileRowArea, ref: string) =>
    setDraft((current) => {
      const isNew = current.rows.some((row) => row.area === area && row.ref === ref && row.action === 'add')
      const others = current.rows.filter((row) => !(row.area === area && row.ref === ref))
      return isNew ? { ...current, rows: others } : { ...current, rows: [...others, { area, action: 'remove', ref, values: {} }] }
    })

  const undoRow = (area: ProfileRowArea, ref: string) =>
    setDraft((current) => ({ ...current, rows: current.rows.filter((row) => !(row.area === area && row.ref === ref)) }))

  const changes = (): ProfileChanges => ({
    fields: Object.entries(draft.fields).map(([key, entry]) => ({ key, value: entry })),
    rows: draft.rows,
  })

  async function run(kind: NonNullable<typeof busy>, action: () => Promise<unknown>, success: string, failure: string) {
    setBusy(kind)
    try {
      await action()
      await reload()
      toast.success(success)
      return true
    } catch (error) {
      toast.error(errorText(error), failure)
      return false
    } finally {
      setBusy(null)
    }
  }

  const saveDraft = () =>
    run('save', () => saveProfileChanges({ changes: changes(), note: draft.note, submit: false }), 'Your changes are saved as a draft.', 'Draft not saved')

  const submit = () =>
    run(
      'submit',
      () => saveProfileChanges({ changes: changes(), note: draft.note, submit: true }),
      'Your changes were sent to HR for verification.',
      'Changes not submitted',
    )

  const withdraw = () =>
    request
      ? run('withdraw', () => withdrawProfileChange(request.requestNo), 'Your changes are back in draft. You can edit them again.', 'Withdraw failed')
      : Promise.resolve(false)

  const discard = () =>
    request && hasDraft
      ? run('discard', () => discardProfileDraft(request.requestNo), 'Your draft was discarded.', 'Discard failed')
      : Promise.resolve(false)

  /** Back to the last saved draft (or BC's values when there is none). */
  const revert = () => setDraft(request?.status === 'Draft' ? draftFromRequest(request) : EMPTY_DRAFT)

  async function upload(input: { fileName: string; contentBase64: string; description: string }) {
    setBusy('upload')
    try {
      setRequest(await uploadProfileDocument(input))
      toast.success('The document is attached to your changes.')
      return true
    } catch (error) {
      toast.error(errorText(error), 'Document not attached')
      return false
    } finally {
      setBusy(null)
    }
  }

  async function removeDocument(attachmentId: string) {
    if (!request) return
    setBusy('upload')
    try {
      setRequest(await deleteProfileDocument(request.requestNo, attachmentId))
    } catch (error) {
      toast.error(errorText(error), 'Document not removed')
    } finally {
      setBusy(null)
    }
  }

  return {
    context,
    draft,
    request,
    busy,
    locked,
    editing: editing && !locked,
    startEditing,
    stopEditing,
    dirty,
    hasDraft,
    changeCount,
    value,
    setField,
    setNote,
    addRow,
    editRow,
    removeRow,
    undoRow,
    saveDraft,
    submit,
    withdraw,
    discard,
    revert,
    upload,
    removeDocument,
  }
}

export type ProfileEditor = ReturnType<typeof useProfileEditor>

export type Lookups = ProfileEditContext['lookups']

/** The value as the employee reads it (option caption, country name, formatted date…). */
export function displayValue(def: ProfileFieldDef | undefined, raw: string, lookups: Lookups) {
  if (!def) return raw
  if (!raw) return ''
  switch (def.type) {
    case 'option':
      return def.options.find((option) => option.value === raw)?.label ?? raw
    case 'lookup': {
      const row = (lookups[def.lookup] ?? []).find((entry) => entry.code.toUpperCase() === raw.toUpperCase())
      return row?.name ? `${row.name} (${row.code})` : raw
    }
    case 'date':
      return formatDate(raw)
    case 'boolean':
      return raw === 'true' ? 'Yes' : 'No'
    default:
      return raw
  }
}
