page 50186 "Staff Clearance Setup"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "User Setup";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the ID of the user who posted the entry, to be used, for example, in the change log.';

                }

                field("Can Clear Finance"; Rec."Can Clear Finance")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Can Clear Finance field.';

                }
                field("Can Clear Store"; Rec."Can Clear Store")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Can Clear Store field.';

                }
                field("Can Clear Footwear section"; Rec."Can Clear Footwear section")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Can Clear Footwear section field.';

                }
                field("Can Clear Laboratory"; Rec."Can Clear Laboratory")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Can Clear Laboratory field.';

                }
                field("Can Clear Human Resource"; Rec."Can Clear Human Resource")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Can Clear Human Resource field.';

                }
                field("Can Clear Leather section"; Rec."Can Clear Leather section")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Can Clear Leather section field.';

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