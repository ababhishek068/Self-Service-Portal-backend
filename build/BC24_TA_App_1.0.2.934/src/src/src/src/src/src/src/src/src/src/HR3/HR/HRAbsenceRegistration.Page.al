page 51187 "HR Absence Registration"
{
    SourceTable = "HR Employee Absence";
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Employee No. field.';
                }
                field("From Date"; Rec."From Date")
                {
                    ToolTip = 'Specifies the value of the From Date field.';
                }
                field("To Date"; Rec."To Date")
                {
                    ToolTip = 'Specifies the value of the To Date field.';
                }
                field("Cause of Absence Code"; Rec."Cause of Absence Code")
                {
                    ToolTip = 'Specifies the value of the Cause of Absence Code field.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("No of Days"; Rec."No of Days")
                {
                    ToolTip = 'Specifies the value of the No of Days field.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links) { }
            systempart(Control1905767507; Notes) { }
        }
    }
    actions
    {
        area(navigation)
        {
            group("A&bsence")
            {
                action("Co&mments")
                {
                    ToolTip = 'Executes the Co&mments action.';
                }
                separator(Action31) { }
                action("Overview by &Categories")
                {
                    ToolTip = 'Executes the Overview by &Categories action.';
                }
                action("Overview by &Periods")
                {
                    ToolTip = 'Executes the Overview by &Periods action.';
                }
            }
        }
    }
}