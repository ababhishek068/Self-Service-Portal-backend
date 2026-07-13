Report 50172 "PR iTax Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/PRiTaxReport.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("HR-Employees"; "HR-Employee")
        {
            RequestFilterFields = "No.", "Payroll Posting Group";
            column(ReportForNavId_1; 1) { }
            column(EmployeeType_HREmployees; "HR-Employees"."No.") { }
            column(Citizenship_HREmployees; "HR-Employees"."Global Dimension 1 Code") { }
            column(FullName_HREmployees; "HR-Employees"."Full Name") { }
            column(Posting_GroupNo_HREmployees; "HR-Employees"."TIN No.") { }
            column(BPAY; BPAY) { }
            column(HouseAllowance; HouseAllowance) { }
            column(TransportAllowance; TransportAllowance) { }
            column(LeaveAllowance; LeaveAllowance) { }
            column(DirectorsFee; DirectorsFee) { }
            column(OvertimeAllowance; OvertimeAllowance) { }
            column(Lumpsum; Lumpsum) { }
            column(OtherAllowances; OtherAllowances) { }
            column(TotalCashPay; TotalCashPay) { }
            column(ValueOfCar; ValueOfCar) { }
            column(OtherNonCash; OtherNonCash) { }
            column(TotalNonCash; TotalNonCash) { }
            column(GlobalIncome; GlobalIncome) { }
            column(TypeOfHousing; TypeOfHousing) { }
            column(RentOfHouse; RentOfHouse) { }
            column(ComputedRent; ComputedRent) { }
            column(RentRecovered; RentRecovered) { }
            column(NetValue; NetValue) { }
            column(TotalGross; TotalGross) { }
            column(ThirtyPCash; ThirtyPCash) { }
            column(ActualContr; ActualContr) { }
            column(PermissibleLimit; PermissibleLimit) { }
            column(MortgageIntrest; MortgageIntrest) { }
            column(HOSP; HOSP) { }
            column(AmountOfBenefit; AmountOfBenefit) { }
            column(TaxablePay; TaxablePay) { }
            column(TaxPayable; TaxPayable) { }
            column(MonthlyRelief; MonthlyRelief) { }
            column(InsuranceRelief; InsuranceRelief) { }
            column(PAYE; PAYE) { }

            trigger OnAfterGetRecord()
            begin
                //Init
                BPAY := 0;
                HouseAllowance := 0;
                TransportAllowance := 0;
                OvertimeAllowance := 0;
                DirectorsFee := 0;
                LeaveAllowance := 0;
                OvertimeAllowance := 0;
                Lumpsum := 0;
                OtherAllowances := 0;
                TotalCashPay := 0;
                ValueOfCar := 0;
                OtherNonCash := 0;
                TotalNonCash := 0;
                GlobalIncome := 0;
                TypeOfHousing := 0;
                ComputedRent := 0;
                RentRecovered := 0;
                NetValue := 0;
                TotalGross := 0;
                ThirtyPCash := 0;
                ActualContr := 0;
                PermissibleLimit := 0;
                MortgageIntrest := 0;
                AmountOfBenefit := 0;
                TaxablePay := 0;
                TaxPayable := 0;
                MonthlyRelief := 0;
                InsuranceRelief := 0;
                PAYE := 0;


                //Basic Pay
                fn_PeriodTrans;
                PRPeriodTrans.SetFilter(PRPeriodTrans."Transaction Code", '%1|%2', 'BPAY', 'E21');
                if PRPeriodTrans.FindFirst() then begin
                    PRPeriodTrans.CalcSums(PRPeriodTrans.Amount);
                    BPAY := PRPeriodTrans.Amount;
                end;

                //House Allowance & Arrears
                fn_PeriodTrans;
                PRPeriodTrans.SetFilter(PRPeriodTrans."Transaction Code", '%1|%2', 'E01', 'E12');
                if PRPeriodTrans.FindFirst() then begin
                    PRPeriodTrans.CalcSums(PRPeriodTrans.Amount);
                    HouseAllowance := PRPeriodTrans.Amount;
                end;

                //Transport Allowance & Arrears
                fn_PeriodTrans;
                PRPeriodTrans.SetFilter(PRPeriodTrans."Transaction Code", '%1|%2', 'E02', 'E13');
                if PRPeriodTrans.FindFirst() then begin
                    PRPeriodTrans.CalcSums(PRPeriodTrans.Amount);
                    TransportAllowance := PRPeriodTrans.Amount;
                end;

                //Leave Allowance & Arrears
                fn_PeriodTrans;
                PRPeriodTrans.SetFilter(PRPeriodTrans."Transaction Code", '%1|%2', 'E10', 'E10ARR');
                if PRPeriodTrans.FindFirst() then begin
                    PRPeriodTrans.CalcSums(PRPeriodTrans.Amount);
                    LeaveAllowance := PRPeriodTrans.Amount;
                end;

                //Overtime Allowance
                fn_PeriodTrans;
                PRPeriodTrans.SetFilter(PRPeriodTrans."Transaction Code", '%1', 'E35');
                if PRPeriodTrans.FindFirst() then begin
                    PRPeriodTrans.CalcSums(PRPeriodTrans.Amount);
                    OvertimeAllowance := PRPeriodTrans.Amount;
                end;

                //Directors Fee


                //Lumpsum
                fn_PeriodTrans;
                PRPeriodTrans.SetFilter(PRPeriodTrans."Transaction Code", '%1', 'E14');
                if PRPeriodTrans.FindFirst() then begin
                    PRPeriodTrans.CalcSums(PRPeriodTrans.Amount);
                    Lumpsum := PRPeriodTrans.Amount;
                end;

                //Other Allowances 1
                fn_PeriodTrans;
                PRPeriodTrans.SetFilter(PRPeriodTrans."Transaction Code", '%1|%2|%3|%4|%5|%6|%7|%8|%9'
                              , 'E03', 'E03-ARREARS', 'E04', 'E04ARR', 'E05', 'E18', 'E06', 'E22', 'E08');
                if PRPeriodTrans.FindFirst() then begin
                    PRPeriodTrans.CalcSums(PRPeriodTrans.Amount);
                    OtherAllowances := PRPeriodTrans.Amount;
                end;

                //Other Allowances 2
                fn_PeriodTrans;
                PRPeriodTrans.SetFilter(PRPeriodTrans."Transaction Code", '%1|%2|%3|%4|%5|%6|%7|%8'
                              , 'E09', 'E09 ARREARS', 'E11', 'E19', 'E23', 'E24', 'E25', 'E25ARREARS');
                if PRPeriodTrans.FindFirst() then begin
                    PRPeriodTrans.CalcSums(PRPeriodTrans.Amount);
                    OtherAllowances += PRPeriodTrans.Amount;
                end;

                //Other Allowances 3
                fn_PeriodTrans;
                PRPeriodTrans.SetFilter(PRPeriodTrans."Transaction Code", '%1|%2|%3|%4|%5|%6'
                              , 'E26', 'E27', 'E28', 'E15', 'E16', 'E20');
                if PRPeriodTrans.FindFirst() then begin
                    PRPeriodTrans.CalcSums(PRPeriodTrans.Amount);
                    OtherAllowances += PRPeriodTrans.Amount;
                end;

                //Other Non Cash
                PRTransCodes.Reset;
                PRTransCodes.SetRange(PRTransCodes."Transaction Type", PRTransCodes."transaction type"::Benefit);
                if PRTransCodes.FindFirst() then begin
                    repeat
                        fn_PeriodTrans;
                        PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", PRTransCodes."Transaction Code");
                        if PRPeriodTrans.FindFirst() then begin
                            OtherNonCash += PRPeriodTrans.Amount;
                        end;
                    until PRTransCodes.Next = 0;
                end;

                //Total Cash Pay
                TotalCashPay := BPAY + HouseAllowance + TransportAllowance + OvertimeAllowance
                              + DirectorsFee + LeaveAllowance + Lumpsum + OtherAllowances + OtherNonCash;


                //Value of Car


                //Total Non Cash
                TotalNonCash := OtherNonCash + ValueOfCar;

                //Globa Income
                GlobalIncome := TotalNonCash + TotalCashPay;

                //Type of Housing

                //Rent of House

                //Computed Rent

                //Rent Recovered

                //Net Value

                //Total Gross
                TotalGross := GlobalIncome;

                //30% of Cash
                ThirtyPCash := 0.3 * GlobalIncome;

                //Actual Contribution - Include Voluntary Pension & Voluntary Pension & Pension
                PRTransCodes.Reset;
                PRTransCodes.SetFilter(PRTransCodes."Special Trans Deductions", '%1|%2'
                                      , (PRTransCodes."Special Trans Deductions"::"Defined Contribution")
                                      , (PRTransCodes."Special Trans Deductions"::"Voluntary Pension"));
                if PRTransCodes.FindFirst() then begin
                    repeat
                        fn_PeriodTrans;
                        PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", PRTransCodes."Transaction Code");
                        if PRPeriodTrans.FindFirst() then begin
                            ActualContr += PRPeriodTrans.Amount;
                        end;
                    until PRTransCodes.Next = 0;
                end;
                //Add Pension too
                fn_PeriodTrans;
                PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", 'Pension');
                if PRPeriodTrans.FindFirst() then begin
                    ActualContr += PRPeriodTrans.Amount;
                end;

                //Permissible Limit
                PermissibleLimit := 20000;

                //Mortgage Intrest
                fn_PeriodTrans;
                PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", 'MORG-RL');
                if PRPeriodTrans.FindFirst() then begin
                    PRPeriodTrans.CalcSums(PRPeriodTrans.Amount);
                    MortgageIntrest := PRPeriodTrans.Amount;
                end;

                //Amount of Benefit
                E1 := 0.3 * TotalCashPay;
                E2 := ActualContr;
                E3 := 20000;

                //Column G - Get least between e1,E2,e3
                if E1 > E2 then begin
                    AmountOfBenefit := E2;
                end else begin
                    AmountOfBenefit := E1;
                end;

                if E3 < AmountOfBenefit then begin
                    AmountOfBenefit := E3;
                end;
                AmountOfBenefit += MortgageIntrest;

                //Taxable Pay
                fn_PeriodTrans;
                PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", 'TXBP');
                if PRPeriodTrans.FindFirst() then begin
                    TaxablePay := PRPeriodTrans.Amount;
                end;

                //Tax Payable
                fn_PeriodTrans;
                PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", 'TXCHRG');
                if PRPeriodTrans.FindFirst() then begin
                    TaxPayable := PRPeriodTrans.Amount;
                end;

                //Monthly Relief
                fn_PeriodTrans;
                PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", 'PSNR');
                if PRPeriodTrans.FindFirst() then begin
                    MonthlyRelief := PRPeriodTrans.Amount;
                end;

                //Insurance Relief
                fn_PeriodTrans;
                PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", 'INSR');
                if PRPeriodTrans.FindFirst() then begin
                    PRPeriodTrans.CalcSums(PRPeriodTrans.Amount);
                    InsuranceRelief := PRPeriodTrans.Amount;
                end;

                //PAYE
                fn_PeriodTrans;
                PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", 'PAYE');
                if PRPeriodTrans.FindFirst() then begin
                    PAYE := PRPeriodTrans.Amount;
                end;


                if TotalCashPay = 0 then CurrReport.Skip;
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
                        Caption = 'Period Filter';
                        TableRelation = "PR Payroll Periods";
                        ToolTip = 'Specifies the value of the Period Filter field.';
                    }
                }
            }
        }

        actions { }
    }

    labels { }

    trigger OnPreReport()
    begin
        if PeriodFilter = 0D then Error('Please select payroll period');
        fnCompanyInfo;
    end;

    var
        CompInfo: Record "Company Information";
        PRPeriodTrans: Record "PR Period Transactions";
        PeriodFilter: Date;
        PRTransCodes: Record "PR Transaction Codes";
        BPAY: Decimal;
        HouseAllowance: Decimal;
        TransportAllowance: Decimal;
        LeaveAllowance: Decimal;
        OvertimeAllowance: Decimal;
        DirectorsFee: Decimal;
        Lumpsum: Decimal;
        OtherAllowances: Decimal;
        TotalCashPay: Decimal;
        ValueOfCar: Decimal;
        OtherNonCash: Decimal;
        TotalNonCash: Decimal;
        GlobalIncome: Decimal;
        TypeOfHousing: Decimal;
        RentOfHouse: Decimal;
        ComputedRent: Decimal;
        RentRecovered: Decimal;
        NetValue: Decimal;
        TotalGross: Decimal;
        ThirtyPCash: Decimal;
        ActualContr: Decimal;
        PermissibleLimit: Decimal;
        MortgageIntrest: Decimal;
        HOSP: Decimal;
        AmountOfBenefit: Decimal;
        E1: Decimal;
        E2: Decimal;
        E3: Decimal;
        TaxablePay: Decimal;
        TaxPayable: Decimal;
        MonthlyRelief: Decimal;
        InsuranceRelief: Decimal;
        PAYE: Decimal;

    procedure fnCompanyInfo()
    begin
        CompInfo.Reset;
        if CompInfo.Get then
            CompInfo.CalcFields(CompInfo.Picture);
    end;

    local procedure fn_PeriodTrans()
    begin
        PRPeriodTrans.Reset;
        PRPeriodTrans.SetCurrentkey("Employee Code", "Transaction Code", "Payroll Period");
        PRPeriodTrans.SetRange(PRPeriodTrans."Employee Code", "HR-Employees"."No.");
        PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period", PeriodFilter);
    end;
}

