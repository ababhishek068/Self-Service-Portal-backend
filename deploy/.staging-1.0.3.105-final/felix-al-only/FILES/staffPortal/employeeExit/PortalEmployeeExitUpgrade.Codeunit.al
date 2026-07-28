/// <summary>
/// OnInstallAppPerCompany only fires on a first install. An environment that already has an
/// earlier build of this extension upgrades instead, and would never register the web
/// service — so re-run the same registration on every version change.
/// </summary>
codeunit 52104 "Portal Employee Exit Upgrade"
{
    Subtype = Upgrade;
    Permissions = tabledata "Tenant Web Service" = RIM,
                  tabledata "Portal Employee Exit Request" = RM;

    trigger OnUpgradePerCompany()
    var
        EmployeeExitInstall: Codeunit "Portal Employee Exit Install";
    begin
        EmployeeExitInstall.PublishEmployeeExitWebService();
        EmployeeExitInstall.PublishEmployeeDataWebService();
        EmployeeExitInstall.PublishPortalAttachmentsWebService();
        MarkEmployeeExitFormsInformational();
    end;

    local procedure MarkEmployeeExitFormsInformational()
    var
        ExitRequest: Record "Portal Employee Exit Request";
    begin
        ExitRequest.SetRange("Request Type", ExitRequest."Request Type"::ExitInterview);
        ExitRequest.SetRange("Approval Required", true);
        ExitRequest.ModifyAll("Approval Required", false, true);
    end;
}
