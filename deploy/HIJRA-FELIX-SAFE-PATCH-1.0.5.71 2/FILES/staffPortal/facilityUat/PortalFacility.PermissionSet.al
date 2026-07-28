/// <summary>
/// Portal Facility permission set.
/// NOTE: Install/Upgrade codeunits are intentionally NOT listed here — they run
/// only during publish and do not need to be assigned to the WS user.
/// Query permissions and tabledata permissions must stay aligned with the web
/// services published by "Portal Facility Install".
/// </summary>
permissionset 52132 "Portal Facility"
{
    Caption = 'SSP Facility (Asset Transfer, Maintenance, Plans)';
    Assignable = true;

    Permissions =
        codeunit "Portal Asset Transfer Mgt." = X,
        codeunit "Portal Facility Mgt." = X,
        query "QyAssetTransfer" = X,
        query "QyPortalFuelMaintExtra" = X,
        query "QyProcurementPlanHeader" = X,
        query "QyProcurementPlanLines" = X,
        query "QyWorkTicketFlight" = X,
        tabledata "Portal Work Ticket Flight" = RIMD,
        tabledata "Portal Fuel Maint. Extra" = RIMD,
        tabledata "Portal Procurement Plan Hdr." = RIMD,
        tabledata "Portal Procurement Plan Line" = RIMD,
        tabledata "Asset Transfer" = RIM,
        tabledata "Asset Transfer Ledger" = RIM,
        tabledata "FLT-Fuel & Maintenance Req." = RM,
        tabledata "FLT-Daily Work Ticket Header" = RM,
        tabledata "Procurement Plan Header" = RIM,
        tabledata "Procurement Plan Lines" = RIMD,
        tabledata "FLT-Vehicle Header" = R,
        tabledata "Fixed Asset" = RM,
        tabledata "User Setup" = R,
        tabledata "HR-Employee" = R,
        tabledata "Tenant Web Service" = RIM;
}
