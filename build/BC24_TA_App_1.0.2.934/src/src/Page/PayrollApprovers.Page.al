page 50302 "Payroll Approvers"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Payroll Approvers";

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
                field(Names; Rec.Names)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Names field.';

                }
                field("Approval Title"; Rec."Approval Title")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Approval Title field.';

                }
                field("Sequence No"; Rec."Sequence No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sequence No field.';

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