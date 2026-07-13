page 50287 "Hr Leave Planner Lines"
{
    PageType = ListPart;
    SourceTable = "HR Leave Planner Lines";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Leave Type"; Rec."Leave Type")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Leave Type field.';
                }
                field("Days Applied"; Rec."Days Applied")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Days Applied field.';
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Start Date field.';
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the End Date field.';
                }
                field("Return Date"; Rec."Return Date")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Return Date field.';
                }
                field("Applicant Comments"; Rec."Applicant Comments")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Applicant Comments field.';
                }
                field("Request Leave Allowance"; Rec."Request Leave Allowance")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Request Leave Allowance field.';
                }
                field(Reliever; Rec.Reliever)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Reliever field.';
                }
                field("Reliever Name"; Rec."Reliever Name")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Reliever Name field.';
                }
                field("Approved days"; Rec."Approved days")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Approved days field.';
                }
                field("Date of Exam"; Rec."Date of Exam")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Date of Exam field.';
                }
                field("Details of Examination"; Rec."Details of Examination")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Details of Examination field.';
                }
            }
        }
    }

    actions { }
}
