import { authDelete, authGet, authHttp, authPost } from '@/api/client/authClient'
import { requireAuthApiUrl } from '@/api/requireBackend'
import { saveBlobAs } from '@/api/endpoints/requestEndpoint'

/** Employee profile changes (BC 1.0.3.609): the employee edits, HR verifies, BC writes them. */
export type ProfileRowArea = 'kin' | 'beneficiary' | 'dependant' | 'qualification' | 'history'
export type ProfileRowAction = 'add' | 'change' | 'remove'
export type ProfileFieldType = 'text' | 'option' | 'date' | 'integer' | 'number' | 'boolean' | 'lookup' | 'computed'

export interface ProfileFieldDef {
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

export interface ProfileAreaRow {
  ref: string
  label: string
  values: Record<string, string>
  display: Record<string, string>
}

export interface ProfileArea {
  label: string
  fields: ProfileFieldDef[]
  rows: ProfileAreaRow[]
  otherRows: Array<Record<string, string>>
}

export interface ProfileChangeLine {
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

export interface ProfileRowChange {
  area: ProfileRowArea
  action: ProfileRowAction
  ref: string
  values: Record<string, string>
}

export interface ProfileChanges {
  fields: Array<{ key: string; value: string }>
  rows: ProfileRowChange[]
}

export interface ProfileChangeAttachment {
  id: string
  fileName: string
  fileType: string
  size: number
  progress: number
  description: string
  uploadedAt: string
}

export type ProfileChangeStatus = 'Draft' | 'Waiting for HR' | 'Approved' | 'Rejected'

export interface ProfileChangeRequest {
  requestNo: string
  status: ProfileChangeStatus
  employeeNo: string
  employeeName: string
  note: string
  hrApproverUserId: string
  hrApproverName: string
  createdAt: string
  submittedAt: string
  decidedAt: string
  decidedByName: string
  decisionRemarks: string
  changesApplied: boolean
  lines: ProfileChangeLine[]
  attachments: ProfileChangeAttachment[]
  changes: ProfileChanges
}

export interface ProfileEditContext {
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

export async function fetchProfileEditContext() {
  requireAuthApiUrl()
  return authGet<ProfileEditContext>('/api/profile/edit-context')
}

/** Save the draft, or with `submit` send it to HR. */
export async function saveProfileChanges(input: { changes: ProfileChanges; note: string; submit: boolean }) {
  requireAuthApiUrl()
  return authPost<ProfileChangeRequest>('/api/profile/changes', input)
}

export async function withdrawProfileChange(requestNo: string) {
  requireAuthApiUrl()
  return authPost<ProfileChangeRequest>(`/api/profile/changes/${encodeURIComponent(requestNo)}/withdraw`, {})
}

export async function discardProfileDraft(requestNo: string) {
  requireAuthApiUrl()
  return authDelete<{ ok: boolean; id: string }>(`/api/profile/changes/${encodeURIComponent(requestNo)}`)
}

export async function uploadProfileDocument(input: { fileName: string; contentBase64: string; description: string }) {
  requireAuthApiUrl()
  return authPost<ProfileChangeRequest>('/api/profile/changes/attachments', input)
}

export async function deleteProfileDocument(requestNo: string, attachmentId: string) {
  requireAuthApiUrl()
  return authDelete<ProfileChangeRequest>(
    `/api/profile/changes/${encodeURIComponent(requestNo)}/attachments/${encodeURIComponent(attachmentId)}`,
  )
}

export async function downloadProfileDocument(requestNo: string, attachment: ProfileChangeAttachment) {
  requireAuthApiUrl()
  const response = await authHttp.get<Blob>(
    `/api/profile/changes/${encodeURIComponent(requestNo)}/attachments/${encodeURIComponent(attachment.id)}/download`,
    { responseType: 'blob' },
  )
  saveBlobAs(response.data, attachment.fileName)
}

/** "35 Years, 1 Months and 20 Days", as on the BC employee card. */
export function ageText(dateOfBirth: string, today = new Date()) {
  const match = /^(\d{4})-(\d{2})-(\d{2})$/.exec(dateOfBirth.trim())
  if (!match) return ''
  const born = new Date(Number(match[1]), Number(match[2]) - 1, Number(match[3]))
  if (Number.isNaN(born.getTime()) || born > today) return ''
  let years = today.getFullYear() - born.getFullYear()
  let months = today.getMonth() - born.getMonth()
  let days = today.getDate() - born.getDate()
  if (days < 0) {
    months -= 1
    days += new Date(today.getFullYear(), today.getMonth(), 0).getDate()
  }
  if (months < 0) {
    years -= 1
    months += 12
  }
  return `${years} Years, ${months} Months and ${days} Days`
}
