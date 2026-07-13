pageextension 50106 CustomerListExt extends "User Settings"
{
    layout
    {
        modify(UserRoleCenter)
        {
            Visible = AllowChangeRole;
        }
        modify(Company)
        {
            Visible = AllowChangeCompanyName;
        }
        modify("Work Date")
        {
            Visible = AllowChangeWorkDay;
        }
    }
    trigger OnOpenPage();
    var
        UserSetup: Record "User Setup";
        NoPermission: Label 'You do not have permission to open the My Settings page. Please contact your administrator';
    begin
        AllowChangeRole := false;
        AllowChangeCompanyName := false;
        AllowChangeWorkDay := false;
        if UserSetup.Get(UserId) then
            if UserSetup."Allow Open My Settings" then begin
                AllowChangeRole := UserSetup."Allow Change Role";
                AllowChangeCompanyName := UserSetup."Allow Change Company";
                AllowChangeWorkDay := UserSetup."Allow Change Work Day";
                exit;
            end;
        Error(NoPermission);
    end;

    var
        AllowChangeRole: Boolean;
        AllowChangeCompanyName: Boolean;
        AllowChangeWorkDay: Boolean;
}