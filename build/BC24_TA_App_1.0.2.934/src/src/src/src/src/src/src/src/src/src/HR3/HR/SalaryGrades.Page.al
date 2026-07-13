Page 50531 "Sal Grades"
{
    PageType = Card;
    SourceTable = "Sal Grades";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102756000)
            {
                field(SalaryGrade; Rec."Salary Grade")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Salary Grade field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(Basic_salary; Rec.Basic_salary)
                {
                    Caption = 'Basic Salary';
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Basic Salary field.';
                }
                field(SalaryAmount; Rec."Salary Gross Amount")
                {
                    caption = 'Gross Salary';
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Gross Salary field.';
                }
                field("House Allowance"; Rec."House Allowance")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the House Allowance field.';
                }
                field("Travel Allowance"; Rec."Travel Allowance")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Travel Allowance field.';
                }

            }
        }
    }

    actions { }
}

