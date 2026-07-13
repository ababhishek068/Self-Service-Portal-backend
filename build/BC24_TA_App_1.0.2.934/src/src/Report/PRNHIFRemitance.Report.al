Report 50157 "PR NHIF Remitance"
{
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
            column(VolAmount; VolAmount) { }
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

            trigger OnAfterGetRecord()
            begin
                //Initialize
                VolAmount := 0;
                STDAmount := 0;

                //Standard Amount
                PRPeriodTrans.Reset;
                PRPeriodTrans.SetRange(PRPeriodTrans."Employee Code", "HR Employees"."No.");
                PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period", PayrollPeriod);
                PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", 'NHIF');
                if PRPeriodTrans.FindFirst() then begin
                    STDAmount := PRPeriodTrans.Amount;
                end;


                //Voluntary Amount
                //PRPeriodTrans.RESET;
                //PRPeriodTrans.SETRANGE(PRPeriodTrans."Employee Code","HR Employees"."No.");
                //PRPeriodTrans.SETRANGE(PRPeriodTrans."Payroll Period",PayrollPeriod);
                //PRPeriodTrans.SETRANGE(PRPeriodTrans."Transaction Code",'909');  //Voluntary Pension Code here
                //IF PRPeriodTrans.FindFirst() THEN
                //BEGIN
                //    VolAmount:=PRPeriodTrans.Amount;
                //END;

                //Grand Totals
                Tot_STDAmount += STDAmount;


                if (STDAmount = 0) then CurrReport.Skip;

                i += 1;
            end;

            trigger OnPreDataItem()
            begin
                //Initialize Grand Total
                Tot_STDAmount := 0;
                Tot_VolAmount := 0;
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
                    field(PayrollPeriod; PayrollPeriod)
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
            // PRPayrollPeriods.RESET();
            // PRPayrollPeriods.SETRANGE(Closed,FALSE);
            // IF PRPayrollPeriods.FindFirst() THEN PayrollPeriod:=PayrollPeriod."Date Opened";
        end;
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
        PRPeriodTrans: Record "PR Period Transactions";
        Tot_VolAmount: Decimal;
        Tot_STDAmount: Decimal;
        i: Integer;
        AppliedFilters: Text;
}

