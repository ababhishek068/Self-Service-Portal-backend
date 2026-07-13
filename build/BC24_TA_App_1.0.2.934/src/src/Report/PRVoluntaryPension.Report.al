Report 50163 "PR Voluntary Pension"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/PRVoluntaryPension.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("HR Employees"; "HR-Employee")
        {
            RequestFilterFields = "No.", "Global Dimension 1 Code", "Payroll Posting Group";
            column(ReportForNavId_1; 1) { }
            column(FullName_HREmployees; "HR Employees"."Full Name") { }
            column(No_HREmployees; "HR Employees"."No.") { }
            column(IDNumber_HREmployees; "HR Employees"."ID Number") { }
            column(Pension_Amount; Pension_Amount) { }
            column(Pension_Scheme; Pension_Scheme) { }
            column(ReportTitle; ReportTitle) { }

            trigger OnAfterGetRecord()
            begin
                //Initialize
                Pension_Amount := 0;
                Pension_Scheme := '';

                //Voluntary Pension
                fnSetrangePRPeriodTransactions;
                PRPeriodTrans.SetFilter(PRPeriodTrans."Transaction Code", '%1|%2', 'D94', 'D15');
                if PRPeriodTrans.FindFirst() then begin
                    Pension_Amount := PRPeriodTrans.Amount;
                    Pension_Scheme := UpperCase(PRPeriodTrans."Transaction Name");
                end;

                if Pension_Amount = 0 then CurrReport.Skip;
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
                field(SelectedPeriod; SelectedPeriod)
                {
                    ApplicationArea = Basic;
                    Caption = 'Payroll Period';
                    TableRelation = "PR Payroll Periods"."Date Opened";
                    ToolTip = 'Specifies the value of the Payroll Period field.';
                }
            }
        }

        actions { }
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
        Pension_Amount: Decimal;
        Pension_Scheme: Text;
        SelectedPeriod: Date;
        PeriodName: Text[30];
        PayrollPeriod: Record "PR Payroll Periods";
        PRPeriodTrans: Record "PR Period Transactions";
        CompInfo: Record "Company Information";
        ReportTitle: Text;
        Text000: label 'VOLUNTARY PENSION CONTRIBUTION - ';

    procedure fnSetrangePRPeriodTransactions()
    begin
        PRPeriodTrans.Reset;
        PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period", SelectedPeriod);
        PRPeriodTrans.SetRange(PRPeriodTrans."Employee Code", "HR Employees"."No.");
    end;

    procedure fnCompanyInfo()
    begin
        CompInfo.Reset;
        if CompInfo.Get() then
            CompInfo.CalcFields(CompInfo.Picture);
    end;
}

