report 50027 "PR Pension Report"
{
    // version FIN-24-AUG-18

    DefaultLayout = RDLC;
    RDLCLayout = './PR Pension Report.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("HR-Employee"; "HR-Employee")
        {
            RequestFilterFields = "No.", Status;
            column(CompInfo_Name; CompInfo.Name) { }
            column(CompInfo_Address; CompInfo.Address) { }
            column(CompInfo_Address2; CompInfo."Address 2") { }
            column(CompInfo_City; CompInfo.City) { }
            column(CompInfo_Picture; CompInfo.Picture) { }
            column(CompInfo_PhoneNo; CompInfo."Phone No.") { }
            column(No_HREmployees; "HR-Employee"."No.") { }
            column(FirstName_HREmployees; "HR-Employee"."First Name") { }
            column(MiddleName_HREmployees; "HR-Employee"."Middle Name") { }
            column(LastName_HREmployees; "HR-Employee"."Last Name") { }
            column(PeriodName; PeriodName) { }
            column(PAYENumber_HREmployees; "HR-Employee"."TIN No.") { }
            column(DateOfBirth_HREmployees; "HR-Employee"."Date Of Birth") { }
            column(NHIFNo_HREmployees; "HR-Employee"."NHIF No.") { }
            column(IDNumber_HREmployees; "HR-Employee"."ID Number") { }
            column(PensionNo_HREmployees; "HR-Employee"."Pension No.") { }
            column(StdAmount; StdAmount) { }
            column(YearBirth; YearBirth) { }
            column(GPAY; GPAY) { }
            column(VolAmount; VolAmount) { }
            column(TotalEmployees; TotalEmployees) { }

            trigger OnAfterGetRecord();
            begin

                StdAmount := 0;
                VolAmount := 0;
                GPAY := 0;

                PRPeriodTrans.RESET;
                PRPeriodTrans.SETRANGE("Payroll Period", SelectedPeriod);
                PRPeriodTrans.SETRANGE("Employee Code", "HR-Employee"."No.");
                PRPeriodTrans.SETRANGE("Transaction Code", 'Pension');
                IF PRPeriodTrans.FINDFIRST() THEN BEGIN
                    StdAmount := PRPeriodTrans.Amount;
                END;

                PRPeriodTrans.RESET;
                PRPeriodTrans.SETRANGE("Payroll Period", SelectedPeriod);
                PRPeriodTrans.SETRANGE("Employee Code", "HR-Employee"."No.");
                PRPeriodTrans.SETRANGE("Transaction Code", 'GPAY');
                IF PRPeriodTrans.FINDFIRST() THEN BEGIN
                    GPAY := PRPeriodTrans.Amount;
                    TotalEmployees += 1;
                END;

                //Voluntary Amount
                PRPeriodTrans.RESET;
                PRPeriodTrans.SETRANGE("Payroll Period", SelectedPeriod);
                PRPeriodTrans.SETRANGE("Employee Code", "HR-Employee"."No.");
                PRPeriodTrans.Setfilter(PRPeriodTrans."Coop Parameter Lk", '%1', PRPeriodTrans."Coop Parameter Lk"::"Voluntary Pension");
                if PRPeriodTrans.FindFirst() then begin
                    VolAmount := PRPeriodTrans.Amount;
                end;



                if GPAY = 0 then CurrReport.Skip();
            end;

            trigger OnPreDataItem();
            begin
                TotalEmployees := 0;
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
                group("Filter Options")
                {
                    field(SelectedPeriod; SelectedPeriod)
                    {
                        Caption = 'Selected Period';
                        TableRelation = "PR Payroll Periods"."Date Opened";
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Selected Period field.';
                    }
                }
            }
        }

        actions { }
    }

    labels { }

    trigger OnPreReport();
    begin


        CompInfo.RESET;
        CompInfo.GET;

        CompInfo.CALCFIELDS(Picture);

        IF SelectedPeriod = 0D THEN ERROR('Please select payroll period');

        PRPayrollPeriods.RESET;
        PRPayrollPeriods.SETRANGE("Date Opened", SelectedPeriod);
        IF PRPayrollPeriods.FINDFIRST() THEN PeriodName := UPPERCASE(PRPayrollPeriods."Period Name");
    end;

    var
        CompInfo: Record "Company Information";
        SelectedPeriod: Date;
        PRPayrollPeriods: Record "PR Payroll Periods";
        PRPeriodTrans: Record "PR Period Transactions";
        PeriodName: Text;
        StdAmount: Decimal;
        YearBirth: Text;
        GPAY: Decimal;
        VolAmount: Decimal;
        TotalEmployees: Decimal;
}

