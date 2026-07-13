page 50967 "Security Guards Register"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Security Guards Register";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Guard No"; Rec."Guard No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Guard No field.';

                }
                field("Guard Name"; Rec."Guard Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Guard Name field.';

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
                field("Active Security Company"; Rec."Active Security Company")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Active Security Company field.';
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