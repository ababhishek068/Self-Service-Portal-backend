page 50918 "Financial Periods"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Financial Periods";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Period Code"; Rec."Period Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Period Code field.';

                }
                field("Period Name"; Rec."Period Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Period Name field.';

                }
                field("Current Period"; Rec."Current Period")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Current Period field.';

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