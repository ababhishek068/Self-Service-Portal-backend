HIJRA SSP — SAFE FELIX AL PATCH
================================

This fixes the red underline / duplicate-object problem shown in VS Code.
It keeps ONE attachment codeunit:
  src\staffPortal\employeeExit\PortalAttachmentMgt.Codeunit.al (codeunit 52106)

It removes the wrong duplicate:
  src\staffPortal\facilityUat\PortalAttachmentsMgt.Codeunit.al

It also puts Facility queries in their correct folders, uses the real Felix
field captions ("Destination/Location" and "Gate Pass No"), updates the Facility
permission/install objects, restores the complete HR Letters object set, and
safely finds the very deeply nested HR files.

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
  CuPortalAssetTransfer  -> codeunit 52160
  CuPortalFacility       -> codeunit 52161
  CuPortalHrLetters      -> codeunit 52141

OData:
  QyAssetTransfer          -> query 52166
  QyWorkTicketFlight       -> query 52167
  QyPortalFuelMaintExtra   -> query 52168
  QyProcurementPlanHeader  -> query 52169
  QyProcurementPlanLines   -> query 52170

The install/upgrade codeunits publish these automatically.
