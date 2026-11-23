import { authDelete, authGet, authPost } from '@/api/client/authClient'
import { requireAuthApiUrl } from '@/api/requireBackend'

export interface PaymentVoucherLine {
  lineNo: number
  description: string
  glAccountNo: string
  glAccountName: string
  divisionCode: string
  departmentCode: string
  grossAmount: number
  vatRate: number
  vatAmount: number
  whtRate: number
  whtAmount: number
  netAmount: number
}

export type PaymentVoucherStatus =
  | 'Draft'
  | 'Submitted'
  | 'Under Review'
  | 'Approved'
  | 'Paid'
  | 'Rejected'

export type PaymentMode = 'Bank Transfer' | 'Cheque' | 'Cash'
export type PayeeType = 'Vendor' | 'Employee' | 'Other'

export interface PaymentVoucherSignature {
  name: string
  title: string
  date: string
  comments?: string
}

export interface PaymentVoucher {
  id: string
  pvNo: string
  date: string
  payeeType: PayeeType
  payeeNo: string
  payeeName: string
  payeeTin: string
  paymentMode: PaymentMode
  bankAccountNo: string
  bankAccountName: string
  chequeOrRefNo: string
  description: string
  projectNo?: string
  projectName?: string
  status: PaymentVoucherStatus
  lines: PaymentVoucherLine[]
  totalGross: number
  totalVat: number
  totalWht: number
  totalNet: number
  amountInWords: string
  preparedBy: PaymentVoucherSignature
  checkedBy?: PaymentVoucherSignature
  approvedBy?: PaymentVoucherSignature
  receivedBy?: {
    name: string
    date: string
    idNumber?: string
  }
  rejectionReason?: string
  createdAt: string
  updatedAt: string
}

export async function fetchPaymentVouchers(params?: {
  search?: string
  status?: string
}): Promise<PaymentVoucher[]> {
  requireAuthApiUrl()
  const query = new URLSearchParams()
  if (params?.search) query.set('search', params.search)
  if (params?.status && params.status !== 'all') query.set('status', params.status)
  const qs = query.toString() ? `?${query.toString()}` : ''
  const result = await authGet<{ vouchers: PaymentVoucher[] }>(`/api/finance/payment-vouchers${qs}`)
  return result.vouchers || []
}

export async function fetchPaymentVoucher(id: string): Promise<PaymentVoucher> {
  requireAuthApiUrl()
  const result = await authGet<{ voucher: PaymentVoucher }>(`/api/finance/payment-vouchers/${encodeURIComponent(id)}`)
  return result.voucher
}

export async function savePaymentVoucher(
  payload: Partial<PaymentVoucher> & { lines: Array<Partial<PaymentVoucherLine>> },
): Promise<PaymentVoucher> {
  requireAuthApiUrl()
  const result = await authPost<{ ok: boolean; voucher: PaymentVoucher }>(
    '/api/finance/payment-vouchers',
    payload,
  )
  return result.voucher
}

export async function submitPaymentVoucher(id: string): Promise<PaymentVoucher> {
  requireAuthApiUrl()
  const result = await authPost<{ ok: boolean; voucher: PaymentVoucher }>(
    `/api/finance/payment-vouchers/${encodeURIComponent(id)}/submit`,
    {},
  )
  return result.voucher
}

export async function approvePaymentVoucher(
  id: string,
  payload?: { comments?: string; step?: 'check' | 'approve' },
): Promise<PaymentVoucher> {
  requireAuthApiUrl()
  const result = await authPost<{ ok: boolean; voucher: PaymentVoucher }>(
    `/api/finance/payment-vouchers/${encodeURIComponent(id)}/approve`,
    payload ?? {},
  )
  return result.voucher
}

export async function rejectPaymentVoucher(
  id: string,
  reason: string,
): Promise<PaymentVoucher> {
  requireAuthApiUrl()
  const result = await authPost<{ ok: boolean; voucher: PaymentVoucher }>(
    `/api/finance/payment-vouchers/${encodeURIComponent(id)}/reject`,
    { reason },
  )
  return result.voucher
}

export async function deletePaymentVoucher(id: string): Promise<void> {
  requireAuthApiUrl()
  await authDelete(`/api/finance/payment-vouchers/${encodeURIComponent(id)}`)
}
