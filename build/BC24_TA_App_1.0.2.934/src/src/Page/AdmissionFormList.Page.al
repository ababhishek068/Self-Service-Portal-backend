page 50984 "Admission Form List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Admission Form Header";
    SourceTableView = where(Status = filter(New));
    CardPageId = "Admission Form Header PSSP";
    Caption = 'Application List';
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Admission No."; Rec."Admission No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Admission No. field.';

                }
                field(Surname; Rec.Surname)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Surname field.';

                }
                field("Other Names"; Rec."Other Names")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Other Names field.';

                }
                field("Intake Code"; Rec."Intake Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Intake Code field.';

                }
                field("ID Number"; Rec."ID Number")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ID Number field.';

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