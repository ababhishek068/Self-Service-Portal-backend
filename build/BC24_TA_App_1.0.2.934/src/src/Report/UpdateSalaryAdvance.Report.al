report 50041 "Update Salary Advance"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem(DataItemName; "PR Salary Card")
        {
            column(Employee_Code; "Employee Code") { }
            trigger OnAfterGetRecord()
            var
                Cust: Record Customer;
                EmpTrans: Record "PR Employee Transactions";
                PayrollPeriod: Record "PR Payroll Periods";
                OpenPeriod: Date;
                TransCode: Record "PR Transaction Codes";
                AdvanceAcnt: code[20];
            begin
                //Get open Period
                PayrollPeriod.Reset();
                IF PayrollPeriod.Closed = false then
                    OpenPeriod := PayrollPeriod."Date Opened";

                //Get Salary Advance Code
                TransCode.reset;
                TransCode.SetRange("Transaction Name", 'Salary Advance');
                if TransCode.Find('-') then
                    AdvanceAcnt := TransCode."Transaction Code";

                Cust.reset;
                cust.SetRange("Account Type", cust."Account Type"::"Salary Advance");
                cust.SetRange("Staff No.", "Employee Code");
                if Cust.Find('-') then begin
                    CUST.CalcFields(Balance);
                    IF Cust.Balance <> 0 THEN begin
                        EmpTrans.Reset();
                        EmpTrans.SetRange("Payroll Period", OpenPeriod);
                        EmpTrans.SetRange("Employee Code", "Employee Code");
                        EmpTrans.SetRange("Transaction Code", AdvanceAcnt);
                        IF EmpTrans.Find('-') THEN DeleteAll();


                        EmpTrans.Init();
                        EmpTrans."Employee Code" := "Employee Code";
                        EmpTrans."Transaction Code" := AdvanceAcnt;
                        EmpTrans."Payroll Period" := OpenPeriod;
                        EmpTrans.Amount := Cust.Balance;
                        EmpTrans."Period Month" := Date2DMY(OpenPeriod, 2);
                        EmpTrans."Period Year" := Date2DMY(OpenPeriod, 3);
                        EmpTrans.Insert();
                    end;

                end;

            end;
        }
    }
}