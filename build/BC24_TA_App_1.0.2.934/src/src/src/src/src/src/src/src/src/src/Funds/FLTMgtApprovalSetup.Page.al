Page 50629 "FLT Mgt Approval Setup"
{
    CardPageID = "FLT Mgt Approval Setup Card";
    ModifyAllowed = true;
    PageType = List;
    SourceTable = "Flt Mgt Approval Setups";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(UserID; Rec.UserID)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the UserID field.';
                }
                field(FleetManagementArea; Rec."Fleet Management Area")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Fleet Management Area field.';
                }
                field(Create; Rec.Create)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Create field.';
                }
                field(LineManagerApprover; Rec."Line Manager Approver")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Line Manager Approver field.';
                }
                field(TransportMgerApprover; Rec."Transport Mger Approver")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Transport Mger Approver field.';
                }
                field(SafariNoticeApprover; Rec."Safari Notice Approver")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Safari Notice Approver field.';
                }
                field(FinanceApprover; Rec."Finance Approver")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Finance Approver field.';
                }
                field(ISDirector; Rec."IS Director")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the IS Director field.';
                }
                field(ISHRM; Rec."IS HRM")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the IS HRM field.';
                }
                field(IsDeputyDirector; Rec."Is Deputy Director")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Is Deputy Director field.';
                }
                field(ViewOnlyDepartment; Rec."View Only Department")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the View Only Department field.';
                }
                field(UserDepartment; Rec."User Department")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the User Department field.';
                }
            }
        }
    }

    actions { }
}

