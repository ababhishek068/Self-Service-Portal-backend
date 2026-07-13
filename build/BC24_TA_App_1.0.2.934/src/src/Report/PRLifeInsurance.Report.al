Report 50164 "PR Life Insurance"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/PRLifeInsurance.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("PR Transaction Codes"; "PR Transaction Codes")
        {
            DataItemTableView = where("Special Trans Deductions" = const("Life Insurance"));
            column(ReportForNavId_1; 1) { }
            column(TransactionCode_PRTransactionCodes; "PR Transaction Codes"."Transaction Code") { }
            column(TransactionName_PRTransactionCodes; "PR Transaction Codes"."Transaction Name") { }
            column(ReportTitle; ReportTitle) { }
            column(Staff_No; Staff_No) { }
            column(Staff_Name; Staff_Name) { }
            column(Staff_IDNumber; Staff_IDNumber) { }
            column(Policy_No; Policy_No) { }
            column(Amount; Amount) { }
            column(Pension_Scheme; Pension_Scheme) { }

            trigger OnAfterGetRecord()
            begin

                PRPeriodTrans.Reset;
                PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period", SelectedPeriod);
                PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", "PR Transaction Codes"."Transaction Code");
                if PRPeriodTrans.FindFirst() then begin
                    repeat
                        //Initialize
                        Staff_No := '';
                        Staff_Name := '';
                        Staff_IDNumber := '';
                        Policy_No := '';
                        Pension_Scheme := '';
                        Amount := 0;

                        //New Values
                        Staff_No := PRPeriodTrans."Employee Code";

                        Clear(HREmp);
                        HREmp.Get(Staff_No);
                        Staff_Name := UpperCase(HREmp."Full Name");
                        Staff_IDNumber := format(HREmp."ID Number");

                        PREmpTrans.Reset;
                        PREmpTrans.SetRange(PREmpTrans."Employee Code", Staff_No);
                        PREmpTrans.SetRange(PREmpTrans."Payroll Period", SelectedPeriod);
                        PREmpTrans.SetRange(PREmpTrans."Transaction Code", PRPeriodTrans."Transaction Code");
                        if PREmpTrans.FindFirst() then begin
                            Policy_No := PREmpTrans."Transaction Code";
                        end;

                        Amount := PRPeriodTrans.Amount;
                        Pension_Scheme := "PR Transaction Codes"."Transaction Name";

                    until PRPeriodTrans.Next = 0;
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
                group(Control3)
                {
                    Caption = 'Options';
                    field(SelectedPeriod; SelectedPeriod)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Payroll Period';
                        TableRelation = "PR Payroll Periods"."Date Opened";
                        ToolTip = 'Specifies the value of the Payroll Period field.';
                    }
                }
            }
        }

        actions { }

        trigger OnOpenPage()
        begin
            PayrollPeriod.Reset();
            PayrollPeriod.SetRange(Closed, false);
            if PayrollPeriod.FindFirst() then SelectedPeriod := PayrollPeriod."Date Opened";
        end;
    }

    labels { }

    trigger OnPreReport()
    begin



        if SelectedPeriod = 0D then Error('Please select payroll period');

        if ReportTitle = '' then ReportTitle := Text000 + ' ' + Format(SelectedPeriod);

        PayrollPeriod.Reset;
        if PayrollPeriod.Get(SelectedPeriod) then PeriodName := PayrollPeriod."Period Name";
    end;

    var
        SelectedPeriod: Date;
        HREmp: Record "HR-Employee";
        PRPeriodTrans: Record "PR Period Transactions";
        PREmpTrans: Record "PR Employer Deductions";
        CompInfo: Record "Company Information";
        ReportTitle: Text;
        Text000: label 'INSURANCE CONTRIBUTION - ';
        PayrollPeriod: Record "PR Payroll Periods";
        PeriodName: Text;
        Staff_No: Code[30];
        Staff_Name: Text;
        Staff_IDNumber: Text;
        Policy_No: Text;
        Amount: Decimal;
        Pension_Scheme: Text;

    procedure fnSetrangePRPeriodTransactions()
    begin
    end;

    procedure fnCompanyInfo()
    begin
        CompInfo.Reset;
        if CompInfo.Get() then
            CompInfo.CalcFields(CompInfo.Picture);
    end;
}

