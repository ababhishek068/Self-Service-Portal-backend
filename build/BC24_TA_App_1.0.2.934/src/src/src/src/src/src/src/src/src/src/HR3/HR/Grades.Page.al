Page 51327 Grades
{
    PageType = Worksheet;
    SourceTable = Grades;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field(Grade; Rec.Grade)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Grade field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(AnnualLeaveDays; Rec."Annual Leave Days")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Annual Leave Days field.';
                }
            }
        }
    }

    actions { }
}

