import { authGet } from '@/api/client/authClient'
import { requireAuthApiUrl } from '@/api/requireBackend'
import {
  isOtherOption,
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
  /** BC 1.0.3.653: the requester confirms receipt of the paid advance before settlement. */
  supportsReceiptConfirmation: boolean
  /**
   * BC 1.0.3.662: Confirm Payment Received right after approval (client, 16 Nov 2026: like the Store receipt), not
   * only once Finance's payment is in BC; settlement still needs that payment.
   */
  receiptAfterApproval: boolean
  /**
   * BC 1.0.3.653: the ESSP Advance Request Types, in the client's order (empty on older BC). `meta.requiresOtherDetails`
   * marks Other (Specify); `meta.glAccount` is blank until Finance sets the account.
   */
  advanceTypes: LookupOption[]
}

type AdvanceTypeRow = { code?: string; description?: string; glAccount?: string; requiresOtherDetails?: boolean; sortOrder?: number }

function mapAdvanceTypes(rows: AdvanceTypeRow[] | undefined): LookupOption[] {
  const options = (Array.isArray(rows) ? rows : [])
    .filter((row) => String(row.code ?? '').trim())
    .sort((left, right) => Number(left.sortOrder ?? 0) - Number(right.sortOrder ?? 0))
    .map((row) => ({
      value: String(row.code ?? '').trim(),
      label: String(row.description ?? row.code ?? '').trim(),
      meta: { glAccount: String(row.glAccount ?? '').trim(), requiresOtherDetails: row.requiresOtherDetails === true },
    }))
  // Other (Specify) last.
  return [...options.filter((option) => !isOtherOption(option)), ...options.filter((option) => isOtherOption(option))]
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
    supportsReceiptConfirmation?: boolean
    receiptAfterApproval?: boolean
    advanceTypes?: AdvanceTypeRow[]
  }>(`/api/advance-payment/context${query}`)

  return {
    employeeNo: String(raw.employeeNo ?? employeeNo ?? '').trim(),
    divisionCode: String(raw.divisionCode ?? '').trim(),
    divisionName: String(raw.divisionName ?? '').trim(),
    purposeGroup: String(raw.purposeGroup ?? '').trim(),
    purposeGroupCaption: String(raw.purposeGroupCaption ?? '').trim(),
    purposes: mapAdvancePaymentPurposes(raw.purposes),
    supportsProjectAssignment: raw.supportsProjectAssignment === true,
    supportsReceiptConfirmation: raw.supportsReceiptConfirmation === true,
    receiptAfterApproval: raw.receiptAfterApproval === true,
    advanceTypes: mapAdvanceTypes(raw.advanceTypes),
  }
}
