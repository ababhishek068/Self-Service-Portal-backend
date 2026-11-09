import { authGet } from '@/api/client/authClient'
import { requireAuthApiUrl } from '@/api/requireBackend'
import {
  mapAdvancePaymentPurposes,
  type AdvancePaymentPurposeRow,
} from '@/data/advanceRequestPurpose'
import type { LookupOption } from '@/api/endpoints/lookups'

export type AdvancePaymentContext = {
  employeeNo: string
  divisionCode: string
  divisionName: string
  purposeGroup: string
  purposeGroupCaption: string
  purposes: LookupOption[]
}

export async function fetchAdvancePaymentContext(employeeNo = ''): Promise<AdvancePaymentContext> {
  requireAuthApiUrl()
  const query = employeeNo ? `?employeeNo=${encodeURIComponent(employeeNo)}` : ''
  const raw = await authGet<{
    employeeNo?: string
    divisionCode?: string
    divisionName?: string
    purposeGroup?: string
    purposeGroupCaption?: string
    purposes?: AdvancePaymentPurposeRow[]
  }>(`/api/advance-payment/context${query}`)

  return {
    employeeNo: String(raw.employeeNo ?? employeeNo ?? '').trim(),
    divisionCode: String(raw.divisionCode ?? '').trim(),
    divisionName: String(raw.divisionName ?? '').trim(),
    purposeGroup: String(raw.purposeGroup ?? '').trim(),
    purposeGroupCaption: String(raw.purposeGroupCaption ?? '').trim(),
    purposes: mapAdvancePaymentPurposes(raw.purposes),
  }
}
