# Medical Claim & Reimbursement — policy fix (1.0.3.631)

Source: **MEDICAL CLAIM AND REIMBURSEMENT POLICY.docx**

## Policy (expected)

1. Entitlement = Basic × 12 × 20%
2. Split 50% Self / 50% Dependants
3. Company pays **80%** of accepted receipt (or hospital setup %), **capped** by remaining category budget
4. If remaining budget &lt; 80% of receipt → pay only remaining budget

## Bugs fixed

1. **Portal line save** (`ClaimRequisitionLine`): for MEDICAL, claim **Amount** was taken from the portal and could ignore the budget cap. Now Amount = **Amount to refund** after policy validation.
2. **Portal preview** (`FetchMedicalClaimAmount`): hardcoded Government 100% / Outline 90% when setup missing. Now uses policy default **80%** via `CalculateMedicalRefund`.
3. New **`FetchMedicalClaimAmountPolicy(employeeNo, medicalAmount, hospitalCategory, patient, dependant)`** returns AmountToRefund **with budget cap**, plus AvailableBalance / RemainingBalance / EmployeeContribution.
4. **Hospital Category** OnValidate on medical lines re-runs full `ValidateMedicalAmount` (budget cap), not only the % table.

## Portal follow-up (recommended)

Call `FetchMedicalClaimAmountPolicy` when the employee enters a receipt (pass Self/Dependant) so the UI shows the capped reimbursement (policy example D: receipt 5,000 with 2,000 budget left → refund 2,000).

## BC admin

Opening allocations still from **PR Medical Management** → Generate Opening Allocation (Basic×12×20%, Self/Dependant 50/50). Ensure Medical Setup Medical % = 20 and categories SELF/DEPENDANT = 50 each (auto-seeded if empty).
