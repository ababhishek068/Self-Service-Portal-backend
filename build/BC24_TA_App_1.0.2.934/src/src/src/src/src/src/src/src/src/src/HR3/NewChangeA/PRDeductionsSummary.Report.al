report 50178 "PR Deductions Summary"
{
    ApplicationArea = All;
    dataset
    {
        dataitem("PR Trans Codes Groups"; "PR Trans Codes Groups")
        {
            column(GroupCode; "Group Code") { }
            column(GroupDescription; "Group Description") { }

            column(CurrAmount; CurrAmount) { }
            column(PeriodFilter; PeriodFilter) { }
            column(CompInfoName; CompInfo.Name) { }
            column(CompInfoAddress; CompInfo.Address) { }
            column(CompInfoAddress2; CompInfo."Address 2") { }
            column(CompInfoCity; CompInfo.City) { }
            column(CompInfoPicture; CompInfo.Picture) { }
            column(CompInfoEMail; CompInfo."E-Mail") { }
            column(CompInfoHomePage; CompInfo."Home Page") { }
            column(Cur_PNAME; Cur_PNAME) { }
            trigger OnPreDataItem()
            begin

            end;

            trigger OnAfterGetRecord()
            begin
                Clear(CurrAmount);

                PRTransCode.Reset();
                PRTransCode.SetRange("Group Code", "PR Trans Codes Groups"."Group Code");
                if PRTransCode.FindSet(false, false) then begin
                    repeat
                        PRPeriodTransactions.Reset();
                        PRPeriodTransactions.SetCurrentKey("Employee Code", "Transaction Code", "Period Month", "Period Year", "Reference No");
                        PRPeriodTransactions.SetRange("Transaction Code", PRTransCode."Transaction Code");
                        PRPeriodTransactions.SetRange("Payroll Period", PeriodFilter);
                        if PRPeriodTransactions.FindSet(false, false) then begin
                            PRPeriodTransactions.CalcSums(Amount);
                            CurrAmount += PRPeriodTransactions.Amount;
                        end;
                    until PRTransCode.Next() = 0;
                end;
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
                group(Options)
                {
                    Caption = 'Options';

                    field(PeriodFilter; PeriodFilter)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Period Filter';
                        TableRelation = "PR Payroll Periods";
                        ToolTip = 'Specifies the value of the Period Filter field.';
                    }
                }

            }
        }
        actions
        {
            area(processing) { }
        }
    }
    trigger OnPreReport()
    begin
        CompInfo.Reset();
        if CompInfo.Get() then CompInfo.CalcFields(Picture);


        PRPayrollPeriods.Reset;
        PRPayrollPeriods.SetRange(PRPayrollPeriods."Date Opened", PeriodFilter);
        if PRPayrollPeriods.FindFirst() then Cur_PNAME := PRPayrollPeriods."Period Name"
    end;



    var
        PRPeriodTransactions: Record "PR Period Transactions";
        Cur_PNAME: text;
        PRTransCode: Record "PR Transaction Codes";
        PeriodFilter: Date;
        CurrAmount: Decimal;
        CompInfo: Record "Company Information";
        PRPayrollPeriods: Record "PR Payroll Periods";
}
