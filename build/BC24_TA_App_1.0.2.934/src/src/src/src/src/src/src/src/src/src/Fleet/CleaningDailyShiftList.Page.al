page 50988 "Cleaning Daily Shift List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Cleaning Daily Shift";
    CardPageId = "Cleaning Daily Shift";
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(No; Rec.No)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No field.';

                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date field.';

                }
                field("Shift Code"; Rec."Shift Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Shift Code field.';

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