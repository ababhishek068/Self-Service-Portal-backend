HIJRA SSP — SAFE FELIX AL PATCH
================================

This fixes the red underline / duplicate-object problem shown in VS Code.
It keeps ONE attachment codeunit:
  src\staffPortal\employeeExit\PortalAttachmentMgt.Codeunit.al (codeunit 52106)

It removes the wrong duplicate:
  src\staffPortal\facilityUat\PortalAttachmentsMgt.Codeunit.al

It also puts Facility queries in their correct folders, uses the real Felix
field captions ("Destination/Location" and "Gate Pass No"), updates the Facility
permission/install objects, restores the complete Employee Exit, HR Letters and
Training object sets, includes the petty-cash department-limit query, adds the
Maintenance Gate Pass source, exposes the complete Gate Pass Log and actual
return dates, corrects Purchase Requisition budget validation so the header and
lines use the same requesting department, and safely finds the deeply nested
base files. The finalized-budget control is still enforced; its error now names
the real item/service number instead of showing the free-text specification.

SYNCHRONIZE FIRST
-----------------
Felix must first pull/synchronize the latest Hijra AL source, then run this
patch against that synchronized project. Do not compile an older source copy:
publishing stale AL can remove fields or data mappings added by recent work.

BEGINNER-SAFE STEPS
-------------------
1. Extract this ZIP to a normal folder.
2. Close VS Code, or at least stop the current AL build.
3. Open Windows PowerShell.
4. Run this command, replacing the final path with Felix's real Hijra folder:

   powershell -ExecutionPolicy Bypass -File ".\APPLY-HIJRA-PATCH.ps1" `
     -HijraProject "C:\Path\To\Hijra"

5. Wait for the green message:
     PATCH APPLIED AND OBJECT IDS VALIDATED.
   Unless -SkipVersionBump is used, app.json is raised to at least 1.0.5.78.
6. Open the Hijra folder in VS Code.
7. Press Ctrl+Shift+P, choose "AL: Package".
8. Publish the generated .app to the UAT Business Central server.

The script creates a timestamped backup inside the Hijra project:
  .hijra-ssp-backup-YYYYMMDD-HHMMSS

If AL: Package still shows an error, copy the FIRST red error only (including
file and line), not the "1K+" Problems badge. Later errors often cascade from
the first one.

EXPECTED SERVICES AFTER APP INSTALL/UPGRADE
-------------------------------------------
SOAP:
  CuPortalEmployeeExit   -> codeunit 52101
  CuPortalEmployeeData   -> codeunit 52105
  CuPortalAttachments    -> codeunit 52106
  CuPortalTraining       -> codeunit 52121
  CuPortalAssetTransfer  -> codeunit 52160
  CuPortalFacility       -> codeunit 52161
  CuPortalHrLetters      -> codeunit 52141

OData:
  QyApprovalCommentLine      -> query 50091
  QyTrainingApplicationHeader -> query 50103
  QyPettyCashLimitDepartment -> query 52132
  QyAssetTransfer          -> query 52166
  QyWorkTicketFlight       -> query 52167
  QyPortalFuelMaintExtra   -> query 52168
  QyProcurementPlanHeader  -> query 52169
  QyProcurementPlanLines   -> query 52170
  QyGatePassReturns        -> query 52171

The install/upgrade codeunits publish these automatically.
