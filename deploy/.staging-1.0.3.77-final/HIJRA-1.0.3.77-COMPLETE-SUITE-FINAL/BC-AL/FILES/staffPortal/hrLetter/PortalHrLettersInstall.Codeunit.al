/// <summary>
/// Registers the web services the Self Service Portal needs but nothing registered before:
///   CuPortalHrLetters            (SOAP,  codeunit 52141) — HR Service Request Letters
///   CuPortalTraining             (SOAP,  codeunit 52121) — training assessments (was manual)
///   QyApprovalCommentLine        (OData, query 50091)    — rejection reasons on requests
///   QyPettyCashLimitDepartment   (OData, query 52132)    — per-department petty cash limit
/// Installing the app is enough; no manual Web Services page entry is required.
/// </summary>
codeunit 52142 "Portal HR Letters Install"
{
    Subtype = Install;
    Permissions = tabledata "Tenant Web Service" = RIM;

    trigger OnInstallAppPerCompany()
    begin
        RegisterAll();
    end;

    procedure RegisterAll()
    begin
        EnsureCodeunitService('CuPortalHrLetters', Codeunit::"Portal HR Letters Mgt.");
        EnsureCodeunitService('CuPortalTraining', Codeunit::"Portal Training Mgt.");
        EnsureQueryService('QyApprovalCommentLine', 50091);
        EnsureQueryService('QyPettyCashLimitDepartment', 52132);
    end;

    local procedure EnsureCodeunitService(ServiceName: Text[240]; ObjectId: Integer)
    var
        TenantWebService: Record "Tenant Web Service";
    begin
        if TenantWebService.Get(TenantWebService."Object Type"::Codeunit, ServiceName) then begin
            if (TenantWebService."Object ID" = ObjectId) and TenantWebService.Published then
                exit;
            TenantWebService."Object ID" := ObjectId;
            TenantWebService.Published := true;
            TenantWebService.Modify(true);
            exit;
        end;

        TenantWebService.Init();
        TenantWebService."Object Type" := TenantWebService."Object Type"::Codeunit;
        TenantWebService."Service Name" := ServiceName;
        TenantWebService."Object ID" := ObjectId;
        TenantWebService.Published := true;
        TenantWebService.Insert(true);
    end;

    local procedure EnsureQueryService(ServiceName: Text[240]; ObjectId: Integer)
    var
        TenantWebService: Record "Tenant Web Service";
    begin
        if TenantWebService.Get(TenantWebService."Object Type"::Query, ServiceName) then begin
            if (TenantWebService."Object ID" = ObjectId) and TenantWebService.Published then
                exit;
            TenantWebService."Object ID" := ObjectId;
            TenantWebService.Published := true;
            TenantWebService.Modify(true);
            exit;
        end;

        TenantWebService.Init();
        TenantWebService."Object Type" := TenantWebService."Object Type"::Query;
        TenantWebService."Service Name" := ServiceName;
        TenantWebService."Object ID" := ObjectId;
        TenantWebService.Published := true;
        TenantWebService.Insert(true);
    end;
}
