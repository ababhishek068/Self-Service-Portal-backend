Report 50017 "Match Bank Entries2"
{
    Caption = 'Match Bank Entries2';
    ProcessingOnly = true;
    ApplicationArea = All;


    dataset
    {
        dataitem("Bank Acc. Reconciliation"; "Bank Acc. Reconciliation")
        {
            DataItemTableView = sorting("Bank Account No.", "Statement No.");
            column(ReportForNavId_1; 1) { }

            trigger OnAfterGetRecord()
            begin
                MatchSingle2(DateRange);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Control3)
                {
                    field(DateRange; DateRange)
                    {
                        ApplicationArea = Basic;
                        BlankZero = true;
                        Caption = 'Transaction Date Tolerance (Days)';
                        MinValue = 0;
                        ToolTip = 'Specifies the value of the Transaction Date Tolerance (Days) field.';
                    }
                }
            }
        }

        actions { }
    }

    labels { }

    var
        DateRange: Integer;
}

