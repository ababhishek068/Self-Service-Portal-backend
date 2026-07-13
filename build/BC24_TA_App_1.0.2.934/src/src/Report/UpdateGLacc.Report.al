
Report 52522 "Update GL acc"
{
    ProcessingOnly = true;
    ApplicationArea = All;

    dataset
    {
        dataitem("G/L Account"; "G/L Account")
        {
            RequestFilterFields = "No.";
            trigger OnAfterGetRecord();
            begin
                "G/L Account"."Account Category" := AccType;
                "G/L Account".Modify;
            end;

            trigger OnPostDataItem();
            begin
                Message('Done');
            end;

        }
    }

    requestpage
    {


        SaveValues = false;
        layout
        {
            area(content)
            {
                field(AccType; AccType)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the AccType field.';
                }
            }
        }

        actions { }
    }

    var
        AccType: Option " ",Assets,Liabilities,Equity,Income,"Cost of Goods Sold",Expense;

}
