/// <summary>
/// Publishes codeunit 52101 as the SOAP web service the Self Service Portal calls.
///
/// Without this the portal reaches BC and BC answers
///   Service "Codeunit/CuPortalEmployeeExit" was not found
/// because deploying the extension does NOT register a web service — that is a separate
/// entry in the Web Services page. Doing it here means installing the app is sufficient
/// and nobody has to remember the manual step on each environment.
///
/// The service name must stay in step with BC_SOAP_EXIT_CODEUNIT_URL in the portal .env.
/// </summary>
codeunit 52103 "Portal Employee Exit Install"
{
    Subtype = Install;
    Permissions = tabledata "Tenant Web Service" = RIM;

    trigger OnInstallAppPerCompany()
    begin
        PublishEmployeeExitWebService();
        PublishEmployeeDataWebService();
        PublishPortalAttachmentsWebService();
    end;

    procedure PublishEmployeeExitWebService()
    var
        TenantWebService: Record "Tenant Web Service";
    begin
        if TenantWebService.Get(TenantWebService."Object Type"::Codeunit, ServiceNameTok) then begin
            if (TenantWebService."Object ID" = Codeunit::"Portal Employee Exit Mgt.") and
               TenantWebService.Published
            then
                exit;
            TenantWebService."Object ID" := Codeunit::"Portal Employee Exit Mgt.";
            TenantWebService.Published := true;
            TenantWebService.Modify(true);
            exit;
        end;

        TenantWebService.Init();
        TenantWebService."Object Type" := TenantWebService."Object Type"::Codeunit;
        TenantWebService."Service Name" := ServiceNameTok;
        TenantWebService."Object ID" := Codeunit::"Portal Employee Exit Mgt.";
        TenantWebService.Published := true;
        TenantWebService.Insert(true);
    end;

    procedure PublishEmployeeDataWebService()
    var
        TenantWebService: Record "Tenant Web Service";
    begin
        if TenantWebService.Get(TenantWebService."Object Type"::Codeunit, DataServiceNameTok) then begin
            if (TenantWebService."Object ID" = Codeunit::"Portal Employee Data Mgt.") and
               TenantWebService.Published
            then
                exit;
            TenantWebService."Object ID" := Codeunit::"Portal Employee Data Mgt.";
            TenantWebService.Published := true;
            TenantWebService.Modify(true);
            exit;
        end;

        TenantWebService.Init();
        TenantWebService."Object Type" := TenantWebService."Object Type"::Codeunit;
        TenantWebService."Service Name" := DataServiceNameTok;
        TenantWebService."Object ID" := Codeunit::"Portal Employee Data Mgt.";
        TenantWebService.Published := true;
        TenantWebService.Insert(true);
    end;

    procedure PublishPortalAttachmentsWebService()
    var
        TenantWebService: Record "Tenant Web Service";
    begin
        if TenantWebService.Get(TenantWebService."Object Type"::Codeunit, AttachmentsServiceNameTok) then begin
            if (TenantWebService."Object ID" = Codeunit::"Portal Attachment Mgt.") and
               TenantWebService.Published
            then
                exit;
            TenantWebService."Object ID" := Codeunit::"Portal Attachment Mgt.";
            TenantWebService.Published := true;
            TenantWebService.Modify(true);
            exit;
        end;

        TenantWebService.Init();
        TenantWebService."Object Type" := TenantWebService."Object Type"::Codeunit;
        TenantWebService."Service Name" := AttachmentsServiceNameTok;
        TenantWebService."Object ID" := Codeunit::"Portal Attachment Mgt.";
        TenantWebService.Published := true;
        TenantWebService.Insert(true);
    end;

    var
        ServiceNameTok: Label 'CuPortalEmployeeExit', Locked = true;
        DataServiceNameTok: Label 'CuPortalEmployeeData', Locked = true;
        AttachmentsServiceNameTok: Label 'CuPortalAttachments', Locked = true;
}
