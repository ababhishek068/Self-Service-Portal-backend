page 50359 "Training Attendance Lines"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Training Attendance Lines";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Serial No"; Rec."Serial No")
                {
                    Caption = 'P/NO';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the P/NO field.';

                }
                field(Names; Rec.Names)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Names field.';

                }
                field("Grade Attained"; Rec."Grade Attained")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Grade Attained field.';

                }
                field("Certificate No."; Rec."Certificate No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Certificate No. field.';

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