page 51170 "Academic Classification"
{
    PageType = list;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Academic Classification";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {

                field(Qualification; Rec.Qualification)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Qualification field.';

                }
                field(Classification; Rec.Classification)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Classification field.';

                }

                field(Score; Rec.Score)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Score field.';

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