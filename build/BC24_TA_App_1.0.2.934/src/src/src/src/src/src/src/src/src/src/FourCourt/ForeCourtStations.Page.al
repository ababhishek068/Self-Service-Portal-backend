page 51404 "ForeCourt Stations"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Dimension Value";
    SourceTableView = where("Global Dimension No." = filter(1), "Fore Coart Station" = filter(true));
    DeleteAllowed = false;
    InsertAllowed = false;
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
                field("Mpesa Account"; Rec."Mpesa Account")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Mpesa Account field.';

                }
                field("Cash Account"; Rec."Cash Account")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Cash Account field.';

                }
            }
        }
        area(Factboxes) { }
    }

    actions
    {
        area(Processing)
        {
            action(FuelPrice)
            {
                ApplicationArea = All;
                caption = 'Fuel Price';
                Image = PriceAdjustment;
                RunObject = page "Fuel Branch Pricing";
                RunPageLink = "Branch Code" = field(Code);
                ToolTip = 'Executes the Fuel Price action.';
            }
        }
    }
}