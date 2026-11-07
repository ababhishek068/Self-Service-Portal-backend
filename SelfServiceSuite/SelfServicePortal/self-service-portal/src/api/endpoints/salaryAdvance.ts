import { cancelModuleRequest, createModuleRequest, deleteModuleRequest, listModuleRequests } from './requestEndpoint'
import type { SalaryAdvanceForm } from '@/schemas/requestSchemas'

const config = { module: 'salaryAdvance' as const, entity: 'selfServiceSalaryAdvanceRequests' }

export const listSalaryAdvanceRequests = () => listModuleRequests(config)

export const createSalaryAdvanceRequest = (
  payload: SalaryAdvanceForm,
  employeeAccountNumber = '',
) => {
  const purpose = String(payload.purpose || payload.justification || payload.requestPurpose || '').trim()
  return createModuleRequest(config, {
    ...payload,
    purpose,
    title: `Advance request - ${purpose.slice(0, 40)}`,
    amount: 0,
    ...(employeeAccountNumber
      ? { customerNo: employeeAccountNumber, accountNo: employeeAccountNumber }
      : {}),
  })
}

export const cancelSalaryAdvanceRequest = (id: string) => cancelModuleRequest(config, id)
export const deleteSalaryAdvanceRequest = (id: string) => deleteModuleRequest(config, id)
