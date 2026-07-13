report 50348 "Trial Balance Summary"
{
    ApplicationArea = All;
    Caption = 'Trial Balance Summary';
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem(GLAccount; "G/L Account")
        {
            column(No; "No.") { }
            column(Name; Name) { }
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName) { }
            }
        }
        actions
        {
            area(processing) { }
        }
    }
}
