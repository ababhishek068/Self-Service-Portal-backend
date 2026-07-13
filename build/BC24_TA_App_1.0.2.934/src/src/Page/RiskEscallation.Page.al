page 50674 "Risk Escallation"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Risk Escallation";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(UserID; Rec.UserID)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the UserID field.';

                }
                field(Designation; Rec.Designation)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Designation field.';

                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date field.';

                }
                field("Action Taken"; Rec."Action Taken")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Action Taken field.';

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