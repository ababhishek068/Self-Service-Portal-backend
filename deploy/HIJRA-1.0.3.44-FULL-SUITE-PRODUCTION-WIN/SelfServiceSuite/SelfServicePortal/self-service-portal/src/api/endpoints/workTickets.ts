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
  bookingType?: string
  travelerEmployeeNo?: string
  travelerName?: string
  flightFrom?: string
  flightTo?: string
  departureDate?: string
  returnDate?: string
  ticketClass?: string
  airlinePreference?: string
  bookingJustification?: string
  bookingConfirmationNo?: string
  bookingConfirmed?: boolean
  bookingConfirmedDate?: string
}

export type WorkTicketHeaderInput = {
  previousTicketNo?: string
  gkNo: string
  type?: string
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

export type WorkTicketFlightInput = {
  travelerEmployeeNo?: string
  flightFrom: string
  flightTo: string
  departureDate: string
  returnDate?: string
  ticketClass?: 'Economy' | 'Business'
  airlinePreference?: string
  justification?: string
}

/** UAT Work Ticket R45/R46: save flight booking fields. */
export async function saveWorkTicketFlight(ticketNo: string, payload: WorkTicketFlightInput) {
  requireAuthApiUrl()
  return authPost<{ ok: boolean }>(
    `/api/work-tickets/${encodeURIComponent(ticketNo)}/flight`,
    payload,
  )
}

/** UAT Work Ticket R48: record booking confirmation receipt. */
export async function confirmWorkTicketBooking(ticketNo: string, confirmationNo: string) {
  requireAuthApiUrl()
  return authPost<{ ok: boolean }>(
    `/api/work-tickets/${encodeURIComponent(ticketNo)}/confirm-booking`,
    { confirmationNo },
  )
}
