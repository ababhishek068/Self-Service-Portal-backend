permissionset 52122 "PORTAL HR SELF SRV"
{
    Assignable = true;
    Caption = 'Portal HR Self Service';

    Permissions =
        tabledata "Portal Training Assessment" = RIM,
        table "Portal Training Assessment" = X,
        page "Portal Training Assessments" = X,
        codeunit "Portal Training Mgt." = X,
        codeunit "Portal Employee Data Mgt." = X,
        tabledata "Portal HR Letter Request" = RIMD,
        table "Portal HR Letter Request" = X,
        page "Portal HR Letter Requests" = X,
        page "Portal HR Letter Request Card" = X,
        codeunit "Portal HR Letters Mgt." = X,
        codeunit "Portal HR Letters Install" = X,
        codeunit "Portal HR Letters Upgrade" = X;
}
