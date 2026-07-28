permissionset 52100 "PORTAL EMPLOYEE EXIT"
{
    Assignable = true;
    Caption = 'Portal Employee Exit';

    Permissions =
        tabledata "Portal Employee Exit Request" = RIMD,
        tabledata "Portal Employee Transfer Setup" = RIMD,
        tabledata "Approval Entry" = RIMD,
        tabledata "Tenant Web Service" = RIM,
        table "Portal Employee Exit Request" = X,
        table "Portal Employee Transfer Setup" = X,
        page "Portal Employee Exit Card" = X,
        page "Portal Employee Exit Requests" = X,
        page "Portal Employee Transfer Setup" = X,
        codeunit "Portal Employee Exit Workflow" = X,
        codeunit "Portal Employee Exit Mgt." = X,
        codeunit "Portal Employee Exit Install" = X,
        codeunit "Portal Employee Exit Upgrade" = X,
        codeunit "Portal Employee Data Mgt." = X,
        codeunit "Portal Attachment Mgt." = X;
}
