page 51061 "Shift Allocation Lines"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Shift Allocation Line";
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {

                field("Staff No"; Rec."Staff No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Staff No field.';

                }
                field("Staff Name"; Rec."Staff Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Staff Name field.';

                }
                field("Pump Code"; Rec."Pump Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Pump Code field.';

                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Remarks field.';

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