page 50961 "Security Daily Shift"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Security Daily Shift";


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
                field("Supervisor Remarks"; Rec."Supervisor Remarks")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Supervisor Remarks field.';

                }
                field("Administration Remarks"; Rec."Administration Remarks")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Administration Remarks field.';

                }
            }
            part(Guards; "Security Guards Register")
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