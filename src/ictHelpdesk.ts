import { callSoapMethod } from './bcClient.js'
import type { AuthUser } from './auth.js'
import { config } from './config.js'

export type IctHelpdeskTicket = {
  no: string
  date: string
  requestedBy: string
  requestorName: string
  department: string
  division: string
  contactPhone: string
  contactEmail: string
  locationBranch: string
  requestType: string
  requisitionCategory: string
  subject: string
  description: string
  priority: string
  urgencyPriority: string
  requiredDate: string
  trackingStatus: string
  status: string
  resolutionStatus: string
  assignee: string
  assigneeName: string
  ictTeam: string
  dateAssigned: string
  expectedResolutionDate: string
  actionTaken: string
  rootCause: string
  resolutionRemarks: string
  dateResolved: string
  resolvedBy: string
  userClosingRemarks: string
  dateUserConfirmed: string
  satisfaction: number
  closureReason: string
  cancelledRemarks: string
  attachmentName: string
}

export type IctHelpdeskRequestType = {
  code: string
  description: string
  assignedStaff: string
  staffName: string
}

export type IctHelpdeskOfficer = {
  employeeNo: string
  name: string
}

export const ICT_REQUEST_TYPES = [
  { value: 'Incident / Problem', label: 'Incident / Problem' },
  { value: 'Service Request', label: 'Service Request' },
  { value: 'Access Request', label: 'Access Request' },
  { value: 'Hardware', label: 'Hardware' },
  { value: 'Software', label: 'Software' },
  { value: 'Network', label: 'Network' },
  { value: 'ERP / Application', label: 'ERP / Application' },
  { value: 'Email', label: 'Email' },
  { value: 'Printer', label: 'Printer' },
  { value: 'Other', label: 'Other' },
] as const

export const ICT_PRIORITIES = [
  { value: 'Critical', label: 'Critical' },
  { value: 'High', label: 'High' },
  { value: 'Medium', label: 'Medium' },
  { value: 'Low', label: 'Low' },
] as const

export const ICT_TRACKING_STATUSES = [
  { value: 'NEW', label: 'New' },
  { value: 'ASSIGNED', label: 'Assigned' },
  { value: 'IN_PROGRESS', label: 'In Progress' },
  { value: 'PENDING_USER', label: 'Pending User' },
  { value: 'PENDING_VENDOR', label: 'Pending Vendor' },
  { value: 'RESOLVED', label: 'Resolved' },
  { value: 'CLOSED', label: 'Closed' },
  { value: 'CANCELLED', label: 'Cancelled' },
] as const

function parseJsonPayload(raw: unknown): Record<string, unknown> {
  if (raw && typeof raw === 'object' && !Array.isArray(raw)) return raw as Record<string, unknown>
  const text = String(raw ?? '').trim()
  if (!text) return {}
  try {
    const parsed = JSON.parse(text) as unknown
    if (parsed && typeof parsed === 'object' && !Array.isArray(parsed)) {
      return parsed as Record<string, unknown>
    }
  } catch {
    /* BC may return plain text faults */
  }
  return { raw: text }
}

function text(row: Record<string, unknown>, ...keys: string[]) {
  for (const key of keys) {
    const value = row[key]
    if (value !== undefined && value !== null && String(value).trim() !== '') {
      const cleaned = String(value).trim()
      if (cleaned.startsWith('0001-01-01')) return ''
      return cleaned
    }
  }
  return ''
}

function numberValue(row: Record<string, unknown>, ...keys: string[]) {
  for (const key of keys) {
    const value = Number(row[key])
    if (Number.isFinite(value)) return value
  }
  return 0
}

export function mapIctTicket(raw: unknown): IctHelpdeskTicket {
  const row = parseJsonPayload(raw)
  return {
    no: text(row, 'no', 'No'),
    date: text(row, 'date', 'Date'),
    requestedBy: text(row, 'requestedBy', 'Requested_By'),
    requestorName: text(row, 'requestorName', 'Requestor_Name'),
    department: text(row, 'department', 'Global_Dimension_2_Code'),
    division: text(row, 'division', 'Global_Dimension_1_Code'),
    contactPhone: text(row, 'contactPhone', 'Portal_Contact_Phone'),
    contactEmail: text(row, 'contactEmail', 'Portal_Contact_Email'),
    locationBranch: text(row, 'locationBranch', 'Portal_Location_Branch'),
    requestType: text(row, 'requestType', 'Portal_Request_Type'),
    requisitionCategory: text(row, 'requisitionCategory', 'Requisition_Category'),
    subject: text(row, 'subject', 'Portal_Subject'),
    description: text(row, 'description', 'General_Description'),
    priority: text(row, 'priority') || 'Medium',
    urgencyPriority: text(row, 'urgencyPriority', 'Urgency_Priority'),
    requiredDate: text(row, 'requiredDate', 'Required_Date'),
    trackingStatus: text(row, 'trackingStatus', 'Portal_Tracking_Status') || 'NEW',
    status: text(row, 'status') || 'New',
    resolutionStatus: text(row, 'resolutionStatus', 'Resolution_Status'),
    assignee: text(row, 'assignee', 'Assignee'),
    assigneeName: text(row, 'assigneeName', 'Assignee_Name'),
    ictTeam: text(row, 'ictTeam', 'Portal_ICT_Team'),
    dateAssigned: text(row, 'dateAssigned', 'Portal_Date_Assigned'),
    expectedResolutionDate: text(row, 'expectedResolutionDate', 'Portal_Expected_Resolve'),
    actionTaken: text(row, 'actionTaken', 'Portal_Action_Taken'),
    rootCause: text(row, 'rootCause', 'Portal_Root_Cause'),
    resolutionRemarks: text(row, 'resolutionRemarks', 'Resolution_Remarks'),
    dateResolved: text(row, 'dateResolved', 'Date_Resolved'),
    resolvedBy: text(row, 'resolvedBy', 'Portal_Resolved_By'),
    userClosingRemarks: text(row, 'userClosingRemarks', 'User_Closing_Remarks'),
    dateUserConfirmed: text(row, 'dateUserConfirmed', 'Date_User_Confirmed'),
    satisfaction: numberValue(row, 'satisfaction', 'Portal_Satisfaction'),
    closureReason: text(row, 'closureReason', 'Portal_Closure_Reason'),
    cancelledRemarks: text(row, 'cancelledRemarks', 'Cancelled_Remarks'),
    attachmentName: text(row, 'attachmentName', 'Portal_Attachment_Name'),
  }
}

function mapRows<T>(raw: unknown, mapOne: (row: Record<string, unknown>) => T): T[] {
  const payload = parseJsonPayload(raw)
  const rows = Array.isArray(payload.rows) ? payload.rows : []
  return rows
    .filter((row): row is Record<string, unknown> => Boolean(row) && typeof row === 'object')
    .map(mapOne)
}

export function authUserIsIctAdmin(
  user: Pick<AuthUser, 'roles' | 'jobTitle' | 'employeeNo'>,
) {
  if ((user.roles ?? []).includes('ictAdmin')) return true
  const empNo = String(user.employeeNo ?? '').toUpperCase()
  if (
    empNo &&
    config.ICT_OVERRIDE_EMPNOS.map((no) => no.toUpperCase()).includes(empNo)
  ) {
    return true
  }
  const title = String(user.jobTitle ?? '')
  return /\bict\s*(officer|admin|administrator|help\s*desk)?\b|\bit\s*manag|\bhelp\s*desk\b|\binformation technology\b/i.test(
    title,
  )
}

/** True when a ticket is permanently finished and must not be edited/reopened. */
export function ictTicketIsFinal(ticket: Pick<IctHelpdeskTicket, 'trackingStatus' | 'resolutionStatus' | 'status'>) {
  const tracking = String(ticket.trackingStatus ?? '').toUpperCase().replace(/\s+/g, '_')
  const resolution = String(ticket.resolutionStatus ?? '').toLowerCase()
  const status = String(ticket.status ?? '').toLowerCase()
  return (
    tracking === 'CLOSED' ||
    tracking === 'CANCELLED' ||
    tracking === 'CANCELED' ||
    resolution.includes('closed') ||
    resolution.includes('cancelled') ||
    resolution.includes('canceled') ||
    status === 'closed' ||
    status === 'cancelled' ||
    status === 'canceled'
  )
}

function ictSoapError(error: unknown) {
  const message = String((error as { message?: unknown } | null)?.message ?? error ?? '')
  if (/was not found|could not be found|CreateIctHelpdeskTicket|ListIctHelpdeskTickets/i.test(message)) {
    return Object.assign(
      new Error(
        'ICT Helpdesk SOAP methods are not published yet. Publish BC app 1.0.3.201+, then republish the CuStaffPortal web service.',
      ),
      { status: 503, code: 'ICT_HELP_DESK_SERVICE_MISSING' },
    )
  }
  if (/ICT Requisition Nos/i.test(message)) {
    return Object.assign(
      new Error('Cash Office Setup is missing ICT Requisition Nos. Ask Finance/ICT to set the number series in Business Central.'),
      { status: 503, code: 'ICT_NOSERIES_MISSING' },
    )
  }
  return error
}

async function callIctSoap(method: string, params: Record<string, unknown>) {
  try {
    return await callSoapMethod(method, params)
  } catch (error) {
    throw ictSoapError(error)
  }
}

export async function listIctHelpdeskTickets(employeeNo: string, ictView: boolean) {
  const result = await callIctSoap('ListIctHelpdeskTickets', {
    employeeNo: ictView ? '' : employeeNo,
    ictView,
  })
  return mapRows(result.returnValue, (row) => mapIctTicket(row))
}

export async function getIctHelpdeskTicket(docNo: string) {
  const result = await callIctSoap('GetIctHelpdeskTicket', { docNo })
  return mapIctTicket(result.returnValue)
}

export async function createIctHelpdeskTicket(input: {
  employeeNo: string
  dim1: string
  dim2: string
  priorityCode: string
  requestType: string
  subject: string
  description: string
  contactPhone: string
  contactEmail: string
  locationBranch: string
  requiredDate: string
  attachmentName: string
}) {
  const result = await callIctSoap('CreateIctHelpdeskTicket', {
    employeeNo: input.employeeNo,
    dim1: input.dim1,
    dim2: input.dim2,
    priorityCode: input.priorityCode,
    requestType: input.requestType,
    subject: input.subject,
    description: input.description,
    contactPhone: input.contactPhone,
    contactEmail: input.contactEmail,
    locationBranch: input.locationBranch,
    requiredDate: input.requiredDate || '0001-01-01',
    attachmentName: input.attachmentName,
  })
  return mapIctTicket(result.returnValue)
}

export async function updateIctHelpdeskTicket(input: {
  docNo: string
  actorEmployeeNo: string
  trackingStatus: string
  assignee: string
  ictTeam: string
  expectedResolve: string
  actionTaken: string
  rootCause: string
  resolutionRemarks: string
  closureReason: string
  satisfaction: number
  userClosingRemarks: string
}) {
  const result = await callIctSoap('UpdateIctHelpdeskTicket', {
    docNo: input.docNo,
    actorEmployeeNo: input.actorEmployeeNo,
    trackingStatus: input.trackingStatus,
    assignee: input.assignee,
    ictTeam: input.ictTeam,
    expectedResolve: input.expectedResolve || '0001-01-01',
    actionTaken: input.actionTaken,
    rootCause: input.rootCause,
    resolutionRemarks: input.resolutionRemarks,
    closureReason: input.closureReason,
    satisfaction: input.satisfaction,
    userClosingRemarks: input.userClosingRemarks,
  })
  return mapIctTicket(result.returnValue)
}

export async function cancelIctHelpdeskTicket(docNo: string, cancelRemarks: string) {
  const result = await callIctSoap('CancelIctHelpdeskTicket', { docNo, cancelRemarks })
  return mapIctTicket(result.returnValue)
}

export async function confirmIctHelpdeskTicket(docNo: string, remarks: string, satisfaction: number) {
  const result = await callIctSoap('ConfirmIctHelpdeskTicket', { docNo, remarks, satisfaction })
  return mapIctTicket(result.returnValue)
}

export async function listIctHelpdeskRequestTypes(): Promise<IctHelpdeskRequestType[]> {
  const result = await callIctSoap('ListIctHelpdeskRequestTypes', {})
  const rows = mapRows(result.returnValue, (row) => ({
    code: text(row, 'code'),
    description: text(row, 'description'),
    assignedStaff: text(row, 'assignedStaff'),
    staffName: text(row, 'staffName'),
  }))
  if (rows.length > 0) return rows
  return ICT_REQUEST_TYPES.map((row) => ({
    code: row.value,
    description: row.label,
    assignedStaff: '',
    staffName: '',
  }))
}

export async function listIctHelpdeskOfficers(): Promise<IctHelpdeskOfficer[]> {
  const result = await callIctSoap('ListIctHelpdeskOfficers', {})
  return mapRows(result.returnValue, (row) => ({
    employeeNo: text(row, 'employeeNo'),
    name: text(row, 'name'),
  }))
}
