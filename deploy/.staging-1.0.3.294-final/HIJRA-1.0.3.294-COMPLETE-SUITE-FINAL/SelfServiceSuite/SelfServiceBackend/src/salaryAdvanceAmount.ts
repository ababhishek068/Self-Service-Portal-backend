import { callSoapMethod, type ODataRecord } from './bcClient.js'
import { fetchEmployeeSalaryBaseForAdvance } from './employeeProfile.js'
import {
  injectSalaryAdvanceSalaryHint,
  mapSalaryAdvanceLine,
  resolveSalaryAdvanceAmount,
  resolveSalaryAdvancePercentage,
} from './erpMappings.js'

const SOAP_AMOUNT_METHODS = [
  'FetchSalaryAdvanceLineAmount',
  'FetchSalaryAdvanceAmount',
  'FetchStaffAdvanceLineAmount',
]

function stampAdvanceAmount(line: ODataRecord, amount: number) {
  return {
    ...line,
    resolvedAmount: amount,
    Amount: amount,
    amount,
    AdvanceAmount: amount,
    Advance_Amount: amount,
  }
}

export function applySalaryAdvanceComputedAmount(
  lines: ODataRecord[],
  header: ODataRecord,
  salaryBase: number,
) {
  if (salaryBase <= 0 || lines.length === 0) return lines
  const percentage = resolveSalaryAdvancePercentage(lines[0] as ODataRecord, header)
  if (percentage <= 0) return lines
  const amount = Math.round(((salaryBase * percentage) / 100) * 100) / 100
  if (amount <= 0) return lines
  return lines.map((line) => stampAdvanceAmount(line, amount))
}

export async function fetchSalaryAdvanceAmountViaSoap(input: {
  staffNo: string
  customerNo?: string
  percentageSalary: number
  docNo?: string
}) {
  const params = {
    staffNo: input.staffNo,
    employeeNo: input.staffNo,
    customerNo: input.customerNo ?? '',
    percentageSalary: input.percentageSalary,
    percentageOfSalary: input.percentageSalary,
    percentageofSalary: input.percentageSalary,
    docNo: input.docNo ?? '',
    headerNo: input.docNo ?? '',
    reqNo: input.docNo ?? '',
    requisitionNo: input.docNo ?? '',
  }

  for (const method of SOAP_AMOUNT_METHODS) {
    try {
      const result = await callSoapMethod(method, params)
      const raw = String(result.returnValue ?? '').trim()
      if (!raw) continue
      if (raw.startsWith('{')) {
        try {
          const parsed = JSON.parse(raw) as Record<string, unknown>
          const amount = Number(
            parsed.Amount ?? parsed.amount ?? parsed.AdvanceAmount ?? parsed.Advance_Amount ?? 0,
          )
          if (Number.isFinite(amount) && amount > 0) return amount
        } catch {
          /* not JSON */
        }
      }
      const amount = Number(raw)
      if (Number.isFinite(amount) && amount > 0) return amount
    } catch {
      continue
    }
  }

  return 0
}

export function salaryAdvanceLinesTotal(lines: ODataRecord[], header: ODataRecord) {
  return lines.reduce<number>(
    (sum, line) => sum + resolveSalaryAdvanceAmount(line, header),
    0,
  )
}

/** Lightweight amount for approval queue — no line fetch; uses requester payroll salary. */
export async function resolveSalaryAdvanceQueueAmount(
  header: ODataRecord,
  lines: ODataRecord[] = [],
) {
  const percentage = resolveSalaryAdvancePercentage(lines[0] ?? {}, header)
  if (percentage <= 0) return 0

  const staffNo = String(
    header.StaffNo ??
      header.Staff_No ??
      header.EmployeeNo ??
      header.Employee_No ??
      '',
  ).trim()
  if (!staffNo) return 0

  const customerNo = String(header.CustomerNo ?? header.Customer_No ?? '').trim()
  const salaryBase = await fetchEmployeeSalaryBaseForAdvance(
    staffNo,
    { customerNo, header, lines },
    { skipDocumentHints: true },
  )
  if (salaryBase <= 0) return 0
  return Math.round(((salaryBase * percentage) / 100) * 100) / 100
}

/** Resolve display amounts for salary-advance lines when BC leaves Amount at zero on drafts. */
export async function enrichSalaryAdvanceLines(
  header: ODataRecord,
  lines: ODataRecord[],
  context: {
    employeeNo: string
    customerNo?: string
    docNo?: string
    monthlySalaryBase?: number
    fast?: boolean
    skipSoap?: boolean
  },
) {
  const salaryBase =
    context.monthlySalaryBase && context.monthlySalaryBase > 0
      ? context.monthlySalaryBase
      : await fetchEmployeeSalaryBaseForAdvance(
          context.employeeNo,
          {
            customerNo: context.customerNo,
            header,
            lines,
          },
          { fast: context.fast, skipDocumentHints: true },
        )

  const headerForMapping = injectSalaryAdvanceSalaryHint(header, salaryBase)
  let mappedLines = lines.map((line) => mapSalaryAdvanceLine(line, headerForMapping))

  if (lines.length > 0) {
    const percentage = resolveSalaryAdvancePercentage(lines[0] as ODataRecord, header)
    if (percentage > 0 && salaryBase > 0) {
      mappedLines = applySalaryAdvanceComputedAmount(lines, headerForMapping, salaryBase)
    } else if (
      salaryAdvanceLinesTotal(mappedLines as ODataRecord[], headerForMapping) <= 0 &&
      percentage > 0
    ) {
      let soapAmount = 0
      if (!context.skipSoap && context.docNo) {
        soapAmount = await fetchSalaryAdvanceAmountViaSoap({
          staffNo: context.employeeNo,
          customerNo: context.customerNo,
          percentageSalary: percentage,
          docNo: context.docNo,
        })
      }
      if (soapAmount > 0) {
        mappedLines = lines.map((line) => stampAdvanceAmount(line, soapAmount))
      }
    }
  }

  return { header: headerForMapping, lines: mappedLines, salaryBase }
}
