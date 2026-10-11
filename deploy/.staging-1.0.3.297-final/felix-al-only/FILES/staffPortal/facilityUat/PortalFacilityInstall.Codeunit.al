/// <summary>
/// Registers the Facility-UAT web services so installing the app is sufficient —
/// no manual Web Services (page 810) step per environment. Same pattern as
/// "Portal Employee Exit Install" (codeunit 52103).
///
/// SOAP:  CuPortalAssetTransfer -> codeunit 52160
///        CuPortalFacility      -> codeunit 52161
/// OData: QyAssetTransfer         -> query 52166
///        QyVehicleAccessories    -> query 52175
///        QyAssetTransferTools    -> query 52176
///        QyWorkTicketFlight      -> query 52167
///        QyPortalFuelMaintExtra  -> query 52168
///        QyProcurementPlanHeader -> query 52169
///        QyProcurementPlanLines  -> query 52170
///        QyGatePassReturns        -> query 52171
///        QyPortalPurchaseLines    -> query 52177
///
/// Service names must stay in step with the portal backend (staffModules/portalApi).
/// </summary>
codeunit 52122 "Portal Facility Install"
{
    Subtype = Install;
    Permissions = tabledata "Tenant Web Service" = RIM;

    trigger OnInstallAppPerCompany()
    begin
        PublishFacilityWebServices();
    end;

    procedure PublishFacilityWebServices()
    begin
        PublishCodeunitService(Codeunit::"Portal Asset Transfer Mgt.", 'CuPortalAssetTransfer');
        PublishCodeunitService(Codeunit::"Portal Facility Mgt.", 'CuPortalFacility');
        PublishQueryService(Query::"QyAssetTransfer", 'QyAssetTransfer');
        PublishQueryService(Query::"QyVehicleAccessories", 'QyVehicleAccessories');
        PublishQueryService(Query::"QyAssetTransferTools", 'QyAssetTransferTools');
        PublishQueryService(Query::"QyWorkTicketFlight", 'QyWorkTicketFlight');
        PublishQueryService(Query::"QyPortalFuelMaintExtra", 'QyPortalFuelMaintExtra');
        PublishQueryService(Query::"QyProcurementPlanHeader", 'QyProcurementPlanHeader');
        PublishQueryService(Query::"QyProcurementPlanLines", 'QyProcurementPlanLines');
        PublishQueryService(Query::"QyGatePassReturns", 'QyGatePassReturns');
        PublishQueryService(Query::"QyPortalPurchaseLines", 'QyPortalPurchaseLines');
        // UAT R37: the Training (and other) department dropdown reads the
        // OData page service 'PgDepartmentsList'. Publish page 51479
        // "Departments List" so the dropdown is populated instead of inactive.
        PublishPageService(Page::"Departments List", 'PgDepartmentsList');
    end;

    local procedure PublishCodeunitService(objectId: Integer; serviceName: Text[250])
    var
        TenantWebService: Record "Tenant Web Service";
    begin
        if TenantWebService.Get(TenantWebService."Object Type"::Codeunit, serviceName) then begin
            if (TenantWebService."Object ID" = objectId) and TenantWebService.Published then
                exit;
            TenantWebService."Object ID" := objectId;
            TenantWebService.Published := true;
            TenantWebService.Modify(true);
            exit;
        end;

        TenantWebService.Init();
        TenantWebService."Object Type" := TenantWebService."Object Type"::Codeunit;
        TenantWebService."Service Name" := serviceName;
        TenantWebService."Object ID" := objectId;
        TenantWebService.Published := true;
        TenantWebService.Insert(true);
    end;

    local procedure PublishQueryService(objectId: Integer; serviceName: Text[250])
    var
        TenantWebService: Record "Tenant Web Service";
    begin
        if TenantWebService.Get(TenantWebService."Object Type"::Query, serviceName) then begin
            if (TenantWebService."Object ID" = objectId) and TenantWebService.Published then
                exit;
            TenantWebService."Object ID" := objectId;
            TenantWebService.Published := true;
            TenantWebService.Modify(true);
            exit;
        end;

        TenantWebService.Init();
        TenantWebService."Object Type" := TenantWebService."Object Type"::Query;
        TenantWebService."Service Name" := serviceName;
        TenantWebService."Object ID" := objectId;
        TenantWebService.Published := true;
        TenantWebService.Insert(true);
    end;

    local procedure PublishPageService(objectId: Integer; serviceName: Text[250])
    var
        TenantWebService: Record "Tenant Web Service";
    begin
        if TenantWebService.Get(TenantWebService."Object Type"::Page, serviceName) then begin
            if (TenantWebService."Object ID" = objectId) and TenantWebService.Published then
                exit;
            TenantWebService."Object ID" := objectId;
            TenantWebService.Published := true;
            TenantWebService.Modify(true);
            exit;
        end;

        TenantWebService.Init();
        TenantWebService."Object Type" := TenantWebService."Object Type"::Page;
        TenantWebService."Service Name" := serviceName;
        TenantWebService."Object ID" := objectId;
        TenantWebService.Published := true;
        TenantWebService.Insert(true);
    end;
}
