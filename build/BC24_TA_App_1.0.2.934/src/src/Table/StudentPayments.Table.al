Table 50083 "Student Payments"
{

    fields
    {
        field(1; "Student No."; Code[20])
        {
            Editable = false;
        }
        field(2; "User ID"; Code[20])
        {
            Editable = false;
        }
        field(3; "Cheque No"; Code[50])
        {

            trigger OnValidate()
            begin
                /*
                StudPay.RESET;
               // studpay.setrange(StudPay."Student No.","Student No.");
                StudPay.SETRANGE(StudPay."Cheque No","Cheque No");
                IF StudPay.FIND('-') THEN
                IF NOT CONFIRM('The selected Receipt Number already exists, Do want to re-use?') THEN
                */

            end;
        }
        field(4; "Drawer Name"; Text[100]) { }
        field(5; "Drawer Bank"; Option)
        {
            OptionMembers = " ",BBK,KCB,CBA,Standard,Stanbic;
        }
        field(6; "Drawer' Branch Code"; Code[20]) { }
        field(7; Balance; Decimal)
        {
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" where("Customer No." = field("Student No.")));
            Editable = false;
            Enabled = true;
            FieldClass = FlowField;
        }
        field(8; "Amount to pay"; Decimal) { }
        field(9; TempBalance; Decimal) { }
        field(10; "Payment Mode"; Option)
        {
            OptionCaption = ' ,Bank Slip,Cheque,Banker''s Cheque,Cash,Mpesa,PDQ,Unreferenced,Money Order,Direct Bank Deposit,Staff Invoice,Weiver,HELB,CDF,Sponsor';
            OptionMembers = " ","Bank Slip",Cheque,"Banker's Cheque",Cash,Mpesa,PDQ,Unreferenced,"Money Order","Direct Bank Deposit","Staff Invoice",Weiver,HELB,CDF,Sponsor;
        }
        field(11; Programme; Code[20]) { }
        field(12; "Applies to Doc No"; Code[30])
        {
            TableRelation = "Receipts Header"."No." where(Posted = const(true));

            trigger OnValidate()
            begin
                if ReceiptH.Get("Applies to Doc No") then begin
                    CalcFields("Allocated Amount");
                    if "Amount to pay" > ReceiptH."Amount Recieved" then Error('Please note that you can not allocate more than receipt amount. ' + Format("Amount to pay") + '/' + Format(ReceiptH."Amount Recieved"));
                end;
            end;
        }
        field(13; "Apply to Overpayment"; Integer)
        {

            trigger OnLookup()
            begin
                CustLedger.SetRange("Customer No.", "Student No.");
                CustLedger.SetRange(Open, true);
                //CustLedger.SETRANGE(CustLedger."Document Type",CustLedger."Document Type"::Payment);
                if Page.RunModal(25, CustLedger) = Action::LookupOK then begin
                    CustLedger.CalcFields("Remaining Amt. (LCY)");
                    "Over Paid Amount" := Abs(CustLedger."Remaining Amt. (LCY)");
                    "Applies to Doc No" := CustLedger."Document No.";
                    "Apply to Overpayment" := CustLedger."Entry No.";
                    "Amount to pay" := "Over Paid Amount";
                    Validate("Amount to pay");
                    Modify;
                end;
            end;

            trigger OnValidate()
            begin
                if "Apply to Overpayment" = 0 then begin
                    "Over Paid Amount" := 0;
                    "Applies to Doc No" := '';
                end;
            end;
        }
        field(14; "Over Paid Amount"; Decimal) { }
        field(15; "Bank No."; Code[20])
        {
            TableRelation = "Bank Account"."No.";

            trigger OnValidate()
            begin
                if bank.Get("Bank No.") then begin
                    "Bank Name" := bank.Name;
                    if "Payment Mode" = "payment mode"::Unreferenced then
                        "UnIndentified G/L Account" := bank."UnIndentified Receipts A/c";
                end;
                /*
                IF "Payment Mode"="Payment Mode"::Unreferenced THEN BEGIN
                  bank.TESTFIELD("UnIndentified Receipts A/c");
                  "UnIndentified G/L Account":=bank."UnIndentified Receipts A/c";
                END;
                 */

            end;
        }
        field(16; "Payment By"; Text[150]) { }
        field(17; "Unapplied Amount"; Decimal) { }
        field(18; "Bank Slip Date"; Date) { }
        field(19; "Transaction Date"; Date) { }
        field(20; "Receipt No"; Code[40]) { }
        field(21; "Auto Post"; Boolean)
        {

            trigger OnValidate()
            begin

                TestField("Transaction Date");
                //IF COMPANYNAME = 'Kenya College of Accountancy 2' THEN
                //TESTFIELD("KCA Receipt No");


                //IF CONFIRM('Do you want to post the transaction?',TRUE) = FALSE THEN BEGIN
                //EXIT;
                //END;

                if "Payment Mode" = "payment mode"::"Bank Slip" then
                    TestField("Bank Slip Date");

                GenJnl.Reset;
                GenJnl.SetRange("Journal Template Name", 'SALES');
                GenJnl.SetRange("Journal Batch Name", 'STUD PAY');
                GenJnl.DeleteAll;

                GenSetUp.Get();

                //Charge Student if not charged
                StudentCharges.Reset;
                StudentCharges.SetRange(StudentCharges."Student No.", "Student No.");
                StudentCharges.SetRange(StudentCharges.Recognized, false);
                if StudentCharges.Find('-') then begin

                    repeat

                        DueDate := StudentCharges.Date;
                        if Sems.Get(StudentCharges.Semester) then begin
                            if Sems.From <> 0D then begin
                                if Sems.From > DueDate then
                                    DueDate := Sems.From;
                            end;
                        end;


                        GenJnl.Init;
                        GenJnl."Line No." := GenJnl."Line No." + 10000;
                        GenJnl."Posting Date" := "Transaction Date";
                        GenJnl."Document No." := StudentCharges."Transacton ID";
                        GenJnl.Validate(GenJnl."Document No.");
                        GenJnl."Journal Template Name" := 'SALES';
                        GenJnl."Journal Batch Name" := 'STUD PAY';
                        GenJnl."Account Type" := GenJnl."account type"::Customer;
                        //
                        if Cust.Get("Student No.") then begin
                            if Cust."Bill-to Customer No." <> '' then
                                GenJnl."Account No." := Cust."Bill-to Customer No."
                            else
                                GenJnl."Account No." := "Student No.";
                        end;

                        GenJnl.Amount := StudentCharges.Amount;
                        GenJnl.Validate(GenJnl."Account No.");
                        GenJnl.Validate(GenJnl.Amount);
                        GenJnl.Description := StudentCharges.Description;
                        GenJnl."Bal. Account Type" := GenJnl."account type"::"G/L Account";

                        if (StudentCharges."Transaction Type" = StudentCharges."transaction type"::"Stage Fees") and
                           (StudentCharges.Charge = false) then begin
                            GenJnl."Bal. Account No." := GenSetUp."Pre-Payment Account";

                            CReg.Reset;
                            CReg.SetCurrentkey(CReg."Reg. Transacton ID");
                            CReg.SetRange(CReg."Reg. Transacton ID", StudentCharges."Reg. Transacton ID");
                            if CReg.Find('-') then begin
                                if CReg."Register for" = CReg."register for"::Stage then begin
                                    Stages.Reset;
                                    Stages.SetRange(Stages."Programme Code", CReg.Programme);
                                    Stages.SetRange(Stages.Code, CReg.Stage);
                                    if Stages.Find('-') then begin
                                        if (Stages."Modules Registration" = true) and (Stages."Ignore No. Of Units" = false) then begin
                                            CReg.CalcFields(CReg."Units Taken");
                                            if CReg."Exempted Units" <> CReg."Units Taken" then
                                                Error('Units Taken must be equal to the no of modules registered for.');

                                        end;
                                    end;
                                end;

                                CReg.Posted := true;
                                CReg.Modify;
                            end;


                        end else
                            if (StudentCharges."Transaction Type" = StudentCharges."transaction type"::"Unit Fees") and
                               (StudentCharges.Charge = false) then begin
                                GenJnl."Bal. Account No." := GenSetUp."Pre-Payment Account";

                                CReg.Reset;
                                CReg.SetCurrentkey(CReg."Reg. Transacton ID");
                                CReg.SetRange(CReg."Reg. Transacton ID", StudentCharges."Reg. Transacton ID");
                                if CReg.Find('-') then begin
                                    CReg.Posted := true;
                                    CReg.Modify;
                                end;



                            end else

                                if (StudentCharges."Transaction Type" = StudentCharges."transaction type"::Charges) or
                                   (StudentCharges.Charge = true) then begin
                                    if Charges.Get(StudentCharges.Code) then
                                        GenJnl."Bal. Account No." := Charges."G/L Account";
                                end;


                        GenJnl.Validate(GenJnl."Bal. Account No.");
                        if StudentCharges."Transaction Type" = StudentCharges."transaction type"::"Stage Fees" then begin
                            if Stages.Get(StudentCharges.Programme, StudentCharges.Stage) then begin
                                Stages.TestField(Stages.Department);
                                GenJnl."Shortcut Dimension 2 Code" := Stages.Department;
                            end;

                        end else
                            if StudentCharges."Transaction Type" = StudentCharges."transaction type"::"Unit Fees" then begin
                                if Units.Get(StudentCharges.Programme, StudentCharges.Stage, StudentCharges.Unit) then begin
                                    Units.TestField(Units.Department);
                                    GenJnl."Shortcut Dimension 2 Code" := Units.Department;
                                end;
                            end;

                        GenJnl.Validate(GenJnl."Shortcut Dimension 2 Code");
                        GenJnl."Due Date" := DueDate;
                        GenJnl.Validate(GenJnl."Due Date");
                        if "Payment Mode" = "payment mode"::Mpesa then begin
                            if StudentCharges."Apply to" = true then begin
                                //GenJnl."Applies-to Doc. Type":=GenJnl."Applies-to Doc. Type"::Payment;
                                GenJnl."Applies-to Doc. No." := "Applies to Doc No";
                                GenJnl.Validate(GenJnl."Applies-to Doc. No.")
                            end;
                        end;
                        GenJnl.Insert;

                        //Distribute Money
                        if StudentCharges."Tuition Fee" = true then begin
                            if Stages.Get(StudentCharges.Programme, StudentCharges.Stage) then begin
                                if (Stages."Distribution Full Time (%)" > 0) or (Stages."Distribution Part Time (%)" > 0) then begin
                                    Stages.TestField(Stages."Distribution Account");
                                    StudentCharges.TestField(StudentCharges.Distribution);
                                    if Cust.Get("Student No.") then begin
                                        CustPostGroup.Get(Cust."Customer Posting Group");

                                        GenJnl.Init;
                                        GenJnl."Line No." := GenJnl."Line No." + 10000;
                                        GenJnl."Posting Date" := "Transaction Date";
                                        GenJnl."Document No." := StudentCharges."Transacton ID";
                                        //GenJnl."Document Type":=GenJnl."Document Type"::Payment;
                                        GenJnl.Validate(GenJnl."Document No.");
                                        GenJnl."Journal Template Name" := 'SALES';
                                        GenJnl."Journal Batch Name" := 'STUD PAY';
                                        GenJnl."Account Type" := GenJnl."account type"::"G/L Account";
                                        GenJnl."Account No." := GenSetUp."Pre-Payment Account";
                                        GenJnl.Amount := StudentCharges.Amount * (StudentCharges.Distribution / 100);
                                        GenJnl.Validate(GenJnl."Account No.");
                                        GenJnl.Validate(GenJnl.Amount);
                                        GenJnl.Description := 'Fee Distribution';
                                        GenJnl."Bal. Account Type" := GenJnl."bal. account type"::"G/L Account";
                                        GenJnl."Bal. Account No." := Stages."Distribution Account";
                                        GenJnl.Validate(GenJnl."Bal. Account No.");
                                        if StudentCharges."Transaction Type" = StudentCharges."transaction type"::"Stage Fees" then begin
                                            if Stages.Get(StudentCharges.Programme, StudentCharges.Stage) then begin
                                                Stages.TestField(Stages.Department);
                                                GenJnl."Shortcut Dimension 2 Code" := Stages.Department;
                                            end;

                                        end else
                                            if StudentCharges."Transaction Type" = StudentCharges."transaction type"::"Unit Fees" then begin
                                                if Units.Get(StudentCharges.Programme, StudentCharges.Stage, StudentCharges.Unit) then begin
                                                    Units.TestField(Units.Department);
                                                    GenJnl."Shortcut Dimension 2 Code" := Units.Department;
                                                end;
                                            end;
                                        GenJnl.Validate(GenJnl."Shortcut Dimension 2 Code");

                                        GenJnl.Insert;

                                    end;
                                end;
                            end;
                        end;
                        //End Distribution


                        StudentCharges.Recognized := true;
                        if "Payment Mode" = "payment mode"::Mpesa then begin
                            if StudentCharges."Apply to" = true then begin
                                StudentCharges."Apply to" := false;
                                StudentCharges."Amount Paid" := StudentCharges."Amount Paid" + StudentCharges."Applied Amount";
                                StudentCharges."Applied Amount" := 0;
                                if StudentCharges."Amount Paid" >= StudentCharges.Amount then
                                    StudentCharges."Fully Paid" := true;
                            end;
                        end;
                        StudentCharges.Modify;

                    until StudentCharges.Next = 0;



                    /*
                    //Post
                    GenJnl.RESET;
                    GenJnl.SETRANGE("Journal Template Name",'SALES');
                    GenJnl.SETRANGE("Journal Batch Name",'STUD PAY');
                    IF GenJnl.FIND('-') THEN BEGIN
                    CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post",GenJnl);
                    MODIFY;
                    END;
                    */


                    GenJnl.SetRange("Journal Template Name", 'SALES');
                    GenJnl.SetRange("Journal Batch Name", 'STUD PAY');
                    if GenJnl.Find('-') then begin
                        repeat
                            //window.OPEN('Posting:,#1######################');
                            //window.UPDATE(1,GenJnl."Line No.");
                            GLPosting.Run(GenJnl);
                        until GenJnl.Next = 0;
                        //window.CLOSE;
                    end;




                    GenJnl.Reset;
                    GenJnl.SetRange("Journal Template Name", 'SALES');
                    GenJnl.SetRange("Journal Batch Name", 'STUD PAY');
                    GenJnl.DeleteAll;



                    Cust.Status := Cust.Status::Current;
                    Cust.Modify;

                end else begin
                    if "Payment Mode" = "payment mode"::Mpesa then
                        Error('Overpayment must be applied manualy.');
                end;

                /////////////////////////////////////////////////////////////////////////////////
                //Receive payments
                if "Payment Mode" <> "payment mode"::Mpesa then begin

                    //Over Payment
                    TotalApplied := 0;



                    Receipt.Init;
                    Receipt."Receipt No." := '';
                    Receipt.Validate(Receipt."Receipt No.");
                    Receipt."Student No." := "Student No.";
                    Receipt.Date := "Transaction Date";
                    Receipt."Bank Slip/Cheque No" := "Cheque No";
                    Receipt."Source Rcpt No" := "Receipt No";
                    Receipt."Payment Mode" := "Payment Mode";
                    Receipt.Amount := "Amount to pay";
                    Receipt."Payment By" := "Payment By";
                    Receipt."Transaction Date" := Today;
                    Receipt."Transaction Time" := Time;
                    Receipt."User ID" := UserId;
                    Receipt."Auto  Receipt Date" := Today;
                    Receipt."Auto  Receipted" := true;
                    Receipt.Insert;

                    Receipt.Reset;
                    if Receipt.Find('+') then begin


                        CustLedg.Reset;
                        CustLedg.SetRange(CustLedg."Customer No.", "Student No.");
                        // CustLedg.SetRange(CustLedg."Apply to",true);
                        CustLedg.SetRange(CustLedg.Open, true);
                        CustLedg.SetRange(CustLedg.Reversed, false);
                        if CustLedg.Find('-') then begin

                            GenSetUp.Get();

                            repeat
                                CustLedg.CalcFields(CustLedg."Remaining Amount");

                                GenJnl.Init;
                                GenJnl."Line No." := GenJnl."Line No." + 10000;
                                GenJnl."Posting Date" := "Transaction Date";
                                GenJnl."Document No." := Receipt."Receipt No.";
                                GenJnl.Validate(GenJnl."Document No.");
                                GenJnl."Journal Template Name" := 'SALES';
                                GenJnl."Journal Batch Name" := 'STUD PAY';
                                GenJnl."Account Type" := GenJnl."account type"::Customer;
                                if Cust.Get("Student No.") then begin
                                    if Cust."Bill-to Customer No." <> '' then
                                        GenJnl."Account No." := Cust."Bill-to Customer No."
                                    else
                                        GenJnl."Account No." := "Student No.";
                                end;
                                // GenJnl.Amount:=CustLedg."Amount Applied" * -1;
                                GenJnl.Validate(GenJnl."Account No.");
                                GenJnl.Validate(GenJnl.Amount);
                                GenJnl.Description := CustLedg.Description;
                                GenJnl."Shortcut Dimension 2 Code" := CustLedg."Global Dimension 2 Code";
                                GenJnl.Validate(GenJnl."Shortcut Dimension 2 Code");
                                //PKK
                                GenJnl."Applies-to Doc. Type" := CustLedg."Document Type";
                                GenJnl."Applies-to Doc. No." := CustLedg."Document No.";
                                GenJnl.Validate(GenJnl."Applies-to Doc. No.");
                                GenJnl.Insert;


                                ReceiptItems.Init;
                                ReceiptItems."Receipt No" := Receipt."Receipt No.";
                                ReceiptItems."Transaction ID" := CustLedg."Document No.";
                                //ERROR('Test Test');

                                StudentCharges.Reset;
                                StudentCharges.SetRange(StudentCharges.Recognized, false);
                                if StudentCharges.Get(CustLedg."Document No.", "Student No.") then begin
                                    ReceiptItems.Code := StudentCharges.Code;
                                    ReceiptItems."Reg. No" := StudentCharges."Reg. Transacton ID";
                                end;
                                ReceiptItems."Student No." := "Student No.";
                                ReceiptItems.Description := CustLedg.Description;
                                // ReceiptItems.Amount:=CustLedg."Amount Applied";
                                //ReceiptItems.Balance:=CustLedg."Remaining Amount" - CustLedg."Amount Applied";
                                ReceiptItems.Insert;

                            // CustLedg."Apply to":=false;
                            //CustLedg."Amount Applied":=0;
                            // CustLedg.Modify;


                            until CustLedg.Next = 0;


                        end;

                        //Over Payment
                        if "Amount to pay" <> TotalApplied then begin
                            GenJnl.Init;
                            GenJnl."Line No." := GenJnl."Line No." + 10000;
                            GenJnl."Posting Date" := "Transaction Date";
                            GenJnl."Document No." := Receipt."Receipt No.";
                            //GenJnl."Document Type":=GenJnl."Document Type"::Payment;
                            GenJnl.Validate(GenJnl."Document No.");
                            GenJnl."Journal Template Name" := 'SALES';
                            GenJnl."Journal Batch Name" := 'STUD PAY';
                            GenJnl."Account Type" := GenJnl."account type"::Customer;
                            GenJnl."Account No." := "Student No.";
                            GenJnl.Amount := ("Amount to pay" - TotalApplied) * -1;
                            GenJnl.Validate(GenJnl."Account No.");
                            GenJnl.Validate(GenJnl.Amount);
                            GenJnl.Description := 'Pre Payment';
                            GenJnl.Insert;




                            ReceiptItems.Init;
                            ReceiptItems."Receipt No" := Receipt."Receipt No.";
                            ReceiptItems.Code := 'OP';
                            ReceiptItems.Description := 'Pre Payment';
                            ReceiptItems.Amount := "Amount to pay" - TotalApplied;
                            ReceiptItems.Insert;


                        end;
                    end;

                    //Bank Entry

                    GenJnl.Init;
                    GenJnl."Line No." := GenJnl."Line No." + 10000;
                    GenJnl."Posting Date" := "Transaction Date";
                    GenJnl."Document No." := Receipt."Receipt No.";
                    GenJnl."External Document No." := "Cheque No";
                    //GenJnl."Document Type":=GenJnl."Document Type"::Payment;
                    GenJnl.Validate(GenJnl."Document No.");
                    GenJnl."Journal Template Name" := 'SALES';
                    GenJnl."Journal Batch Name" := 'STUD PAY';
                    //GenJnl."Account Type":=GenJnl."Account Type"::"Bank Account";
                    //GenJnl."Account No.":="Bank No.";
                    if "Payment Mode" = "payment mode"::"Direct Bank Deposit" then begin
                        GenJnl."Account Type" := GenJnl."bal. account type"::"Bank Account";
                        GenJnl."Account No." := 'BFS';
                    end else
                        if "Payment Mode" = "payment mode"::HELB then begin
                            GenJnl."Account Type" := GenJnl."bal. account type"::"G/L Account";
                            GenJnl."Account No." := '300020';
                        end else
                            if "Payment Mode" = "payment mode"::CDF then begin
                                GenJnl."Account Type" := GenJnl."bal. account type"::"G/L Account";
                                GenJnl."Account No." := '300021';
                            end else
                                if "Payment Mode" = "payment mode"::Sponsor then begin
                                    GenJnl."Account Type" := GenJnl."bal. account type"::"G/L Account";
                                    GenJnl."Account No." := '300022';
                                end;

                    GenJnl.Amount := "Amount to pay";
                    GenJnl.Validate(GenJnl."Account No.");
                    GenJnl.Validate(GenJnl.Amount);
                    GenJnl.Description := Cust.Name;
                    GenJnl.Insert;



                    //Post
                    /*
                    GenJnl.RESET;
                    GenJnl.SETRANGE("Journal Template Name",'SALES');
                    GenJnl.SETRANGE("Journal Batch Name",'STUD PAY');
                    IF GenJnl.FIND('-') THEN BEGIN
                    CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post",GenJnl);
                    MODIFY;
                    END;
                    */


                    GenJnl.SetRange("Journal Template Name", 'SALES');
                    GenJnl.SetRange("Journal Batch Name", 'STUD PAY');
                    if GenJnl.Find('-') then begin
                        repeat
                            //window.OPEN('Posting:,#1######################');
                            //window.UPDATE(1,GenJnl."Line No.");
                            GLPosting.Run(GenJnl);
                        until GenJnl.Next = 0;
                        //window.CLOSE;
                    end;




                    //MESSAGE('Transaction posted successfully.');
                    /*
                    //IF COMPANYNAME <> 'Kenya College of Accountancy 2' THEN BEGIN
                    Receipts.RESET;
                    Receipts.SETCURRENTKEY(Receipts."Receipt No.");
                    Receipts.SETRANGE(Receipts."Receipt No.",Receipt."Receipt No.");
                    IF Receipts.FIND('-') THEN
                    REPORT.RUN(67079,TRUE,FALSE,Receipts);
                    */

                end;


                //END;

            end;
        }
        field(22; "Auto Receipt Entry"; Boolean) { }
        field(23; "Auto Bill"; Boolean)
        {

            trigger OnValidate()
            begin



                GenJnl.Reset;
                GenJnl.SetRange("Journal Template Name", 'SALES');
                GenJnl.SetRange("Journal Batch Name", 'STUD PAY');
                GenJnl.DeleteAll;

                GenSetUp.Get();
                GenSetUp.TestField(GenSetUp."Pre-Payment Account");

                //Charge Student if not charged
                StudentCharges.Reset;
                StudentCharges.SetRange(StudentCharges."Student No.", "Student No.");
                StudentCharges.SetRange(StudentCharges.Recognized, false);
                if StudentCharges.Find('-') then begin

                    repeat

                        DueDate := StudentCharges.Date;
                        if Sems.Get(StudentCharges.Semester) then begin
                            if Sems.From <> 0D then begin
                                if Sems.From > DueDate then
                                    DueDate := Sems.From;
                            end;
                        end;


                        GenJnl.Init;
                        GenJnl."Line No." := GenJnl."Line No." + 10000;
                        GenJnl."Posting Date" := Today;
                        GenJnl."Document No." := StudentCharges."Transacton ID";
                        GenJnl.Validate(GenJnl."Document No.");
                        GenJnl."Journal Template Name" := 'SALES';
                        GenJnl."Journal Batch Name" := 'STUD PAY';
                        GenJnl."Account Type" := GenJnl."account type"::Customer;
                        if Cust.Get("Student No.") then begin
                            if Cust."Bill-to Customer No." <> '' then
                                GenJnl."Account No." := Cust."Bill-to Customer No."
                            else
                                GenJnl."Account No." := "Student No.";
                        end;

                        GenJnl.Amount := StudentCharges.Amount;
                        GenJnl.Validate(GenJnl."Account No.");
                        GenJnl.Validate(GenJnl.Amount);
                        GenJnl.Description := StudentCharges.Description;
                        GenJnl."Bal. Account Type" := GenJnl."account type"::"G/L Account";

                        if (StudentCharges."Transaction Type" = StudentCharges."transaction type"::"Stage Fees") and
                           (StudentCharges.Charge = false) then begin
                            GenJnl."Bal. Account No." := GenSetUp."Pre-Payment Account";

                            CReg.Reset;
                            CReg.SetCurrentkey(CReg."Reg. Transacton ID");
                            CReg.SetRange(CReg."Reg. Transacton ID", StudentCharges."Reg. Transacton ID");
                            CReg.SetRange(CReg."Student No.", StudentCharges."Student No.");
                            if CReg.Find('-') then begin
                                if CReg."Register for" = CReg."register for"::Stage then begin
                                    Stages.Reset;
                                    Stages.SetRange(Stages."Programme Code", CReg.Programme);
                                    Stages.SetRange(Stages.Code, CReg.Stage);
                                    if Stages.Find('-') then begin
                                        if (Stages."Modules Registration" = true) and (Stages."Ignore No. Of Units" = false) then begin
                                            CReg.CalcFields(CReg."Units Taken");
                                            if CReg."Exempted Units" <> CReg."Units Taken" then
                                                Error('Units Taken must be equal to the no of modules registered for.');

                                        end;
                                    end;
                                end;

                                CReg.Posted := true;
                                CReg.Modify;
                            end;


                        end else
                            if (StudentCharges."Transaction Type" = StudentCharges."transaction type"::"Unit Fees") and
                               (StudentCharges.Charge = false) then begin
                                GenJnl."Bal. Account No." := GenSetUp."Pre-Payment Account";

                                CReg.Reset;
                                CReg.SetCurrentkey(CReg."Reg. Transacton ID");
                                CReg.SetRange(CReg."Reg. Transacton ID", StudentCharges."Reg. Transacton ID");
                                if CReg.Find('-') then begin
                                    CReg.Posted := true;
                                    CReg.Modify;
                                end;



                            end else
                                if (StudentCharges."Transaction Type" = StudentCharges."transaction type"::Charges) or
                                   (StudentCharges.Charge = true) then begin
                                    if Charges.Get(StudentCharges.Code) then
                                        GenJnl."Bal. Account No." := Charges."G/L Account";
                                end;


                        GenJnl.Validate(GenJnl."Bal. Account No.");
                        if StudentCharges."Transaction Type" = StudentCharges."transaction type"::"Stage Fees" then begin
                            if Stages.Get(StudentCharges.Programme, StudentCharges.Stage) then begin
                                //Stages.TESTFIELD(Stages.Department);
                                //GenJnl."Shortcut Dimension 2 Code":=Stages.Department;
                            end;

                        end else
                            if StudentCharges."Transaction Type" = StudentCharges."transaction type"::"Unit Fees" then begin
                                if Units.Get(StudentCharges.Programme, StudentCharges.Stage, StudentCharges.Unit) then begin
                                    //Units.TESTFIELD(Units.Department);
                                    //GenJnl."Shortcut Dimension 2 Code":=Units.Department;
                                end;
                            end;

                        //GenJnl.VALIDATE(GenJnl."Shortcut Dimension 2 Code");
                        GenJnl."Due Date" := DueDate;
                        GenJnl.Validate(GenJnl."Due Date");
                        GenJnl.Insert;

                        //Distribute Money
                        if StudentCharges."Tuition Fee" = true then begin
                            if Stages.Get(StudentCharges.Programme, StudentCharges.Stage) then begin
                                if (Stages."Distribution Full Time (%)" > 0) or (Stages."Distribution Part Time (%)" > 0) then begin
                                    Stages.TestField(Stages."Distribution Account");
                                    StudentCharges.TestField(StudentCharges.Distribution);
                                    if Cust.Get("Student No.") then begin
                                        CustPostGroup.Get(Cust."Customer Posting Group");

                                        GenJnl.Init;
                                        GenJnl."Line No." := GenJnl."Line No." + 10000;
                                        GenJnl."Posting Date" := Today;
                                        GenJnl."Document No." := StudentCharges."Transacton ID";
                                        //GenJnl."Document Type":=GenJnl."Document Type"::Payment;
                                        GenJnl.Validate(GenJnl."Document No.");
                                        GenJnl."Journal Template Name" := 'SALES';
                                        GenJnl."Journal Batch Name" := 'STUD PAY';
                                        GenJnl."Account Type" := GenJnl."account type"::"G/L Account";
                                        GenSetUp.TestField(GenSetUp."Pre-Payment Account");
                                        GenJnl."Account No." := GenSetUp."Pre-Payment Account";
                                        GenJnl.Amount := StudentCharges.Amount * (StudentCharges.Distribution / 100);
                                        GenJnl.Validate(GenJnl."Account No.");
                                        GenJnl.Validate(GenJnl.Amount);
                                        GenJnl.Description := 'Fee Distribution';
                                        GenJnl."Bal. Account Type" := GenJnl."bal. account type"::"G/L Account";
                                        GenJnl."Bal. Account No." := Stages."Distribution Account";
                                        GenJnl.Validate(GenJnl."Bal. Account No.");
                                        if StudentCharges."Transaction Type" = StudentCharges."transaction type"::"Stage Fees" then begin
                                            if Stages.Get(StudentCharges.Programme, StudentCharges.Stage) then begin
                                                //GenJnl."Shortcut Dimension 2 Code":=Stages.Department;
                                            end;

                                        end else
                                            if StudentCharges."Transaction Type" = StudentCharges."transaction type"::"Unit Fees" then begin
                                                if Units.Get(StudentCharges.Programme, StudentCharges.Stage, StudentCharges.Unit) then begin
                                                    //Units.TESTFIELD(Units.Department);
                                                    //GenJnl."Shortcut Dimension 2 Code":=Units.Department;
                                                end;
                                            end;
                                        //GenJnl.VALIDATE(GenJnl."Shortcut Dimension 2 Code");

                                        GenJnl.Insert;

                                    end;
                                end;
                            end;
                        end else begin
                            //Distribute Charges
                            if StudentCharges.Distribution > 0 then begin
                                StudentCharges.TestField(StudentCharges."Distribution Account");
                                if Charges.Get(StudentCharges.Code) then begin
                                    Charges.TestField(Charges."G/L Account");
                                    GenJnl.Init;
                                    GenJnl."Line No." := GenJnl."Line No." + 10000;
                                    GenJnl."Posting Date" := Today;
                                    GenJnl."Document No." := StudentCharges."Transacton ID";
                                    GenJnl.Validate(GenJnl."Document No.");
                                    GenJnl."Journal Template Name" := 'SALES';
                                    GenJnl."Journal Batch Name" := 'STUD PAY';
                                    GenJnl."Account Type" := GenJnl."account type"::"G/L Account";
                                    GenJnl."Account No." := StudentCharges."Distribution Account";
                                    GenJnl.Amount := StudentCharges.Amount * (StudentCharges.Distribution / 100);
                                    GenJnl.Validate(GenJnl."Account No.");
                                    GenJnl.Validate(GenJnl.Amount);
                                    GenJnl.Description := 'Fee Distribution';
                                    GenJnl."Bal. Account Type" := GenJnl."bal. account type"::"G/L Account";
                                    GenJnl."Bal. Account No." := Charges."G/L Account";
                                    GenJnl.Validate(GenJnl."Bal. Account No.");
                                    if Stages.Get(StudentCharges.Programme, StudentCharges.Stage) then begin
                                        //Stages.TESTFIELD(Stages.Department);
                                        //GenJnl."Shortcut Dimension 2 Code":=Stages.Department;
                                    end;
                                    //GenJnl.VALIDATE(GenJnl."Shortcut Dimension 2 Code");
                                    GenJnl.Insert;

                                end;
                            end;
                        end;
                        //End Distribution


                        StudentCharges.Recognized := true;
                        StudentCharges.Modify;

                    until StudentCharges.Next = 0;



                    GenJnl.SetRange("Journal Template Name", 'SALES');
                    GenJnl.SetRange("Journal Batch Name", 'STUD PAY');
                    if GenJnl.Find('-') then begin
                        repeat
                            GLPosting.Run(GenJnl);
                        until GenJnl.Next = 0;
                    end;

                    //Billing


                    GenJnl.Reset;
                    GenJnl.SetRange("Journal Template Name", 'SALES');
                    GenJnl.SetRange("Journal Batch Name", 'STUD PAY');
                    GenJnl.DeleteAll;

                    Cust.Status := Cust.Status::Current;
                    Cust.Modify;

                end;


                //BILLING
            end;
        }
        field(24; "Unref. Entry No."; Integer)
        {
            TableRelation = "G/L Entry"."Entry No." where("G/L Account No." = field("UnIndentified G/L Account"));

            trigger OnValidate()
            begin
                "Unref Document No." := '';
                "Amount to pay" := 0;
                if "G/LEntry".Get("Unref. Entry No.") then begin
                    "Unref Document No." := "G/LEntry"."Document No.";
                    "Amount to pay" := "G/LEntry".Amount * -1;
                    "Bank Slip Date" := "G/LEntry"."Posting Date";
                    Validate("Amount to pay");
                end;
                CalcFields("Unref. Entry No. Used Count");
                if "Unref. Entry No. Used Count" > 1 then Error('Please note that the selected entry has already been used');
            end;
        }
        field(25; "Unref Document No."; Code[20])
        {
            TableRelation = "G/L Entry"."Document No." where("G/L Account No." = field("UnIndentified G/L Account"));
        }
        field(26; "Auto Post 2"; Boolean)
        {

            trigger OnValidate()
            begin

                TestField("Transaction Date");

                if "Payment Mode" = "payment mode"::"Bank Slip" then
                    TestField("Bank Slip Date");

                //("Amount to pay" - TotalApplied)
                //ERROR('%1',TotalApplied);
                if "Amount to pay" <> TotalApplied then begin

                end;


                if Cust.Get("Student No.") then begin
                    //Cust.Status:=Cust.Status::Current;
                    //Cust.MODIFY;
                end;


                GenJnl.Reset;
                GenJnl.SetRange("Journal Template Name", 'SALES');
                GenJnl.SetRange("Journal Batch Name", 'STUD PAY');
                GenJnl.DeleteAll;

                GenSetUp.Get();




                /////////////////////////////////////////////////////////////////////////////////
                //Receive payments
                if "Payment Mode" <> "payment mode"::Mpesa then begin

                    //Over Payment
                    TotalApplied := 0;


                    /*
                    Receipt.INIT;
                    Receipt."Receipt No.":='';
                    Receipt.VALIDATE(Receipt."Receipt No.");
                    Receipt."Student No.":="Student No.";
                    Receipt.Date:="Transaction Date";
                    Receipt."KCA Rcpt No":="KCA Receipt No";
                    Receipt."Payment Mode":="Payment Mode";
                    Receipt.Amount:="Amount to pay";
                    Receipt."Payment By":="Payment By";
                    Receipt."Transaction Date":=TODAY;
                    Receipt."Transaction Time":=TIME;
                    Receipt."User ID":=USERID;
                    Receipt."Auto  Receipt Date":=TODAY;
                    Receipt."Auto  Receipted":=TRUE;
                    Receipt.INSERT;
                    */


                    Receipt.Reset;
                    Receipt.SetRange(Receipt."Receipt No.", "Rcpt No.");
                    if Receipt.Find('-') then begin


                        CustLedg.Reset;
                        CustLedg.SetRange(CustLedg."Customer No.", "Student No.");
                        // CustLedg.SetRange(CustLedg."Apply to", true);
                        CustLedg.SetRange(CustLedg.Open, true);
                        CustLedg.SetRange(CustLedg.Reversed, false);
                        if CustLedg.Find('-') then begin

                            GenSetUp.Get();


                            repeat
                                CustLedg.CalcFields(CustLedg."Remaining Amount");

                                GenJnl.Init;
                                GenJnl."Line No." := GenJnl."Line No." + 10000;
                                GenJnl."Posting Date" := "Transaction Date";
                                GenJnl."Document No." := "Rcpt No.";
                                GenJnl.Validate(GenJnl."Document No.");
                                GenJnl."Journal Template Name" := 'SALES';
                                GenJnl."Journal Batch Name" := 'STUD PAY';
                                GenJnl."Account Type" := GenJnl."account type"::Customer;
                                if Cust.Get("Student No.") then begin
                                    if Cust."Bill-to Customer No." <> '' then
                                        GenJnl."Account No." := Cust."Bill-to Customer No."
                                    else
                                        GenJnl."Account No." := "Student No.";
                                end;
                                //  GenJnl.Amount := CustLedg."Amount Applied" * -1;
                                GenJnl.Validate(GenJnl."Account No.");
                                GenJnl.Validate(GenJnl.Amount);
                                GenJnl.Description := CustLedg.Description;
                                GenJnl."Shortcut Dimension 2 Code" := CustLedg."Global Dimension 2 Code";
                                GenJnl.Validate(GenJnl."Shortcut Dimension 2 Code");
                                //PKK
                                GenJnl."Applies-to Doc. Type" := CustLedg."Document Type";
                                GenJnl."Applies-to Doc. No." := CustLedg."Document No.";
                                GenJnl.Validate(GenJnl."Applies-to Doc. No.");
                                GenJnl.Insert;


                                ReceiptItems.Init;
                                ReceiptItems."Receipt No" := Receipt."Receipt No.";
                                ReceiptItems."Transaction ID" := CustLedg."Document No.";
                                //ERROR('Test Test');

                                StudentCharges.Reset;
                                StudentCharges.SetRange(StudentCharges.Recognized, false);
                                if StudentCharges.Get(CustLedg."Document No.", "Student No.") then begin
                                    ReceiptItems.Code := StudentCharges.Code;
                                    ReceiptItems."Reg. No" := StudentCharges."Reg. Transacton ID";
                                end;
                                ReceiptItems."Student No." := "Student No.";
                                ReceiptItems.Description := CustLedg.Description;
                                //  ReceiptItems.Amount := CustLedg."Amount Applied";
                                //  ReceiptItems.Balance := CustLedg."Remaining Amount" - CustLedg."Amount Applied";
                                ReceiptItems.Insert;




                            until CustLedg.Next = 0;


                        end;

                        //Over Payment
                        if "Amount to pay" <> TotalApplied then begin
                            GenJnl.Init;
                            GenJnl."Line No." := GenJnl."Line No." + 10000;
                            GenJnl."Posting Date" := "Transaction Date";
                            GenJnl."Document No." := "Rcpt No.";
                            //GenJnl."Document Type":=GenJnl."Document Type"::Payment;
                            GenJnl.Validate(GenJnl."Document No.");
                            GenJnl."Journal Template Name" := 'SALES';
                            GenJnl."Journal Batch Name" := 'STUD PAY';
                            GenJnl."Account Type" := GenJnl."account type"::Customer;
                            GenJnl."Account No." := "Student No.";
                            GenJnl.Amount := ("Amount to pay" - TotalApplied) * -1;
                            GenJnl.Validate(GenJnl."Account No.");
                            GenJnl.Validate(GenJnl.Amount);
                            GenJnl.Description := 'Pre Payment';
                            GenJnl.Insert;




                            ReceiptItems.Init;
                            ReceiptItems."Receipt No" := Receipt."Receipt No.";
                            ReceiptItems.Code := 'OP';
                            ReceiptItems.Description := 'Pre Payment';
                            ReceiptItems.Amount := "Amount to pay" - TotalApplied;
                            ReceiptItems.Insert;


                        end;
                    end;

                    //Bank Entry
                    /*
                    GenJnl.INIT;
                    GenJnl."Line No." := GenJnl."Line No." + 10000;
                    GenJnl."Posting Date":="Transaction Date";
                    GenJnl."Document No.":=Receipt."Receipt No.";
                    GenJnl."External Document No.":="Cheque No";
                    //GenJnl."Document Type":=GenJnl."Document Type"::Payment;
                    GenJnl.VALIDATE(GenJnl."Document No.");
                    GenJnl."Journal Template Name":='SALES';
                    GenJnl."Journal Batch Name":='STUD PAY';
                    GenJnl."Account Type":=GenJnl."Account Type"::"Bank Account";
                    GenJnl."Account No.":="Bank No.";
                    GenJnl.Amount:="Amount to pay";
                    GenJnl.VALIDATE(GenJnl."Account No.");
                    GenJnl.VALIDATE(GenJnl.Amount);
                    GenJnl.Description:=Cust.Name;
                    GenJnl.INSERT;
                    */

                    if "Payment Mode" <> "payment mode"::Unreferenced then begin

                        GenJnl.Init;
                        GenJnl."Line No." := GenJnl."Line No." + 10000;
                        GenJnl."Posting Date" := "Transaction Date";
                        GenJnl."Document No." := Receipt."Receipt No.";
                        GenJnl."External Document No." := "Cheque No";
                        GenJnl.Validate(GenJnl."Document No.");
                        GenJnl."Journal Template Name" := 'SALES';
                        GenJnl."Journal Batch Name" := 'STUD PAY';
                        GenJnl."Account Type" := GenJnl."account type"::"Bank Account";
                        GenJnl."Account No." := "Bank No.";
                        GenJnl.Amount := "Amount to pay";
                        GenJnl.Validate(GenJnl."Account No.");
                        GenJnl.Validate(GenJnl.Amount);
                        GenJnl.Description := Cust.Name;
                        GenJnl.Insert;

                    end else begin


                        GenJnl.Init;
                        GenJnl."Line No." := GenJnl."Line No." + 10000;
                        GenJnl."Posting Date" := "Transaction Date";
                        GenJnl."Document No." := Receipt."Receipt No.";
                        GenJnl."External Document No." := "Cheque No";
                        GenJnl.Validate(GenJnl."Document No.");
                        GenJnl."Journal Template Name" := 'SALES';
                        GenJnl."Journal Batch Name" := 'STUD PAY';
                        GenJnl."Account Type" := GenJnl."account type"::Customer;
                        GenJnl."Account No." := 'UNREF';
                        GenJnl.Amount := "Amount to pay";
                        GenJnl.Validate(GenJnl."Account No.");
                        GenJnl.Validate(GenJnl.Amount);
                        GenJnl.Description := Cust.Name;
                        GenJnl."Applies-to Doc. No." := "Unref Document No.";
                        GenJnl.Validate(GenJnl."Applies-to Doc. No.");
                        GenJnl.Insert;


                    end;



                    //Post

                    GenJnl.SetRange("Journal Template Name", 'SALES');
                    GenJnl.SetRange("Journal Batch Name", 'STUD PAY');
                    if GenJnl.Find('-') then begin
                        repeat
                            //window.OPEN('Posting:,#1######################');
                            //window.UPDATE(1,GenJnl."Line No.");
                            GLPosting.Run(GenJnl);
                        until GenJnl.Next = 0;
                        //window.CLOSE;
                    end;


                end;

            end;
        }
        field(27; "Rcpt No."; Code[20]) { }
        field(127; "Module Code"; Code[20]) { }
        field(28; Currency; Code[20])
        {
            TableRelation = Currency.Code;

            trigger OnValidate()
            begin
                Validate("Amount to pay");
            end;
        }
        field(29; "Auto Post Final"; Boolean)
        {

            trigger OnValidate()
            var
                Prog: record programme;
            begin
                if Cust.Get("Student No.") then begin
                    if Cust."Bill-to Customer No." <> '' then begin
                        Cust."Bill-to Customer No." := '';
                    end;
                end;

                TestField("Transaction Date");
                GenSetUp.Get();
                if "Payment Mode" = "payment mode"::"Bank Slip" then
                    TestField("Bank Slip Date");
                LastReceipt := '';
                LastReceipt := "Posting Receipt No";
                if "Posting Receipt No" = '' then begin
                    BankRec.Reset;
                    if BankRec.Get("Bank No.") then
                        BankRec.TestField(BankRec."Receipt No. Series")
                    else
                        GenSetUp.TestField("Receipt Nos.");

                    NoSeries.Reset;
                    if "Bank No." = '' then
                        LastReceipt := NoSeriesMgt.GetNextNo(GenSetUp."Receipt Nos.", 0D, true)
                    else
                        LastReceipt := NoSeriesMgt.GetNextNo(BankRec."Receipt No. Series", 0D, true);
                end;

                if Receipt.Get(LastReceipt) then LastReceipt := LastReceipt + '/' + CopyStr(NoSeriesMgt.GetNextNo(GenSetUp."Receipt Nos.", 0D, true), 4, 20);
                if LastReceipt <> '' then begin
                    //IF "Receipt No"<>'' THEN LastReceipt:="Receipt No";
                    ///////////////////////////////////////////
                    //Receive payments
                    if "Payment Mode" <> "payment mode"::Mpesa then begin
                        //ERROR('Test'+LastReceipt);
                        Receipt.Init;
                        Receipt."Receipt No." := LastReceipt;
                        //Receipt.VALIDATE(Receipt."Receipt No.");
                        Receipt."Student No." := "Student No.";
                        Receipt.Date := "Transaction Date";
                        Receipt."Bank Slip/Cheque No" := "Cheque No";
                        Receipt."Source Rcpt No" := "Receipt No";
                        Receipt."Payment Mode" := "Payment Mode";
                        Receipt.Amount := "Amount to pay";
                        Receipt."Payment By" := "Payment By";
                        Receipt."Transaction Date" := Today;
                        Receipt."Transaction Time" := Time;
                        Receipt."User ID" := UserId;
                        Receipt."Auto  Receipt Date" := Today;
                        Receipt."Auto  Receipted" := true;
                        Receipt."Source Rcpt No" := "Receipt No";
                        Receipt."Room No" := "Receipt No";
                        Receipt.Insert;

                        Receipt.Reset;
                        if Receipt.Find('+') then begin

                            if "Receipt No" <> '' then LastReceipt := "Receipt No";
                            GenJnl.Reset;
                            GenJnl.SetRange("Journal Template Name", 'SALES');
                            GenJnl.SetRange("Journal Batch Name", 'STUD PAY');
                            if GenJnl.Find('-') then GenJnl.DeleteAll;

                            GenJnl.Init;
                            GenJnl."Line No." := GenJnl."Line No." + 110000;
                            GenJnl."Posting Date" := "Transaction Date";
                            GenJnl."Document No." := LastReceipt;
                            GenJnl.Validate(GenJnl."Document No.");
                            GenJnl."Journal Template Name" := 'SALES';
                            GenJnl."Journal Batch Name" := 'STUD PAY';
                            GenJnl."Account Type" := GenJnl."account type"::Customer;
                            //IF Cust.GET("Student No.") THEN BEGIN
                            //IF Cust."Bill-to Customer No." <> '' THEN
                            //GenJnl."Account No.":=Cust."Bill-to Customer No."
                            //ELSE
                            GenJnl."Account No." := "Student No.";
                            //END;
                            GenJnl.Amount := "Amount to pay" * -1;
                            GenJnl.Validate(GenJnl."Account No.");
                            GenJnl.Validate(GenJnl.Amount);

                            if "Payment Mode" = "payment mode"::"Direct Bank Deposit" then begin
                                GenJnl."Bal. Account Type" := GenJnl."bal. account type"::"Bank Account";
                                GenJnl."Bal. Account No." := "Bank No.";
                                GenJnl.Description := "Payment By" + '-' + 'Bank Deposit';
                            end else
                                if "Payment Mode" = "payment mode"::HELB then begin
                                    // GenJnl."Document No.":="Receipt No";
                                    GenJnl."Bal. Account Type" := GenJnl."bal. account type"::"G/L Account";
                                    GenSetUp.TestField(GenSetUp."Helb Account");
                                    GenJnl.Description := Semester + '-' + "Cheque No" + '-Helb';
                                    GenJnl."Bal. Account No." := GenSetUp."Helb Account";

                                end else
                                    if "Payment Mode" = "payment mode"::CDF then begin
                                        GenJnl."Bal. Account Type" := GenJnl."bal. account type"::"G/L Account";
                                        GenSetUp.TestField(GenSetUp."CDF Account");
                                        GenJnl."Bal. Account No." := GenSetUp."CDF Account";
                                        GenJnl.Description := "Payment By";

                                    end else
                                        if "Payment Mode" = "payment mode"::Unreferenced then begin
                                            GenSetUp.TestField("Unallocated Rcpts Account");
                                            GenJnl."Account Type" := GenJnl."account type"::"G/L Account";
                                            GenJnl."Account No." := "Bank No.";
                                            GenJnl."Bal. Account Type" := GenJnl."bal. account type"::Customer;
                                            GenJnl."Bal. Account No." := GenSetUp."Unallocated Rcpts Account";
                                            GenJnl.Description := "Payment By";
                                            GenJnl.Amount := "Amount to pay";
                                        end;

                            GenJnl."External Document No." := "Cheque No";
                            GenJnl.Validate(GenJnl."Bal. Account No.");
                            GenJnl."Shortcut Dimension 1 Code" := Cust."Global Dimension 1 Code";
                            GenJnl.Validate("Shortcut Dimension 1 Code");
                            if prog.get(cust."Current Programme") then begin
                                GenJnl."Shortcut Dimension 2 Code" := Prog."Department Code";
                                // GenJnl."Shortcut Dimension 3 Code" := Prog."School Code";
                                GenJnl.Validate("Shortcut Dimension 2 Code");
                                // GenJnl.Validate("Shortcut Dimension 3 Code", Prog."School Code");
                            end;
                            // if "Module Code" <> '' then
                            //     GenJnl.Validate("Shortcut Dimension 3 Code", "Module Code");

                            GenJnl.Insert;


                            GenJnl.SetRange("Journal Template Name", 'SALES');
                            GenJnl.SetRange("Journal Batch Name", 'STUD PAY');
                            if GenJnl.Find('-') then begin
                                repeat
                                    GLPosting.Run(GenJnl);
                                until GenJnl.Next = 0;
                            end;

                            GenSetUp.get;
                            if GenSetUp."Notify Student on Receipt" = true then
                                Billing.EmailStudentReceipt("Student No.", LastReceipt);


                        end;

                    end;
                end;
            end;
        }
        field(30; "Staff Invoice No."; Code[20])
        {
            TableRelation = "Sales Invoice Header"."No." where("Customer Posting Group" = const('SUNDRY'));

            trigger OnValidate()
            begin
                InvoiceHeader.SetRange(InvoiceHeader."No.", "Staff Invoice No.");
                if InvoiceHeader.Find('-') then begin
                    "Staff Description" := InvoiceHeader."Bill-to Customer No." + ' ' + InvoiceHeader."Bill-to Name";
                end;
                "Transaction Date" := InvoiceHeader."Posting Date";
                // Get The Invoice Amount
                InvoiceLine.SetRange(InvoiceLine."Document No.", "Staff Invoice No.");
                if InvoiceLine.Find('-') then begin
                    repeat
                        InvAmount := InvAmount + InvoiceLine.Amount
                    until InvoiceLine.Next = 0;
                end;
                "Amount to pay" := InvAmount;
            end;
        }
        field(31; "Staff Description"; Text[50]) { }
        field(32; "Sponsor Account"; Code[20])
        {
            TableRelation = "G/L Account"."No." where("Direct Posting" = filter(true));

            trigger OnValidate()
            var
                GL: record "G/L Account";
            begin
                if GL.Get("Sponsor Account") then
                    "Sponsor Description" := GL.Name;
            end;
        }
        field(33; "Sponsor Description"; Text[100]) { }
        field(34; Semester; Code[20]) { }
        field(35; "Bank Name"; Text[150]) { }
        field(36; "Staff Number"; Code[20])
        {
            TableRelation = Customer."No.";
        }
        field(37; "UnIndentified G/L Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(38; "Unref. Entry No. Used Count"; Integer)
        {
            CalcFormula = count("Student Payments" where("Unref. Entry No." = field("Unref. Entry No.")));
            FieldClass = FlowField;
        }
        field(39; "Unref. Entry No. Doc No"; Code[20])
        {
            CalcFormula = lookup("G/L Entry"."Document No." where("G/L Account No." = field("UnIndentified G/L Account"),
                                                                   "Entry No." = field("Unref. Entry No.")));
            FieldClass = FlowField;
        }
        field(40; "Line No"; Integer)
        {
            AutoIncrement = true;
        }
        field(42; "Allocated Amount"; Decimal)
        {
            CalcFormula = sum("Student Payments"."Amount to pay" where("Applies to Doc No" = field("Applies to Doc No")));
            FieldClass = FlowField;
        }
        field(43; "Posting Receipt No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(44; "Unreff. Type"; Option)
        {
            OptionMembers = Claim,Receipt;
            DataClassification = ToBeClassified;
        }
        field(45; "SponsorShip Application No"; Code[20])
        {
            DataClassification = ToBeClassified;
            /*  TableRelation = "Sponsorship Application"."Application No" where("Student No." = field("Student No."));
             trigger OnValidate()
             var
                 SponsorApp: Record "Sponsorship Application";
             begin
                 TestField("Sponsor Account");
                 if SponsorApp.get("Student No.", "SponsorShip Application No") then
                     "Amount to pay" := SponsorApp."Approved Amount";
             end; */
        }
    }

    keys
    {
        key(Key1; "Student No.", "Line No")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnInsert()
    begin

        StudentCharges.Reset;
        StudentCharges.SetRange(StudentCharges."Student No.", "Student No.");
        if StudentCharges.Find('-') then begin
            StudentCharges.ModifyAll(StudentCharges."Applied Amount", 0);
            StudentCharges.ModifyAll(StudentCharges."Apply to", false);
        end;

        "Transaction Date" := Today;
    end;

    var
        CustLedger: Record "Cust. Ledger Entry";
        StudentCharges: Record "Student Charges";
        GenJnl: Record "Gen. Journal Line";
        Stages: Record "Programme Stages";
        Units: Record "Units/Subjects";

        Charges: Record Charge;
        Receipt: Record Receipt;
        ReceiptItems: Record "Receipt Items";
        GenSetUp: Record "General Set-Up";
        Billing: Codeunit "Student Billing";
        TotalApplied: Decimal;
        Sems: Record Semesters;
        DueDate: Date;
        Cust: Record Customer;
        CustPostGroup: Record "Customer Posting Group";
        GLPosting: Codeunit "Gen. Jnl.-Post B2";
        CReg: Record "Course Registration";
        CustLedg: Record "Cust. Ledger Entry";
        InvoiceHeader: Record "Sales Invoice Header";
        InvoiceLine: Record "Sales Invoice Line";
        InvAmount: Decimal;
        BankRec: Record "Bank Account";
        NoSeries: Record "No. Series Line";
        LastReceipt: Code[40];
        bank: Record "Bank Account";
        "G/LEntry": Record "G/L Entry";
        ReceiptH: Record "Receipts Header";
        NoSeriesMgt: Codeunit "No. Series";
}

