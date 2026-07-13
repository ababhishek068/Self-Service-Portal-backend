Page 50624 "FLT Officers Going on Safari"
{
    PageType = List;
    SourceTable = "FLT-Safari Accompanying Off.";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(EmployeeNo; Rec."Employee No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Employee No. field.';
                }
                field(EmployeeName; Rec."Employee Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Employee Name field.';
                }
                field(Designation; Rec.Designation)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Designation field.';
                }
                field("Emp. Pin No."; Rec."Emp. Pin No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Emp. Pin No. field.';
                }
                field(Department; Rec.Department)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Department field.';
                }
            }
        }
    }

    actions { }
}

