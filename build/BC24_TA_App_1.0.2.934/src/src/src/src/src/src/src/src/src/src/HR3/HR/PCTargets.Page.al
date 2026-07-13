page 50661 "PC Targets"
{
    PageType = list;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "PC Targets";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Quarterly Target"; Rec."Quarterly Target")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Quarterly Target field.';

                }
                field("Actual achieved"; Rec."Actual achieved")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Actual achieved field.';

                }
                field("Cumulative Target"; Rec."Cumulative Target")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Cumulative Target field.';

                }
                field("Cumulative Actual"; Rec."Cumulative Actual")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Cumulative Actual field.';

                }
                field(Variance; Rec.Variance)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Variance field.';

                }
                field("Comments on variance"; Rec."Comments on variance")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Comments on variance field.';

                }
                field("action taken"; Rec."action taken")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the action taken field.';

                }
                field("Risk Mitigation"; Rec."Risk Mitigation")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Risk Mitigation field.';

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