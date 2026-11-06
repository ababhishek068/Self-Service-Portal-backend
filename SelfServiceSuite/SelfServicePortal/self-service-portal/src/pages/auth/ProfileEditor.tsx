import { useRef, useState, type ReactNode } from 'react'
import { createPortal } from 'react-dom'
import {
  Accessibility, AlertTriangle, Baby, BookUser, Briefcase, Building2, CalendarDays, CheckCircle2, ChevronDown, Clock, Contact,
  Download, FileText, Flag, Globe, GraduationCap, Hash, Heart, Hourglass, House, IdCard, Landmark, Mail, Mailbox, MapPin,
  Paperclip, Pencil, Phone, Plus, Save, Scale, Send, Siren, Smartphone, Trash2, Undo2, Upload, UserRound, Users, X, XCircle,
} from 'lucide-react'
import {
  ageText,
  downloadProfileDocument,
  type ProfileArea,
  type ProfileFieldDef,
  type ProfileRowArea,
  type ProfileRowChange,
} from '@/api/endpoints/profileChanges'
import { displayValue, errorText, type Lookups, type ProfileEditor } from './useProfileEditor'
import { useToast } from '@/components/feedback/ToastProvider'
import { useConfirm } from '@/components/feedback/ConfirmProvider'
import { Button } from '@/components/ui/button'
import { cn } from '@/lib/utils'
import { formatDate, formatDateTime } from '@/utils/formatters'

// ------------------------------------------------------------------------------------------------
// Values
// ------------------------------------------------------------------------------------------------

function lookupOptions(def: ProfileFieldDef, lookups: Lookups, current: string) {
  const rows = lookups[def.lookup] ?? []
  const options = rows.map((row) => ({ value: row.code, label: row.name ? `${row.name} (${row.code})` : row.code }))
  if (current && !rows.some((row) => row.code.toUpperCase() === current.toUpperCase())) {
    options.unshift({ value: current, label: current })
  }
  return options
}

const inputClass =
  'w-full rounded-md border border-slate-200 bg-white px-2.5 py-1.5 text-sm font-semibold text-slate-900 outline-none ' +
  'focus:border-[var(--portal-navy)] focus:ring-2 focus:ring-[var(--portal-navy)]/15 disabled:cursor-not-allowed disabled:bg-slate-50 disabled:text-slate-500'

function FieldInput({
  def,
  value,
  onChange,
  lookups,
  disabled,
  id,
}: {
  def: ProfileFieldDef
  value: string
  onChange: (value: string) => void
  lookups: Lookups
  disabled?: boolean
  id: string
}) {
  if (def.type === 'option' || def.type === 'lookup' || def.type === 'boolean') {
    const options =
      def.type === 'option'
        ? def.options.map((option) => ({ value: option.value, label: option.label || '— Not set —' }))
        : def.type === 'boolean'
          ? [
              { value: 'false', label: 'No' },
              { value: 'true', label: 'Yes' },
            ]
          : [{ value: '', label: '— Not set —' }, ...lookupOptions(def, lookups, value)]
    return (
      <div className="relative">
        <select
          id={id}
          className={cn(inputClass, 'appearance-none pr-8')}
          value={def.type === 'boolean' ? (value === 'true' ? 'true' : 'false') : value}
          disabled={disabled}
          onChange={(event) => onChange(event.target.value)}
        >
          {options.map((option) => (
            <option key={`${option.value}-${option.label}`} value={option.value}>
              {option.label}
            </option>
          ))}
        </select>
        <ChevronDown className="pointer-events-none absolute right-2 top-1/2 h-4 w-4 -translate-y-1/2 text-slate-500" />
      </div>
    )
  }
  if (def.type === 'date') {
    return (
      <input
        id={id}
        type="date"
        className={inputClass}
        value={value}
        disabled={disabled}
        onChange={(event) => onChange(event.target.value)}
      />
    )
  }
  if (def.type === 'integer' || def.type === 'number') {
    return (
      <input
        id={id}
        type="number"
        inputMode={def.type === 'integer' ? 'numeric' : 'decimal'}
        step={def.type === 'integer' ? 1 : 0.01}
        min={0}
        className={inputClass}
        value={value}
        disabled={disabled}
        onChange={(event) => onChange(event.target.value)}
      />
    )
  }
  return (
    <input
      id={id}
      type={def.key.toLowerCase().includes('email') ? 'email' : 'text'}
      className={inputClass}
      value={value}
      maxLength={def.maxLength > 0 ? def.maxLength : undefined}
      disabled={disabled}
      onChange={(event) => onChange(event.target.value)}
    />
  )
}

// ------------------------------------------------------------------------------------------------
// Bio Data
// ------------------------------------------------------------------------------------------------

const FIELD_ICONS: Record<string, ReactNode> = {
  staffNo: <IdCard />, title: <UserRound />, firstName: <UserRound />, middleName: <UserRound />, lastName: <UserRound />,
  fullName: <UserRound />, fydaId: <Hash />, idNumber: <IdCard />, passportNumber: <BookUser />, citizenship: <Scale />,
  countryCode: <Globe />, dateOfBirth: <CalendarDays />, age: <Hourglass />, gender: <Users />, maritalStatus: <Heart />,
  religion: <Landmark />, numberOfDependants: <Baby />, disabled: <Accessibility />, cellPhone: <Smartphone />,
  cellularPhone: <Smartphone />, homePhone: <Phone />, workPhone: <Phone />, extension: <Hash />, personalEmail: <Mail />,
  companyEmail: <Mail />, emergencyName: <Siren />, emergencyPhone: <Siren />, emergencyEmail: <Siren />, poBox: <Mailbox />,
  postalAddress: <MapPin />, city: <Building2 />, residentialAddress: <House />, residentialAddress2: <House />,
}

export function SectionHeading({ children, icon }: { children: ReactNode; icon?: ReactNode }) {
  return (
    <div className="flex items-center gap-3">
      {icon ? <span className="text-[var(--portal-navy)] [&>svg]:h-5 [&>svg]:w-5">{icon}</span> : null}
      <h3 className="whitespace-nowrap text-sm font-bold uppercase tracking-wide text-[var(--portal-navy)]">{children}</h3>
      <div className="h-px flex-1 bg-gradient-to-r from-[var(--portal-navy)]/30 to-transparent" />
    </div>
  )
}

function FieldCard({ def, editor }: { def: ProfileFieldDef; editor: ProfileEditor }) {
  const lookups = editor.context?.lookups ?? {}
  const id = `profile-field-${def.key}`
  const changed = def.key in editor.draft.fields
  const current = editor.value(def.key)
  let shown = def.display
  if (def.type === 'computed' && def.key === 'age') shown = ageText(editor.value('dateOfBirth'))
  if (def.key === 'fullName' && ['firstName', 'middleName', 'lastName'].some((key) => key in editor.draft.fields)) {
    shown = ['firstName', 'middleName', 'lastName'].map((key) => editor.value(key).trim()).filter(Boolean).join(' ')
  }
  const missing = def.required && !current.trim()
  return (
    <div
      className={cn(
        'flex items-start gap-3 rounded-xl border bg-white p-3 transition-colors',
        changed ? 'border-amber-300 bg-amber-50/40 ring-1 ring-amber-200' : 'border-slate-200',
        missing && !def.readOnly ? 'border-red-300' : '',
      )}
    >
      <span className="mt-0.5 flex h-10 w-10 shrink-0 items-center justify-center rounded-lg bg-[var(--portal-navy)]/[0.06] text-[var(--portal-navy)] [&>svg]:h-5 [&>svg]:w-5">
        {FIELD_ICONS[def.key] ?? <FileText />}
      </span>
      <div className="min-w-0 flex-1">
        <label htmlFor={id} className="flex items-center gap-1 text-xs font-medium text-slate-500">
          {def.label}
          {def.required && !def.readOnly ? <span className="text-red-600">*</span> : null}
        </label>
        {def.readOnly || def.type === 'computed' ? (
          <p className="mt-1 break-words text-sm font-semibold text-slate-900">{shown || '—'}</p>
        ) : (
          <div className="mt-1">
            <FieldInput
              id={id}
              def={def}
              value={current}
              lookups={lookups}
              disabled={editor.locked || editor.busy !== null}
              onChange={(next) => editor.setField(def.key, next)}
            />
          </div>
        )}
        {changed ? (
          <p className="mt-1 text-[11px] text-amber-800">
            {editor.locked ? 'Waiting for HR · was ' : 'Changed · was '}
            <span className="font-medium">{def.display || 'empty'}</span>
          </p>
        ) : null}
      </div>
    </div>
  )
}

export function BioDataEditor({ editor, extra }: { editor: ProfileEditor; extra?: ReactNode }) {
  const fields = editor.context?.fields ?? []
  const identity = fields.filter((field) => field.section === 'identity')
  const contact = fields.filter((field) => field.section === 'contact')
  const contactChanged = contact.some((field) => field.key in editor.draft.fields)
  const [contactOpen, setContactOpen] = useState(false)
  const open = contactOpen || contactChanged
  return (
    <div className="space-y-6">
      <div className="space-y-3">
        <SectionHeading>Personal Information</SectionHeading>
        <div className="grid gap-3 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4">
          {identity.map((field) => (
            <FieldCard key={field.key} def={field} editor={editor} />
          ))}
        </div>
      </div>
      <div className="space-y-3">
        <button
          type="button"
          className="flex w-full items-center gap-3 text-left"
          aria-expanded={open}
          onClick={() => setContactOpen(!open)}
        >
          <Contact className="h-5 w-5 text-[var(--portal-navy)]" />
          <span className="whitespace-nowrap text-sm font-bold uppercase tracking-wide text-[var(--portal-navy)]">Contact Details</span>
          <span className="h-px flex-1 bg-gradient-to-r from-[var(--portal-navy)]/30 to-transparent" />
          <ChevronDown className={cn('h-5 w-5 text-slate-500 transition-transform', open ? 'rotate-180' : '')} />
        </button>
        {open ? (
          <div className="grid gap-3 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4">
            {contact.map((field) => (
              <FieldCard key={field.key} def={field} editor={editor} />
            ))}
          </div>
        ) : null}
      </div>
      {extra}
    </div>
  )
}

// ------------------------------------------------------------------------------------------------
// Lists (next of kin, beneficiaries, dependants, qualifications, employment history)
// ------------------------------------------------------------------------------------------------

const ROW_DETAIL_KEYS: Record<ProfileRowArea, string[]> = {
  kin: ['relationship', 'gender', 'dateOfBirth', 'homeTelNo', 'occupation'],
  beneficiary: ['relationship', 'percentage', 'dateOfBirth', 'homeTelNo'],
  dependant: ['relationship', 'gender', 'dateOfBirth', 'memberId'],
  qualification: ['qualification', 'institution', 'type', 'fromDate', 'toDate', 'gpa', 'highestQualification'],
  history: ['jobTitle', 'from', 'toDate', 'reasonForLeaving'],
}

const AREA_ICONS: Record<ProfileRowArea, ReactNode> = {
  kin: <Users />, beneficiary: <Users />, dependant: <Baby />, qualification: <GraduationCap />, history: <Briefcase />,
}

const ADD_LABELS: Record<ProfileRowArea, string> = {
  kin: 'Add next of kin',
  beneficiary: 'Add beneficiary',
  dependant: 'Add dependant',
  qualification: 'Add qualification',
  history: 'Add previous employment',
}

function rowTitle(area: ProfileRowArea, values: Record<string, string>) {
  if (area === 'qualification') return values.description || 'Qualification'
  if (area === 'history') return values.companyName || 'Organisation'
  return [values.otherNames, values.surName].filter(Boolean).join(' ') || 'Person'
}

type RowState = 'same' | 'changed' | 'removed' | 'new'

interface ShownRow {
  ref: string
  values: Record<string, string>
  state: RowState
}

function shownRows(area: ProfileRowArea, data: ProfileArea, rows: ProfileRowChange[]): ShownRow[] {
  const mine = rows.filter((row) => row.area === area)
  const existing = data.rows.map((row): ShownRow => {
    const change = mine.find((entry) => entry.ref === row.ref)
    if (change?.action === 'remove') return { ref: row.ref, values: row.values, state: 'removed' }
    if (change?.action === 'change') return { ref: row.ref, values: { ...row.values, ...change.values }, state: 'changed' }
    return { ref: row.ref, values: row.values, state: 'same' }
  })
  const added = mine.filter((row) => row.action === 'add').map((row): ShownRow => ({ ref: row.ref, values: row.values, state: 'new' }))
  return [...existing, ...added]
}

const STATE_BADGES: Record<Exclude<RowState, 'same'>, { label: string; className: string }> = {
  new: { label: 'New', className: 'bg-emerald-50 text-emerald-700 ring-emerald-200' },
  changed: { label: 'Changed', className: 'bg-amber-50 text-amber-800 ring-amber-200' },
  removed: { label: 'To be removed', className: 'bg-red-50 text-red-700 ring-red-200' },
}

export function RowAreaEditor({ editor, area, title }: { editor: ProfileEditor; area: ProfileRowArea; title?: string }) {
  const confirm = useConfirm()
  const data = editor.context?.areas[area]
  const [dialog, setDialog] = useState<{ ref: string | null; values: Record<string, string> } | null>(null)
  if (!data) return null
  const lookups = editor.context?.lookups ?? {}
  const rows = shownRows(area, data, editor.draft.rows)
  const disabled = editor.locked || editor.busy !== null
  const defs = Object.fromEntries(data.fields.map((field) => [field.key, field]))
  return (
    <div className="space-y-3">
      <div className="flex flex-wrap items-center gap-3">
        <div className="min-w-0 flex-1">
          <SectionHeading icon={AREA_ICONS[area]}>{title ?? data.label}</SectionHeading>
        </div>
        <Button type="button" variant="outline" size="sm" disabled={disabled} onClick={() => setDialog({ ref: null, values: {} })}>
          <Plus className="h-4 w-4" />
          {ADD_LABELS[area]}
        </Button>
      </div>
      {rows.length === 0 ? (
        <p className="rounded-xl border border-dashed border-slate-300 p-4 text-sm text-slate-500">
          Nothing recorded yet. Use {ADD_LABELS[area].toLowerCase()} to add one.
        </p>
      ) : (
        <div className="grid gap-3 md:grid-cols-2">
          {rows.map((row) => {
            const badge = row.state === 'same' ? null : STATE_BADGES[row.state]
            const details = ROW_DETAIL_KEYS[area]
              .map((key) => ({ key, label: defs[key]?.label ?? key, value: displayValue(defs[key], row.values[key] ?? '', lookups) }))
              .filter((detail) => detail.value && !(detail.key === 'highestQualification' && detail.value === 'No'))
            return (
              <div
                key={row.ref}
                className={cn(
                  'rounded-xl border bg-white p-4',
                  row.state === 'removed' ? 'border-red-200 bg-red-50/30' : row.state === 'same' ? 'border-slate-200' : 'border-amber-200 bg-amber-50/30',
                )}
              >
                <div className="flex items-start justify-between gap-3">
                  <div className="min-w-0">
                    <p className={cn('break-words font-semibold text-slate-900', row.state === 'removed' ? 'line-through' : '')}>
                      {rowTitle(area, row.values)}
                    </p>
                    {badge ? (
                      <span className={cn('mt-1 inline-block rounded-full px-2 py-0.5 text-[11px] font-semibold ring-1', badge.className)}>
                        {editor.locked ? `${badge.label} · waiting for HR` : badge.label}
                      </span>
                    ) : null}
                  </div>
                  <div className="flex shrink-0 gap-1">
                    {row.state === 'removed' || row.state === 'changed' ? (
                      <Button type="button" variant="ghost" size="sm" disabled={disabled} onClick={() => editor.undoRow(area, row.ref)}>
                        <Undo2 className="h-4 w-4" />
                        Undo
                      </Button>
                    ) : null}
                    {row.state !== 'removed' ? (
                      <>
                        <Button
                          type="button"
                          variant="ghost"
                          size="sm"
                          aria-label={`Edit ${rowTitle(area, row.values)}`}
                          disabled={disabled}
                          onClick={() => setDialog({ ref: row.ref, values: row.values })}
                        >
                          <Pencil className="h-4 w-4" />
                        </Button>
                        <Button
                          type="button"
                          variant="ghost"
                          size="sm"
                          aria-label={`Remove ${rowTitle(area, row.values)}`}
                          disabled={disabled}
                          onClick={async () => {
                            const ok = await confirm({
                              title: 'Remove this record?',
                              message: `${rowTitle(area, row.values)} will be removed when HR approves your changes.`,
                              confirmLabel: 'Remove',
                              tone: 'danger',
                            })
                            if (ok) editor.removeRow(area, row.ref)
                          }}
                        >
                          <Trash2 className="h-4 w-4 text-red-600" />
                        </Button>
                      </>
                    ) : null}
                  </div>
                </div>
                {details.length ? (
                  <dl className="mt-3 grid grid-cols-2 gap-x-4 gap-y-2 text-sm">
                    {details.map((detail) => (
                      <div key={detail.key} className="min-w-0">
                        <dt className="text-xs text-slate-500">{detail.label}</dt>
                        <dd className="break-words font-medium text-slate-800">{detail.value}</dd>
                      </div>
                    ))}
                  </dl>
                ) : null}
              </div>
            )
          })}
        </div>
      )}
      {area === 'qualification' && data.otherRows.length ? (
        <div className="space-y-2">
          <p className="text-xs font-semibold uppercase tracking-wide text-slate-500">Recorded by HR</p>
          <div className="grid gap-3 md:grid-cols-2">
            {data.otherRows.map((row, index) => (
              <div key={index} className="rounded-xl border border-slate-200 bg-slate-50 p-4 text-sm">
                <p className="font-semibold text-slate-900">{row.label || 'Qualification'}</p>
                <p className="mt-1 text-slate-600">
                  {[row.level, row.institution, [row.fromDate, row.toDate].filter(Boolean).map((date) => formatDate(date)).join(' – ')]
                    .filter(Boolean)
                    .join(' · ')}
                </p>
              </div>
            ))}
          </div>
        </div>
      ) : null}
      {dialog ? (
        <RowDialog
          title={dialog.ref ? `Edit ${rowTitle(area, dialog.values)}` : ADD_LABELS[area]}
          fields={data.fields}
          initial={dialog.values}
          lookups={lookups}
          onClose={() => setDialog(null)}
          onSave={(values) => {
            if (dialog.ref) editor.editRow(area, dialog.ref, values)
            else editor.addRow(area, values)
            setDialog(null)
          }}
        />
      ) : null}
    </div>
  )
}

function RowDialog({
  title,
  fields,
  initial,
  lookups,
  onClose,
  onSave,
}: {
  title: string
  fields: ProfileFieldDef[]
  initial: Record<string, string>
  lookups: Lookups
  onClose: () => void
  onSave: (values: Record<string, string>) => void
}) {
  const editable = fields.filter((field) => !field.readOnly)
  const [values, setValues] = useState<Record<string, string>>(() =>
    Object.fromEntries(editable.map((field) => [field.key, initial[field.key] ?? (field.type === 'option' ? '0' : field.type === 'boolean' ? 'false' : '')])),
  )
  const [tried, setTried] = useState(false)
  const missing = editable.filter(
    (field) =>
      field.required && (!(values[field.key] ?? '').trim() || (field.type === 'option' && values[field.key] === '0')),
  )
  const save = () => {
    setTried(true)
    if (missing.length) return
    onSave(Object.fromEntries(Object.entries(values).map(([key, entry]) => [key, entry.trim()])))
  }
  return createPortal(
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-slate-950/40 p-4" role="dialog" aria-modal="true" aria-label={title}>
      <div className="flex max-h-[90vh] w-full max-w-2xl flex-col rounded-xl bg-white shadow-xl">
        <div className="flex items-center justify-between border-b border-slate-200 px-5 py-4">
          <h2 className="text-lg font-semibold text-slate-950">{title}</h2>
          <button type="button" className="rounded-md p-1 text-slate-500 hover:bg-slate-100" aria-label="Close" onClick={onClose}>
            <X className="h-5 w-5" />
          </button>
        </div>
        <div className="grid flex-1 gap-4 overflow-y-auto px-5 py-4 sm:grid-cols-2">
          {fields.map((field) => {
            const id = `row-field-${field.key}`
            const invalid = tried && missing.includes(field)
            return (
              <div key={field.key} className={field.key === 'address' || field.key === 'remarks' || field.key === 'description' ? 'sm:col-span-2' : ''}>
                <label htmlFor={id} className="mb-1 flex items-center gap-1 text-xs font-medium text-slate-600">
                  {field.label}
                  {field.required ? <span className="text-red-600">*</span> : null}
                  {field.readOnly ? <span className="text-slate-400">(set by HR)</span> : null}
                </label>
                {field.readOnly ? (
                  <p className="rounded-md bg-slate-50 px-2.5 py-1.5 text-sm text-slate-600">{displayValue(field, initial[field.key] ?? '', lookups) || '—'}</p>
                ) : (
                  <FieldInput
                    id={id}
                    def={field}
                    value={values[field.key] ?? ''}
                    lookups={lookups}
                    onChange={(next) => setValues((current) => ({ ...current, [field.key]: next }))}
                  />
                )}
                {invalid ? <p className="mt-1 text-xs text-red-600">Enter the {field.label.toLowerCase()}.</p> : null}
                {field.key === 'institution' ? (
                  <p className="mt-1 text-xs text-slate-500">Not in the list? Leave it empty and write the institution in the qualification name.</p>
                ) : null}
              </div>
            )
          })}
        </div>
        <div className="flex justify-end gap-2 border-t border-slate-200 px-5 py-4">
          <Button type="button" variant="outline" onClick={onClose}>
            Cancel
          </Button>
          <Button type="button" onClick={save}>
            <CheckCircle2 className="h-4 w-4" />
            Done
          </Button>
        </div>
      </div>
    </div>,
    document.body,
  )
}

// ------------------------------------------------------------------------------------------------
// Supporting documents
// ------------------------------------------------------------------------------------------------

const ALLOWED_DOCUMENTS = new Set(['pdf', 'doc', 'docx', 'jpg', 'png'])

function readFileBase64(file: File): Promise<string> {
  return new Promise((resolve, reject) => {
    const reader = new FileReader()
    reader.onerror = () => reject(new Error(`Could not read ${file.name}`))
    reader.onload = () => {
      const content = String(reader.result ?? '').split(',')[1] ?? ''
      if (content) resolve(content)
      else reject(new Error(`Could not read ${file.name}`))
    }
    reader.readAsDataURL(file)
  })
}

export function ProfileDocuments({ editor }: { editor: ProfileEditor }) {
  const toast = useToast()
  const fileInput = useRef<HTMLInputElement | null>(null)
  const [description, setDescription] = useState('')
  const [file, setFile] = useState<File | null>(null)
  const request = editor.request
  const documents = request && request.status !== 'Approved' && request.status !== 'Rejected' ? request.attachments : []
  const canEdit = !editor.locked && editor.busy === null
  const attach = async () => {
    if (!file) return
    const extension = file.name.split('.').pop()?.toLowerCase() ?? ''
    if (!ALLOWED_DOCUMENTS.has(extension)) {
      toast.error('Use a PDF, Word document, JPG or PNG file.', 'File type not allowed')
      return
    }
    if (file.size > 10_000_000) {
      toast.error('The file must be 10 MB or smaller.', 'File too large')
      return
    }
    if (!description.trim()) {
      toast.error('Describe the document, for example "Birth certificate of my child".', 'Description required')
      return
    }
    const ok = await editor.upload({ fileName: file.name, contentBase64: await readFileBase64(file), description: description.trim() })
    if (ok) {
      setFile(null)
      setDescription('')
      if (fileInput.current) fileInput.current.value = ''
    }
  }
  return (
    <div className="space-y-3">
      <SectionHeading icon={<Paperclip />}>Supporting documents for your changes</SectionHeading>
      <p className="text-sm text-slate-600">
        Attach proof for HR, for example a certificate for a new qualification, a birth or marriage certificate for a dependant,
        or your ID for a name correction. After HR approves, the documents are kept with your employee record.
      </p>
      {canEdit ? (
        <div className="grid gap-3 rounded-xl border border-slate-200 bg-slate-50/60 p-4 md:grid-cols-[1fr_1fr_auto] md:items-end">
          <div>
            <label htmlFor="profile-document-description" className="mb-1 block text-xs font-medium text-slate-600">
              Description
            </label>
            <input
              id="profile-document-description"
              className={inputClass}
              maxLength={200}
              value={description}
              placeholder="e.g. Degree certificate"
              onChange={(event) => setDescription(event.target.value)}
            />
          </div>
          <div>
            <label htmlFor="profile-document-file" className="mb-1 block text-xs font-medium text-slate-600">
              File (PDF, Word, JPG or PNG, up to 10 MB)
            </label>
            <input
              id="profile-document-file"
              ref={fileInput}
              type="file"
              accept=".pdf,.doc,.docx,.jpg,.png"
              className="block w-full text-sm text-slate-700 file:mr-3 file:rounded-md file:border-0 file:bg-[var(--portal-navy)] file:px-3 file:py-1.5 file:text-sm file:font-medium file:text-white"
              onChange={(event) => setFile(event.target.files?.[0] ?? null)}
            />
          </div>
          <Button type="button" disabled={!file || editor.busy !== null} onClick={() => void attach()}>
            <Upload className="h-4 w-4" />
            {editor.busy === 'upload' ? 'Attaching…' : 'Attach'}
          </Button>
        </div>
      ) : null}
      {documents.length ? (
        <ul className="space-y-2">
          {documents.map((document) => (
            <li key={document.id} className="flex items-center justify-between gap-3 rounded-xl border border-slate-200 bg-white p-3">
              <div className="min-w-0">
                <p className="break-words text-sm font-medium text-slate-900">{document.description}</p>
                <p className="text-xs text-slate-500">{document.fileName}</p>
              </div>
              <div className="flex shrink-0 gap-1">
                <Button
                  type="button"
                  variant="ghost"
                  size="sm"
                  aria-label={`Download ${document.fileName}`}
                  onClick={() =>
                    request &&
                    void downloadProfileDocument(request.requestNo, document).catch((error: unknown) =>
                      toast.error(errorText(error), 'Download failed'),
                    )
                  }
                >
                  <Download className="h-4 w-4" />
                </Button>
                {canEdit ? (
                  <Button
                    type="button"
                    variant="ghost"
                    size="sm"
                    aria-label={`Remove ${document.fileName}`}
                    onClick={() => void editor.removeDocument(document.id)}
                  >
                    <Trash2 className="h-4 w-4 text-red-600" />
                  </Button>
                ) : null}
              </div>
            </li>
          ))}
        </ul>
      ) : (
        <p className="text-sm text-slate-500">No supporting documents attached to your changes yet.</p>
      )}
    </div>
  )
}

// ------------------------------------------------------------------------------------------------
// Status and actions
// ------------------------------------------------------------------------------------------------

export function ProfileStatusBanner({ editor }: { editor: ProfileEditor }) {
  const request = editor.request
  const context = editor.context
  if (!context) return null
  const notices: ReactNode[] = []
  // Counted as in the action bar: one per field, one per added / changed / removed record.
  const count = request ? request.changes.fields.length + request.changes.rows.length : 0
  const changesText = `${count} change${count === 1 ? '' : 's'}`
  if (request?.status === 'Waiting for HR') {
    notices.push(
      <div key="pending" role="status" className="flex flex-wrap items-start gap-3 rounded-xl border border-sky-200 bg-sky-50 p-4 text-sm text-sky-900">
        <Clock className="mt-0.5 h-5 w-5 shrink-0" />
        <div className="min-w-0 flex-1">
          <p className="font-semibold">Your changes are waiting for HR verification</p>
          <p className="mt-1">
            Sent on {formatDateTime(request.submittedAt)} to {request.hrApproverName || request.hrApproverUserId || 'HR'} ({changesText}).
            Your profile is locked until HR decides. Withdraw the request if you need to change something.
          </p>
        </div>
      </div>,
    )
  } else if (request?.status === 'Rejected') {
    notices.push(
      <div key="rejected" role="status" className="flex items-start gap-3 rounded-xl border border-red-200 bg-red-50 p-4 text-sm text-red-900">
        <XCircle className="mt-0.5 h-5 w-5 shrink-0" />
        <div>
          <p className="font-semibold">HR did not approve your last changes ({formatDate(request.decidedAt)})</p>
          <p className="mt-1">
            {request.decisionRemarks ? `Reason: ${request.decisionRemarks}. ` : ''}Your changes are filled in below: correct them and
            submit again, or click Cancel to drop them.
          </p>
        </div>
      </div>,
    )
  } else if (request?.status === 'Approved') {
    notices.push(
      <div key="approved" role="status" className="flex items-start gap-3 rounded-xl border border-emerald-200 bg-emerald-50 p-4 text-sm text-emerald-900">
        <CheckCircle2 className="mt-0.5 h-5 w-5 shrink-0" />
        <p>
          HR approved your last changes on {formatDate(request.decidedAt)} and they are saved in your record. You can make new changes
          below at any time.
        </p>
      </div>,
    )
  } else if (request?.status === 'Draft' && count) {
    notices.push(
      <div key="draft" role="status" className="flex items-start gap-3 rounded-xl border border-amber-200 bg-amber-50 p-4 text-sm text-amber-900">
        <FileText className="mt-0.5 h-5 w-5 shrink-0" />
        <p>
          You have a saved draft with {changesText}. HR sees it only after you click Submit.
        </p>
      </div>,
    )
  }
  if (context.routingProblem && !editor.locked) {
    notices.push(
      <div key="routing" role="alert" className="flex items-start gap-3 rounded-xl border border-amber-200 bg-amber-50 p-4 text-sm text-amber-900">
        <AlertTriangle className="mt-0.5 h-5 w-5 shrink-0" />
        <p>{context.routingProblem} You can still save your changes as a draft.</p>
      </div>,
    )
  }
  return notices.length ? <div className="space-y-3">{notices}</div> : null
}

function changeLines(editor: ProfileEditor) {
  const context = editor.context
  if (!context) return []
  const lookups = context.lookups
  const lines: Array<{ key: string; section: string; text: string }> = []
  for (const field of context.fields) {
    if (!(field.key in editor.draft.fields)) continue
    const next = displayValue(field, editor.draft.fields[field.key] ?? '', lookups)
    lines.push({
      key: `field-${field.key}`,
      section: field.section === 'contact' ? 'Contact Details' : 'Personal Information',
      text: `${field.label}: ${field.display || 'empty'} → ${next || 'empty'}`,
    })
  }
  for (const row of editor.draft.rows) {
    const area = context.areas[row.area]
    const existing = area.rows.find((entry) => entry.ref === row.ref)
    const titleValues = { ...(existing?.values ?? {}), ...row.values }
    const verb = row.action === 'add' ? 'Add' : row.action === 'remove' ? 'Remove' : 'Change'
    lines.push({ key: `row-${row.area}-${row.ref}`, section: area.label, text: `${verb} ${rowTitle(row.area, titleValues)}` })
  }
  return lines
}

export function ProfileActionBar({ editor, onShowDocuments }: { editor: ProfileEditor; onShowDocuments: () => void }) {
  const confirm = useConfirm()
  const [submitOpen, setSubmitOpen] = useState(false)
  const context = editor.context
  if (!context) return null
  const busy = editor.busy !== null
  const documents = editor.request && editor.request.status !== 'Approved' && editor.request.status !== 'Rejected' ? editor.request.attachments.length : 0

  if (editor.locked) {
    return (
      <div className="sticky bottom-0 z-10 -mx-5 -mb-5 mt-6 flex flex-wrap items-center justify-between gap-3 rounded-b-2xl border-t border-slate-200 bg-white/95 px-5 py-4 backdrop-blur sm:-mx-6 sm:-mb-6 sm:px-6">
        <p className="text-sm text-slate-600">
          <Clock className="mr-1 inline h-4 w-4 text-sky-700" />
          {editor.changeCount} change{editor.changeCount === 1 ? '' : 's'} waiting for HR.
        </p>
        <Button
          type="button"
          variant="outline"
          disabled={busy}
          onClick={async () => {
            const ok = await confirm({
              title: 'Withdraw your changes?',
              message: 'They go back to draft and HR will no longer see them. You can edit them and submit again.',
              confirmLabel: 'Withdraw',
            })
            if (ok) await editor.withdraw()
          }}
        >
          <Undo2 className="h-4 w-4" />
          {editor.busy === 'withdraw' ? 'Withdrawing…' : 'Withdraw'}
        </Button>
      </div>
    )
  }

  const status = editor.dirty
    ? `${editor.changeCount} change${editor.changeCount === 1 ? '' : 's'} not saved yet`
    : editor.changeCount
      ? `Draft saved · ${editor.changeCount} change${editor.changeCount === 1 ? '' : 's'}`
      : 'No changes yet. Edit your details, then submit them to HR.'

  const cancel = async () => {
    if (editor.dirty) {
      const ok = await confirm({
        title: 'Undo your unsaved changes?',
        message: editor.hasDraft ? 'Your profile goes back to the last saved draft.' : 'Your profile goes back to what is recorded in HR.',
        confirmLabel: 'Undo changes',
        tone: 'danger',
      })
      if (ok) editor.revert()
      return
    }
    if (editor.hasDraft) {
      const ok = await confirm({
        title: 'Discard your draft?',
        message: 'The saved changes and their documents are deleted. Your recorded profile does not change.',
        confirmLabel: 'Discard draft',
        tone: 'danger',
      })
      if (ok) await editor.discard()
    }
  }

  return (
    <>
      <div className="sticky bottom-0 z-10 -mx-5 -mb-5 mt-6 flex flex-wrap items-center justify-between gap-3 rounded-b-2xl border-t border-slate-200 bg-white/95 px-5 py-4 backdrop-blur sm:-mx-6 sm:-mb-6 sm:px-6">
        <div className="min-w-0 text-sm text-slate-600">
          <p className={editor.dirty ? 'font-medium text-amber-800' : ''}>{status}</p>
          {documents ? (
            <button type="button" className="text-xs text-[var(--portal-navy)] underline" onClick={onShowDocuments}>
              {documents} supporting document{documents === 1 ? '' : 's'} attached
            </button>
          ) : null}
        </div>
        <div className="flex flex-wrap gap-2">
          <Button type="button" variant="outline" disabled={busy || !editor.dirty} onClick={() => void editor.saveDraft()}>
            <Save className="h-4 w-4" />
            {editor.busy === 'save' ? 'Saving…' : 'Save as Draft'}
          </Button>
          <Button
            type="button"
            disabled={busy || editor.changeCount === 0 || Boolean(context.routingProblem)}
            title={context.routingProblem || undefined}
            onClick={() => setSubmitOpen(true)}
          >
            <Send className="h-4 w-4" />
            Submit
          </Button>
          <Button type="button" variant="outline" disabled={busy || (!editor.dirty && !editor.hasDraft)} onClick={() => void cancel()}>
            <X className="h-4 w-4" />
            Cancel
          </Button>
        </div>
      </div>
      {submitOpen ? (
        <SubmitDialog
          editor={editor}
          onClose={() => setSubmitOpen(false)}
          onSubmit={async () => {
            const ok = await editor.submit()
            if (ok) setSubmitOpen(false)
          }}
        />
      ) : null}
    </>
  )
}

function SubmitDialog({ editor, onClose, onSubmit }: { editor: ProfileEditor; onClose: () => void; onSubmit: () => Promise<void> }) {
  const lines = changeLines(editor)
  const sections = [...new Set(lines.map((line) => line.section))]
  return createPortal(
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-slate-950/40 p-4" role="dialog" aria-modal="true" aria-label="Submit your changes to HR">
      <div className="flex max-h-[90vh] w-full max-w-xl flex-col rounded-xl bg-white shadow-xl">
        <div className="border-b border-slate-200 px-5 py-4">
          <h2 className="text-lg font-semibold text-slate-950">Submit your changes to HR</h2>
          <p className="mt-1 text-sm text-slate-600">
            {editor.context?.hrApproverName ? `${editor.context.hrApproverName} (HR)` : 'HR'} checks them before they are saved in your record.
          </p>
        </div>
        <div className="flex-1 space-y-4 overflow-y-auto px-5 py-4">
          {sections.map((section) => (
            <div key={section}>
              <p className="text-xs font-semibold uppercase tracking-wide text-slate-500">{section}</p>
              <ul className="mt-1 space-y-1 text-sm text-slate-800">
                {lines
                  .filter((line) => line.section === section)
                  .map((line) => (
                    <li key={line.key} className="flex gap-2">
                      <Flag className="mt-0.5 h-3.5 w-3.5 shrink-0 text-amber-600" />
                      <span className="break-words">{line.text}</span>
                    </li>
                  ))}
              </ul>
            </div>
          ))}
          <div>
            <label htmlFor="profile-note" className="mb-1 block text-xs font-medium text-slate-600">
              Note to HR (optional)
            </label>
            <textarea
              id="profile-note"
              className={cn(inputClass, 'min-h-[80px] font-normal')}
              maxLength={250}
              value={editor.draft.note}
              placeholder="e.g. My name was misspelled; a copy of my ID is attached."
              onChange={(event) => editor.setNote(event.target.value)}
            />
            <p className="mt-1 text-right text-xs text-slate-500">{editor.draft.note.length}/250</p>
          </div>
        </div>
        <div className="flex justify-end gap-2 border-t border-slate-200 px-5 py-4">
          <Button type="button" variant="outline" disabled={editor.busy !== null} onClick={onClose}>
            Back
          </Button>
          <Button type="button" disabled={editor.busy !== null} onClick={() => void onSubmit()}>
            <Send className="h-4 w-4" />
            {editor.busy === 'submit' ? 'Submitting…' : 'Submit to HR'}
          </Button>
        </div>
      </div>
    </div>,
    document.body,
  )
}
