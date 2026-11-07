import { callSoapMethod } from './bcClient.js'

/**
 * Employee profile changes (BC 1.0.3.609, codeunit "ABH Profile Change Mgt" through the Staff
 * Portal Codeunit): the employee edits their own profile (personal and contact details, next of
 * kin, beneficiaries, dependants, qualifications, previous employment, supporting documents),
 * HR verifies it, and the approved changes are written to the HR employee card and its lists.
 */
export const PROFILE_CHANGE_MODULE = 'profileChange' as const
/** Table "ABH Profile Change Request": the supporting documents are attached to it. */
export const PROFILE_CHANGE_TABLE_ID = 53645

export const PROFILE_ROW_AREAS = ['kin', 'beneficiary', 'dependant', 'qualification', 'history'] as const
export type ProfileRowArea = (typeof PROFILE_ROW_AREAS)[number]
export const PROFILE_ROW_ACTIONS = ['add', 'change', 'remove'] as const
export type ProfileRowAction = (typeof PROFILE_ROW_ACTIONS)[number]

export type ProfileFieldType = 'text' | 'option' | 'date' | 'integer' | 'number' | 'boolean' | 'lookup' | 'computed'

export type ProfileFieldDef = {
  key: string
  label: string
  section: string
  readOnly: boolean
  required: boolean
  lookup: string
  type: ProfileFieldType
  maxLength: number
  options: Array<{ value: string; label: string }>
  value: string
  display: string
}

export type ProfileAreaRow = {
  ref: string
  label: string
  values: Record<string, string>
  display: Record<string, string>
}

export type ProfileArea = {
  label: string
  fields: ProfileFieldDef[]
  rows: ProfileAreaRow[]
  otherRows: Array<Record<string, string>>
}

export type ProfileChangeLine = {
  lineNo: number
  area: string
  areaName: string
  action: ProfileRowAction
  rowRef: string
  rowLabel: string
  fieldKey: string
  fieldCaption: string
  oldValue: string
  newValue: string
  newRaw: string
}

export type ProfileChanges = {
  fields: Array<{ key: string; value: string }>
  rows: Array<{ area: ProfileRowArea; action: ProfileRowAction; ref: string; values: Record<string, string> }>
}

export type ProfileChangeStatus = 'Draft' | 'Waiting for HR' | 'Approved' | 'Rejected'

export type ProfileChangeAttachment = {
  id: string
  fileName: string
  fileType: string
  size: number
  progress: number
  description: string
  uploadedAt: string
}

export type ProfileChangeRequest = {
  requestNo: string
  status: ProfileChangeStatus
  employeeNo: string
  employeeName: string
  jobTitle: string
  department: string
  note: string
  requesterUserId: string
  hrApproverUserId: string
  hrApproverName: string
  createdAt: string
  submittedAt: string
  decidedAt: string
  decidedBy: string
  decidedByName: string
  decisionRemarks: string
  changesApplied: boolean
  /** BC 1.0.3.620: HR approved, but the changes could not be written to the employee yet (why). */
  applyProblem: string
  lines: ProfileChangeLine[]
  attachments: ProfileChangeAttachment[]
  /** The draft as the edit form needs it back (rebuilt from the lines). */
  changes: ProfileChanges
}

export type ProfileEditContext = {
  employeeNo: string
  employeeName: string
  fields: ProfileFieldDef[]
  areas: Record<ProfileRowArea, ProfileArea>
  lookups: Record<string, Array<{ code: string; name: string }>>
  hrApproverUserId: string
  hrApproverName: string
  routingProblem: string
  request: ProfileChangeRequest | null
}

const STATUSES: ProfileChangeStatus[] = ['Draft', 'Waiting for HR', 'Approved', 'Rejected']
const FIELD_TYPES: ProfileFieldType[] = ['text', 'option', 'date', 'integer', 'number', 'boolean', 'lookup', 'computed']
const MIME_TYPES: Record<string, string> = {
  pdf: 'application/pdf',
  doc: 'application/msword',
  docx: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
  jpg: 'image/jpeg',
  jpeg: 'image/jpeg',
  png: 'image/png',
}

function str(value: unknown) {
  return value === undefined || value === null ? '' : String(value).trim()
}

function num(value: unknown) {
  const parsed = Number(value)
  return Number.isFinite(parsed) ? parsed : 0
}

function bool(value: unknown) {
  return value === true || ['true', '1', 'yes'].includes(str(value).toLowerCase())
}

function record(value: unknown): Record<string, unknown> {
  return value && typeof value === 'object' && !Array.isArray(value) ? (value as Record<string, unknown>) : {}
}

function list(value: unknown): unknown[] {
  return Array.isArray(value) ? value : []
}

function textMap(value: unknown): Record<string, string> {
  return Object.fromEntries(Object.entries(record(value)).map(([key, entry]) => [key, str(entry)]))
}

function parseJson(value: unknown): unknown {
  if (typeof value !== 'string') return value
  const trimmed = value.trim()
  if (!trimmed) return null
  try {
    return JSON.parse(trimmed)
  } catch {
    throw Object.assign(new Error('Business Central returned a profile answer the portal could not read.'), {
      status: 502,
    })
  }
}

function isRowArea(value: string): value is ProfileRowArea {
  return (PROFILE_ROW_AREAS as readonly string[]).includes(value)
}

function isRowAction(value: string): value is ProfileRowAction {
  return (PROFILE_ROW_ACTIONS as readonly string[]).includes(value)
}

export function parseProfileFieldDef(value: unknown): ProfileFieldDef {
  const row = record(value)
  const type = str(row.type) as ProfileFieldType
  return {
    key: str(row.key),
    label: str(row.label),
    section: str(row.section),
    readOnly: bool(row.readOnly),
    required: bool(row.required),
    lookup: str(row.lookup),
    type: FIELD_TYPES.includes(type) ? type : 'text',
    maxLength: num(row.maxLength),
    options: list(row.options).map((option) => ({ value: str(record(option).value), label: str(record(option).label) })),
    value: str(row.value),
    display: str(row.display),
  }
}

function parseArea(value: unknown, fallbackLabel: string): ProfileArea {
  const row = record(value)
  return {
    label: str(row.label) || fallbackLabel,
    fields: list(row.fields).map(parseProfileFieldDef).filter((field) => field.key),
    rows: list(row.rows).map((entry) => {
      const item = record(entry)
      return { ref: str(item.ref), label: str(item.label), values: textMap(item.values), display: textMap(item.display) }
    }),
    otherRows: list(row.otherRows).map(textMap),
  }
}

/** The draft as the edit form needs it: employee fields by key, list rows grouped by area / row / action. */
export function changesFromLines(lines: ProfileChangeLine[]): ProfileChanges {
  const fields: ProfileChanges['fields'] = []
  const rows = new Map<string, ProfileChanges['rows'][number]>()
  for (const line of lines) {
    if (line.area === 'identity' || line.area === 'contact') {
      if (line.fieldKey) fields.push({ key: line.fieldKey, value: line.newRaw })
      continue
    }
    if (!isRowArea(line.area)) continue
    const groupKey = `${line.area}|${line.rowRef}|${line.action}`
    const row = rows.get(groupKey) ?? { area: line.area, action: line.action, ref: line.rowRef, values: {} }
    if (line.action !== 'remove' && line.fieldKey) row.values[line.fieldKey] = line.newRaw
    rows.set(groupKey, row)
  }
  return { fields, rows: [...rows.values()] }
}

export function parseProfileChangeRequest(value: unknown): ProfileChangeRequest {
  const row = record(value)
  const status = str(row.status) as ProfileChangeStatus
  const lines = list(row.lines).map((entry): ProfileChangeLine => {
    const line = record(entry)
    const action = str(line.action).toLowerCase()
    return {
      lineNo: num(line.lineNo),
      area: str(line.area).toLowerCase(),
      areaName: str(line.areaName),
      action: isRowAction(action) ? action : 'change',
      rowRef: str(line.rowRef),
      rowLabel: str(line.rowLabel),
      fieldKey: str(line.fieldKey),
      fieldCaption: str(line.fieldCaption),
      oldValue: str(line.oldValue),
      newValue: str(line.newValue),
      newRaw: str(line.newRaw),
    }
  })
  const attachments = list(row.attachments).map((entry): ProfileChangeAttachment => {
    const attachment = record(entry)
    const baseName = str(attachment.fileName) || 'document'
    const extension = str(attachment.fileExtension).toLowerCase()
    const fileName =
      extension && !baseName.toLowerCase().endsWith(`.${extension}`) ? `${baseName}.${extension}` : baseName
    return {
      id: str(attachment.id),
      fileName,
      fileType: MIME_TYPES[extension] ?? 'application/octet-stream',
      size: 0,
      progress: 100,
      description: str(attachment.description) || baseName,
      uploadedAt: str(attachment.attachedAt),
    }
  })
  return {
    requestNo: str(row.requestNo),
    status: STATUSES.includes(status) ? status : 'Draft',
    employeeNo: str(row.employeeNo),
    employeeName: str(row.employeeName),
    jobTitle: str(row.jobTitle),
    department: str(row.department),
    note: str(row.note),
    requesterUserId: str(row.requesterUserId),
    hrApproverUserId: str(row.hrApproverUserId),
    hrApproverName: str(row.hrApproverName),
    createdAt: str(row.createdAt),
    submittedAt: str(row.submittedAt),
    decidedAt: str(row.decidedAt),
    decidedBy: str(row.decidedBy),
    decidedByName: str(row.decidedByName),
    decisionRemarks: str(row.decisionRemarks),
    changesApplied: bool(row.changesApplied),
    applyProblem: str(row.applyProblem),
    lines,
    attachments,
    changes: changesFromLines(lines),
  }
}

export function parseProfileChangeRequests(value: unknown): ProfileChangeRequest[] {
  return list(parseJson(value)).map(parseProfileChangeRequest).filter((request) => request.requestNo)
}

const AREA_LABELS: Record<ProfileRowArea, string> = {
  kin: 'Next of Kin',
  beneficiary: 'Beneficiary',
  dependant: 'Dependant',
  qualification: 'Qualification',
  history: 'Employment History',
}

export function parseProfileEditContext(value: unknown): ProfileEditContext {
  const row = record(parseJson(value))
  const areas = record(row.areas)
  const lookups = record(row.lookups)
  return {
    employeeNo: str(row.employeeNo),
    employeeName: str(row.employeeName),
    fields: list(row.fields).map(parseProfileFieldDef).filter((field) => field.key),
    areas: Object.fromEntries(
      PROFILE_ROW_AREAS.map((area) => [area, parseArea(areas[area], AREA_LABELS[area])]),
    ) as Record<ProfileRowArea, ProfileArea>,
    lookups: Object.fromEntries(
      Object.entries(lookups).map(([key, rows]) => [
        key,
        list(rows)
          .map((entry) => ({ code: str(record(entry).code), name: str(record(entry).name) }))
          .filter((entry) => entry.code),
      ]),
    ),
    hrApproverUserId: str(row.hrApproverUserId),
    hrApproverName: str(row.hrApproverName),
    routingProblem: str(row.routingProblem),
    request: row.request ? parseProfileChangeRequest(row.request) : null,
  }
}

function invalid(message: string) {
  return Object.assign(new Error(message), { status: 422, code: 'PROFILE_CHANGE_INVALID' })
}

const KEY_PATTERN = /^[A-Za-z][A-Za-z0-9]{0,49}$/

/** The portal's draft as BC takes it: known shapes only, short texts (BC checks every value itself). */
export function validateProfileChanges(input: unknown): ProfileChanges {
  const source = record(input)
  const fields = list(source.fields).map((entry) => {
    const item = record(entry)
    const key = str(item.key)
    if (!KEY_PATTERN.test(key)) throw invalid('A changed profile field is not valid. Refresh the page and try again.')
    const value = str(item.value)
    if (value.length > 250) throw invalid('A profile value is longer than 250 characters.')
    return { key, value }
  })
  const rows = list(source.rows).map((entry) => {
    const item = record(entry)
    const area = str(item.area)
    const action = str(item.action).toLowerCase()
    if (!isRowArea(area) || !isRowAction(action)) {
      throw invalid('A changed profile list entry is not valid. Refresh the page and try again.')
    }
    const ref = str(item.ref).slice(0, 50)
    if (action !== 'add' && !ref) throw invalid('A changed profile list entry has no reference. Refresh the page.')
    const values = textMap(item.values)
    for (const [key, value] of Object.entries(values)) {
      if (!KEY_PATTERN.test(key)) throw invalid('A changed profile list field is not valid.')
      if (value.length > 250) throw invalid('A profile value is longer than 250 characters.')
    }
    return { area, action, ref, values: action === 'remove' ? {} : values }
  })
  if (fields.length > 100 || rows.length > 100) throw invalid('Too many profile changes in one request.')
  return { fields, rows }
}

/** BC without package 1.0.3.609 does not know the profile change methods. */
export function profileChangeServiceMissing(error: unknown) {
  const message = String((error as { message?: unknown } | null)?.message ?? error ?? '')
  return /Method '?PortalProfile\w*'? is invalid|PortalProfile\w*.*(not found|not published)|soapaction/i.test(message)
}

function profileCallError(error: unknown) {
  if (profileChangeServiceMissing(error)) {
    return Object.assign(
      new Error(
        'Editing your profile needs Business Central package 1.0.3.609. Ask the BC administrator to publish it.',
      ),
      { status: 503, code: 'PROFILE_CHANGE_SERVICE_MISSING' },
    )
  }
  return error
}

async function callProfile(method: string, params: Record<string, unknown>) {
  try {
    return await callSoapMethod(method, params)
  } catch (error) {
    throw profileCallError(error)
  }
}

export async function getProfileEditContext(employeeNo: string, requesterUserId: string) {
  const result = await callProfile('PortalProfileEditContext', { employeeNo, requesterUserId })
  return parseProfileEditContext(result.returnValue)
}

export async function saveProfileChanges(input: {
  employeeNo: string
  requesterUserId: string
  changes: ProfileChanges
  note: string
  submit: boolean
}) {
  const result = await callProfile('PortalProfileChangeSave', {
    employeeNo: input.employeeNo,
    requesterUserId: input.requesterUserId,
    changesJson: JSON.stringify(input.changes),
    note: input.note.trim().slice(0, 250),
    submitRequest: input.submit,
  })
  return parseProfileChangeRequest(parseJson(result.returnValue))
}

export async function ensureProfileDraft(employeeNo: string, requesterUserId: string) {
  const result = await callProfile('PortalProfileChangeDraft', { employeeNo, requesterUserId })
  return parseProfileChangeRequest(parseJson(result.returnValue))
}

export async function withdrawProfileChange(employeeNo: string, requestNo: string) {
  const result = await callProfile('PortalProfileChangeWithdraw', { employeeNo, requestNo })
  return parseProfileChangeRequest(parseJson(result.returnValue))
}

export async function discardProfileDraft(employeeNo: string, requestNo: string) {
  const result = await callProfile('PortalProfileChangeDiscard', { employeeNo, requestNo })
  if (!bool(result.returnValue)) {
    throw Object.assign(new Error('Business Central did not discard the draft.'), { status: 502 })
  }
  return { ok: true, id: requestNo }
}

export async function listProfileChanges(employeeNo: string) {
  const result = await callProfile('PortalProfileChangeList', { employeeNo })
  return parseProfileChangeRequests(result.returnValue)
}

export async function getProfileChangeByNo(requestNo: string) {
  const trimmed = requestNo.trim()
  if (!trimmed) return null
  try {
    const result = await callProfile('PortalProfileChangeByNo', { requestNo: trimmed })
    const parsed = parseJson(result.returnValue)
    return parsed ? parseProfileChangeRequest(parsed) : null
  } catch (error) {
    if ((error as { code?: string }).code === 'PROFILE_CHANGE_SERVICE_MISSING') throw error
    if (/was not found/i.test(String((error as Error)?.message ?? ''))) return null
    throw error
  }
}

/** Requests waiting for this HR approver ('pending') or already decided by them ('decided'). */
export async function listProfileChangeApprovals(approverUserIds: string, scope: 'pending' | 'decided' = 'pending') {
  if (!approverUserIds.trim()) return []
  try {
    const result = await callSoapMethod('PortalProfileChangeApprovals', { approverUserIds, scope })
    return parseProfileChangeRequests(result.returnValue)
  } catch (error) {
    if (profileChangeServiceMissing(error)) return []
    throw error
  }
}

export async function decideProfileChange(input: {
  approverUserIds: string
  requestNo: string
  approve: boolean
  remarks: string
}) {
  const remarks = input.remarks.trim().slice(0, 250)
  if (!input.approve && remarks.length < 3) {
    throw Object.assign(new Error('Enter the reason for rejecting (at least 3 characters).'), { status: 422 })
  }
  const result = await callProfile('PortalProfileChangeDecide', {
    approverUserIds: input.approverUserIds,
    requestNo: input.requestNo,
    approve: input.approve,
    remarks,
  })
  return parseProfileChangeRequest(parseJson(result.returnValue))
}

function sameId(left: string, right: string) {
  return Boolean(left) && left.trim().toUpperCase() === right.trim().toUpperCase()
}

/** The employee who asked, or the HR approver. */
export function profileChangeActingUserMayView(request: ProfileChangeRequest, actingIds: string[], employeeNo = '') {
  if (employeeNo && sameId(request.employeeNo, employeeNo)) return true
  return actingIds.some((id) => sameId(request.hrApproverUserId, id))
}

/** HR's decision on the request, for Approved / Rejected Documents. */
export function profileChangeApproverOutcome(request: ProfileChangeRequest, actingIds: string[]) {
  if (!actingIds.some((id) => sameId(request.hrApproverUserId, id))) return null
  if (request.status === 'Approved' || request.status === 'Rejected') return request.status
  return null
}

/** "3 Bio Data changes · Dependant added · Qualification removed" */
export function profileChangeSummary(request: ProfileChangeRequest) {
  const parts: string[] = []
  const bio = request.lines.filter((line) => line.area === 'identity' || line.area === 'contact').length
  if (bio) parts.push(`${bio} Bio Data change${bio === 1 ? '' : 's'}`)
  const seen = new Set<string>()
  const rowCounts = new Map<string, number>()
  for (const line of request.lines) {
    if (line.area === 'identity' || line.area === 'contact') continue
    const groupKey = `${line.area}|${line.rowRef}|${line.action}`
    if (seen.has(groupKey)) continue
    seen.add(groupKey)
    const verb = line.action === 'add' ? 'added' : line.action === 'remove' ? 'removed' : 'changed'
    const label = `${line.areaName || line.area} ${verb}`
    rowCounts.set(label, (rowCounts.get(label) ?? 0) + 1)
  }
  for (const [label, count] of rowCounts) parts.push(count > 1 ? `${label} (${count})` : label)
  return parts.join(' · ') || 'No changes'
}

function queueStatus(status: ProfileChangeStatus) {
  if (status === 'Approved') return 'Approved'
  if (status === 'Rejected') return 'Rejected'
  return 'Pending Approval'
}

export function profileChangeApprovalQueueItem(request: ProfileChangeRequest) {
  return {
    id: `${PROFILE_CHANGE_MODULE}-${request.requestNo}`,
    requestNo: request.requestNo,
    module: PROFILE_CHANGE_MODULE,
    title: `Profile changes: ${profileChangeSummary(request)}`,
    makerEmployeeNo: request.employeeNo,
    makerName: request.employeeName,
    amount: 0,
    status: queueStatus(request.status),
    submittedAt: request.submittedAt || request.createdAt,
    approverEmployeeNo: request.hrApproverUserId,
    sourceDocumentNo: request.requestNo,
  }
}

/** Approvals detail: the request, the HR step and every change (current and new value). */
export function profileChangeToPortalRequest(request: ProfileChangeRequest, actingUserId = '') {
  const queue = profileChangeApprovalQueueItem(request)
  const hrStatus =
    request.status === 'Approved' || request.status === 'Rejected'
      ? request.status
      : request.status === 'Waiting for HR'
        ? ('Pending Approval' as const)
        : ('Waiting' as const)
  return {
    id: queue.id,
    requestNo: request.requestNo,
    requestType: PROFILE_CHANGE_MODULE,
    title: queue.title,
    status: queue.status,
    makerEmployeeNo: request.employeeNo,
    makerName: request.employeeName,
    departmentCode: request.department,
    departmentName: request.department,
    responsibleCenter: '',
    amount: 0,
    sourceDocument: { documentNo: request.requestNo, erpEntity: 'Profile Change Request' },
    createdAt: request.createdAt || request.submittedAt,
    submittedAt: request.submittedAt || request.createdAt,
    approverEmployeeNo: actingUserId || request.hrApproverUserId,
    approverName: request.hrApproverName || actingUserId,
    auditTrail: [],
    approvalSteps: [
      {
        id: 'maker',
        actorEmployeeNo: request.employeeNo,
        actorName: request.employeeName,
        role: 'Maker' as const,
        status: 'Submitted' as const,
        timestamp: request.submittedAt || request.createdAt,
        note: 'Profile changes submitted from the self-service portal',
        sequenceNo: 0,
      },
      {
        id: 'hr',
        actorEmployeeNo: request.hrApproverUserId,
        actorName: `HR: ${request.hrApproverName || request.hrApproverUserId || 'not set'}`,
        role: 'HR' as const,
        status: hrStatus,
        timestamp: request.decidedAt,
        note: request.decisionRemarks,
        sequenceNo: 1,
      },
    ],
    attachments: request.attachments,
    payload: {
      sourceDocumentAvailable: true,
      hideDocumentLines: true,
      commentRequiredOnReject: true,
      pendingStage: 1,
      pendingStageLabel: 'HR',
      bcStatus: request.status,
      reason: request.note,
      detailFacts: [
        { label: 'Job title', value: request.jobTitle },
        { label: 'Department', value: request.department },
        { label: 'Changes', value: profileChangeSummary(request) },
        {
          label: 'Written to the employee',
          value: request.status === 'Approved' ? (request.changesApplied ? 'Yes' : 'No') : '',
        },
      ].filter((fact) => fact.value),
      changeCount: request.lines.length,
      profileChanges: request.lines,
      lines: [],
    },
  }
}
