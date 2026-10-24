import { useState } from 'react'
import { Pencil } from 'lucide-react'
import { Button } from '@/components/ui/button'
import { CardEditor, CardSection, type CardEditorKind, type CardField } from '@/components/facility/BcCard'

/** An editable card field, by its label: BC payload key, editor and its value now. */
export type EditSpec = { key: string; kind: CardEditorKind; initial: string; options?: Array<{ value: string; label: string }> }

/**
 * A BC card section with Edit / Save: the fields in `specs` turn into editors, Save sends only the
 * changed values (`onSave` runs the BC action, reports the result and returns false when BC refused).
 * `fields` may depend on whether the section is being edited (e.g. a field shown only while editing).
 */
export function EditableCardSection({
  title,
  intro,
  fields,
  specs,
  canEdit,
  showAll,
  onSave,
}: {
  title: string
  intro?: string
  fields: CardField[] | ((editing: boolean) => CardField[])
  specs: Record<string, EditSpec>
  canEdit: boolean
  showAll: boolean
  onSave: (changed: Record<string, string>) => Promise<boolean>
}) {
  // Values being edited: payload key → value (null when not editing).
  const [draft, setDraft] = useState<Record<string, string> | null>(null)
  const [saving, setSaving] = useState(false)
  const editing = draft !== null && canEdit
  const base = typeof fields === 'function' ? fields(editing) : fields
  const shown: CardField[] = editing
    ? base.map((field) => {
        const spec = specs[field.label]
        if (!spec) return field
        return {
          ...field,
          editor: (
            <CardEditor
              kind={spec.kind}
              label={field.label}
              options={spec.options}
              value={draft[spec.key] ?? ''}
              disabled={saving}
              onChange={(value) => setDraft((current) => (current ? { ...current, [spec.key]: value } : current))}
            />
          ),
        }
      })
    : base

  const save = async () => {
    if (!draft) return
    const changed = Object.fromEntries(
      Object.values(specs)
        .filter((spec) => (draft[spec.key] ?? '') !== spec.initial)
        .map((spec) => [spec.key, draft[spec.key] ?? '']),
    )
    if (Object.keys(changed).length === 0) {
      setDraft(null)
      return
    }
    setSaving(true)
    try {
      if (await onSave(changed)) setDraft(null)
    } finally {
      setSaving(false)
    }
  }

  const action = editing ? (
    <div className="flex gap-2">
      <Button type="button" size="sm" variant="outline" disabled={saving} onClick={() => setDraft(null)}>
        Cancel
      </Button>
      <Button type="button" size="sm" variant="gradient" disabled={saving} onClick={() => void save()}>
        {saving ? 'Saving…' : 'Save'}
      </Button>
    </div>
  ) : canEdit ? (
    <Button
      type="button"
      size="sm"
      variant="outline"
      onClick={() => setDraft(Object.fromEntries(Object.values(specs).map((spec) => [spec.key, spec.initial])))}
    >
      <Pencil className="h-4 w-4" />
      Edit
    </Button>
  ) : null

  return <CardSection title={title} intro={intro} fields={shown} showAll={showAll || editing} action={action} />
}
