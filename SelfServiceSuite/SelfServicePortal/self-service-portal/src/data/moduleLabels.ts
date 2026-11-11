import type { PortalModuleKey } from '@/types/erp.types'

/** Human-readable label for each portal module. */
export const moduleLabels: Record<PortalModuleKey, string> = {
  imprest: 'Advance Payment',
  imprestSurrender: 'Advance Settlement',
  staffClaim: 'Staff Claims',
  pettyCash: 'Petty Cash Request',
  pettyCashReplenishment: 'Petty Cash Replenishment',
  storeRequisition: 'Store Requisition',
  purchaseRequisition: 'Purchase Requisition',
  fuelRequest: 'Fuel Requisition',
  transport: 'Transport Requisition',
  maintenance: 'Maintenance Request',
  transferOrder: 'Transfer Orders',
  vehicleTransfer: 'Vehicle Transfer',
  gatePass: 'Gate Pass',
  leave: 'Leave Requisition',
  overtime: 'Overtime Request (Stage 1)',
  overtimeWork: 'Overtime Request',
  overtimePayment: 'Overtime Payment Request',
  travel: 'Travel Request',
  salaryAdvance: 'Salary Advance Request',
  training: 'Training Request',
  documentRequisition: 'Document Requisition',
  employeeExit: 'Employee Exit',
  hrServiceLetter: 'HR Service Letters',
  profileChange: 'Profile Change',
}

/** Ordered list of statuses a request can transition through. */
export const statusFlow = [
  'Draft',
  'Pending Approval',
  'Approved',
  'Rejected',
  'Cancelled',
  'Posted',
  'Pending',
] as const

export type StatusFlowValue = (typeof statusFlow)[number]
