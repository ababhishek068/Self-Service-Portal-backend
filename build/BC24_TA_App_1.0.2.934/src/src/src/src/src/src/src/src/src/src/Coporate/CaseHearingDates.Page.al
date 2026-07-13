page 50515 "Case Hearing Dates"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Case Hearing";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Hearing Date"; Rec."Hearing Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Hearing Date field.';

                }
                field("Court Remarks"; Rec."Court Remarks")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Court Remarks field.';

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