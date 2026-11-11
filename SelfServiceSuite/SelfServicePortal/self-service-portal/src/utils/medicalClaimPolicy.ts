/**
 * ABH Medical Claim and Reimbursement Policy, as plain arithmetic for the ESSP Medical Claim form.
 * Business Central (Medical Claim Management, 1.0.3.638) applies the same rules when the claim is saved.
 *
 * 1. Annual entitlement = Basic salary x 12 x 20%
 * 2. Split 50% Self (Employee) / 50% Dependents, each a separate budget
 * 3. Company covers 80% of the accepted receipt; employee contributes 20%
 * 4. Reimbursement never exceeds the remaining budget of that category; none once it is exhausted
 */
export const MEDICAL_POLICY = {
  entitlementPercent: 20,
  categorySharePercent: 50,
  companyCoveragePercent: 80,
  employeeContributionPercent: 20,
} as const

export type MedicalCategory = 'self' | 'dependant'

function round2(value: number) {
  return Math.round((value + Number.EPSILON) * 100) / 100
}

export function annualMedicalEntitlement(monthlyBasic: number) {
  return monthlyBasic > 0 ? round2(monthlyBasic * 12 * (MEDICAL_POLICY.entitlementPercent / 100)) : 0
}

export function categoryAllocation(entitlement: number) {
  return round2(entitlement * (MEDICAL_POLICY.categorySharePercent / 100))
}

export type MedicalReceiptCalc = {
  /** Accepted medical receipt. */
  amount: number
  /** 80% of the receipt (policy section 3). */
  companyCoverage: number
  /** 20% of the receipt (policy section 3). */
  employeeContribution: number
  /** What the company pays: the 80%, limited by the budget left (policy section 4). */
  reimbursement: number
  /** Part of the 80% not paid because the budget ran out. */
  notReimbursed: number
  capped: boolean
}

export type MedicalClaimCalc = {
  receipts: MedicalReceiptCalc[]
  totalReceipts: number
  totalCompanyCoverage: number
  totalEmployeeContribution: number
  totalReimbursement: number
  totalNotReimbursed: number
  /** Budget available before this claim; null when Business Central did not return it. */
  availableBefore: number | null
  remainingAfter: number | null
  capped: boolean
  /** The category budget is fully used: no reimbursement is allowed (policy section 4). */
  exhausted: boolean
}

/** Receipts are applied in order against the one category budget, as BC does line by line. */
export function calculateMedicalClaim(receiptAmounts: number[], availableBudget: number | null): MedicalClaimCalc {
  const availableBefore =
    availableBudget === null || !Number.isFinite(availableBudget) ? null : round2(availableBudget)
  let remaining = availableBefore === null ? null : Math.max(0, availableBefore)
  const receipts = receiptAmounts.map((raw) => {
    const amount = Number.isFinite(raw) && raw > 0 ? round2(raw) : 0
    const companyCoverage = round2(amount * (MEDICAL_POLICY.companyCoveragePercent / 100))
    const employeeContribution = round2(amount - companyCoverage)
    let reimbursement = companyCoverage
    if (remaining !== null) {
      reimbursement = round2(Math.min(companyCoverage, remaining))
      remaining = round2(remaining - reimbursement)
    }
    const notReimbursed = round2(companyCoverage - reimbursement)
    return { amount, companyCoverage, employeeContribution, reimbursement, notReimbursed, capped: notReimbursed > 0 }
  })
  const sum = (pick: (row: MedicalReceiptCalc) => number) => round2(receipts.reduce((total, row) => total + pick(row), 0))
  return {
    receipts,
    totalReceipts: sum((row) => row.amount),
    totalCompanyCoverage: sum((row) => row.companyCoverage),
    totalEmployeeContribution: sum((row) => row.employeeContribution),
    totalReimbursement: sum((row) => row.reimbursement),
    totalNotReimbursed: sum((row) => row.notReimbursed),
    availableBefore,
    remainingAfter: remaining,
    capped: receipts.some((row) => row.capped),
    exhausted: availableBefore !== null && availableBefore <= 0,
  }
}
