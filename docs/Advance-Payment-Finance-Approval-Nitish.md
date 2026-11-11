# Finance Advance Payment approval — Nitish setup

**BC:** `1.0.3.645`  
**Portal:** shows the ladder on Advance Payment and reads Approval Entries as before.

## Rule (ESSP / ABH)

1. **Superior** = first approver from the **Workflow User Group** (same idea as Store Requisition)  
2. Then by **Total Net Amount (ETB)**:
   - below **50,000** → **FAD**
   - **50,000–100,000** → **COO**
   - above **100,000** → **CEO**

BC owns the workflow; ESSP submits and shows status from Approval Entries.

## What to configure in BC

### 1. Workflow User Group (Superior)
1. Tell Me → **Workflow User Groups**
2. Create / open a group e.g. `ADVANCE-SUPERIOR` (or reuse your division superior group)
3. Add the **Superior** user(s) as members (Sequence 1 = first Superior)

### 2. Advance Payment workflow
1. Tell Me → **Workflows** → open **ADVANCE PAYMENT IT** (or your Imprest workflow)
2. Line 1 event: **Approval of a Imprest is requested**
3. **Then Response** → Approver Type = **Workflow User Group** → pick the Superior group above  
4. Cancel event must be **Imprest / Advance Payment canceled** (not Store Requisition)
5. Clear Dimension conditions if all divisions should use this workflow
6. **Enabled = On**

### 3. Advance Payment Setup (amount steps only)
1. Tell Me → **Advance Payment Setup**
2. Set **FAD User ID**, **COO User ID**, **CEO User ID**
3. Confirm limits (defaults 50,000 / 100,000)

## Behaviour on submit

`RequestImprestApproval`:

1. Starts the BC workflow → first Open entry = **Workflow User Group** member → labeled **Superior**  
2. Sets next entry to **FAD / COO / CEO** by amount and cancels extra group steps  

Portal history: **Superior → FAD|COO|CEO**.
