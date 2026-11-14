import { authGet } from '@/api/client/authClient'
import { requireAuthApiUrl } from '@/api/requireBackend'
import { cancelModuleRequest, createModuleRequest, deleteModuleRequest, listModuleRequests } from './requestEndpoint'
import type { SalaryAdvanceForm } from '@/schemas/requestSchemas'
import type { SalaryAdvanceFacts } from '@/utils/salaryAdvancePolicy'

const config = { module: 'salaryAdvance' as const, entity: 'selfServiceSalaryAdvanceRequests' }

export const salaryAdvanceModule = config

/** BC 1.0.3.652 `PortalSalaryAdvanceContext` (older BC: what the portal knows; unknown facts stay blank). */
export interface SalaryAdvanceContext extends SalaryAdvanceFacts {
  supportsDetails: boolean
  employeeNo: string
  employeeName: string
  jobTitle: string
  departmentCode: string
  departmentName: string
  divisionCode: string
  divisionName: string
  basicSalary: number
  salaryPeriod: string
  policy: { maxRepaymentMonths: number; maxNetSalaryMonths: number; legalDeductionDivisor: number }
}

export async function fetchSalaryAdvanceContext(docNo = '') {
  requireAuthApiUrl()
  return authGet<SalaryAdvanceContext>('/api/salary-advance/context', {
    params: docNo ? { docNo } : undefined,
  })
}

/** The ESSP Staff Salary Advance form as the backend takes it (POST /requests and PATCH /requests/:id). */
export interface SalaryAdvanceFormPayload {
  requestedAmount: number
  repaymentMonths: number
  /** YYYY-MM. */
  deductionStartMonth: string
  /** YYYY-MM-DD. */
  dateNeeded: string
  reason: string
  declarationAccepted: boolean
}

export const listSalaryAdvanceRequests = () => listModuleRequests(config)

export const createSalaryAdvanceRequest = (
  payload: SalaryAdvanceForm,
  employeeAccountNumber = '',
) => {
  const purpose = String(payload.purpose ?? '').trim()
  return createModuleRequest(config, {
    ...payload,
    purpose,
    title: `Salary advance - ${purpose.slice(0, 40)}`,
    amount: 0,
    ...(employeeAccountNumber
      ? { customerNo: employeeAccountNumber, accountNo: employeeAccountNumber }
      : {}),
  })
}

export const cancelSalaryAdvanceRequest = (id: string) => cancelModuleRequest(config, id)
export const deleteSalaryAdvanceRequest = (id: string) => deleteModuleRequest(config, id)
