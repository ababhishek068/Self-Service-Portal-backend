Report 50169 "PR P.A.Y.E Schedule"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/PRPAYESchedule.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("HR-Employees"; "HR-Employee")
        {
            RequestFilterFields = "No.", "Payroll Posting Group";
            column(ReportForNavId_1; 1) { }
            column(PensionNo_HREmployees; "HR-Employees"."Pension No.") { }
            column(No_HREmployees; "HR-Employees"."No.") { }
            column(FullName_HREmployees; "HR-Employees"."Full Name") { }
            column(IDNumber_HREmployees; "HR-Employees"."ID Number") { }
            column(JobTitle_HREmployees; "HR-Employees"."Job Title") { }
            column(i; i) { }
            column(PayrollPeriod; PayrollPeriod) { }
            column(PINNo_HREmployees; "HR-Employees"."TIN No.") { }
            column(MPRAmount; MPRAmount) { }
            column(INSReleifAmount; INSReleifAmount) { }
            column(PAYEAmount; PAYEAmount) { }
            column(CompInfoName; CompInfo.Name) { }
            column(CompInfoPicture; CompInfo.Picture) { }

            trigger OnAfterGetRecord()
            begin
                MPRAmount := 0;
                INSReleifAmount := 0;
                PAYEAmount := 0;


                //1,162
                PRPeriodTrans.Reset;
                PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period", PayrollPeriod);
                PRPeriodTrans.SetRange(PRPeriodTrans."Employee Code", "HR-Employees"."No.");
                PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", 'PSNR');
                if PRPeriodTrans.FindFirst() then begin
                    MPRAmount := PRPeriodTrans.Amount;
                end;

                //Insurance Relief
                PRPeriodTrans.Reset;
                PRPeriodTrans.SetCurrentkey("Employee Code", "Transaction Code", "Payroll Period");
                PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period", PayrollPeriod);
                PRPeriodTrans.SetRange(PRPeriodTrans."Employee Code", "HR-Employees"."No.");
                PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", 'INSR');
                if PRPeriodTrans.FindFirst() then begin
                    PRPeriodTrans.CalcSums(PRPeriodTrans.Amount);
                    INSReleifAmount := PRPeriodTrans.Amount;
                end;

                //PAYE
                PRPeriodTrans.Reset;
                PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period", PayrollPeriod);
                PRPeriodTrans.SetRange(PRPeriodTrans."Employee Code", "HR-Employees"."No.");
                PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", 'PAYE');
                if PRPeriodTrans.FindFirst() then begin
                    PAYEAmount := PRPeriodTrans.Amount;
                end;

                if MPRAmount + INSReleifAmount + PAYEAmount = 0 then CurrReport.Skip;

                i += 1;
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
                field(PayrollPeriod; PayrollPeriod)
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
        CompInfo.Reset;
        CompInfo.Get;
        CompInfo.CalcFields(CompInfo.Picture);
        if PayrollPeriod = 0D then Error('Please enter payroll period');
    end;

    var
        PayrollPeriod: Date;
        PRPeriodTrans: Record "PR Period Transactions";
        i: Integer;
        MPRAmount: Decimal;
        INSReleifAmount: Decimal;
        PAYEAmount: Decimal;
        CompInfo: Record "Company Information";
}

