import fs from 'node:fs'
import path from 'node:path'
import { z } from 'zod'

export interface PaymentVoucherLine {
  lineNo: number
  description: string
  glAccountNo: string
  glAccountName: string
  divisionCode: string
  departmentCode: string
  grossAmount: number
  vatRate: number // 15 or 0
  vatAmount: number
  whtRate: number // 2, 30, or 0
  whtAmount: number
  netAmount: number
}

export type PaymentVoucherStatus = 'Draft' | 'Submitted' | 'Under Review' | 'Approved' | 'Paid' | 'Rejected'
export type PaymentMode = 'Bank Transfer' | 'Cheque' | 'Cash'
export type PayeeType = 'Vendor' | 'Employee' | 'Other'

export interface PaymentVoucherSignature {
  name: string
  title: string
  date: string
  signature?: string
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

const STORAGE_FILE = path.resolve(process.cwd(), 'data', 'payment-vouchers.json')

function ensureStorageDir() {
  const dir = path.dirname(STORAGE_FILE)
  if (!fs.existsSync(dir)) {
    fs.mkdirSync(dir, { recursive: true })
  }
}

export function numberToWords(num: number): string {
  if (num === 0) return 'Zero Ethiopian Birr Only'
  
  const ones = [
    '', 'One', 'Two', 'Three', 'Four', 'Five', 'Six', 'Seven', 'Eight', 'Nine',
    'Ten', 'Eleven', 'Twelve', 'Thirteen', 'Fourteen', 'Fifteen', 'Sixteen',
    'Seventeen', 'Eighteen', 'Nineteen'
  ]
  const tens = ['', '', 'Twenty', 'Thirty', 'Forty', 'Fifty', 'Sixty', 'Seventy', 'Eighty', 'Ninety']

  function convertHundreds(n: number): string {
    let str = ''
    if (n >= 100) {
      str += ones[Math.floor(n / 100)] + ' Hundred '
      n %= 100
    }
    if (n >= 20) {
      const ten = tens[Math.floor(n / 10)]
      const one = n % 10 > 0 ? ones[n % 10] : ''
      str += one ? `${ten}-${one} ` : `${ten} `
      return str.trim()
    }
    if (n > 0) {
      str += ones[n] + ' '
    }
    return str.trim()
  }

  const intPart = Math.floor(Math.abs(num))
  const cents = Math.round((Math.abs(num) - intPart) * 100)

  if (intPart === 0 && cents > 0) {
    return `${cents}/100 Cents Ethiopian Birr Only`
  }

  let words = ''
  const billions = Math.floor(intPart / 1_000_000_000)
  const millions = Math.floor((intPart % 1_000_000_000) / 1_000_000)
  const thousands = Math.floor((intPart % 1_000_000) / 1000)
  const remainder = intPart % 1000

  if (billions > 0) words += convertHundreds(billions) + ' Billion '
  if (millions > 0) words += convertHundreds(millions) + ' Million '
  if (thousands > 0) words += convertHundreds(thousands) + ' Thousand '
  if (remainder > 0) words += convertHundreds(remainder) + ' '

  words = words.trim() + ' Ethiopian Birr'
  if (cents > 0) {
    words += ` and ${cents}/100 Cents`
  }
  return words + ' Only'
}

export function calculateVoucherTotals(lines: Array<Partial<PaymentVoucherLine>>): {
  lines: PaymentVoucherLine[]
  totalGross: number
  totalVat: number
  totalWht: number
  totalNet: number
  amountInWords: string
} {
  let totalGross = 0
  let totalVat = 0
  let totalWht = 0
  let totalNet = 0

  const calculatedLines: PaymentVoucherLine[] = (lines || []).map((line, idx) => {
    const gross = Math.max(0, Number(line.grossAmount || 0))
    const vatRate = Number(line.vatRate ?? 15)
    const whtRate = Number(line.whtRate ?? 2)

    const vatAmount = vatRate > 0 ? Math.round(gross * (vatRate / 100) * 100) / 100 : 0
    const whtAmount = whtRate > 0 ? Math.round(gross * (whtRate / 100) * 100) / 100 : 0
    const netAmount = Math.max(0, Math.round((gross + vatAmount - whtAmount) * 100) / 100)

    totalGross += gross
    totalVat += vatAmount
    totalWht += whtAmount
    totalNet += netAmount

    return {
      lineNo: line.lineNo || idx + 1,
      description: String(line.description || '').trim(),
      glAccountNo: String(line.glAccountNo || '').trim(),
      glAccountName: String(line.glAccountName || '').trim(),
      divisionCode: String(line.divisionCode || 'ADM').trim(),
      departmentCode: String(line.departmentCode || '').trim(),
      grossAmount: gross,
      vatRate,
      vatAmount,
      whtRate,
      whtAmount,
      netAmount,
    }
  })

  totalGross = Math.round(totalGross * 100) / 100
  totalVat = Math.round(totalVat * 100) / 100
  totalWht = Math.round(totalWht * 100) / 100
  totalNet = Math.round(totalNet * 100) / 100

  return {
    lines: calculatedLines,
    totalGross,
    totalVat,
    totalWht,
    totalNet,
    amountInWords: numberToWords(totalNet),
  }
}

const DEFAULT_VOUCHERS: PaymentVoucher[] = [
  {
    id: 'PV-2026-0001',
    pvNo: 'PV-2026-0001',
    date: '2026-11-20',
    payeeType: 'Vendor',
    payeeNo: 'VEND-00142',
    payeeName: 'Ethio Telecom Enterprise',
    payeeTin: '0001248596',
    paymentMode: 'Bank Transfer',
    bankAccountNo: 'CBE-100014528',
    bankAccountName: 'Commercial Bank of Ethiopia - Main Branch',
    chequeOrRefNo: 'CBE/FT/2026/99412',
    description: 'Payment for dedicated enterprise broadband and cloud lease services for Nov 2026',
    projectNo: 'PROJ-ADM',
    projectName: 'General Administration',
    status: 'Approved',
    lines: [
      {
        lineNo: 1,
        description: 'Monthly high-speed internet connectivity - Head Office',
        glAccountNo: '54100',
        glAccountName: 'Telephone, Internet & Telecommunications',
        divisionCode: 'ADM',
        departmentCode: 'ICT',
        grossAmount: 48500,
        vatRate: 15,
        vatAmount: 7275,
        whtRate: 2,
        whtAmount: 970,
        netAmount: 54805,
      },
    ],
    totalGross: 48500,
    totalVat: 7275,
    totalWht: 970,
    totalNet: 54805,
    amountInWords: 'Fifty-Four Thousand Eight Hundred Five Ethiopian Birr Only',
    preparedBy: {
      name: 'Leah Worku',
      title: 'Finance & Accounts Officer',
      date: '2026-11-20T09:15:00Z',
    },
    checkedBy: {
      name: 'Yohannes Haile',
      title: 'Senior Finance Specialist',
      date: '2026-11-20T11:30:00Z',
      comments: 'Budget code 54100 verified against November allocation. Approved for FAD sign-off.',
    },
    approvedBy: {
      name: 'Tesfaye Abebe',
      title: 'Finance & Administration Director',
      date: '2026-11-20T14:45:00Z',
      comments: 'Approved for electronic fund transfer via CBE.',
    },
    receivedBy: {
      name: 'Ethio Telecom Finance Clearing',
      date: '2026-11-21',
      idNumber: 'FT-ACK-8812',
    },
    createdAt: '2026-11-20T09:15:00Z',
    updatedAt: '2026-11-20T14:45:00Z',
  },
  {
    id: 'PV-2026-0002',
    pvNo: 'PV-2026-0002',
    date: '2026-11-21',
    payeeType: 'Vendor',
    payeeNo: 'VEND-00089',
    payeeName: 'Awash Stationery & General Printing PLC',
    payeeTin: '0028914432',
    paymentMode: 'Cheque',
    bankAccountNo: 'AWASH-902148',
    bankAccountName: 'Awash Bank - Bole Branch',
    chequeOrRefNo: 'CHQ-0045812',
    description: 'Procurement of project training manuals and field survey stationery materials',
    projectNo: 'PROJ-SAFARICOM',
    projectName: 'Safaricom Ethiopia Project',
    status: 'Under Review',
    lines: [
      {
        lineNo: 1,
        description: 'Printing of 500 copies of field enumeration guides',
        glAccountNo: '53200',
        glAccountName: 'Printing & Stationery Supplies',
        divisionCode: 'OPS',
        departmentCode: 'SURVEY',
        grossAmount: 32000,
        vatRate: 15,
        vatAmount: 4800,
        whtRate: 2,
        whtAmount: 640,
        netAmount: 36160,
      },
    ],
    totalGross: 32000,
    totalVat: 4800,
    totalWht: 640,
    totalNet: 36160,
    amountInWords: 'Thirty-Six Thousand One Hundred Sixty Ethiopian Birr Only',
    preparedBy: {
      name: 'Leah Worku',
      title: 'Finance & Accounts Officer',
      date: '2026-11-21T10:00:00Z',
    },
    checkedBy: {
      name: 'Yohannes Haile',
      title: 'Senior Finance Specialist',
      date: '2026-11-21T13:20:00Z',
      comments: 'Invoices matched with GRN. Transmitted to Tesfaye Abebe for final authorization.',
    },
    createdAt: '2026-11-21T10:00:00Z',
    updatedAt: '2026-11-21T13:20:00Z',
  },
]

export function loadPaymentVouchers(): PaymentVoucher[] {
  ensureStorageDir()
  try {
    if (fs.existsSync(STORAGE_FILE)) {
      const data = fs.readFileSync(STORAGE_FILE, 'utf-8')
      const parsed = JSON.parse(data)
      if (Array.isArray(parsed)) return parsed
    }
  } catch (err) {
    console.warn('[PaymentVouchers] Error loading vouchers from file, using memory fallback:', err)
  }
  // Initialize with defaults
  savePaymentVouchers(DEFAULT_VOUCHERS)
  return DEFAULT_VOUCHERS
}

/**
 * Fetch Payment Vouchers from Business Central OData (Paymentsheader / QyPaymentsHeader)
 * with graceful fallback to local persistent store.
 */
export async function fetchPaymentVouchersWithBc(): Promise<PaymentVoucher[]> {
  const localVouchers = loadPaymentVouchers()
  try {
    const { fetchOData } = await import('./bcClient.js')
    const bcRows = (await fetchOData('Paymentsheader', {
      $top: 100,
    }).catch(async () => {
      return (await fetchOData('QyPaymentsHeader', { $top: 100 }).catch(() => []))
    })) as Array<Record<string, unknown>> | null

    if (Array.isArray(bcRows) && bcRows.length > 0) {
      const bcVouchers: PaymentVoucher[] = bcRows.map((row) => {
        const no = String(row.No || row.No_ || '').trim()
        const gross = Number(row.TotalPaymentAmount || 0)
        const vat = Number(row.TotalVATAmount || 0)
        const wht = Number(row.TotalWitholdingTaxAmount || 0)
        const net = Number(row.TotalNetAmount || (gross + vat - wht))
        const statusRaw = String(row.Status || 'Draft')
        const statusMap: Record<string, PaymentVoucherStatus> = {
          Pending: 'Draft',
          'Pending Approval': 'Submitted',
          Approved: 'Approved',
          Posted: 'Paid',
          Cancelled: 'Rejected',
        }
        return {
          id: no,
          pvNo: no,
          date: String(row.Date || row.PaymentReleaseDate || '').slice(0, 10) || new Date().toISOString().slice(0, 10),
          payeeType: 'Vendor',
          payeeNo: String(row.PFNo || ''),
          payeeName: String(row.Payee || row.OnBehalfOf || 'Beneficiary'),
          payeeTin: '',
          paymentMode: row.PayMode === 1 ? 'Cheque' : row.PayMode === 0 ? 'Cash' : 'Bank Transfer',
          bankAccountNo: String(row.PayingBankAccount || ''),
          bankAccountName: String(row.BankName || ''),
          chequeOrRefNo: String(row.ChequeNo || row.ReferenceNo || ''),
          description: String(row.PaymentNarration || ''),
          status: statusMap[statusRaw] || (statusRaw as PaymentVoucherStatus),
          lines: [],
          totalGross: gross,
          totalVat: vat,
          totalWht: wht,
          totalNet: net,
          amountInWords: numberToWords(net),
          preparedBy: {
            name: String(row.Cashier || 'Finance Officer'),
            title: 'Finance Officer',
            date: String(row.Date || new Date().toISOString()),
          },
          createdAt: String(row.SystemCreatedAt || new Date().toISOString()),
          updatedAt: String(row.SystemModifiedAt || new Date().toISOString()),
        }
      })

      const merged = [...bcVouchers]
      for (const loc of localVouchers) {
        if (!merged.some((b) => b.pvNo === loc.pvNo)) {
          merged.push(loc)
        }
      }
      return merged
    }
  } catch {
    // Graceful fallback to local cache
  }
  return localVouchers
}

export function savePaymentVouchers(vouchers: PaymentVoucher[]): void {
  ensureStorageDir()
  try {
    fs.writeFileSync(STORAGE_FILE, JSON.stringify(vouchers, null, 2), 'utf-8')
  } catch (err) {
    console.error('[PaymentVouchers] Error saving vouchers to file:', err)
  }
}

export function generateNextPvNo(): string {
  const vouchers = loadPaymentVouchers()
  const year = new Date().getFullYear()
  let maxSeq = 0
  for (const v of vouchers) {
    const match = v.pvNo?.match(/PV-(\d{4})-(\d+)/)
    if (match && Number(match[1]) === year) {
      const seq = Number(match[2])
      if (seq > maxSeq) maxSeq = seq
    }
  }
  const nextSeq = String(maxSeq + 1).padStart(4, '0')
  return `PV-${year}-${nextSeq}`
}

export function findPaymentVoucherById(id: string): PaymentVoucher | undefined {
  const vouchers = loadPaymentVouchers()
  return vouchers.find((v) => v.id === id || v.pvNo === id)
}

export function createOrUpdatePaymentVoucher(
  payload: Omit<Partial<PaymentVoucher>, 'lines'> & { lines?: Array<Partial<PaymentVoucherLine>> },
  actor: { name: string; title: string; employeeNo?: string },
): PaymentVoucher {
  const vouchers = loadPaymentVouchers()
  const now = new Date().toISOString()
  const today = now.slice(0, 10)

  const isExisting = payload.id && vouchers.some((v) => v.id === payload.id)
  const id = isExisting ? payload.id! : generateNextPvNo()
  const pvNo = payload.pvNo || id

  const calculated = calculateVoucherTotals(payload.lines || [])

  const existing = isExisting ? vouchers.find((v) => v.id === id) : undefined

  const voucher: PaymentVoucher = {
    id,
    pvNo,
    date: payload.date || existing?.date || today,
    payeeType: (payload.payeeType || existing?.payeeType || 'Vendor') as PayeeType,
    payeeNo: payload.payeeNo || existing?.payeeNo || '',
    payeeName: payload.payeeName || existing?.payeeName || '',
    payeeTin: payload.payeeTin || existing?.payeeTin || '',
    paymentMode: (payload.paymentMode || existing?.paymentMode || 'Bank Transfer') as PaymentMode,
    bankAccountNo: payload.bankAccountNo || existing?.bankAccountNo || '',
    bankAccountName: payload.bankAccountName || existing?.bankAccountName || '',
    chequeOrRefNo: payload.chequeOrRefNo || existing?.chequeOrRefNo || '',
    description: payload.description || existing?.description || '',
    projectNo: payload.projectNo || existing?.projectNo,
    projectName: payload.projectName || existing?.projectName,
    status: (payload.status || existing?.status || 'Draft') as PaymentVoucherStatus,
    lines: calculated.lines,
    totalGross: calculated.totalGross,
    totalVat: calculated.totalVat,
    totalWht: calculated.totalWht,
    totalNet: calculated.totalNet,
    amountInWords: calculated.amountInWords,
    preparedBy: existing?.preparedBy || {
      name: actor.name || 'Leah Worku',
      title: actor.title || 'Finance Officer',
      date: now,
    },
    checkedBy: payload.checkedBy || existing?.checkedBy,
    approvedBy: payload.approvedBy || existing?.approvedBy,
    receivedBy: payload.receivedBy || existing?.receivedBy,
    rejectionReason: payload.rejectionReason,
    createdAt: existing?.createdAt || now,
    updatedAt: now,
  }

  const updatedVouchers = isExisting
    ? vouchers.map((v) => (v.id === id ? voucher : v))
    : [voucher, ...vouchers]

  savePaymentVouchers(updatedVouchers)
  return voucher
}

export function submitPaymentVoucher(
  id: string,
  actor: { name: string; title: string },
): PaymentVoucher {
  const vouchers = loadPaymentVouchers()
  const voucher = vouchers.find((v) => v.id === id || v.pvNo === id)
  if (!voucher) {
    throw Object.assign(new Error(`Payment Voucher ${id} not found`), { status: 404 })
  }
  if (voucher.status !== 'Draft' && voucher.status !== 'Rejected') {
    throw Object.assign(new Error(`Payment Voucher is already in status '${voucher.status}'`), { status: 422 })
  }
  if (!voucher.lines || voucher.lines.length === 0) {
    throw Object.assign(new Error('At least one accounting distribution line is required before submission.'), { status: 422 })
  }
  if (!voucher.payeeName) {
    throw Object.assign(new Error('Payee name is required before submission.'), { status: 422 })
  }

  const now = new Date().toISOString()
  voucher.status = 'Submitted'
  voucher.preparedBy = {
    name: actor.name || voucher.preparedBy.name,
    title: actor.title || voucher.preparedBy.title,
    date: now,
  }
  voucher.updatedAt = now

  savePaymentVouchers(vouchers)
  return voucher
}

export function approvePaymentVoucher(
  id: string,
  actor: { name: string; title: string; comments?: string; step?: 'check' | 'approve' },
): PaymentVoucher {
  const vouchers = loadPaymentVouchers()
  const voucher = vouchers.find((v) => v.id === id || v.pvNo === id)
  if (!voucher) {
    throw Object.assign(new Error(`Payment Voucher ${id} not found`), { status: 404 })
  }

  const now = new Date().toISOString()
  const isChecker =
    actor.step === 'check' ||
    /yohannes|johannes|accountant|specialist|checker/i.test(actor.name + ' ' + actor.title)

  if (voucher.status === 'Submitted' && isChecker) {
    voucher.status = 'Under Review'
    voucher.checkedBy = {
      name: actor.name || 'Yohannes Haile',
      title: actor.title || 'Senior Finance Specialist',
      date: now,
      comments: actor.comments || 'Verified budget codes and calculations.',
    }
  } else if (voucher.status === 'Under Review' || voucher.status === 'Submitted') {
    voucher.status = 'Approved'
    voucher.approvedBy = {
      name: actor.name || 'Tesfaye Abebe',
      title: actor.title || 'Finance & Administration Director',
      date: now,
      comments: actor.comments || 'Authorized for disbursement.',
    }
    if (!voucher.checkedBy) {
      voucher.checkedBy = {
        name: 'Yohannes Haile',
        title: 'Senior Finance Specialist',
        date: now,
        comments: 'Verified.',
      }
    }
  } else if (voucher.status === 'Approved') {
    // Mark as Paid
    voucher.status = 'Paid'
    voucher.receivedBy = {
      name: voucher.payeeName,
      date: now.slice(0, 10),
      idNumber: voucher.chequeOrRefNo,
    }
  }

  voucher.updatedAt = now
  savePaymentVouchers(vouchers)
  return voucher
}

export function rejectPaymentVoucher(
  id: string,
  actor: { name: string; title: string; reason: string },
): PaymentVoucher {
  const vouchers = loadPaymentVouchers()
  const voucher = vouchers.find((v) => v.id === id || v.pvNo === id)
  if (!voucher) {
    throw Object.assign(new Error(`Payment Voucher ${id} not found`), { status: 404 })
  }
  if (!actor.reason) {
    throw Object.assign(new Error('A rejection reason is required.'), { status: 422 })
  }

  const now = new Date().toISOString()
  voucher.status = 'Rejected'
  voucher.rejectionReason = actor.reason
  voucher.updatedAt = now

  savePaymentVouchers(vouchers)
  return voucher
}

export function deletePaymentVoucher(id: string): boolean {
  const vouchers = loadPaymentVouchers()
  const voucher = vouchers.find((v) => v.id === id || v.pvNo === id)
  if (!voucher) return false
  if (voucher.status !== 'Draft' && voucher.status !== 'Rejected') {
    throw Object.assign(new Error('Only Draft or Rejected payment vouchers can be deleted.'), { status: 422 })
  }
  const filtered = vouchers.filter((v) => v.id !== id && v.pvNo !== id)
  savePaymentVouchers(filtered)
  return true
}
