Page 50364 "Student Payments Form"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Student Payments";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(StudentNo; Rec."Student No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Student No. field.';
                }
                field(PaymentMode; Rec."Payment Mode")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Payment Mode field.';

                    trigger OnValidate()
                    begin
                        Rec."Transaction Date" := Today;
                        ApplicationEnable := true;

                        if Rec."Payment Mode" <> Rec."payment mode"::Cash then
                            "Amount to payEnable" := false;

                        if ((Rec."Payment Mode" = Rec."payment mode"::"Banker's Cheque") or (Rec."Payment Mode" = Rec."payment mode"::"Bank Slip") or
                        (Rec."Payment Mode" = Rec."payment mode"::Cheque) or (Rec."Payment Mode" = Rec."payment mode"::"Money Order") or (Rec."Payment Mode" = Rec."payment mode"::Mpesa) or
                        (Rec."Payment Mode" = Rec."payment mode"::Cash)) or (Rec."Payment Mode" = Rec."payment mode"::"Direct Bank Deposit") or (Rec."Payment Mode" = Rec."payment mode"::Sponsor) then begin
                            "Cheque NoEnable" := true;
                            "Drawer NameEnable" := true;
                            //CurrForm."Drawer's Bank".ENABLED:=TRUE;
                            //CurrForm."Drawer's Branch Code".ENABLED:=TRUE;
                            "Bank No.Enable" := true;
                            "Amount to payEnable" := true;
                            "Bank Slip DateEnable" := true;
                            "Unref. Entry No.Enable" := false;

                            if BankRec.Get(Rec."Bank No.") then
                                Rec."Drawer Name" := BankRec.Contact;

                        end else begin

                            "Cheque NoEnable" := false;
                            "Drawer NameEnable" := false;
                            //CurrForm."Drawer's Bank".ENABLED:=FALSE;
                            //CurrForm."Drawer's Branch Code".ENABLED:=FALSE;
                            //CurrForm."Bank No.".ENABLED:=FALSE;
                            "Amount to payEnable" := false;
                            "Bank Slip DateEnable" := false;
                            "Unref. Entry No.Enable" := false;
                            "Staff Invoice No.Enable" := false;
                            "Staff DescriptionEnable" := false;


                        end;

                        if Rec."Payment Mode" = Rec."payment mode"::Unreferenced then begin
                            "Bank No.Enable" := false;
                            "Unref. Entry No.Enable" := true;
                            Rec."Bank No." := '';
                            ApplicationEnable := false;

                        end;



                        if Rec."Payment Mode" = Rec."payment mode"::"Staff Invoice" then
                            "Amount to payEnable" := true;

                        if Rec."Payment Mode" = Rec."payment mode"::"Money Order" then
                            Rec."Bank No." := 'BFS';

                        if Rec."Payment Mode" = Rec."payment mode"::PDQ then begin
                            "Applies to Doc NoEnable" := false;
                            "Apply to OverpaymentEnable" := true;
                        end else
                            "Apply to OverpaymentEnable" := false;

                        if Rec."Payment Mode" = Rec."payment mode"::"Staff Invoice" then begin
                            "Staff Invoice No.Enable" := true;
                            "Staff DescriptionEnable" := true;
                            "Bank No.Enable" := false;
                            "Bank No.Enable" := false;
                            "Amount to payEnable" := false;
                        end else begin
                            "Bank No.Enable" := true;
                            "Bank No.Enable" := true;
                            "Amount to payEnable" := true;

                        end;

                        if Rec."Payment Mode" = Rec."payment mode"::Weiver then begin
                            "Bank No.Enable" := false;
                            "Bank No.Enable" := false;
                            "Amount to payEnable" := true;
                            "Payment ByEnable" := true;
                        end;
                        if ((Rec."Payment Mode" = Rec."payment mode"::CDF) or (Rec."Payment Mode" = Rec."payment mode"::HELB)) then begin
                            "Bank No.Enable" := false;
                            "Bank No.Enable" := false;
                            "Amount to payEnable" := true;
                            "Payment ByEnable" := true;
                            "CDF AccountEnable" := true;
                            "CDF DescriptionEnable" := true;
                        end;
                        if Rec."Payment Mode" = Rec."payment mode"::Sponsor then begin
                            "Bank No.Enable" := false;
                            SponsorshipEnable := true;
                            Rec."Bank No." := '';


                        end;
                        BankName := '';
                        BankAcc.Reset;
                        BankAcc.SetRange(BankAcc."No.", Rec."Bank No.");
                        if BankAcc.Find('-') then begin
                            BankName := BankAcc.Name;
                        end;
                    end;
                }
                field(BankNo; Rec."Bank No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Bank No. field.';
                }
                field(BankSlipChequeNo; Rec."Cheque No")
                {
                    ApplicationArea = Basic;
                    Caption = 'Bank Slip/Cheque No.';
                    Enabled = "Cheque NoEnable";
                    ToolTip = 'Specifies the value of the Bank Slip/Cheque No. field.';
                }
                field(Amounttopay; Rec."Amount to pay")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Amount to pay field.';
                }
                field(BankSlipDate; Rec."Bank Slip Date")
                {
                    ApplicationArea = Basic;
                    Enabled = "Bank Slip DateEnable";
                    ToolTip = 'Specifies the value of the Bank Slip Date field.';
                }
                field("Bank Name"; BankName)
                {
                    ApplicationArea = Basic;
                    Caption = 'Bank Name';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Bank Name field.';
                }
                field(PaymentBy; Rec."Payment By")
                {
                    ApplicationArea = Basic;
                    Enabled = "Payment ByEnable";
                    ToolTip = 'Specifies the value of the Payment By field.';
                }
                field(DrawerName; Rec."Drawer Name")
                {
                    ApplicationArea = Basic;
                    Enabled = "Drawer NameEnable";
                    ToolTip = 'Specifies the value of the Drawer Name field.';
                }
                field(SponsorAccount; Rec."Sponsor Account")
                {
                    ApplicationArea = Basic;
                    Enabled = SponsorshipEnable;
                    ToolTip = 'Specifies the value of the Sponsor Account field.';
                }
                field("SponsorShip Application No"; Rec."SponsorShip Application No")
                {
                    ApplicationArea = Basic;
                    Enabled = SponsorshipEnable;
                    ToolTip = 'Specifies the value of the SponsorShip Application No field.';
                }
                field(SponsorDescription; Rec."Sponsor Description")
                {
                    ApplicationArea = Basic;
                    Enabled = SponsorshipEnable;
                    ToolTip = 'Specifies the value of the Sponsor Description field.';
                }
                field(StaffUniversityNo; Rec."Staff Number")
                {
                    ApplicationArea = Basic;
                    Caption = 'Staff/University No';
                    Editable = true;
                    Enabled = "Staff Invoice No.Enable";
                    ToolTip = 'Specifies the value of the Staff/University No field.';
                }
                field(StaffDescription; Rec."Staff Description")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    Enabled = "Staff DescriptionEnable";
                    ToolTip = 'Specifies the value of the Staff Description field.';
                }
                field(UnIndentifiedGLAccount; Rec."UnIndentified G/L Account")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the UnIndentified G/L Account field.';
                }
                field(AppliestoDocNo; Rec."Applies to Doc No")
                {
                    ApplicationArea = Basic;
                    Enabled = "Applies to Doc NoEnable";
                    ToolTip = 'Specifies the value of the Applies to Doc No field.';
                }
                field(UnrefEntryNo; Rec."Unref. Entry No.")
                {
                    ApplicationArea = Basic;
                    Enabled = "Unref. Entry No.Enable";
                    ToolTip = 'Specifies the value of the Unref. Entry No. field.';
                }

            }
        }
    }

    actions
    {
        area(navigation) { }
        area(processing)
        {
            action(Post)
            {
                ApplicationArea = Basic;
                Caption = 'Post';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Post action.';

                trigger OnAction()
                begin
                    Rec.TestField("Transaction Date");

                    if Confirm('Do you want to post the transaction?', true) = false then begin
                        exit;
                    end;

                    if Rec."Payment Mode" <> Rec."payment mode"::Sponsor then begin
                        Rec.TestField("Bank Slip Date");

                    end;

                    // IF "Amount to pay" <> TotalApplied THEN BEGIN
                    // IF CONFIRM('There is an overpayment. Do you want to continue?',FALSE) = FALSE THEN BEGIN
                    // EXIT;
                    // END;
                    //
                    // END;


                    if Cust.Get(Rec."Student No.") then begin
                        Cust."Application Method" := Cust."application method"::"Apply to Oldest";
                        Cust.Status := Cust.Status::Current;
                        //Cust.MODIFY;
                    end;

                    if Cust.Get(Rec."Student No.") then
                        GenJnl.Reset;
                    GenJnl.SetRange("Journal Template Name", 'SALES');
                    GenJnl.SetRange("Journal Batch Name", 'STUD PAY');
                    GenJnl.DeleteAll;

                    GenSetUp.Get();


                    GenJnl.Reset;
                    GenJnl.SetRange("Journal Template Name", 'SALES');
                    GenJnl.SetRange("Journal Batch Name", 'STUD PAY');
                    GenJnl.DeleteAll;

                    GenSetUp.TestField(GenSetUp."Pre-Payment Account");



                    //Charge Student if not charged
                    StudentCharges.Reset;
                    StudentCharges.SetRange(StudentCharges."Student No.", Rec."Student No.");
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
                            //
                            if Cust.Get(Rec."Student No.") then begin
                                if Cust."Bill-to Customer No." <> '' then
                                    GenJnl."Account No." := Cust."Bill-to Customer No."
                                else
                                    GenJnl."Account No." := Rec."Student No.";
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

                            CReg.Reset;
                            CReg.SetRange(CReg."Student No.", Rec."Student No.");
                            CReg.SetRange(CReg.Reversed, false);
                            if CReg.Find('+') then begin
                                if ProgrammeSetUp.Get(CReg.Programme) then begin
                                    //ProgrammeSetUp.TESTFIELD(ProgrammeSetUp."Department Code");
                                    //ProgrammeSetUp.TESTFIELD(Cust."Global Dimension 1 Code");
                                    GenJnl."Shortcut Dimension 1 Code" := Cust."Global Dimension 1 Code";
                                    if cust2.Get() then
                                        if cust2."Global Dimension 2 Code" <> '' then
                                            GenJnl."Shortcut Dimension 2 Code" := cust2."Global Dimension 2 Code"
                                        else
                                            Error('Department haiko!')
                                    //else
                                    //GenJnl."Shortcut Dimension 2 Code":=ProgrammeSetUp."Department Code";
                                end;
                            end;
                            GenJnl.Validate(GenJnl."Shortcut Dimension 1 Code");
                            GenJnl.Validate(GenJnl."Shortcut Dimension 2 Code");


                            GenJnl."Due Date" := DueDate;
                            GenJnl.Validate(GenJnl."Due Date");

                            GenJnl.Insert;

                            //Distribute Money
                            if StudentCharges."Tuition Fee" = true then begin
                                if Stages.Get(StudentCharges.Programme, StudentCharges.Stage) then begin
                                    if (Stages."Distribution Full Time (%)" > 0) or (Stages."Distribution Part Time (%)" > 0) then begin
                                        Stages.TestField(Stages."Distribution Account");
                                        StudentCharges.TestField(StudentCharges.Distribution);
                                        if Cust.Get(Rec."Student No.") then begin
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

                                            CReg.Reset;
                                            CReg.SetRange(CReg."Student No.", Rec."Student No.");
                                            CReg.SetRange(CReg.Reversed, false);
                                            if CReg.Find('+') then begin
                                                if ProgrammeSetUp.Get(CReg.Programme) then begin
                                                    //ProgrammeSetUp.TESTFIELD(ProgrammeSetUp."Department Code");
                                                    //ProgrammeSetUp.TESTFIELD(Cust."Global Dimension 1 Code");
                                                    GenJnl."Shortcut Dimension 1 Code" := Cust."Global Dimension 1 Code";
                                                    GenJnl."Shortcut Dimension 2 Code" := ProgrammeSetUp."Department Code";
                                                end;
                                            end;
                                            GenJnl.Validate(GenJnl."Shortcut Dimension 1 Code");
                                            GenJnl.Validate(GenJnl."Shortcut Dimension 2 Code");
                                            if GenJnl.Amount <> 0 then
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

                                        //Stages.TESTFIELD(Stages.Department);
                                        CReg.Reset;
                                        CReg.SetRange(CReg."Student No.", Rec."Student No.");
                                        CReg.SetRange(CReg.Reversed, false);
                                        if CReg.Find('+') then begin
                                            if ProgrammeSetUp.Get(CReg.Programme) then begin
                                                //ProgrammeSetUp.TESTFIELD(ProgrammeSetUp."Department Code");
                                                //ProgrammeSetUp.TESTFIELD(Cust."Global Dimension 1 Code");
                                                GenJnl."Shortcut Dimension 1 Code" := Cust."Global Dimension 1 Code";
                                                GenJnl."Shortcut Dimension 2 Code" := ProgrammeSetUp."Department Code";
                                            end;
                                        end;
                                        GenJnl.Validate(GenJnl."Shortcut Dimension 1 Code");
                                        GenJnl.Validate(GenJnl."Shortcut Dimension 2 Code");
                                        if GenJnl.Amount <> 0 then
                                            GenJnl.Insert;

                                    end;
                                end;
                            end;
                            //End Distribution


                            StudentCharges.Recognized := true;
                            StudentCharges.Modify;

                        until StudentCharges.Next = 0;



                        //Post New
                        GenJnl.Reset;
                        GenJnl.SetRange("Journal Template Name", 'SALES');
                        GenJnl.SetRange("Journal Batch Name", 'STUD PAY');
                        if GenJnl.Find('-') then begin
                            GenJnl.Amount := StudentCharges.Amount * (StudentCharges.Distribution / 100);

                            Codeunit.Run(Codeunit::"Gen. Jnl.-Post B2", GenJnl);
                        end;

                        //Post New



                    end;


                    //BILLING
                    if (Rec."Payment Mode" = Rec."payment mode"::Unreferenced) or (Rec."Payment Mode" = Rec."payment mode"::Sponsor) then begin
                        GenSetUp.Get;
                        GenSetUp.TestField("Receipt Nos.");
                        "No. Series Line".SetRange("No. Series Line"."Series Code", GenSetUp."Receipt Nos.");
                        if "No. Series Line".Find('-') then begin
                            "Last No" := IncStr("No. Series Line"."Last No. Used");
                            "No. Series Line"."Last No. Used" := IncStr("No. Series Line"."Last No. Used");
                            "No. Series Line".Modify;
                        end;
                    end;
                    if (Rec."Payment Mode" <> Rec."payment mode"::Unreferenced) and (Rec."Payment Mode" <> Rec."payment mode"::Sponsor) then begin
                        "Last No" := '';
                        "No. Series Line".Reset;
                        BankRec.Get(Rec."Bank No.");
                        BankRec.TestField(BankRec."Receipt No. Series");
                        "No. Series Line".SetRange("No. Series Line"."Series Code", BankRec."Receipt No. Series");
                        if "No. Series Line".Find('-') then begin
                            "Last No" := IncStr("No. Series Line"."Last No. Used");
                            "No. Series Line"."Last No. Used" := IncStr("No. Series Line"."Last No. Used");
                            "No. Series Line".Modify;
                        end;
                    end;
                    //End Denno

                    GenJnl.Reset;
                    GenJnl.SetRange("Journal Template Name", 'SALES');
                    GenJnl.SetRange("Journal Batch Name", 'STUD PAY');
                    GenJnl.DeleteAll;



                    Cust.Status := Cust.Status::Current;
                    //Cust.MODIFY;


                    if Rec."Payment Mode" = Rec."payment mode"::PDQ then
                        Error('Overpayment must be applied manualy.');


                    /////////////////////////////////////////////////////////////////////////////////
                    //Receive payments
                    if Rec."Payment Mode" <> Rec."payment mode"::PDQ then begin

                        //Over Payment
                        TotalApplied := 0;



                        CReg.Reset;
                        CReg.SetCurrentkey(CReg."Reg. Transacton ID");
                        //CReg.SETRANGE(CReg."Reg. Transacton ID",StudentCharges."Reg. Transacton ID");
                        CReg.SetRange(CReg."Student No.", Rec."Student No.");
                        if CReg.Find('+') then
                            CourseReg := CReg."Reg. Transacton ID";





                        Receipt.Init;
                        Receipt."Receipt No." := "Last No";
                        //Receipt.VALIDATE(Receipt."Receipt No.");
                        Receipt."Student No." := Rec."Student No.";
                        Receipt.Date := Rec."Transaction Date";
                        Receipt."Source Rcpt No" := Rec."Receipt No";
                        Receipt."Bank Slip Date" := Rec."Bank Slip Date";
                        Receipt."Bank Slip/Cheque No" := Rec."Cheque No";
                        Receipt."Bank Account" := Rec."Bank No.";
                        if Rec."Payment Mode" = Rec."payment mode"::"Bank Slip" then
                            Receipt."Payment Mode" := Receipt."payment mode"::"Bank Slip" else
                            if Rec."Payment Mode" = Rec."payment mode"::Cheque then
                                Receipt."Payment Mode" := Receipt."payment mode"::Cheque else
                                if Rec."Payment Mode" = Rec."payment mode"::Cash then
                                    Receipt."Payment Mode" := Receipt."payment mode"::Cash else
                                    if Rec."Payment Mode" = Rec."payment mode"::Mpesa then
                                        Receipt."Payment Mode" := Receipt."payment mode"::Mpesa else
                                        Receipt."Payment Mode" := Rec."Payment Mode";
                        Receipt.Amount := Rec."Amount to pay";
                        Receipt."Payment By" := Rec."Payment By";
                        Receipt."Transaction Date" := Today;
                        Receipt."Transaction Time" := Time;
                        Receipt."User ID" := UserId;
                        Receipt."Reg ID" := CourseReg;
                        Receipt."Unreff G/L Account" := Rec."UnIndentified G/L Account";
                        Receipt."Unreff Entry No" := Rec."Unref. Entry No.";
                        Receipt.Insert;

                        GenSetUp.Get();
                        Receipt.Reset;
                        if Receipt.Find('+') then begin

                        end;



                        if (Rec."Payment Mode" <> Rec."payment mode"::Unreferenced) and (Rec."Payment Mode" <> Rec."payment mode"::"Staff Invoice")
                        and (Rec."Payment Mode" <> Rec."payment mode"::Weiver) and (Rec."Payment Mode" <> Rec."payment mode"::CDF)
                        and (Rec."Payment Mode" <> Rec."payment mode"::HELB) and (Rec."Payment Mode" <> Rec."payment mode"::Sponsor) then begin
                            //Bank Entry
                            if BankRec.Get(Rec."Bank No.") then
                                BankName := BankRec.Name;
                            GenJnl.Init;
                            GenJnl."Line No." := GenJnl."Line No." + 10000;
                            GenJnl."Posting Date" := Today;
                            GenJnl."Document Date" := Rec."Bank Slip Date";
                            GenJnl."Document No." := "Last No";
                            if GenJnl."Document No." = '' then GenJnl."Document No." := Rec."Cheque No";
                            GenJnl."External Document No." := Rec."Cheque No";
                            GenJnl.Validate(GenJnl."Document No.");
                            GenJnl."Journal Template Name" := 'SALES';
                            GenJnl."Journal Batch Name" := 'STUD PAY';
                            GenJnl."Account Type" := GenJnl."account type"::"Bank Account";
                            GenJnl."Account No." := Rec."Bank No.";
                            GenJnl.Amount := Rec."Amount to pay";
                            GenJnl.Validate(GenJnl."Account No.");
                            GenJnl.Validate(GenJnl.Amount);
                            GenJnl.Description := 'Fee Payment ' + Format(Rec."Payment Mode") + ' ' + Rec."Cheque No";
                            //FORMAT("Payment Mode")+'-'+FORMAT("Bank Slip Date")+'-'+BankName;
                            GenJnl."Bal. Account Type" := GenJnl."bal. account type"::Customer;
                            if Cust."Bill-to Customer No." <> '' then
                                GenJnl."Bal. Account No." := Cust."Bill-to Customer No."
                            else
                                GenJnl."Bal. Account No." := Rec."Student No.";


                            GenJnl.Validate(GenJnl."Bal. Account No.");

                            CReg.Reset;
                            CReg.SetRange(CReg."Student No.", Rec."Student No.");
                            CReg.SetRange(CReg.Reversed, false);
                            if CReg.Find('+') then begin
                                if ProgrammeSetUp.Get(CReg.Programme) then begin
                                    //ProgrammeSetUp.TESTFIELD(ProgrammeSetUp."Department Code");
                                    //ProgrammeSetUp.TESTFIELD(Cust."Global Dimension 1 Code");
                                    GenJnl."Shortcut Dimension 1 Code" := Cust."Global Dimension 1 Code";
                                    GenJnl."Shortcut Dimension 2 Code" := ProgrammeSetUp."Department Code";
                                end;
                            end;
                            GenJnl.Validate(GenJnl."Shortcut Dimension 1 Code");
                            GenJnl.Validate(GenJnl."Shortcut Dimension 2 Code");
                            if GenJnl.Amount <> 0 then
                                GenJnl.Insert;
                        end;
                        if Rec."Payment Mode" = Rec."payment mode"::Unreferenced then begin
                            Rec.TestField("UnIndentified G/L Account");
                            Rec.TestField("Unref. Entry No.");
                            Rec.CalcFields("Unref. Entry No. Used Count");
                            if Rec."Unref. Entry No. Used Count" > 1 then Error('Please note that the selected Entry Number has already been used');
                            GenJnl.Init;
                            GenJnl."Line No." := GenJnl."Line No." + 10000;
                            GenJnl."Posting Date" := Rec."Bank Slip Date";
                            GenJnl."Document Date" := today;
                            GenJnl."Document No." := "Last No";
                            GenJnl."External Document No." := Rec."Unref Document No.";
                            GenJnl.Validate(GenJnl."Document No.");
                            GenJnl."Journal Template Name" := 'SALES';
                            GenJnl."Journal Batch Name" := 'STUD PAY';
                            GenJnl."Account Type" := GenJnl."account type"::"G/L Account";
                            GenJnl."Account No." := Rec."UnIndentified G/L Account";
                            GenJnl.Amount := Rec."Amount to pay";
                            GenJnl.Validate(GenJnl."Account No.");
                            GenJnl.Validate(GenJnl.Amount);
                            GenJnl.Description := 'Fee Payment ' + Format(Rec."Payment Mode") + ' ' + Rec."Unref Document No.";
                            GenJnl."Bal. Account Type" := GenJnl."bal. account type"::Customer;
                            if Cust."Bill-to Customer No." <> '' then
                                GenJnl."Bal. Account No." := Cust."Bill-to Customer No."
                            else
                                GenJnl."Bal. Account No." := Rec."Student No.";

                            //GenJnl."Applies-to Doc. No.":="Unref Document No.";
                            //GenJnl.VALIDATE(GenJnl."Applies-to Doc. No.");

                            CReg.Reset;
                            CReg.SetRange(CReg."Student No.", Rec."Student No.");
                            CReg.SetRange(CReg.Reversed, false);
                            if CReg.Find('+') then begin
                                if ProgrammeSetUp.Get(CReg.Programme) then begin
                                    //ProgrammeSetUp.TESTFIELD(ProgrammeSetUp."Department Code");
                                    //ProgrammeSetUp.TESTFIELD(Cust."Global Dimension 1 Code");
                                    GenJnl."Shortcut Dimension 1 Code" := Cust."Global Dimension 1 Code";
                                    GenJnl."Shortcut Dimension 2 Code" := ProgrammeSetUp."Department Code";
                                end;
                            end;
                            GenJnl.Validate(GenJnl."Shortcut Dimension 1 Code");
                            GenJnl.Validate(GenJnl."Shortcut Dimension 2 Code");
                            if GenJnl.Amount <> 0 then
                                GenJnl.Insert;

                        end;
                        // BKK...Staff Invoice
                        if Rec."Payment Mode" = Rec."payment mode"::"Staff Invoice" then begin

                            GenJnl.Init;
                            GenJnl."Line No." := GenJnl."Line No." + 10000;
                            GenJnl."Posting Date" := Today;
                            GenJnl."Document Date" := Rec."Bank Slip Date";
                            GenJnl."Document No." := "Last No";
                            GenJnl."External Document No." := '';
                            GenJnl.Validate(GenJnl."Document No.");
                            GenJnl."Journal Template Name" := 'SALES';
                            GenJnl."Journal Batch Name" := 'STUD PAY';
                            GenJnl."Account Type" := GenJnl."account type"::Customer;
                            GenJnl."Account No." := Rec."Student No.";
                            GenJnl.Amount := -Rec."Amount to pay";
                            GenJnl.Validate(GenJnl."Account No.");
                            GenJnl.Validate(GenJnl.Amount);
                            GenJnl.Description := cust2.Name;
                            GenJnl."Bal. Account Type" := GenJnl."bal. account type"::"G/L Account";
                            GenJnl."Bal. Account No." := '30103';

                            CReg.Reset;
                            CReg.SetRange(CReg."Student No.", Rec."Student No.");
                            CReg.SetRange(CReg.Reversed, false);
                            if CReg.Find('+') then begin
                                if ProgrammeSetUp.Get(CReg.Programme) then begin
                                    //ProgrammeSetUp.TESTFIELD(ProgrammeSetUp."Department Code");
                                    //ProgrammeSetUp.TESTFIELD(Cust."Global Dimension 1 Code");
                                    GenJnl."Shortcut Dimension 1 Code" := Cust."Global Dimension 1 Code";
                                    GenJnl."Shortcut Dimension 2 Code" := ProgrammeSetUp."Department Code";
                                end;
                            end;
                            GenJnl.Validate(GenJnl."Shortcut Dimension 1 Code");
                            GenJnl.Validate(GenJnl."Shortcut Dimension 2 Code");
                            if GenJnl.Amount <> 0 then
                                GenJnl.Insert;


                        end;
                        //Sponsor
                        if Rec."Payment Mode" = Rec."payment mode"::Sponsor then begin
                            Rec.TestField("Sponsor Account");
                            //  TestField("Unref. Entry No.");
                            //  CalcFields("Unref. Entry No. Used Count");
                            //  if "Unref. Entry No. Used Count" > 1 then Error('Please note that the selected Entry Number has already been used');
                            GenJnl.Init;
                            GenJnl."Line No." := GenJnl."Line No." + 10000;
                            GenJnl."Posting Date" := Today;
                            GenJnl."Document Date" := Rec."Bank Slip Date";
                            GenJnl."Document No." := "Last No";
                            GenJnl."External Document No." := Rec."Unref Document No.";
                            GenJnl.Validate(GenJnl."Document No.");
                            GenJnl."Journal Template Name" := 'SALES';
                            GenJnl."Journal Batch Name" := 'STUD PAY';
                            GenJnl."Account Type" := GenJnl."account type"::"G/L Account";
                            GenJnl."Account No." := Rec."Sponsor Account";
                            GenJnl.Amount := Rec."Amount to pay";
                            GenJnl.Validate(GenJnl."Account No.");
                            GenJnl.Validate(GenJnl.Amount);
                            GenJnl.Description := Rec."Sponsor Description" + '-' + Rec."Sponsor Account";
                            GenJnl."Bal. Account Type" := GenJnl."bal. account type"::Customer;
                            if Cust."Bill-to Customer No." <> '' then
                                GenJnl."Bal. Account No." := Cust."Bill-to Customer No."
                            else
                                GenJnl."Bal. Account No." := Rec."Student No.";

                            //GenJnl."Applies-to Doc. No.":="Unref Document No.";
                            //GenJnl.VALIDATE(GenJnl."Applies-to Doc. No.");

                            CReg.Reset;
                            CReg.SetRange(CReg."Student No.", Rec."Student No.");
                            CReg.SetRange(CReg.Reversed, false);
                            if CReg.Find('+') then begin
                                if ProgrammeSetUp.Get(CReg.Programme) then begin
                                    //ProgrammeSetUp.TESTFIELD(ProgrammeSetUp."Department Code");
                                    //ProgrammeSetUp.TESTFIELD(Cust."Global Dimension 1 Code");
                                    GenJnl."Shortcut Dimension 1 Code" := Cust."Global Dimension 1 Code";
                                    GenJnl."Shortcut Dimension 2 Code" := ProgrammeSetUp."Department Code";
                                end;
                            end;
                            GenJnl.Validate(GenJnl."Shortcut Dimension 1 Code");
                            GenJnl.Validate(GenJnl."Shortcut Dimension 2 Code");
                            if GenJnl.Amount <> 0 then
                                GenJnl.Insert;

                        end;
                        // BKK...CDF
                        if Rec."Payment Mode" = Rec."payment mode"::CDF then begin
                            GenSetUp.TestField(GenSetUp."CDF Account");
                            GenJnl.Init;
                            GenJnl."Line No." := GenJnl."Line No." + 10000;
                            GenJnl."Posting Date" := Today;
                            GenJnl."Document Date" := Rec."Bank Slip Date";
                            GenJnl."Document No." := "Last No";
                            GenJnl."External Document No." := 'CDF';
                            GenJnl.Validate(GenJnl."Document No.");
                            GenJnl."Journal Template Name" := 'SALES';
                            GenJnl."Journal Batch Name" := 'STUD PAY';
                            GenJnl."Account Type" := GenJnl."account type"::Customer;
                            GenJnl."Account No." := Rec."Student No.";
                            GenJnl.Amount := -Rec."Amount to pay";
                            GenJnl.Validate(GenJnl."Account No.");
                            GenJnl.Validate(GenJnl.Amount);
                            GenJnl.Description := Rec."Sponsor Description";
                            //GenJnl."Bal. Account Type":=GenJnl."Bal. Account Type"::"G/L Account";
                            //GenJnl."Bal. Account No.":=;
                            CReg.Reset;
                            CReg.SetRange(CReg."Student No.", Rec."Student No.");
                            CReg.SetRange(CReg.Reversed, false);
                            if CReg.Find('+') then begin
                                if ProgrammeSetUp.Get(CReg.Programme) then begin
                                    //ProgrammeSetUp.TESTFIELD(ProgrammeSetUp."Department Code");
                                    //ProgrammeSetUp.TESTFIELD(Cust."Global Dimension 1 Code");
                                    GenJnl."Shortcut Dimension 1 Code" := Cust."Global Dimension 1 Code";
                                    GenJnl."Shortcut Dimension 2 Code" := ProgrammeSetUp."Department Code";
                                end;
                            end;
                            GenJnl.Validate(GenJnl."Shortcut Dimension 1 Code");
                            GenJnl.Validate(GenJnl."Shortcut Dimension 2 Code");
                            if GenJnl.Amount <> 0 then
                                GenJnl.Insert;

                            GenJnl.Init;
                            GenJnl."Line No." := GenJnl."Line No." + 10000;
                            GenJnl."Posting Date" := Today;
                            GenJnl."Document Date" := Rec."Bank Slip Date";
                            GenJnl."Document No." := "Last No";
                            GenJnl."External Document No." := 'CDF';
                            GenJnl.Validate(GenJnl."Document No.");
                            GenJnl."Journal Template Name" := 'SALES';
                            GenJnl."Journal Batch Name" := 'STUD PAY';
                            GenJnl."Account Type" := GenJnl."account type"::"G/L Account";
                            GenJnl."Account No." := GenSetUp."CDF Account";
                            GenJnl.Amount := Rec."Amount to pay";
                            GenJnl.Validate(GenJnl."Account No.");
                            GenJnl.Validate(GenJnl.Amount);
                            GenJnl.Description := Rec."Student No.";

                            CReg.Reset;
                            CReg.SetRange(CReg."Student No.", Rec."Student No.");
                            CReg.SetRange(CReg.Reversed, false);
                            if CReg.Find('+') then begin
                                if ProgrammeSetUp.Get(CReg.Programme) then begin
                                    //ProgrammeSetUp.TESTFIELD(ProgrammeSetUp."Department Code");
                                    //ProgrammeSetUp.TESTFIELD(Cust."Global Dimension 1 Code");
                                    GenJnl."Shortcut Dimension 1 Code" := Cust."Global Dimension 1 Code";
                                    GenJnl."Shortcut Dimension 2 Code" := ProgrammeSetUp."Department Code";
                                end;
                            end;
                            GenJnl.Validate(GenJnl."Shortcut Dimension 1 Code");
                            GenJnl.Validate(GenJnl."Shortcut Dimension 2 Code");
                            if GenJnl.Amount <> 0 then
                                GenJnl.Insert;


                        end;

                        // Post Weiver Fees 400455 ...BKK
                        /*
                       IF "Payment Mode"="Payment Mode"::weiver THEN BEGIN
                       GenJnl.INIT;
                       GenJnl."Line No." := GenJnl."Line No." + 10000;
                       GenJnl."Posting Date":="Transaction Date";
                       GenJnl."Document No.":="Last No";
                       GenJnl."External Document No.":='';
                       GenJnl.VALIDATE(GenJnl."Document No.");
                       GenJnl."Journal Template Name":='SALES';
                       GenJnl."Journal Batch Name":='STUD PAY';
                       GenJnl."Account Type":=GenJnl."Account Type"::Customer;
                       GenJnl."Account No.":="Student No.";
                       GenJnl.Amount:=-"Amount to pay";
                       GenJnl.VALIDATE(GenJnl."Account No.");
                       GenJnl.VALIDATE(GenJnl.Amount);
                       GenJnl.Description:='Staff Weiver';
                       GenJnl."Bal. Account Type":=GenJnl."Bal. Account Type"::"G/L Account";
                       GenJnl."Bal. Account No.":='10309';

                       CReg.RESET;
                       CReg.SETRANGE(CReg."Student No.","Student No.");
                       CReg.SETRANGE(CReg.Reversed,FALSE) ;
                       IF CReg.FIND('+') THEN BEGIN
                       IF ProgrammeSetUp.GET(CReg.Programme) THEN BEGIN
                       //ProgrammeSetUp.testfield(ProgrammeSetUp."Department Code");
                       //ProgrammeSetUp.TESTFIELD(Cust."Global Dimension 1 Code");
                       GenJnl."Shortcut Dimension 1 Code":=Cust."Global Dimension 1 Code";
                       GenJnl."Shortcut Dimension 2 Code":=ProgrammeSetUp."Department Code";
                       END;
                       END;
                       GenJnl.VALIDATE(GenJnl."Shortcut Dimension 1 Code");
                       GenJnl.VALIDATE(GenJnl."Shortcut Dimension 2 Code");

                       GenJnl.INSERT;


                       END;
                       */
                        if Rec."Payment Mode" = Rec."payment mode"::HELB then begin
                            GenSetUp.TestField(GenSetUp."Helb Account");
                            GenJnl.Init;
                            GenJnl."Line No." := GenJnl."Line No." + 10000;
                            GenJnl."Posting Date" := Today;
                            GenJnl."Document Date" := Rec."Bank Slip Date";
                            GenJnl."Document No." := "Last No";
                            GenJnl."External Document No." := '';
                            GenJnl.Validate(GenJnl."Document No.");
                            GenJnl."Journal Template Name" := 'SALES';
                            GenJnl."Journal Batch Name" := 'STUD PAY';
                            GenJnl."Account Type" := GenJnl."account type"::Customer;
                            GenJnl."Account No." := Rec."Student No.";
                            GenJnl.Amount := -Rec."Amount to pay";
                            GenJnl.Validate(GenJnl."Account No.");
                            GenJnl.Validate(GenJnl.Amount);
                            GenJnl.Description := 'HELB';
                            GenJnl."Bal. Account Type" := GenJnl."bal. account type"::"G/L Account";
                            GenJnl."Bal. Account No." := GenSetUp."Helb Account";
                            CReg.Reset;
                            CReg.SetRange(CReg."Student No.", Rec."Student No.");
                            CReg.SetRange(CReg.Reversed, false);
                            if CReg.Find('+') then begin
                                if ProgrammeSetUp.Get(CReg.Programme) then begin
                                    GenJnl."Shortcut Dimension 2 Code" := ProgrammeSetUp."Department Code";
                                end;
                            end;

                            GenJnl.Validate(GenJnl."Shortcut Dimension 2 Code");
                            if GenJnl.Amount <> 0 then
                                GenJnl.Insert;


                        end;

                        //Post

                        GenJnl.Reset;
                        GenJnl.SetRange("Journal Template Name", 'SALES');
                        GenJnl.SetRange("Journal Batch Name", 'STUD PAY');
                        if GenJnl.Find('-') then begin
                            Codeunit.Run(Codeunit::"Gen. Jnl.-Post B2", GenJnl);
                            //MODIFY;
                        end;

                        // Hostel Allocations
                        StudHostel.Reset;
                        StudHostel.SetRange(StudHostel.Student, Rec."Student No.");
                        StudHostel.SetRange(StudHostel.Billed, false);
                        if StudHostel.Find('-') then begin
                            StudHostel.Billed := true;
                            StudHostel.Modify;
                            Receipts.Reset;
                            if Receipts.Get("Last No") then begin
                                Receipts."Room No" := StudHostel."Space No";
                                Receipts.Modify;
                            end;

                            HostLedg.Reset;
                            HostLedg.SetRange(HostLedg."Space No", StudHostel."Space No");
                            HostLedg.SetRange(HostLedg."Hostel No", StudHostel."Hostel No");
                            if HostLedg.Find('-') then begin
                                HostLedg.Status := HostLedg.Status::"Partially Occupied";
                                HostLedg.Modify;
                            end;
                        end;

                        Receipts.Reset;
                        Receipts.SetCurrentkey(Receipts."Receipt No.");
                        Receipts.SetRange(Receipts."Receipt No.", "Last No");
                        if Receipts.Find('-') then begin
                            if Confirm('Do you want to print the receipt?', true) then
                                Report.Run(70134858, true, true, Receipts);
                        end;
                        GenSetUp.get;
                        if GenSetUp."Notify Student on Receipt" then
                            Billing.EmailStudentReceipt(Rec."Student No.", "Last No");
                    end;

                    Message('Posted Succesfully');
                    CurrPage.Close;

                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        //"Bank No.":='';

        if Rec."Payment Mode" <> Rec."payment mode"::Cash then
            "Amount to payEnable" := false;

        if ((Rec."Payment Mode" = Rec."payment mode"::"Banker's Cheque") or (Rec."Payment Mode" = Rec."payment mode"::"Bank Slip") or
        (Rec."Payment Mode" = Rec."payment mode"::Cheque)) then begin
            "Cheque NoEnable" := true;
            "Drawer NameEnable" := true;
            //CurrForm."Drawer's Bank".ENABLED:=TRUE;
            //CurrForm."Drawer's Branch Code".ENABLED:=TRUE;
            "Bank No.Enable" := true;
            "Amount to payEnable" := true;
            "Bank Slip DateEnable" := true;
        end else
            if Rec."Payment Mode" = Rec."payment mode"::Sponsor then begin
                "Bank No.Enable" := false;
                SponsorshipEnable := true;
                Rec."Bank No." := '';
                ApplicationEnable := false;


            end else begin

                "Cheque NoEnable" := false;
                "Drawer NameEnable" := false;
                //CurrForm."Drawer's Bank".ENABLED:=FALSE;
                //CurrForm."Drawer's Branch Code".ENABLED:=FALSE;
                //CurrForm."Bank No.".ENABLED:=FALSE;
                "Amount to payEnable" := false;

            end;


        if Rec."Payment Mode" = Rec."payment mode"::Cash then
            "Amount to payEnable" := true;

        if Rec."Payment Mode" = Rec."payment mode"::Mpesa then begin
            "Applies to Doc NoEnable" := false;
            "Apply to OverpaymentEnable" := true;
        end else
            "Apply to OverpaymentEnable" := false;

        //"Payment Mode":="Payment Mode"::"Bank Slip";
        //VALIDATE("Payment Mode");
        //"Bank No.":='CONS SAVNG';
        Rec."Transaction Date" := Today;

        "Cheque NoEnable" := true;
        "Drawer NameEnable" := true;
        "Bank No.Enable" := true;
        "Amount to payEnable" := true;
        "Bank Slip DateEnable" := true;

        if Rec."Payment Mode" = Rec."payment mode"::Weiver then begin
            "Bank No.Enable" := false;
            "Amount to payEnable" := true;
            "Bank Slip DateEnable" := true;

        end;

        if Rec."Payment Mode" = Rec."payment mode"::CDF then begin
            "Bank No.Enable" := false;
            "Amount to payEnable" := true;
            "Bank Slip DateEnable" := true;
            "CDF AccountEnable" := true;
            "CDF DescriptionEnable" := true;
        end;

        BankName := '';
        BankAcc.Reset;
        BankAcc.SetRange(BankAcc."No.", Rec."Bank No.");
        if BankAcc.Find('-') then begin
            BankName := BankAcc.Name;
        end;
    end;

    trigger OnInit()
    begin
        "Payment ByEnable" := true;
        "Staff DescriptionEnable" := true;
        "Staff Invoice No.Enable" := true;
        "Unref. Entry No.Enable" := true;
        ApplicationEnable := true;
        "CDF DescriptionEnable" := true;
        "CDF AccountEnable" := true;
        "Apply to OverpaymentEnable" := true;
        "Applies to Doc NoEnable" := true;
        "Bank Slip DateEnable" := true;
        "Bank No.Enable" := true;
        "Drawer NameEnable" := true;
        "Cheque NoEnable" := true;
        "Amount to payEnable" := true;
        SponsorshipEnable := false;
    end;

    trigger OnOpenPage()
    begin
        /*
        "Cheque NoEnable" :=FALSE;
        "Drawer NameEnable" :=FALSE;
        //CurrForm."Drawer's Bank".ENABLED:=FALSE;
        //CurrForm."Drawer's Branch Code".ENABLED:=FALSE;
        "Amount to payEnable" :=FALSE;
        "Applies to Doc NoEnable" :=FALSE;
        "Apply to OverpaymentEnable" :=FALSE;
        "Bank Slip DateEnable" :=FALSE;
        "Bank No.Enable" :=FALSE;
        "Unref. Entry No.Enable" :=FALSE;
        "Staff Invoice No.Enable" :=FALSE;
        "Staff DescriptionEnable" :=FALSE;
        "CDF AccountEnable" :=FALSE;
        "CDF DescriptionEnable" :=FALSE;
        */

    end;

    var
        cust2: Record Customer;
        StudentCharges: Record "Student Charges";
        GenJnl: Record "Gen. Journal Line";
        Stages: Record "Programme Stages";
        Charges: Record Charge;
        Receipt: Record Receipt;
        GenSetUp: Record "General Set-Up";
        Billing: Codeunit "Student Billing";
        TotalApplied: Decimal;
        Sems: Record Semesters;
        DueDate: Date;
        Cust: Record Customer;
        CustPostGroup: Record "Customer Posting Group";
        Receipts: Record Receipt;
        CReg: Record "Course Registration";
        ProgrammeSetUp: Record Programme;
        CourseReg: Code[20];
        "No. Series Line": Record "No. Series Line";
        "Last No": Code[20];
        BankRec: Record "Bank Account";
        [InDataSet]
        "Amount to payEnable": Boolean;
        [InDataSet]
        "Cheque NoEnable": Boolean;
        [InDataSet]
        "Drawer NameEnable": Boolean;
        [InDataSet]
        "Bank No.Enable": Boolean;
        [InDataSet]
        "Bank Slip DateEnable": Boolean;
        [InDataSet]
        "Applies to Doc NoEnable": Boolean;
        [InDataSet]
        "Apply to OverpaymentEnable": Boolean;
        [InDataSet]
        "CDF AccountEnable": Boolean;
        [InDataSet]
        "CDF DescriptionEnable": Boolean;
        [InDataSet]
        ApplicationEnable: Boolean;
        [InDataSet]
        "Unref. Entry No.Enable": Boolean;
        [InDataSet]
        "Staff Invoice No.Enable": Boolean;
        [InDataSet]
        "Staff DescriptionEnable": Boolean;
        [InDataSet]
        "Payment ByEnable": Boolean;
        "SponsorshipEnable": Boolean;
        StudHostel: Record "Students Hostel Rooms";
        HostLedg: Record "Hostel Ledger";
        BankName: Text[100];
        BankAcc: Record "Bank Account";
}

