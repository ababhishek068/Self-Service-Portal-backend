page 51231 "Registration Qualifications"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Registration Qualifications";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Serial No."; Rec."Service No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Service No. field.';
                }
                field("Subject Code"; Rec."Subject Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Subject Code field.';

                }
                field(Subject; Rec.Subject)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Subject field.';

                }
                field(Grade; Rec.Grade)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Grade field.';

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