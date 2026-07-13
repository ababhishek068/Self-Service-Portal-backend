page 50024 "Assembly Progress Status"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Assembly Progress Status";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Assembly Stage"; Rec."Assembly Stage")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Assembly Stage field.';

                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Start Date field.';

                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the End Date field.';

                }
                field("Current Stage"; Rec."Current Stage")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Current Stage field.';

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