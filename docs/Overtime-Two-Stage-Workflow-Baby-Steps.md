# Overtime two-stage — BC workflow baby steps (1.0.3.634)

Do this **after** app **1.0.3.634** is published and synced on BC240.

---

## A. Overtime Setup (once)

1. Tell Me → **Overtime Setup**
2. Set **FAD User ID (Stage 1)** to the FAD approver’s User ID  
   (same style as User Setup / Approval User Setup)
3. Leave **Stage 1 step names** as `FAD` (or set to that)
4. Optional: **Overtime Payment Request Nos.** (number series). If blank, BC uses `OTP-…`
5. **Superior when none is set** = Line Manager Fallback (only if employee has no Approver ID / Supervisor)

---

## B. Stage 1 workflow — Overtime Request (Superior → FAD)

Code forces **Superior first, then FAD**. The workflow only needs to exist and be **enabled**.

### If you already have an Overtime Request workflow

1. Tell Me → **Workflows**
2. Find the workflow whose first event is:  
   **An Approval Request for an Overtime Request has been Requested.**
3. Open it → turn **Enabled** = Yes  
4. You can leave the old FD/HR/Finance user group; BC still rewrites the run to Superior → FAD using Overtime Setup.

### If you need to create it (copy Leave)

1. Tell Me → **Workflows**
2. Open the **Leave** approval workflow you use → **Copy Workflow**
3. Code e.g. `OT-REQ-S1` — Description: *Overtime Request Stage 1 (work authorization)*
4. On the **first When** event, change it to:  
   **An Approval Request for an Overtime Request has been Requested.**
5. On the **cancel** event (if present), use:  
   **An Approval Request for an Overtime Request has been Cancelled.**
6. Keep standard steps:  
   Set status Pending Approval → Create approval request → Send approval request  
   On approve last → Release document  
   On reject → Reject + Open document  
   On cancel → Cancel all + Open document
7. **Create an approval request**: Approver Type can stay *Workflow User Group* (any group with at least 1 member is fine — FAD is forced from setup)
8. **Enabled** = Yes → OK

---

## C. Stage 2 workflow — Overtime Payment Request (Superior only) — NEW

1. Tell Me → **Workflows**
2. Copy the **Leave** workflow again (or copy Stage 1 OT workflow)
3. Code e.g. `OT-PAY-S2` — Description: *Overtime Payment Request Stage 2*
4. First **When** event → change to:  
   **An Approval Request for an Overtime Payment Request has been Requested.**
5. Cancel event →:  
   **An Approval Request for an Overtime Payment Request has been Cancelled.**
6. Keep the same Pending / Create / Send / Release / Reject / Open responses as Leave
7. Approver Type: Workflow User Group with **at least one** member (placeholder is OK — code forces Superior only and cancels extra steps)
8. **Enabled** = Yes → OK

---

## D. Quick check

| Check | Where |
|-------|--------|
| FAD User ID filled | Overtime Setup |
| Stage 1 workflow Enabled | Workflows — OT Request event |
| Stage 2 workflow Enabled | Workflows — OT Payment Request event |
| Test Stage 1 from portal | Approvers show Superior then FAD |
| Test Stage 2 after Stage 1 approved | Only Superior; justification required on approve |
| After Stage 2 approve | Hours on open overtime sheet |

If submit says workflow not enabled: the event text must match **exactly** (including “Overtime Payment Request” for Stage 2). Re-open Workflows and confirm Enabled = Yes after publish.
