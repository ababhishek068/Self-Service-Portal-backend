/**
 * ABH Staff Salary Advance policy: the ABH Partners PLC Staff Salary Advance Request Form, section 7
 * ("proposed, to be confirmed by management"), and the ESSP infographic's Eligibility & Prerequisites.
 *
 * Pure rules shared by the portal form and the backend. Keep these two files identical:
 *   SelfServiceSuite/SelfServiceBackend/src/salaryAdvancePolicy.ts
 *   SelfServiceSuite/SelfServicePortal/self-service-portal/src/utils/salaryAdvancePolicy.ts
 */
export const SALARY_ADVANCE_POLICY = {
  /** Note 3: equal monthly payroll deductions within a maximum of three months. */
  maxRepaymentMonths: 3,
  /** Note 2: the advance should not exceed one month's net salary. */
  maxNetSalaryMonths: 1,
  /** Note 4: Labour Proclamation No. 1156/2019 — deductions within one-third of the monthly wage. */
  legalDeductionDivisor: 3,
  /** A balance below this (ETB) is rounding, not an outstanding advance. */
  outstandingTolerance: 1,
  /** The first deduction starts this month or within this many months. */
  maxStartMonthsAhead: 3,
  /** Without a probation end date: probation (at most 60 working days) is over after this many days. */
  probationFallbackDays: 90,
} as const

export interface SalaryAdvanceFacts {
  /** 0 = unknown. */
  monthlyGrossSalary: number
  /** 0 = unknown. */
  monthlyNetSalary: number
  /** YYYY-MM-DD, '' = unknown. */
  probationEndDate: string
  onProbation: boolean | null
  /** YYYY-MM-DD, '' = unknown. */
  dateOfEmployment: string
  permanent: boolean | null
  employmentType: string
  /** YYYY-MM-DD, '' = none / unknown. */
  contractEndDate: string
  /** Balance on the employee's advance account(s); null = unknown. */
  outstandingBalance: number | null
  /** Other salary advances waiting for approval or approved and not yet paid; null = unknown. */
  openSalaryAdvances: Array<{ documentNo: string; status: string; amount: number }> | null
  policy?: { maxRepaymentMonths?: number; maxNetSalaryMonths?: number; legalDeductionDivisor?: number }
}

export interface SalaryAdvancePlan {
  requestedAmount: number
  repaymentMonths: number
  /** YYYY-MM or YYYY-MM-DD. */
  deductionStartMonth: string
  /** YYYY-MM-DD. */
  dateNeeded: string
}

export type SalaryAdvanceCheckKey = 'probation' | 'outstanding' | 'amountLimit' | 'contract' | 'deductionLimit'
export type SalaryAdvanceCheckState = 'pass' | 'fail' | 'unknown'

export interface SalaryAdvanceCheck {
  key: SalaryAdvanceCheckKey
  label: string
  state: SalaryAdvanceCheckState
  detail: string
}

/** The five HR verification checks (form section 3), in the form's order. */
export const SALARY_ADVANCE_CHECKS: ReadonlyArray<{ key: SalaryAdvanceCheckKey; label: string }> = [
  { key: 'probation', label: 'Employee has completed probation' },
  { key: 'outstanding', label: 'No outstanding advance or loan' },
  { key: 'amountLimit', label: 'Amount within policy limit' },
  { key: 'contract', label: 'Contract runs beyond full repayment period' },
  { key: 'deductionLimit', label: 'Monthly deduction within legal limit' },
]

const MONTHS = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
]

export function round2(value: number) {
  return Math.round((Number(value) || 0) * 100) / 100
}

export function maxRepaymentMonths(facts?: Pick<SalaryAdvanceFacts, 'policy'> | null) {
  return facts?.policy?.maxRepaymentMonths || SALARY_ADVANCE_POLICY.maxRepaymentMonths
}

/** Equal monthly deduction (ETB). */
export function monthlyDeduction(amount: number, months: number) {
  return months > 0 && amount > 0 ? round2(amount / months) : 0
}

/** 'YYYY-MM' of a 'YYYY-MM' or 'YYYY-MM-DD' value ('' when invalid). */
export function monthKey(value: string) {
  const match = /^(\d{4})-(\d{2})/.exec(String(value ?? '').trim())
  if (!match) return ''
  const month = Number(match[2])
  return month >= 1 && month <= 12 ? `${match[1]}-${match[2]}` : ''
}

export function addMonths(key: string, count: number) {
  const valid = monthKey(key)
  if (!valid) return ''
  const [year, month] = valid.split('-').map(Number) as [number, number]
  const index = year * 12 + (month - 1) + count
  return `${Math.floor(index / 12)}-${String((index % 12) + 1).padStart(2, '0')}`
}

/** Months from `from` to `to` ('YYYY-MM'); negative when `to` is earlier. */
export function monthsBetween(from: string, to: string) {
  const a = monthKey(from)
  const b = monthKey(to)
  if (!a || !b) return 0
  const [ay, am] = a.split('-').map(Number) as [number, number]
  const [by, bm] = b.split('-').map(Number) as [number, number]
  return by * 12 + bm - (ay * 12 + am)
}

export function lastDeductionMonth(plan: Pick<SalaryAdvancePlan, 'deductionStartMonth' | 'repaymentMonths'>) {
  return plan.repaymentMonths > 0 ? addMonths(plan.deductionStartMonth, plan.repaymentMonths - 1) : ''
}

export function endOfMonth(key: string) {
  const valid = monthKey(key)
  if (!valid) return ''
  const [year, month] = valid.split('-').map(Number) as [number, number]
  const day = new Date(Date.UTC(year, month, 0)).getUTCDate()
  return `${valid}-${String(day).padStart(2, '0')}`
}

/** "December 2026". */
export function monthLabel(key: string) {
  const valid = monthKey(key)
  if (!valid) return ''
  const [year, month] = valid.split('-').map(Number) as [number, number]
  return `${MONTHS[month - 1]} ${year}`
}

/** "5 Dec 2026". */
export function dayLabel(value: string) {
  const match = /^(\d{4})-(\d{2})-(\d{2})/.exec(String(value ?? ''))
  if (!match) return String(value ?? '')
  return `${Number(match[3])} ${MONTHS[Number(match[2]) - 1]!.slice(0, 3)} ${match[1]}`
}

export function etb(value: number) {
  return `ETB ${round2(value).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`
}

function addDays(value: string, days: number) {
  const match = /^(\d{4})-(\d{2})-(\d{2})/.exec(value)
  if (!match) return ''
  const date = new Date(Date.UTC(Number(match[1]), Number(match[2]) - 1, Number(match[3]) + days))
  return date.toISOString().slice(0, 10)
}

function validDay(value: string) {
  return /^\d{4}-\d{2}-\d{2}/.test(String(value ?? '')) && !String(value).startsWith('0001-01-01')
}

/** Live eligibility checks: a fact that is not known stays 'unknown' (HR verifies it). */
export function salaryAdvanceChecks(facts: SalaryAdvanceFacts, plan: SalaryAdvancePlan, today: string): SalaryAdvanceCheck[] {
  const label = (key: SalaryAdvanceCheckKey) => SALARY_ADVANCE_CHECKS.find((check) => check.key === key)!.label
  const amount = round2(plan.requestedAmount)
  const monthly = monthlyDeduction(amount, plan.repaymentMonths)
  const net = Number(facts.monthlyNetSalary) || 0
  const gross = Number(facts.monthlyGrossSalary) || 0
  const netMonths = facts.policy?.maxNetSalaryMonths || SALARY_ADVANCE_POLICY.maxNetSalaryMonths
  const divisor = facts.policy?.legalDeductionDivisor || SALARY_ADVANCE_POLICY.legalDeductionDivisor

  const probation = ((): SalaryAdvanceCheck => {
    if (validDay(facts.probationEndDate)) {
      return facts.probationEndDate.slice(0, 10) <= today
        ? { key: 'probation', label: label('probation'), state: 'pass', detail: `Probation ended ${dayLabel(facts.probationEndDate)}.` }
        : { key: 'probation', label: label('probation'), state: 'fail', detail: `Probation ends ${dayLabel(facts.probationEndDate)}. A salary advance can be requested after that.` }
    }
    if (facts.onProbation === true) {
      return { key: 'probation', label: label('probation'), state: 'fail', detail: 'Your employee card shows you are on probation.' }
    }
    if (validDay(facts.dateOfEmployment)) {
      const over = addDays(facts.dateOfEmployment.slice(0, 10), SALARY_ADVANCE_POLICY.probationFallbackDays)
      if (over && over <= today) {
        return { key: 'probation', label: label('probation'), state: 'pass', detail: `Employed since ${dayLabel(facts.dateOfEmployment)}, beyond the probation period.` }
      }
    }
    return { key: 'probation', label: label('probation'), state: 'unknown', detail: 'HR verifies the probation end date.' }
  })()

  const outstanding = ((): SalaryAdvanceCheck => {
    const open = facts.openSalaryAdvances ?? []
    if (open.length) {
      const first = open[0]!
      return {
        key: 'outstanding',
        label: label('outstanding'),
        state: 'fail',
        detail: `Salary advance ${first.documentNo} is ${first.status.toLowerCase()}. One advance at a time: a new request is allowed after full repayment.`,
      }
    }
    if (facts.outstandingBalance !== null && facts.outstandingBalance > SALARY_ADVANCE_POLICY.outstandingTolerance) {
      return {
        key: 'outstanding',
        label: label('outstanding'),
        state: 'fail',
        detail: `Your advance account has an outstanding balance of ${etb(facts.outstandingBalance)}. Repay it first.`,
      }
    }
    if (facts.openSalaryAdvances !== null && facts.outstandingBalance !== null) {
      return { key: 'outstanding', label: label('outstanding'), state: 'pass', detail: 'No open salary advance and no outstanding advance balance. HR confirms loans.' }
    }
    return { key: 'outstanding', label: label('outstanding'), state: 'unknown', detail: 'HR verifies outstanding advances and loans.' }
  })()

  const amountLimit = ((): SalaryAdvanceCheck => {
    if (amount <= 0) return { key: 'amountLimit', label: label('amountLimit'), state: 'unknown', detail: 'Enter the amount requested.' }
    if (net <= 0) return { key: 'amountLimit', label: label('amountLimit'), state: 'unknown', detail: "HR verifies the amount against one month's net salary." }
    const limit = round2(net * netMonths)
    return amount <= limit
      ? { key: 'amountLimit', label: label('amountLimit'), state: 'pass', detail: `${etb(amount)} is within one month's net salary (${etb(limit)}).` }
      : { key: 'amountLimit', label: label('amountLimit'), state: 'fail', detail: `${etb(amount)} is above one month's net salary (${etb(limit)}). Request ${etb(limit)} or less.` }
  })()

  const contract = ((): SalaryAdvanceCheck => {
    const last = lastDeductionMonth(plan)
    if (facts.permanent === true || /permanent/i.test(facts.employmentType)) {
      return { key: 'contract', label: label('contract'), state: 'pass', detail: 'Permanent employment.' }
    }
    if (validDay(facts.contractEndDate) && last) {
      const lastDay = endOfMonth(last)
      return facts.contractEndDate.slice(0, 10) >= lastDay
        ? { key: 'contract', label: label('contract'), state: 'pass', detail: `Contract ends ${dayLabel(facts.contractEndDate)}, after the last deduction (${monthLabel(last)}).` }
        : { key: 'contract', label: label('contract'), state: 'fail', detail: `Contract ends ${dayLabel(facts.contractEndDate)}, before the last deduction (${monthLabel(last)}). Choose fewer months.` }
    }
    return { key: 'contract', label: label('contract'), state: 'unknown', detail: 'HR verifies the contract end date.' }
  })()

  const deductionLimit = ((): SalaryAdvanceCheck => {
    if (monthly <= 0) return { key: 'deductionLimit', label: label('deductionLimit'), state: 'unknown', detail: 'Enter the amount and the repayment period.' }
    if (gross <= 0) return { key: 'deductionLimit', label: label('deductionLimit'), state: 'unknown', detail: 'HR verifies total monthly deductions against the legal limit.' }
    const limit = round2(gross / divisor)
    return monthly <= limit
      ? { key: 'deductionLimit', label: label('deductionLimit'), state: 'pass', detail: `${etb(monthly)} a month is within one-third of gross salary (${etb(limit)}).` }
      : { key: 'deductionLimit', label: label('deductionLimit'), state: 'fail', detail: `${etb(monthly)} a month is above one-third of gross salary (${etb(limit)}). Choose more months or a smaller amount.` }
  })()

  return [probation, outstanding, amountLimit, contract, deductionLimit]
}

/** Form errors (not eligibility): what must be filled in, and filled in correctly. */
export function salaryAdvancePlanErrors(
  plan: SalaryAdvancePlan,
  input: { reason: string; declarationAccepted: boolean; forSubmit: boolean; today: string; maxMonths?: number },
) {
  const errors: string[] = []
  const maxMonths = input.maxMonths || SALARY_ADVANCE_POLICY.maxRepaymentMonths
  if (!(round2(plan.requestedAmount) > 0)) errors.push('Enter the amount requested (ETB) above zero.')
  if (!Number.isInteger(plan.repaymentMonths) || plan.repaymentMonths < 1 || plan.repaymentMonths > maxMonths) {
    errors.push(`Choose a repayment period of 1 to ${maxMonths} months.`)
  }
  const reason = input.reason.trim()
  if (reason.length < 5) errors.push('Enter the reason for the advance (at least 5 characters).')
  if (reason.length > 250) errors.push('Keep the reason within 250 characters.')
  if (!validDay(plan.dateNeeded)) errors.push('Enter the date the advance is needed.')
  else if (plan.dateNeeded.slice(0, 10) < input.today) errors.push('The date needed cannot be in the past.')
  const start = monthKey(plan.deductionStartMonth)
  const thisMonth = monthKey(input.today)
  if (!start) errors.push('Choose the deduction start month.')
  else if (monthsBetween(thisMonth, start) < 0) errors.push('The deduction start month cannot be in the past.')
  else if (monthsBetween(thisMonth, start) > SALARY_ADVANCE_POLICY.maxStartMonthsAhead) {
    errors.push(`The deduction should start within ${SALARY_ADVANCE_POLICY.maxStartMonthsAhead} months.`)
  } else if (validDay(plan.dateNeeded) && monthsBetween(monthKey(plan.dateNeeded), start) < 0) {
    errors.push('The deduction start month cannot be before the month the advance is needed.')
  }
  if (input.forSubmit && !input.declarationAccepted) {
    errors.push('Accept the employee declaration and deduction authorization to submit.')
  }
  return errors
}

const ONES = [
  '',
  'One',
  'Two',
  'Three',
  'Four',
  'Five',
  'Six',
  'Seven',
  'Eight',
  'Nine',
  'Ten',
  'Eleven',
  'Twelve',
  'Thirteen',
  'Fourteen',
  'Fifteen',
  'Sixteen',
  'Seventeen',
  'Eighteen',
  'Nineteen',
]
const TENS = ['', '', 'Twenty', 'Thirty', 'Forty', 'Fifty', 'Sixty', 'Seventy', 'Eighty', 'Ninety']

function belowThousand(value: number) {
  const parts: string[] = []
  const hundreds = Math.floor(value / 100)
  const rest = value % 100
  if (hundreds) parts.push(`${ONES[hundreds]} Hundred`)
  if (rest) parts.push(rest < 20 ? ONES[rest]! : `${TENS[Math.floor(rest / 10)]}${rest % 10 ? `-${ONES[rest % 10]}` : ''}`)
  return parts.join(' ')
}

function wholeInWords(value: number) {
  if (value === 0) return 'Zero'
  const scales = ['', 'Thousand', 'Million', 'Billion']
  const parts: string[] = []
  let remaining = value
  for (let index = 0; remaining > 0 && index < scales.length; index += 1) {
    const chunk = remaining % 1000
    if (chunk) parts.unshift(`${belowThousand(chunk)}${scales[index] ? ` ${scales[index]}` : ''}`)
    remaining = Math.floor(remaining / 1000)
  }
  return parts.join(' ')
}

/** "Ten Thousand Five Hundred Birr and Fifty Santim Only". */
export function amountInWords(amount: number) {
  const value = round2(amount)
  if (!(value > 0)) return ''
  const birr = Math.floor(value)
  const santim = Math.round((value - birr) * 100)
  const words = `${wholeInWords(birr)} Birr${santim ? ` and ${wholeInWords(santim)} Santim` : ''} Only`
  return words
}
