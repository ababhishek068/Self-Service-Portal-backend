Page 50939 "Leave Family Employees"
{
    PageType = ListPart;
    SourceTable = "Leave Family Employees";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field(EmployeeNo; Rec."Employee No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Employee No field.';
                }
                field(Names; Employee."First Name" + ' ' + Employee."Middle Name" + ' ' + Employee."Last Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Names';
                    ToolTip = 'Specifies the value of the Names field.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
            }
        }
    }

    actions { }

    var
        Employee: Record "HR-Employee";
}

