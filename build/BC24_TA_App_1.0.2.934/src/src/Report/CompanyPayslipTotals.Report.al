report 50095 "Company Payslip Totals"
{
    // version FIN-24-AUG-18

    DefaultLayout = RDLC;
    ApplicationArea = All;
    //RDLCLayout = './Company Payslip Totals.rdlc';

    dataset
    {
        dataitem("PR Period Transactions"; "PR Period Transactions")
        {
            RequestFilterFields = "Payroll Period", "Employee Code", "Transaction Code";
            column(CompInfo_Name; CompInfo.Name) { }
            column(CompInfo_Address; CompInfo.Address) { }
            column(CompInfo_Address2; CompInfo."Address 2") { }
            column(CompInfo_City; CompInfo.City) { }
            column(CompInfo_Picture; CompInfo.Picture) { }
            column(CompInfo_PhoneNo; CompInfo."Phone No.") { }
            column(AppliedFilters; AppliedFilters) { }
            column(ReportTitle; ReportTitle) { }
            column(TransactionCode; "PR Period Transactions"."Transaction Code") { }
            column(GroupText; "PR Period Transactions"."Group Text") { }
            column(TransactionName; "PR Period Transactions"."Transaction Name") { }
            column(Amount; "PR Period Transactions".Amount) { }
            column(EmployeeCode_PRPeriodTransactions; "PR Period Transactions"."Employee Code") { }
            column(SelectedPeriod; SelectedPeriod) { }
            column(PayrollPeriod; "PR Period Transactions"."Payroll Period") { }
            column(GroupOrder; "PR Period Transactions"."Group Order") { }
            column(SubGroupOrder; "PR Period Transactions"."Sub Group Order") { }
            column(TCode_Pension; TCode_Pension) { }
            column(TCode_Gratuity; TCode_Gratuity) { }
            column(RequestPageFiltersMandatory; RequestPageFiltersMandatory) { }
            column(PensionEmployer; PensionEmployer) { }
            column(PensionAccumilationSelf; PensionAccumilationSelf) { }
            column(PensionAccumilationEmployer; PensionAccumilationEmployer) { }
            column(SalaryAdvanceBalance; SalaryAdvanceBalance) { }
            column(EmployeeCount; EmployeeCount) { }
            column(NewHire; NewHire) { }
            column(BankRemmitance; BankRemmitance) { }

            trigger OnAfterGetRecord();
            begin

                IF "PR Period Transactions"."Transaction Code" = 'NPAY' THEN BEGIN
                    EmployeeCount += 1;
                    BankRemmitance += "PR Period Transactions".Amount;
                    //ERROR('%1 IS ',BankRemmitance);
                END;


                //Pension Employer
                PREmployerDeductions.RESET;
                PREmployerDeductions.SETRANGE("Payroll Period", SelectedPeriod);
                PREmployerDeductions.SETRANGE("Transaction Code", TCode_Pension);
                PREmployerDeductions.SETRANGE("Employee Code", "PR Period Transactions"."Employee Code");
                IF PREmployerDeductions.FINDFIRST THEN BEGIN
                    REPEAT
                        PensionEmployer += PREmployerDeductions.Amount;
                    UNTIL PREmployerDeductions.NEXT = 0;
                END;
            end;

            trigger OnPreDataItem();
            begin
                CompInfo.RESET;
                CompInfo.GET;

                IF "PR Period Transactions".GETFILTER("PR Period Transactions"."Payroll Period") = '' THEN ERROR('Please select payroll period');

                CompInfo.CALCFIELDS(Picture);


                //Initialize
                CLEAR(PensionEmployer);
                CLEAR(PensionAccumilationSelf);
                CLEAR(PensionAccumilationEmployer);

                //Pension Accumilation Self
                PRPeriodTrans.RESET;
                PRPeriodTrans.SETRANGE("Transaction Code", TCode_Pension);
                PRPeriodTrans.SETRANGE("Payroll Period", SelectedPeriod);
                //PRPeriodTrans.SETCURRENTKEY("Employee Code", "Transaction Code", "Period Month", "Period Year", Membership, "Reference No");
                IF PRPeriodTrans.FINDSET() THEN BEGIN
                    PRPeriodTrans.CALCSUMS(Amount);
                    PensionAccumilationSelf := PRPeriodTrans.Amount;
                END;

                //Pension Accumilation Employer
                PREmployerDeductions.RESET;
                PREmployerDeductions.SETRANGE("Payroll Period", SelectedPeriod);
                PREmployerDeductions.SETRANGE("Transaction Code", TCode_Pension);
                IF PREmployerDeductions.FINDSET() THEN BEGIN
                    PREmployerDeductions.CALCSUMS(Amount);
                    PensionAccumilationEmployer := PREmployerDeductions.Amount;
                END;

                //Filter period
                "PR Period Transactions".SETRANGE("Payroll Period", SelectedPeriod);
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
                    field(RequestPageFiltersMandatory; RequestPageFiltersMandatory)
                    {
                        Caption = 'Transaction Codes FIlter Manadatory';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Transaction Codes FIlter Manadatory field.';
                    }
                    field(TCode_Pension; TCode_Pension)
                    {
                        Caption = 'Pension Code';
                        TableRelation = "PR Transaction Codes"."Transaction Code";
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Pension Code field.';
                    }
                    field(TCode_Gratuity; TCode_Gratuity)
                    {
                        Caption = 'Gratuity Code';
                        TableRelation = "PR Transaction Codes"."Transaction Code";
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Gratuity Code field.';
                    }
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

        trigger OnOpenPage();
        begin
            RequestPageFiltersMandatory := TRUE;
        end;
    }

    labels { }

    trigger OnPreReport();
    begin

        //Request page filters
        IF RequestPageFiltersMandatory THEN BEGIN
            IF TCode_Pension = '' THEN ERROR('Please select Pension Transaction Code on request page');
            IF TCode_Gratuity = '' THEN ERROR('Please select Pension Transaction Code on request page');
        END;


        IF SelectedPeriod = 0D THEN ERROR('Please select payroll period');

        //Default Report Title
        IF ReportTitle = '' THEN ReportTitle := TXT_DEFAULT_REPORT_TITLE;

        //Applied Filters
        AppliedFilters := TXT_APPLIED_FILTERS + TXT_SP_OP + "PR Period Transactions".GETFILTERS + TXT_SP_CL;
    end;

    var
        CompInfo: Record "Company Information";
        AppliedFilters: Text;
        ReportTitle: Text[150];
        TXT_DEFAULT_REPORT_TITLE: Label 'COMPANY PAYSLIP TOTALS';
        TXT_APPLIED_FILTERS: Label '"Applied Filters - "';
        TXT_SP_OP: Label '"( "';
        TXT_SP_CL: Label '" )"';
        SelectedPeriod: Date;
        TCode_Pension: Code[10];
        TCode_Gratuity: Code[10];
        RequestPageFiltersMandatory: Boolean;
        PREmployerDeductions: Record "PR Employer Deductions";
        PensionEmployer: Decimal;
        PensionAccumilationSelf: Decimal;
        PensionAccumilationEmployer: Decimal;
        SalaryAdvanceBalance: Decimal;
        EmployeeCount: Decimal;
        NewHire: Decimal;
        BankRemmitance: Decimal;
        PRPeriodTrans: Record "PR Period Transactions";
}

