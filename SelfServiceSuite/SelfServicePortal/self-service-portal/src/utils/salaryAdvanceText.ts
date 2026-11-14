/** Wording of the ABH Partners PLC Staff Salary Advance Request Form, and which requests use it. */

/** ABH form section 7 (proposed, to be confirmed by management). */
export const SALARY_ADVANCE_POLICY_NOTES = [
  'Eligible staff have completed probation and have no other outstanding advance or loan.',
  "The advance should not exceed one month's net salary.",
  'Repayment is through equal monthly payroll deductions, within a maximum of three months.',
  'Total monthly deductions must stay within the limit set by Labour Proclamation No. 1156/2019.',
  'One advance at a time; a new request is allowed only after full repayment.',
  'The advance is interest-free and is for genuine personal or emergency needs.',
]

export const SALARY_ADVANCE_DECLARATION =
  'I confirm that the information above is correct. I authorize ABH Partners PLC to deduct the monthly installments stated in Section 2 from my salary until the advance is fully repaid. I understand that any unpaid balance will be deducted from my final pay if I leave the company before full repayment.'

/** A salary advance made with the ESSP form (BC 1.0.3.652 has its Requested Amount). */
export function isEsspSalaryAdvance(request: { payload?: Record<string, unknown> }) {
  const payload = request.payload ?? {}
  return Number(payload.RequestedAmount ?? payload.Requested_Amount ?? 0) > 0
}
