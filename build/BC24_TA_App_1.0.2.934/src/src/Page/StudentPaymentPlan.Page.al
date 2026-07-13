page 50346 "Student Payment Plan"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Student Payment Plan";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Student No"; Rec."Student No")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Student No field.';

                }
                field(Semester; Rec.Semester)
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Semester field.';

                }
                field("Installment No"; Rec."Installment No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Installment No field.';

                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Due Date field.';

                }
                field("Installment Percentage"; Rec."Installment Percentage")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Installment Percentage field.';

                }
                field("Expected Payment"; Rec."Expected Payment")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Expected Payment field.';

                }
                field(Penalized; Rec.Penalized)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Penalized field.';

                }
                field(Defaulted; Rec.Defaulted)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Defaulted field.';

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