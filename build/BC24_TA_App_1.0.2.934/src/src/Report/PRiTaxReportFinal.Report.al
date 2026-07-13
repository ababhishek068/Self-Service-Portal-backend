report 50020 "PR iTax Report Final"
{
    DefaultLayout = RDLC;
    RDLCLayout = './PR iTax Report.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("HR Employees"; "HR-Employee")
        {

            RequestFilterFields = "No.", "Posting Group", "Contract Type";
            column(EmployeeType_HREmployees; "HR Employees"."Employee Type") { }
            column(No_; "No.") { }
            column(Employee_Contract_Type; "Employee Contract Type") { }
            column(Employement_Type; "Employement Type") { }
            column(Contract_Type; "Contract Type") { }
            column(Citizenship_HREmployees; "HR Employees".Citizenship) { }
            column(FullName_HREmployees; "HR Employees"."Full Name") { }
            column(PINNo_HREmployees; "HR Employees"."TIN No.") { }
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

            trigger OnAfterGetRecord();
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
                PRPeriodTrans.SETFILTER(PRPeriodTrans."Transaction Code", '%1|%2', 'BPAY', 'E21');
                IF PRPeriodTrans.FIND('-') THEN BEGIN
                    PRPeriodTrans.CALCSUMS(PRPeriodTrans.Amount);
                    BPAY := PRPeriodTrans.Amount;
                END;

                //House Allowance & Arrears
                fn_PeriodTrans;
                PRPeriodTrans.SETFILTER(PRPeriodTrans."Transaction Code", '%1|%2', 'E001', 'E12');
                IF PRPeriodTrans.FIND('-') THEN BEGIN
                    PRPeriodTrans.CALCSUMS(PRPeriodTrans.Amount);
                    HouseAllowance := PRPeriodTrans.Amount;
                END;

                //Transport Allowance & Arrears
                fn_PeriodTrans;
                PRPeriodTrans.SETFILTER(PRPeriodTrans."Transaction Code", '%1|%2', 'E002', 'E13');
                IF PRPeriodTrans.FIND('-') THEN BEGIN
                    PRPeriodTrans.CALCSUMS(PRPeriodTrans.Amount);
                    TransportAllowance := PRPeriodTrans.Amount;
                END;

                //Leave Allowance & Arrears
                fn_PeriodTrans;
                PRPeriodTrans.SETFILTER(PRPeriodTrans."Transaction Code", '%1|%2', 'E004', 'E10ARR');
                IF PRPeriodTrans.FIND('-') THEN BEGIN
                    PRPeriodTrans.CALCSUMS(PRPeriodTrans.Amount);
                    LeaveAllowance := PRPeriodTrans.Amount;
                END;

                //Overtime Allowance
                fn_PeriodTrans;
                PRPeriodTrans.SETFILTER(PRPeriodTrans."Transaction Code", '%1', 'E35');
                IF PRPeriodTrans.FIND('-') THEN BEGIN
                    PRPeriodTrans.CALCSUMS(PRPeriodTrans.Amount);
                    OvertimeAllowance := PRPeriodTrans.Amount;
                END;

                //Directors Fee


                //Lumpsum
                fn_PeriodTrans;
                PRPeriodTrans.SETFILTER(PRPeriodTrans."Transaction Code", '%1', 'E018');
                IF PRPeriodTrans.FIND('-') THEN BEGIN
                    PRPeriodTrans.CALCSUMS(PRPeriodTrans.Amount);
                    Lumpsum := PRPeriodTrans.Amount;
                END;

                //Other Allowances 1
                fn_PeriodTrans;
                PRPeriodTrans.SETFILTER(PRPeriodTrans."Transaction Code", '%1|%2|%3|%4|%5|%6|%7|%8|%9'
                              , 'E003', 'E007', 'E013', 'E005', 'E018', 'E006', 'E022', 'E008');
                IF PRPeriodTrans.FIND('-') THEN BEGIN
                    PRPeriodTrans.CALCSUMS(PRPeriodTrans.Amount);
                    OtherAllowances := PRPeriodTrans.Amount;
                END;

                //Other Allowances 2
                fn_PeriodTrans;
                PRPeriodTrans.SETFILTER(PRPeriodTrans."Transaction Code", '%1|%2|%3|%4|%5|%6|%7|%8'
                              , 'E009', 'E010', 'E011', 'E019', 'E023', 'E024', 'E025', 'E012');
                IF PRPeriodTrans.FIND('-') THEN BEGIN
                    PRPeriodTrans.CALCSUMS(PRPeriodTrans.Amount);
                    OtherAllowances += PRPeriodTrans.Amount;
                END;

                //Other Allowances 3
                fn_PeriodTrans;
                PRPeriodTrans.SETFILTER(PRPeriodTrans."Transaction Code", '%1|%2|%3|%4|%5|%6|%7|%8|%9|%10|%11'
                              , 'E026', 'E027', 'E028', 'E015', 'E016', 'E020', 'E014', 'E017', 'E021', 'E029', 'E030');
                IF PRPeriodTrans.FIND('-') THEN BEGIN
                    PRPeriodTrans.CALCSUMS(PRPeriodTrans.Amount);
                    OtherAllowances += PRPeriodTrans.Amount;
                END;

                //Other Non Cash
                PRTransCodes.RESET;
                PRTransCodes.SETRANGE(PRTransCodes."Transaction Type", PRTransCodes."Transaction Type"::Benefit);
                IF PRTransCodes.FIND('-') THEN BEGIN
                    REPEAT
                        fn_PeriodTrans;
                        PRPeriodTrans.SETRANGE(PRPeriodTrans."Transaction Code", PRTransCodes."Transaction Code");
                        IF PRPeriodTrans.FIND('-') THEN BEGIN
                            OtherNonCash += PRPeriodTrans.Amount;
                        END;
                    UNTIL PRTransCodes.NEXT = 0;
                END;

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
                PRTransCodes.RESET;
                PRTransCodes.SETFILTER(PRTransCodes."Special Trans Deductions", '%1|%2'
                                      , (PRTransCodes."Special Trans Deductions"::"Defined Contribution")
                                      , (PRTransCodes."Special Trans Deductions"::"Voluntary Pension")
                                      );
                IF PRTransCodes.FIND('-') THEN BEGIN
                    REPEAT
                        fn_PeriodTrans;
                        PRPeriodTrans.SETRANGE(PRPeriodTrans."Transaction Code", PRTransCodes."Transaction Code");
                        IF PRPeriodTrans.FIND('-') THEN BEGIN
                            ActualContr += PRPeriodTrans.Amount;
                        END;
                    UNTIL PRTransCodes.NEXT = 0;
                END;
                //Add Pension too
                fn_PeriodTrans;
                PRPeriodTrans.SETRANGE(PRPeriodTrans."Transaction Code", 'Pension');
                IF PRPeriodTrans.FIND('-') THEN BEGIN
                    ActualContr += PRPeriodTrans.Amount;
                END;

                //Permissible Limit
                PermissibleLimit := 20000;

                //Mortgage Intrest
                fn_PeriodTrans;
                PRPeriodTrans.SETRANGE(PRPeriodTrans."Transaction Code", 'MORG-RL');
                IF PRPeriodTrans.FIND('-') THEN BEGIN
                    PRPeriodTrans.CALCSUMS(PRPeriodTrans.Amount);
                    MortgageIntrest := PRPeriodTrans.Amount;
                END;

                //Amount of Benefit
                E1 := 0.3 * TotalCashPay;
                E2 := ActualContr;
                E3 := 20000;

                //Column G - Get least between e1,E2,e3
                IF E1 > E2 THEN BEGIN
                    AmountOfBenefit := E2;
                END ELSE BEGIN
                    AmountOfBenefit := E1;
                END;

                IF E3 < AmountOfBenefit THEN BEGIN
                    AmountOfBenefit := E3;
                END;
                AmountOfBenefit += MortgageIntrest;

                //Taxable Pay
                fn_PeriodTrans;
                PRPeriodTrans.SETRANGE(PRPeriodTrans."Transaction Code", 'TXBP');
                IF PRPeriodTrans.FIND('-') THEN BEGIN
                    TaxablePay := PRPeriodTrans.Amount;
                END;

                //Tax Payable
                fn_PeriodTrans;
                PRPeriodTrans.SETRANGE(PRPeriodTrans."Transaction Code", 'TXCHRG');
                IF PRPeriodTrans.FIND('-') THEN BEGIN
                    TaxPayable := PRPeriodTrans.Amount;
                END;

                //Monthly Relief
                fn_PeriodTrans;
                PRPeriodTrans.SETRANGE(PRPeriodTrans."Transaction Code", 'PSNR');
                IF PRPeriodTrans.FIND('-') THEN BEGIN
                    MonthlyRelief := PRPeriodTrans.Amount;
                END;

                //Insurance Relief
                fn_PeriodTrans;
                PRPeriodTrans.SETFILTER(PRPeriodTrans."Transaction Code", '%1|%2', 'INSR', 'NHIF-RL');
                IF PRPeriodTrans.FIND('-') THEN BEGIN
                    PRPeriodTrans.CALCSUMS(PRPeriodTrans.Amount);
                    InsuranceRelief := PRPeriodTrans.Amount;
                END;

                //PAYE
                fn_PeriodTrans;
                PRPeriodTrans.SETRANGE(PRPeriodTrans."Transaction Code", 'PAYE');
                IF PRPeriodTrans.FIND('-') THEN BEGIN
                    PAYE := PRPeriodTrans.Amount;
                END;


                IF TotalCashPay = 0 THEN CurrReport.SKIP;
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
                        Caption = 'Period Filter';
                        TableRelation = "PR Payroll Periods";
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Period Filter field.';
                    }
                }
            }
        }

        actions { }
    }

    labels { }

    trigger OnPreReport();
    begin
        IF PeriodFilter = 0D THEN ERROR('Please select payroll period');
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

    procedure fnCompanyInfo();
    begin
        CompInfo.RESET;
        IF CompInfo.GET THEN
            CompInfo.CALCFIELDS(CompInfo.Picture);
    end;

    local procedure fn_PeriodTrans();
    begin
        PRPeriodTrans.RESET;
        PRPeriodTrans.SETRANGE(PRPeriodTrans."Employee Code", "HR Employees"."No.");
        PRPeriodTrans.SETRANGE(PRPeriodTrans."Payroll Period", PeriodFilter);
    end;
}

