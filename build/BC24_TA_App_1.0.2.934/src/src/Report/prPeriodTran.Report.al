report 50012 prPeriodTran
{
    ApplicationArea = All;
    Caption = 'prPeriodTran';
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem(PRPeriodTransactions; "PR Period Transactions")
        {
            RequestFilterFields = "Payroll Period", "Employee Code", "Transaction Code";

            column(EmployeeCode; "Employee Code") { }
            column(Amount; Amount) { }
            column(PayrollPeriod; "Payroll Period") { }
            column(TransactionCode; "Transaction Code") { }
            column(TransactionGroup; "Transaction Group") { }
            column(TransactionName; "Transaction Name") { }

            column(strNames; strNames) { }

            column(Group_Order; "Group Order") { }

            column(Sub_Group_Order; "Sub Group Order") { }

            column(CI_Picture; CI.Picture) { }

            trigger OnAfterGetRecord()
            begin
                objemp.Reset();
                objemp.SetRange(objemp."No.", "Employee Code");
                if objemp.Find('-') then begin
                    strNames := objemp."First Name" + ' ' + objemp."Middle Name" + ' ' + objemp."Last Name";

                end;


            end;
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
    trigger OnPreReport()
    begin
        CI.Get();
        CI.CalcFields(CI.Picture);

    end;

    var
        CI: Record "Company Information";
        objemp: Record "HR-Employee";
        strNames: Text;



}
