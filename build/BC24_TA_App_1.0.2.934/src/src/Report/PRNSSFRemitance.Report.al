Report 50155 "PR Pension Remitance"
{
    ProcessingOnly = true;
    ApplicationArea = All;

    dataset
    {
        dataitem("HR Employees"; "HR-Employee")
        {
            RequestFilterFields = "No.", "Global Dimension 1 Code", "Payroll Posting Group";
            column(ReportForNavId_1; 1) { }
            column(PensionNo_HREmployees; "HR Employees"."Pension No.") { }
            column(No_HREmployees; "HR Employees"."No.") { }
            column(FullName_HREmployees; "HR Employees"."Full Name") { }
            column(IDNumber_HREmployees; "HR Employees"."ID Number") { }
            column(STDAmount; STDAmount) { }
            column(GROSSAmount; GROSSAmount) { }
            column(VolAmount; VolAmount) { }
            column(Vol_STD_Amount; Vol_STD_Amount) { }
            column(Tot_VolAmount; Tot_VolAmount) { }
            column(Tot_STDAmount; Tot_STDAmount) { }
            column(i; i) { }
            column(CompInfoName; CompInfo.Name) { }
            column(PayrollPeriod; PayrollPeriod) { }
            column(FirstName_HREmployees; "HR Employees"."First Name") { }
            column(MiddleName_HREmployees; "HR Employees"."Middle Name") { }
            column(LastName_HREmployees; "HR Employees"."Last Name") { }
            column(NHIFNo_HREmployees; "HR Employees"."NHIF No.") { }
            column(AppliedFilters; AppliedFilters) { }
            column(PINNo_HREmployees; "HR Employees"."TIN No.") { }
            column(PensionNO; PensionNO) { }

            trigger OnAfterGetRecord()
            begin
                //Initialize
                VolAmount := 0;
                STDAmount := 0;
                Vol_STD_Amount := 0;
                GROSSAmount := 0;
                PensionNO := '20177062';

                //Standard Amount
                PRPeriodTrans.Reset;
                PRPeriodTrans.SetRange(PRPeriodTrans."Employee Code", "HR Employees"."No.");
                PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period", PayrollPeriod);
                PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", 'Pension');
                if PRPeriodTrans.FindFirst() then begin
                    STDAmount := PRPeriodTrans.Amount * 2;
                end;


                //Voluntary Amount
                PRPeriodTrans.Reset;
                PRPeriodTrans.SetRange(PRPeriodTrans."Employee Code", "HR Employees"."No.");
                PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period", PayrollPeriod);
                PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", 'D74');  //Voluntary Pension Code here
                if PRPeriodTrans.FindFirst() then begin
                    VolAmount := PRPeriodTrans.Amount;
                end;


                //Gross Amount
                PRPeriodTrans.Reset;
                PRPeriodTrans.SetRange(PRPeriodTrans."Employee Code", "HR Employees"."No.");
                PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period", PayrollPeriod);
                PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", 'GPAY');
                if PRPeriodTrans.FindFirst() then begin
                    GROSSAmount := PRPeriodTrans.Amount;
                end;

                //Vol + Standard
                //Vol_STD_Amount:=STDAmount + VolAmount;

                Tot_VolAmount += VolAmount;
                Tot_STDAmount += STDAmount;
                //Tot_Vol_STD_Amount +=Vol_STD_Amount;
                //Grand Totals
                if (STDAmount = 0) and (VolAmount = 0) then CurrReport.Skip;

                i += 1;
            end;

            trigger OnPreDataItem()
            begin
                Tot_VolAmount := 0;
                Tot_STDAmount := 0;
                Tot_Vol_STD_Amount := 0;
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

        if PayrollPeriod = 0D then Error('Please enter payroll period');

        //AppliedFilters
        if "HR Employees".GetFilters = '' then begin
            AppliedFilters := '';
        end else begin
            AppliedFilters := 'APPLIED FILTERS(s) ' + "HR Employees".GetFilters;
        end;
    end;

    var
        CompInfo: Record "Company Information";
        PayrollPeriod: Date;
        STDAmount: Decimal;
        VolAmount: Decimal;
        Tot_VolAmount: Decimal;
        Tot_STDAmount: Decimal;
        Tot_Vol_STD_Amount: Decimal;
        PRPeriodTrans: Record "PR Period Transactions";
        i: Integer;
        AppliedFilters: Text;
        Vol_STD_Amount: Decimal;
        GROSSAmount: Decimal;
        PensionNO: Code[30];
}

