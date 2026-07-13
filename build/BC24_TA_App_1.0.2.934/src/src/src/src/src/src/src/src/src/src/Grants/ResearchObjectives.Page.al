page 50465 "Research Objectives"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Research Objectives";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Research Area"; Rec."Research Area")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Research Area field.';

                }
                field(Objective; Rec.Objective)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Objective field.';

                }
                field("Measure Indicator"; Rec."Measure Indicator")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Measure Indicator field.';

                }
                field("Research Results"; Rec."Research Results")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Research Results field.';

                }
            }
        }
        area(Factboxes) { }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;
                ToolTip = 'Executes the ActionName action.';

                trigger OnAction();
                begin

                end;
            }
        }
    }
}