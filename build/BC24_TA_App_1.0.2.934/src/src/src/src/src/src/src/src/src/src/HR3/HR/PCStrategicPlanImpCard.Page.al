page 50521 "PC Strategic Plan Imp. Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "PC Strategic Plan Imp";
    caption = 'Strategic Plan Implementation Card';

    layout
    {
        area(Content)
        {
            group(General)
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
                field("Workplan No"; Rec."Workplan No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Workplan No field.';

                }
                field("Workplan Activity Code"; Rec."Workplan Activity Code")
                {
                    Caption = 'Workplan Strategic No.';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Workplan Strategic No. field.';

                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';

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
        area(Navigation)
        {
            action(Target)
            {
                Caption = 'Strategic Targets';
                ApplicationArea = All;

                RunObject = page "PC Targets";
                RunPageLink = "Strategic Plan No." = field(No);
                ToolTip = 'Executes the Strategic Targets action.';
            }
        }
    }
}