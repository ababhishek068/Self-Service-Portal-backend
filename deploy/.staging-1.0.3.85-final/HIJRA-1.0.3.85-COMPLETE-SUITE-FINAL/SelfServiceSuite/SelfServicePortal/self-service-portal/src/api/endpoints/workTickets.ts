import { authDelete, authGet, authPost } from '@/api/client/authClient'
import { requireAuthApiUrl } from '@/api/requireBackend'

export interface WorkTicketRow {
  id: string
  ticketNo: string
  previousTicketNo: string
  gkNo: string
  type: string
  department: string
  status: string
  bookingType: string
  travelerEmployeeNo: string
  travelerName: string
  flightFrom: string
  flightTo: string
  departureDate: string
  returnDate: string
  ticketClass: string
  airlinePreference: string
  justification: string
  bookingConfirmationNo: string
  bookingConfirmed: boolean
  bookingConfirmedDate: string
}

export interface WorkTicketLine {
  id: string
  lineNo: string
  driverName: string
  departureFrom: string
  destination: string
  workDate: string
  authorizingOfficerName: string
}

export interface WorkTicketDetail extends WorkTicketRow {
  lines: WorkTicketLine[]
}

export type WorkTicketHeaderInput = {
  previousTicketNo?: string
  gkNo?: string
  type?: string
  travelerEmployeeNo: string
  flightFrom: string
  flightTo: string
  departureDate: string
  returnDate?: string
  ticketClass: string
  airlinePreference?: string
  justification: string
}

export type WorkTicketLineInput = {
  driverName: string
  departureFrom: string
  destination: string
  workDate: string
  authorizingOfficer: string
}

export async function listWorkTickets(): Promise<WorkTicketRow[]> {
  requireAuthApiUrl()
  const { rows } = await authGet<{ rows: WorkTicketRow[] }>('/api/work-tickets')
  return rows
}

export async function getWorkTicket(ticketNo: string) {
  requireAuthApiUrl()
  return authGet<WorkTicketDetail>(`/api/work-tickets/${encodeURIComponent(ticketNo)}`)
}

export async function createWorkTicket(payload: WorkTicketHeaderInput) {
  requireAuthApiUrl()
  return authPost<WorkTicketDetail, WorkTicketHeaderInput>('/api/work-tickets', payload)
}

export async function addWorkTicketLine(ticketNo: string, payload: WorkTicketLineInput) {
  requireAuthApiUrl()
  return authPost<{ ok: boolean }, WorkTicketLineInput>(
    `/api/work-tickets/${encodeURIComponent(ticketNo)}/lines`,
    payload,
  )
}

export async function deleteWorkTicketLine(ticketNo: string, lineNo: string) {
  requireAuthApiUrl()
  return authDelete<void>(
    `/api/work-tickets/${encodeURIComponent(ticketNo)}/lines/${encodeURIComponent(lineNo)}`,
  )
}

export async function confirmWorkTicketBooking(ticketNo: string, confirmationNo: string) {
  requireAuthApiUrl()
  return authPost<{ ok: boolean }, { confirmationNo: string }>(
    `/api/work-tickets/${encodeURIComponent(ticketNo)}/confirmation`,
    { confirmationNo },
  )
}

export async function submitWorkTicket(ticketNo: string) {
  requireAuthApiUrl()
  return authPost<{ ok: boolean }>(
    `/api/work-tickets/${encodeURIComponent(ticketNo)}/submit`,
    {},
  )
}

export async function cancelWorkTicketApproval(ticketNo: string) {
  requireAuthApiUrl()
  return authPost<{ ok: boolean }>(
    `/api/work-tickets/${encodeURIComponent(ticketNo)}/cancel`,
    {},
  )
}
