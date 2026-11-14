/**
 * ESSP Staff Salary Advance (ABH Partners PLC Staff Salary Advance Request Form; BC 1.0.3.652).
 *
 * BC `PortalSalaryAdvanceContext` gives the employee facts and the policy limits; `PortalSalaryAdvanceDetails`
 * saves the form on the draft Staff Advance Header. On BC without these methods the portal still works:
 * facts it cannot read stay unknown ("HR verifies"), and the amount goes to BC as a percentage of basic pay.
 */
import type { AuthUser } from './auth.js'
import { callSoapMethod, fetchOData, type ODataRecord } from './bcClient.js'
import { fetchEmployeeSalaryBaseForAdvance } from './employeeProfile.js'
import {
  SALARY_ADVANCE_POLICY,
  amountInWords,
  dayLabel,
  monthKey,
  monthLabel,
  monthlyDeduction,
  round2,
  salaryAdvanceChecks,
  salaryAdvancePlanErrors,
  type SalaryAdvanceFacts,
  type SalaryAdvancePlan,
} from './salaryAdvancePolicy.js'

export interface SalaryAdvanceContext extends SalaryAdvanceFacts {
  /** BC 1.0.3.652: the form fields are saved on the Staff Advance Header. */
  supportsDetails: boolean
  employeeNo: string
  employeeName: string
  jobTitle: string
  departmentCode: string
  departmentName: string
  divisionCode: string
  divisionName: string
  basicSalary: number
  /** YYYY-MM-DD of the payroll run the salaries come from ('' = employee card / unknown). */
  salaryPeriod: string
  policy: { maxRepaymentMonths: number; maxNetSalaryMonths: number; legalDeductionDivisor: number }
}

function text(value: unknown) {
  return String(value ?? '').trim()
}

function num(value: unknown) {
  const parsed = Number(value)
  return Number.isFinite(parsed) ? parsed : 0
}

function bool(value: unknown): boolean | null {
  if (value === true || value === false) return value
  const lowered = text(value).toLowerCase()
  if (lowered === 'true' || lowered === 'yes' || lowered === '1') return true
  if (lowered === 'false' || lowered === 'no' || lowered === '0') return false
  return null
}

function day(value: unknown) {
  const raw = text(value).slice(0, 10)
  return /^\d{4}-\d{2}-\d{2}$/.test(raw) && raw !== '0001-01-01' ? raw : ''
}

export function soapMethodMissing(error: unknown, method: string) {
  const message = String((error as { message?: unknown } | null)?.message ?? error ?? '')
  return new RegExp(`Method '?${method}'? is invalid|${method}.*(not found|not published)`, 'i').test(message)
}

export function parseSalaryAdvanceContext(raw: unknown): SalaryAdvanceContext {
  const row = (raw && typeof raw === 'object' ? raw : {}) as Record<string, unknown>
  const policy = (row.policy && typeof row.policy === 'object' ? row.policy : {}) as Record<string, unknown>
  const open = Array.isArray(row.openSalaryAdvances) ? row.openSalaryAdvances : null
  return {
    supportsDetails: bool(row.supportsDetails) === true,
    employeeNo: text(row.employeeNo),
    employeeName: text(row.employeeName),
    jobTitle: text(row.jobTitle),
    departmentCode: text(row.departmentCode),
    departmentName: text(row.departmentName),
    divisionCode: text(row.divisionCode),
    divisionName: text(row.divisionName),
    dateOfEmployment: day(row.dateOfEmployment),
    employmentType: text(row.employmentType),
    permanent: bool(row.permanent),
    contractEndDate: day(row.contractEndDate),
    probationEndDate: day(row.probationEndDate),
    onProbation: bool(row.onProbation),
    basicSalary: round2(num(row.basicSalary)),
    monthlyGrossSalary: round2(num(row.monthlyGrossSalary)),
    monthlyNetSalary: round2(num(row.monthlyNetSalary)),
    salaryPeriod: day(row.salaryPeriod),
    outstandingBalance: row.outstandingBalance === undefined || row.outstandingBalance === null ? null : round2(num(row.outstandingBalance)),
    openSalaryAdvances: open
      ? open.map((item) => {
          const entry = (item && typeof item === 'object' ? item : {}) as Record<string, unknown>
          return { documentNo: text(entry.documentNo), status: text(entry.status), amount: round2(num(entry.amount)) }
        })
      : null,
    policy: {
      maxRepaymentMonths: num(policy.maxRepaymentMonths) || SALARY_ADVANCE_POLICY.maxRepaymentMonths,
      maxNetSalaryMonths: num(policy.maxNetSalaryMonths) || SALARY_ADVANCE_POLICY.maxNetSalaryMonths,
      legalDeductionDivisor: num(policy.legalDeductionDivisor) || SALARY_ADVANCE_POLICY.legalDeductionDivisor,
    },
  }
}

/** BC before 1.0.3.652: what the portal session and the salary advance list can tell. */
async function fallbackContext(user: AuthUser, docNo: string): Promise<SalaryAdvanceContext> {
  const [basicSalary, rows] = await Promise.all([
    fetchEmployeeSalaryBaseForAdvance(user.employeeNo).catch(() => 0),
    fetchOData('QyStaffAdvanceHeader', { $filter: `StaffID eq '${user.employeeNo.replace(/'/g, "''")}'` }).catch(
      () => null,
    ),
  ])
  const open = Array.isArray(rows)
    ? (rows as ODataRecord[])
        .filter((row) => text(row.No) !== docNo && /pending approval/i.test(text(row.Status)))
        .map((row) => ({ documentNo: text(row.No), status: text(row.Status), amount: 0 }))
    : null
  return {
    supportsDetails: false,
    employeeNo: user.employeeNo,
    employeeName: user.displayName || user.name,
    jobTitle: user.jobTitle,
    departmentCode: user.department,
    departmentName: user.departmentName,
    divisionCode: '',
    divisionName: '',
    dateOfEmployment: '',
    employmentType: '',
    permanent: null,
    contractEndDate: '',
    probationEndDate: '',
    onProbation: null,
    basicSalary: round2(basicSalary),
    monthlyGrossSalary: 0,
    monthlyNetSalary: 0,
    salaryPeriod: '',
    // The old list cannot tell paid, approved advances apart: only pending ones are known.
    outstandingBalance: null,
    openSalaryAdvances: open && open.length ? open : null,
    policy: {
      maxRepaymentMonths: SALARY_ADVANCE_POLICY.maxRepaymentMonths,
      maxNetSalaryMonths: SALARY_ADVANCE_POLICY.maxNetSalaryMonths,
      legalDeductionDivisor: SALARY_ADVANCE_POLICY.legalDeductionDivisor,
    },
  }
}

export async function getSalaryAdvanceContext(user: AuthUser, docNo = ''): Promise<SalaryAdvanceContext> {
  try {
    const result = await callSoapMethod('PortalSalaryAdvanceContext', { employeeNo: user.employeeNo, docNo })
    return parseSalaryAdvanceContext(JSON.parse(String(result.returnValue ?? '{}') || '{}'))
  } catch (error) {
    if (!soapMethodMissing(error, 'PortalSalaryAdvanceContext')) throw error
    return fallbackContext(user, docNo)
  }
}

/** The form values in a request body (`requestedAmount` marks the ESSP form; older bodies send `percentageSalary`). */
export function salaryAdvanceFormBody(body: Record<string, unknown> | undefined) {
  const source = body ?? {}
  if (source.requestedAmount === undefined || source.requestedAmount === null || source.requestedAmount === '') return null
  const plan: SalaryAdvancePlan = {
    requestedAmount: round2(num(source.requestedAmount)),
    repaymentMonths: Number(source.repaymentMonths),
    deductionStartMonth: monthKey(text(source.deductionStartMonth)),
    dateNeeded: day(source.dateNeeded),
  }
  return {
    plan,
    reason: text(source.reason ?? source.purpose),
    declarationAccepted: bool(source.declarationAccepted) === true,
    submit: source.submit === true,
  }
}

function todayIso() {
  return new Date().toISOString().slice(0, 10)
}

function unprocessable(message: string) {
  return Object.assign(new Error(message), { status: 422 })
}

/** Throws the first form error; on submit also the eligibility checks that clearly fail. */
export function assertSalaryAdvanceForm(
  form: NonNullable<ReturnType<typeof salaryAdvanceFormBody>>,
  context: SalaryAdvanceContext | null,
  options: { forSubmit: boolean; today?: string },
) {
  const today = options.today ?? todayIso()
  const errors = salaryAdvancePlanErrors(form.plan, {
    reason: form.reason,
    declarationAccepted: form.declarationAccepted,
    forSubmit: options.forSubmit,
    today,
    maxMonths: context?.policy.maxRepaymentMonths,
  })
  if (errors.length) throw unprocessable(errors[0]!)
  if (options.forSubmit && context) assertEligible(context, form.plan, today)
}

export function assertEligible(context: SalaryAdvanceContext, plan: SalaryAdvancePlan, today = todayIso()) {
  const failed = salaryAdvanceChecks(context, plan, today).filter((check) => check.state === 'fail')
  if (failed.length) {
    throw unprocessable(
      `Not eligible for this salary advance: ${failed.map((check) => `${check.label} — ${check.detail}`).join(' ')}`,
    )
  }
}

/** The JSON BC `PortalSalaryAdvanceDetails` reads (strings, so BC reads every value the same way). */
export function salaryAdvanceDetailsJson(form: NonNullable<ReturnType<typeof salaryAdvanceFormBody>>) {
  const { plan } = form
  return JSON.stringify({
    requestedAmount: plan.requestedAmount.toFixed(2),
    amountInWords: amountInWords(plan.requestedAmount),
    dateNeeded: plan.dateNeeded,
    repaymentMonths: String(plan.repaymentMonths),
    deductionStartMonth: `${plan.deductionStartMonth}-01`,
    declarationAccepted: form.declarationAccepted ? 'true' : 'false',
    reason: form.reason.slice(0, 250),
  })
}

/**
 * BC without PortalSalaryAdvanceDetails keeps only Purpose and a percentage of basic pay: put the plan
 * in Purpose so HR sees it.
 */
export function salaryAdvanceLegacyPurpose(form: NonNullable<ReturnType<typeof salaryAdvanceFormBody>>) {
  const { plan } = form
  const summary = ` | ETB ${plan.requestedAmount.toFixed(2)}, ${plan.repaymentMonths} month(s) of ETB ${monthlyDeduction(
    plan.requestedAmount,
    plan.repaymentMonths,
  ).toFixed(2)} from ${monthLabel(plan.deductionStartMonth)}; needed ${dayLabel(plan.dateNeeded)}`
  return `${form.reason.slice(0, Math.max(0, 250 - summary.length))}${summary}`.slice(0, 250)
}

/** Percentage of basic pay for BC without the ESSP fields (at most 100). */
export function salaryAdvanceLegacyPercentage(amount: number, basicSalary: number) {
  if (!(basicSalary > 0) || !(amount > 0)) return 0
  return Math.min(100, Math.round((amount / basicSalary) * 100 * 10000) / 10000)
}

/** The plan saved on a BC 1.0.3.652 header (OData QyStaffAdvanceHeader), or null for an older request. */
export function salaryAdvancePlanFromHeader(header: ODataRecord) {
  const requestedAmount = round2(num(header.RequestedAmount ?? header.Requested_Amount))
  if (!(requestedAmount > 0)) return null
  return {
    plan: {
      requestedAmount,
      repaymentMonths: Number(header.RepaymentMonths ?? header.Repayment_Months ?? 0),
      deductionStartMonth: monthKey(text(header.DeductionStartMonth ?? header.Deduction_Start_Month)),
      dateNeeded: day(header.DateNeeded ?? header.Date_Needed),
    } satisfies SalaryAdvancePlan,
    declarationAccepted: bool(header.DeclarationAccepted ?? header.Declaration_Accepted) === true,
  }
}
