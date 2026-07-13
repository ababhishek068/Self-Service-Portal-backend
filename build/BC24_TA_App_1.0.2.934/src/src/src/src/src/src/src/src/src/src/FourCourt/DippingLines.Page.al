page 51390 "Dipping Lines"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Dipping Lines";
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Tank Code"; Rec."Tank Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tank Code field.';

                }
                field("Expected Quantity"; Rec."Expected Quantity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Expected Quantity field.';

                }
                field("Actual Quantity"; Rec."Actual Quantity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Actual Quantity field.';

                }
                field("Variance Quantity"; Rec."Variance Quantity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Variance Quantity field.';

                }
                field("Variant Cost"; Rec."Variant Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Variant Cost field.';

                }
                field("Fuel Type"; Rec."Fuel Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Fuel Type field.';

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

                trigger OnAction();
                begin

                end;
            }
        }
    }
}