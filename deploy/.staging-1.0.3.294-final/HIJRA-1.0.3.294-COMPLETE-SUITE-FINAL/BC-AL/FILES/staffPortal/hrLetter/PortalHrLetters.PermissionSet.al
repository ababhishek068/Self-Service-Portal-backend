permissionset 52110 "PORTAL HR LETTERS"
{
    Assignable = true;
    Caption = 'Portal HR Letters';

    Permissions =
        tabledata "Portal HR Letter Request" = RIMD,
        tabledata "Tenant Web Service" = RIM,
        table "Portal HR Letter Request" = X,
        page "Portal HR Letter Requests" = X,
        page "Portal HR Letter Request Card" = X,
        codeunit "Portal HR Letters Mgt." = X,
        codeunit "Portal HR Letters Install" = X,
        codeunit "Portal HR Letters Upgrade" = X;
}
