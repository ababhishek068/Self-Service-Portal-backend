Report 50152 "PR Bank Summary"
{
    DefaultLayout = RDLC;
    ApplicationArea = All;

    dataset
    {
        dataitem("HR Bank Summary"; "HR Bank Summary")
        {
            CalcFields = "Bank Type";

            RequestFilterFields = "Payroll Period", "Posting Group", "Bank Type", "Bank Code";
            column(ReportForNavId_1; 1) { }
            column(BankCode_HRBankSummary; "HR Bank Summary"."Bank Code") { }
            column(Bank_and_Branch_Code; "Bank and Branch Code") { }
            column(Line_No_; "Line No.") { }
            column(StaffNo_HRBankSummary; "HR Bank Summary"."No.") { }
            column(StaffBankName_HRBankSummary; "HR Bank Summary"."Staff Bank Name") { }

            column(Bank_Type; "Bank Type") { }
            column(BranchCode_HRBankSummary; "HR Bank Summary"."Branch Code") { }

            column(Bank_Name; "Bank Name") { }

            column(Branch_Name; "Branch Name") { }
            column(PayrollPeriod_HRBankSummary; "HR Bank Summary"."Payroll Period") { }
            column(ACNumber_HRBankSummary; "HR Bank Summary"."A/C Number") { }
            column(Amount_HRBankSummary; "HR Bank Summary".Amount) { }
            column(PeriodName; PeriodName) { }
            column(Cur_PNAME; Cur_PNAME) { }
            column(DebitValueDate; DebitValueDate) { }
            column(StaffName; StaffName) { }

            column(RownNum; RownNum) { }

            trigger OnAfterGetRecord()
            begin
                Num += 1;
                RownNum += 1;
                HREmp.reset;
                IF HREmp.Get("No.") then begin
                    StaffName := HREmp."First Name" + ' ' + HREmp."Middle Name" + ' ' + HREmp."Last Name"
                end;
            end;

            trigger OnPreDataItem()
            begin
                if PeriodFilter = '' then "HR Bank Summary".SetFilter("HR Bank Summary"."Payroll Period", PeriodFilter);

                if "HR Bank Summary".Amount = 0 then
                    CurrReport.Skip;


                //ROUND("HR Bank Summary".Amount,1'>');
            end;
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }

    trigger OnPreReport()
    begin
        PeriodFilter := "HR Bank Summary".GetFilter("HR Bank Summary"."Payroll Period");
        DebitValueDate := '';
        RownNum := 0;

        //if "HR Bank Summary".GetFilter("HR Bank Summary"."Bank Type") = '' then Error('Please select Bank Type');

        if PeriodFilter = '' then begin
            PRPayrollPeriods.Reset;
            PRPayrollPeriods.SetRange(PRPayrollPeriods.Closed, false);
            if PRPayrollPeriods.Find('-') then begin
                Cur_PNAME := PRPayrollPeriods."Period Name";
            end;
        end else begin
            PRPayrollPeriods.Reset;
            PRPayrollPeriods.SetRange(PRPayrollPeriods.Closed, false);
            if PRPayrollPeriods.Find('-') then begin
                Cur_PNAME := PRPayrollPeriods."Period Name";
            end;
        end;

        DebitValueDate := Format(Date2dmy(Today, 3)); //Year 12-05-88
        DebitValueDate += Format(Date2dmy(Today, 2)); //Month
        DebitValueDate += Format(Date2dmy(Today, 1)); //Day
    end;

    var
        Num: Decimal;
        StaffName: Text;
        HREmp: Record "HR-Employee";
        PeriodName: Text;
        Cur_PNAME: Text;
        PeriodFilter: Text;
        PRPayrollPeriods: Record "PR Payroll Periods";
        DebitValueDate: Text;

        RownNum: integer;
}

