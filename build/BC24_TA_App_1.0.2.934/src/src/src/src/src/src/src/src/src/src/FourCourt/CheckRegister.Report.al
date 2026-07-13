report 50036 "Check Register"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem(DataItemName; "Bank Account Ledger Entry")
        {
            column(Bank_Account_No_; "Bank Account No.") { }
            column(External_Document_No_; "External Document No.") { }
            column(Posting_Date; "Posting Date") { }
            column(Description; Description) { }
            column(Amount; Amount) { }
            column(BankName; BankName) { }
            column(CompInfLogo; CompInf.Picture) { }
            column(CompInfName; CompInf.Name) { }

            trigger OnAfterGetRecord()
            begin
                IF Banks.Get("Bank Account No.") THEN
                    BankName := Banks.Name;
            end;



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
    trigger OnPreReport()
    begin
        CompInf.get();
        CompInf.CalcFields(Picture);
    end;


    var
        BankName: text[100];
        Banks: Record "Bank Account";
        CompInf: Record "Company Information";
}