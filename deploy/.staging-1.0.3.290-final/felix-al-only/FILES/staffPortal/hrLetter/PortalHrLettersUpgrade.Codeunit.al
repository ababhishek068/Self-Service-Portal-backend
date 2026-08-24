/// <summary>
/// OnInstallAppPerCompany only fires on a first install. Environments that already run an
/// earlier build upgrade instead — so re-run the web service registration on every version
/// change, exactly like the Employee Exit upgrade codeunit does.
/// </summary>
codeunit 52143 "Portal HR Letters Upgrade"
{
    Subtype = Upgrade;
    Permissions = tabledata "Tenant Web Service" = RIM;

    trigger OnUpgradePerCompany()
    var
        HrLettersInstall: Codeunit "Portal HR Letters Install";
    begin
        HrLettersInstall.RegisterAll();
    end;
}
