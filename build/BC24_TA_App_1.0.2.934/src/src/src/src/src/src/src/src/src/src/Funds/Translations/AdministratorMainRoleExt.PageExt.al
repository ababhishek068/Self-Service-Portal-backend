pageextension 50009 "Administrator Main Role Ext" extends "Administrator Main Role Center"
{
    layout { }

    actions
    {
        addafter("Change Log Setup")
        {
            action(LicenseInfo)
            {
                Caption = 'License Information';
                Image = Agreement;
                ApplicationArea = all;
                RunObject = page "License Info";
                ToolTip = 'Executes the License Information action.';
            }
        }
        addfirst(Navigation)
        {
            group("ICT Help Desk")
            {
                Caption = 'ICT Help Desk';
                action("Help Desk Request")
                {
                    ApplicationArea = basic;
                    RunObject = page "ICT Requisition List";
                    ToolTip = 'Executes the Help Desk Request action.';
                }
                action("Help Desk Categories")
                {
                    ApplicationArea = basic;
                    RunObject = page "ICT Requisition Category";
                    ToolTip = 'Executes the Help Desk Categories action.';
                }
            }
        }
    }
}