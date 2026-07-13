page 50990 "Cleaning Daily Shift"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Cleaning Daily Shift";


    layout
    {
        area(Content)
        {
            group(GroupName)
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
            part(Guards; "Cleaners Register")
            {
                SubPageLink = "Shift Code" = field("Shift Code");
            }

        }
    }

    actions
    {
        area(Processing)
        {
            action(Guards)
            {
                ApplicationArea = All;
                Promoted = true;
                Image = ResourceGroup;
                RunObject = page "Security Guards Register";
                RunPageLink = Date = field(Date), "Shift Code" = field("Shift Code");
                ToolTip = 'Executes the Guards action.';
            }
        }
    }
}