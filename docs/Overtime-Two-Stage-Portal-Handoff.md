# Portal note — Overtime two-stage (BC 1.0.3.635)

**Two linked documents.** Hours go to the overtime sheet only after Stage 2.

## Flow

1. **Stage 1 — Overtime Request (work authorization)**  
   Employee submits purpose / hours / period → **Superior**, then **FAD** → both approve → employee may start work.  
   Status Approved here means **work authorized**, not paid. **No sheet yet.**

2. **Stage 2 — Overtime Payment Request**  
   After work, employee creates payment request linked to the approved Stage 1 document → **Superior** reviews and must enter a **justification** → on approve, hours are added to the **current overtime sheet** → HR sends sheet to payroll.

## Stage 1 period + daily times (1.0.3.635)

Request covers a **period** plus **one line per day** (date + start/end time).

`PortalOvertimeContext` includes `supportsPeriod: true` (and existing `supportsLines`).

### Save `detailsJson` example

```json
{
  "periodStartDate": "2026-11-10",
  "periodEndDate": "2026-11-12",
  "reason": "Month-end closing",
  "projectNo": "",
  "lines": [
    { "overtimeDate": "2026-11-10", "startTime": "18:00", "endTime": "21:00", "dayType": "working", "reason": "Closing" },
    { "overtimeDate": "2026-11-11", "startTime": "18:00", "endTime": "20:30", "dayType": "working", "reason": "Closing" },
    { "overtimeDate": "2026-11-12", "startTime": "17:00", "endTime": "19:00", "dayType": "working", "reason": "Closing" }
  ]
}
```

Aliases accepted: `startDate` / `endDate` for the period.  
If period is omitted, BC sets it from the first and last line dates.  
Every `overtimeDate` must fall inside the period.

Response fields: `periodStartDate`, `periodEndDate`, `startDate`, `endDate`, plus `lines[]`.

## Stage 1 SOAP (names unchanged)

| SOAP | Notes |
|------|--------|
| `PortalOvertimeContext` | Preview is Superior → FAD. New fields: `stage` = `workAuthorization`, `stageCaption`, `paymentNote`, `supportsPeriod` |
| `PortalOvertimeList` / `PortalOvertimeByNo` | Same |
| `PortalOvertimeSave` / `Withdraw` / `Delete` | Same — send period + lines |
| `PortalOvertimeApprovals` / `PortalOvertimeDecide` | Same (Superior then FAD) |

On request JSON (list/byNo/save response), use:

| Field | Meaning |
|-------|---------|
| `paymentRequestNo` | Linked Stage 2 no. (if any) |
| `paymentApproved` | Stage 2 done |
| `workAuthorized` | Stage 1 approved, payment not yet |
| `canRequestPayment` | Show “Request payment” when true |

After Stage 1 approve, UI copy: **Work authorized — submit Overtime Payment Request after the work is done.**

## Stage 2 SOAP (new)

| SOAP | Purpose |
|------|---------|
| `PortalOTPaymentContext(employeeNo, requesterUserId, otRequestNo)` | Open payment form; embeds Stage 1 as `otRequest` |
| `PortalOTPaymentList(employeeNo)` | Employee’s payment requests |
| `PortalOTPaymentByNo(paymentNo)` | One payment request |
| `PortalOTPaymentSave(employeeNo, requesterUserId, paymentNo, detailsJson, submitRequest)` | Draft / submit (`paymentNo` blank = new) |
| `PortalOTPaymentWithdraw(employeeNo, paymentNo)` | Back to draft |
| `PortalOTPaymentDelete(employeeNo, paymentNo)` | Delete draft only |
| `PortalOTPaymentApprovals(approverUserIds, scope)` | Superior inbox — `pending` / `decided` |
| `PortalOTPaymentDecide(approverUserIds, paymentNo, approve, remarks)` | **Approve requires remarks ≥ 3 chars** → stored as `superiorJustification` |

### `detailsJson` for Save

```json
{
  "otRequestNo": "OTR-00012",
  "workCompletedOn": "2026-11-10",
  "employeeRemarks": "Work completed as approved"
}
```

## Portal UI checklist

1. Stage 1 tracker: steps **Superior → FAD** (not FD/HR/Finance).
2. When `canRequestPayment` = true → button **Request overtime payment**.
3. New payment form: show linked Stage 1 summary, work completed date, employee remarks; submit to Superior only.
4. Superior Stage 2 approve: **justification required** (map to `remarks` on Decide).
5. Do **not** show “on overtime sheet / payroll” until Stage 2 is Approved (`addedToSheet` / Stage 1 `addedToSheet`).

Package: **BC24_TA App 1.0.3.635** (after ERP publish).
