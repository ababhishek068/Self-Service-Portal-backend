Report 50006 "PR Company Payslip - II"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/PRCompanyPayslipII.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("PR Period Transactions"; "PR Period Transactions")
        {
            RequestFilterFields = "Transaction Code", "Payroll Period", "Employee Code";
            column(ReportForNavId_1000000000; 1000000000) { }
            column(EmployeeCode_PRPeriodTransactions; "PR Period Transactions"."Employee Code") { }
            column(TransactionCode_PRPeriodTransactions; "PR Period Transactions"."Transaction Code") { }
            column(TransactionName_PRPeriodTransactions; "PR Period Transactions"."Transaction Name") { }
            column(Amount_PRPeriodTransactions; "PR Period Transactions".Amount) { }
            column(SchemeCode_PRPeriodTransactions; "PR Period Transactions"."Global Dimension 1 Code") { }
            column(Balance_PRPeriodTransactions; "PR Period Transactions".Balance) { }
            column(strEmpName; strEmpName) { }
            column(CompInfoName; CompInfo.Name) { }
            column(CompInfoAddress; CompInfo.Address) { }
            column(CompInfoAddress2; CompInfo."Address 2") { }
            column(CompInfoCity; CompInfo.City) { }
            column(CompInfoPicture; CompInfo.Picture) { }
            column(CompInfoEMail; CompInfo."E-Mail") { }
            column(CompInfoHomePage; CompInfo."Home Page") { }
            column(PeriodName; PeriodName) { }
            column(COMPANYNAME; COMPANYNAME) { }
            column(IDNumber; IDNumber) { }
            column(AppliedFilters; AppliedFilters) { }
            column(ReportTitle; ReportTitle) { }
            column(i; i) { }

            trigger OnAfterGetRecord()
            begin
                IDNumber := '';
                strEmpName := '';
                RefNo := '';

                Clear(HREmp);
                if HREmp.Get("PR Period Transactions"."Employee Code") then begin
                    strEmpName := HREmp."Full Name";
                    IDNumber := format(HREmp."ID Number");
                end;


                PREmpTrans.Reset;
                PREmpTrans.SetRange(PREmpTrans."Payroll Period", SelectedPeriod);
                PREmpTrans.SetRange(PREmpTrans."Employee Code", "PR Period Transactions"."Employee Code");
                PREmpTrans.SetRange(PREmpTrans."Transaction Code", "PR Period Transactions"."Transaction Code");
                if PREmpTrans.FindFirst() then begin
                    RefNo := PREmpTrans."Transaction Code";
                end;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout { }

        actions { }
    }

    labels { }

    trigger OnPreReport()
    begin

        fnCompanyInfo;

        SelectedPeriod := "PR Period Transactions".GetRangeMin("Payroll Period");
        PRPayrollPeriods.Reset;
        PRPayrollPeriods.SetRange(PRPayrollPeriods."Date Opened", SelectedPeriod);
        if PRPayrollPeriods.FindFirst() then begin
            PeriodName := PRPayrollPeriods."Period Name"
        end;

        if "PR Period Transactions".GetFilter("PR Period Transactions"."Payroll Period") = '' then begin
            PRPayrollPeriods.Reset;
            PRPayrollPeriods.SetRange(PRPayrollPeriods.Closed, false);
            if PRPayrollPeriods.FindFirst() then begin
                "PR Period Transactions".SetFilter("PR Period Transactions"."Payroll Period", Format(PRPayrollPeriods."Date Opened"));
                SelectedPeriod := PRPayrollPeriods."Date Opened";
            end;
        end else begin
            PRPayrollPeriods.Reset;
            PRPayrollPeriods.SetRange(PRPayrollPeriods.Closed, false);
            if PRPayrollPeriods.FindFirst() then begin
                "PR Period Transactions".SetFilter("PR Period Transactions"."Payroll Period", Format(PRPayrollPeriods."Date Opened"));
                SelectedPeriod := PRPayrollPeriods."Date Opened";
            end;
        end;

        //Save Filters
        if PostingGroup = '' then PostingGroupTxt := 'ALL' else PostingGroupTxt := PostingGroup;

        AppliedFilters := 'Posting Group: ' + PostingGroupTxt + '; Payroll Period: ' + Format(PeriodName) + '; ' + "PR Period Transactions".GetFilters;


        //Report Title
        if "PR Period Transactions".GetFilter("PR Period Transactions"."Transaction Code") = '' then begin
            ReportTitle := UpperCase('Company Payslip Listing - ' + PeriodName);
        end else begin
            PRTransCode.Reset;
            PRTransCode.SetFilter(PRTransCode."Transaction Code", "PR Period Transactions".GetFilter("PR Period Transactions"."Transaction Code"));
            if PRTransCode.FindFirst() then ReportTitle := UpperCase(PRTransCode."Transaction Name");
        end;
    end;

    var
        strEmpName: Text;
        HREmp: Record "HR-Employee";
        CompInfo: Record "Company Information";
        PeriodName: Text[30];
        PRPayrollPeriods: Record "PR Payroll Periods";
        SelectedPeriod: Date;
        IDNumber: Code[50];
        AppliedFilters: Text;
        ReportTitle: Text;
        i: Integer;
        PRTransCode: Record "PR Transaction Codes";
        RefNo: Code[50];
        PREmpTrans: Record "PR Employer Deductions";
        PostingGroup: Code[20];
        PostingGroupTxt: Text;

    procedure fnCompanyInfo()
    begin
        CompInfo.Reset;
        if CompInfo.Get then
            CompInfo.CalcFields(CompInfo.Picture);
    end;
}

