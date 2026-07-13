page 51022 "Estate Houses"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Estate Houses";

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Code field.';

                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';

                }
                field("Occupant Employee No"; Rec."Occupant Employee No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Occupant Employee No field.';

                }
                field("Outsider Name"; Rec."Outsider Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Outsider Name field.';

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