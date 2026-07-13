Page 51007 "Un-affected Salary Increaments"
{
    Editable = false;
    PageType = List;
    SourceTable = "Un-affected Salary Increaments";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(IncreamentMonth; Rec."Increament Month")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Increament Month field.';
                }
                field(IncreamentYear; Rec."Increament Year")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Increament Year field.';
                }
                field(EmployeeNo; Rec."Employee No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Employee No. field.';
                }
                field(EmployeeCategory; Rec."Employee Category")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Employee Category field.';
                }
                field(EmployeeGrade; Rec."Employee Grade")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Employee Grade field.';
                }
                field(Reason; Rec.Reason)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Reason field.';
                }
            }
        }
    }

    actions { }
}

