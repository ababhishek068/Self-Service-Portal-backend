# Finance Advance Payment approval — Nitish setup

**BC:** `1.0.3.626`  
**Portal:** shows the ladder on Advance Payment and reads Approval Entries as before.

## Rule (ESSP / ABH)

1. **Line Manager** approves every Advance Payment first.
2. Then by **Total Net Amount (ETB)**:
   - below **50,000** → **FAD**
   - **50,000–100,000** → **COO**
   - above **100,000** → **CEO**

BC owns the workflow; ESSP only submits and shows status / comments / payment refs from Approval Entries.

## What to configure in BC

1. Tell Me → **Advance Payment Setup**
   - Set **FAD User ID**, **COO User ID**, **CEO User ID**
   - Confirm amount limits (defaults 50,000 / 100,000)
   - Optional **Line Manager Fallback ID**
2. Keep the existing **Imprest / Advance Payment** approval workflow enabled (event used by `RequestImprestApproval`).
3. Employee must have a line manager via User Setup Approver ID, or Supervisor/HOD on the employee card (or the fallback).

## Behaviour on submit

`RequestImprestApproval` still starts the BC workflow, then:

1. Inserts **Line Manager** as the first open Approval Entry  
2. Sets the next entry to **FAD / COO / CEO** (by amount) and cancels extra workflow steps  

Portal Approval History will show those step labels when BC returns the entries.
