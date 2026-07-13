Page 50556 "Internal Auditors"
{
    PageType = List;
    SourceTable = Auditors;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Role; Rec.Role)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Role field.';
                }
                field(AuditProgramme; Rec."Audit Programme")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Audit Programme field.';
                }
                field(AuditNo; Rec."Audit No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Audit No. field.';
                }
                field(DateCreated; Rec."Date Created")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Created field.';
                }
                field(UserID; Rec."User ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the User ID field.';
                }
                field(Department; Rec.Department)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Department field.';
                }
                field(AuditCode; Rec."Audit Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Audit Code field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field(ApprovalComments; Rec."Approval Comments")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Approval Comments field.';
                }
            }
        }
    }

    actions { }
}

