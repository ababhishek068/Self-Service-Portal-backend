

Report 50183 "PR Pension Remitance2"
{
    RDLCLayout = './Layouts/PRPensionRemitance.rdlc';
    DefaultLayout = RDLC;
    ApplicationArea = All;

    dataset
    {
        dataitem("HR-Employee"; "HR-Employee")
        {
            RequestFilterFields = "No.", "Global Dimension 1 Code", "Posting Group";
            column(PensionNo_HREmployees; "HR-Employee"."Pension No.") { }
            column(No_HREmployees; "HR-Employee"."No.") { }
            column(FullName_HREmployees; "HR-Employee"."Full Name") { }
            column(IDNumber_HREmployees; "HR-Employee"."ID Number") { }
            column(STDAmount; STDAmount) { }
            column(GROSSAmount; GROSSAmount) { }
            column(VolAmount; VolAmount) { }
            column(Vol_STD_Amount; Vol_STD_Amount) { }
            column(Tot_VolAmount; Tot_VolAmount) { }
            column(Tot_STDAmount; Tot_STDAmount) { }
            column(i; i) { }
            column(CompInfoName; CompInfo.Name) { }
            column(PayrollPeriod; PayrollPeriod) { }
            column(CompInfoPension; CompInfo."VAT Registration No.") { }
            column(CompInfoNHIF; CompInfo."VAT Registration No.") { }
            column(FirstName_HREmployees; "HR-Employee"."First Name") { }
            column(MiddleName_HREmployees; "HR-Employee"."Middle Name") { }
            column(LastName_HREmployees; "HR-Employee"."Last Name") { }
            column(NHIFNo_HREmployees; "HR-Employee"."NHIF No.") { }
            column(AppliedFilters; AppliedFilters) { }
            column(PINNo_HREmployees; "HR-Employee"."TIN No.") { }
            column(PensionNO; PensionNO) { }
            trigger OnPreDataItem();
            begin
                Tot_VolAmount := 0;
                Tot_STDAmount := 0;
                Tot_Vol_STD_Amount := 0;
            end;

            trigger OnAfterGetRecord();
            begin
                //Initialize
                VolAmount := 0;
                STDAmount := 0;
                Vol_STD_Amount := 0;
                GROSSAmount := 0;
                PensionNO := '';
                //Standard Amount
                PRPeriodTrans.Reset;
                PRPeriodTrans.SetRange(PRPeriodTrans."Employee Code", "HR-Employee"."No.");
                PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period", PayrollPeriod);
                PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", 'Pension');
                if PRPeriodTrans.Find('-') then begin
                    STDAmount := PRPeriodTrans.Amount * 2;
                end;
                //Voluntary Amount
                PRPeriodTrans.Reset;
                PRPeriodTrans.SetRange(PRPeriodTrans."Employee Code", "HR-Employee"."No.");
                PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period", PayrollPeriod);
                PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", 'D003');  //Voluntary Pension Code here
                if PRPeriodTrans.Find('-') then begin
                    VolAmount := PRPeriodTrans.Amount;
                end;
                //Gross Amount
                PRPeriodTrans.Reset;
                PRPeriodTrans.SetRange(PRPeriodTrans."Employee Code", "HR-Employee"."No.");
                PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period", PayrollPeriod);
                PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", 'GPAY');
                if PRPeriodTrans.Find('-') then begin
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
        trigger OnOpenPage()
        begin
        end;
    }

    trigger OnInitReport()
    begin

    end;

    trigger OnPostReport()
    begin
    end;

    trigger OnPreReport()
    begin
        CompInfo.Reset;
        CompInfo.Get;
        if PayrollPeriod = 0D then Error('Please enter payroll period');
        //AppliedFilters
        if "HR-Employee".GetFilters = '' then begin
            AppliedFilters := '';
        end else begin
            AppliedFilters := 'APPLIED FILTERS(s) ' + "HR-Employee".GetFilters;
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
        //HRCodeunit: Codeunit UnknownCodeunit50000;
        //HRPRAccess: Record UnknownRecord70134810;
        PensionNO: Code[30];



}
