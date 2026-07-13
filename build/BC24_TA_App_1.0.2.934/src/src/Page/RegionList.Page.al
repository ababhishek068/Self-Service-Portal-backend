page 50435 "Region List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Dimension Value";
    SourceTableView = where("Global Dimension No." = const(1));
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code for the dimension value.';

                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a descriptive name for the dimension value.';

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
                caption = 'Service Units';
                image = List;
                RunObject = page "Service Units";
                RunPageLink = "Service Region" = field(Code);
                ToolTip = 'Executes the Service Units action.';

            }
        }
    }
}