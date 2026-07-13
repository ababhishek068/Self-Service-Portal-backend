page 50163 "Audit Meetings"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Audit Meetings";
    CardPageId = "Audit Meetings Card";
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Audit Code"; Rec."Audit Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Audit Code field.';

                }
                field("Audit No."; Rec."Audit No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Audit No. field.';

                }
                field("Audit Programme"; Rec."Audit Programme")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Audit Programme field.';

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