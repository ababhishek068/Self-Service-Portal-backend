HIJRA HR LETTERS — COMPILE FIX (25 Jul 2026)
============================================

If you saw errors like:
  - Record "Portal HR Letter Request" does not contain a definition for 'Purpose'
  - 'InProgress' is not an option on field 'Status'
  - 'ReadyForCollection' is not an option on field 'Status'

REPLACE the entire folder:
  src/staffPortal/hrLetter   (or hrLetters)
with the files from this package:
  src/staffPortal/hrLetters/

FILES IN THIS FOLDER (10 objects)
---------------------------------
PortalHrLetterRequest.Table.al        table 52140
PortalHrLetterStatus.Enum.al          enum 52144
PortalHrLetterType.Enum.al            enum 52145
PortalHrLettersMgt.Codeunit.al        codeunit 52141  (SOAP: CuPortalHrLetters)
PortalHrLettersInstall.Codeunit.al    codeunit 52142
PortalHrLettersUpgrade.Codeunit.al    codeunit 52143
PortalHrLetterRequests.Page.al        page 52140
PortalHrLetterRequestCard.Page.al     page 52146
PortalHrLettersRoleCenter.PageExt.al  pageextension 52147

THEN
----
1. Delete any duplicate/old hrLetter folder if you created one manually
2. AL: Package (Ctrl+Shift+B)
3. AL: Publish extension
4. BC → Portal Employee Transfer Setup → set HR Approver User ID
