# Portal handoff — Medical Claim 1.0.3.642

BC package: `Technology Associates EA Ltd_BC24_TA App_1.0.3.642.app`  
Policy source: ABH Medical Claim & Reimbursement Policy + meeting 11 Nov 2026.

## Already live (638+)

| SOAP | Purpose |
|------|---------|
| `FetchMedicalClaimAmountPolicy` | Preview: 80% of receipt, capped by remaining Self/Dependant budget |
| `FnGetEmployeeMedicalBalances` | `self` / `dependant` available + allocation / used / entitlement / coveragePercent |

## New in 642

| SOAP | Purpose |
|------|---------|
| `FnGetMedicalClaimDependants(employeeNo)` | JSON: `{ employeeNo, dependants: [ { no, systemId, memberId, surName, otherNames, fullName, relationship, relationshipValue, dateOfBirth, identificationType, cardNo, eligible, ineligibleReason? } ] }` |

Eligible relationships: Spouse, Father, Mother, Child under 18 with Identification Type = Birth Cert. No. and Card No filled.  
Guardian / Other / Brother / Sister are not eligible.

## Portal UX checklist

1. Medical claim form: Patient Self / Dependant; remove government / hospital-category driven refund UI (BC ignores hospital %; flat 80%).
2. On receipt amount entry → call `FetchMedicalClaimAmountPolicy`; show AvailableBalance, AmountToRefund, EmployeeContribution.
3. Dependant picker → call `FnGetMedicalClaimDependants`; show only `eligible=true` (or show all with disabled ineligible + reason).
4. Attach invoice before submit (BC already requires Document Attachment).
5. After Finance payment, refresh balances via `FnGetEmployeeMedicalBalances`.

## BC admin

1. Publish `docs/ERP-Publish-1.0.3.642.ps1`
2. Medical Setup: Medical % = 20; SELF/DEPENDANT = 50
3. PR Medical Management → Generate Opening Allocation for current HR calendar
4. Employee Dependants: children need DOB + Birth Cert. No. + Card No
