Report 50171 "PR iTax"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/PRiTax.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("HR-Employees"; "HR-Employee")
        {
            DataItemTableView = where(Status = const(Active));
            RequestFilterFields = "No.";
            column(ReportForNavId_1; 1) { }
            column(No_HREmployees; "HR-Employees"."No.") { }
            column(PINNo_HREmployees; "HR-Employees"."TIN No.") { }
            column(CompInfoName; CompInfo.Name) { }
            column(CompInfoAddress; CompInfo.Address) { }
            column(CompInfoCity; CompInfo.City) { }
            column(CompInfoPicture; CompInfo.Picture) { }
            column(CompInfoEMail; CompInfo."E-Mail") { }
            column(CompInfoHomePage; CompInfo."Home Page") { }
            column(EmpFullName; EmpFullName) { }
            column(Actualcontrib; Actualcontrib) { }
            column(BasicSalary; BasicSalary) { }
            column(HouseAllowance; HouseAllowance) { }
            column(TransportAllowance; TransportAllowance) { }
            column(PercentageofCash; PercentageofCash) { }
            column(LeaveAllowance; LeaveAllowance) { }
            column(TaxPayable; TaxPayable) { }
            column(AirtimeAllowance1; AirtimeAllowance1) { }
            column(OvertimeAllowance; OvertimeAllowance) { }
            column(KraTaxablepay; KraTaxablepay) { }
            column(AmountofBenefit; AmountofBenefit) { }
            column(TotalTransportAllowance; TotalTransportAllowance) { }
            column(GlobalIncome; GlobalIncome) { }
            column(OtherAllowance; OtherAllowance) { }
            column(TotalCashPay; TotalCashPay) { }
            column(GrossPay; GrossPay) { }
            column(TaxablePay; TaxablePay) { }
            column(TotTaxPayable; TotTaxPayable) { }
            column(payekra; "p.a.y.e.kra") { }
            column(TaxCharged; TaxCharged) { }
            column(MonthlyRelief; MonthlyRelief) { }
            column(InsuranceRelief; InsuranceRelief) { }
            column(PAYE; PAYE) { }
            column(MORG; MORG) { }
            column(EmployeeType_HREmployees; HREmp."No.") { }
            column(Citizenship_HREmployees; "HR-Employees".Religion) { }
            column(NetPay; NetPay) { }
            column(BPA; BPA) { }
            column(CombinedBasic; CombinedBasic) { }
            column(OtherNoncash; OtherNoncash) { }
            column(Lumpsum; Lumpsum) { }
            column(AllOtherAllowances; AllOtherAllowances) { }
            column(TotalHouseArrersAllowance; TotalHouseArrersAllowance) { }

            trigger OnAfterGetRecord()
            begin
                //Initialize
                EmpFullName := '';
                BasicSalary := 0;
                TaxPayable := 0;
                TaxPayable1 := 0;
                "p.a.y.e.kra" := 0;
                TaxPayable2 := 0;
                TaxPayable3 := 0;
                TaxPayable4 := 0;
                HouseAllowance := 0;
                TransportAllowance := 0;
                LeaveAllowance := 0;
                LeaveAllowanceAAR := 0;
                OvertimeAllowance := 0;
                OtherAllowance := 0;
                GrossPay := 0;
                PensionVol := 0;
                PensionVol := 0;
                KraTaxablepay := 0;
                Pension := 0;
                GlobalIncome := 0;
                Actualcontrib := 0;
                Lumpsum := 0;
                AmountofBenefit := 0;
                NetPay := 0;
                TaxablePay := 0;
                TaxCharged := 0;
                MonthlyRelief := 0;
                InsuranceRelief := 0;
                BPA := 0;
                PercentageofCash := 0;
                OtherNoncash := 0;
                EntertainmentAllowance := 0;
                EntertainmentAllowance := 0;
                HardshipAllowance := 0;
                ExrenousAllowance := 0;
                ResponsibilityAllowance := 0;
                AirportAllowance := 0;
                ActingAllowance := 0;
                AirtimeAllowance := 0;
                AirtimeArrearsAllowance := 0;
                TransferAllowance := 0;
                SpecialAllowance := 0;
                SubsistenceAllowance := 0;
                ExtrenousAllowance1 := 0;
                TransferAllowance1 := 0;
                SalaryArrearsAllowance := 0;
                ResponsibilityAllowance1 := 0;
                ArrearsEarningAllowance := 0;
                OtherAllowance1 := 0;
                RenumerationAllowance := 0;
                RenumerationArrearsAllowance := 0;
                SubsistenceAllowance1 := 0;
                OtherAllowance2 := 0;
                AirtimeAllowance1 := 0;
                MORG := 0;
                BasicPayArrears := 0;

                //Full Name
                Clear(HREmp);
                HREmp.SetRange(HREmp."No.", "HR-Employees"."No.");
                if HREmp.FindFirst() then begin
                    EmpFullName := HREmp."First Name" + ' ' + HREmp."Middle Name" + ' ' + HREmp."Last Name";
                end;

                //Basic Salary
                PRPeriodTrans.Reset;
                PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period", PeriodFilter);
                PRPeriodTrans.SetRange(PRPeriodTrans."Employee Code", "HR-Employees"."No.");
                PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", 'BPAY');
                if PRPeriodTrans.FindFirst() then begin
                    BasicSalary := PRPeriodTrans.Amount;
                end;

                //Basic Salary Arrears
                PRPeriodTrans.Reset;
                PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period", PeriodFilter);
                PRPeriodTrans.SetRange(PRPeriodTrans."Employee Code", "HR-Employees"."No.");
                PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", 'E21');
                if PRPeriodTrans.FindFirst() then begin
                    BasicPayArrears := PRPeriodTrans.Amount;
                end;
                //E21
                PRPeriodTrans.Reset;
                PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period", PeriodFilter);
                PRPeriodTrans.SetRange(PRPeriodTrans."Employee Code", "HR-Employees"."No.");
                PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", 'E21');
                if PRPeriodTrans.FindFirst() then begin
                    BPA := PRPeriodTrans.Amount;
                end;

                CombinedBasic := BPA + BasicSalary;

                //House Allowance
                PRPeriodTrans.Reset;
                PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period", PeriodFilter);
                PRPeriodTrans.SetRange(PRPeriodTrans."Employee Code", "HR-Employees"."No.");
                PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", 'E01');
                if PRPeriodTrans.FindFirst() then begin
                    HouseAllowance := PRPeriodTrans.Amount;
                end;


                //Other non cash
                PRPeriodTrans.Reset;
                PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period", PeriodFilter);
                PRPeriodTrans.SetRange(PRPeriodTrans."Employee Code", "HR-Employees"."No.");
                PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", 'E28');
                if PRPeriodTrans.FindFirst() then begin
                    OtherNoncash := PRPeriodTrans.Amount;
                end;

                // lumpsum
                PRPeriodTrans.Reset;
                PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period", PeriodFilter);
                PRPeriodTrans.SetRange(PRPeriodTrans."Employee Code", "HR-Employees"."No.");
                PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", 'E14');
                if PRPeriodTrans.FindFirst() then begin
                    Lumpsum := PRPeriodTrans.Amount;
                end;


                //Transport Allowance
                PRPeriodTrans.Reset;
                PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period", PeriodFilter);
                PRPeriodTrans.SetRange(PRPeriodTrans."Employee Code", "HR-Employees"."No.");
                PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", 'E02');
                if PRPeriodTrans.FindFirst() then begin
                    TransportAllowance := PRPeriodTrans.Amount;
                end;
                //CommuterArrearsAllowance
                PRPeriodTrans.Reset;
                PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period", PeriodFilter);
                PRPeriodTrans.SetRange(PRPeriodTrans."Employee Code", "HR-Employees"."No.");
                PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", 'E13');
                if PRPeriodTrans.FindFirst() then begin
                    CommuterArrearsAllowance := PRPeriodTrans.Amount;
                end;

                TotalTransportAllowance := TransportAllowance + CommuterArrearsAllowance;

                //Leave Allowance ARREARS
                PRPeriodTrans.Reset;
                PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period", PeriodFilter);
                PRPeriodTrans.SetRange(PRPeriodTrans."Employee Code", "HR-Employees"."No.");
                PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", 'E10ARR');
                if PRPeriodTrans.FindFirst() then begin
                    LeaveAllowanceAAR := PRPeriodTrans.Amount;
                end;

                //Leave Allowance
                PRPeriodTrans.Reset;
                PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period", PeriodFilter);
                PRPeriodTrans.SetRange(PRPeriodTrans."Employee Code", "HR-Employees"."No.");
                PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", 'E10');
                if PRPeriodTrans.FindFirst() then begin
                    LeaveAllowance := PRPeriodTrans.Amount;
                end;


                //Overtime Allowance
                PRPeriodTrans.Reset;
                PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period", PeriodFilter);
                PRPeriodTrans.SetRange(PRPeriodTrans."Employee Code", "HR-Employees"."No.");
                PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", 'E35');
                if PRPeriodTrans.FindFirst() then begin
                    OvertimeAllowance := PRPeriodTrans.Amount;
                end;

                //Other Allowances
                PRPeriodTrans.Reset;
                PRPeriodTrans.SetCurrentkey("Employee Code", "Transaction Code", "Payroll Period");
                PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period", PeriodFilter);
                PRPeriodTrans.SetRange(PRPeriodTrans."Employee Code", "HR-Employees"."No.");
                PRPeriodTrans.SetFilter(PRPeriodTrans."Transaction Code", '<>%1|<>%2|<>%3', 'E01', 'E11', 'E10');
                if PRPeriodTrans.FindFirst() then begin
                    PRPeriodTrans.CalcSums(PRPeriodTrans.Amount);
                end;

                //Total Net Pay
                PRPeriodTrans.Reset;
                PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period", PeriodFilter);
                PRPeriodTrans.SetRange(PRPeriodTrans."Employee Code", "HR-Employees"."No.");
                PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", 'NPAY');
                if PRPeriodTrans.FindFirst() then begin
                    NetPay := PRPeriodTrans.Amount;
                end;

                //Gross Pay
                PRPeriodTrans.Reset;
                PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period", PeriodFilter);
                PRPeriodTrans.SetRange(PRPeriodTrans."Employee Code", "HR-Employees"."No.");
                PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", 'GPAY');
                if PRPeriodTrans.FindFirst() then begin
                    GrossPay := PRPeriodTrans.Amount;
                end;

                //Taxable Pay
                PRPeriodTrans.Reset;
                PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period", PeriodFilter);
                PRPeriodTrans.SetRange(PRPeriodTrans."Employee Code", "HR-Employees"."No.");
                PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", 'TXBP');
                if PRPeriodTrans.FindFirst() then begin
                    TaxablePay := PRPeriodTrans.Amount;
                end;

                //Tax Charged
                PRPeriodTrans.Reset;
                PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period", PeriodFilter);
                PRPeriodTrans.SetRange(PRPeriodTrans."Employee Code", "HR-Employees"."No.");
                PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", 'TXCHRG');
                if PRPeriodTrans.FindFirst() then begin
                    TaxCharged := PRPeriodTrans.Amount;
                end;

                //Monthly Relief
                PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period", PeriodFilter);
                PRPeriodTrans.SetRange(PRPeriodTrans."Employee Code", "HR-Employees"."No.");
                PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", 'PSNR');
                if PRPeriodTrans.FindFirst() then begin
                    MonthlyRelief := PRPeriodTrans.Amount;
                end;

                //Insurance Relief
                PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period", PeriodFilter);
                PRPeriodTrans.SetRange(PRPeriodTrans."Employee Code", "HR-Employees"."No.");
                PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", 'INSR');
                if PRPeriodTrans.FindFirst() then begin
                    InsuranceRelief := PRPeriodTrans.Amount;
                end;

                //PAYE
                PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period", PeriodFilter);
                PRPeriodTrans.SetRange(PRPeriodTrans."Employee Code", "HR-Employees"."No.");
                PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", 'PAYE');
                if PRPeriodTrans.FindFirst() then begin
                    PAYE := PRPeriodTrans.Amount;
                end;
                //E12
                PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period", PeriodFilter);
                PRPeriodTrans.SetRange(PRPeriodTrans."Employee Code", "HR-Employees"."No.");
                PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", 'E12');
                if PRPeriodTrans.FindFirst() then begin
                    HouseArrersAllowance1 := PRPeriodTrans.Amount;
                end;
                //HouseArrersAllowance
                PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period", PeriodFilter);
                PRPeriodTrans.SetRange(PRPeriodTrans."Employee Code", "HR-Employees"."No.");
                PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", 'E17');
                if PRPeriodTrans.FindFirst() then begin
                    HouseArrersAllowance := PRPeriodTrans.Amount;
                end;

                //MORG-RL
                PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period", PeriodFilter);
                PRPeriodTrans.SetRange(PRPeriodTrans."Employee Code", "HR-Employees"."No.");
                PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", 'MORG-RL');
                if PRPeriodTrans.FindFirst() then begin
                    MORG := PRPeriodTrans.Amount;
                end;

                //E03
                PRPeriodTrans.Reset;
                PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period", PeriodFilter);
                PRPeriodTrans.SetRange(PRPeriodTrans."Employee Code", "HR-Employees"."No.");
                PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", 'E03');
                if PRPeriodTrans.FindFirst() then begin
                    EntertainmentAllowance := PRPeriodTrans.Amount;
                end;

                //E03ARRERS
                PRPeriodTrans.Reset;
                PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period", PeriodFilter);
                PRPeriodTrans.SetRange(PRPeriodTrans."Employee Code", "HR-Employees"."No.");
                PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", 'E03-ARREARS');
                if PRPeriodTrans.FindFirst() then begin
                    EntertainmentArrearsAllowance := PRPeriodTrans.Amount;
                end;
                //OTHER ALLOWANCE
                PRPeriodTrans.Reset;
                PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period", PeriodFilter);
                PRPeriodTrans.SetRange(PRPeriodTrans."Employee Code", "HR-Employees"."No.");
                PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", 'E04');
                if PRPeriodTrans.FindFirst() then begin
                    HardshipAllowance := PRPeriodTrans.Amount;
                end;
                //OTHER ALLOWANCE
                PRPeriodTrans.Reset;
                PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period", PeriodFilter);
                PRPeriodTrans.SetRange(PRPeriodTrans."Employee Code", "HR-Employees"."No.");
                PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", 'E05');
                if PRPeriodTrans.FindFirst() then begin
                    ExrenousAllowance := PRPeriodTrans.Amount;
                end;
                //OTHER ALLOWANCE
                PRPeriodTrans.Reset;
                PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period", PeriodFilter);
                PRPeriodTrans.SetRange(PRPeriodTrans."Employee Code", "HR-Employees"."No.");
                PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", 'E06');
                if PRPeriodTrans.FindFirst() then begin
                    ResponsibilityAllowance := PRPeriodTrans.Amount;
                end;
                //OTHER ALLOWANCE
                PRPeriodTrans.Reset;
                PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period", PeriodFilter);
                PRPeriodTrans.SetRange(PRPeriodTrans."Employee Code", "HR-Employees"."No.");
                PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", 'E07');
                if PRPeriodTrans.FindFirst() then begin
                    AirportAllowance := PRPeriodTrans.Amount;
                end;
                //OTHER ALLOWANCE
                PRPeriodTrans.Reset;
                PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period", PeriodFilter);
                PRPeriodTrans.SetRange(PRPeriodTrans."Employee Code", "HR-Employees"."No.");
                PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", 'E08');
                if PRPeriodTrans.FindFirst() then begin
                    ActingAllowance := PRPeriodTrans.Amount;
                end;
                //OTHER ALLOWANCE
                PRPeriodTrans.Reset;
                PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period", PeriodFilter);
                PRPeriodTrans.SetRange(PRPeriodTrans."Employee Code", "HR-Employees"."No.");
                PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", 'E09');
                if PRPeriodTrans.FindFirst() then begin
                    AirtimeAllowance := PRPeriodTrans.Amount;
                end;
                //OTHER ALLOWANCE
                PRPeriodTrans.Reset;
                PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period", PeriodFilter);
                PRPeriodTrans.SetRange(PRPeriodTrans."Employee Code", "HR-Employees"."No.");
                PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", 'E09-ARREARS');
                if PRPeriodTrans.FindFirst() then begin
                    AirtimeArrearsAllowance := PRPeriodTrans.Amount;
                end;
                //OTHER ALLOWANCE
                PRPeriodTrans.Reset;
                PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period", PeriodFilter);
                PRPeriodTrans.SetRange(PRPeriodTrans."Employee Code", "HR-Employees"."No.");
                PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", 'E11');
                if PRPeriodTrans.FindFirst() then begin
                    TransferAllowance := PRPeriodTrans.Amount;
                end;
                //OTHER ALLOWANCE
                PRPeriodTrans.Reset;
                PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period", PeriodFilter);
                PRPeriodTrans.SetRange(PRPeriodTrans."Employee Code", "HR-Employees"."No.");
                PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", 'E15');
                if PRPeriodTrans.FindFirst() then begin
                    SpecialAllowance := PRPeriodTrans.Amount;
                end;
                //OTHER ALLOWANCE
                PRPeriodTrans.Reset;
                PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period", PeriodFilter);
                PRPeriodTrans.SetRange(PRPeriodTrans."Employee Code", "HR-Employees"."No.");
                PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", 'E16');
                if PRPeriodTrans.FindFirst() then begin
                    SubsistenceAllowance := PRPeriodTrans.Amount;
                end;
                PRPeriodTrans.Reset;
                PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period", PeriodFilter);
                PRPeriodTrans.SetRange(PRPeriodTrans."Employee Code", "HR-Employees"."No.");
                PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", 'E26');
                if PRPeriodTrans.FindFirst() then begin
                    SubsistenceAllowance += PRPeriodTrans.Amount;
                end;
                //OTHER ALLOWANCE
                PRPeriodTrans.Reset;
                PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period", PeriodFilter);
                PRPeriodTrans.SetRange(PRPeriodTrans."Employee Code", "HR-Employees"."No.");
                PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", 'E18');
                if PRPeriodTrans.FindFirst() then begin
                    ExtrenousAllowance1 := PRPeriodTrans.Amount;
                end;
                //OTHER ALLOWANCE
                PRPeriodTrans.Reset;
                PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period", PeriodFilter);
                PRPeriodTrans.SetRange(PRPeriodTrans."Employee Code", "HR-Employees"."No.");
                PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", 'E19');
                if PRPeriodTrans.FindFirst() then begin
                    TransferAllowance1 := PRPeriodTrans.Amount;
                end;

                //OTHER ALLOWANCE
                PRPeriodTrans.Reset;
                PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period", PeriodFilter);
                PRPeriodTrans.SetRange(PRPeriodTrans."Employee Code", "HR-Employees"."No.");
                PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", 'E20');
                if PRPeriodTrans.FindFirst() then begin
                    SalaryArrearsAllowance := PRPeriodTrans.Amount;
                end;
                //OTHER ALLOWANCE
                PRPeriodTrans.Reset;
                PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period", PeriodFilter);
                PRPeriodTrans.SetRange(PRPeriodTrans."Employee Code", "HR-Employees"."No.");
                PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", 'E22');
                if PRPeriodTrans.FindFirst() then begin
                    ResponsibilityAllowance1 := PRPeriodTrans.Amount;
                end;
                //OTHER ALLOWANCE
                PRPeriodTrans.Reset;
                PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period", PeriodFilter);
                PRPeriodTrans.SetRange(PRPeriodTrans."Employee Code", "HR-Employees"."No.");
                PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", 'E23');
                if PRPeriodTrans.FindFirst() then begin
                    ArrearsEarningAllowance := PRPeriodTrans.Amount;
                end;
                //OTHER ALLOWANCE
                PRPeriodTrans.Reset;
                PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period", PeriodFilter);
                PRPeriodTrans.SetRange(PRPeriodTrans."Employee Code", "HR-Employees"."No.");
                PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", 'E24');
                if PRPeriodTrans.FindFirst() then begin
                    OtherAllowance1 := PRPeriodTrans.Amount;
                end;
                //OTHER ALLOWANCE
                PRPeriodTrans.Reset;
                PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period", PeriodFilter);
                PRPeriodTrans.SetRange(PRPeriodTrans."Employee Code", "HR-Employees"."No.");
                PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", 'E25');
                if PRPeriodTrans.FindFirst() then begin
                    RenumerationAllowance := PRPeriodTrans.Amount;
                end;
                //OTHER ALLOWANCE
                PRPeriodTrans.Reset;
                PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period", PeriodFilter);
                PRPeriodTrans.SetRange(PRPeriodTrans."Employee Code", "HR-Employees"."No.");
                PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", 'E25ARREARS');
                if PRPeriodTrans.FindFirst() then begin
                    RenumerationArrearsAllowance := PRPeriodTrans.Amount;
                end;


                //OTHER ALLOWANCE
                PRPeriodTrans.Reset;
                PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period", PeriodFilter);
                PRPeriodTrans.SetRange(PRPeriodTrans."Employee Code", "HR-Employees"."No.");
                PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", 'E27');
                if PRPeriodTrans.FindFirst() then begin
                    OtherAllowance2 := PRPeriodTrans.Amount;
                end;
                //OTHER ALLOWANCE
                PRPeriodTrans.Reset;
                PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period", PeriodFilter);
                PRPeriodTrans.SetRange(PRPeriodTrans."Employee Code", "HR-Employees"."No.");
                PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", 'E31');
                if PRPeriodTrans.FindFirst() then begin
                    AirtimeAllowance1 := PRPeriodTrans.Amount;
                end;


                //Pension
                PRPeriodTrans.Reset;
                PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period", PeriodFilter);
                PRPeriodTrans.SetRange(PRPeriodTrans."Employee Code", "HR-Employees"."No.");
                PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", 'Pension');
                if PRPeriodTrans.FindFirst() then begin
                    Pension := PRPeriodTrans.Amount;
                end;


                AllOtherAllowances := EntertainmentAllowance + EntertainmentArrearsAllowance + HardshipAllowance + ExrenousAllowance + ResponsibilityAllowance +
                AirportAllowance + ActingAllowance + AirtimeAllowance + AirtimeArrearsAllowance + TransferAllowance + SpecialAllowance + SubsistenceAllowance +
                ExtrenousAllowance1 + TransferAllowance1 + SalaryArrearsAllowance + ResponsibilityAllowance1 + ArrearsEarningAllowance + OtherAllowance1 + RenumerationAllowance +
                RenumerationArrearsAllowance + SubsistenceAllowance1 + OtherAllowance2 + BasicPayArrears + HouseArrersAllowance1;

                TotalCashPay := AllOtherAllowances + BasicSalary + HouseAllowance + TransportAllowance + LeaveAllowance + OvertimeAllowance + Lumpsum + LeaveAllowanceAAR;

                TotalHouseArrersAllowance := HouseAllowance + HouseArrersAllowance + HouseArrersAllowance1;

                GlobalIncome := TotalCashPay + AirtimeAllowance1;

                PercentageofCash := 0.3 * GlobalIncome;

                //Include Voluntary Pension & Voluntary Pension & Pension
                PRTransCodes.Reset;
                PRTransCodes.SetFilter(PRTransCodes."Special Trans Deductions", '%1|%2'
                                      , (PRTransCodes."special Trans Deductions"::"Defined Contribution")
                                      , (PRTransCodes."special Trans Deductions"::"Voluntary Pension"));
                if PRTransCodes.FindFirst() then begin
                    repeat
                        PRPeriodTrans.Reset;
                        PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", PRTransCodes."Transaction Code");
                        PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period", 20200101D);
                        PRPeriodTrans.SetRange(PRPeriodTrans."Employee Code", "HR-Employees"."No.");
                        if PRPeriodTrans.FindFirst() then begin
                            Actualcontrib += PRPeriodTrans.Amount;
                        end;
                    until PRTransCodes.Next = 0;
                end;
                Actualcontrib += Pension;


                //Amount to Benefit
                E1 := 0.3 * GrossPay;
                E2 := Actualcontrib;
                E3 := 20000;

                //Column G - Get least between e1,E2,e3
                if E1 > E2 then begin
                    AmountofBenefit := E2;
                end else begin
                    AmountofBenefit := E1;
                end;

                if E3 < AmountofBenefit then begin
                    AmountofBenefit := E3;
                end;
                AmountofBenefit += MORG;
                //Amount to Benefit



                //Taxable Payable
                PRPeriodTrans.Reset;
                PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period", PeriodFilter);
                PRPeriodTrans.SetRange(PRPeriodTrans."Employee Code", "HR-Employees"."No.");
                PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", 'TXBP');
                if PRPeriodTrans.FindFirst() then begin
                    KraTaxablepay := PRPeriodTrans.Amount;
                end;

                //TaxPayable
                PRPeriodTrans.Reset;
                PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period", PeriodFilter);
                PRPeriodTrans.SetRange(PRPeriodTrans."Employee Code", "HR-Employees"."No.");
                PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code", 'TXCHRG');
                if PRPeriodTrans.FindFirst() then begin
                    TotTaxPayable := PRPeriodTrans.Amount;
                end;
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
        PRTransCodes: Record "PR Transaction Codes";
        CompInfo: Record "Company Information";
        PeriodFilter: Date;
        HREmp: Record "HR-Employee";
        EmpFullName: Text;
        PRPeriodTrans: Record "PR Period Transactions";
        BasicSalary: Decimal;
        HouseAllowance: Decimal;
        TransportAllowance: Decimal;
        TotalTransportAllowance: Integer;
        CommuterArrearsAllowance: Decimal;
        LeaveAllowance: Decimal;
        OvertimeAllowance: Decimal;
        OtherAllowance: Decimal;
        TotalCashPay: Decimal;
        Actualcontrib: Decimal;
        GrossPay: Decimal;
        TaxablePay: Decimal;
        TaxCharged: Decimal;
        MonthlyRelief: Decimal;
        InsuranceRelief: Decimal;
        PAYE: Decimal;
        MORG: Decimal;
        BPA: Decimal;
        CombinedBasic: Decimal;
        OtherNoncash: Decimal;
        Lumpsum: Decimal;
        EntertainmentAllowance: Decimal;
        EntertainmentArrearsAllowance: Decimal;
        HardshipAllowance: Decimal;
        ExrenousAllowance: Decimal;
        ResponsibilityAllowance: Decimal;
        AirportAllowance: Decimal;
        ActingAllowance: Decimal;
        AirtimeAllowance: Decimal;
        AirtimeArrearsAllowance: Decimal;
        TransferAllowance: Decimal;
        LeaveAllowanceAAR: Decimal;
        SpecialAllowance: Decimal;
        SubsistenceAllowance: Decimal;
        ExtrenousAllowance1: Decimal;
        TransferAllowance1: Decimal;
        SalaryArrearsAllowance: Decimal;
        ResponsibilityAllowance1: Decimal;
        ArrearsEarningAllowance: Decimal;
        OtherAllowance1: Decimal;
        RenumerationAllowance: Decimal;
        RenumerationArrearsAllowance: Decimal;
        SubsistenceAllowance1: Decimal;
        OtherAllowance2: Decimal;
        AirtimeAllowance1: Decimal;
        AllOtherAllowances: Decimal;
        NetPay: Decimal;
        HouseArrersAllowance: Decimal;
        HouseArrersAllowance1: Decimal;
        TotalHouseArrersAllowance: Decimal;
        GlobalIncome: Decimal;
        PercentageofCash: Decimal;
        //PensionVol: Decimal;
        PensionVol: Decimal;
        Pension: Decimal;
        AmountofBenefit: Decimal;
        KraTaxablepay: Decimal;
        TaxPayable: Decimal;
        TaxPayable1: Decimal;
        TaxPayable2: Decimal;
        TaxPayable3: Decimal;
        TaxPayable4: Decimal;
        TotTaxPayable: Decimal;
        "p.a.y.e.kra": Decimal;
        E1: Decimal;
        E2: Decimal;
        E3: Decimal;
        BasicPayArrears: Decimal;

    procedure fnCompanyInfo()
    begin
        CompInfo.Reset;
        if CompInfo.Get then
            CompInfo.CalcFields(CompInfo.Picture);
    end;
}

