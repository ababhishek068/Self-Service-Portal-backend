page 50660 "PC Strategic Plan Imp."
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "PC Strategic Plan Imp";
    CardPageId = "PC Strategic Plan Imp. Card";
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(No; Rec.No)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No field.';

                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Type field.';

                }
                field(Objectives; Rec.Objectives)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Objectives field.';

                }
                field(Strategies; Rec.Strategies)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Strategies field.';

                }
                field(Activities; Rec.Activities)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Activities field.';

                }
                field("Expected Outputs"; Rec."Expected Outputs")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Expected Outputs field.';

                }
                field("Performance Indicators"; Rec."Performance Indicators")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Performance Indicators field.';

                }
                field("Baseline Value"; Rec."Baseline Value")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Baseline Value field.';

                }
                field("Overall Target"; Rec."Overall Target")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Overall Target field.';

                }
                field("Annual Targets"; Rec."Annual Targets")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Annual Targets field.';

                }
                field("Time – Line"; Rec."Time – Line")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Time – Line field.';

                }
                field("Annual Budgets"; Rec."Annual Budgets")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Annual Budgets field.';

                }
                field("Overall Budget"; Rec."Overall Budget")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Overall Budget field.';

                }
                field("Action By"; Rec."Action By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Action By field.';

                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;
                ToolTip = 'Executes the ActionName action.';

                trigger OnAction()
                begin

                end;
            }
        }
    }
}