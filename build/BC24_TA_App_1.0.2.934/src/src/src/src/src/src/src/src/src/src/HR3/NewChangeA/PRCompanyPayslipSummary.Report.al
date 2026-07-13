Report 50167 "PR Company Payslip Summary"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/PRCompanyPayslip.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("PR Transaction Codes"; "PR Transaction Codes")
        {
            RequestFilterFields = "Transaction Type", "Transaction Code";

            column(ReportForNavId_1; 1) { }
            column(TransactionCode_PRTransactionCodes; "PR Transaction Codes"."Transaction Code") { }
            column(HideStaffCount; HideStaffCount) { }
            column(TransactionName_PRTransactionCodes; "PR Transaction Codes"."Transaction Name") { }
            column(TransactionType_PRTransactionCodes; "PR Transaction Codes"."Transaction Type") { }
            column(Amount; Amount) { }
            column(PeriodFilter; PeriodFilter) { }
            column(CompInfoName; CompInfo.Name) { }
            column(CompInfoAddress; CompInfo.Address) { }
            column(CompInfoAddress2; CompInfo."Address 2") { }
            column(CompInfoCity; CompInfo.City) { }
            column(CompInfoPicture; CompInfo.Picture) { }
            column(CompInfoEMail; CompInfo."E-Mail") { }
            column(CompInfoHomePage; CompInfo."Home Page") { }
            column(PeriodName; PeriodName) { }
            column(COMPANYNAME; COMPANYNAME) { }
            column(AppliedFilters; AppliedFilters) { }
            column(Cur_PNAME; Cur_PNAME) { }
            column(Cur_No_Assigned; Cur_No_Assigned) { }
            column(TotalEarnings; TotalEarnings) { }
            column(TotalDeductions; TotalDeductions) { }
            column(NetSalaryAmnt; NetSalaryAmnt) { }
            column(NumberOfStaff; NumberOfStaff) { }
            column(Group_Code; "Group Code") { }

            trigger OnAfterGetRecord()
            begin
                //Initialize
                Amount := 0;

                //Selected Period
                fn_SR_PeriodTrans;
                if PRPeriodTrans.FindFirst() then begin
                    Cur_No_Assigned := PRPeriodTrans.Count();
                    PRPeriodTrans.CalcSums(PRPeriodTrans.Amount);
                    Amount := PRPeriodTrans.Amount;
                end;

                //   if Amount = 0 then CurrReport.Skip();
            end;

            trigger OnPreDataItem()
            begin
                Clear(TotalDeductions);
                Clear(TotalEarnings);

                PRTransCodes.Reset();
                PRTransCodes.SetRange("Transaction Type", PRTransCodes."transaction type"::Income);
                if PRTransCodes.FindSet(false, false) then begin
                    repeat
                        PRPeriodTrans.Reset;
                        PRPeriodTrans.SetCurrentkey("Employee Code", "Transaction Code", "Payroll Period");
                        PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", PRTransCodes."Transaction Code");
                        PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period", PeriodFilter);
                        if PostingGroup <> '' then PRPeriodTrans.SetRange("Posting Group", PostingGroup);
                        if PRPeriodTrans.FindFirst() then begin
                            PRPeriodTrans.CalcSums(PRPeriodTrans.Amount);
                            TotalEarnings += PRPeriodTrans.Amount;
                        end;

                    until PRTransCodes.Next() = 0;
                end;

                PRTransCodes.Reset();
                PRTransCodes.SetRange("Transaction Type", PRTransCodes."transaction type"::Deduction);
                if PRTransCodes.FindSet(false, false) then begin
                    repeat
                        PRPeriodTrans.Reset;
                        PRPeriodTrans.SetCurrentkey("Employee Code", "Transaction Code", "Payroll Period");
                        PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", PRTransCodes."Transaction Code");
                        PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period", PeriodFilter);
                        if PostingGroup <> '' then PRPeriodTrans.SetRange("Posting Group", PostingGroup);
                        if PRPeriodTrans.FindFirst() then begin
                            PRPeriodTrans.CalcSums(PRPeriodTrans.Amount);
                            TotalDeductions += PRPeriodTrans.Amount;
                        end;

                    until PRTransCodes.Next() = 0;
                end;


                PRPeriodTrans.Reset;
                PRPeriodTrans.SetCurrentkey("Employee Code", "Transaction Code", "Payroll Period");
                PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", 'NPAY');
                PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period", PeriodFilter);
                if PostingGroup <> '' then PRPeriodTrans.SetRange("Posting Group", PostingGroup);
                if PRPeriodTrans.FindSet(false, false) then begin
                    NumberOfStaff := PRPeriodTrans.Count();
                end;


                NetSalaryAmnt := TotalEarnings - TotalDeductions;
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
                        Caption = 'Current Period Filter';
                        TableRelation = "PR Payroll Periods";
                        ToolTip = 'Specifies the value of the Current Period Filter field.';
                    }
                    field(PostingGroup; PostingGroup)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Posting Group';
                        TableRelation = "PR Employee Posting Groups".Code;
                        ToolTip = 'Specifies the value of the Posting Group field.';
                    }

                    // field(HideStaffCount; HideStaffCount)
                    // {
                    //     ApplicationArea = basic;
                    //     caption = 'Hide Staff Count';
                    // }
                    field(PreviousPaymentSystem; PreviousPaymentSystem)
                    {
                        ApplicationArea = basic;
                        caption = 'Previous Payment System';
                        TableRelation = "HR Lookup Values".code where(Type = const("Previous Payment System"));
                        ToolTip = 'Specifies the value of the Previous Payment System field.';

                    }

                }
            }
        }

        actions { }

        trigger OnOpenPage()
        begin
            PRPayrollPeriods.Reset();
            PRPayrollPeriods.SetRange(Closed, false);
            if PRPayrollPeriods.FindFirst() then PeriodFilter := PRPayrollPeriods."Date Opened";
        end;
    }

    labels { }

    trigger OnPreReport()
    begin
        CompInfo.Reset();
        if CompInfo.Get() then CompInfo.CalcFields(Picture);


        PRPayrollPeriods.Reset;
        PRPayrollPeriods.SetRange(PRPayrollPeriods."Date Opened", PeriodFilter);
        if PRPayrollPeriods.FindFirst() then Cur_PNAME := PRPayrollPeriods."Period Name";

        //Save Filters
        if PostingGroup = '' then PostingGroupTxt := 'ALL' else PostingGroupTxt := PostingGroup;

        AppliedFilters := 'Posting Group: ' + PostingGroupTxt + '; Payroll Period: ' + Format(Cur_PNAME) + "PR Transaction Codes".GetFilters;

        //Company Info
        fnCompanyInfo;
    end;

    var
        PRPeriodTrans: Record "PR Period Transactions";
        PeriodFilter: Date;

        HideStaffCount: Boolean;

        PreviousPaymentSystem: Code[20];
        Amount: Decimal;
        CompInfo: Record "Company Information";
        PeriodName: Text[30];
        PRPayrollPeriods: Record "PR Payroll Periods";
        AppliedFilters: Text;
        Cur_PNAME: Text;
        PostingGroup: Code[20];
        PostingGroupTxt: Text;
        Cur_No_Assigned: Integer;
        PRTransCodes: Record "PR Transaction Codes";
        TotalEarnings: Decimal;
        TotalDeductions: Decimal;
        NetSalaryAmnt: Decimal;
        NumberOfStaff: Integer;

    procedure fnCompanyInfo()
    begin
        CompInfo.Reset;
        if CompInfo.Get then
            CompInfo.CalcFields(CompInfo.Picture);
    end;

    local procedure fn_SR_PeriodTrans()
    begin
        PRPeriodTrans.Reset;
        PRPeriodTrans.SetCurrentkey("Employee Code", "Transaction Code", "Payroll Period");
        PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", "PR Transaction Codes"."Transaction Code");
        PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period", PeriodFilter);

        if PostingGroup <> '' then PRPeriodTrans.SetRange("Posting Group", PostingGroup);

        if "PreviousPaymentSystem" <> '' then PRPeriodTrans.SetRange("Previous Payment System", PreviousPaymentSystem);
    end;


}