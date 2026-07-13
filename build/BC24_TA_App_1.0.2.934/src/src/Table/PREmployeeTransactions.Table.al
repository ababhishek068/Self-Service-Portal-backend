Table 50517 "PR Employee Transactions"
{
    DataCaptionFields = "Employee Code";

    fields
    {
        field(1; "Employee Code"; Code[30])
        {
            TableRelation = "HR-Employee"."No.";
        }
        field(2; "Transaction Code"; Code[30])
        {
            TableRelation = "PR Transaction Codes"."Transaction Code" where("Transaction Code" = filter(<> ''));

            trigger OnValidate()
            var
                strExtractedFrml: text[100];
                PRPayroll: codeunit "PR Payroll Processing";
                LeaveLedger: record "HR Leave Allocation";
                LeaveCalendar: Record "HR Leave Calendar";
                lDays: integer;
            begin

                if "Transaction Code" <> '' then begin
                    EmployeeTrans.Reset;
                    EmployeeTrans.SetRange(EmployeeTrans."Transaction Code", "Transaction Code");
                    EmployeeTrans.SetRange(EmployeeTrans."Employee Code", "Employee Code");
                    EmployeeTrans.SetRange(EmployeeTrans."Payroll Period", "Payroll Period");
                    EmployeeTrans.SetRange(EmployeeTrans."Reference No", "Reference No");
                    if EmployeeTrans.FindFirst() then begin
                        //  Error('Transaction Code [ %1 ] has already been assigned to "No." [ %2 ] Payroll Period [ %3 ]'
                        //       , "Transaction Code", "Employee Code", "Payroll Period");
                    end;
                end;


                Transcode.Reset;
                Transcode.SetRange(Transcode."Transaction Code", "Transaction Code");
                if Transcode.FindFirst() then begin
                    "Transaction Name" := Transcode."Transaction Name";

                    if Transcode.Frequency = Transcode.Frequency::Varied then
                        "Stop for Next Period" := true;

                    //Leave Allowance
                    if Transcode."Special Trans Incomes" = Transcode."special trans incomes"::"Leave Allowance" then begin
                        SalCard.Reset;
                        SalCard.SetRange(SalCard."Employee Code", "Employee Code");
                        if SalCard.FindFirst() then begin
                            Amount := (1 / 3) * SalCard."Basic Pay";
                            Amount := ROUND(Amount, 1, '<');
                            if Amount > 50000 then Amount := 50000;
                            // "Start Date":=TODAY;  //Remvoe this
                            //"End Date":=20163108D; //Remove this
                        end;
                    end;

                    //Transfer Allowance
                    if Transcode."Special Trans Incomes" = Transcode."special trans incomes"::"Transfer Allowance" then begin
                        SalCard.Reset;
                        SalCard.SetRange(SalCard."Employee Code", "Employee Code");
                        if SalCard.FindFirst() then begin
                            Amount := SalCard."Basic Pay" * 2;
                            Amount := ROUND(Amount, 1, '<');
                            "Start Date" := Today;  //Remvoe this
                            "End Date" := 20320831D; //Remove this
                        end;
                    end;
                    if Transcode."Is Formula" = true then begin
                        SalCard.Reset;
                        SalCard.SetRange(SalCard."Employee Code", "Employee Code");
                        if SalCard.FindFirst() then begin
                            strExtractedFrml := PRPayroll.fnPureFormula("Employee Code", "Period Month", "Period Year", Transcode.Formula);
                            //strExtractedFrml := PRPayroll.fnPureFormula2(Transcode.Formula);
                            // strExtractedFrml := strExtractedFrml + Format(SalCard."Basic Pay");
                            //Message(Transcode.Formula + '--' + strExtractedFrml + '-' + Format(PRPayroll.fnFormulaResult(strExtractedFrml)));

                            Amount := PRPayroll.fnFormulaResult(strExtractedFrml); //Get the calculated amount
                        end;
                    end;
                    if Transcode."coop parameters" = Transcode."coop parameters"::Pension then begin
                        SalCard.Reset;
                        SalCard.SetRange(SalCard."Employee Code", "Employee Code");
                        if SalCard.FindFirst() then begin
                            Amount := SalCard."Basic Pay" * Transcode."Formula %";
                        end;
                    end;
                end;
                if Transcode."Is Leave Allowance" = true then begin
                    LeaveCalendar.reset;
                    LeaveCalendar.setrange(Current, true);
                    if LeaveCalendar.find('-') then begin
                        LeaveLedger.reset;
                        LeaveLedger.SetRange(LeaveLedger."No.", "Employee Code");
                        LeaveLedger.SetRange("Entry Type", LeaveLedger."Entry Type"::"Negative Adjustment");
                        LeaveLedger.SetRange("Calendar Code", LeaveCalendar.Code);
                        if LeaveLedger.find('-') then begin
                            repeat
                                lDays := lDays + LeaveLedger."No. Of days"
                            until LeaveLedger.next = 0;
                        end;
                        "Taken Leave Days" := LDays;
                    end;
                end;
            end;
        }
        field(3; "Transaction Name"; Text[100])
        {
            editable = false;
        }
        field(4; Amount; Decimal)
        {
            trigger OnValidate()
            begin
                // validate("Amount Borrowed");
                if "Original Amount" > 0 then
                    "#of Repayments" := "Amount Borrowed" / Amount;

                if Transcode.get("Transaction Code") then begin
                    if Transcode."Is Leave Allowance" = true then
                        if "Taken Leave Days" < 15 then
                            error('Please note that the minimum leave days for leave allowance is 15 days');
                end
            end;


        }
        field(5; Balance; Decimal)
        {

            trigger OnValidate()
            begin
                "#of Repayments" := 0;
                //IF (Balance > 0) AND ("#of Repayments" > 0) THEN
                //Amount:=Balance/"#of Repayments"
            end;
        }
        field(6; "Original Amount"; Decimal) { }
        field(7; "Period Month"; Integer) { }
        field(8; "Period Year"; Integer) { }
        field(9; "Payroll Period"; Date)
        {
            TableRelation = "PR Payroll Periods"."Date Opened";
        }
        field(10; "#of Repayments"; Integer)
        {

            trigger OnValidate()
            begin
                if (Balance > 0) and ("#of Repayments" > 0) then
                    Amount := Balance / "#of Repayments"
            end;
        }

        field(12; "Reference No"; Text[100]) { }
        field(13; integera; Integer) { }
        field(14; "Employer Amount"; Decimal) { }
        field(15; "Employer Balance"; Decimal) { }
        field(16; "Stop for Next Period"; Boolean) { }
        field(17; "Amortized Loan Total Repay Amt"; Decimal) { }
        field(18; "Start Date"; Date) { }
        field(19; "End Date"; Date) { }
        field(20; "Loan Number"; Code[10]) { }

        field(22; "No of Units"; Decimal) { }
        field(23; Suspended; Boolean) { }
        field(24; "Entry No"; Integer)
        {
            AutoIncrement = false;
        }
        field(38; "IsCoop/LnRep"; Boolean)
        {
            CalcFormula = lookup("PR Transaction Codes"."IsCoop/LnRep" where("Transaction Code" = field("Transaction Code")));
            Description = 'to be able to report the different coop contributions -Dennis';
            FieldClass = FlowField;
        }
        field(41; Stopped; Boolean) { }
        field(42; "Subledger Account"; Code[10])
        {
            TableRelation = if ("Subledger Account" = const('VENDOR')) Vendor."No." where(Blocked = filter(<> All),
                                                                                         "Vendor Posting Group" = const('OTHERS'))
            else
            if ("Subledger Account" = const('CUSTOMER')) Customer."No." where(Blocked = filter(<> All));
        }
        field(43; Subledger; Option)
        {
            OptionCaption = ' ,Customer,Vendor';
            OptionMembers = " ",Customer,Vendor;
        }
        field(44; "Sacco loan"; Boolean) { }
        field(45; "Sacco share"; Boolean) { }
        field(47; "Loan Interest Rate"; Decimal) { }
        field(48; "Exempt from Interest"; Boolean)
        {

            trigger OnValidate()
            begin
                /*
                if not "Exempt from Interest" then
                begin
                    if Confirm('Disable Staff No [ %1 ] from paying Interest on this Transaction Code [ %2 - %3? ]',false
                                  ,"Employee Code","Transaction Code","Transaction Name") = true then
                    begin
                        "Exempt from Interest":=true;
                    end else
                    begin
                        error('Aborted');
                    end;
                end else
                begin
                    if Confirm('Enalbe Staff No [ %1 ] to pay Interest on this Transaction Code [ %2 - %3? ]',false
                                  ,"Employee Code","Transaction Code","Transaction Name") = true then
                    begin
                        "Exempt from Interest":=true;
                    end else
                    begin
                        error('Aborted');
                    end;
                
                end;
                 */

            end;
        }
        field(52; "Transaction Type"; Option)
        {
            CalcFormula = lookup("PR Transaction Codes"."Transaction Type" where("Transaction Code" = field("Transaction Code")));
            Description = 'Income,Deduction';
            FieldClass = FlowField;
            OptionMembers = Income,Deduction,Benefit;
        }
        field(53; "coop parameters"; Option)
        {
            Caption = 'Other Categorization';
            OptionMembers = "none",shares,loan,"loan Interest","Emergency loan","Emergency loan Interest","School Fees loan","School Fees loan Interest",Welfare,Pension,Overtime;
            FieldClass = FlowField;
            CalcFormula = Lookup("PR Transaction Codes"."coop parameters" WHERE("Transaction Code" = FIELD("Transaction Code")));
        }

        field(54; "Has Insurance Certificate"; enum "Has Insurance Certificate")
        {
            //OptionMembers = " ","No","Yes";
            trigger OnValidate()
            var
                PRTransCode: Record "PR Transaction Codes";
            begin
                PRTransCode.Reset();
                PRTransCode.SetRange("Transaction Code", "Transaction Code");
                if PRTransCode.FindFirst() then begin
                    PRTransCode.TestField("Special Trans Deductions", PRTransCode."Special Trans Deductions"::"Life Insurance");
                end;
            end;
        }

        field(55; "Amount Borrowed"; Decimal)
        {
            BlankZero = true;
            caption = 'Initial Loan Amount';

            trigger OnValidate()
            var
                NewSchedule: Record "Loan Repayment Schedule";
                RemainingPrincipalAmountDec: Decimal;
                RunningDate: Date;
                RepaymentAmt: Decimal;
                LoopEndBool: Boolean;
                InterestAmountDec: Decimal;
                LoanTypeRec: Record "PR Transaction Codes";
                RoundPrecisionDec: Decimal;
                RoundDirectionCode: Code[20];
                LineNoInt: Integer;

            begin
                if LoanTypeRec.get("Transaction Code") then begin
                    if LoanTypeRec."coop parameters" <> LoanTypeRec."coop parameters"::none then begin
                        NewSchedule.Reset();
                        NewSchedule.SetRange("Loan No", "Transaction Code");
                        NewSchedule.SetRange("Employee No", "Employee Code");
                        NewSchedule.DeleteAll();


                        Balance := "Amount Borrowed";
                        if ("Total Installments" > 0) and ("Total Installments" > 0) and (Amount = 0) then
                            Amount := "Amount Borrowed" / "Total Installments";

                        RemainingPrincipalAmountDec := 0;
                        LoopEndBool := FALSE;
                        LineNoInt := 0;

                        IF "Total Installments" <= 0 THEN ERROR('Instalment Amount must be specified');

                        TestField("Amount Borrowed");

                        RemainingPrincipalAmountDec := "Amount Borrowed";
                        RunningDate := "Loan Application Date";
                        RepaymentAmt := Amount;


                        RoundPrecisionDec := 1;
                        RoundDirectionCode := '=';

                        LoanTypeRec.Reset();
                        LoanTypeRec.SetRange("Transaction Code", "Transaction Code");
                        if LoanTypeRec.FindFirst() then begin
                            //LoanTypeRec.TestField("Interest Rate");
                        end;

                        REPEAT
                            if LoanTypeRec."Interest Rate" > 0 then
                                InterestAmountDec := ROUND(RemainingPrincipalAmountDec * (LoanTypeRec."Interest Rate" / 100) / 12, RoundPrecisionDec, RoundDirectionCode);    //
                                                                                                                                                                              // MESSAGE('%1 %2 %3',RepaymentAmt,RemainingPrincipalAmountDec,RunningDate);
                                                                                                                                                                              // IF InterestAmountDec >=RepaymentAmt  THEN
                                                                                                                                                                              //   ERROR('This Loan is not possible because\the the instalment Amount must\be higher than %1',InterestAmountDec);
                                                                                                                                                                              //
                            LineNoInt := LineNoInt + 1;
                            NewSchedule."Instalment No" := LineNoInt;
                            NewSchedule."Employee No" := "Employee Code";
                            NewSchedule."Loan No" := "Transaction Code";
                            NewSchedule."Repayment Date" := RunningDate;
                            NewSchedule."Monthly Interest" := InterestAmountDec;
                            if LoanTypeRec."Interest Rate" > 0 then
                                NewSchedule."Interest Rate" := (LoanTypeRec."Interest Rate" / 100) / 12;
                            //NewSchedule."Monthly Repayment" := RepaymentAmt + InterestAmountDec;

                            NewSchedule."Monthly Repayment" := Amount;
                            //NewSchedule."Loan Category" := "Loan Product Type";
                            NewSchedule."Loan Amount" := RemainingPrincipalAmountDec;
                            if Amount <> 0 then
                                NewSchedule."Principal Repayment" := Amount
                            else
                                NewSchedule."Principal Repayment" := RepaymentAmt;//NewSchedule."Monthly Repayment"-NewSchedule."Monthly Interest";

                            NewSchedule."Monthly Repayment" := NewSchedule."Principal Repayment" + InterestAmountDec;
                            // Area to be looked at
                            IF LineNoInt = "Total Installments" THEN BEGIN
                                NewSchedule."Remaining Debt" := 0;
                                NewSchedule."Monthly Repayment" := RemainingPrincipalAmountDec + NewSchedule."Monthly Interest";

                                LoopEndBool := TRUE;
                            END;

                            IF RepaymentAmt >= RemainingPrincipalAmountDec THEN BEGIN  // - InterestAmountDec)
                                NewSchedule."Principal Repayment" := RemainingPrincipalAmountDec;
                                NewSchedule."Remaining Debt" := 0;
                                LoopEndBool := TRUE;
                            END ELSE BEGIN
                                NewSchedule."Principal Repayment" := RepaymentAmt;// - InterestAmountDec
                                RemainingPrincipalAmountDec := RemainingPrincipalAmountDec - RepaymentAmt;// - InterestAmountDec)
                                NewSchedule."Remaining Debt" := RemainingPrincipalAmountDec;
                            END;
                            NewSchedule."Remaining Debt" := NewSchedule."Remaining Debt" + RepaymentAmt;
                            NewSchedule.INSERT;
                            RunningDate := CALCDATE('1M', RunningDate);

                        UNTIL LoopEndBool;
                    end;
                end;
            end;
        }
        field(56; "Loan Application Date"; Date)
        {
            trigger OnValidate()
            begin
                if "Amount Borrowed" <> 0 then Validate("Amount Borrowed");
            end;
        }

        field(57; "Total Installments"; Integer)
        {
            BlankZero = true;

            trigger OnValidate()
            begin
                if "Amount Borrowed" <> 0 then begin
                    Validate("Amount Borrowed");
                    if "Total Installments" > 0 then
                        Amount := "Amount Borrowed" / "Total Installments";
                end;

            end;
        }
        field(58; "Leave Application No"; code[20])
        {
            TableRelation = "HR Leave Application"."Application Code" where("Employee No." = field("Employee Code"), Status = filter(Posted));
            trigger OnValidate()
            var
                LeaveApp: record "HR Leave Application";
            begin
                if LeaveApp.get("Leave Application No") then
                    "Taken Leave Days" := LeaveApp."Days Applied";
            end;
        }
        field(59; "Taken Leave Days"; Integer) { }
        field(60; "Absent Days"; Integer)
        {
            trigger OnValidate()
            var
                EmpSal: record "PR Salary Card";
            begin
                if EmpSal.get("Employee Code") then begin
                    if "Absent Days" > 0 then begin
                        Amount := ("Absent Days" / 30) * EmpSal."Basic Pay";
                    end;
                end;
            end;
        }
    }

    keys
    {
        key(Key1; "Employee Code", "Transaction Code", "Period Month", "Period Year", "Payroll Period", "Reference No")
        {
            Clustered = true;
            SumIndexFields = Amount;
        }
        key(Key2; "Employee Code", "Transaction Code", "Period Month", "Period Year", Suspended) { }
    }

    fieldgroups { }

    trigger OnDelete()
    begin

    end;

    trigger OnInsert()
    var
    begin

    end;

    trigger OnModify()
    begin

    end;

    var
        Transcode: Record "PR Transaction Codes";
        EmployeeTrans: Record "PR Employee Transactions";
        SalCard: Record "PR Salary Card";
}

