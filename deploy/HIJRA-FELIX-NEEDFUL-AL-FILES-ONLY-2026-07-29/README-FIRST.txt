HIJRA SSP — NEEDFUL AL FILES ONLY — 29 JULY 2026
=================================================

IMPORTANT
---------
Portal v1.0.3.101 contains the UI/backend fixes. Two BC objects in this package
must also be present in the synchronized AL source:

1. FILES\staffPortal\query\HrEmployee.Query.al exposes Basic_Pay. Without it,
   Monthly Basic Salary remains blank and Salary Advance cannot calculate an
   amount when BC stores only Percentage of Salary.
2. FILES\staffPortal\training\... stores the full Training Need Assessment.
   The install/upgrade codeunits publish CuPortalTraining, and
   PortalHr.PermissionSet.al grants the required access.

The package contains only the AL files needed for the previously identified
UAT fixes plus these salary/training dependencies. It intentionally excludes
unrelated full-module copies.

DO NOT COPY OR COMPILE BEFORE SYNCHRONIZATION
---------------------------------------------
1. Felix first synchronizes/pulls the latest Hijra AL source.
2. Create a backup/branch from that synchronized source.
3. Compare and merge each file in FILES; do not blindly replace a newer file.
4. Review FILES-TO-REMOVE.txt and remove only confirmed obsolete duplicates.
5. Review table changes carefully, especially HRLeaveApplication.Table.al and
   GatePass.Table.al, before packaging.
6. Confirm the Web Services page contains published service CuPortalTraining.
   The supplied install/upgrade codeunits register it during app deployment.
7. Compile/package once after the merge is complete.
8. Publish as a normal app upgrade/schema synchronization. Do not uninstall,
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
