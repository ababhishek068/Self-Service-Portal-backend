Report 50160 "PR Wage Bill Summary"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/PRWageBillSummary.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Dimension Value"; "Dimension Value")
        {
            DataItemTableView = order(ascending) where("Global Dimension No." = const(1));
            RequestFilterHeading = 'Required Filters';
            column(ReportForNavId_1102755000; 1102755000) { }
            column(Num; Num) { }
            column(Code_DimensionValue; "Dimension Value".Code) { }
            column(TotGPAY; TotGPAY) { }
            column(TotMedAll; TotMedAll) { }
            column(TotGPAY_TotMedAll; TotGPAY_TotMedAll) { }
            column(TotPFund; TotPFund) { }
            column(TotEmpPension; TotEmpPension) { }
            column(TotSalary; TotSalary) { }
            column(TotScheme; TotScheme) { }
            column(COMPANYNAME; COMPANYNAME) { }
            column(CompInfoPicture; CompInfo.Picture) { }
            column(PeriodName; PeriodName) { }
            column(ReportTitle; ReportTitle) { }

            trigger OnAfterGetRecord()
            begin
                //Initialize Values
                TotGPAY := 0;
                TotMedAll := 0;
                TotGPAY_TotMedAll := 0;
                TotPFund := 0;
                TotEmpPension := 0;


                //Gross Pay
                fnSetrangePRPeriodTransactions;
                PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", 'GPAY');
                if PRPeriodTrans.FindFirst() then begin
                    PRPeriodTrans.CalcSums(PRPeriodTrans.Amount);
                    TotGPAY := PRPeriodTrans.Amount;
                end else begin
                    PRPeriodTrans.CalcSums(PRPeriodTrans.Amount);
                    TotGPAY := PRPeriodTrans.Amount;
                end;

                //
                // // Medical Allowance
                // fnSetrangePRPeriodTransactions;
                // PRPeriodTrans.SETRANGE(PRPeriodTrans."Transaction Code",'E02');
                // IF PRPeriodTrans.FindFirst() THEN
                // BEGIN
                //      PRPeriodTrans.CALCSUMS(PRPeriodTrans.Amount);
                //      TotMedAll:=PRPeriodTrans.Amount;
                //      //Total Gross Pay - Total Medical Allowance
                //      TotGPAY_TotMedAll:=TotGPAY - TotMedAll;
                // END ELSE
                // BEGIN
                //     PRPeriodTrans.CALCSUMS(PRPeriodTrans.Amount);
                //     TotMedAll:=PRPeriodTrans.Amount;
                //     TotGPAY_TotMedAll:=TotGPAY - TotMedAll;
                // END;


                //Employer Provudent Fund
                fnSetrangePREmployerDeductions;
                PREmployerDed.SetRange(PREmployerDed."Transaction Code", 'D98');
                if PREmployerDed.FindFirst() then begin
                    PREmployerDed.CalcSums(PREmployerDed.Amount);
                    TotPFund := PREmployerDed.Amount;
                end else begin
                    PREmployerDed.CalcSums(PREmployerDed.Amount);
                    TotPFund := PREmployerDed.Amount;
                end;

                //Pension Employer Contribution
                fnSetrangePREmployerDeductions;
                PREmployerDed.SetRange(PREmployerDed."Transaction Code", 'Pension');
                //IF ContractTypeFilter <> '' THEN PREmployerDed.SETFILTER(PREmployerDed."Contract Type",ContractTypeFilter);
                if PREmployerDed.FindFirst() then begin
                    PREmployerDed.CalcSums(PREmployerDed.Amount);
                    TotEmpPension := PREmployerDed.Amount;
                end else begin
                    PREmployerDed.CalcSums(PREmployerDed.Amount);
                    TotEmpPension := PREmployerDed.Amount;
                end;

                //Salary Total
                TotSalary := TotGPAY_TotMedAll + TotPFund + TotEmpPension + TotMedAll;

                //Scheme Row Total
                //TotScheme:=TotGPAY + TotMedAll + TotPFund + TotEmpPension + TotSalary;

                if TotSalary = 0 then begin
                    if not ShowAllDirectorates then begin
                        CurrReport.Skip;
                    end else begin
                        TotScheme := TotGPAY + TotMedAll + TotPFund + TotEmpPension + TotSalary;
                    end;
                end;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(SelectedPeriod; SelectedPeriod)
                    {
                        ApplicationArea = Basic;
                        Caption = 'SelectedPeriod';
                        TableRelation = "PR Payroll Periods"."Date Opened";
                        ToolTip = 'Specifies the value of the SelectedPeriod field.';
                    }
                    label(Control3)
                    {
                        ApplicationArea = Basic;
                        Caption = '**';
                        Editable = false;
                    }
                    field(ReportTitle; ReportTitle)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Report Title';
                        ToolTip = 'Specifies the value of the Report Title field.';
                    }
                    field(ShowAllDirectorates; ShowAllDirectorates)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show All Directorates';
                        ToolTip = 'If Yes, Schemes with No Data will be Displayed';
                    }
                }
            }
        }

        actions { }
    }

    labels
    {
        LblCertifiedBy = 'Certified By:';
        LblApprovedBy = 'Approved By:';
        LblTypingSpace = '...............................................................................';
        LblPrintedby = 'Printed By:';
        LblPage = 'Page No.';
    }

    trigger OnPreReport()
    begin

        if SelectedPeriod = 0D then Error('Please Specify "Payroll Period" on the Request Page');

        if ReportTitle = '' then ReportTitle := 'PR Wage Bill Summary';


        //ContractTypeFilter:="Dimension Value".GETFILTER("Contract Type Filter");
        //error(ContractTypeFilter);



        PayrollPeriod.Reset;
        if PayrollPeriod.Get(SelectedPeriod) then PeriodName := PayrollPeriod."Period Name";

        fnCompanyInfo;
    end;

    var
        Num: Integer;
        PREmployerDed: Record "PR Employer Deductions";
        PRPeriodTrans: Record "PR Period Transactions";
        SelectedPeriod: Date;
        TotMedAll: Decimal;
        TotGPAY_TotMedAll: Decimal;
        TotPFund: Decimal;
        TotEmpPension: Decimal;
        TotSalary: Decimal;
        TotScheme: Decimal;
        ReportTitle: Text[100];
        PeriodName: Text[30];
        PayrollPeriod: Record "PR Payroll Periods";
        CompInfo: Record "Company Information";
        ShowAllDirectorates: Boolean;
        TotGPAY: Decimal;

    procedure fnSetrangePRPeriodTransactions()
    begin
        PRPeriodTrans.Reset;
        PRPeriodTrans.SetCurrentkey("Employee Code", "Transaction Code", "Payroll Period");
        PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period", SelectedPeriod);
        PRPeriodTrans.SetRange(PRPeriodTrans."Global Dimension 1 Code", "Dimension Value".Code);
        // PRPeriodTrans.SETFILTER(PRPeriodTrans."Contract Type",'<>%1','CASUALS');
        //IF ContractTypeFilter <> '' THEN PRPeriodTrans.SETFILTER(PRPeriodTrans."Contract Type",ContractTypeFilter);
    end;

    procedure fnSetrangePREmployerDeductions()
    begin
        PREmployerDed.Reset;
        PRPeriodTrans.SetCurrentkey("Employee Code", "Transaction Code", "Payroll Period");
        PREmployerDed.SetRange(PREmployerDed."Payroll Period", SelectedPeriod);
        PREmployerDed.SetRange(PREmployerDed."Global Dimension 1 Code", "Dimension Value".Code);
        // PREmployerDed.SETFILTER(PREmployerDed."Contract Type",'<>%1','CASUALS');
        //IF ContractTypeFilter <> '' THEN PREmployerDed.SETRANGE(PREmployerDed."Contract Type",ContractTypeFilter);
    end;

    procedure fnCompanyInfo()
    begin
        CompInfo.Reset;
        if not CompInfo.Get then Error('Please setup company info');
        CompInfo.CalcFields(CompInfo.Picture);
    end;
}

