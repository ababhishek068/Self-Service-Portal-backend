import { authGet, authPatch, authPost } from '@/api/client/authClient'
import { requireAuthApiUrl } from '@/api/requireBackend'

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

export type IctHelpdeskMeta = {
  canManageDesk: boolean
  requestTypes: Array<{ code: string; description: string; assignedStaff: string; staffName: string }>
  officers: Array<{ employeeNo: string; name: string }>
  priorities: Array<{ value: string; label: string }>
  statuses: Array<{ value: string; label: string }>
}

export type CreateIctTicketInput = {
  subject: string
  description: string
  requestType: string
  priority: string
  contactPhone?: string
  contactEmail?: string
  locationBranch?: string
  department?: string
  division?: string
  requiredDate?: string
  attachmentName?: string
}

export type UpdateIctTicketInput = {
  trackingStatus?: string
  assignee?: string
  ictTeam?: string
  expectedResolutionDate?: string
  actionTaken?: string
  rootCause?: string
  resolutionRemarks?: string
  closureReason?: string
  satisfaction?: number
  userClosingRemarks?: string
}

export async function fetchIctHelpdeskMeta() {
  requireAuthApiUrl()
  return authGet<IctHelpdeskMeta>('/api/ict/helpdesk/meta')
}

export async function listIctHelpdeskTickets(scope?: 'mine' | 'desk') {
  requireAuthApiUrl()
  const query =
    scope === 'mine' ? '?scope=mine' : scope === 'desk' ? '?scope=desk' : ''
  return authGet<{ rows: IctHelpdeskTicket[]; scope: string; canManageDesk: boolean }>(
    `/api/ict/helpdesk/tickets${query}`,
  )
}

export async function getIctHelpdeskTicket(no: string) {
  requireAuthApiUrl()
  return authGet<{ ticket: IctHelpdeskTicket; canManageDesk: boolean }>(
    `/api/ict/helpdesk/tickets/${encodeURIComponent(no)}`,
  )
}

export async function createIctHelpdeskTicket(input: CreateIctTicketInput) {
  requireAuthApiUrl()
  return authPost<{ ticket: IctHelpdeskTicket }, CreateIctTicketInput>('/api/ict/helpdesk/tickets', input)
}

export async function updateIctHelpdeskTicket(no: string, input: UpdateIctTicketInput) {
  requireAuthApiUrl()
  return authPatch<{ ticket: IctHelpdeskTicket }, UpdateIctTicketInput>(
    `/api/ict/helpdesk/tickets/${encodeURIComponent(no)}`,
    input,
  )
}

export async function cancelIctHelpdeskTicket(no: string, remarks: string) {
  requireAuthApiUrl()
  return authPost<{ ticket: IctHelpdeskTicket }, { remarks: string }>(
    `/api/ict/helpdesk/tickets/${encodeURIComponent(no)}/cancel`,
    { remarks },
  )
}

export async function confirmIctHelpdeskTicket(no: string, remarks: string, satisfaction: number) {
  requireAuthApiUrl()
  return authPost<{ ticket: IctHelpdeskTicket }, { remarks: string; satisfaction: number }>(
    `/api/ict/helpdesk/tickets/${encodeURIComponent(no)}/confirm`,
    { remarks, satisfaction },
  )
}
