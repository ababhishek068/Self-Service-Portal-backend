import assert from 'node:assert/strict'
import { describe, it } from 'node:test'
import {
  assertEligible,
  parseSalaryAdvanceContext,
  salaryAdvanceDetailsJson,
  salaryAdvanceFormBody,
  salaryAdvanceLegacyPercentage,
  salaryAdvanceLegacyPurpose,
  salaryAdvancePlanFromHeader,
} from './salaryAdvance.js'
import {
  amountInWords,
  lastDeductionMonth,
  monthlyDeduction,
  salaryAdvanceChecks,
  salaryAdvancePlanErrors,
  type SalaryAdvanceFacts,
} from './salaryAdvancePolicy.js'

const today = '2026-11-15'

const facts = (overrides: Partial<SalaryAdvanceFacts> = {}): SalaryAdvanceFacts => ({
  monthlyGrossSalary: 30000,
  monthlyNetSalary: 21000,
  probationEndDate: '2025-03-01',
  onProbation: false,
  dateOfEmployment: '2024-12-01',
  permanent: false,
  employmentType: 'Contract',
  contractEndDate: '2027-06-30',
  outstandingBalance: 0,
  openSalaryAdvances: [],
  ...overrides,
})

const plan = { requestedAmount: 15000, repaymentMonths: 3, deductionStartMonth: '2026-12', dateNeeded: '2026-11-20' }

const state = (checks: ReturnType<typeof salaryAdvanceChecks>) =>
  Object.fromEntries(checks.map((check) => [check.key, check.state]))

describe('Staff Salary Advance policy (ABH form section 7)', () => {
  it('passes an eligible request: probation over, nothing outstanding, within net salary, contract and one-third of gross', () => {
    assert.deepEqual(state(salaryAdvanceChecks(facts(), plan, today)), {
      probation: 'pass',
      outstanding: 'pass',
      amountLimit: 'pass',
      contract: 'pass',
      deductionLimit: 'pass',
    })
  })

  it('fails each rule that the facts clearly break', () => {
    const checks = salaryAdvanceChecks(
      facts({
        probationEndDate: '2026-12-31',
        openSalaryAdvances: [{ documentNo: 'SA-0009', status: 'Pending Approval', amount: 5000 }],
        contractEndDate: '2027-02-15',
      }),
      { ...plan, requestedAmount: 25000, repaymentMonths: 2 },
      today,
    )
    assert.deepEqual(state(checks), {
      probation: 'fail',
      outstanding: 'fail',
      amountLimit: 'fail',
      contract: 'pass',
      deductionLimit: 'fail',
    })
    assert.match(checks[1]!.detail, /SA-0009 is pending approval/)
    assert.match(checks[2]!.detail, /above one month's net salary \(ETB 21,000\.00\)/)
    assert.match(checks[4]!.detail, /ETB 12,500\.00 a month is above one-third of gross salary \(ETB 10,000\.00\)/)
  })

  it('fails a contract that ends before the last deduction and an outstanding advance balance', () => {
    const checks = salaryAdvanceChecks(facts({ contractEndDate: '2027-01-31', outstandingBalance: 3200 }), plan, today)
    assert.equal(lastDeductionMonth(plan), '2027-02')
    assert.equal(checks.find((check) => check.key === 'contract')!.state, 'fail')
    assert.equal(checks.find((check) => check.key === 'outstanding')!.state, 'fail')
  })

  it('leaves unknown facts to HR and treats permanent staff as beyond the repayment period', () => {
    const checks = salaryAdvanceChecks(
      facts({
        monthlyGrossSalary: 0,
        monthlyNetSalary: 0,
        probationEndDate: '',
        dateOfEmployment: '',
        onProbation: null,
        permanent: true,
        contractEndDate: '',
        outstandingBalance: null,
        openSalaryAdvances: null,
      }),
      plan,
      today,
    )
    assert.deepEqual(state(checks), {
      probation: 'unknown',
      outstanding: 'unknown',
      amountLimit: 'unknown',
      contract: 'pass',
      deductionLimit: 'unknown',
    })
  })

  it('checks the form: amount, 1 to 3 months, reason, date needed, start month, declaration on submit', () => {
    const base = { reason: 'Family medical emergency', declarationAccepted: true, forSubmit: true, today }
    assert.deepEqual(salaryAdvancePlanErrors(plan, base), [])
    assert.deepEqual(salaryAdvancePlanErrors({ ...plan, repaymentMonths: 4 }, base), ['Choose a repayment period of 1 to 3 months.'])
    assert.deepEqual(salaryAdvancePlanErrors({ ...plan, deductionStartMonth: '2026-10' }, base), [
      'The deduction start month cannot be in the past.',
    ])
    assert.deepEqual(salaryAdvancePlanErrors({ ...plan, dateNeeded: '2026-11-14' }, base), ['The date needed cannot be in the past.'])
    assert.deepEqual(salaryAdvancePlanErrors(plan, { ...base, declarationAccepted: false }), [
      'Accept the employee declaration and deduction authorization to submit.',
    ])
    assert.deepEqual(salaryAdvancePlanErrors(plan, { ...base, declarationAccepted: false, forSubmit: false }), [])
  })

  it('writes the amount in words and splits the monthly deduction', () => {
    assert.equal(amountInWords(10500.5), 'Ten Thousand Five Hundred Birr and Fifty Santim Only')
    assert.equal(amountInWords(21000), 'Twenty-One Thousand Birr Only')
    assert.equal(amountInWords(1001001), 'One Million One Thousand One Birr Only')
    assert.equal(monthlyDeduction(10000, 3), 3333.33)
  })
})

describe('Staff Salary Advance to Business Central', () => {
  it('reads the ESSP form from the request body and sends BC strings', () => {
    const form = salaryAdvanceFormBody({
      requestedAmount: '15000',
      repaymentMonths: 3,
      deductionStartMonth: '2026-12-01',
      dateNeeded: '2026-11-20',
      reason: 'School fees',
      declarationAccepted: true,
      submit: true,
    })!
    assert.equal(form.submit, true)
    assert.deepEqual(JSON.parse(salaryAdvanceDetailsJson(form)), {
      requestedAmount: '15000.00',
      amountInWords: 'Fifteen Thousand Birr Only',
      dateNeeded: '2026-11-20',
      repaymentMonths: '3',
      deductionStartMonth: '2026-12-01',
      declarationAccepted: 'true',
      reason: 'School fees',
    })
    assert.equal(salaryAdvanceFormBody({ percentageSalary: 20, purpose: 'Old form' }), null)
  })

  it('keeps the plan in Purpose and caps the percentage for BC before 1.0.3.652', () => {
    const form = salaryAdvanceFormBody({ ...plan, reason: 'School fees', declarationAccepted: true })!
    assert.equal(
      salaryAdvanceLegacyPurpose(form),
      'School fees | ETB 15000.00, 3 month(s) of ETB 5000.00 from December 2026; needed 20 Nov 2026',
    )
    assert.equal(salaryAdvanceLegacyPercentage(15000, 12000), 100)
    assert.equal(salaryAdvanceLegacyPercentage(6000, 24000), 25)
    assert.equal(salaryAdvanceLegacyPercentage(6000, 0), 0)
  })

  it('reads the BC context and the saved header, and refuses an ineligible submit', () => {
    const context = parseSalaryAdvanceContext({
      supportsDetails: true,
      employeeNo: 'ABH-010',
      monthlyGrossSalary: 30000,
      monthlyNetSalary: 21000,
      probationEndDate: '0001-01-01',
      dateOfEmployment: '2024-12-01',
      permanent: false,
      contractEndDate: '2027-06-30',
      outstandingBalance: 0,
      openSalaryAdvances: [],
      policy: { maxRepaymentMonths: 3, maxNetSalaryMonths: 1, legalDeductionDivisor: 3 },
    })
    assert.equal(context.probationEndDate, '')
    assert.equal(context.supportsDetails, true)
    const saved = salaryAdvancePlanFromHeader({
      RequestedAmount: 15000,
      RepaymentMonths: 3,
      DeductionStartMonth: '2026-12-01',
      DateNeeded: '2026-11-20',
      DeclarationAccepted: true,
    })!
    assert.deepEqual(saved.plan, plan)
    assert.equal(saved.declarationAccepted, true)
    assert.doesNotThrow(() => assertEligible(context, saved.plan, today))
    assert.throws(() => assertEligible(context, { ...saved.plan, requestedAmount: 30000 }, today), /Amount within policy limit/)
    assert.equal(salaryAdvancePlanFromHeader({ RequestedAmount: 0, PercentageofSalary: 20 }), null)
  })
})
