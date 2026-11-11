# Portal note — Advance Settlement / Surrender (BC 1.0.3.636)

ESSP **Advance Settlement** = BC **Advance Surrender** (`Imprest Surrender Header`).

## Flow

1. Employee picks an **approved + paid** Advance Payment Request  
2. Enters **actual expenses** (+ attachments)  
3. BC auto-calcs: Advance − Expenses = Balance → outcome  
4. Employee completes refund or additional-claim fields + declaration  
5. Submit for approval → Finance → post → advance closed  

## Outcomes

| Balance | Outcome | Portal must collect |
|---------|---------|---------------------|
| ≈ 0 | `fullySettled` | Declaration only |
| &gt; 0 | `refundDue` | Refund amount (auto), **refund date**, **payment reference**, proof attachment |
| &lt; 0 | `additionalClaim` | Claim amount (auto), **justification** (≥3 chars), docs |

## Existing SOAP (still used)

| SOAP | Role |
|------|------|
| `ImprestSurrenderHeader` (create) | Create settlement — now **blocks** unpaid / unapproved / duplicate |
| `ImprestSurrenderLine` | Update Actual Spent — recalcs settlement outcome |
| `RequestImprestSurrenderApproval` | Now runs settlement validation first |
| `CancelImprestSurrender` | Cancel |
| Attachments | Existing upload APIs (table 50884) |

## New SOAP

| SOAP | Purpose |
|------|---------|
| `PortalAdvanceSettlementContext(employeeNo, surrenderNo)` | `settleableAdvances[]` + current settlement JSON (balance, outcome, lines). Pass blank `surrenderNo` for list-only. |
| `PortalAdvanceSettlementSave(surrenderNo, refundDateText, refundPaymentReference, additionalClaimJustification, declarationConfirmed, settlementRemarks)` | Save Section 4/5 fields; returns refreshed context JSON |
| `PortalAdvanceSettlementAddExpense(surrenderNo, expenseCategory, expenseDescription, expenseAmount)` | Add free expense line (`Receipts and Payment Types` code → G/L). Returns line no. |

### Context JSON (highlights)

- `settleableAdvances[]`: `{ advanceNo, purpose, requestPurposeText, amount, date, fullyPaid, posted }`  
- `totalAdvanceReceived`, `totalActualExpenses`, `settlementBalance`  
- `settlementOutcome`: `fullySettled` | `refundDue` | `additionalClaim`  
- `refundAmount`, `refundDate`, `refundPaymentReference`  
- `additionalClaimAmount`, `additionalClaimJustification`  
- `declarationConfirmed`, `lines[]`

## Portal UI checklist

1. Advance lookup = only `settleableAdvances` (approved + paid, not Full, no open settlement).  
2. Show auto reconciliation (Section 3).  
3. Show Refund section only when `refundDue`; Additional Claim only when `additionalClaim`.  
4. Require declaration checkbox before submit.  
5. Call `PortalAdvanceSettlementSave` then `RequestImprestSurrenderApproval`.  

## BC admin

1. Publish **1.0.3.636**  
2. Ensure Advance Payments get **Fully Paid** (or Posted) when paid — otherwise portal cannot settle.  
3. Expense categories for Add Expense = Payment types with G/L on **Receipts and Payment Types**.
