import { authGet } from '@/api/client/authClient'
import { requireAuthApiUrl } from '@/api/requireBackend'
import { fetchCurrentUser } from './auth'
import type { PortalRequest } from '@/types/erp.types'

export interface DashboardModuleCount {
  key: string
  label: string
  count: number
}

export interface DashboardStatusCount {
  label: string
  count: number
}

export interface DashboardLowStockItem {
  itemNo: string
  description: string
  quantity: number
  locationCode: string
}

export interface DashboardStockAvailability {
  available: boolean
  stockOnHand: number
  activeItems: number
  lowStock: DashboardLowStockItem[]
}

interface DashboardSummary {
  pendingApprovals: number
  approvedDocuments: number
  rejectedDocuments: number
  leaveApplications: number
  staffClaims: number
  imprestRequisitions: number
  imprestSurrenders: number
  pettyCash?: number
  purchaseRequisitions: number
  storeRequisitions: number
  overtimeRequests?: number
  leaveBalance: number
  openRequests: number
  unresolved: number
  recentActivity: PortalRequest[]
  documentsByModule?: DashboardModuleCount[]
  workflowStatus?: DashboardStatusCount[]
  stockAvailability?: DashboardStockAvailability
}

export const getCurrentEmployee = async () => {
  requireAuthApiUrl()
  return fetchCurrentUser()
}

export const getDashboardSummary = async () => {
  requireAuthApiUrl()
  return authGet<DashboardSummary>('/api/dashboard/summary')
}

export const listItemMaster = async () => {
  requireAuthApiUrl()
  const { rows } = await authGet<{ rows: unknown[] }>('/api/items')
  return rows
}

export const getStoreUsageReport = () => {
  requireAuthApiUrl()
  return authGet('/api/reports/store-usage')
}

export const getLeaveBalanceReport = () => {
  requireAuthApiUrl()
  return authGet('/api/reports/leave-balance')
}

export const getGatePassLogReport = () => {
  requireAuthApiUrl()
  return authGet('/api/reports/gate-pass-log')
}
