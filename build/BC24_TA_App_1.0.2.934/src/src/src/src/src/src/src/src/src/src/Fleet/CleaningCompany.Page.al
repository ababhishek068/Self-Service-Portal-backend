page 50987 "Cleaning Company"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Cleaning Company";

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
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';

                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Starting Date field.';

                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the End Date field.';

                }
                field(Active; Rec.Active)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Active field.';

                }
            }
            part(Gurds; "Security Guards")
            {
                SubPageLink = "Security Company" = field(No);
            }
        }
        area(Factboxes) { }
    }

    actions
    {
        area(Processing)
        {
            action("Guards")
            {
                ApplicationArea = All;
                Promoted = true;
                image = Resource;
                RunObject = page "Security Guards";
                RunPageLink = "Security Company" = field(No);
                ToolTip = 'Executes the Guards action.';
            }
        }
    }
}