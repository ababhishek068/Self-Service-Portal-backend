page 50286 "Kin Relationship"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Kin Relationship";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(code; Rec.code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the code field.';

                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';

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