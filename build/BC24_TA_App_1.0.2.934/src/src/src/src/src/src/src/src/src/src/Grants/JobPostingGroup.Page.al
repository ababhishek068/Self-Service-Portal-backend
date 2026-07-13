page 51037 "Job-Posting Group"
{
    PageType = List;

    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Job-Posting Group";

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
                field("G/L Expense Acc. (Contract)"; Rec."G/L Expense Acc. (Contract)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the G/L Expense Acc. (Contract) field.';

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