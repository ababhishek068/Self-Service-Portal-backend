HIJRA SSP — NEEDFUL AL FILES ONLY — PORTAL 1.0.3.108 / AL 1.0.5.78
====================================================================

IMPORTANT
---------
Portal v1.0.3.108 contains the UI/backend fixes. The following BC objects in
this package must also be present in the synchronized AL source:

1. FILES\staffPortal\query\HrEmployee.Query.al exposes Basic_Pay. Without it,
   Monthly Basic Salary remains blank and Salary Advance cannot calculate an
   amount when BC stores only Percentage of Salary.
2. FILES\staffPortal\training\... stores the full Training Need Assessment.
   The install/upgrade codeunits publish CuPortalTraining, and
   PortalHr.PermissionSet.al grants the required access.
3. FILES\Query\ImprestHeaders.Query.al exposes Date Required, travel dates and
   Travel Destination for Imprest Surrender.
4. FILES\Query\ImprestLines2.Query.al exposes Daily Rate, Destination and Duty
   Area for Imprest and Imprest Surrender.
5. FILES\Query\ReceiptPaymentTypes.Query.al exposes the G/L Account and Rate
   Source used by Staff Claims and Imprest.
6. FILES\HR-DEEP\StaffPortalCodeunit.Codeunit.al accepts and stores a manually
   entered daily rate before Business Central validates No. of Days.
7. FILES\Query\GatePass.Query.al exposes AssetNo and ReturnDate instead of
   leaving those Gate Pass Log columns blank.
8. FILES\staffPortal\query\QyGatePassReturns.Query.al exposes the actual
   returned movement and DateIn from the Gate Pass Return table.
9. FILES\staffPortal\facilityUat\PortalFacility.PermissionSet.al plus the
   Install and Upgrade codeunits grant access and publish QyGatePassReturns
   during both new installs and normal app upgrades.
10. FILES\HR-DEEP\StaffPortalCodeunit.Codeunit.al keeps the Purchase
    Requisition header and lines on the same Requesting Department, checks the
    correct finalized departmental budget, and reports the real item/service
    number rather than the free-text specification. Budget control is not
    bypassed.

Portal v1.0.3.108 also presents Store Requisition according to the complete
operational flow: Request, Items, Approval, Store Issue and Receipt
Confirmation. It displays requester/organisation fields, available stock,
requested/to-issue/issued/received quantities, variance reasons, SRN, issue
date and values. These fields already exist in QyStoreRequisitionHeader and
QyStoreRequisitionLines, so no additional AL object is required beyond 1.0.5.78.

Portal v1.0.3.108 fixes Facility list values without requiring another AL
change. Store and Purchase totals fall back to their saved Business Central
line values when the header FlowField returns zero. Fuel cost falls back to
litres multiplied by price per litre. Non-financial workflows now display the
correct passenger, quantity, asset, or maintenance metric instead of a
misleading ETB 0.

Portal v1.0.3.108 also corrects Maintenance Request detail presentation. It
translates raw request-type codes into readable labels, uses NextServiceKM from
the existing QyPortalFuelMaintExtra service, displays odometer cards only for
vehicle maintenance, and explains Open/Pending/Approved/receipt workflow
states instead of rendering an empty workflow box. No new AL object is needed.

The package contains 33 AL files: only the cumulative AL files needed for the
previously identified UAT fixes and their required dependencies. It
intentionally excludes the frontend, backend and unrelated full-module copies.

DO NOT COPY OR COMPILE BEFORE SYNCHRONIZATION
---------------------------------------------
1. Felix first synchronizes/pulls the latest Hijra AL source.
2. Create a backup/branch from that synchronized source.
3. Compare and merge each file in FILES; do not blindly replace a newer file.
4. Review FILES-TO-REMOVE.txt and remove only confirmed obsolete duplicates.
5. Review table changes carefully, especially HRLeaveApplication.Table.al and
   GatePass.Table.al, before packaging.
6. Confirm the six Query files above are included before compiling. Missing
   query files cause blank salary, imprest, staff-claim and Gate Pass Log fields.
7. Confirm Web Services contains CuPortalTraining and QyGatePassReturns. The
   supplied install/upgrade codeunits register them during app deployment.
8. Compile/package once after the merge is complete.
9. Publish as a normal app upgrade/schema synchronization. Do not uninstall,
   clean the schema, or use ForceSync.

STRUCTURE
---------
FILES\staffPortal\... and FILES\Query\... map below the Hijra project's src
folder with the same relative path.

The deeply nested legacy files must be found by filename after synchronization:
  FILES\HR-DEEP\StaffPortalCodeunit.Codeunit.al
  FILES\HR-DEEP\HRLeaveApplication.Table.al
  FILES\BASE-DEEP\GatePass.Table.al

There is deliberately no automatic apply or version-bump script in this
package. Felix should merge these files into his synchronized source.
