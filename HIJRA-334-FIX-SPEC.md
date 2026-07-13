# HIJRA BC24_TA App — exact fix spec (verified against installed 1.0.2.334)

Source of truth: extracted from the **installed** `Technology Associates EA Ltd_BC24_TA App_1.0.2.334.app`
(NAVX header stripped, manifest confirms `Version="1.0.2.334"`). All file paths/line numbers below
are from that real source. Build the next version as **1.0.2.335** from the real project folder
`C:\Users\erp\Desktop\apps_erp\hijraERP\Hijra` (the folder dated 7/10 9:27 PM that built .334).

DO NOT touch payroll (Felix's instruction — payroll data was removed from UAT; that is why Salary
Advance shows 0. It is expected in UAT and will populate in production. No `Basic_Pay` change.)

---

## A. SIMPLE — long-name overflow (Code[20]) — safe find/replace in Table files

These cause the "A value ... is too long (Total Reward and Recognition)" errors on Imprest Surrender
and Staff Claims. Fix = wrap each assignment in `CopyStr(<value>, 1, MaxStrLen(<field>))`.

### A1. src\Table\ImprestSurrenderHeader.Table.al
Fields are Code[20]: `field(50004;"District Name")`, `field(50005;"Branch Name")`, `field(50007;"Division Name")`.
Wrap these assignments (lines 390, 507, 509, 510, 541, 567):
- `"District Name" := departmentsRec."Department Name";`  (appears x2 — 390 & 541)
- `"District Name" := Emp."District Name";`
- `"Branch Name" := Emp."Branch- Name";`
- `"Division Name" := Emp."Division Name";`
- `"Division Name" := branchesdivRec."Division/Branch Name";`
→ each becomes `<field> := CopyStr(<value>, 1, MaxStrLen(<field>));`

### A2. src\Table\StaffClaimsHeader.Table.al
NOTE: Felix already widened `Branch Name` and `Department Name` to Code[100]. Still Code[20] and unfixed:
`field(93;"District Name")`, `field(95;"Division Name")`. Wrap (lines 418, 420, 423, 449):
- `"Sector Name" := "HR-EMP"."Sector Name";`            (Code[50] — safe margin, wrap anyway)
- `"District Name" := "HR-EMP"."District Name";`         (Code[20])
- `"Division Name" := "HR-EMP"."Division Name";`         (Code[20])
- `"District Name" := departmentsRec."Department Name";` (Code[20]) ← THE actual failure: dept name into District
→ each becomes `<field> := CopyStr(<value>, 1, MaxStrLen(<field>));`

A guarded PowerShell patch for A1+A2 is provided: `apply-hijra-334-to-335-longname.ps1`.

---

## B. NEEDS DEVELOPMENT (Felix) — not a find/replace

### B1. Work Tickets — "Method WorkTicketHeader is invalid"
In `StaffPortalCodeunit.Codeunit.al` there is **NO** `WorkTicketHeader` procedure (only `DeleteWorkTicketLine`).
The portal calls SOAP methods `WorkTicketHeader` and `WorkTicketLine` to create the ticket — those functions
were never written. Felix must add both, inserting into the Work Ticket tables.

Blueprint (verified against .334 source):
- Header table: `"FLT-Daily Work Ticket Header"` — key `"Ticket No."` [Code20], generated via its `"No. Series"`
  (field 18); the codeunit already has `NoSeriesMgt: Codeunit "No. Series"` + `Nosetup: Record "No. Series Line"`.
  Settable fields to map: `"Previous W.T. No."`(2)←previousWTNo, `"G.K. No."`(3)←gkNo, `Department`(11)←employee dept.
  NOTE `Type`(6) is a FlowField (auto from vehicle Model) — do NOT assign it.
- Line table: `"FLT-Daily Work Ticket Lines"` — key `"Line No."`(1)+`"Ticket No."`(2). Map: `"Work Date"`(3)←workDate,
  `"Departure From"`(9)←departureFrom, `Destination`(25)←destination, `"Authorizing Officer No"`(23)←authorizingOfficer.
  NOTE `"Driver Name"`(8) and `"Authorizing Officer Name"`(28) are FlowFields — set the No. fields, not the names.
- Portal sends header: action, ticketNo, employeeNo, previousWTNo, gkNo, type, department.
  Portal sends line: action, ticketNo, lineNo, driverName, departureFrom, destination, workDate, authorizingOfficer, employeeNo.
- Mirror the create/edit + No.Series pattern used by `ImprestSurrenderHeader`/`PurchaseRequisitionHeader` in the same codeunit.
Felix must decide the numbering + which employee→dimension mapping applies (business logic).

### B2. Purchase Requisition — "Requesting Department must have a value"
`PurchaseRequisitionHeader` (line ~1310) sets Shortcut Dimension 1/2/3 from the employee but never sets
the mandatory `"Requesting Department"` (Purchase Header field 50090, Code[20]). Add, in the create block
right after the Shortcut Dimension assignments:
`TbPurchaseHeader."Requesting Department" := TbEmployee."Global Dimension 1 Code";`
(and the same in the edit block). Global Dimension 1 Code is a dimension CODE, so it fits Code[20].

### B3. Gate Pass (Asset Transfer / Store Requisition / Transfer Orders) — "Entity does not support insert"
The portal POSTs to `QyGatePass`, which is a **Query** (read-only in OData → cannot insert). BC must expose
an insertable Gate Pass **Page** web service or a codeunit create method — or gate passes should be
auto-generated on posting the source document and the portal should only read them. BC design decision.

### B4. Transport Requisition — "created but did not return its document number" (after number-series repair)
Number series `TRANSPORT` was repaired on 2026-07-11 (Ending No. set to `TRNS_9999`, a leftover blank-number
record deleted). After that the "could not allocate" error changed to "created but did not return its document
number" — i.e. the `TransportRequisition` codeunit inserts the header **without assigning a No. from the series**,
so portal-created requisitions get a blank number. Felix: make the codeunit call the No. Series
(`NoSeriesMgt.GetNextNo`) on insert so the document number is assigned and returned. (Confirmed blank-number
records accumulate from each portal attempt.)

### B5. Petty Cash Replenishment — "The limit for this branch is not setup" for Corporate employees
The current `InterBankTransfers.Table.al` logic matches a limit by **branch only**. But Corporate (COORP) staff
like E0083 have **no branch** (none exists in the Sector→Division→Branch hierarchy for their sector — verified:
the branch lookup is empty even via "Select from full list"). So branch-based limits can never match for them.
Felix: add the **department-fallback** (if no branch limit, use a Petty Cash Limits-Departments entry) — the block
from the original .333 plan. Then Finance adds an HC department limit (page 51641).

---

## C. BC ADMIN SETTINGS (no code)
- Petty Cash: Payment Type `PETTY` → replace invalid G/L account `101006` with a valid one (page 50870).
- Petty Cash Replenishment: add limit for E0083's branch (page 51640) or department (page 51641).
- Transport Requisition: repair TR No. Series + remove the blank-number record.
- Fuel Requisition: enable the approval workflow for the fuel document type (table 50865/50866).

---

## Build & publish 1.0.2.335 (on the server)
1. Apply section A (patch script or by hand) to `...\hijraERP\Hijra`. Have Felix add B1/B2 in the same source.
2. In VS Code on that folder: `AL: Download Symbols`, then `AL: Package` → produces `...1.0.2.335.app`.
3. Business Central Administration Shell (as Administrator):
   Publish-NAVApp / Sync-NAVApp / Start-NAVAppDataUpgrade / Restart-NAVServerInstance (version 1.0.2.335).
4. Then do section C settings, and retest.
