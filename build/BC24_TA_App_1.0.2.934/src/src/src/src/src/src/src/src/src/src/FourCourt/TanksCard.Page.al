page 51401 "Tanks Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Tanks;

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("Tank Code"; Rec."Tank Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tank Code field.';

                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';

                }
                field("Station Code"; Rec."Station Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Station Code field.';

                }
                field("Fuel Type"; Rec."Fuel Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Fuel Type field.';

                }
                field(Capacity; Rec.Capacity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Capacity field.';

                }
                field("Initial Quantity"; Rec."Initial Quantity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Initial Quantity field.';

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