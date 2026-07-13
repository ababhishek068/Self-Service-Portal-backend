report 50037 "Dipping Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem(DataItemName; "Dipping Header")

        {
            column(No; No) { }
            column(Date; Date) { }
            column(Station_Code; "Station Code") { }
            column(Dipping_Time; "Dipping Time") { }
            column(Description; Description) { }
            column(Posted; Posted) { }
            column(Posted_By; "Posted By") { }
            column(Posting_Date; "Posting Date") { }
            dataitem("Dipping Lines"; "Dipping Lines")
            {
                DataItemLink = no = field(no);
                column(Tank_Code; "Tank Code") { }
                column(Expected_Quantity; "Expected Quantity") { }
                column(Actual_Quantity; "Actual Quantity") { }
                column(Variance_Quantity; "Variance Quantity") { }
                column(Fuel_Type; "Fuel Type") { }
                column(Unit_Cost; "Unit Cost") { }
                column(Variant_Cost; "Variant Cost") { }
            }

        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName) { }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;
                    ToolTip = 'Executes the ActionName action.';

                }
            }
        }
    }
}