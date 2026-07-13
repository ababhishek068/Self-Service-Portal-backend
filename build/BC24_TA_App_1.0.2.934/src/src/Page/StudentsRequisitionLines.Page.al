page 50361 "Students Requisition Lines"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Student Requisition Lines";

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("Application No"; Rec."Application No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Application No field.';

                }
                field("Unit Code"; Rec."Unit Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Unit Code field.';

                }
                field("Unit Title"; Rec."Unit Title")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Unit Title field.';

                }
                field(Reason; Rec."Application No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Application No field.';

                }
                field("Line No"; Rec."Line No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Line No field.';

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