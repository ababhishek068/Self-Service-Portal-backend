ABH SELF SERVICE PORTAL — INSTALL v1.0.3.344 / API v193
======================================================

This is the paired ABH UAT release. It includes Business Central app
1.0.3.273, workflow-driven ERP approvals and requester-visible rejection notes,
requester-visible mandatory rejection reasons, audited Purchase and Store Requisitions, production Employee Exit
Supervisor/HR routing, Imprest Surrender, mandatory claim/sick-leave
attachments, attendance grace
rules and 7:00 PM auto sign-out, live HOD department functions, HR-only policy
administration, plus live Employee Card medical balances on Staff Claims.
Do not mix this portal zip with an older Business Central app.

PORTAL INSTALL
==============

1) Keep the old portal folder as a rollback copy.
2) Extract ABH-Portal-COMPLETE-1.0.3.344.zip to C:\TA\
3) Copy the working .env into:
   SelfServiceSuite\SelfServiceBackend\.env
4) Run VERIFY-SUITE.bat. It must say ALL CHECKS PASSED.
5) Run START-ABH-PORTAL.bat.
6) Open http://146.161.102.7:4000/api/portal-build
   Expected: v193 — 1.0.3.344 (Leave approval notifications through BC)
7) Log in and press Ctrl+Shift+R once to clear the old browser bundle.
8) In Administrator PowerShell, run INSTALL-AUTOSTART.ps1 once to start the
   portal automatically after every Windows server restart.

BUSINESS CENTRAL APP
====================

1) Open the extracted BusinessCentral folder.
2) Copy "Technology Associates EA Ltd_BC24_TA App_1.0.3.273.app" to
   C:\TA\publish\ on the Business Central server.
3) Run ABH-PUBLISH-BC.ps1 as Administrator in the Business Central
   Administration Shell.
4) Confirm BC24_TA App 1.0.3.273 is installed. The StaffPortal codeunit
   includes the HR policy create/delete operations; its existing SOAP endpoint
   remains the same, so no web-service refresh is required.
   CuPortalEmployeeExit is published automatically by app install/upgrade.
5) Follow BusinessCentral\ABH-PRODUCTION-SETUP.txt to assign the real ABH
   approvers and enable the supplied workflows.

NEW FLOW TESTS
==============

1) Create Purchase and Store Requisitions from the portal, add lines, upload
   supporting documents, and request approval. The actual assigned approver
   must approve/reject in Business Central Approvals.
2) Open Employee Exit and submit Transfer, Resignation, and Employee Exit Form
   requests. Confirm Transfer/Resignation go Supervisor then HR. Confirm the
   Employee Exit Form is recorded directly as Completed with no approval entry.
3) Confirm Staff Claim submission is blocked without an attachment, and Sick
   Leave submission is blocked without a medical/supporting attachment.
4) Confirm arrivals through 08:50 are within grace, checkout from 17:20 is
   within grace, and open attendance is closed at 19:00 by the running portal.
5) Create an Imprest Surrender against an eligible Business Central imprest.
6) Sign in as an HOD and confirm Department Staff and Staff on Leave show only
   that HOD's department. Sign in as ordinary staff and confirm HOD navigation
   is absent.
7) Sign in as HR, upload an unpublished HR policy draft, then publish a test
   policy. Ordinary staff must see/download only the published document and
   must never see Upload or Delete. Delete the test policy as HR.
8) Reject one request at each approval step. A reason of at least three
   characters must be required and displayed to the requester in Approval History.
9) For ABH-010 Annual Leave, confirm Accrued To-Date = Carry Forward + Accrued
   Days and Available = Accrued To-Date - Taken To-Date on the Employee Card,
   portal, and generated leave-statement PDF.
10) Start a 2-day Annual Leave on a Friday. When Saturday/Sunday are excluded
    on the BC Leave Type, End Date must be Monday and Return Date Tuesday.
11) Submit, cancel, and resubmit one leave request. The requester timeline must
    show only the newest run: Step 1 Pending and later steps Waiting.

LEAVE STATUS / DIRECT EDIT TEST
===============================

1) In Business Central, open an HR Leave Application whose status is
   Pending Approval.
2) Click the standard pencil Edit button. Status must now show a dropdown with
   Open, Pending Approval, Approved, Rejected, Canceled, and Posted.
3) Sign in as the user assigned to the open leave Approval Entry. Use Approvals
   and choose Approve. The workflow must set the leave header to Approved and
   run the normal leave-allocation validation.
4) For correction instead, select Open. Confirm the prompt. Active approvals are cancelled/archived and
   the application reopens for editing.
5) Change Leave Type, Reason, Days Applied, Start Date, End Date, or Reliever.
   The live approval request is cancelled and archived before the first change
   is saved, and the leave application returns to Open.
6) Save the correction.
7) Select Pending Approval in the Status dropdown (or choose Approvals > Send
   Approval Request). The normal workflow creates the approval request.

Approved, Rejected, Canceled, and Posted remain workflow-controlled and cannot
be forced from the Status dropdown, including by an administrator. The assigned
approver must complete the approval through Business Central Approvals.

EMPLOYEE ORGANISATION TEST
==========================

1) Search HR Employee List and open employee ABH-010.
2) Confirm Job Group / Job Level is populated under Salary Calculations.
3) Select District on the employee card. District Name fills automatically.
4) In the portal, sign out and sign in, then open Medical Claim. Job Grade and
   District must display the Business Central employee values instead of a dash.

MEDICAL DEPENDANT TEST
======================

1) Create a medical claim for ABH-010 and choose Patient = Dependant.
2) Select spouse Etaferahu from the dependant lookup. Business Central must retain
   the spouse name and must not validate child Evana's date of birth.
3) Select child Evana separately. The genuine child date-of-birth and maximum-age
   validation must still run against Evana's HR Employee Kin record.

If verification fails, run ABH-DIAGNOSE.bat while the portal is running and
send the generated ABH-PORTAL-DIAGNOSTIC.txt file.
