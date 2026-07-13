Report 50156 "PR Master Roll Report"
{
    DefaultLayout = RDLC;
    ApplicationArea = All;

    dataset
    {
        dataitem("PR Period Transactions"; "PR Period Transactions")
        {
            RequestFilterFields = "Employee Code", "Payroll Period";
            column(TransactionCode_PRPeriodTransactions; "PR Period Transactions"."Transaction Code") { }
            column(Amount_PRPeriodTransactions; "PR Period Transactions".Amount) { }
            column(EmployeeCode_PRPeriodTransactions; "PR Period Transactions"."Employee Code") { }
            column(TransactionName_PRPeriodTransactions; "PR Period Transactions"."Transaction Name") { }
            column(PeriodMonth_PRPeriodTransactions; "PR Period Transactions"."Period Month") { }
            column(PeriodYear_PRPeriodTransactions; "PR Period Transactions"."Period Year") { }
            column(GlobalDimension1Code_PRPeriodTransactions; "PR Period Transactions"."Global Dimension 1 Code") { }
            column(GroupOrder_PRPeriodTransactions; "PR Period Transactions"."Group Order") { }
            column(SubGroupOrder_PRPeriodTransactions; "PR Period Transactions"."Sub Group Order") { }
            column(FullName; FullName) { }
            column(RowNum; RowNum) { }
            column(HideDetails; HideDetails) { }

            trigger OnAfterGetRecord()
            begin
                FullName := '';
                RowNum := 0;

                if "PR Period Transactions"."Employee Code" <> "PR Period Transactions"."Employee Code" then RowNum += 1;

                Clear(HREmp);
                HREmp.SetRange(HREmp."No.", "PR Period Transactions"."Employee Code");
                if HREmp.Find('-') then FullName := UpperCase(HREmp."Full Name");
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
                field(HideDetails; HideDetails)
                {
                    ApplicationArea = Basic;
                    Caption = 'Hide Details';
                    ToolTip = 'Specifies the value of the Hide Details field.';
                }
            }
        }

        actions { }
    }

    labels { }

    trigger OnInitReport()
    begin

        if "PR Period Transactions".GetFilter("PR Period Transactions"."Payroll Period") = '' then begin
            PRPayrollPeriods.Reset;
            PRPayrollPeriods.SetRange(PRPayrollPeriods.Closed, false);
            if PRPayrollPeriods.Find('-') then begin
                "PR Period Transactions".SetFilter("PR Period Transactions"."Payroll Period", Format(PRPayrollPeriods."Date Opened"));
            end;
        end;
    end;

    trigger OnPreReport()
    begin
        "PR Period Transactions".SetCurrentkey("PR Period Transactions"."Employee Code", "PR Period Transactions"."Period Month", "PR Period Transactions"."Period Year",
        "PR Period Transactions"."Group Order", "PR Period Transactions"."Sub Group Order");
    end;

    var
        HREmp: Record "HR-Employee";
        FullName: Text;
        RowNum: Integer;
        HideDetails: Boolean;
        PRPayrollPeriods: Record "PR Payroll Periods";
}

