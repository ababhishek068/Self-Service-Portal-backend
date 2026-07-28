# Cursor Safe Handoff — Hijra Self Service

Copy everything in the **Cursor continuation prompt** section into Cursor before making any change.

## Cursor continuation prompt

```text
You are continuing active work on the Hijra Bank Self Service project.

Repository:
/Users/abhishekbehera/SelfServiceBackend-Hijra

Branch:
cursor/hod-modules-uat-parity

Expected base HEAD:
9430ee5

CRITICAL PRESERVATION RULES

1. The working tree contains valuable uncommitted Claude/Codex changes. Preserve and build on them.
2. NEVER run:
   - git reset --hard
   - git checkout -- <file>
   - git restore <file>
   - git clean
   - any command that replaces the repository or source folders
3. Do not delete generated/staging folders unless the user explicitly authorizes it.
4. Before editing, run:
   pwd
   git branch --show-current
   git rev-parse --short HEAD
   git status --short
   git diff --stat
   git diff --check
5. Confirm that the six modified tracked files listed below are still modified. If any expected change is missing, STOP and report it instead of recreating or overwriting blindly.
6. Inspect existing diffs before changing a file. Make the smallest additive patch and do not discard unrelated work.
7. Do not compile, publish, install, or synchronize the AL extension until Felix confirms that the latest AL source has been synchronized/pulled.
8. For Business Central deployment, use a normal upgrade/schema synchronization only. NEVER uninstall the extension, use ForceSync, clean the schema, or recreate tables. Those actions can lose entered data.
9. Do not claim an ERP/setup problem is fixed by hiding its error. Keep clear, user-friendly errors and state the required Business Central setup.

CURRENT UNCOMMITTED TRACKED FILES — MUST BE PRESERVED

- SelfServiceSuite/SelfServiceBackend/src/approvalTableIds.test.ts
- SelfServiceSuite/SelfServiceBackend/src/bcClient.ts
- SelfServiceSuite/SelfServiceBackend/src/portalApi.ts
- SelfServiceSuite/SelfServicePortal/self-service-portal/src/components/shared/MultiStepRequestPage.tsx
- SelfServiceSuite/SelfServicePortal/self-service-portal/src/components/shared/RequestFormPage.tsx
- deploy/build-complete-suite-final.sh

Expected current diff:
- 6 tracked files changed
- 134 insertions
- 12 deletions
- git diff --check passes

CURRENT UNTRACKED BUILD ARTIFACT DIRECTORIES — DO NOT CONFUSE WITH LOST SOURCE

- deploy/.staging-1.0.3.121-final/
- deploy/HIJRA-FELIX-NEEDFUL-AL-FILES-ONLY-PORTAL-1.0.3.121-AL-1.0.5.80/

CURRENT VERSIONS

- Portal/backend: 1.0.3.121
- AL: 1.0.5.80
- BUILD_ID: hijra-portal-1.0.3.121-FINAL-2026-07-29-select-relation-guard
- PORTAL_API_BUILD: v1.0.3.121 — 2026-07-29 (BC dropdown captions normalize to keys and stale values are blocked)

LATEST VERIFIED DESKTOP PACKAGES

- /Users/abhishekbehera/Desktop/HIJRA-1.0.3.121-COMPLETE-SUITE-FINAL.zip
  SHA-256: e83bdde4c9aa9efe6e1b2e3601e1204d247014ace0b2c478af098be7d6421eb0
- /Users/abhishekbehera/Desktop/HIJRA-FELIX-NEEDFUL-AL-FILES-ONLY-PORTAL-1.0.3.121-AL-1.0.5.80.zip
  SHA-256: 669a45cfff0e8fdeffab72151b17f89b224dec501da6e58cea8b350d4bda3d8b

Both ZIPs passed integrity checks. The complete package had 385 entries and the needful package had 33 AL files. There were no tracked deletions. There was no AL delta between portal versions 1.0.3.120 and 1.0.3.121.

LATEST V1.0.3.121 CHANGES ALREADY IMPLEMENTED — DO NOT REMOVE

1. Added a shared dropdown/select guard for HR, Finance, and Facilities shared forms.
2. Cached display captions are normalized to current Business Central codes/keys.
3. Removed or stale dropdown values are blocked before a SOAP request is sent.
4. The user receives an inline message asking them to select a current Business Central value.
5. RequestFormPage and MultiStepRequestPage apply the guard to headers and line forms.
6. Generic Business Central TableRelation SOAP faults such as “contains a value (...) that cannot be found in related table (...)” are translated into readable recovery guidance.
7. A regression test was added for that SOAP fault.
8. Portal/backend/package versions were advanced to 1.0.3.121.

VERIFICATION ALREADY COMPLETED FOR V1.0.3.121

- Frontend production build passed.
- Backend tests passed: 107/107.
- git diff --check passed.
- AL was intentionally NOT compiled or synchronized.

CUMULATIVE FIXES PRESENT IN THE CURRENT PACKAGES

- Salary Advance: basic/monthly salary lookup, amount derivation when BC returns zero, and amount display in lists/details.
- Emergency Staff Loan: monthly salary population.
- Leave: balance handling, leave type descriptions, days/quantity in approval, pending approval placeholder for paternity and other leave types, employee workflow visibility, cancellation, and status synchronization.
- Training: submit the real Business Central CourseCode while displaying its title; resolve stale titles; exclude closed/individual courses; improve related-table errors; populate list/detail fields.
- Attendance: remove location/coordinates from the table; retain MAC address; improve time selection where used.
- Finance/Imprest: daily-rate lookup, travel destination, employee account restoration, manual-rate fallback before validation, and flow-aware surrender fields.
- Staff Claims: support Sector-only employees, medical/non-medical field handling, flow-aware columns, and G/L account names.
- Facilities: gate-pass source/log enrichment; return query; store/purchase/fuel totals; maintenance labels/workflow; reduced stage-aware store line table; Asset Transfer approval integration; request detail/approval presentation.
- Password reset/browser timeout handling and multiple alignment/time-picker improvements.

OPEN ITEMS — AUDIT AND FIX WITHOUT REGRESSING EXISTING WORK

1. Purchase Requisition sector/department bug — CODE FIX STILL PENDING

Observed Business Central error:
“The field sector of table Purchase Header contains a value (FACILITY) that cannot be found in the related table (Dimension Value).”

Root cause already identified in:
SelfServiceSuite/.../StaffPortalCodeunit.Codeunit.al

The create and edit paths contain logic equivalent to:

if requestingDepartment <> '' then begin
    TbPurchaseHeader."Requesting Department" := requestingDepartment;
    TbPurchaseHeader."Shortcut Dimension 1 Code" := requestingDepartment;
end;

The second assignment is wrong because it copies the department code into Global Dimension 1/Sector.

Required correction in BOTH create and edit paths:

if requestingDepartment <> '' then
    TbPurchaseHeader."Requesting Department" := requestingDepartment;

Preserve the employee’s valid Shortcut Dimension 1/Sector value, such as HC. Do not create FACILITY as a Sector merely to bypass validation.

Before applying this fix:
- locate the exact synchronized AL file with rg;
- inspect its current diff;
- confirm no newer Felix/Claude change already solved it;
- patch only the two incorrect assignments;
- add or update regression coverage where feasible.

After this AL change, increment the AL patch version and package version consistently, but do not compile/publish until Felix confirms synchronization.

2. Work Ticket number series — BUSINESS CENTRAL SETUP, NOT A PORTAL CODE DEFECT

Observed error:
“Work Ticket No. must have a value in FLT-Fleet Mgt Setup: Driver Rotations. It cannot be zero or empty.”

Required BC admin steps:
- Search for No. Series.
- Create or select a Work Ticket number series, for example WORKTICKET starting at WT000001.
- Open FLT-Fleet Mgt Setup.
- Open the Driver Rotations setup/row.
- Set Work Ticket No. to that number series.
- Save, then retry creating a Work Ticket.

Do not fabricate a portal-side number if Business Central owns numbering.

3. Maintained Asset Gate Pass approval — BUSINESS CENTRAL WORKFLOW SETUP

Observed error:
“The Business Central approval workflow is not configured for this document type.”

Required BC admin steps:
- Open Workflows.
- Create or enable the Gate Pass approval workflow for Gate Pass table 50296.
- Configure the workflow user group/approvers and their sequence.
- If the workflow is specific to maintained assets, add the condition Link to = Maintenance.
- Verify the requester and approvers exist in Approval User Setup.
- Retry Request Approval.

If no Gate Pass workflow event/template is available at all, the AL workflow event/response registration is missing and must be added in AL. Do not substitute the Maintenance Request workflow for the Gate Pass document.

OTHER USER-REPORTED BEHAVIOR TO REGRESSION-CHECK

- Leave approval detail must show human-readable leave type such as Sick Leave/Paternity Leave, not only code 0001/0002.
- Leave approval detail must show Days Applied as quantity instead of ETB 0.
- Paternity and every valid leave type must show the approval flow/timeline when pending.
- Training dropdown must submit a current BC CourseCode, never typed display text such as BSC or EXCUSION EXCELLENCE.
- Imprest daily rate should come from ERP when configured; if BC has no valid rate, allow a clearly labelled manual rate and do not pretend it came from ERP.
- Imprest surrender should hide fields that are not part of the selected flow and have no value; do not show meaningless dashes everywhere.
- Staff Claim line table should show only fields relevant to the selected claim type/flow and should populate available account names and medical values.
- Store Requisition detail should show only essential stage-relevant columns; avoid a very wide table full of zeros.
- Facility list amounts should use real header or line totals and must not default every row to ETB 0.
- Gate Pass Log should populate available asset tag, destination, return date, and status.
- Maintenance detail should show useful labels/descriptions instead of raw numeric codes where Business Central supplies captions.
- Asset Transfer and other facility documents must show their real approval workflow, not a fake visual-only stepper.

WHAT FELIX’S “DO NOT COMPILE BEFORE SYNCHRONIZATION” MESSAGE MEANS

Felix is warning that compiling/publishing an older or unsynchronized AL copy can overwrite newer source/schema expectations and make users re-enter data. The safe sequence is:

1. Stop AL compilation/publication.
2. Synchronize/pull the latest shared AL changes.
3. Review and merge this repository’s uncommitted diff.
4. Resolve conflicts without discarding either side.
5. Back up the tenant/database and current extension package.
6. Compile once from the merged source.
7. Publish using a normal upgrade/schema synchronization.
8. Never uninstall, clean schema, or ForceSync.
9. Smoke-test existing records before entering new production data.

PACKAGING EXPECTATION AFTER ANY NEW FIX

The user wants only the necessary files, preserving their exact folder structure, plus a complete suite package:

1. Complete suite ZIP on Desktop.
2. Needful AL-files-only ZIP on Desktop containing only required AL changes with exact relative paths.
3. Include portal/backend needful files when those layers changed.
4. Re-run frontend build, backend tests, git diff --check, ZIP integrity checks, and report hashes.
5. Do not remove or overwrite the previous verified ZIPs until the replacement packages pass verification.

FIRST RESPONSE TO THE USER AFTER LOADING THIS CONTEXT

Report:
- whether the branch and HEAD match;
- whether all six protected modified files are present;
- current diff statistics;
- whether the two verified ZIPs still match their hashes;
- which pending issue you will address;
- that no destructive Git operation or AL compile/sync will be performed.
```

## Short safety checklist

Before continuing in another IDE:

1. Open the same repository and branch.
2. Check `git status --short` before making changes.
3. Confirm the six protected modified files are present.
4. Never reset, restore, checkout, or clean the working tree.
5. Synchronize the latest shared AL source before compiling.
6. Use only a normal Business Central upgrade/schema synchronization.
7. Keep the verified ZIPs until the next packages pass tests and checksum verification.

