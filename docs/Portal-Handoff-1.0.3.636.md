# Portal handoff — BC 1.0.3.636 (publish this package)

Includes **634 + 635 + 636**. Detail docs:

- `Overtime-Two-Stage-Portal-Handoff.md`
- `Advance-Settlement-Portal-Handoff.md`

---

## 1) Overtime — two stages (634) + period/daily times (635)

### Stage 1 — Overtime Request (work authorization)

- Approvers: **Superior → FAD** (not FD/HR/Finance).
- Approved = **work authorized**. Hours do **not** go to overtime sheet yet.
- Existing SOAP names unchanged: `PortalOvertimeContext/List/ByNo/Save/Withdraw/Delete/Approvals/Decide`.

**Period + daily times** (send both):

```json
{
  "periodStartDate": "2026-11-10",
  "periodEndDate": "2026-11-12",
  "reason": "…",
  "lines": [
    { "overtimeDate": "2026-11-10", "startTime": "18:00", "endTime": "21:00", "dayType": "working", "reason": "…" }
  ]
}
```

- Aliases: `startDate` / `endDate` for period.
- Context: `supportsPeriod: true`, `supportsLines: true`.
- Response flags: `canRequestPayment`, `workAuthorized`, `paymentRequestNo`, `paymentApproved`.

### Stage 2 — Overtime Payment Request (new)

After Stage 1 approved and work done:

| SOAP | Use |
|------|-----|
| `PortalOTPaymentContext(employeeNo, requesterUserId, otRequestNo)` | Open payment form |
| `PortalOTPaymentList` / `ByNo` / `Save` / `Withdraw` / `Delete` | CRUD |
| `PortalOTPaymentApprovals` / `Decide` | Superior inbox — **approve needs justification ≥ 3 chars** |

Save JSON: `{ "otRequestNo", "workCompletedOn", "employeeRemarks" }`  
Hours → overtime sheet only after Stage 2 approved.

---

## 2) Advance Settlement / Surrender (636)

= BC Advance Surrender. Settle only **approved + paid** advances.

| Outcome | When | Portal collects |
|---------|------|-----------------|
| `fullySettled` | Expenses = Advance | Declaration |
| `refundDue` | Expenses &lt; Advance | Refund date, payment reference, proof |
| `additionalClaim` | Expenses &gt; Advance | Justification (+ docs) |

**Keep using:** `ImprestSurrenderHeader`, `ImprestSurrenderLine`, `RequestImprestSurrenderApproval` (now validates settlement), attachments.

**New:**

| SOAP | Use |
|------|-----|
| `PortalAdvanceSettlementContext(employeeNo, surrenderNo)` | Settleable advances + balance/outcome/lines |
| `PortalAdvanceSettlementSave(...)` | Refund/claim/declaration/remarks |
| `PortalAdvanceSettlementAddExpense(...)` | Extra expense line (category + description + amount) |

Use `settleableAdvances` from Context for the document lookup (not all advances).

---

## Package

`Technology Associates EA Ltd_BC24_TA App_1.0.3.636.app`  
Publish after ERP upgrade; BC admin must set OT Setup **FAD User ID** + OT Stage 1/2 workflows, and mark advances **Fully Paid** when paid.
