page 50183 "Lecturers Claim Rates"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Lecturers Claim Rates";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Programme Category"; Rec."Programme Category")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Programme Category field.';

                }
                field("Students Numbers"; Rec."Students Numbers")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Students NUmbers field.';

                }
                field(Rate; Rec.Rate)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Rate field.';

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