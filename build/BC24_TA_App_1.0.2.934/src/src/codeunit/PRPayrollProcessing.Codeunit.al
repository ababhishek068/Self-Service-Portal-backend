Codeunit 50010 "PR Payroll Processing"
{
    // ++Note
    // Tax on Excess Pension Not Clear /Not indicated anywhere
    // Low Interest Benefits
    // VOQ
    trigger OnRun()
    begin

    end;

    var
        VitalSetup: Record "PR Vital Setup Info";
        currNHIFRelief: Decimal;
        curReliefPersonal: Decimal;
        curReliefInsurance: Decimal;
        curReliefMorgage: Decimal;
        curMaximumRelief: Decimal;
        currMinRelief: Decimal;
        curPensionEmployee: Decimal;
        curPension_Employer_Factor: Decimal;
        costshare: Decimal;
        costsharecheck: Boolean;
        intNHIF_BasedOn: Option Gross,Basic,"Taxable Pay";
        intPension_BasedOn: Option Gross,Basic;
        curDisabledLimit: Decimal;
        curMaxPensionContrib: Decimal;
        curRateTaxExPension: Decimal;
        curOOIMaxMonthlyContrb: Decimal;
        curOOIDecemberDedc: Decimal;
        curLoanMarketRate: Decimal;
        curLoanCorpRate: Decimal;
        TaxAccount: Code[50];
        salariesAcc: Code[50];
        socialcontributionAcc: code[50];
        PayablesAcc: Code[50];
        PensionEMPyer: Code[50];
        //PensionEMPyer: Code[50];
        PensionEMPyee: Code[50];
        transportllAcc: code[50];
        costshareacc: Code[50];
        loanguaranteeacc: code[50];
        NHIFEMPyee: Code[50];
        PensionRate: Decimal;
        penemployee: Decimal;
        penemployer: Decimal;
        PensionUEL: Decimal;
        PensionLEL: Decimal;
        ImplementNewPension: Boolean;
        CoopParameters: Option "none",shares,loan,"loan Interest","Emergency loan","Emergency loan Interest","School Fees loan","School Fees loan Interest",Welfare,Pension,nssf;
        PostingGroup: Record "PR Employee Posting Groups";
        HREmp2: Record "HR-Employee";
        curTransSubledger: Option " ",Customer,Vendor;
        curTransSubledgerAccount: Code[50];
        PRSalCard_Disability: Record "PR Salary Card";
        HRBankSummary: Record "HR Bank Summary";
        PRSalCard_2: Record "PR Salary Card";
        curMorgageRelief: Decimal;
        PRTransCode_2: Record "PR Transaction Codes";
        PREmpTrans_INT: Record "PR Employee Transactions";
        PREmpTrans_2: Record "PR Employee Transactions";
        BenifitAmount: Decimal;
        HREmp: Record "HR-Employee";
        PRTransCodeForm: Record "PR Transaction Codes Formula";
        curDefinedContrib_2: Decimal;
        curdefinedcontrib_1: decimal;
        totalcurGross: Decimal;

    procedure fnBasicPayProrated(strEmpCode: Code[50]; Month: Integer; Year: Integer; BasicSalary: Decimal; DaysWorked: Integer; DaysInMonth: Integer) ProratedAmt: Decimal
    begin
        //ProratedAmt := ROUND((DaysWorked / DaysInMonth) * BasicSalary, 0.05, '=');
        // ProratedAmt := ((DaysWorked + 1) / 30) * BasicSalary;
        // Message(Format(DaysWorked)+'-->'+Format(DaysInMonth));
        //DaysWorked:=DaysWorked+1;
        DaysInMonth := 30;
        ProratedAmt := (DaysWorked / DaysInMonth) * BasicSalary;
        //Message(Format(ProratedAmt));
    end;

    procedure fnCalcLoanInterest(strEmpCode: Code[50]; strTransCode: Code[50]; InterestRate: Decimal; RecoveryMethod: Option Reducing,"Straight line",Amortized; LoanAmount: Decimal; Balance: Decimal; CurrPeriod: Date) LnInterest: Decimal
    var
        curLoanInt: Decimal;
        intMonth: Integer;
        intYear: Integer;
    begin
        intMonth := Date2dmy(CurrPeriod, 2);
        intYear := Date2dmy(CurrPeriod, 3);
        curLoanInt := 0;
        if InterestRate > 0 then begin
            if RecoveryMethod = Recoverymethod::"Straight line" then //Straight Line Method [1]
                curLoanInt := (InterestRate / 1200) * LoanAmount;

            if RecoveryMethod = Recoverymethod::Reducing then //Reducing Balance [0]

                 curLoanInt := ((InterestRate / 12) / 100) * Balance;

            if RecoveryMethod = Recoverymethod::Amortized then //Amortized [2]
                curLoanInt := (InterestRate / 100) * Balance;

        end else
            curLoanInt := 0;

        //Return the Amount
        LnInterest := ROUND(curLoanInt, 2);
    end;

    procedure fnClosePayrollPeriod(dtOpenPeriod: Date) Closed: Boolean
    var
        dtNewPeriod: Date;
        intNewMonth: Integer;
        intNewYear: Integer;
        prEmployeeTransactions: Record "PR Employee Transactions";
        intMonth: Integer;
        intYear: Integer;
        prTransactionCodes: Record "PR Transaction Codes";
        curTransAmount: Decimal;
        curTransBalance: Decimal;
        EmpTrans: Record "PR Employee Transactions";
        prPayrollPeriods: Record "PR Payroll Periods";
        prNewPayrollPeriods: Record "PR Payroll Periods";
        curTransName: text;
        CurInsuranceCert: Enum "Has Insurance Certificate";
    begin
        //MESSAGE('Also include function to reset No. of days worked');
        dtNewPeriod := CalcDate('1M', dtOpenPeriod);
        intNewMonth := Date2dmy(dtNewPeriod, 2);
        //intNewWeeK := Date2dwy(dtNewPeriod, 2);
        intNewYear := Date2dmy(dtNewPeriod, 3);
        //intWeek := Date2dwy(dtOpenPeriod, 2);
        intMonth := Date2dmy(dtOpenPeriod, 2);
        intYear := Date2dmy(dtOpenPeriod, 3);
        prEmployeeTransactions.Reset;
        prEmployeeTransactions.SetRange(prEmployeeTransactions."Period Month", intMonth);
        prEmployeeTransactions.SetRange(prEmployeeTransactions."Period Year", intYear);
        prEmployeeTransactions.SetRange(prEmployeeTransactions.Suspended, false);
        prEmployeeTransactions.SetRange(prEmployeeTransactions.Stopped, false);
        prEmployeeTransactions.SetRange(prEmployeeTransactions."Payroll Period", dtOpenPeriod);
        if prEmployeeTransactions.FindFirst() then begin
            repeat
                //Added
                Clear(curTransAmount);
                Clear(curTransBalance);
                Clear(CurInsuranceCert);
                Clear(curTransName);

                CurInsuranceCert := prEmployeeTransactions."Has Insurance Certificate";
                curTransName := prEmployeeTransactions."Transaction Name";
                //Added
                prTransactionCodes.Reset;
                prTransactionCodes.SetRange(prTransactionCodes."Transaction Code", prEmployeeTransactions."Transaction Code");
                if prTransactionCodes.FindFirst() then begin
                    //with prTransactionCodes do begin
                    case prTransactionCodes."Balance Type" of
                        prTransactionCodes."balance type"::None:
                            begin
                                curTransAmount := prEmployeeTransactions.Amount;
                                //curTransBalance := prEmployeeTransactions.Balance ;
                            end;
                        prTransactionCodes."balance type"::Increasing:
                            begin
                                curTransAmount := prEmployeeTransactions.Amount;
                                curTransBalance := prEmployeeTransactions.Balance + prEmployeeTransactions.Amount;
                                //****
                                //Added  to Include Subledger and Subledger Account for the next period
                                if prEmployeeTransactions.Subledger <> prEmployeeTransactions.Subledger::" " then begin
                                    curTransSubledger := prEmployeeTransactions.Subledger;
                                    curTransSubledgerAccount := prEmployeeTransactions."Subledger Account";
                                end;
                                //****

                            end;
                        prTransactionCodes."balance type"::Reducing:
                            begin
                                curTransAmount := prEmployeeTransactions.Amount;
                                if prEmployeeTransactions.Balance <= prEmployeeTransactions.Amount then begin
                                    curTransAmount := prEmployeeTransactions.Balance;
                                    curTransBalance := 0;
                                end else begin
                                    curTransBalance := prEmployeeTransactions.Balance - prEmployeeTransactions.Amount;
                                end;
                                if curTransBalance < 0 then begin
                                    curTransAmount := 0;
                                    curTransBalance := 0;
                                end;
                            end;
                    end;
                    //end;
                end;

                //For those transactions with Start and End Date Specified
                if (prEmployeeTransactions."Start Date" <> 0D) and (prEmployeeTransactions."End Date" <> 0D) then begin
                    if prEmployeeTransactions."End Date" < dtNewPeriod then begin
                        curTransAmount := 0;
                        curTransBalance := 0;
                    end;
                end;
                //End Transactions with Start and End Date

                if (prTransactionCodes.Frequency = prTransactionCodes.Frequency::Fixed) and
                   (prEmployeeTransactions."Stop for Next Period" = false) then //DENNO ADDED THIS TO CHECK FREQUENCY AND STOP IF MARKED
                 begin
                    if (curTransAmount <> 0) then  //Update the employee transaction table
                     begin
                        if ((prTransactionCodes."Balance Type" = prTransactionCodes."balance type"::Reducing) and (curTransBalance <> 0)) or
                         (prTransactionCodes."Balance Type" <> prTransactionCodes."balance type"::Reducing) then
                            prEmployeeTransactions.Balance := curTransBalance;
                        prEmployeeTransactions.Modify;


                        //Insert record for the next period
                        //with prEmployeeTrans do begin
                        EmpTrans.Init;
                        EmpTrans."Employee Code" := prEmployeeTransactions."Employee Code";
                        EmpTrans."Transaction Code" := prEmployeeTransactions."Transaction Code";
                        EmpTrans."Transaction Name" := curTransName; //Modified
                        EmpTrans.Amount := curTransAmount;
                        EmpTrans.Balance := curTransBalance;
                        EmpTrans."Amortized Loan Total Repay Amt" := prEmployeeTransactions."Amortized Loan Total Repay Amt";
                        EmpTrans."Original Amount" := prEmployeeTransactions."Original Amount";
                        EmpTrans."Reference No" := prEmployeeTransactions."Reference No";
                        EmpTrans."Period Month" := intNewMonth;
                        EmpTrans."Period Year" := intNewYear;
                        EmpTrans."Payroll Period" := dtNewPeriod;
                        EmpTrans."Has Insurance Certificate" := CurInsuranceCert; //Modified
                        EmpTrans."Exempt from Interest" := prEmployeeTransactions."Exempt from Interest";
                        EmpTrans."Loan Interest Rate" := prEmployeeTransactions."Loan Interest Rate";
                        EmpTrans."Reference No" := prEmployeeTransactions."Reference No";
                        EmpTrans."Total Installments" := prEmployeeTransactions."Total Installments";
                        EmpTrans."Loan Application Date" := prEmployeeTransactions."Loan Application Date";
                        EmpTrans."Amount Borrowed" := prEmployeeTransactions."Amount Borrowed";

                        if curTransSubledger <> Curtranssubledger::" " then begin
                            EmpTrans.Subledger := curTransSubledger;
                            EmpTrans."Subledger Account" := curTransSubledgerAccount;
                        end;
                        //****
                        if prTransactionCodes."Skip Transfer in Next Period" = false then
                            EmpTrans.Insert;
                        //end;
                    end;
                end
            until prEmployeeTransactions.Next = 0;
        end;

        //Update the Period as Closed
        prPayrollPeriods.Reset;
        prPayrollPeriods.SetRange(prPayrollPeriods."Period Month", intMonth);
        prPayrollPeriods.SetRange(prPayrollPeriods."Period Year", intYear);
        prPayrollPeriods.SetRange(prPayrollPeriods.Closed, false);
        if prPayrollPeriods.FindFirst() then begin
            prPayrollPeriods.Closed := true;
            prPayrollPeriods."Date Closed" := Today;
            prPayrollPeriods."Closed By" := UserId;
            prPayrollPeriods.Modify;
        end;


        //Error('Manually Stopped');
        //Enter a New Period

        prNewPayrollPeriods.Init();
        prNewPayrollPeriods."Period Month" := intNewMonth;
        prNewPayrollPeriods."Period Year" := intNewYear;
        prNewPayrollPeriods."Period Name" := Format(dtNewPeriod, 0, '<Month Text>') + '' + Format(intNewYear);
        prNewPayrollPeriods."Date Opened" := dtNewPeriod;
        prNewPayrollPeriods."Opened By" := UserId;
        prNewPayrollPeriods.Closed := false;
        prNewPayrollPeriods.Insert;


        //Effect the transactions for the P9
        fnP9PeriodClosure(intMonth, intYear, dtOpenPeriod);

        //Take all the Negative pay (Net) for the current month & treat it as a deduction in the new period
        fnGetNegativePay(intMonth, intYear, dtOpenPeriod);


        /*
        //Reset no. of days worked for casuals
        PRSalCard.RESET;
        PRSalCard.SETRANGE(PRSalCard."Employee Contract Type",'CASUALS');
        IF PRSalCard.FINDFirst() THEN
        BEGIN
            REPEAT
                PRSalCard."No. of Days Worked":=0;
                PRSalCard.MODIFY;
            UNTIL PRSalCard.NEXT = 0;
        END;
        */

    end;

    procedure fnDaysInMonth(dtDate: Date) DaysInMonth: Integer
    var
        Day: Integer;
        SysDate: Record Date;
        Expr1: Text[30];
        FirstDay: Date;
        LastDate: Date;
        TodayDate: Date;
    begin
        TodayDate := dtDate;

        Day := Date2dmy(TodayDate, 1);
        Expr1 := Format(-Day) + 'D+1D';
        FirstDay := CalcDate(Expr1, TodayDate);
        LastDate := CalcDate('1M-1D', FirstDay);

        SysDate.Reset;
        SysDate.SetRange(SysDate."Period Type", SysDate."period type"::Date);
        SysDate.SetRange(SysDate."Period Start", FirstDay, LastDate);
        SysDate.SetFilter(SysDate."Period No.", '1..7');
        if SysDate.FindFirst() then
            DaysInMonth := SysDate.Count;
    end;

    procedure fnDaysWorked(dtDate: Date; IsTermination: Boolean) DaysWorked: Integer
    var
        Day: Integer;
        SysDate: Record Date;
        Expr1: Text[30];
        FirstDay: Date;
        LastDate: Date;
        TodayDate: Date;

    begin
        TodayDate := dtDate;
        Day := Date2dmy(TodayDate, 1);
        Expr1 := Format(-Day) + 'D+1D';
        FirstDay := CalcDate(Expr1, TodayDate);
        LastDate := CalcDate('1M-1D', FirstDay);
        SysDate.Reset;
        SysDate.SetRange(SysDate."Period Type", SysDate."period type"::Date);
        if not IsTermination then
            SysDate.SetRange(SysDate."Period Start", dtDate, LastDate)
        else
            SysDate.SetRange(SysDate."Period Start", FirstDay, dtDate);
        SysDate.SetFilter(SysDate."Period No.", '1..7');
        if SysDate.FindFirst() then
            DaysWorked := SysDate.Count;
    end;

    procedure fnDisplayFrmlValues(EmpCode: Code[30]; intMonth: Integer; intYear: Integer; Formula: Text[50]) curTransAmount: Decimal
    var
        pureformula: Text[50];
    begin
        pureformula := fnPureFormula(EmpCode, intMonth, intYear, Formula);
        curTransAmount := fnFormulaResult(pureformula); //Get the calculated amount
        curTransAmount := ROUND(curTransAmount, 0.05, '=');
    end;

    procedure fnFormulaResult(strFormula: Text[250]) Results: Decimal
    var
        AccSchedLine: Record "Acc. Schedule Line";
        ColumnLayout: Record "Column Layout";
        CalcAddCurr: Boolean;
        AccSchedMgt: Codeunit AccSchedManagement_CU;
    //New Changes   
    begin
        Results := AccSchedMgt.EvaluateExpression(true, strFormula, AccSchedLine, ColumnLayout, CalcAddCurr);

    end;

    procedure fnGetEmployeeNHIF(curBaseAmount: Decimal) NHIF: Decimal
    var
        prNHIF: Record "PR Income Tax";
    begin
        prNHIF.Reset;
        prNHIF.SetCurrentkey(prNHIF."Tier Code");
        prNHIF.Findset(false, false);
        begin
            repeat
                if ((curBaseAmount >= prNHIF."Lower Limit") and (curBaseAmount <= prNHIF."Upper Limit")) then
                    NHIF := (prNHIF.Rate / 100) * curBaseAmount;
            until prNHIF.Next = 0;
        end;
    end;

    procedure fnGetEmployeePension(curBaseAmount: Decimal) Pension: Decimal
    var
        prPension: Record "PR Pension";
    // begin
    //     IF ImplementNewPension THEN BEGIN
    //         if (curBaseAmount <= PensionLEL) then
    //             Pension := ROUND((curBaseAmount * (PensionRate / 100)), 1)
    //         else
    //             if (curBaseAmount > PensionLEL) AND (curBaseAmount <= PensionUEL)
    //        then
    //                 Pension := ROUND(((curBaseAmount - PensionLEL) * (PensionRate / 100)) + (PensionLEL * (PensionRate / 100)), 1)
    //             ELSE
    //                 Pension := ROUND(((PensionUEL - PensionLEL) * (PensionRate / 100)) + (PensionLEL * (PensionRate / 100)), 1);
    //     end else begin
    //         prPension.Reset;
    //         prPension.SetCurrentkey(prPension.Tier);
    //         prPension.findset(false, false);
    //         begin
    //             repeat
    //                 if ((curBaseAmount >= prPension."Lower Limit") and (curBaseAmount <= prPension."Upper Limit")) then
    //                     Pension := prPension."Tier 1 Employer Contribution" + prPension."Tier 2 Employer Contribution";
    //             until prPension.Next = 0;
    //         end;

    //     end;
    // end;
    //Use Ethiopia pension policy
    begin
        Pension := (penemployee / 100) * curBaseAmount;

    end;

    procedure fnGetEmployeePaye(curTaxablePay: Decimal) PAYE: Decimal
    var
        //     prPAYE: Record "PR PAYE";
        //     curTempAmount: Decimal;
        //     KeepCount: Integer;
        // begin
        //     KeepCount := 0;

        //     prPAYE.Reset;
        //     prPAYE.FindSet(false, false);
        //     begin
        //         if curTaxablePay < prPAYE."PAYE Tier" then exit;
        //         repeat
        //             KeepCount += 1;

        //             curTempAmount := curTaxablePay;

        //             if curTaxablePay = 0 then exit;
        //             if KeepCount = prPAYE.Count then   //this is the last record or loop
        //                 curTaxablePay := curTempAmount
        //             else
        //                 if curTempAmount >= prPAYE."PAYE Tier" then
        //                     curTempAmount := prPAYE."PAYE Tier"
        //                 else
        //                     curTempAmount := curTempAmount;

        //             PAYE := PAYE + (curTempAmount * (prPAYE.Rate / 100));

        //             curTaxablePay := curTaxablePay - curTempAmount;

        //         until prPAYE.Next = 0;
        //     end;
        //Use  Ethiopian Income tax calculations
        prNHIF: Record "PR Income Tax";
    begin
        prNHIF.Reset;
        prNHIF.SetCurrentkey(prNHIF."Tier Code");
        prNHIF.Findset(false, false);
        begin
            repeat
                if ((curTaxablePay >= prNHIF."Lower Limit") and (curTaxablePay <= prNHIF."Upper Limit")) then
                    PAYE := ((prNHIF.Rate / 100) * curTaxablePay) - prNHIF.Relief;
            until prNHIF.Next = 0;
        end;
    end;

    procedure fnGetEmployerPension(curBaseAmount: Decimal) Pension: Decimal
    var
        prPension: Record "PR Pension";
    // begin
    //     IF ImplementNewPension THEN BEGIN
    //         if (curBaseAmount <= PensionLEL) then
    //             Pension := ROUND((curBaseAmount * (PensionRate / 100)), 1)
    //         else
    //             if (curBaseAmount > PensionLEL) AND (curBaseAmount <= PensionUEL)
    //        then
    //                 Pension := ROUND(((curBaseAmount - PensionLEL) * (PensionRate / 100)) + (PensionLEL * (PensionRate / 100)), 1)
    //             ELSE
    //                 Pension := ROUND(((PensionUEL - PensionLEL) * (PensionRate / 100)) + (PensionLEL * (PensionRate / 100)), 1);
    //     end else begin
    //         prPension.Reset;
    //         prPension.SetCurrentkey(prPension.Tier);
    //         prPension.findset(false, false);
    //         begin
    //             repeat
    //                 if ((curBaseAmount >= prPension."Lower Limit") and (curBaseAmount <= prPension."Upper Limit")) then
    //                     Pension := prPension."Tier 1 Employer Contribution" + prPension."Tier 2 Employer Contribution";
    //             until prPension.Next = 0;
    //         end;

    //     end;
    // end;
    begin
        Pension := (penemployer / 100) * curBaseAmount;
    end;


    procedure fnGetJournalDet(strEmpCode: Code[50])
    var
        HREmp: Record "HR-Employee";
    begin
        //Get Payroll Posting Accounts
        //IF SalaryCard.GET(strEmpCode) THEN BEGIN
        if HREmp.Get(strEmpCode) then begin
            PostingGroup.Get(HREmp."Payroll Posting Group");
            begin
                //Comment This for the Time Being
                PostingGroup.TestField("Salary Account");
                PostingGroup.TestField("Income Tax Account");
                PostingGroup.TestField("Net Salary Payable");
                PostingGroup.TestField("SSF Employer Account");
                PostingGroup.TestField("Pension Employer Acc");
                PostingGroup.TestField("Transport/Fuel Allowance Ac");
                PostingGroup.TestField("Cost Share Payable Acc");
                PostingGroup.TestField("Social Contribution Acc");
                TaxAccount := PostingGroup."Income Tax Account";
                salariesAcc := PostingGroup."Salary Account";
                PayablesAcc := PostingGroup."Net Salary Payable";
                socialcontributionAcc := PostingGroup."Social Contribution Acc";
                PensionEMPyee := PostingGroup."SSF Employee Account";
                NHIFEMPyee := PostingGroup."NHIF Employee Account";
                PensionEMPyer := PostingGroup."Pension Employer Acc";
                transportllAcc := PostingGroup."Transport/Fuel Allowance Ac";
                costshareacc := PostingGroup."Cost Share Payable Acc";
            end;
        end;
        //End Get Payroll Posting Accounts
    end;

    procedure fnGetNegativePay(intMonth: Integer; intYear: Integer; dtOpenPeriod: Date)
    var
        prPeriodTransactions: Record "PR Period Transactions";
        prEmployeeTransactions: Record "PR Employee Transactions";
        intNewMonth: Integer;
        intNewYear: Integer;
        dtNewPeriod: Date;
    begin
        dtNewPeriod := CalcDate('1M', dtOpenPeriod);
        intNewMonth := Date2dmy(dtNewPeriod, 2);
        intNewYear := Date2dmy(dtNewPeriod, 3);

        prPeriodTransactions.Reset;
        prPeriodTransactions.SetRange(prPeriodTransactions."Period Month", intMonth);
        prPeriodTransactions.SetRange(prPeriodTransactions."Period Year", intYear);
        prPeriodTransactions.SetRange(prPeriodTransactions."Group Order", 9);
        prPeriodTransactions.SetFilter(prPeriodTransactions.Amount, '<0');

        if prPeriodTransactions.FindFirst() then begin
            repeat

                prEmployeeTransactions.Init();
                ;
                prEmployeeTransactions."Employee Code" := prPeriodTransactions."Employee Code";
                prEmployeeTransactions."Transaction Code" := 'NEGP';
                prEmployeeTransactions."Transaction Name" := 'Negative Pay';
                prEmployeeTransactions.Amount := prPeriodTransactions.Amount;
                prEmployeeTransactions.Balance := 0;
                prEmployeeTransactions."Original Amount" := 0;
                prEmployeeTransactions."Period Month" := intNewMonth;
                prEmployeeTransactions."Period Year" := intNewYear;
                prEmployeeTransactions."Payroll Period" := dtNewPeriod;
                prEmployeeTransactions.Insert;

            until prPeriodTransactions.Next = 0;
        end;
    end;

    procedure fnGetOpenPeriod() dtOpenPeriod: Date
    var
        "prPayroll Periods": Record "PR Payroll Periods";
        intMonth: Integer;
        intYear: Integer;
    begin
        "prPayroll Periods".Reset;
        "prPayroll Periods".SetRange("prPayroll Periods".Closed, false);

        if "prPayroll Periods".FindFirst() then begin
            dtOpenPeriod := "prPayroll Periods"."Date Opened";
            intMonth := Date2dmy(dtOpenPeriod, 2); //GET THE MONTH
            intYear := Date2dmy(dtOpenPeriod, 3);  //GET THE YEAR
        end
        else begin
            Error('There is no open payroll period');
        end
    end;

    procedure fnGetSpecialTransAmount(strEmpCode: Code[50]; intMonth: Integer; intYear: Integer; intSpecTransID: Option "None","Defined Contribution","Home Ownership Savings Plan","Life Insurance","Owner Occupier Interest","Prescribed Benefit","Salary Arrears","Staff Loan (Interest Varies)","Value of Quarters",Mortgage,"Voluntary Pension","Mortgage Relief"; blnCompDedc: Boolean) SpecialTransAmount: Decimal
    var
        prEmployeeTransactions: Record "PR Employee Transactions";
        prTransactionCodes: Record "PR Transaction Codes";
        strExtractedFrml: Text[250];
        MortgageInterest: Decimal;
        MortgageRelief: Decimal;
    begin
        SpecialTransAmount := 0;
        prTransactionCodes.Reset;
        prTransactionCodes.SetRange(prTransactionCodes."Special Trans Deductions", intSpecTransID);
        if prTransactionCodes.FindFirst() then begin
            repeat
                prEmployeeTransactions.Reset;
                prEmployeeTransactions.SetRange(prEmployeeTransactions."Employee Code", strEmpCode);
                prEmployeeTransactions.SetRange(prEmployeeTransactions."Transaction Code", prTransactionCodes."Transaction Code");
                prEmployeeTransactions.SetRange(prEmployeeTransactions."Period Month", intMonth);
                prEmployeeTransactions.SetRange(prEmployeeTransactions."Period Year", intYear);
                prEmployeeTransactions.SetRange(prEmployeeTransactions.Stopped, false); //Added  to not process Stopped Transactions
                if prEmployeeTransactions.FindFirst() then begin

                    //Ignore,Defined Contribution,Home Ownership Savings Plan,Life Insurance,
                    //Owner Occupier Interest,Prescribed Benefit,Salary Arrears,Staff Loan,Value of Quarters
                    case intSpecTransID of
                        Intspectransid::"Defined Contribution":
                            if prTransactionCodes."Is Formula" then begin
                                strExtractedFrml := '';
                                strExtractedFrml := fnPureFormula(strEmpCode, intMonth, intYear, prTransactionCodes.Formula);
                                SpecialTransAmount := SpecialTransAmount + (fnFormulaResult(strExtractedFrml)); //Get the calculated amount for the Special Transaction
                            end else
                                SpecialTransAmount := SpecialTransAmount + prEmployeeTransactions.Amount;

                        Intspectransid::"Life Insurance": //You have to specify on Employee Transactions whether staff has brought his her certificate
                            begin
                                prEmployeeTransactions.TestField("Has Insurance Certificate");
                                if prEmployeeTransactions."Has Insurance Certificate" = prEmployeeTransactions."Has Insurance Certificate"::Yes then begin
                                    SpecialTransAmount := SpecialTransAmount + ((curReliefInsurance / 100) * prEmployeeTransactions.Amount);
                                end;
                            end;


                        Intspectransid::"Owner Occupier Interest":
                            SpecialTransAmount := SpecialTransAmount + prEmployeeTransactions.Amount;


                        Intspectransid::"Home Ownership Savings Plan":
                            begin
                                SpecialTransAmount := SpecialTransAmount + prEmployeeTransactions.Amount;
                                //Modified Dann
                                if SpecialTransAmount > 4000 then SpecialTransAmount := 4000;
                            end;
                        Intspectransid::"Voluntary Pension":
                            begin
                                SpecialTransAmount := SpecialTransAmount + prEmployeeTransactions.Amount;
                                if SpecialTransAmount >= curMaxPensionContrib then begin
                                    //If Pension is > 20 then less Pension
                                    SpecialTransAmount := curMaxPensionContrib - curDefinedContrib_2;
                                end;
                            end;


                        Intspectransid::Mortgage:
                            begin
                                SpecialTransAmount := SpecialTransAmount + curReliefMorgage;

                                if SpecialTransAmount > curReliefMorgage then begin
                                    SpecialTransAmount := curReliefMorgage
                                end;
                            end;

                        //Dann
                        Intspectransid::"Mortgage Relief":
                            begin
                                //Intrest = 6%/12 * Curr Balance
                                MortgageInterest := (0.06 / 12) * prEmployeeTransactions.Balance;

                                if MortgageInterest < curReliefMorgage then begin
                                    MortgageRelief := 0.3 * MortgageInterest;
                                end;

                                if MortgageInterest > curReliefMorgage then begin
                                    MortgageRelief := 0.3 * curReliefMorgage;
                                end;

                                SpecialTransAmount := ROUND(MortgageRelief, 0.05, '=')

                            end;
                    //Dann

                    end;
                end;
            until prTransactionCodes.Next = 0;
        end;
    end;

    procedure fnGetTransAmount(strEmpCode: Code[50]; strTransCode: Code[50]; intMonth: Integer; intYear: Integer) TransAmount: Decimal
    var
        prEmployeeTransactions: Record "PR Employee Transactions";
        prPeriodTransactions: Record "PR Period Transactions";
        prSalCard: Record "PR Salary Card";
    begin
        prEmployeeTransactions.Reset;
        prEmployeeTransactions.SetRange(prEmployeeTransactions."Employee Code", strEmpCode);
        prEmployeeTransactions.SetRange(prEmployeeTransactions."Transaction Code", strTransCode);
        prEmployeeTransactions.SetRange(prEmployeeTransactions."Period Month", intMonth);
        prEmployeeTransactions.SetRange(prEmployeeTransactions."Period Year", intYear);
        prEmployeeTransactions.SetRange(prEmployeeTransactions.Stopped, false); //Added  to not process Stopped Transactions
        if prEmployeeTransactions.FindFirst then
            TransAmount := prEmployeeTransactions.Amount;

        if TransAmount = 0 then begin
            prPeriodTransactions.Reset;
            prPeriodTransactions.SetRange(prPeriodTransactions."Employee Code", strEmpCode);
            prPeriodTransactions.SetRange(prPeriodTransactions."Transaction Code", strTransCode);
            prPeriodTransactions.SetRange(prPeriodTransactions."Period Month", intMonth);
            prPeriodTransactions.SetRange(prPeriodTransactions."Period Year", intYear);
            if prPeriodTransactions.FindFirst then
                TransAmount := prPeriodTransactions.Amount;
        end;

        if TransAmount = 0 then begin
            IF strTransCode = 'BPAY' THEN begin
                prSalCard.Reset;
                prSalCard.SetRange(prSalCard."Employee Code", strEmpCode);

                if prSalCard.FindFirst then
                    TransAmount := prSalCard."Basic Pay";
            end;
        end;
    end;

    procedure fnInitialize()
    begin

        //Initialize Global Setup Items
        VitalSetup.FindFirst;

        // <<< 26th-April-2020
        //VitalSetup.TestField("Minimum Taxable Pay");
        //>>>
        curReliefPersonal := VitalSetup."Tax Relief";
        curReliefInsurance := VitalSetup."Insurance Relief";
        curReliefMorgage := VitalSetup."Mortgage Relief"; //Same as HOSP
        curMaximumRelief := VitalSetup."Max Relief";
        curPensionEmployee := VitalSetup."Pension Employee";
        curPension_Employer_Factor := VitalSetup."Pension Employer Factor";
        intNHIF_BasedOn := VitalSetup."NHIF Based on";
        intPension_BasedOn := VitalSetup."Pension Based on";
        curMaxPensionContrib := VitalSetup."Max Pension Contribution";
        curRateTaxExPension := VitalSetup."Tax On Excess Pension";
        curOOIMaxMonthlyContrb := VitalSetup."OOI Deduction";
        curOOIDecemberDedc := VitalSetup."OOI December";
        curLoanMarketRate := VitalSetup."Loan Market Rate";
        curLoanCorpRate := VitalSetup."Loan Corporate Rate";
        currMinRelief := VitalSetup."Minimum Relief Amount";
        curDisabledLimit := VitalSetup."Disbled Tax Limit";
        PensionRate := VitalSetup."Pension Rate";
        loanguaranteeacc := VitalSetup."Guarantee Recovery code";
        penemployee := VitalSetup."Pension Employee";
        penemployer := VitalSetup."Pension Employer Factor";
        PensionLEL := VitalSetup."Pension Lower Earning Limit(LEL)";
        PensionUEL := VitalSetup."Pension Upper Earning Limit(UEL)";
        ImplementNewPension := VitalSetup."Implement New Pension";



    end;

    procedure fnP9PeriodClosure(intMonth: Integer; intYear: Integer; dtCurPeriod: Date)
    var
        P9BasicPay: Decimal;
        P9Allowances: Decimal;
        P9Benefits: Decimal;
        P9ValueOfQuarters: Decimal;
        P9DefinedContribution: Decimal;
        P9OwnerOccupierInterest: Decimal;
        P9GrossPay: Decimal;
        P9TaxablePay: Decimal;
        P9TaxCharged: Decimal;
        P9InsuranceRelief: Decimal;
        P9TaxRelief: Decimal;
        P9Paye: Decimal;
        P9Pension: Decimal;
        P9NHIF: Decimal;
        P9Deductions: Decimal;
        P9NetPay: Decimal;
        prPeriodTransactions: Record "PR Period Transactions";
        prEmployee: Record "HR-Employee";
    begin
        P9BasicPay := 0;
        P9Allowances := 0;
        P9Benefits := 0;
        P9ValueOfQuarters := 0;
        P9DefinedContribution := 0;
        P9OwnerOccupierInterest := 0;
        P9GrossPay := 0;
        P9TaxablePay := 0;
        P9TaxCharged := 0;
        P9InsuranceRelief := 0;
        P9TaxRelief := 0;
        P9Paye := 0;
        P9Pension := 0;
        P9NHIF := 0;
        P9Deductions := 0;
        P9NetPay := 0;

        Clear(prEmployee);
        //prEmployee.Reset();
        prEmployee.SetRange(prEmployee.Status, prEmployee.Status::Active);
        //prEmployee.SetRange(Status, prEmployee.Status::Active);
        //prEmployee.SETFILTER(prEmployee."Employee Contract Type",'<>%1','CASUALS'); //Remove
        if prEmployee.FindFirst() then begin
            repeat

                P9BasicPay := 0;
                P9Allowances := 0;
                P9Benefits := 0;
                P9ValueOfQuarters := 0;
                P9DefinedContribution := 0;
                P9OwnerOccupierInterest := 0;
                P9GrossPay := 0;
                P9TaxablePay := 0;
                P9TaxCharged := 0;
                P9InsuranceRelief := 0;
                P9TaxRelief := 0;
                P9Paye := 0;
                P9Pension := 0;
                P9NHIF := 0;
                P9Deductions := 0;
                P9NetPay := 0;

                prPeriodTransactions.Reset;
                prPeriodTransactions.SetRange(prPeriodTransactions."Employee Code", prEmployee."No.");
                prPeriodTransactions.SetRange(prPeriodTransactions."Period Month", intMonth);
                prPeriodTransactions.SetRange(prPeriodTransactions."Period Year", intYear);
                if prPeriodTransactions.FindFirst() then begin
                    repeat

                        case prPeriodTransactions."Group Order" of
                            1: //Basic pay & Arrears
                                begin
                                    if prPeriodTransactions."Sub Group Order" = 1 then P9BasicPay := prPeriodTransactions.Amount; //Basic Pay
                                    if prPeriodTransactions."Sub Group Order" = 2 then P9BasicPay := P9BasicPay + prPeriodTransactions.Amount; //Basic Pay Arrears
                                end;
                            3:  //Allowances
                                begin
                                    P9Allowances := P9Allowances + prPeriodTransactions.Amount
                                end;
                            4: //Gross Pay
                                begin
                                    P9GrossPay := prPeriodTransactions.Amount
                                end;
                            6: //Taxation
                                begin
                                    if prPeriodTransactions."Sub Group Order" = 1 then P9DefinedContribution := prPeriodTransactions.Amount; //Defined Contribution
                                    if prPeriodTransactions."Sub Group Order" = 9 then P9TaxRelief := prPeriodTransactions.Amount; //Tax Relief
                                    if prPeriodTransactions."Sub Group Order" = 8 then P9InsuranceRelief := prPeriodTransactions.Amount; //Insurance Relief
                                    if prPeriodTransactions."Sub Group Order" = 6 then P9TaxablePay := prPeriodTransactions.Amount; //Taxable Pay
                                    if prPeriodTransactions."Sub Group Order" = 7 then P9TaxCharged := prPeriodTransactions.Amount; //Tax Charged
                                end;
                            7: //Statutories
                                begin
                                    if prPeriodTransactions."Sub Group Order" = 1 then P9Pension := prPeriodTransactions.Amount; //Pension
                                    if prPeriodTransactions."Sub Group Order" = 2 then P9NHIF := prPeriodTransactions.Amount; //Nhif
                                    if prPeriodTransactions."Sub Group Order" = 3 then P9Paye := prPeriodTransactions.Amount; //paye
                                    if prPeriodTransactions."Sub Group Order" = 4 then P9Paye := P9Paye + prPeriodTransactions.Amount; //Paye Arrears
                                end;
                            8://Deductions
                                begin
                                    P9Deductions := P9Deductions + prPeriodTransactions.Amount;
                                end;
                            9: //NetPay
                                begin
                                    P9NetPay := prPeriodTransactions.Amount;
                                end;
                        end;

                    until prPeriodTransactions.Next = 0;
                end;
                //Update the P9 Details
                if P9NetPay <> 0 then
                    fnUpdateP9Table(prEmployee."No.", P9BasicPay, P9Allowances, P9Benefits, P9ValueOfQuarters, P9DefinedContribution,
                        P9OwnerOccupierInterest, P9GrossPay, P9TaxablePay, P9TaxCharged, P9InsuranceRelief, P9TaxRelief, P9Paye, P9Pension,
                        P9NHIF, P9Deductions, P9NetPay, dtCurPeriod);

            until prEmployee.Next = 0;
        end;
    end;

    procedure fnProcesspayroll(strEmpCode: Code[50]; dtDOE: Date; curBasicPay: Decimal; blnPaysPaye: Boolean; blnPaysPension: Boolean; blnPaysNhif: Boolean; SelectedPeriod: Date; dtOpenPeriod: Date; Membership: Text[30]; ReferenceNo: Text[30]; dtTermination: Date; blnGetsPAYERelief: Boolean; Dept: Code[50]; blnInsuranceCertificate: Boolean; paycostshare: Boolean; processadvance: Boolean; loanguarantee: Boolean; arrearsdays: Decimal; actingexpiry: date; actingstart: date; socialjoin: Boolean; socialjoindate: Date; leftsocial: Boolean)
    var
        curTransAmount: Decimal;
        curTransBalance: Decimal;
        strTransDescription: Text[50];
        prevousmonth: Date;
        TGroup: Text[30];
        TGroupOrder: Integer;
        TSubGroupOrder: Integer;
        curSalaryArrears: Decimal;
        curPayeArrears: Decimal;
        curGrossPay: Decimal;
        curTotAllowances: Decimal;
        curPension: Decimal;
        curpensionE: decimal;
        curDefinedContrib: Decimal;
        curPensionStaff: Decimal;
        curNonTaxable: Decimal;
        curGrossTaxable: Decimal;
        curCostshare: Decimal;
        workeddays: Integer;
        definedtransport_allmax: Decimal;
        definedtransportallo: Decimal;
        curBenefits: Decimal;
        curValueOfQuarters: Decimal;
        curUnusedRelief: Decimal;
        curInsuranceReliefAmount: Decimal;
        curTaxablePay: Decimal;
        curTaxCharged: Decimal;
        curPAYE: Decimal;
        prPeriodTransactions: Record "PR Period Transactions";
        intYear: Integer;
        intMonth: Integer;
        CountDaysofMonth: Integer;
        DaysWorked: Integer;
        CountDaysofMonthP: Integer;
        DaysWorkedP: Integer;
        currentendmonth: date;

        //prSalaryArrears: Record UnknownRecord70134782;
        prEmployeeTransactions: Record "PR Employee Transactions";
        prTransactionCodes: Record "PR Transaction Codes";
        suspendpay: Record "PR Salary Card";
        strExtractedFrml: Text[250];
        SpecialTransType: Option "None","Defined Contribution","Home Ownership Savings Plan","Life Insurance","Owner Occupier Interest","Prescribed Benefit","Salary Arrears","Staff Loan (Interest Varies)","Value of Quarters",Mortgage,"Voluntary Pension","Mortgage Relief";
        //prUnusedRelief: Record UnknownRecord70134784;
        curNhif_Base_Amount: Decimal;
        curNHIF: Decimal;
        curTotalDeductions: Decimal;
        curNetRnd_Effect: Decimal;
        curNetPay: Decimal;
        socialcontributionamt: Decimal;
        socialcontributionamtreg: Decimal;
        curClaim: Decimal;
        curTotCompanyDed: Decimal;
        curOOI: Decimal;
        curHOSP: Decimal;
        curLoanInt: Decimal;
        strTransCode: Text[250];
        fnCalcFringeBenefit: Decimal;
        prEmployerDeductions: Record "PR Employer Deductions";
        salCard: Record "PR Salary Card";
        curBPAYBal: Decimal;
        curPensionReliefAmount: Decimal;
        curIncludeinNet: Decimal;
        JournalPostAs: Option ,Debit,Credit;
        JournalPostingType: Option " ","G/L Account",Customer,Vendor;
        JournalAc: Code[50];
        Customer: Record Customer;
        curIncludeGross: Decimal;
        curPension_Base_Amount: Decimal;
        HREmp: Record "HR-Employee";
        loanguaranteeheader: Record "Loan Guarantee Header";
        loanguaranteelines: Record "Loan Guarantee Lines";
        actualcostshare: decimal;
        actualcostsharebal: Decimal;
        loanguaranteeamt: Decimal;
        totalcostsharecontr: Decimal;
        prtrans: Record "PR Period Transactions";
        eduloancostshare: Boolean;
        costsharestartdate: date;
    begin

        dtOpenPeriod := fnGetOpenPeriod();

        //Initialize
        fnInitialize;

        //Get Payroll Posting Accountss
        fnGetJournalDet(strEmpCode);
        //check if the period selected=current period. If not, do NOT run this function
        if SelectedPeriod <> dtOpenPeriod then exit;
        intMonth := Date2dmy(SelectedPeriod, 2);
        intYear := Date2dmy(SelectedPeriod, 3);
        prevousmonth := CalcDate('-1M', dtOpenPeriod);
        CountDaysofMonthp := fnDaysInMonth(prevousmonth);
        DaysWorkedp := fnDaysWorked(prevousmonth, false);

        //Delete all Records from the prPeriod Transactions for Reprocessing
        prPeriodTransactions.Reset;
        prPeriodTransactions.SetRange(prPeriodTransactions."Employee Code", strEmpCode);
        prPeriodTransactions.SetRange(prPeriodTransactions."Payroll Period", dtOpenPeriod);
        if prPeriodTransactions.FindSet() then
            prPeriodTransactions.DeleteAll;

        //Delete all Records from prEmployer Deductions
        prEmployerDeductions.Reset;
        prEmployerDeductions.SetRange(prEmployerDeductions."Employee Code", strEmpCode);
        prEmployerDeductions.SetRange(prEmployerDeductions."Payroll Period", dtOpenPeriod);
        if prEmployerDeductions.FindSet() then
            prEmployerDeductions.DeleteAll;

        //Delete all records from HRBankSummary
        HRBankSummary.Reset;
        HRBankSummary.SetRange(HRBankSummary."Payroll Period", dtOpenPeriod);
        HRBankSummary.SetRange(HRBankSummary."No.", strEmpCode);
        if HRBankSummary.FindSet() then HRBankSummary.DeleteAll;

        //IF curBasicPay >0 THEN
        begin

            definedtransport_allmax := VitalSetup."Defined Maximum Fuel Allowance";
            //Message(Format(definedtransport_allmax));   


            //Get the Basic Salary (prorate basc pay if needed) //Termination Remaining
            VitalSetup.Get();
            VitalSetup.TestField("Guarantee Recovery code");
            VitalSetup.TestField("Claims Code");
            VitalSetup.TestField("Minimum take home");
            //Message(Format(curBasicPay)+''+format(dtDOE));

            if VitalSetup."Enable Payroll Proration" = true then begin

                if dtDOE <> 0D then begin
                    if (Date2dmy(dtDOE, 2) = Date2dmy(dtOpenPeriod, 2)) and (Date2dmy(dtDOE, 3) = Date2dmy(dtOpenPeriod, 3)) then begin
                        CountDaysofMonth := fnDaysInMonth(dtDOE);
                        //CountDaysofMonth := 30;
                        //DaysWorked := fnDaysWorked(dtDOE, false);
                        DaysWorked:=30;
                        // if dtDOE > dtOpenPeriod then begin
                        //     DaysWorked := fnDaysWorked(dtDOE, false);
                        //     DaysWorked := DaysWorked + (20260309D - 20260228D) + 1;                           

                        // end;
                        CountDaysofMonthp := fnDaysInMonth(prevousmonth);
                        CountDaysofMonthp := 30;
                        DaysWorkedp := fnDaysWorked(prevousmonth, false);
                        definedtransportallo := (DaysWorked / CountDaysofMonth) * definedtransport_allmax;
                        definedtransportallo := ROUND(definedtransportallo, 0.01, '=');
                        definedtransportallo := ROUND(definedtransportallo, 0.01, '=');


                        curBasicPay := fnBasicPayProrated(strEmpCode, intMonth, intYear, curBasicPay, DaysWorked, CountDaysofMonth);
                        curBasicPay := Round(curBasicPay, 0.01, '=');



                        // if strEmpCode='ABH-097' then begin
                        // Message('1'+'-->'+ Format(CountDaysofMonth)+'-->'+Format(DaysWorked)+'-->'+Format(curBasicPay));
                        // end;
                    end;
                end;

                if dtTermination <> 0D then begin
                    if (Date2dmy(dtTermination, 2) = Date2dmy(dtOpenPeriod, 2)) and (Date2dmy(dtDOE, 3) = Date2dmy(dtOpenPeriod, 3)) then begin
                        CountDaysofMonth := 30;
                        DaysWorked := fnDaysWorked(dtTermination, true);
                        DaysWorked := 30;
                        CountDaysofMonthp := fnDaysInMonth(prevousmonth);
                        DaysWorkedp := fnDaysWorked(prevousmonth, false);
                        // if strEmpCode='ABH-097' then begin
                        // Message('2'+'-->'+Format(DaysWorked)+'-->'+Format(CountDaysofMonth));
                        // end;
                        definedtransportallo := (DaysWorked / CountDaysofMonth) * definedtransport_allmax;
                        definedtransportallo := ROUND(definedtransportallo, 0.01, '=');

                        curBasicPay := fnBasicPayProrated(strEmpCode, intMonth, intYear, curBasicPay, DaysWorked, CountDaysofMonth);
                        curBasicPay := Round(curBasicPay, 0.01, '=');

                    end;
                end;
                //Prorate Basic Pay on    {What if someone leaves within the same month they are employed}
                if dtTermination <> 0D then begin
                    dtTermination := CalcDate('-1D', dtTermination);
                    if dtDOE <> 0D then begin
                        if (Date2dmy(dtTermination, 2) = Date2dmy(dtOpenPeriod, 2)) and (Date2dmy(dtTermination, 3) = Date2dmy(dtOpenPeriod, 3)) then begin
                            CountDaysofMonth := 30;
                            DaysWorked := 30;
                            DaysWorked := DaysWorked + (20260309D - 20260228D) + 1;
                            CountDaysofMonthp := fnDaysInMonth(prevousmonth);
                            DaysWorkedp := fnDaysWorked(prevousmonth, false);
                            definedtransportallo := (DaysWorked / CountDaysofMonth) * definedtransport_allmax;
                            // if strEmpCode='ABH-097' then begin
                            // Error('3'+'-->'+Format(DaysWorked)+'-->'+Format(CountDaysofMonth));

                            // end;
                            curBasicPay := fnBasicPayProrated(strEmpCode, intMonth, intYear, curBasicPay, DaysWorked, CountDaysofMonth);
                            curBasicPay := Round(curBasicPay, 0.01, '=');
                        end;
                    end;
                end;
                //Prorate what if has arrears
                // if arrearsdays <> 0 then begin

                //     prevousmonth := CalcDate('-1M', dtOpenPeriod);
                //     if prevousmonth <> 0D then begin

                //         DaysWorkedP := arrearsdays;
                //         definedtransportallo := definedtransportallo + (DaysWorkedP / CountDaysofMonthP) * definedtransport_allmax;
                //         //Message('3'+'-->'+Format(DaysWorked)+'-->'+Format(CountDaysofMonth));
                //         curBasicPay := curBasicPay + fnBasicPayProrated(strEmpCode, intMonth, intYear, curBasicPay, DaysWorkedP, CountDaysofMonthP);
                //         curBasicPay := Round(curBasicPay, 0.01, '=');
                //         // if strEmpCode='ABH-097' then begin
                //         // Error(Format(DaysWorked)+'->'+Format(curBasicPay)+'-->'+Format(CountDaysofMonth));
                //         // end;
                //     end;
                // end;
            end;

            //basic pay balance
            curBPAYBal := 0;
            salCard.Reset;
            salCard.SetRange(salCard."Employee Code", strEmpCode);
            //salCard.CALCFIELDS(salCard."Cumm BasicPay");
            if salCard.FindFirst() then begin
                curBPAYBal := curBasicPay;
            end;
            if HREmp.get(strEmpCode) then begin
                if HREmp."On Suspension" = true then
                    curBPAYBal := 0;
                if HREmp."On Interdiction" = true then
                    curBPAYBal := curBasicPay * 0.5;
            end;
            // Test Proration of Basic Pay, then prorate allowances
            // if strEmpCode = 'ABH-097' then begin
            //     curBasicPay := fnBasicPayProrated(strEmpCode, intMonth, intYear, curBasicPay, 29, 30);
            //     curBasicPay := Round(curBasicPay, 0.01, '=');
            //     // Error('2'+'-->'+ Format(CountDaysofMonth)+'-->'+Format(DaysWorked)+'-->'+Format(curBasicPay));                     

            // end else begin
            //     curBasicPay := curBasicPay

            // end;

            curTransAmount := curBasicPay;
            curTransAmount := ROUND(curTransAmount, 0.01, '=');
            strTransDescription := 'BASIC PAY';
            TGroup := 'BASIC SALARY';
            TGroupOrder := 1;
            TSubGroupOrder := 1;
            if processadvance = false then
                fnUpdatePeriodTrans(strEmpCode, 'BPAY', TGroup, TGroupOrder,
                                   TSubGroupOrder, strTransDescription, curTransAmount, curBPAYBal,
                                   intMonth, intYear, Membership, ReferenceNo, SelectedPeriod, Dept,
                                   salariesAcc, Journalpostas::Debit, Journalpostingtype::"G/L Account", ''
                                   , Coopparameters::none);



            //Education Cost share

            //if costshare

            if paycostshare = true then begin
                costsharestartdate := 0D;
                HREmp.Reset();
                HREmp.SetRange(HREmp."No.", strEmpCode);
                if HREmp.FindFirst() then begin
                    HREmp.TestField("Cost Share Outstanding Balance");
                    HREmp.TestField("Cost Share Start Date");
                    HREmp.Validate("CostShare Contributions");

                    totalcostsharecontr := 0;
                    actualcostshare := 0;
                    actualcostsharebal := 0;
                    costsharestartdate := HREmp."Cost Share Start Date";
                    actualcostshare := HREmp."Cost Share Outstanding Balance";
                    prtrans.Reset();
                    prtrans.SetRange(prtrans."Employee Code", strEmpCode);
                    prtrans.SetRange(prtrans."Transaction Code", 'COSTSHARE');
                    prtrans.SetRange(prtrans."Period Closed", true);
                    if prtrans.find('-') then begin
                        repeat

                            totalcostsharecontr := totalcostsharecontr + prtrans.Amount;

                        until prtrans.Next = 0;
                    end;

                end;
                actualcostsharebal := actualcostshare - totalcostsharecontr;
                if costsharestartdate <= dtOpenPeriod then begin

                    if (curBasicPay > 0) and (actualcostsharebal > 0) then begin
                        if VitalSetup."Cost share percentage" > 0 then begin
                            curCostshare := (curBasicPay * (VitalSetup."Cost share percentage" / 100));
                            //Post cost share amount
                            if curCostshare > 0 then
                                if (curCostshare > actualcostsharebal) then begin

                                    curTransAmount := actualcostsharebal;
                                    curTransAmount := Round(curTransAmount, 0.01, '=');

                                end else if (curCostshare <= actualcostsharebal) then begin
                                    curTransAmount := curCostshare;
                                    curTransAmount := Round(curTransAmount, 0.01, '=');
                                end;
                        end;


                        strTransDescription := 'Cost share';
                        TGroup := 'STATUTORIES';
                        TGroupOrder := 7;
                        TSubGroupOrder := 1;
                        if curTransAmount > 0 then
                            if processadvance = false then
                                fnUpdatePeriodTrans(strEmpCode, 'Costshare', TGroup, TGroupOrder, TSubGroupOrder,
                                strTransDescription, curTransAmount, 0, intMonth, intYear, '', '', SelectedPeriod, Dept, costshareacc,
                                Journalpostas::Credit, Journalpostingtype::"G/L Account", '', Coopparameters::none);

                    end;

                end;


            end;




            //End education cost share

            //if loanguarantee
            if loanguarantee = true then begin
                if HREmp.get(strEmpCode) then
                    if (HREmp."Guarantee Start Date" <> 0D) and (HREmp."Guarantee Start Date" <= SelectedPeriod) then
                        loanguaranteeamt := 0;
                loanguaranteelines.Reset();
                loanguaranteelines.SetRange(loanguaranteelines."Guarantor Code", strEmpCode);
                loanguaranteelines.SetRange(loanguaranteelines.Closed, false);
                if loanguaranteelines.Find('-') then begin
                    repeat
                        loanguaranteeheader.Reset();
                        loanguaranteeheader.SetRange(loanguaranteeheader."Ref No", loanguaranteelines."Ref No");
                        loanguaranteeheader.SetRange(loanguaranteeheader."Loan Guarantee No", loanguaranteelines."Guarantee No");
                        loanguaranteeheader.SetRange(loanguaranteeheader.Status, loanguaranteeheader.Status::Approved);
                        loanguaranteeheader.SetRange(loanguaranteeheader."Send to Payroll", true);

                        if loanguaranteeheader.Find('-') then begin
                            loanguaranteeamt := loanguaranteeamt + loanguaranteelines.Installment;

                        end else begin
                            loanguaranteeamt := loanguaranteeamt;


                        end;

                    until loanguaranteelines.next = 0;

                end;
                if loanguaranteeamt <> 0 then
                    PREmpTrans_2.Reset();
                PREmpTrans_2.SetRange(PREmpTrans_2."Employee Code", strEmpCode);
                PREmpTrans_2.SetRange(PREmpTrans_2."Payroll Period", SelectedPeriod);
                PREmpTrans_2.SetRange(PREmpTrans_2."Period Year", intYear);
                PREmpTrans_2.SetRange(PREmpTrans_2."Period Month", intMonth);
                PREmpTrans_2.SetRange(PREmpTrans_2."Transaction Code", VitalSetup."Guarantee Recovery code");
                if PREmpTrans_2.FindFirst() then begin
                    PREmpTrans_2.Amount := loanguaranteeamt;
                    PREmpTrans_2.Modify;

                end else if not PREmpTrans_2.Find() then begin
                    PREmpTrans_2.init;
                    PREmpTrans_2."Transaction Code" := VitalSetup."Guarantee Recovery code";
                    PREmpTrans_2.Validate("Transaction Code");
                    PREmpTrans_2."Employee Code" := strEmpCode;
                    PREmpTrans_2."Payroll Period" := SelectedPeriod;
                    PREmpTrans_2."Period Month" := intMonth;
                    PREmpTrans_2."Period Year" := intYear;
                    PREmpTrans_2.Amount := loanguaranteeamt;
                    PREmpTrans_2.Validate(Amount);
                    PREmpTrans_2.Insert;
                    Sleep(20);
                end;


            end;
            //loanguarantee end

            /*
             //Salary Arrears
             prSalaryArrears.Reset;
             prSalaryArrears.SetRange(prSalaryArrears."Employee Code",strEmpCode);
             prSalaryArrears.SetRange(prSalaryArrears."Period Month",intMonth);
             prSalaryArrears.SetRange(prSalaryArrears."Period Year",intYear);
             if prSalaryArrears.FindFirst() then begin
             repeat
                  curSalaryArrears := prSalaryArrears."Salary Arrears";
                  curPayeArrears := prSalaryArrears."PAYE Arrears";

                  //Insert [Salary Arrears] into period trans [ARREARS]
                  curTransAmount := curSalaryArrears;
                  strTransDescription := 'Salary Arrears';
                  TGroup := 'ARREARS'; TGroupOrder := 1; TSubGroupOrder := 2;
                  fnUpdatePeriodTrans(strEmpCode, prSalaryArrears."Transaction Code", TGroup, TGroupOrder, TSubGroupOrder,
                    strTransDescription, curTransAmount, 0, intMonth, intYear,Membership,ReferenceNo,SelectedPeriod,Dept,
                    salariesAcc,Journalpostas::Debit,Journalpostingtype::"G/L Account",'',Coopparameters::none);

                  //Insert [PAYE Arrears] into period trans [PYAR]
                  curTransAmount:= curPayeArrears;

                  strTransDescription := 'P.A.Y.E Arrears';
                  TGroup := 'STATUTORIES'; TGroupOrder := 7; TSubGroupOrder := 4;
                  fnUpdatePeriodTrans(strEmpCode, 'PYAR', TGroup, TGroupOrder, TSubGroupOrder,
                     strTransDescription, curTransAmount, 0, intMonth, intYear,Membership,ReferenceNo,SelectedPeriod,Dept
                     ,salariesAcc,Journalpostas::Debit,Journalpostingtype::"G/L Account",'',Coopparameters::none)

             until prSalaryArrears.Next=0;
             end;
            */

            //Get Earnings
            prEmployeeTransactions.Reset;
            prEmployeeTransactions.SetRange(prEmployeeTransactions."Employee Code", strEmpCode);
            prEmployeeTransactions.SetRange(prEmployeeTransactions."Period Month", intMonth);
            prEmployeeTransactions.SetRange(prEmployeeTransactions."Period Year", intYear);
            prEmployeeTransactions.SetRange(prEmployeeTransactions.Stopped, false);
            if prEmployeeTransactions.FindFirst() then begin
                curTotAllowances := 0;
                // if strEmpCode = 'ABH-097' then begin
                //     DaysWorked := 29;
                //     CountDaysofMonth := 30;
                // end;
                repeat
                    prTransactionCodes.Reset;
                    prTransactionCodes.SetRange(prTransactionCodes."Transaction Code", prEmployeeTransactions."Transaction Code");
                    prTransactionCodes.SetRange(prTransactionCodes."Transaction Type", prTransactionCodes."transaction type"::Income);
                    if prTransactionCodes.FindFirst() then begin

                        curTransAmount := 0;
                        curTransBalance := 0;
                        strTransDescription := '';
                        strExtractedFrml := '';
                        curIncludeinNet := 0;
                        if prTransactionCodes."Is Formula" then begin
                            strExtractedFrml := fnPureFormula(strEmpCode, intMonth, intYear, prTransactionCodes.Formula);
                            curTransAmount := ROUND(fnFormulaResult(strExtractedFrml), 0.05, '='); //Get the calculated amount
                                                                                                   //error('%1',curTransAmount);
                            if (DaysWorked <> 0) and (CountDaysofMonth <> 0) then begin
                                curTransAmount := curTransAmount * (DaysWorked / CountDaysofMonth);
                                curTransAmount := ROUND(fnFormulaResult(strExtractedFrml), 0.05, '=');
                                if (arrearsdays <> 0) and (prTransactionCodes."Disable Proration" = false) then begin
                                    curTransAmount := curTransAmount + (arrearsdays / CountDaysofMonthP) * curTransAmount;
                                    curTransAmount := Round(curTransAmount, 0.01, '=');
                                end;
                                if (actingexpiry <> 0D) and (prTransactionCodes."Disable Proration" = true) and (dtTermination = 0D) then begin
                                    currentendmonth := CalcDate('+1M', dtOpenPeriod);
                                    currentendmonth := CalcDate('-1D', currentendmonth);
                                    if (actingexpiry < currentendmonth) or (actingstart > dtOpenPeriod) then
                                        if (Date2dmy(dtOpenPeriod, 2) = Date2dmy(actingexpiry, 2)) and (Date2dmy(dtOpenPeriod, 3) = Date2dmy(actingexpiry, 3)) then begin
                                            if actingstart <= dtOpenPeriod then begin
                                                CountDaysofMonth := fnDaysInMonth(dtOpenPeriod);
                                                DaysWorked := fnDaysWorked(actingexpiry, true);
                                            end else if actingstart > dtOpenPeriod then begin
                                                CountDaysofMonth := fnDaysInMonth(dtOpenPeriod);
                                                DaysWorked := currentendmonth - actingstart;

                                            end;
                                        end;

                                    if (DaysWorked <> 0) and (CountDaysofMonth <> 0) then begin
                                        curTransAmount := curTransAmount + (DaysWorked / CountDaysofMonth) * curTransAmount;
                                        curTransAmount := Round(curTransAmount, 0.01, '=');

                                    end;


                                end;


                            end else begin
                                curTransAmount := ROUND(fnFormulaResult(strExtractedFrml), 0.05, '=');

                            end;
                        end else begin
                            if (DaysWorked <> 0) and (CountDaysofMonth <> 0) then begin
                                curTransAmount := prEmployeeTransactions.Amount;
                                curTransAmount := curTransAmount * (DaysWorked / CountDaysofMonth);
                                curTransAmount := ROUND(curTransAmount, 0.01, '=');
                                if (arrearsdays <> 0) and (prTransactionCodes."Disable Proration" = false) then begin
                                    curTransAmount := curTransAmount + (arrearsdays / CountDaysofMonthP) * curTransAmount;
                                    curTransAmount := Round(curTransAmount, 0.01, '=');
                                end;
                                if (actingexpiry <> 0D) and (prTransactionCodes."Disable Proration" = true) and (dtTermination = 0D) then begin
                                    currentendmonth := CalcDate('+1M', dtOpenPeriod);
                                    currentendmonth := CalcDate('-1D', currentendmonth);
                                    if (actingexpiry < currentendmonth) or (actingstart > dtOpenPeriod) then
                                        if (Date2dmy(dtOpenPeriod, 2) = Date2dmy(actingexpiry, 2)) and (Date2dmy(dtOpenPeriod, 3) = Date2dmy(actingexpiry, 3)) then begin
                                            if actingstart <= dtOpenPeriod then begin
                                                CountDaysofMonth := fnDaysInMonth(dtOpenPeriod);
                                                DaysWorked := fnDaysWorked(actingexpiry, true);
                                            end else if actingstart > dtOpenPeriod then begin
                                                CountDaysofMonth := fnDaysInMonth(dtOpenPeriod);
                                                DaysWorked := currentendmonth - actingstart;

                                            end;
                                        end;

                                    if (DaysWorked <> 0) and (CountDaysofMonth <> 0) then begin
                                        curTransAmount := curTransAmount + (DaysWorked / CountDaysofMonth) * curTransAmount;
                                        curTransAmount := Round(curTransAmount, 0.01, '=');

                                    end;

                                end;

                            end else begin
                                curTransAmount := prEmployeeTransactions.Amount;
                                curTransAmount := ROUND(curTransAmount, 0.01, '=');
                                if (arrearsdays <> 0) and (prTransactionCodes."Disable Proration" = false) then begin
                                    curTransAmount := curTransAmount + (arrearsdays / CountDaysofMonthP) * curTransAmount;
                                    curTransAmount := Round(curTransAmount, 0.01, '=');
                                end;
                                if (actingexpiry <> 0D) and (prTransactionCodes."Disable Proration" = true) and (dtTermination = 0D) then begin
                                    currentendmonth := CalcDate('+1M', dtOpenPeriod);
                                    currentendmonth := CalcDate('-1D', currentendmonth);
                                    if (actingexpiry < currentendmonth) or (actingstart > dtOpenPeriod) then
                                        if (Date2dmy(dtOpenPeriod, 2) = Date2dmy(actingexpiry, 2)) and (Date2dmy(dtOpenPeriod, 3) = Date2dmy(actingexpiry, 3)) then begin
                                            if actingstart <= dtOpenPeriod then begin
                                                CountDaysofMonth := fnDaysInMonth(dtOpenPeriod);
                                                DaysWorked := fnDaysWorked(actingexpiry, true);
                                            end else if actingstart > dtOpenPeriod then begin
                                                CountDaysofMonth := fnDaysInMonth(dtOpenPeriod);
                                                DaysWorked := currentendmonth - actingstart;

                                            end;
                                        end;

                                    if (DaysWorked <> 0) and (CountDaysofMonth <> 0) then begin
                                        curTransAmount := curTransAmount + (DaysWorked / CountDaysofMonth) * curTransAmount;
                                        curTransAmount := Round(curTransAmount, 0.01, '=');

                                    end;

                                end;
                            end;
                        end;

                        if prTransactionCodes."Balance Type" = prTransactionCodes."balance type"::None then //[0=None, 1=Increasing, 2=Reducing]
                            curTransBalance := 0;
                        if prTransactionCodes."Balance Type" = prTransactionCodes."balance type"::Increasing then
                            curTransBalance := prEmployeeTransactions.Balance + curTransAmount;
                        if prTransactionCodes."Balance Type" = prTransactionCodes."balance type"::Reducing then
                            curTransBalance := prEmployeeTransactions.Balance - curTransAmount;
                        if prTransactionCodes."Include in Net" = true then begin
                            curIncludeinNet := curTransAmount;
                        end;


                        //Prorate Allowances Here
                        //Get the Basic Salary (prorate basc pay if needed) //Termination Remaining
                        // if dtDOE <> 0D then begin
                        //     IF (DATE2DMY(dtDOE, 2) = DATE2DMY(dtOpenPeriod, 2)) AND (DATE2DMY(dtDOE, 3) = DATE2DMY(dtOpenPeriod, 3)) THEN BEGIN
                        //         CountDaysofMonth := fnDaysInMonth(dtDOE);
                        //         DaysWorked := fnDaysWorked(dtDOE, FALSE);
                        //         curTransAmount := fnBasicPayProrated(strEmpCode, intMonth, intYear, curTransAmount, DaysWorked, CountDaysofMonth);
                        //     END;
                        // end;
                        //Prorate Basic Pay on    {What if someone leaves within the same month they are employed}
                        // IF dtTermination <> 0D THEN BEGIN

                        //     IF (DATE2DMY(dtTermination, 2) = DATE2DMY(dtOpenPeriod, 2)) AND (DATE2DMY(dtTermination, 3) = DATE2DMY(dtOpenPeriod, 3)) THEN BEGIN
                        //         CountDaysofMonth := fnDaysInMonth(dtTermination);
                        //         DaysWorked := fnDaysWorked(dtTermination, TRUE);
                        //         curTransAmount := fnBasicPayProrated(strEmpCode, intMonth, intYear, curTransAmount, DaysWorked, CountDaysofMonth);
                        //     END;

                        // END;
                        // Prorate Allowances Here

                        //Add Non Taxable Here
                        if (not prTransactionCodes.Taxable) and (prTransactionCodes."Special Trans Deductions" =
                        prTransactionCodes."special trans deductions"::None) then
                            curNonTaxable := curNonTaxable + curTransAmount;


                        //Added to ensure special transaction that are not taxable are not inlcuded in list of Allowances
                        if (not prTransactionCodes.Taxable) and (prTransactionCodes."Special Trans Deductions" <>
                        prTransactionCodes."special trans deductions"::None) then
                            curTransAmount := 0;

                        curTotAllowances := curTotAllowances + curTransAmount; //Sum-up all the allowances
                        curTransAmount := curTransAmount;
                        curTransBalance := curTransBalance;
                        strTransDescription := prTransactionCodes."Transaction Name";
                        //jnlcode:=prTransactionCodes."GL Account";
                        TGroup := 'ALLOWANCE';
                        TGroupOrder := 3;
                        TSubGroupOrder := 0;
                        //MESSAGE(FORMAT(JournalAc));


                        //Get the posting Details
                        JournalPostingType := Journalpostingtype::" ";
                        JournalAc := '';
                        if prTransactionCodes.Subledger <> prTransactionCodes.Subledger::" " then begin
                            //FOR CUSTOMER
                            //***********************************

                            if prTransactionCodes.Subledger = prTransactionCodes.Subledger::Customer then begin
                                //HrEmployee.GET(strEmpCode);
                                Customer.Reset;
                                Customer.SetRange(Customer."Staff No.", strEmpCode);
                                Customer.SetFilter(Customer."Account Type", '%1|%2', Customer."account type"::"Staff Advance", Customer."account type"::"Travel Advance");
                                if Customer.FindFirst() then begin
                                    JournalAc := strEmpCode;
                                    JournalPostingType := Journalpostingtype::Customer;
                                end;
                            end;

                            //FOR VENDOR
                            //***********************************
                            //           (

                        end else begin
                            //JournalAc:=jnlcode;
                            JournalPostingType := Journalpostingtype::"G/L Account";
                            JournalAc := prTransactionCodes."GL Account";

                        end;



                        //End posting Details

                        if processadvance = false then
                            fnUpdatePeriodTrans
                            (

                                               strEmpCode, prTransactionCodes."Transaction Code", TGroup, TGroupOrder, TSubGroupOrder,
                                               strTransDescription, curTransAmount, curTransBalance, intMonth, intYear, '',
                                               prEmployeeTransactions."Reference No", SelectedPeriod, Dept, JournalAc, Journalpostas::Debit, JournalPostingType, '',
                                               prTransactionCodes."coop parameters"
                            );



                    end;
                until prEmployeeTransactions.Next = 0;
            end;
            if definedtransportallo = 0 then begin
                definedtransportallo := definedtransport_allmax;
            end;
            //Error(Format(curBasicPay)+' '+Format(curTotAllowances)+' '+Format(curSalaryArrears)+' '+format(curIncludeGross)+''+Format(definedtransportallo));
            //Calc GrossPay = (BasicSalary + Allowances + SalaryArrears) [Group Order = 4]
            //assume transport is not defined contribution
            //curGrossPay := (curBasicPay + curTotAllowances + curSalaryArrears + curIncludeGross + definedtransportallo);
            curGrossPay := (curBasicPay + curTotAllowances + curSalaryArrears + curIncludeGross);
            curGrossPay := ROUND(curGrossPay, 0.01, '='); //0.01,'>' curGrossPay;
            curTransAmount := curGrossPay;
            totalcurGross := curGrossPay;
            curNetPay := ROUND(curNetPay, 0.01, '=');

            //check for claims



            //Post defined transport allowance- Ethiopia government
            if (definedtransportallo <> 0) then begin
                // TGroup := 'ALLOWANCE';
                //         TGroupOrder := 3;
                //         TSubGroupOrder := 0;
                //         JournalPostingType := Journalpostingtype::"G/L Account";
                // if processadvance=false then
                // fnUpdatePeriodTrans
                //         (
                //                            strEmpCode, 'Trans', TGroup, TGroupOrder, TSubGroupOrder,
                //                            'Non-Taxable Transport Allowance', definedtransportallo, 0, intMonth, intYear, '',
                //                            prEmployeeTransactions."Reference No", SelectedPeriod, Dept, transportllAcc, Journalpostas::Debit, JournalPostingType, '',
                //                            prTransactionCodes."coop parameters"::none
                //         );


            end;


            //end posting

            //************************************************************************************************************************************
            /*
                      //Get the Pension amount
                      IF blnPaysPension THEN
                        curPension := curPensionEmployee;
                      curTransAmount := curPension;
                      strTransDescription := 'N.S.S.F';
                      TGroup := 'STATUTORIES'; TGroupOrder := 7; TSubGroupOrder := 1;
                      fnUpdatePeriodTrans (strEmpCode, 'Pension', TGroup, TGroupOrder, TSubGroupOrder,
                      strTransDescription, curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,
                      PensionEMPyee,JournalPostAs::Credit,JournalPostingType::"G/L Account",'',CoopParameters::Pension);
            

            */
            //************************************************************************************************************************************
            //NEW Pension CODE HERE
            //Get the N.S.S.F amount for the month GBT
            curPension_Base_Amount := 0;
            if intPension_BasedOn = IntPension_basedon::Gross then //>Pension calculation can be based on:
                curPension_Base_Amount := curGrossPay;
            if intPension_BasedOn = IntPension_basedon::Basic then
                curPension_Base_Amount := curBasicPay;

            //Get the employee Pension amount
            if blnPaysPension then
                curPension := fnGetEmployeePension(curBasicPay);
            //hijra deducts from basic
            curTransAmount := curPension;

            curTransAmount := Round(curTransAmount, 0.01, '=');
            curpensionE := curTransAmount;
            curpensionE := ROUND(curpensionE, 0.01, '=');
            strTransDescription := 'Pension-employee';
            TGroup := 'STATUTORIES';
            TGroupOrder := 7;
            TSubGroupOrder := 1;
            if processadvance = false then
                fnUpdatePeriodTrans(strEmpCode, 'Pension', TGroup, TGroupOrder, TSubGroupOrder,
                strTransDescription, curTransAmount, 0, intMonth, intYear, '', '', SelectedPeriod, Dept, PensionEMPyee,
                Journalpostas::Credit, Journalpostingtype::"G/L Account", '', Coopparameters::nssf);

            //Update Employer deductions
            if blnPaysPension then
                curPension := fnGetEmployerPension(curBasicPay);
            //Hijra bank calculates from basic
            curTransAmount := curPension;
            curTransAmount := Round(curTransAmount, 0.01, '=');
            fnUpdateEmployerDeductions(strEmpCode, 'Pension',
             'EMP', TGroupOrder, TSubGroupOrder, '', curTransAmount, 0, intMonth, intYear,
              '', prEmployeeTransactions."Reference No", SelectedPeriod);


            //Get the Defined contribution to post based on the Max Def contrb allowed
            curDefinedContrib := curPension;
            curTransAmount := curDefinedContrib;
            curTransAmount := ROUND(curTransAmount, 0.01, '=');
            curDefinedContrib_2 := curPension;
            strTransDescription := 'Pension-employer';
            TGroup := 'TAX CALCULATIONS';
            TGroupOrder := 6;
            TSubGroupOrder := 1;
            if processadvance = false then
                fnUpdatePeriodTrans(strEmpCode, 'DEFCON', TGroup, TGroupOrder, TSubGroupOrder,
                 strTransDescription, curTransAmount, 0, intMonth, intYear, '', '', SelectedPeriod, Dept,
                 '', Journalpostas::Credit, Journalpostingtype::" ", '', Coopparameters::none);

            //Gross includes Gross + Employer contirbution
            totalcurGross := curDefinedContrib_2 + totalcurGross;

            strTransDescription := 'GROSS PAY';
            TGroup := 'GROSS PAY';
            TGroupOrder := 4;
            TSubGroupOrder := 0;
            if processadvance = false then
                fnUpdatePeriodTrans(strEmpCode, 'GPAY', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription, totalcurGross, 0, intMonth,
                 intYear, '', '', SelectedPeriod, Dept, '', Journalpostas::Debit, Journalpostingtype::" ", '', Coopparameters::none);


            //Get the Gross taxable amount
            //>GrossTaxable = Gross + Benefits + nValueofQuarters  ******Confirm CurValueofQuaters
            curGrossTaxable := curGrossPay + curBenefits + curValueOfQuarters;

            //>If GrossTaxable = 0 Then TheDefinedToPost = 0
            if curGrossTaxable = 0 then curDefinedContrib := 0;
            //Message(format(curBenefits) + '-->' + Format(curGrossTaxable));
            //Personal Relief
            // if get relief is ticked  - DENNO ADDED

            //Added for auto relief calculation

            if (curGrossPay - curPension) <= VitalSetup."Minimum Taxable Pay" then // <<< 26th-April-2020 Reduction in Paye>>>
            begin
                blnGetsPAYERelief := false;
            end else begin
                blnGetsPAYERelief := false;
                //If employee is marked on salary card as not entitle to personal relief  -- a)
                PRSalCard_2.Reset;
                if PRSalCard_2.Get(strEmpCode) then begin
                    if PRSalCard_2."De-Activate Personal Relief?" then blnGetsPAYERelief := false;
                end;
            end;

            //<<< Overwride a) above

            if (curGrossPay - curPension) <= VitalSetup."Minimum Taxable Pay" then begin
                blnGetsPAYERelief := false;
            end;
            // >>>

            if blnGetsPAYERelief then begin
                curReliefPersonal := curReliefPersonal + curUnusedRelief; //*****Get curUnusedRelief
                curTransAmount := curReliefPersonal;
                strTransDescription := 'Personal Relief';
                TGroup := 'TAX CALCULATIONS';
                TGroupOrder := 6;
                TSubGroupOrder := 9;
                if processadvance = false then
                    fnUpdatePeriodTrans(strEmpCode, 'PSNR', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
                     curTransAmount, 0, intMonth, intYear, '', '', SelectedPeriod, Dept,
                     '', Journalpostas::Credit, Journalpostingtype::" ", '', Coopparameters::none);
            end
            else
                curReliefPersonal := 0;

            //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            //>Pension Contribution [self] relief
            curPensionStaff := fnGetSpecialTransAmount(strEmpCode, intMonth, intYear,
            Specialtranstype::"Defined Contribution", false);//Self contrib Pension is 1 on [Special Transaction]
            if curPensionStaff > 0 then begin
                if curPensionStaff > curMaxPensionContrib then
                    curTransAmount := ROUND(curMaxPensionContrib, 0.05, '=')
                else
                    curTransAmount := ROUND(curPensionStaff, 0.05, '=');
                strTransDescription := 'Pension Relief';
                TGroup := 'TAX CALCULATIONS';
                TGroupOrder := 6;
                TSubGroupOrder := 2;
                if processadvance = false then
                    fnUpdatePeriodTrans(strEmpCode, 'PNSR', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
                    curTransAmount, 0, intMonth, intYear, '', '', SelectedPeriod, Dept,
                    '', Journalpostas::Credit, Journalpostingtype::" ", '', Coopparameters::none)
            end;

            //New NHIF Relief Update <<<
            // curNhif_Base_Amount := 0;
            // curNHIF := 0;
            // currNHIFRelief := 0;

            // IF VitalSetup."Implement NHIF Relief" THEN BEGIN
            //     VitalSetup.TESTFIELD("NHIF Relief Percentage");

            //     IF blnPaysNhif and blnPaysPaye THEN BEGIN


            //         IF intNHIF_BasedOn = intNHIF_BasedOn::Gross THEN curNhif_Base_Amount := curGrossPay;
            //         IF intNHIF_BasedOn = intNHIF_BasedOn::Basic THEN curNhif_Base_Amount := curBasicPay;

            //         curNHIF := fnGetEmployeeNHIF(curNhif_Base_Amount);
            //         currNHIFRelief := curNHIF * (VitalSetup."NHIF Relief Percentage" / 100);

            //         // MESSAGE('NHIF is %1 and the relief is %2', currNHIFRelief, curNHIF);

            //         curNhif_Base_Amount := 0;
            //         curNHIF := 0;

            //         IF currNHIFRelief > 0 THEN BEGIN
            //             curTransAmount := ROUND(currNHIFRelief, 0.05, '=');
            //             strTransDescription := 'NHIF Relief';
            //             TGroup := 'TAX CALCULATIONS';
            //             TGroupOrder := 6;
            //             TSubGroupOrder := 8;

            //             fnUpdatePeriodTrans(strEmpCode, 'NHIF-RL', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
            //             curTransAmount, 0, intMonth, intYear, '', '', SelectedPeriod, Dept,
            //             '', JournalPostAs::Credit, JournalPostingType::" ", '', CoopParameters::none);
            //         END;
            //     END;
            // END;

            //>>> NHIF Relief Update




            //if he PAYS paye only*******************I
            // if blnPaysPaye and blnGetsPAYERelief then begin
            if blnGetsPAYERelief then begin
                //Get Insurance Relief
                curInsuranceReliefAmount := fnGetSpecialTransAmount(strEmpCode, intMonth, intYear,
                Specialtranstype::"Life Insurance", false); //Insurance is 3 on [Special Transaction]

                //********************************************************************************************************************************************************
                //Added  - for employees who have brought the Insurance certificate, they are entitled to Insurance relief, Otherwise NO
                //Place a check mark on the Salary Card to YES
                if (curInsuranceReliefAmount > 0) and (blnInsuranceCertificate) then begin
                    curTransAmount := ROUND(curInsuranceReliefAmount, 0.05, '=');
                    strTransDescription := 'Insurance Relief';
                    TGroup := 'TAX CALCULATIONS';
                    TGroupOrder := 6;
                    TSubGroupOrder := 8;

                    //Added  to limit maximum insurance reliedf ro 5,000
                    if curTransAmount > VitalSetup."Max Relief" then curTransAmount := VitalSetup."Max Relief";

                    if processadvance = false then
                        fnUpdatePeriodTrans(strEmpCode, 'INSR', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
                        curTransAmount, 0, intMonth, intYear, '', '', SelectedPeriod, Dept,
                        '', Journalpostas::Credit, Journalpostingtype::" ", '', Coopparameters::none);
                end;

                //Get Pension Relief
                curPensionReliefAmount := fnGetSpecialTransAmount(strEmpCode, intMonth, intYear,
                Specialtranstype::"Voluntary Pension", false); //Insurance is 3 on [Special Transaction]
                if curPensionReliefAmount > 0 then begin
                    curTransAmount := curPensionReliefAmount;
                    strTransDescription := 'Voluntary Pension / Pension Relief';
                    TGroup := 'TAX CALCULATIONS';
                    TGroupOrder := 6;
                    TSubGroupOrder := 8;
                    if processadvance = false then
                        fnUpdatePeriodTrans(strEmpCode, 'IPR', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
                        curTransAmount, 0, intMonth, intYear, '', '', SelectedPeriod, Dept,
                        '', Journalpostas::Credit, Journalpostingtype::" ", '', Coopparameters::none);

                end;

                //>OOI
                curOOI := fnGetSpecialTransAmount(strEmpCode, intMonth, intYear,
                Specialtranstype::"Owner Occupier Interest", false); //Morgage is LAST on [Special Transaction]
                if curOOI > 0 then begin
                    if curOOI <= curOOIMaxMonthlyContrb then
                        curTransAmount := curOOI
                    else
                        curTransAmount := curOOIMaxMonthlyContrb;

                    strTransDescription := 'Owner Occupier';
                    TGroup := 'TAX CALCULATIONS';
                    TGroupOrder := 6;
                    TSubGroupOrder := 2;
                    if processadvance = false then
                        fnUpdatePeriodTrans(strEmpCode, 'OOI', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
                        curTransAmount, 0, intMonth, intYear, '', '', SelectedPeriod, Dept,
                        '', Journalpostas::Credit, Journalpostingtype::" ", '', Coopparameters::none);
                end;

                //HOSP
                curHOSP := fnGetSpecialTransAmount(strEmpCode, intMonth, intYear,
                Specialtranstype::"Home Ownership Savings Plan", false); //Home Ownership Savings Plan
                if curHOSP > 0 then begin
                    if curHOSP <= curReliefMorgage then
                        curTransAmount := curHOSP
                    else
                        curTransAmount := curReliefMorgage;

                    strTransDescription := 'Home Ownership Savings Plan';
                    TGroup := 'TAX CALCULATIONS';
                    TGroupOrder := 6;
                    TSubGroupOrder := 4;
                    if processadvance = false then
                        fnUpdatePeriodTrans(strEmpCode, 'HOSP', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
                        curTransAmount, 0, intMonth, intYear, '', '', SelectedPeriod, Dept,
                        '', Journalpostas::Credit, Journalpostingtype::" ", '', Coopparameters::none);
                end;

                //Dann
                //Mortage Relief
                curMorgageRelief := fnGetSpecialTransAmount(strEmpCode, intMonth, intYear,
                Specialtranstype::"Mortgage Relief", false);
                if curMorgageRelief > 0 then begin
                    curTransAmount := curMorgageRelief;
                    curMorgageRelief := ROUND(curMorgageRelief, 0.05, '=');
                    strTransDescription := 'Mortgage Relief';
                    TGroup := 'TAX CALCULATIONS';
                    TGroupOrder := 6;
                    TSubGroupOrder := 9;
                    if processadvance = false then
                        fnUpdatePeriodTrans(strEmpCode, 'MORG-RL', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
                        curTransAmount, 0, intMonth, intYear, '', '', SelectedPeriod, Dept,
                        '', Journalpostas::Credit, Journalpostingtype::" ", '', Coopparameters::none)

                end;



                //Enter NonTaxable Amount
                if curNonTaxable > 0 then begin
                    strTransDescription := 'Other Non-Taxable Benefits';
                    TGroup := 'TAX CALCULATIONS';
                    TGroupOrder := 6;
                    TSubGroupOrder := 5;
                    if processadvance = false then
                        fnUpdatePeriodTrans(strEmpCode, 'NONTAX', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
                        curNonTaxable, 0, intMonth, intYear, '', '', SelectedPeriod, Dept,
                        '', Journalpostas::Credit, Journalpostingtype::" ", '', Coopparameters::none);
                end;

            end;

            //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            /*
            //>Company pension, Excess pension, Tax on excess pension
            curPensionCompany := fnGetSpecialTransAmount(strEmpCode, intMonth, intYear, SpecialTransType::"Defined Contribution",
            TRUE); //Self contrib Pension is 1 on [Special Transaction]
            IF curPensionCompany > 0 THEN BEGIN
                curTransAmount := curPensionCompany;
                strTransDescription := 'Pension (Company)';
                //Update the Employer deductions table

                curExcessPension:= curPensionCompany - curMaxPensionContrib;
                IF curExcessPension > 0 THEN BEGIN
                    curTransAmount := curExcessPension;
                    strTransDescription := 'Excess Pension';
                    TGroup := 'STATUTORIES'; TGroupOrder := 7; TSubGroupOrder := 5;
                    fnUpdatePeriodTrans (strEmpCode, 'EXCP', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription, curTransAmount, 0,
                     intMonth,intYear,'','',SelectedPeriod,Dept,costc);

                    curTaxOnExcessPension := (curRateTaxExPension / 100) * curExcessPension;
                    curTransAmount := curTaxOnExcessPension;
                    strTransDescription := 'Tax on ExPension';
                    TGroup := 'STATUTORIES'; TGroupOrder := 7; TSubGroupOrder := 6;
                    fnUpdatePeriodTrans (strEmpCode, 'TXEP', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription, curTransAmount, 0,
                     intMonth,intYear,'','',SelectedPeriod,Dept,costc);
                END;
            END;
             */

            //Get the Taxable amount for calculation of PAYE
            //>prTaxablePay = (GrossTaxable - SalaryArrears) - (TheDefinedToPost + curSelfPensionContrb + MorgageRelief)


            BenifitAmount := 0;

            PRTransCode_2.Reset;
            PRTransCode_2.SetRange(PRTransCode_2."Transaction Type", PRTransCode_2."transaction type"::Benefit);
            if PRTransCode_2.FindFirst() then begin
                PREmpTrans_2.Reset;
                PREmpTrans_2.SetRange(PREmpTrans_2."Transaction Code", PRTransCode_2."Transaction Code");
                PREmpTrans_2.SetRange(PREmpTrans_2."Employee Code", strEmpCode);
                PREmpTrans_2.SetRange(PREmpTrans_2."Payroll Period", SelectedPeriod);
                if PREmpTrans_2.FindFirst() then begin
                    if PRTransCode_2.Taxable then BenifitAmount := (PREmpTrans_2.Amount * 30 / 100);
                    //Insert in to PR Period Trans
                    strTransDescription := PRTransCode_2."Transaction Name";
                    curTransAmount := PREmpTrans_2.Amount;
                    PREmpTrans_2.Amount := ROUND(PREmpTrans_2.Amount, 0.05, '=');
                    TGroup := 'TAX CALCULATIONS';
                    TGroupOrder := 6;
                    TSubGroupOrder := 1;
                    if processadvance = false then
                        fnUpdatePeriodTrans(strEmpCode, PRTransCode_2."Transaction Code", TGroup, TGroupOrder, TSubGroupOrder,
                        strTransDescription, curTransAmount, 0, intMonth, intYear, '', '', SelectedPeriod, Dept,
                        '', Journalpostas::Credit, Journalpostingtype::" ", '', Coopparameters::none);

                    //Initialize
                    curTransAmount := 0;
                    curTransBalance := 0;
                    strTransDescription := '';
                end;
            end;


            //Add HOSP and MORTGAGE KIM{}
            // Message(Format(curSalaryArrears)+'-->'+Format(curGrossTaxable)+'-->'+Format(curNonTaxable)+'-->'+Format(BenifitAmount)+'==>'+Format(definedtransportallo));
            //if assume transport allowance is not defined
            //                curTaxablePay := curGrossTaxable - (curSalaryArrears + curNonTaxable + definedtransportallo) + BenifitAmount
            if curPensionStaff > curMaxPensionContrib then
                curTaxablePay := curGrossTaxable - (curSalaryArrears + curNonTaxable) + BenifitAmount
            else
                curTaxablePay := curGrossTaxable - (curSalaryArrears + curNonTaxable) + BenifitAmount;

            PRSalCard_Disability.reset;
            PRSalCard_Disability.SetRange("Employee Code", strEmpCode);
            if PRSalCard_Disability.FindFirst() then begin
                if PRSalCard_Disability."PWD Certificate?" = true then begin
                    curTaxablePay := curTaxablePay - curDisabledLimit;
                end;
            end;

            curTaxablePay := ROUND(curTaxablePay, 0.01, '=');
            curTransAmount := curTaxablePay;
            curTaxablePay := ROUND(curTaxablePay, 0.01, '=');
            strTransDescription := 'Taxable Pay';
            TGroup := 'TAX CALCULATIONS';
            TGroupOrder := 6;
            TSubGroupOrder := 6;
            if processadvance = false then
                fnUpdatePeriodTrans(strEmpCode, 'TXBP', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
                 curTransAmount, 0, intMonth, intYear, '', '', SelectedPeriod, Dept,
                 '', Journalpostas::Credit, Journalpostingtype::" ", '', Coopparameters::none);

            //
            //  //Get the Tax charged for the month
            // //Added for auto relief calculation
            // IF  (curGrossPay-curPension)  <= currMinRelief THEN
            // BEGIN
            //     blnPaysPaye:=FALSE;
            // END ELSE
            // BEGIN
            //     blnPaysPaye:=TRUE;
            // END;
            //
            // Message(Format(curTaxablePay));
            //Felix-Hijra
            if strEmpCode = 'E0010' then begin
                //Message(Format(curGrossTaxable) + '==>' + Format(curTaxablePay) + '-->' + Format(curNonTaxable));
            end;
            if blnPaysPaye then begin
                //Added:: Dann.... Special tax for disabled employee
                //HREmp2.Reset;
                if HREmp2.Get(strEmpCode) then begin
                    if HREmp2."Disabling Details" <> '' then begin
                        blnPaysPaye := false;
                    end else begin
                        //Added:: Dann - Special Tax for Secondary Staff
                        HREmp2.RESET;
                        if HREmp2.Get(strEmpCode) then begin
                            if HREmp2."Employee Type" = HREmp2."employee type"::Seconded then begin
                                // curTaxCharged := curTaxablePay * 0.3;
                                curTaxCharged := fnGetEmployeePaye(curTaxablePay);
                                curTransAmount := curTaxCharged;
                                curTransAmount := ROUND(curTaxCharged, 0.05, '=');
                                strTransDescription := 'Tax Charged';
                                TGroup := 'TAX CALCULATIONS';
                                TGroupOrder := 6;
                                TSubGroupOrder := 7;
                                if processadvance = false then
                                    fnUpdatePeriodTrans(strEmpCode, 'TXCHRG', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
                                    curTransAmount, 0, intMonth, intYear, '', '', SelectedPeriod, Dept,
                                    '', Journalpostas::Credit, Journalpostingtype::" ", '', Coopparameters::none);
                            end else begin
                                //Error('Taxable Pay for [ %1 ] is [ %2 ]', strEmpCode, curTaxablePay);
                                //Tax for Normal staff
                                curTaxCharged := fnGetEmployeePaye(curTaxablePay);
                                curTransAmount := ROUND(curTaxCharged, 0.01, '='); //ROUND PAYE UP TO NEAREST WHOLE NO
                                strTransDescription := 'Tax Charged';
                                TGroup := 'TAX CALCULATIONS';
                                TGroupOrder := 6;
                                TSubGroupOrder := 7;
                                if processadvance = false then
                                    fnUpdatePeriodTrans(strEmpCode, 'TXCHRG', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
                                    curTransAmount, 0, intMonth, intYear, '', '', SelectedPeriod, Dept,
                                    '', Journalpostas::Credit, Journalpostingtype::" ", '', Coopparameters::none);
                            end;
                        end;
                    end;
                end;
            end;

            //Get the Net PAYE amount to post for the month
            if VitalSetup."Enable Relief On PAYE Only" then begin
                if (curReliefPersonal + curInsuranceReliefAmount) > curMaximumRelief then begin
                    curPAYE := curTaxCharged - curMaximumRelief;
                end else begin
                    //******************************************************************************************************************************************
                    //Added : Only for Employees who have brought their insurance Certificate are entitled to Insurance Relief Otherwise NO
                    //Place a check mark on the Salary Card to YES
                    if (blnInsuranceCertificate) then begin
                        curPAYE := curTaxCharged - (curReliefPersonal + curInsuranceReliefAmount + curMorgageRelief + currNHIFRelief);
                    end else begin
                        curPAYE := curTaxCharged - (curReliefPersonal + curMorgageRelief + currNHIFRelief);
                    end;
                    //******************************************************************************************************************************************
                end;
            end else begin
                if (curReliefPersonal + curInsuranceReliefAmount + currNHIFRelief) > curMaximumRelief then begin
                    curPAYE := curTaxCharged - curMaximumRelief;
                end else begin
                    //******************************************************************************************************************************************
                    //Added : Only for Employees who have brought their insurance Certificate are entitled to Insurance Relief Otherwise NO
                    //Place a check mark on the Salary Card to YES
                    if curTaxCharged < currNHIFRelief then begin
                        currNHIFRelief := 0;
                        if (blnInsuranceCertificate) then begin
                            curPAYE := curTaxCharged - (curReliefPersonal + curInsuranceReliefAmount + curMorgageRelief + currNHIFRelief);
                        end else begin
                            curPAYE := curTaxCharged - (curReliefPersonal + curMorgageRelief + currNHIFRelief);
                        end;
                    end;
                    //******************************************************************************************************************************************
                end;
            end;
            curPAYE := curTaxCharged;

            if curPAYE < 0 then curPAYE := 0;

            //Added for auto PAYE calculation
            //   IF  (curGrossPay-curPension)  <= currMinRelief THEN
            //   BEGIN
            //       blnPaysPaye:=FALSE;
            //   END ELSE
            //   BEGIN
            //       blnPaysPaye:=TRUE;
            //   END;

            blnPaysPaye := true;
            if not blnPaysPaye then curPAYE := 0; //Get statutory Exemption for the staff. If exempted from tax, set PAYE=0
            curTransAmount := curPAYE;

            if curPAYE < 0 then curTransAmount := 0;
            curPAYE := ROUND(curPAYE, 0.05, '>');
            strTransDescription := 'Income Tax';
            //felix for ethiopia
            TGroup := 'STATUTORIES';
            TGroupOrder := 7;
            TSubGroupOrder := 3;
            if processadvance = false then
                fnUpdatePeriodTrans(strEmpCode, 'PAYE', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
                curTransAmount, 0, intMonth, intYear, '', '', SelectedPeriod, Dept,
                TaxAccount, Journalpostas::Credit, Journalpostingtype::"G/L Account", '', Coopparameters::none);

            /*          //Store the unused relief for the current month
                     //>If Paye<0 then "Insert into tblprUNUSEDRELIEF
                     if curPAYE < 0 then begin
                     prUnusedRelief.Reset;
                     prUnusedRelief.SetRange(prUnusedRelief."Employee Code",strEmpCode);
                     prUnusedRelief.SetRange(prUnusedRelief."Period Month",intMonth);
                     prUnusedRelief.SetRange(prUnusedRelief."Period Year",intYear);
                     if prUnusedRelief.FindFirst() then
                        prUnusedRelief.Delete;

                     prUnusedRelief.Reset;
                     with prUnusedRelief do begin
                         Init;
                         "Employee Code" := strEmpCode;
                         "Unused Relief" := curPAYE;
                         "Period Month" := intMonth;
                         "Period Year" := intYear;
                         Insert;
                     end;
                    end; */

            //Deductions: get all deductions for the month
            //Loans: calc loan deduction amount, interest, fringe benefit (employer deduction), loan balance
            //>Balance = (Openning Bal + Deduction)...//Increasing balance
            //>Balance = (Openning Bal - Deduction)...//Reducing balance
            //>NB: some transactions (e.g Sacco shares) can be made by cheque or cash. Allow user to edit the outstanding balance

            //Get the N.H.I.F amount for the month GBT
            curNhif_Base_Amount := 0;

            if intNHIF_BasedOn = Intnhif_basedon::Gross then //>NHIF calculation can be based on:
                curNhif_Base_Amount := curGrossPay;
            if intNHIF_BasedOn = Intnhif_basedon::Basic then
                curNhif_Base_Amount := curBasicPay;
            if intNHIF_BasedOn = Intnhif_basedon::"Taxable Pay" then
                curNhif_Base_Amount := curTaxablePay;

            // if blnPaysNhif then begin
            //     curNHIF := fnGetEmployeeNHIF(curNhif_Base_Amount);
            //     curTransAmount := curNHIF;

            //     strTransDescription := 'N.H.I.F';
            //     TGroup := 'STATUTORIES';
            //     TGroupOrder := 7;
            //     TSubGroupOrder := 2;
            //     fnUpdatePeriodTrans(strEmpCode, 'NHIF', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
            //      curTransAmount, 0, intMonth, intYear, '', '', SelectedPeriod, Dept,
            //      NHIFEMPyee, Journalpostas::Credit, Journalpostingtype::"G/L Account", '', Coopparameters::none);
            // end;

            prEmployeeTransactions.Reset;
            prEmployeeTransactions.SetRange(prEmployeeTransactions."Employee Code", strEmpCode);
            prEmployeeTransactions.SetRange(prEmployeeTransactions."Period Month", intMonth);
            prEmployeeTransactions.SetRange(prEmployeeTransactions."Period Year", intYear);
            //prEmployeeTransactions.SetRange(prEmployeeTransactions.Stopped, false); //Added  to not process Stopped Transactions
            if prEmployeeTransactions.FindFirst() then begin
                curTotalDeductions := 0;
                repeat
                    prTransactionCodes.Reset;
                    prTransactionCodes.SetRange(prTransactionCodes."Transaction Code", prEmployeeTransactions."Transaction Code");
                    prTransactionCodes.SetRange(prTransactionCodes."Transaction Type", prTransactionCodes."transaction type"::Deduction);
                    //prTransactionCodes.SetFilter("coop parameters", '<>%1', prTransactionCodes."coop parameters"::"loan Interest");
                    if prTransactionCodes.FindFirst() then begin
                        curTransAmount := 0;
                        curTransBalance := 0;
                        strTransDescription := '';
                        strExtractedFrml := '';

                        if prTransactionCodes."Is Formula" then begin
                            strExtractedFrml := fnPureFormula(strEmpCode, intMonth, intYear, prTransactionCodes.Formula);
                            curTransAmount := fnFormulaResult(strExtractedFrml); //Get the calculated amount
                        end else begin
                            curTransAmount := prEmployeeTransactions.Amount;
                            prEmployeeTransactions.Amount := ROUND(prEmployeeTransactions.Amount, 0.05, '=');
                        end;

                        // Dann - Customized for AFFA (Each Directorate has its own Formalua for Pension
                        if prTransactionCodes."Is Formula Per Directorate" then begin
                            //Get directorate of staff
                            if HREmp.Get(strEmpCode) then begin
                                HREmp.TestField(HREmp."Global Dimension 1 Code");

                                //Get Formulae from PR Trans Code Formulae
                                PRTransCodeForm.Reset;
                                PRTransCodeForm.SetRange(PRTransCodeForm."Global Dimension 1 Code", HREmp."Global Dimension 1 Code");
                                if PRTransCodeForm.FindFirst() then begin
                                    PRTransCodeForm.TestField(PRTransCodeForm."Employee Formulae");
                                    strExtractedFrml := fnPureFormula(strEmpCode, intMonth, intYear, PRTransCodeForm."Employee Formulae");
                                    curTransAmount := fnFormulaResult(strExtractedFrml); //Get the calculated amount
                                end else begin
                                    //                     ERROR('Formulae Per Directorate for Transaction Code[ %1 ] is not specified for Directorate %2',
                                    //                           strTransCode,HREmp."Global Dimension 1 Code");
                                end;
                            end;
                        end;
                        // Dann - End Customized for AFFA

                        //**************************If "deduct Premium" is not ticked and the type is insurance- Dennis*****
                        if (prTransactionCodes."Special Trans Deductions" = prTransactionCodes."special trans deductions"::"Life Insurance")
                          and (prTransactionCodes."Deduct Premium" = false) then begin
                            curTransAmount := 0;
                        end;

                        //**************************If "deduct Premium" is not ticked and the type is mortgage- Dennis*****
                        if (prTransactionCodes."Special Trans Deductions" = prTransactionCodes."special trans deductions"::Mortgage)
                         and (prTransactionCodes."Deduct Mortgage" = false) then begin
                            curTransAmount := 0;
                        end;


                        //**************************If "deduct Premium" is not ticked and the type is mortgage- Dennis*****
                        if (prTransactionCodes."Special Trans Deductions" = prTransactionCodes."special trans deductions"::"Voluntary Pension")
                         and (prTransactionCodes.Welfare = false) then begin
                            curTransAmount := 0;
                        end;

                        //Get the posting Details  -- Deductions for Salary Advance
                        JournalPostingType := Journalpostingtype::" ";
                        JournalAc := '';
                        if prTransactionCodes.Subledger <> prTransactionCodes.Subledger::" " then begin
                            if prTransactionCodes.Subledger = prTransactionCodes.Subledger::Customer then begin
                                Customer.Reset;
                                Customer.SetFilter(Customer."Account Type", '%1|%2', Customer."account type"::"Staff Advance", Customer."account type"::"Travel Advance");
                                Customer.SetRange(Customer."Staff No.", strEmpCode);
                                Customer.FindFirst();
                                begin
                                    if Customer.Count > 1 then begin
                                        Error('More than 1 Salary Advance account is linked for Customer %1', Customer."No.");
                                    end;
                                    JournalAc := Customer."No.";
                                    JournalPostingType := Journalpostingtype::Customer;
                                end;
                            end;

                            //FOR VENDOR
                            //***********************************
                            if prTransactionCodes.Subledger = prTransactionCodes.Subledger::Vendor then begin
                                if HREmp.Get(strEmpCode) then begin
                                    JournalAc := prEmployeeTransactions."Subledger Account";
                                    JournalPostingType := Journalpostingtype::Vendor;
                                end;
                            end;
                        end else begin
                            JournalAc := prTransactionCodes."GL Account";
                            JournalPostingType := Journalpostingtype::"G/L Account";
                        end;

                        //End posting Details


                        //Loan Calculation is Amortized do Calculations here -Monthly Principal and Interest Keeps on Changing
                        if (prTransactionCodes."Special Trans Deductions" = prTransactionCodes."special trans deductions"::"Sacco Loan") and
                           (prTransactionCodes."Repayment Method" = prTransactionCodes."repayment method"::Reducing) then begin
                            curTransAmount := 0;
                            curLoanInt := 0;

                            prTransactionCodes.TestField("Intrest Transaction Code");
                            prTransactionCodes.TestField("Interest Rate");

                            //if not prEmployeeTransactions."Exempt from Interest" then prEmployeeTransactions.TestField(prEmployeeTransactions."Loan Interest Rate");
                            //niko hapa
                            clear(curLoanInt);

                            curLoanInt := fnCalcLoanInterest(strEmpCode, prTransactionCodes."Intrest Transaction Code",
                            prTransactionCodes."Interest Rate", prTransactionCodes."Repayment Method",
                               prEmployeeTransactions."Original Amount", prEmployeeTransactions.Balance, SelectedPeriod);
                            //Post the Interest
                            if (curLoanInt <> 0) then begin
                                //curTransAmount := curLoanInt;
                                curTotalDeductions := curTotalDeductions + curLoanInt; //Sum-up all the deductions
                                curTransBalance := 0;
                                strTransCode := prTransactionCodes."Intrest Transaction Code";
                                strTransDescription := prEmployeeTransactions."Transaction Name" + ' - Interest';
                                TGroup := 'DEDUCTIONS';
                                TGroupOrder := 8;
                                TSubGroupOrder := 1;
                                if processadvance = false then
                                    fnUpdatePeriodTrans(strEmpCode, strTransCode, TGroup, TGroupOrder, TSubGroupOrder,
                                      strTransDescription, curLoanInt, curTransBalance, intMonth, intYear,
                                      '', prEmployeeTransactions."Reference No", SelectedPeriod, Dept,
                                      JournalAc, Journalpostas::Credit, JournalPostingType, prEmployeeTransactions."Loan Number",
                                      Coopparameters::"loan Interest")
                            end;

                            //Added DW - Create intrest transaction code in PR Employee Transactions
                            PREmpTrans_INT.Reset();
                            PREmpTrans_INT.Init();
                            PREmpTrans_INT."Employee Code" := strEmpCode;
                            PREmpTrans_INT."Transaction Code" := prTransactionCodes."Intrest Transaction Code";
                            PREmpTrans_INT.Validate("Transaction Code");
                            PREmpTrans_INT."Period Month" := Date2DMY(SelectedPeriod, 2);
                            PREmpTrans_INT."Period Year" := Date2DMY(SelectedPeriod, 3);
                            PREmpTrans_INT."Payroll Period" := SelectedPeriod;
                            PREmpTrans_INT.Amount := curLoanInt;
                            if not PREmpTrans_INT.Insert() then PREmpTrans_INT.Modify();

                            //Added DW



                            //Get the Principal Amt
                            //curTransAmount:=prEmployeeTransactions."Amortized Loan Total Repay Amt"-curLoanInt;
                            //Modify PREmployeeTransaction Table
                            //prEmployeeTransactions.Amount:=curTransAmount;
                            //prEmployeeTransactions.MODIFY;
                        end;
                        //Loan Calculation Amortized

                        case prTransactionCodes."Balance Type" of //[0=None, 1=Increasing, 2=Reducing]
                            prTransactionCodes."balance type"::None:
                                begin
                                    curTransBalance := 0;
                                    curTransAmount := prEmployeeTransactions.Amount;
                                end;
                            prTransactionCodes."balance type"::Increasing:
                                begin
                                    //Added Dann
                                    if prTransactionCodes."Special Trans Deductions" <> prTransactionCodes."special trans deductions"::"Defined Contribution"
                                    then begin
                                        curTransAmount := prEmployeeTransactions.Amount;
                                    end;
                                    //Added Dann
                                    curTransBalance := prEmployeeTransactions.Balance + curTransAmount;
                                end;
                            prTransactionCodes."balance type"::Reducing:
                                begin
                                    //curTransBalance := prEmployeeTransactions.Balance - curTransAmount;
                                    if prEmployeeTransactions.Balance < prEmployeeTransactions.Amount then begin
                                        curTransAmount := prEmployeeTransactions.Balance;
                                        curTransBalance := 0;
                                    end else begin
                                        //Added Dann
                                        curTransAmount := prEmployeeTransactions.Amount;
                                        //Added Dann

                                        curTransBalance := prEmployeeTransactions.Balance - curTransAmount;
                                    end;
                                    if curTransBalance < 0 then begin
                                        curTransAmount := 0;
                                        curTransBalance := 0;
                                    end;
                                end
                        end;
                        //Message(Format(curTotalDeductions));

                        curTotalDeductions := curTotalDeductions + curTransAmount; //Sum-up all the deductions
                        curTransAmount := curTransAmount;
                        curTransBalance := curTransBalance;
                        strTransDescription := prTransactionCodes."Transaction Name";

                        TGroup := 'DEDUCTIONS';
                        TGroupOrder := 8;
                        TSubGroupOrder := 0;
                        if processadvance = false then
                            fnUpdatePeriodTrans(strEmpCode, prEmployeeTransactions."Transaction Code", TGroup, TGroupOrder, TSubGroupOrder,
                             strTransDescription, curTransAmount, curTransBalance, intMonth,
                             intYear, '', prEmployeeTransactions."Reference No", SelectedPeriod, Dept,
                             JournalAc, Journalpostas::Credit, JournalPostingType, prEmployeeTransactions."Loan Number",
                             prTransactionCodes."coop parameters");

                        //Fringe Benefits and Low interest Benefits
                        if prTransactionCodes."Fringe Benefit" = true then begin
                            if prTransactionCodes."Interest Rate" < curLoanMarketRate then begin
                                fnCalcFringeBenefit := (((curLoanMarketRate - prTransactionCodes."Interest Rate") * curLoanCorpRate) / 1200)
                                 * prEmployeeTransactions.Balance;
                            end;
                        end else begin
                            fnCalcFringeBenefit := 0;
                        end;
                        if fnCalcFringeBenefit > 0 then begin
                            fnUpdateEmployerDeductions(strEmpCode, prEmployeeTransactions."Transaction Code" + '-FRG',
                             'EMP', TGroupOrder, TSubGroupOrder, 'Fringe Benefit Tax', fnCalcFringeBenefit, 0, intMonth, intYear,
                              '', prEmployeeTransactions."Reference No", SelectedPeriod)

                        end;
                        //End Fringe Benefits

                        //Create Employer Deduction
                        //Modified Dann  - Each Directorate has its own formula for Pension
                        if (prTransactionCodes."Special Trans Deductions" = prTransactionCodes."special trans deductions"::"Defined Contribution") then begin
                            if prTransactionCodes."Is Formula Per Directorate" then begin
                                //Get Directorate of Staff
                                if HREmp.Get(strEmpCode) then begin
                                    HREmp.TestField(HREmp."Global Dimension 1 Code");

                                    //Get Formulae from PR Trans Code Formulae
                                    PRTransCodeForm.Reset;
                                    PRTransCodeForm.SetRange(PRTransCodeForm."Global Dimension 1 Code", HREmp."Global Dimension 1 Code");
                                    if PRTransCodeForm.FindFirst() then begin
                                        if PRTransCodeForm."Include In Employer Deductions" then begin
                                            PRTransCodeForm.TestField(PRTransCodeForm."Employer Formulae");
                                        end;

                                        strExtractedFrml := fnPureFormula(strEmpCode, intMonth, intYear, PRTransCodeForm."Employer Formulae");
                                        curTransAmount := fnFormulaResult(strExtractedFrml); //Get the calculated amount

                                        if curTransAmount > 0 then begin
                                            fnUpdateEmployerDeductions(strEmpCode, prEmployeeTransactions."Transaction Code",
                                           'EMP', TGroupOrder, TSubGroupOrder, '', curTransAmount, 0, intMonth, intYear,
                                            '', prEmployeeTransactions."Reference No", SelectedPeriod);
                                        end;
                                    end;
                                end;
                            end else begin
                                strExtractedFrml := fnPureFormula(strEmpCode, intMonth, intYear, prTransactionCodes."Is Formula for employer");
                                curTransAmount := fnFormulaResult(strExtractedFrml); //Get the calculated amount

                                if curTransAmount > 0 then begin
                                    fnUpdateEmployerDeductions(strEmpCode, prEmployeeTransactions."Transaction Code",
                                   'EMP', TGroupOrder, TSubGroupOrder, '', curTransAmount, 0, intMonth, intYear,
                                    '', prEmployeeTransactions."Reference No", SelectedPeriod);
                                end;
                            end;
                            //Modified Dan - Each Directorate has its own formula for Pension

                            //         //Update Balance on PR Period Transaction Table with Pension Contributed from Employer
                            //          PRPeriodTrans.RESET;
                            //          PRPeriodTrans.SETRANGE(PRPeriodTrans."Employee Code",strEmpCode);
                            //          PRPeriodTrans.SETRANGE(PRPeriodTrans."Transaction Code",prEmployeeTransactions."Transaction Code");
                            //          PRPeriodTrans.SETRANGE(PRPeriodTrans."Payroll Period",SelectedPeriod);
                            //          IF PRPeriodTrans.FINDFirst() THEN
                            //          BEGIN
                            //             IF PRPeriodTrans.Balance <> 0 THEN PRPeriodTrans.Balance += curTransAmount;
                            //             PRPeriodTrans.MODIFY;
                            //          END;
                            //         //Added Dann

                        end;
                    end;

                until prEmployeeTransactions.Next = 0;
                //GET TOTAL DEDUCTIONS
                //Total Deductions to Include PAYE, Pension, NHIF - Added DW

                curTotalDeductions := curTotalDeductions;
                //Message(Format(curTotalDeductions));






                //Net Pay: calculate the Net pay for the month in the following manner:
                //>Nett = Gross - (xPensionAmount + curMyNhifAmt + PAYE + PayeArrears + prTotDeductions)
                //...Tot Deductions also include (SumLoan + SumInterest)

                curNetPay := curGrossPay - (curPensionE + curPAYE + curPayeArrears + curTotalDeductions + curCostshare);//-curIncludeinNet;
                                                                                                                        //curNetPay := curGrossPay - (curPayeArrears + curTotalDeductions);//-curIncludeinNet;
                                                                                                                        //curNetPay:=curNetPay+curIncludeinNet;
                                                                                                                        //>Nett = Nett - curExcessPension
                                                                                                                        //...Excess pension is only used for tax. Staff is not paid the amount hence substract it
                curNetPay := curNetPay; //- curExcessPension

                //>Nett = Nett - cSumEmployerDeductions
                //...Employer Deductions are used for reporting as cost to company BUT dont affect Net pay
                curNetPay := curNetPay - curTotCompanyDed; //******Get Company Deduction*****

                curNetRnd_Effect := curNetPay - ROUND(curNetPay);
                curNetPay := ROUND(curNetPay, 0.01, '=');//john //Check here//0.01,'>'
                curTransAmount := curNetPay;
                //check claims first
                fnupdatemedical(strEmpCode, dtOpenPeriod, curNetPay);


                // if strEmpCode=
                //deduct social contribution
                socialcontributionamt := 0;
                socialcontributionamtreg := 0;

                //caclculate registration fee, to subtract from net
                VitalSetup.get;
                VitalSetup.TestField("Social ContributioCode");
                //Message(VitalSetup."Social ContributioCode");    

                prEmployeeTransactions.Reset();
                prEmployeeTransactions.SetRange(prEmployeeTransactions."Employee Code", strEmpCode);
                prEmployeeTransactions.SetRange(prEmployeeTransactions."Payroll Period", dtOpenPeriod);
                prEmployeeTransactions.SetRange(prEmployeeTransactions."Transaction Code", VitalSetup."Social ContributioCode");
                prEmployeeTransactions.SetRange(prEmployeeTransactions."Period Month", Date2DMY(dtOpenPeriod, 2));
                prEmployeeTransactions.SetRange(prEmployeeTransactions."Period Year", Date2DMY(dtOpenPeriod, 3));
                if prEmployeeTransactions.FindFirst() then begin
                    socialcontributionamtreg := prEmployeeTransactions.Amount;
                    // if strEmpCode='ABH-089' then

                    // Error(Format(socialcontributionamtreg));

                end;

                //end of registration fee calculation

                if (socialjoin = true) and (leftsocial = false) and (socialjoindate <= dtOpenPeriod) then begin

                    socialcontributionamt := fnsocialcontributiondeduct(strEmpCode, dtOpenPeriod, curNetPay, socialcontributionamtreg);
                    // if strEmpCode = 'ABH-001' then
                    // Error(format(curTransAmount)+'-->'+Format(socialcontributionamt)+Format(curNetPay));
                    curNetPay := curNetPay - socialcontributionamt;
                    
                    curTransAmount := curNetPay;
                    if socialcontributionamt > 0 then begin
                        socialcontributionamt := socialcontributionamt;
                        socialcontributionamt := Round(socialcontributionamt, 0.01, '=');
                        strTransDescription := 'Social Contribution';
                        TGroup := 'DEDUCTIONS';
                        TGroupOrder := 8;
                        TSubGroupOrder := 1;
                        fnUpdatePeriodTrans(strEmpCode, 'S-CONT', TGroup, TGroupOrder, TSubGroupOrder,
                        strTransDescription, socialcontributionamt, 0, intMonth, intYear, '', '', SelectedPeriod, Dept, socialcontributionAcc,
                        Journalpostas::Credit, Journalpostingtype::"G/L Account", '', Coopparameters::nssf);


                    end;
                end;

                //post total deductions here
                curTotalDeductions := curTotalDeductions + socialcontributionamt + curPAYE + curPensionE;

                curTransBalance := 0;
                strTransCode := 'TOT-DED';
                strTransDescription := 'TOTAL DEDUCTION';
                TGroup := 'DEDUCTIONS';
                TGroupOrder := 8;
                TSubGroupOrder := 9;
                if processadvance = false then
                    fnUpdatePeriodTrans(strEmpCode, strTransCode, TGroup, TGroupOrder, TSubGroupOrder,
                      strTransDescription, curTotalDeductions, curTransBalance, intMonth, intYear,
                      '', prEmployeeTransactions."Reference No", SelectedPeriod, Dept,
                      '', Journalpostas::Credit, Journalpostingtype::" ", '', Coopparameters::none);

                //END GET TOTAL DEDUCTIONS
            end;

            curTransAmount := curTransAmount;
            strTransDescription := 'NET PAY';
            TGroup := 'NET PAY';
            TGroupOrder := 9;
            TSubGroupOrder := 0;

            //update saladvance

            if processadvance = true then begin

                fnupdateadvance(strEmpCode, curNetPay);
            end;


            // if strEmpCode = 'E0010' then begin
            //     Message(Format(curGrossTaxable) + '-->' + Format(curTaxablePay) + '-->' + Format(curGrossPay) + '-->' + format(curNetPay));
            // end;



            // IF curNetPay < 0 THEN MESSAGE('Net Pay for Employee No. %1 is %2',strEmpCode, curNetPay);

            if processadvance = false then
                fnUpdatePeriodTrans(strEmpCode, 'NPAY', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
                curTransAmount, 0, intMonth, intYear, '', '', SelectedPeriod, Dept,
                PayablesAcc, Journalpostas::Credit, Journalpostingtype::"G/L Account", '', Coopparameters::none);

            //  //*************************************************************************************************************
            //  //Added: . To Update PR Staff Bank Transactions with Net Pay Amounts that are transfered to Individual Banks

            //  fnUpdateStaffBankTrans(strEmpCode, 'NPAY',,curTransAmount,
            //                        intMonth, intYear,SelectedPeriod,Dept);


            //  //*************************************************************************************************************
        end;

    end;

    procedure fnPureFormula(strEmpCode: Code[50]; intMonth: Integer; intYear: Integer; strFormula: Text[250]) Formula: Text[250]
    var
        Where: Text[30];
        Which: Text[30];
        i: Integer;
        TransCode: Code[50];
        Char: Text[1];
        StartCopy: Boolean;
        FinalFormula: Text[250];
        TransCodeAmount: Decimal;
    begin
        TransCode := '';
        for i := 1 to StrLen(strFormula) do begin
            Char := CopyStr(strFormula, i, 1);
            if Char = '[' then StartCopy := true;

            if StartCopy then TransCode := TransCode + Char;
            //Copy Characters as long as is not within []
            if not StartCopy then
                FinalFormula := FinalFormula + Char;
            if Char = ']' then begin
                StartCopy := false;
                //Get Transcode
                Where := '=';
                Which := '[]';
                TransCode := DelChr(TransCode, Where, Which);
                //Get TransCodeAmount
                TransCodeAmount := fnGetTransAmount(strEmpCode, TransCode, intMonth, intYear);
                //Reset Transcode
                TransCode := '';
                //Get Final Formula
                FinalFormula := FinalFormula + Format(TransCodeAmount);
                //End Get Transcode
            end;
        end;
        Formula := FinalFormula;
    end;

    procedure fnPureFormula2(strFormula: Text[250]) Formula: Text[250]
    var
        Where: Text[30];
        Which: Text[30];
        i: Integer;
        TransCode: Code[50];
        Char: Text[1];
        StartCopy: Boolean;
        FinalFormula: Text[250];
    begin
        TransCode := '';
        for i := 1 to StrLen(strFormula) do begin
            Char := CopyStr(strFormula, i, 1);
            if Char = '[' then StartCopy := true;

            if StartCopy then TransCode := TransCode + Char;
            //Copy Characters as long as is not within []
            if not StartCopy then
                FinalFormula := FinalFormula + Char;
            if Char = ']' then begin
                StartCopy := false;
                //Get Transcode
                Where := '=';
                Which := '[]';
                TransCode := DelChr(TransCode, Where, Which);
                //Get TransCodeAmount
                // TransCodeAmount := fnGetTransAmount(strEmpCode, TransCode, intMonth, intYear);
                //Reset Transcode
                TransCode := '';
                //Get Final Formula
                FinalFormula := FinalFormula;
                //End Get Transcode
            end;
        end;
        Formula := FinalFormula;
    end;

    procedure fnsocialcontributiondeduct(empno: Code[20]; currperiod: date; netpay: Decimal; contribution: Decimal) contributionamt: Decimal
    var
        prperiods: record "PR Payroll Periods";
        vitalset: record "PR Vital Setup Info";
        prtransactions: record "PR Period Transactions";
    begin
        //contributionamt := 0;
        vitalset.Get;
        vitalset.TestField("Social Cont Registation Amount");
        vitalset.TestField("Social Contriution Perc");
        vitalset.TestField("Social ContributioCode");
        contributionamt := (vitalset."Social Contriution Perc" / 100) * (netpay + contribution);

    end;

    procedure fnupdatemedical(empcode: Code[20]; CurrPayrollPeriod: Date; npay: Decimal) claimamount: Decimal
    var
        vitalset: record "PR Vital Setup Info";
        salgrades: Record "Sal Grades";
        emptransactions: record "PR Employee Transactions";
        hremps: Record "HR-Employee";
        salcard: record "PR Salary Card";
        branches: Record Branches;
        prperiods: record "PR Payroll Periods";
        claimlines: Record "Medical Claim Lines";
        claimheader: Record "Medical Claims Header";
        payrollm: Integer;
        payrolly: Integer;
        previousamt: Decimal;
        currentamt: decimal;
        noofprevious: Integer;
        totalsall: decimal;
        prtransactions: record "PR Period Transactions";
    begin
        vitalset.Get();
        vitalset.TestField("Claims Code");
        prperiods.Reset();
        prperiods.SetRange(prperiods."Date Opened", CurrPayrollPeriod);
        if prperiods.FindFirst() then begin
            payrollm := prperiods."Period Month";
            payrolly := prperiods."Period Year";
        end;
        claimheader.Reset();
        claimheader.SetRange(claimheader."Payroll Period", CurrPayrollPeriod);
        claimheader.SetRange(claimheader.Status, claimheader.Status::approved);
        if claimheader.FindFirst() then begin
            claimlines.Reset();
            claimlines.SetRange(claimlines."Claim No", claimheader."Claim No");
            claimlines.SetRange(claimlines."Vendor No", claimheader."Vendor No");
            if claimlines.FindFirst() then begin
                claimlines.CalcFields("Amount paid");
                claimlines.Validate("Amount paid");
                if claimlines.Balance > 0 then begin
                    emptransactions.Reset();
                    emptransactions.SetRange(emptransactions."Transaction Code", vitalset."Claims Code");
                    emptransactions.SetRange(emptransactions."Payroll Period", CurrPayrollPeriod);
                    emptransactions.SetRange(emptransactions."Period Month", payrollm);
                    emptransactions.SetRange(emptransactions."Period Year", payrolly);
                    emptransactions.SetRange(emptransactions."Employee Code", empcode);
                    if emptransactions.FindFirst() then begin
                        emptransactions.Amount := claimlines.Balance;
                        emptransactions.Validate("Transaction Code");
                        emptransactions.Modify();

                    end else if not emptransactions.Find() then begin
                        emptransactions.Init();
                        emptransactions."Transaction Code" := vitalset."Claims Code";
                        emptransactions.Validate("Transaction Code");
                        emptransactions."Employee Code" := empcode;
                        emptransactions."Payroll Period" := CurrPayrollPeriod;
                        emptransactions."Period Month" := payrollm;
                        emptransactions."Period Year" := payrolly;
                        emptransactions.Amount := claimlines.Balance;
                        emptransactions.Validate(Amount);
                        emptransactions.Insert();

                    end;

                end;

            end;
        end;

    end;

    procedure fnupdateadvance(empcode: code[20]; npay: Decimal)
    var
        saladvance: record "Staff Advance Header";
        advancelines: Record "Staff Advance Lines";
    begin
        saladvance.Reset();
        saladvance.SetRange(saladvance."Staff ID", empcode);
        saladvance.SetRange(saladvance."Send to payroll", true);
        saladvance.SetRange(saladvance.Posted, false);
        saladvance.SetRange(saladvance.Status, saladvance.Status::Approved);
        if saladvance.FindFirst() then begin
            advancelines.Reset();
            advancelines.SetRange(advancelines.No, saladvance."No.");
            advancelines.SetRange(advancelines."Advance Type", 'SALARY');
            if advancelines.FindFirst() then begin

                if advancelines."Percentage of Salary" > 0 then begin
                    advancelines.Amount := (advancelines."Percentage of Salary" / 100) * npay;
                    advancelines.Modify;
                end;
            end
        end;

    end;


    procedure fnUpdateEmployeeTrans(EmpCode: Code[50]; TransCode: Code[50]; Amount: Decimal; Month: Integer; Year: Integer; PayrollPeriod: Date)
    var
        prEmployeeTrans: Record "PR Employee Transactions";
    begin
        prEmployeeTrans.Reset;
        prEmployeeTrans.SetRange(prEmployeeTrans."Employee Code", EmpCode);
        prEmployeeTrans.SetRange(prEmployeeTrans."Transaction Code", TransCode);
        prEmployeeTrans.SetRange(prEmployeeTrans."Payroll Period", PayrollPeriod);
        prEmployeeTrans.SetRange(prEmployeeTrans."Period Month", Month);
        prEmployeeTrans.SetRange(prEmployeeTrans."Period Year", Year);
        if prEmployeeTrans.FindFirst() then begin
            prEmployeeTrans.Amount := Amount;
            prEmployeeTrans.Modify;
        end;
    end;

    procedure fnUpdateEmployerDeductions(EmpCode: Code[50]; TCode: Code[50]; TGroup: Code[50]; GroupOrder: Integer; SubGroupOrder: Integer; Description: Text[50]; curAmount: Decimal; curBalance: Decimal; Month: Integer; Year: Integer; mMembership: Text[30]; ReferenceNo: Text[30]; dtOpenPeriod: Date)
    var
        prEmployerDeductions: Record "PR Employer Deductions";
    begin

        if curAmount = 0 then exit;

        prEmployerDeductions.Init;
        prEmployerDeductions."Employee Code" := EmpCode;
        prEmployerDeductions."Transaction Code" := TCode;
        prEmployerDeductions.Amount := curAmount;
        prEmployerDeductions."Period Month" := Month;
        prEmployerDeductions."Period Year" := Year;
        prEmployerDeductions."Payroll Period" := dtOpenPeriod;
        //Insert Dim and Contract Type for each Trans Being Updated
        if HREmp2.Get(EmpCode) then begin
            prEmployerDeductions."Global Dimension 1 Code" := HREmp2."Global Dimension 1 Code";
            prEmployerDeductions."Global Dimension 2 Code" := HREmp."Global Dimension 2 Code";
            prEmployerDeductions."Contract Type" := HREmp2."Contract Type";
            prEmployerDeductions."Posting Group" := HREmp2."Payroll Posting Group";
            prEmployerDeductions."Previous Payment System" := HREmp2."Previous Payment System";
        end;
        //Insert Transaction Type (Either "Income or Deduction") for each Trans Being Updated
        prEmployerDeductions.Insert;
    end;

    procedure fnUpdateP9Table(P9EmployeeCode: Code[50]; P9BasicPay: Decimal; P9Allowances: Decimal; P9Benefits: Decimal; P9ValueOfQuarters: Decimal; P9DefinedContribution: Decimal; P9OwnerOccupierInterest: Decimal; P9GrossPay: Decimal; P9TaxablePay: Decimal; P9TaxCharged: Decimal; P9InsuranceRelief: Decimal; P9TaxRelief: Decimal; P9Paye: Decimal; P9Pension: Decimal; P9NHIF: Decimal; P9Deductions: Decimal; P9NetPay: Decimal; dtCurrPeriod: Date)
    var
        prEmployeeP9Info: Record "PR Employee P9 Info";
        intYear: Integer;
        intMonth: Integer;
    begin
        intMonth := Date2dmy(dtCurrPeriod, 2);
        intYear := Date2dmy(dtCurrPeriod, 3);

        prEmployeeP9Info.Reset;
        prEmployeeP9Info.setrange(prEmployeeP9Info."Employee Code", P9EmployeeCode);
        prEmployeeP9Info.setrange(prEmployeeP9Info."Payroll Period", dtCurrPeriod);
        if prEmployeeP9Info.find('-') then
            prEmployeeP9Info.DeleteAll();

        prEmployeeP9Info.Init;
        prEmployeeP9Info."Employee Code" := P9EmployeeCode;
        prEmployeeP9Info."Basic Pay" := P9BasicPay;
        prEmployeeP9Info.Allowances := P9Allowances;
        prEmployeeP9Info.Benefits := P9Benefits;
        prEmployeeP9Info."Value Of Quarters" := P9ValueOfQuarters;
        prEmployeeP9Info."Defined Contribution" := P9DefinedContribution;
        prEmployeeP9Info."Owner Occupier Interest" := P9OwnerOccupierInterest;
        prEmployeeP9Info."Gross Pay" := P9GrossPay;
        prEmployeeP9Info."Taxable Pay" := P9TaxablePay;
        prEmployeeP9Info."Tax Charged" := P9TaxCharged;
        prEmployeeP9Info."Insurance Relief" := P9InsuranceRelief;
        prEmployeeP9Info."Tax Relief" := P9TaxRelief;
        prEmployeeP9Info.PAYE := P9Paye;
        prEmployeeP9Info.Pension := P9Pension;
        prEmployeeP9Info.NHIF := P9NHIF;
        prEmployeeP9Info.Deductions := P9Deductions;
        prEmployeeP9Info."Net Pay" := P9NetPay;
        prEmployeeP9Info."Period Month" := intMonth;
        prEmployeeP9Info."Period Year" := intYear;
        prEmployeeP9Info."Payroll Period" := dtCurrPeriod;
        prEmployeeP9Info.Insert;
    end;

    procedure fnUpdatePeriodTrans(EmpCode: Code[50]; TCode: Code[50]; TGroup: Code[50]; GroupOrder: Integer; SubGroupOrder: Integer; Description: Text[50]; curAmount: Decimal; curBalance: Decimal; Month: Integer; Year: Integer; mMembership: Text[30]; ReferenceNo: Text[30]; dtOpenPeriod: Date; Department: Code[50]; JournalAC: Code[50]; PostAs: Option " ",Debit,Credit; JournalACType: Option " ","G/L Account",Customer,Vendor; LoanNo: Code[10]; CoopParam: Option "none",shares,loan,"loan Interest","Emergency loan","Emergency loan Interest","School Fees loan","School Fees loan Interest",Welfare,Pension)
    var
        PRPeriodTransactions: Record "PR Period Transactions";
        HREmp_3: Record "HR-Employee";
        AllowInsert: Boolean;
        PRTransCode: Record "PR Transaction Codes";
    begin
        //******************************************************************************************************************************************
        /* Added Dann. for Multiple bank A/Cs                                                                                                       */
        //******************************************************************************************************************************************
        AllowInsert := true;
        if HREmp_3.get(EmpCode) then begin
            if PRTransCode.get(TCode) then begin
                if ((HREmp_3."On Suspension" = true) or (HREmp_3."On Interdiction" = true)) and (PRTransCode.isHouseAllowance = false) and ((TCode <> 'NPAY') or (TCode = 'BPAY') or (TCode = 'Pension') or (TCode = 'NHIF')) then begin
                    AllowInsert := false;
                end;
            end;

        end;
        if TCode = 'NPAY' then begin
            HREmp_3.Reset;
            HREmp_3.SetRange(HREmp_3."No.", EmpCode);
            if HREmp_3.FindFirst() then begin
                repeat

                    //Enable bank account checking

                    // HREmp_3.TestField(HREmp_3."Main Bank");
                    // HREmp_3.TestField(HREmp_3."Branch Bank");
                    // HREmp_3.TestField(HREmp_3."Bank Account Number");
                    //HREmp_3.TestField(HREmp_3."Bank and Branch Code");

                    HRBankSummary.Reset;
                    HRBankSummary.Init;

                    HRBankSummary."Line No." := GetLastEntryNo;
                    HRBankSummary."Bank Code" := HREmp_3."Main Bank";
                    HRBankSummary."Branch Code" := HREmp_3."Branch Bank";
                    HRBankSummary."Bank and Branch Code" := HREmp_3."Bank and Branch Code";
                    HRBankSummary."Staff Bank Name" := HREmp_3."Full Name";
                    HRBankSummary."Payroll Period" := dtOpenPeriod;
                    HRBankSummary.Amount := curAmount;
                    HRBankSummary."Transaction Code" := 'NPAY';
                    HRBankSummary."No." := EmpCode;
                    HRBankSummary."Bank Name" := HREmp_3."Bank Name";
                    HRBankSummary."Branch Name" := HREmp_3."Branch Name";
                    HRBankSummary."A/C Number" := HREmp_3."Bank Account Number";
                    if HREmp_3.Get(EmpCode) then begin
                        HRBankSummary."Posting Group" := HREmp_3."Payroll Posting Group";
                    end;


                    if HRBankSummary.Amount > 0 then HRBankSummary.Insert;

                until HREmp_3.Next = 0;
            end else begin
                //ERROR('No Bank A/C has been specified for [Employee No %1]',EmpCode);
            end;
        end;
        //******************************************************************************************************************************************
        //******************************************************************************************************************************************


        if curAmount = 0 then exit;

        PRPeriodTransactions.Init;
        PRPeriodTransactions."Employee Code" := EmpCode;
        PRPeriodTransactions."Transaction Code" := TCode;
        PRPeriodTransactions."Group Text" := TGroup;
        PRPeriodTransactions."Transaction Name" := Description;
        PRPeriodTransactions.Amount := curAmount;
        curAmount := ROUND(curAmount, 0.2, '=');
        PRPeriodTransactions.Balance := curBalance;
        PRPeriodTransactions."Original Amount" := PRPeriodTransactions.Balance;
        PRPeriodTransactions."Group Order" := GroupOrder;
        PRPeriodTransactions."Sub Group Order" := SubGroupOrder;
        PRPeriodTransactions."Reference No" := ReferenceNo;
        PRPeriodTransactions."Period Month" := Month;
        PRPeriodTransactions."Period Year" := Year;
        PRPeriodTransactions."Payroll Period" := dtOpenPeriod;
        PRPeriodTransactions."Global DImension 1 Code" := Department;
        PRPeriodTransactions."Journal Account Type" := JournalACType;
        PRPeriodTransactions."Post As" := PostAs;
        PRPeriodTransactions."Journal Account Code" := JournalAC;
        PRPeriodTransactions."Loan Number" := LoanNo;
        PRPeriodTransactions."coop parameters" := CoopParam;
        //
        //Insert Dim and Contract Type for each Trans Being Updated
        if HREmp2.Get(EmpCode) then begin

            HREmp2.TestField("Payroll Posting Group");

            PRPeriodTransactions."Global Dimension 1 Code" := HREmp2."Global Dimension 1 Code";
            PRPeriodTransactions."Global Dimension 2 Code" := HREmp."Global Dimension 2 Code";
            PRPeriodTransactions."Contract Type" := HREmp2."Contract Type";
            PRPeriodTransactions."Posting Group" := HREmp2."Payroll Posting Group";
            PRPeriodTransactions."Employee Type" := HREmp2."Employee Type";
            PRPeriodTransactions."Previous Payment System" := HREmp2."Previous Payment System";
        end;
        //Insert Transaction Type (Either "Income or Deduction") for each Trans Being Updated
        PRTransCode.Reset;
        PRTransCode.SetRange(PRTransCode."Transaction Code", TCode);
        if PRTransCode.FindFirst() then begin
            PRPeriodTransactions."Transaction Type" := PRTransCode."Transaction Type";
        end;

        PRPeriodTransactions.Insert;
        //Update the prEmployee Transactions  with the Amount

        //fnUpdateEmployeeTrans(PRPeriodTransactions."Employee Code", PRPeriodTransactions."Transaction Code", PRPeriodTransactions.Amount, PRPeriodTransactions."Period Month", PRPeriodTransactions."Period Year", PRPeriodTransactions."Payroll Period");


    end;


    local procedure GetLastEntryNo() LastLineNum: Integer
    var
        HRBankSummary_2: Record "HR Bank Summary";
    begin
        HRBankSummary_2.Reset;
        if HRBankSummary_2.FindLast then begin
            LastLineNum := HRBankSummary_2."Line No." + 1;
        end else begin
            LastLineNum := 1;
        end;
    end;

    procedure fnClearCurrentPeriod(SelectedPeriod: Date; dtOpenPeriod: Date; EmpNo: code[20])
    var
        prPeriodTransactions: Record "PR Period Transactions";
        prBankSummary: Record "HR Bank Summary";
    begin

        dtOpenPeriod := fnGetOpenPeriod();
        //check if the period selected=current period. If not, do NOT run this function
        if SelectedPeriod <> dtOpenPeriod then exit;

        //Delete all Records from the prPeriod Transactions for Reprocessing
        prPeriodTransactions.Reset;
        prPeriodTransactions.SetRange(prPeriodTransactions."Payroll Period", dtOpenPeriod);
        if EmpNo <> '' then prPeriodTransactions.SetRange("Employee Code", EmpNo);
        if prPeriodTransactions.FindFirst() then
            prPeriodTransactions.DeleteAll;

        prBankSummary.Reset;
        prBankSummary.SetRange(prBankSummary."Payroll Period", dtOpenPeriod);
        if EmpNo <> '' then prBankSummary.SetRange(prBankSummary."No.", EmpNo);
        if prBankSummary.FindFirst() then
            prBankSummary.DeleteAll;
    end;
}

