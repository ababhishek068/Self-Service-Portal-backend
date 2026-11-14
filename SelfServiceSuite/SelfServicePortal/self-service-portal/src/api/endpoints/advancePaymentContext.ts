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
  /** BC 1.0.3.651: Imprest Header has the optional Project / Assignment field. */
  supportsProjectAssignment: boolean
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
    supportsProjectAssignment?: boolean
  }>(`/api/advance-payment/context${query}`)

  return {
    employeeNo: String(raw.employeeNo ?? employeeNo ?? '').trim(),
    divisionCode: String(raw.divisionCode ?? '').trim(),
    divisionName: String(raw.divisionName ?? '').trim(),
    purposeGroup: String(raw.purposeGroup ?? '').trim(),
    purposeGroupCaption: String(raw.purposeGroupCaption ?? '').trim(),
    purposes: mapAdvancePaymentPurposes(raw.purposes),
    supportsProjectAssignment: raw.supportsProjectAssignment === true,
  }
}
