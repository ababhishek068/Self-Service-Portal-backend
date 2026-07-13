Page 50943 "Project Personnel Cost Alloc"
{
    DelayedInsert = true;
    PageType = Card;
    SourceTable = "Project Personnel Cost Alloc";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                field(EmployeeNo; Rec."Employee No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Employee No field.';
                }
                field(EmployeeName; Rec."Employee Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Employee Name field.';
                }
                field(ProjectRole; Rec."Project Role")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Project Role field.';
                }
                field(StartDate; Rec."Start Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Start Date field.';
                }
                field(EndDate; Rec."End Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the End Date field.';
                }
                field(comment; Rec.comment)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the comment field.';
                }
                field(AllocationValue; Rec."% Allocation Value")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the % Allocation Value field.';
                }
            }
        }
    }

    actions { }
}

