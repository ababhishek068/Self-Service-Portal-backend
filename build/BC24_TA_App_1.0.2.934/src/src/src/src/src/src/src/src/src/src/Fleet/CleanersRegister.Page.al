page 50991 "Cleaners Register"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Cleaners Register";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Cleaner No"; Rec."Cleaner No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Cleaner No field.';

                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Name field.';

                }
                field("Allocated Section"; Rec."Allocated Section")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Allocated Section field.';

                }
                field(Supervisor; Rec.Supervisor)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Supervisor field.';
                }
                field("Active Security Company"; Rec."Active Cleaning Company")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Active Cleaning Company field.';
                }
                field("Time In"; Rec."Time In")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Time In field.';
                }
                field("Time Out"; Rec."Time Out")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Time Out field.';
                }
                field(Closed; Rec.Closed)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Closed field.';
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