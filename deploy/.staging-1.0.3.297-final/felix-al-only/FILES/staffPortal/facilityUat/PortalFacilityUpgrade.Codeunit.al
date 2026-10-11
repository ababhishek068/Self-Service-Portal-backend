/// <summary>
/// Install triggers only run on first install; existing environments get the app
/// as an UPGRADE, so register the Facility-UAT web services here too.
/// </summary>
codeunit 52123 "Portal Facility Upgrade"
{
    Subtype = Upgrade;
    Permissions = tabledata "Tenant Web Service" = RIM;

    trigger OnUpgradePerCompany()
    var
        PortalFacilityInstall: Codeunit "Portal Facility Install";
    begin
        PortalFacilityInstall.PublishFacilityWebServices();
    end;
}
