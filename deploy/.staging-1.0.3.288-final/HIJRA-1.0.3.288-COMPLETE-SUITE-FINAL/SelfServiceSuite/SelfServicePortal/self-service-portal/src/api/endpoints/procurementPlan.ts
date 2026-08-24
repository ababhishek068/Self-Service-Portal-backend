import { authGet, authPost } from '@/api/client/authClient'
import { requireAuthApiUrl } from '@/api/requireBackend'

export type ProcurementPlanHeader = {
  BudgetName?: string
  GlobalDimension1?: string
  GlobalDimension2?: string
  ProcurementPlanPeriod?: string
  Status?: string
}

export type ProcurementPlanLine = {
  BudgetName?: string
  Department?: string
  Type?: string
  TypeNo?: string
  Description?: string
  Quantity?: number
  UnitCost?: number
  Amount?: number
  PlanDate?: string
  ProcurementPlanPeriod?: string
  GlobalDimension1?: string
}

export async function listProcurementPlans(params?: { budgetName?: string; planPeriod?: string }) {
  requireAuthApiUrl()
  return authGet<{ headers: ProcurementPlanHeader[]; lines: ProcurementPlanLine[] }>(
    '/api/procurement-plans',
    { params: params ?? {} },
  )
}

export async function createProcurementPlan(payload: {
  budgetName: string
  globalDim1?: string
  globalDim2?: string
  planPeriod: string
}) {
  requireAuthApiUrl()
  return authPost<{ ok: boolean }>('/api/procurement-plans', payload)
}

export async function saveProcurementPlanLine(payload: {
  budgetName: string
  department: string
  lineType: number | string
  typeNo: string
  globalDim1?: string
  planPeriod: string
  quantity: number
  unitCost: number
  planDate?: string
}) {
  requireAuthApiUrl()
  return authPost<{ ok: boolean }>('/api/procurement-plans/lines', payload)
}

export async function deleteProcurementPlanLine(payload: {
  budgetName: string
  department: string
  lineType: number | string
  typeNo: string
  globalDim1?: string
  planPeriod: string
}) {
  requireAuthApiUrl()
  return authPost<{ ok: boolean }>('/api/procurement-plans/lines/delete', payload)
}

export async function submitProcurementPlan(payload: {
  budgetName: string
  globalDim1?: string
  globalDim2?: string
  planPeriod: string
}) {
  requireAuthApiUrl()
  return authPost<{ ok: boolean }>('/api/procurement-plans/submit', payload)
}
