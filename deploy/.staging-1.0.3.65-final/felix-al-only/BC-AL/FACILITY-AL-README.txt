================================================================================
HIJRA SSP — FACILITY MANAGEMENT AL PACKAGE (UAT fixes, 27 Jul 2026)
For: Felix (BC administrator)
================================================================================

WHY: The SSP portal v1.0.3.62+ ships every Facility screen and API, but these
additive BC objects must be compiled into the portal extension and published as
web services before maintenance actions, work-ticket flight booking, asset
transfer posting, purchase specification attachments and the procurement
template work end-to-end.

--------------------------------------------------------------------------------
1. ADD THESE OBJECTS TO THE PORTAL EXTENSION (same app as Portal Training Mgt.)
--------------------------------------------------------------------------------
Tables
  52122  Portal Work Ticket Flight        (PortalWorkTicketFlight.Table.al)
  52123  Portal Fuel Maint. Extra         (PortalFuelMaintExtra.Table.al)
  52124  Portal Procurement Plan Hdr.     (PortalProcurementPlanHeader.Table.al)
  52125  Portal Procurement Plan Line     (PortalProcurementPlanLine.Table.al)

Codeunits
  52106  Portal Attachments Mgt.          (PortalAttachmentsMgt.Codeunit.al)
  52120  Portal Asset Transfer Mgt.       (PortalAssetTransferMgt.Codeunit.al)
  52122  Portal Facility Mgt.             (PortalFacilityMgt.Codeunit.al)

Queries
  50126  QyGatePassTransferShipments      (QyGatePassTransferShipments.Query.al)
  50127  QyGatePassAssetTransfers         (QyGatePassAssetTransfers.Query.al)
  52121  QyAssetTransfer                  (QyAssetTransfer.Query.al)
  52122  QyWorkTicketFlight               (QyWorkTicketFlight.Query.al)
  52123  QyPortalFuelMaintExtra           (QyPortalFuelMaintExtra.Query.al)
  52124  QyProcurementPlanHeader          (QyProcurementPlanHeader.Query.al)
  52125  QyProcurementPlanLines           (QyProcurementPlanLines.Query.al)

If any object ID above is already taken in your extension, renumber the object —
the portal only depends on the published SERVICE NAMES below.

--------------------------------------------------------------------------------
2. PUBLISH THESE WEB SERVICES (Web Services page) — names must match EXACTLY
--------------------------------------------------------------------------------
SOAP  (Object Type = Codeunit)
  CuPortalFacility        -> codeunit 52122 Portal Facility Mgt.
  CuPortalAssetTransfer   -> codeunit 52120 Portal Asset Transfer Mgt.
  CuPortalAttachments     -> codeunit 52106 Portal Attachments Mgt.

OData (Object Type = Query)
  QyWorkTicketFlight          -> query 52122
  QyPortalFuelMaintExtra      -> query 52123
  QyProcurementPlanHeader     -> query 52124
  QyProcurementPlanLines      -> query 52125
  QyAssetTransfer             -> query 52121
  QyGatePassTransferShipments -> query 50126
  QyGatePassAssetTransfers    -> query 50127

--------------------------------------------------------------------------------
3. KNOWN FIELD-NAME ASSUMPTIONS (adjust if the compiler complains)
--------------------------------------------------------------------------------
a) QyAssetTransfer + QyGatePassAssetTransfers target table 50278 "Asset
   Transfer" (card page 50584). If your table object or its fields are named
   differently, fix the source names on the LEFT of each column. The column
   names on the RIGHT are read by the portal and must not change.
b) QyGatePassTransferShipments assumes a custom "Gate Pass No." field on the
   standard Transfer Shipment Header (5744). If it does not exist, add it (the
   gate-pass flow stamps it) or drop the column and tell TA so the portal
   filter is relaxed.
c) Portal Asset Transfer Mgt. writes table 50278 through RecordRef + field-name
   lookup, so it compiles regardless of the exact field list. If a SOAP call
   does nothing, the field name in ApplyTransferFields() does not match —
   align it there.
d) SendForApproval/PostTransfer in Portal Asset Transfer Mgt. use a minimal
   status write. If the bank's approval workflow needs the card 50584 action
   code (OnSendForApproval events / posting routine), paste that code into
   those two functions.

--------------------------------------------------------------------------------
4. WHAT LIGHTS UP AFTER PUBLISHING
--------------------------------------------------------------------------------
UAT R4        Purchase specification documents attach to Purchase Header (38)
UAT R35-R44   Maintenance template + assign technician + FA receipt + odometer
              (next service KM = current + 5,000 per R41)
UAT R45-R48   Work ticket flight booking + booking confirmation receipt
UAT R49-R54   Asset transfer create/update/approval action/post from portal
UAT R55-R58   Gate pass source dropdowns for transfer orders + asset transfers
UAT R59-R61   Procurement budget template (header, itemised lines, submit)

No portal redeploy is needed after publishing — the backend already calls
these services and falls back gracefully until they exist.
================================================================================
