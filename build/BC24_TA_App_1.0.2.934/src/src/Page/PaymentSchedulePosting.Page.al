Page 50964 "Payment Schedule Posting"
{

    PageType = Card;
    SourceTable = "Payment Schedule";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(No; Rec.No)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No field.';
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field(PayingBankNo; Rec."Paying Bank No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Paying Bank No field.';
                }
                field(ChequeNo; Rec."Cheque No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cheque No field.';
                }
                field(ChequeDate; Rec."Cheque Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cheque Date field.';
                }
                field(Payee; Rec.Payee)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Payee field.';
                }
                field(TotalAmount; Rec."Total Amount")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Total Amount field.';
                }
                field(ChequeFormat; Rec."Cheque Format")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cheque Format field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
            part(Control6; "Payment Schedule Line")
            {
                ApplicationArea = basic;
                SubPageLink = No = field(No);
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Print Cheque")
            {
                ApplicationArea = Basic;
                Image = PreviewChecks;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the Print Cheque action.';

                trigger OnAction()
                begin
                    if Confirm('Do you really want to post the selected the payments?', false) then
                        //  IF "Cheque Format"="Cheque Format"::"Kalamazoo Format" THEN PrintKalamzoo;
                        //  IF "Cheque Format"="Cheque Format"::"Plain Format" THEN PrintNormal;
                        PostPaymentVoucher;
                end;
            }
            separator(Action15) { }
            action(Test)
            {
                Caption = 'Test Cheque';
                ApplicationArea = Basic;
                RunObject = Report "Payment Cheque";
                Promoted = true;
                PromotedCategory = Process;
                Image = TestReport;
                ToolTip = 'Executes the Test Cheque action.';
            }
            separator(Action17) { }
            action("Post Payments")
            {
                ApplicationArea = Basic;
                Image = PaymentJournal;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the Post Payments action.';
                trigger OnAction()
                var
                    CashOfficeSetup: record "Cash Office Setup";
                begin
                    CashOfficeSetup.get;
                    //CashOfficeSetup.TestField("Payment Posting Method"::"Payment Schedule");

                    PostPV;
                    PostImprest;
                    PostItemCash();
                    PostClaim();
                    PostScheduleHeader;

                    PSline.Reset;
                    PSline.SetRange(No, Rec.No);
                    if PSline.Find('-') then begin
                        repeat
                            if PVHead.Get(PSline."Payment No") then begin
                                PVHead."Cheque No." := Rec."Cheque No";
                                PVHead."Payment Release Date" := Rec."Cheque Date";
                                PVHead."Cheque Printed" := true;
                                PVHead."Payment Schedule No" := Rec.No;
                                PVHead.Modify;
                                // PostChequeNo.UpdateBankCheque("Paying Bank No",PSline."Payment No","Cheque No");
                            end;

                        until PSline.Next = 0;
                    end;
                    Rec.Posted := true;
                    // Status:=Payments.Status::Posted;
                    Rec."Posted By" := UserId;
                    Rec."Posting Dated" := Today;
                    Rec.Modify;
                end;
            }
        }
    }

    var
        Payments: Record "Payment Schedule";
        PSline: Record "Payment Schedule Line";
        PVHead: Record "Payments Header";
        GenJnlLine: Record "Gen. Journal Line";
        Temp: Record "Cash Office User Template";
        JTemplate: Code[20];
        JBatch: Code[20];
        LineNo: Integer;
        DocPrint: Codeunit "Document-Print";
        AdjustGenJnl: Codeunit "Adjust Gen. Journal Balance";
        PS: Record "Payment Schedule";
        BankRec: Record "Bank Account";
        IsPosted: Codeunit "Journal Post Successful";

    procedure PostPaymentVoucher()
    begin
        // DELETE ANY LINE ITEM THAT MAY BE PRESENT
        Rec.TestField(Payee);
        Rec.TestField("Paying Bank No");
        Temp.Get(UserId);

        JTemplate := Temp."Payment Journal Template";
        JBatch := Temp."Payment Journal Batch";

        if JTemplate = '' then begin
            Error('Ensure the PV Template is set up in Cash Office Setup');
        end;
        if JBatch = '' then begin
            Error('Ensure the PV Batch is set up in the Cash Office Setup')
        end;

        GenJnlLine.Reset;
        GenJnlLine.SetRange(GenJnlLine."Journal Template Name", JTemplate);
        GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", JBatch);
        if GenJnlLine.Find('+') then begin
            LineNo := GenJnlLine."Line No." + 1000;
        end
        else begin
            LineNo := 1000;
        end;
        GenJnlLine.DeleteAll;
        GenJnlLine.Reset;

        if Payments.Get(Rec.No) then PostHeader(Payments);


        if BankRec.Get(Rec."Paying Bank No") then begin
            BankRec."Last Check No." := Rec."Cheque No";
            BankRec.Modify;
        end;



        //END;
    end;

    procedure PostHeader(var Payment: Record "Payment Schedule")
    begin



        if (Rec."Cheque No" = '') then begin
            Error('Please ensure that the cheque number is inserted');
        end;

        //
        // IF Payments."Pay Mode"=Payments."Pay Mode"::EFT THEN
        //  BEGIN
        //    IF "Cheque No"='' THEN
        //      BEGIN
        //        ERROR ('Please ensure that the EFT number is inserted');
        //      END;
        //  END;
        //
        // IF Payments."Pay Mode"=Payments."Pay Mode"::"Account Transfer" THEN
        //  BEGIN
        //    IF "Cheque No"='' THEN
        //      BEGIN
        //        ERROR('Please ensure that the Letter of Credit ref no. is entered.');
        //      END;
        //  END;
        GenJnlLine.Reset;
        GenJnlLine.SetRange(GenJnlLine."Journal Template Name", JTemplate);
        GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", JBatch);

        if GenJnlLine.Find('+') then begin
            LineNo := GenJnlLine."Line No." + 1000;
        end
        else begin
            LineNo := 1000;
        end;


        LineNo := LineNo + 1000;
        GenJnlLine.Init;
        GenJnlLine."Journal Template Name" := JTemplate;
        GenJnlLine.Validate(GenJnlLine."Journal Template Name");
        GenJnlLine."Journal Batch Name" := JBatch;
        GenJnlLine.Validate(GenJnlLine."Journal Batch Name");
        GenJnlLine."Line No." := LineNo;
        GenJnlLine."Source Code" := 'PAYMENTJNL';
        GenJnlLine."Posting Date" := Rec."Cheque Date";

        GenJnlLine."Document Type" := GenJnlLine."document type"::Payment;
        GenJnlLine."Document No." := Rec.No;
        GenJnlLine."External Document No." := Rec."Cheque No";

        GenJnlLine."Account Type" := GenJnlLine."account type"::"Bank Account";
        GenJnlLine."Account No." := Rec."Paying Bank No";
        GenJnlLine.Validate(GenJnlLine."Account No.");

        // GenJnlLine."Currency Code":=Payments."Currency Code";
        // GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
        //CurrFactor
        //  GenJnlLine."Currency Factor":=Payments."Currency Factor";
        //  GenJnlLine.VALIDATE("Currency Factor");

        Rec.CalcFields("Total Amount");
        GenJnlLine.Amount := -(Rec."Total Amount");
        GenJnlLine.Validate(GenJnlLine.Amount);
        GenJnlLine."Bal. Account Type" := GenJnlLine."bal. account type"::"Bank Account";
        GenJnlLine."Bal. Account No." := '';
        // GenJnlLine."Recipient Bank Account":="Paying Bank No";

        // GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
        // GenJnlLine."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
        // GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
        // GenJnlLine."Shortcut Dimension 2 Code":=PayLine."Shortcut Dimension 2 Code";
        // GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
        // GenJnlLine.ValidateShortcutDimCode(3,PayLine."Shortcut Dimension 3 Code");
        // GenJnlLine.ValidateShortcutDimCode(4,PayLine."Shortcut Dimension 4 Code");

        GenJnlLine.Description := CopyStr(Rec.Payee, 1, 50);//COPYSTR('Pay To:' + Payments.Payee,1,50);
        GenJnlLine.Validate(GenJnlLine.Description);

        GenJnlLine."Bank Payment Type" := GenJnlLine."bank payment type"::"Computer Check";
        // GenJnlLine.Payee:=Payee;
        if GenJnlLine.Amount <> 0 then
            GenJnlLine.Insert;


        //
        GenJnlLine.Reset;
        GenJnlLine.SetRange(GenJnlLine."Journal Template Name", JTemplate);
        GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", JBatch);
        if GenJnlLine.Find('-') then begin
            AdjustGenJnl.Run(GenJnlLine);
            if Rec."Cheque Format" = Rec."cheque format"::"Kalamazoo Format" then begin
                Report.Run(70134841, false, false, GenJnlLine)
            end else begin
                // REPORT.RUN(70134836,FALSE,FALSE,GenJnlLine);
                PS.Reset;
                PS.SetFilter(No, Rec.No);
                if PSline.Find('-') then
                    Report.Run(50090, false, false, PS);

            end;
            //70134836
        end;
        //DocPrint.PrintCheck(GenJnlLine);
        //CODEUNIT.RUN(CODEUNIT::"Adjust Gen. Journal Balance",GenJnlLine);
    end;

    local procedure PrintNormal()
    begin

        PS.SetFilter(No, Rec.No);
        GenJnlLine.Reset;
        GenJnlLine.SetRange(GenJnlLine."Journal Template Name", JTemplate);
        GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", JBatch);

        if GenJnlLine.Find('+') then begin
            LineNo := GenJnlLine."Line No." + 1000;
        end
        else begin
            LineNo := 1000;
        end;


        LineNo := LineNo + 1000;
        GenJnlLine.Init;
        GenJnlLine."Journal Template Name" := JTemplate;
        GenJnlLine.Validate(GenJnlLine."Journal Template Name");
        GenJnlLine."Journal Batch Name" := JBatch;
        GenJnlLine.Validate(GenJnlLine."Journal Batch Name");
        GenJnlLine."Line No." := LineNo;
        GenJnlLine."Source Code" := 'PAYMENTJNL';
        GenJnlLine."Posting Date" := Rec."Cheque Date";

        GenJnlLine."Document Type" := GenJnlLine."document type"::Payment;
        GenJnlLine."Document No." := Rec.No;
        GenJnlLine."External Document No." := Rec."Cheque No";

        GenJnlLine."Account Type" := GenJnlLine."account type"::"Bank Account";
        GenJnlLine."Account No." := Rec."Paying Bank No";
        GenJnlLine.Validate(GenJnlLine."Account No.");

        // GenJnlLine."Currency Code":=Payments."Currency Code";
        // GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
        //CurrFactor
        //  GenJnlLine."Currency Factor":=Payments."Currency Factor";
        //  GenJnlLine.VALIDATE("Currency Factor");

        Rec.CalcFields("Total Amount");
        GenJnlLine.Amount := -(Rec."Total Amount");
        GenJnlLine.Validate(GenJnlLine.Amount);
        GenJnlLine."Bal. Account Type" := GenJnlLine."bal. account type"::"Bank Account";
        GenJnlLine."Bal. Account No." := '';
        // GenJnlLine."Recipient Bank Account":="Paying Bank No";

        // GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
        // GenJnlLine."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
        // GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
        // GenJnlLine."Shortcut Dimension 2 Code":=PayLine."Shortcut Dimension 2 Code";
        // GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
        // GenJnlLine.ValidateShortcutDimCode(3,PayLine."Shortcut Dimension 3 Code");
        // GenJnlLine.ValidateShortcutDimCode(4,PayLine."Shortcut Dimension 4 Code");

        GenJnlLine.Description := CopyStr(Rec.Payee, 1, 50);//COPYSTR('Pay To:' + Payments.Payee,1,50);
        GenJnlLine.Validate(GenJnlLine.Description);

        GenJnlLine."Bank Payment Type" := GenJnlLine."bank payment type"::"Computer Check";
        //GenJnlLine.Payee := Payee;
        if GenJnlLine.Amount <> 0 then
            GenJnlLine.Insert;

    end;

    local procedure PrintKalamzoo()
    begin
    end;

    procedure PostImprest()
    var
        Setup: Record "Cash Office Setup";
        Temp: Record "Cash Office User Template";
        ImpH: Record "Imprest Header";
    begin
        PSline.Reset;
        PSline.SetRange(No, Rec.No);
        PSline.SetRange("Document Type", PSline."document type"::Imprest);
        if PSline.Find('-') then begin
            repeat
                Rec.TestField("Cheque Date");
                Rec.TestField("Paying Bank No");
                Rec.TestField("Cheque No");

                ImpH.Get(PSline."Payment No");
                Setup.Get;
                Setup.TestField("Payment Split Account");

                //IF Posted=TRUE THEN ERROR('The Document is already Posted!');
                /*Check if the user has selcted all the relevant fields*/
                Temp.Get(UserId);
                JTemplate := Temp."Payment Journal Template";
                JBatch := Temp."Payment Journal Batch";

                if JTemplate = '' then Error('Please ensure that the Payment Template is setup in the cash management setup!!');
                if JBatch = '' then Error('Please ensure that the Payment Batch is setup in the cash management setup!!');

                if Temp.Get(UserId) then begin
                    GenJnlLine.Reset;
                    GenJnlLine.SetRange(GenJnlLine."Journal Template Name", JTemplate);
                    GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", JBatch);
                    GenJnlLine.DeleteAll;
                end;
                /*
                LineNo:=LineNo+1000;
                GenJnlLine.INIT;
                GenJnlLine."Journal Template Name":=JTemplate;
                GenJnlLine."Journal Batch Name":=JBatch;
                GenJnlLine."Line No.":=LineNo;
                GenJnlLine."Source Code":='PAYMENTJNL';
                GenJnlLine."Posting Date":="Cheque Date";
                GenJnlLine."Document Type":=GenJnlLine."Document Type"::Payment;
                GenJnlLine."Document No.":=PSline."Payment No";
                GenJnlLine."External Document No.":="Cheque No";
                GenJnlLine."Account Type":=GenJnlLine."Account Type"::"G/L Account";
                GenJnlLine."Account No.":=Setup."Payment Split Account";
                GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                GenJnlLine.Description:='Payment: '+No+':'+"Cheque No";

                GenJnlLine.Amount:=PSline."Cheque Amount";
                GenJnlLine.VALIDATE(GenJnlLine.Amount);
                GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::"Bank Account";
                GenJnlLine."Bal. Account No.":="Paying Bank No";
                GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                //Added for Currency Codes
                GenJnlLine."Currency Code":=ImpH."Currency Code";
                GenJnlLine.VALIDATE("Currency Code");
                GenJnlLine."Currency Factor":=ImpH."Currency Factor";
                GenJnlLine.VALIDATE("Currency Factor");
                {
                GenJnlLine."Currency Factor":=Payments."Currency Factor";
                GenJnlLine.VALIDATE("Currency Factor");
                }
                GenJnlLine."Shortcut Dimension 1 Code":=ImpH."Global Dimension 1 Code";
                GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                GenJnlLine."Shortcut Dimension 2 Code":=ImpH."Shortcut Dimension 2 Code";
                GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
                GenJnlLine.ValidateShortcutDimCode(3,ImpH."Shortcut Dimension 3 Code");
                GenJnlLine.ValidateShortcutDimCode(4,ImpH."Shortcut Dimension 4 Code");

                IF GenJnlLine.Amount<>0 THEN
                GenJnlLine.INSERT;

                //IF GLEntry.FINDLAST THEN LastEntry:=GLEntry."Entry No.";


                GenJnlLine.RESET;
                GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name",JTemplate);
                GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name",JBatch);
                CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post",GenJnlLine);
                */
                if ImpH.Posted = false then begin

                    if Temp.Get(UserId) then begin
                        GenJnlLine.Reset;
                        GenJnlLine.SetRange(GenJnlLine."Journal Template Name", JTemplate);
                        GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", JBatch);
                        GenJnlLine.DeleteAll;
                    end;

                    LineNo := LineNo + 1000;
                    GenJnlLine.Init;
                    GenJnlLine."Journal Template Name" := JTemplate;
                    GenJnlLine."Journal Batch Name" := JBatch;
                    GenJnlLine."Line No." := LineNo;
                    GenJnlLine."Source Code" := 'PAYMENTJNL';
                    GenJnlLine."Posting Date" := Today;
                    GenJnlLine."Document Type" := GenJnlLine."document type"::Invoice;
                    GenJnlLine."Document No." := ImpH."No.";
                    //GenJnlLine."External Document No.":="Cheque No.";
                    GenJnlLine."Account Type" := GenJnlLine."account type"::Customer;
                    GenJnlLine."Account No." := ImpH."Account No.";
                    GenJnlLine.Validate(GenJnlLine."Account No.");
                    GenJnlLine.Description := 'Imprest: ' + ImpH."Account No." + ':' + ImpH.Payee;
                    ImpH.CalcFields("Total Net Amount");
                    GenJnlLine.Amount := ImpH."Total Net Amount";
                    GenJnlLine.Validate(GenJnlLine.Amount);
                    GenJnlLine."Bal. Account Type" := GenJnlLine."bal. account type"::"G/L Account";
                    GenJnlLine."Bal. Account No." := Setup."Payment Split Account";
                    GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
                    //Added for Currency Codes
                    GenJnlLine."Currency Code" := ImpH."Currency Code";
                    GenJnlLine.Validate("Currency Code");
                    GenJnlLine."Currency Factor" := ImpH."Currency Factor";
                    GenJnlLine.Validate("Currency Factor");
                    /*
                    GenJnlLine."Currency Factor":=Payments."Currency Factor";
                    GenJnlLine.VALIDATE("Currency Factor");
                    */
                    GenJnlLine."Shortcut Dimension 1 Code" := ImpH."Global Dimension 1 Code";
                    GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                    GenJnlLine."Shortcut Dimension 2 Code" := ImpH."Shortcut Dimension 2 Code";
                    GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
                    GenJnlLine.ValidateShortcutDimCode(3, ImpH."Shortcut Dimension 3 Code");
                    GenJnlLine.ValidateShortcutDimCode(4, ImpH."Shortcut Dimension 4 Code");

                    if GenJnlLine.Amount <> 0 then
                        GenJnlLine.Insert;

                    GenJnlLine.Reset;
                    GenJnlLine.SetRange(GenJnlLine."Journal Template Name", JTemplate);
                    GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", JBatch);
                    Codeunit.Run(Codeunit::"Gen. Jnl.-Post Bill", GenJnlLine);

                    if IsPosted.PostedSuccessfully(ImpH."No.") then begin
                        ImpH.Posted := true;
                        ImpH."Posted By" := UserId;
                        ImpH."Date Posted" := Today;
                        ImpH.Modify;
                    end;
                end;

                ImpH.CalcFields("Paid Amount");
                ImpH.CalcFields("Total Net Amount");
                if ImpH."Total Net Amount" = ImpH."Paid Amount" then begin
                    ImpH."Fully Paid" := true;
                    ImpH.Modify;
                end;
            until PSline.Next = 0;
        end;

    end;

    procedure PostItemCash()
    var
        Setup: Record "Cash Office Setup";
        Temp: Record "Cash Office User Template";
        ImpH: Record "Imprest Header";
    begin
        PSline.Reset;
        PSline.SetRange(No, Rec.No);
        PSline.SetRange("Document Type", PSline."document type"::"Item Cash");
        if PSline.Find('-') then begin
            repeat
                Rec.TestField("Cheque Date");
                Rec.TestField("Paying Bank No");
                Rec.TestField("Cheque No");

                ImpH.Get(PSline."Payment No");
                Setup.Get;
                Setup.TestField("Payment Split Account");

                //IF Posted=TRUE THEN ERROR('The Document is already Posted!');
                /*Check if the user has selcted all the relevant fields*/
                Temp.Get(UserId);
                JTemplate := Temp."Payment Journal Template";
                JBatch := Temp."Payment Journal Batch";

                if JTemplate = '' then Error('Please ensure that the Payment Template is setup in the cash management setup!!');
                if JBatch = '' then Error('Please ensure that the Payment Batch is setup in the cash management setup!!');

                if Temp.Get(UserId) then begin
                    GenJnlLine.Reset;
                    GenJnlLine.SetRange(GenJnlLine."Journal Template Name", JTemplate);
                    GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", JBatch);
                    GenJnlLine.DeleteAll;
                end;
                /*
                LineNo:=LineNo+1000;
                GenJnlLine.INIT;
                GenJnlLine."Journal Template Name":=JTemplate;
                GenJnlLine."Journal Batch Name":=JBatch;
                GenJnlLine."Line No.":=LineNo;
                GenJnlLine."Source Code":='PAYMENTJNL';
                GenJnlLine."Posting Date":="Cheque Date";
                GenJnlLine."Document Type":=GenJnlLine."Document Type"::Payment;
                GenJnlLine."Document No.":=PSline."Payment No";
                GenJnlLine."External Document No.":="Cheque No";
                GenJnlLine."Account Type":=GenJnlLine."Account Type"::"G/L Account";
                GenJnlLine."Account No.":=Setup."Payment Split Account";
                GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                GenJnlLine.Description:='Payment: '+No+':'+"Cheque No";

                GenJnlLine.Amount:=PSline."Cheque Amount";
                GenJnlLine.VALIDATE(GenJnlLine.Amount);
                GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::"Bank Account";
                GenJnlLine."Bal. Account No.":="Paying Bank No";
                GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                //Added for Currency Codes
                GenJnlLine."Currency Code":=ImpH."Currency Code";
                GenJnlLine.VALIDATE("Currency Code");
                GenJnlLine."Currency Factor":=ImpH."Currency Factor";
                GenJnlLine.VALIDATE("Currency Factor");
                {
                GenJnlLine."Currency Factor":=Payments."Currency Factor";
                GenJnlLine.VALIDATE("Currency Factor");
                }
                GenJnlLine."Shortcut Dimension 1 Code":=ImpH."Global Dimension 1 Code";
                GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                GenJnlLine."Shortcut Dimension 2 Code":=ImpH."Shortcut Dimension 2 Code";
                GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
                GenJnlLine.ValidateShortcutDimCode(3,ImpH."Shortcut Dimension 3 Code");
                GenJnlLine.ValidateShortcutDimCode(4,ImpH."Shortcut Dimension 4 Code");

                IF GenJnlLine.Amount<>0 THEN
                GenJnlLine.INSERT;

                //IF GLEntry.FINDLAST THEN LastEntry:=GLEntry."Entry No.";


                GenJnlLine.RESET;
                GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name",JTemplate);
                GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name",JBatch);
                CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post",GenJnlLine);
                */
                if ImpH.Posted = false then begin

                    if Temp.Get(UserId) then begin
                        GenJnlLine.Reset;
                        GenJnlLine.SetRange(GenJnlLine."Journal Template Name", JTemplate);
                        GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", JBatch);
                        GenJnlLine.DeleteAll;
                    end;

                    LineNo := LineNo + 1000;
                    GenJnlLine.Init;
                    GenJnlLine."Journal Template Name" := JTemplate;
                    GenJnlLine."Journal Batch Name" := JBatch;
                    GenJnlLine."Line No." := LineNo;
                    GenJnlLine."Source Code" := 'PAYMENTJNL';
                    GenJnlLine."Posting Date" := Today;
                    GenJnlLine."Document Type" := GenJnlLine."document type"::Invoice;
                    GenJnlLine."Document No." := ImpH."No.";
                    //GenJnlLine."External Document No.":="Cheque No.";
                    GenJnlLine."Account Type" := GenJnlLine."account type"::Customer;
                    GenJnlLine."Account No." := ImpH."Account No.";
                    GenJnlLine.Validate(GenJnlLine."Account No.");
                    GenJnlLine.Description := 'Imprest: ' + ImpH."Account No." + ':' + ImpH.Payee;
                    ImpH.CalcFields("Total Net Amount");
                    GenJnlLine.Amount := ImpH."Total Net Amount";
                    GenJnlLine.Validate(GenJnlLine.Amount);
                    GenJnlLine."Bal. Account Type" := GenJnlLine."bal. account type"::"G/L Account";
                    GenJnlLine."Bal. Account No." := Setup."Payment Split Account";
                    GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
                    //Added for Currency Codes
                    GenJnlLine."Currency Code" := ImpH."Currency Code";
                    GenJnlLine.Validate("Currency Code");
                    GenJnlLine."Currency Factor" := ImpH."Currency Factor";
                    GenJnlLine.Validate("Currency Factor");
                    /*
                    GenJnlLine."Currency Factor":=Payments."Currency Factor";
                    GenJnlLine.VALIDATE("Currency Factor");
                    */
                    GenJnlLine."Shortcut Dimension 1 Code" := ImpH."Global Dimension 1 Code";
                    GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                    GenJnlLine."Shortcut Dimension 2 Code" := ImpH."Shortcut Dimension 2 Code";
                    GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
                    GenJnlLine.ValidateShortcutDimCode(3, ImpH."Shortcut Dimension 3 Code");
                    GenJnlLine.ValidateShortcutDimCode(4, ImpH."Shortcut Dimension 4 Code");

                    if GenJnlLine.Amount <> 0 then
                        GenJnlLine.Insert;

                    GenJnlLine.Reset;
                    GenJnlLine.SetRange(GenJnlLine."Journal Template Name", JTemplate);
                    GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", JBatch);
                    Codeunit.Run(Codeunit::"Gen. Jnl.-Post Bill", GenJnlLine);

                    if IsPosted.PostedSuccessfully(ImpH."No.") then begin
                        ImpH.Posted := true;
                        ImpH."Posted By" := UserId;
                        ImpH."Date Posted" := Today;
                        ImpH.Modify;
                    end;
                end;

                ImpH.CalcFields("Paid Amount");
                ImpH.CalcFields("Total Net Amount");
                if ImpH."Total Net Amount" = ImpH."Paid Amount" then begin
                    ImpH."Fully Paid" := true;
                    ImpH.Modify;
                end;
            until PSline.Next = 0;
        end;

    end;

    local procedure PostPV()
    var
        Setup: Record "Cash Office Setup";
        Temp: Record "Cash Office User Template";
        PayH: Record "Payments Header";
    begin
        Temp.Get(UserId);
        Setup.Get;
        Setup.TestField("Payment Split Account");
        JTemplate := Temp."Payment Journal Template";
        JBatch := Temp."Payment Journal Batch";

        if JTemplate = '' then Error('Please ensure that the Payment Template is setup in the cash management setup!!');
        if JBatch = '' then Error('Please ensure that the Payment Batch is setup in the cash management setup!!');

        PSline.Reset;
        PSline.SetRange(No, Rec.No);
        PSline.SetRange("Document Type", PSline."document type"::Payment);
        if PSline.Find('-') then begin
            repeat

                PayH.Get(PSline."Payment No");

                if Temp.Get(UserId) then begin
                    GenJnlLine.Reset;
                    GenJnlLine.SetRange(GenJnlLine."Journal Template Name", JTemplate);
                    GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", JBatch);
                    GenJnlLine.DeleteAll;
                end;

                GenJnlLine.Reset;
                GenJnlLine.SetRange(GenJnlLine."Journal Template Name", JTemplate);
                GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", JBatch);

                CheckPVRequiredItems(PayH);
                PostPaymentDocument(PayH);

            until PSline.Next = 0;
        end;
    end;

    procedure CheckPVRequiredItems(PV: Record "Payments Header")
    begin


        //PV.TESTFIELD(Status,Status::Approved);
        //PV.TESTFIELD("Paying Bank Account");
        //PV.TESTFIELD("Pay Mode");
        //PV.TESTFIELD("Payment Release Date");
        //Confirm whether Bank Has the Cash
        /*IF "Pay Mode"="Pay Mode"::Cash THEN
         CheckBudgetAvail.CheckFundsAvailability(Rec);*/

        //Confirm Payment Release Date is today);
        /*IF "Pay Mode"="Pay Mode"::Cash THEN
          TESTFIELD("Payment Release Date",WORKDATE);*/

        /*Check if the user has selected all the relevant fields*/
        Temp.Get(UserId);

        JTemplate := Temp."Payment Journal Template";
        JBatch := Temp."Payment Journal Batch";

        if JTemplate = '' then begin
            Error('Ensure the PV Template is set up in Cash Office Setup');
        end;
        if JBatch = '' then begin
            Error('Ensure the PV Batch is set up in the Cash Office Setup')
        end;

    end;

    procedure PostPaymentDocument(PV: Record "Payments Header")
    var
        PayLine: Record "Payment Line";
        CheckBudgetAvail: Codeunit "Budgetary Control";
        Doc_Type: Option LPO,Requisition,Imprest,"Payment Voucher";
    begin
        // DELETE ANY LINE ITEM THAT MAY BE PRESENT
        GenJnlLine.Reset;
        GenJnlLine.SetRange(GenJnlLine."Journal Template Name", JTemplate);
        GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", JBatch);
        if GenJnlLine.Find('+') then begin
            LineNo := GenJnlLine."Line No." + 1000;
        end
        else begin
            LineNo := 1000;
        end;
        GenJnlLine.DeleteAll;
        GenJnlLine.Reset;

        if PV.Posted = false then begin
            PayLine.Reset;
            PayLine.SetRange(PayLine.No, PV."No.");
            if PayLine.Find('-') then begin
                repeat
                    PostPVHeader(PV);
                until PayLine.Next = 0;
            end;
        end;
        //Post:=FALSE;
        if IsPosted.PostedSuccessfully(PV."No.") then begin
            //IF Post THEN  BEGIN
            PV.Posted := true;
            PV.Status := PV.Status::Posted;
            PV."Posted By" := UserId;
            PV."Date Posted" := Today;
            PV."Time Posted" := Time;
            if PV."Cheque Type" = PV."cheque type"::"Computer Check" then
                PV."Cheque Printed" := true;
            PV.Modify;

            //Post Reversal Entries for Commitments
            Doc_Type := Doc_type::"Payment Voucher";
            CheckBudgetAvail.ReverseEntries(Doc_Type, PV."No.");

        end;
        //END;
    end;

    procedure PostPVHeader(var PV: Record "Payments Header")
    var
        Setup: Record "Cash Office Setup";
    begin


        Setup.Get;
        Setup.TestField("Payment Split Account");

        GenJnlLine.Reset;
        GenJnlLine.SetRange(GenJnlLine."Journal Template Name", JTemplate);
        GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", JBatch);

        if GenJnlLine.Find('+') then begin
            LineNo := GenJnlLine."Line No." + 1000;
        end
        else begin
            LineNo := 1000;
        end;


        LineNo := LineNo + 1000;
        GenJnlLine.Init;
        GenJnlLine."Journal Template Name" := JTemplate;
        GenJnlLine.Validate(GenJnlLine."Journal Template Name");
        GenJnlLine."Journal Batch Name" := JBatch;
        GenJnlLine.Validate(GenJnlLine."Journal Batch Name");
        GenJnlLine."Line No." := LineNo;
        GenJnlLine."Source Code" := 'PAYMENTJNL';
        GenJnlLine."Posting Date" := Rec."Cheque Date";
        //IF CustomerPayLinesExist THEN
        // GenJnlLine."Document Type":=GenJnlLine."Document Type"::" "
        //ELSE
        GenJnlLine."Document Type" := GenJnlLine."document type"::Payment;
        GenJnlLine."Document No." := PV."No.";
        GenJnlLine."External Document No." := Rec."Cheque No";

        GenJnlLine."Account Type" := GenJnlLine."account type"::"G/L Account";
        GenJnlLine."Account No." := Setup."Payment Split Account";
        GenJnlLine.Validate(GenJnlLine."Account No.");

        GenJnlLine."Currency Code" := PV."Currency Code";
        GenJnlLine.Validate(GenJnlLine."Currency Code");
        //CurrFactor
        GenJnlLine."Currency Factor" := PV."Currency Factor";
        GenJnlLine.Validate("Currency Factor");

        PV.CalcFields("Total Net Amount", "Total VAT Amount");
        GenJnlLine.Amount := -(PV."Total Net Amount");
        GenJnlLine.Validate(GenJnlLine.Amount);
        GenJnlLine."Bal. Account Type" := GenJnlLine."bal. account type"::"G/L Account";
        GenJnlLine."Bal. Account No." := '';

        GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
        GenJnlLine."Shortcut Dimension 1 Code" := PV."Global Dimension 1 Code";
        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
        GenJnlLine."Shortcut Dimension 2 Code" := PV."Shortcut Dimension 2 Code";
        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
        GenJnlLine.ValidateShortcutDimCode(3, PV."Shortcut Dimension 3 Code");
        GenJnlLine.ValidateShortcutDimCode(4, PV."Shortcut Dimension 4 Code");

        GenJnlLine.Description := CopyStr(PV."Payment Narration", 1, 50);//COPYSTR('Pay To:' + Payments.Payee,1,50);
        GenJnlLine.Validate(GenJnlLine.Description);

        // IF "Pay Mode"<>"Pay Mode"::Cheque THEN  BEGIN
        // GenJnlLine."Bank Payment Type":=GenJnlLine."Bank Payment Type"::" "
        // END ELSE BEGIN
        // IF "Cheque Type"="Cheque Type"::"Computer Check" THEN
        // GenJnlLine."Bank Payment Type":=GenJnlLine."Bank Payment Type"::"Computer Check"
        // ELSE
        //   GenJnlLine."Bank Payment Type":=GenJnlLine."Bank Payment Type"::" "
        //
        // END;
        if GenJnlLine.Amount <> 0 then
            GenJnlLine.Insert;

        //Post Other Payment Journal Entries
        PostPVs(PV);
    end;

    procedure PostPVs(var Payments: Record "Payments Header")
    var
        PayLine: Record "Payment Line";
        CashierLinks: Record "Cashier Link";
        TarriffCodes: Record "Tariff Codes";
    begin


        PayLine.Reset;
        PayLine.SetRange(PayLine.No, Payments."No.");
        if PayLine.Find('-') then begin

            repeat
                // strText:=GetAppliedEntries(PayLine."Line No.");
                Payments.TestField(Payments.Payee);
                PayLine.TestField(PayLine.Amount);
                //IF PayLine."PAYE Amount">0 THEN PayLine.TESTFIELD(PayLine."KRA Pin No.");
                // PayLine.TESTFIELD(PayLine."Global Dimension 1 Code");

                //BANK
                if PayLine."Pay Mode" = PayLine."pay mode"::Cash then begin
                    CashierLinks.Reset;
                    CashierLinks.SetRange(CashierLinks.UserID, UserId);
                end;

                //CHEQUE
                LineNo := LineNo + 1000;
                GenJnlLine.Init;
                GenJnlLine."Journal Template Name" := JTemplate;
                GenJnlLine.Validate(GenJnlLine."Journal Template Name");
                GenJnlLine."Journal Batch Name" := JBatch;
                GenJnlLine.Validate(GenJnlLine."Journal Batch Name");
                GenJnlLine."Source Code" := 'PAYMENTJNL';
                GenJnlLine."Line No." := LineNo;
                GenJnlLine."Posting Date" := Rec."Cheque Date";
                GenJnlLine."Document No." := PayLine.No;
                // IF CustomerPayLinesExist THEN
                // GenJnlLine."Document Type":=GenJnlLine."Document Type"::" "
                //ELSE
                GenJnlLine."Document Type" := GenJnlLine."document type"::Payment;
                GenJnlLine."Account Type" := PayLine."Account Type";
                GenJnlLine."Account No." := PayLine."Account No.";
                GenJnlLine.Validate(GenJnlLine."Account No.");
                GenJnlLine."External Document No." := Rec."Cheque No";
                GenJnlLine.Description := CopyStr(Payments."Payment Narration", 1, 50);
                //    GenJnlLine.Description:=COPYSTR(PayLine."Transaction Name" + ':' + Payment.Payee,1,50);
                GenJnlLine."Currency Code" := Payments."Currency Code";
                GenJnlLine.Validate("Currency Code");
                GenJnlLine."Currency Factor" := Payments."Currency Factor";
                GenJnlLine.Validate("Currency Factor");

                if PayLine."VAT Code" = '' then begin
                    GenJnlLine.Amount := PayLine."Net Amount";//..
                end
                else
                    if PayLine."VAT Withheld Code" = '' then begin
                        GenJnlLine.Amount := PayLine."Net Amount";
                    end
                    else begin
                        GenJnlLine.Amount := PayLine."Net Amount";
                    end;

                GenJnlLine.Validate(GenJnlLine.Amount);
                GenJnlLine."VAT Prod. Posting Group" := PayLine."VAT Prod. Posting Group";
                GenJnlLine.Validate(GenJnlLine."VAT Prod. Posting Group");
                //GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                GenJnlLine."Shortcut Dimension 1 Code" := PayLine."Global Dimension 1 Code";
                GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                GenJnlLine."Shortcut Dimension 2 Code" := PayLine."Shortcut Dimension 2 Code";
                GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
                GenJnlLine.ValidateShortcutDimCode(3, PayLine."Shortcut Dimension 3 Code");
                GenJnlLine.ValidateShortcutDimCode(4, PayLine."Shortcut Dimension 4 Code");
                GenJnlLine."Applies-to Doc. Type" := GenJnlLine."applies-to doc. type"::Invoice;
                GenJnlLine."Applies-to Doc. No." := PayLine."Applies-to Doc. No.";
                GenJnlLine.Validate(GenJnlLine."Applies-to Doc. No.");
                GenJnlLine."Applies-to ID" := PayLine."Applies-to ID";

                if GenJnlLine.Amount <> 0 then GenJnlLine.Insert;

                //Post RETENTION to GL[RETENTION GL]
                if PayLine."Retention Code" <> '' then begin

                    TarriffCodes.Reset;
                    TarriffCodes.SetRange(TarriffCodes.Code, PayLine."Retention Code");
                    if TarriffCodes.Find('-') then begin
                        TarriffCodes.TestField(TarriffCodes."G/L Account");
                        LineNo := LineNo + 1000;
                        GenJnlLine.Init;
                        GenJnlLine."Journal Template Name" := JTemplate;
                        GenJnlLine.Validate(GenJnlLine."Journal Template Name");
                        GenJnlLine."Journal Batch Name" := JBatch;
                        GenJnlLine.Validate(GenJnlLine."Journal Batch Name");
                        GenJnlLine."Source Code" := 'PAYMENTJNL';
                        GenJnlLine."Line No." := LineNo;
                        GenJnlLine."Posting Date" := Rec."Cheque Date";
                        // IF CustomerPayLinesExist THEN
                        //  GenJnlLine."Document Type":=GenJnlLine."Document Type"::" "
                        // ELSE
                        GenJnlLine."Document Type" := GenJnlLine."document type"::Payment;
                        GenJnlLine."Document No." := PayLine.No;
                        GenJnlLine."External Document No." := Rec."Cheque No";
                        GenJnlLine."Account Type" := GenJnlLine."account type"::"G/L Account";
                        GenJnlLine."Account No." := TarriffCodes."G/L Account";
                        GenJnlLine.Validate(GenJnlLine."Account No.");
                        GenJnlLine."Currency Code" := Payments."Currency Code";
                        GenJnlLine.Validate(GenJnlLine."Currency Code");
                        //CurrFactor
                        GenJnlLine."Currency Factor" := Payments."Currency Factor";
                        GenJnlLine.Validate("Currency Factor");

                        GenJnlLine."Gen. Posting Type" := GenJnlLine."gen. posting type"::" ";
                        GenJnlLine.Validate(GenJnlLine."Gen. Posting Type");
                        GenJnlLine."Gen. Bus. Posting Group" := '';
                        GenJnlLine.Validate(GenJnlLine."Gen. Bus. Posting Group");
                        GenJnlLine."Gen. Prod. Posting Group" := '';
                        GenJnlLine.Validate(GenJnlLine."Gen. Prod. Posting Group");
                        GenJnlLine."VAT Bus. Posting Group" := '';
                        GenJnlLine.Validate(GenJnlLine."VAT Bus. Posting Group");
                        GenJnlLine."VAT Prod. Posting Group" := '';
                        GenJnlLine.Validate(GenJnlLine."VAT Prod. Posting Group");
                        GenJnlLine.Amount := -PayLine."Retention  Amount";
                        GenJnlLine.Validate(GenJnlLine.Amount);
                        GenJnlLine."Bal. Account Type" := GenJnlLine."bal. account type"::"G/L Account";
                        GenJnlLine."Bal. Account No." := '';
                        GenJnlLine.Description := CopyStr('RETENTION:' + Format(PayLine."Account Type") + '::' + Format(PayLine."Account Name"), 1, 50);
                        GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
                        GenJnlLine."Shortcut Dimension 1 Code" := PayLine."Global Dimension 1 Code";
                        GenJnlLine."Shortcut Dimension 2 Code" := PayLine."Shortcut Dimension 2 Code";
                        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
                        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                        GenJnlLine.ValidateShortcutDimCode(3, PayLine."Shortcut Dimension 3 Code");
                        GenJnlLine.ValidateShortcutDimCode(4, PayLine."Shortcut Dimension 4 Code");

                        if GenJnlLine.Amount <> 0 then GenJnlLine.Insert;
                    end;

                    // Retention to balancing
                    LineNo := LineNo + 1000;
                    GenJnlLine.Init;
                    GenJnlLine."Journal Template Name" := JTemplate;
                    GenJnlLine.Validate(GenJnlLine."Journal Template Name");
                    GenJnlLine."Journal Batch Name" := JBatch;
                    GenJnlLine.Validate(GenJnlLine."Journal Batch Name");
                    GenJnlLine."Source Code" := 'PAYMENTJNL';
                    GenJnlLine."Line No." := LineNo;
                    GenJnlLine."Posting Date" := Rec."Cheque Date";
                    if CustomerPayLinesExist then
                        GenJnlLine."Document Type" := GenJnlLine."document type"::" "
                    else
                        GenJnlLine."Document Type" := GenJnlLine."document type"::Payment;
                    GenJnlLine."Document No." := PayLine.No;
                    GenJnlLine."External Document No." := Rec."Cheque No";
                    GenJnlLine."Account Type" := PayLine."Account Type";
                    GenJnlLine."Account No." := PayLine."Account No.";
                    GenJnlLine.Validate(GenJnlLine."Account No.");
                    GenJnlLine."Currency Code" := Payments."Currency Code";
                    GenJnlLine.Validate(GenJnlLine."Currency Code");
                    //CurrFactor
                    GenJnlLine."Currency Factor" := Payments."Currency Factor";
                    GenJnlLine.Validate("Currency Factor");

                    GenJnlLine."Gen. Posting Type" := GenJnlLine."gen. posting type"::" ";
                    GenJnlLine.Validate(GenJnlLine."Gen. Posting Type");
                    GenJnlLine."Gen. Bus. Posting Group" := '';
                    GenJnlLine.Validate(GenJnlLine."Gen. Bus. Posting Group");
                    GenJnlLine."Gen. Prod. Posting Group" := '';
                    GenJnlLine.Validate(GenJnlLine."Gen. Prod. Posting Group");
                    GenJnlLine."VAT Bus. Posting Group" := '';
                    GenJnlLine.Validate(GenJnlLine."VAT Bus. Posting Group");
                    GenJnlLine."VAT Prod. Posting Group" := '';
                    GenJnlLine.Validate(GenJnlLine."VAT Prod. Posting Group");
                    GenJnlLine.Amount := PayLine."Retention  Amount";
                    GenJnlLine.Validate(GenJnlLine.Amount);
                    GenJnlLine."Bal. Account Type" := GenJnlLine."bal. account type"::"G/L Account";
                    GenJnlLine."Bal. Account No." := '';
                    GenJnlLine.Description := CopyStr('RETENTION:' + Format(PayLine."Account Type") + '::' + Format(PayLine."Account Name"), 1, 50);
                    GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
                    GenJnlLine."Shortcut Dimension 1 Code" := PayLine."Global Dimension 1 Code";
                    GenJnlLine."Shortcut Dimension 2 Code" := PayLine."Shortcut Dimension 2 Code";
                    GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
                    GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                    GenJnlLine.ValidateShortcutDimCode(3, PayLine."Shortcut Dimension 3 Code");
                    GenJnlLine.ValidateShortcutDimCode(4, PayLine."Shortcut Dimension 4 Code");

                    if GenJnlLine.Amount <> 0 then GenJnlLine.Insert;


                end;


                ///////////////Post VAT WITHHELD////////////////////////////////////////////////////

                TarriffCodes.Reset;
                TarriffCodes.SetRange(TarriffCodes.Code, PayLine."VAT Code");
                if TarriffCodes.Find('-') then begin
                    TarriffCodes.TestField(TarriffCodes."G/L Account");
                    LineNo := LineNo + 1000;
                    GenJnlLine.Init;
                    GenJnlLine."Journal Template Name" := JTemplate;
                    GenJnlLine.Validate(GenJnlLine."Journal Template Name");
                    GenJnlLine."Journal Batch Name" := JBatch;
                    GenJnlLine.Validate(GenJnlLine."Journal Batch Name");
                    GenJnlLine."Source Code" := 'PAYMENTJNL';
                    GenJnlLine."Line No." := LineNo;
                    GenJnlLine."Posting Date" := Rec."Cheque Date";
                    GenJnlLine."Document Type" := GenJnlLine."document type"::Payment;
                    GenJnlLine."Document No." := PayLine.No;
                    GenJnlLine."External Document No." := Rec."Cheque No";
                    GenJnlLine."Account Type" := GenJnlLine."account type"::"G/L Account";
                    GenJnlLine."Account No." := TarriffCodes."G/L Account";
                    GenJnlLine.Validate(GenJnlLine."Account No.");
                    GenJnlLine."Currency Code" := Payments."Currency Code";
                    GenJnlLine.Validate(GenJnlLine."Currency Code");
                    GenJnlLine."Gen. Posting Type" := GenJnlLine."gen. posting type"::" ";
                    GenJnlLine.Validate(GenJnlLine."Gen. Posting Type");
                    GenJnlLine."Gen. Bus. Posting Group" := '';
                    GenJnlLine.Validate(GenJnlLine."Gen. Bus. Posting Group");
                    GenJnlLine."Gen. Prod. Posting Group" := '';
                    GenJnlLine.Validate(GenJnlLine."Gen. Prod. Posting Group");
                    GenJnlLine."VAT Bus. Posting Group" := '';
                    GenJnlLine.Validate(GenJnlLine."VAT Bus. Posting Group");
                    GenJnlLine."VAT Prod. Posting Group" := '';
                    GenJnlLine.Validate(GenJnlLine."VAT Prod. Posting Group");
                    GenJnlLine.Amount := -PayLine."VAT Withheld Amount";
                    GenJnlLine.Validate(GenJnlLine.Amount);
                    GenJnlLine."Bal. Account Type" := GenJnlLine."bal. account type"::"G/L Account";
                    GenJnlLine."Bal. Account No." := '';
                    GenJnlLine.Description := CopyStr('VAT WITHHELD:' + Format(PayLine."Account Type") + '::' + Format(PayLine."Account Name"), 1, 50);
                    GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
                    GenJnlLine."Shortcut Dimension 1 Code" := PayLine."Global Dimension 1 Code";
                    GenJnlLine."Shortcut Dimension 2 Code" := PayLine."Shortcut Dimension 2 Code";
                    GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
                    GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                    GenJnlLine.ValidateShortcutDimCode(3, PayLine."Shortcut Dimension 3 Code");
                    GenJnlLine.ValidateShortcutDimCode(4, PayLine."Shortcut Dimension 4 Code");

                    if GenJnlLine.Amount <> 0 then GenJnlLine.Insert;
                end;

                ////////////////////////////END VAT WITHHELD to GL//////////////////////////////////////////////
                TarriffCodes.Reset;
                TarriffCodes.SetRange(TarriffCodes.Code, PayLine."VAT Code");
                if TarriffCodes.Find('-') then begin
                    // TarriffCodes.TESTFIELD(TarriffCodes."G/L Account");
                    LineNo := LineNo + 1000;
                    GenJnlLine.Init;
                    GenJnlLine."Journal Template Name" := JTemplate;
                    GenJnlLine.Validate(GenJnlLine."Journal Template Name");
                    GenJnlLine."Journal Batch Name" := JBatch;
                    GenJnlLine.Validate(GenJnlLine."Journal Batch Name");
                    GenJnlLine."Source Code" := 'PAYMENTJNL';
                    GenJnlLine."Line No." := LineNo;
                    GenJnlLine."Posting Date" := Rec."Cheque Date";
                    GenJnlLine."Document Type" := GenJnlLine."document type"::Payment;
                    GenJnlLine."Document No." := PayLine.No;
                    GenJnlLine."External Document No." := Rec."Cheque No";
                    //GenJnlLine."Account Type":=GenJnlLine."Account Type"::"G/L Account";
                    //GenJnlLine."Bal. Account Type":=GenJnlLine."Account Type"::Vendor;
                    GenJnlLine."Account Type" := PayLine."Account Type";
                    GenJnlLine."Account No." := PayLine."Account No.";
                    GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
                    //GenJnlLine."Account No.":=TarriffCodes."G/L Account";
                    //GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                    GenJnlLine."Currency Code" := Payments."Currency Code";
                    GenJnlLine.Validate(GenJnlLine."Currency Code");
                    GenJnlLine."Gen. Posting Type" := GenJnlLine."gen. posting type"::" ";
                    GenJnlLine.Validate(GenJnlLine."Gen. Posting Type");
                    GenJnlLine."Gen. Bus. Posting Group" := '';
                    GenJnlLine.Validate(GenJnlLine."Gen. Bus. Posting Group");
                    GenJnlLine."Gen. Prod. Posting Group" := '';
                    GenJnlLine.Validate(GenJnlLine."Gen. Prod. Posting Group");
                    GenJnlLine."VAT Bus. Posting Group" := '';
                    GenJnlLine.Validate(GenJnlLine."VAT Bus. Posting Group");
                    GenJnlLine."VAT Prod. Posting Group" := '';
                    GenJnlLine.Validate(GenJnlLine."VAT Prod. Posting Group");
                    GenJnlLine.Amount := PayLine."VAT Withheld Amount";
                    GenJnlLine.Validate(GenJnlLine.Amount);
                    GenJnlLine."Bal. Account Type" := GenJnlLine."account type"::"G/L Account";
                    GenJnlLine."Bal. Account No." := '';
                    GenJnlLine.Description := CopyStr('VAT WITHHELD:' + Format(PayLine."Account Type") + '::' + Format(PayLine."Account Name"), 1, 50);
                    GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
                    GenJnlLine."Shortcut Dimension 1 Code" := PayLine."Global Dimension 1 Code";
                    GenJnlLine."Shortcut Dimension 2 Code" := PayLine."Shortcut Dimension 2 Code";
                    GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
                    GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                    GenJnlLine.ValidateShortcutDimCode(3, PayLine."Shortcut Dimension 3 Code");
                    GenJnlLine.ValidateShortcutDimCode(4, PayLine."Shortcut Dimension 4 Code");

                    if GenJnlLine.Amount <> 0 then GenJnlLine.Insert;
                end;

                ////////////////////END BALANCING VAT WITHHELD/////////////////////////////////////////////////////////////


                //POST W/TAX to Respective W/TAX GL Account
                TarriffCodes.Reset;
                TarriffCodes.SetRange(TarriffCodes.Code, PayLine."Withholding Tax Code");
                if TarriffCodes.Find('-') then begin
                    TarriffCodes.TestField(TarriffCodes."G/L Account");
                    LineNo := LineNo + 1000;
                    GenJnlLine.Init;
                    GenJnlLine."Journal Template Name" := JTemplate;
                    GenJnlLine.Validate(GenJnlLine."Journal Template Name");
                    GenJnlLine."Journal Batch Name" := JBatch;
                    GenJnlLine.Validate(GenJnlLine."Journal Batch Name");
                    GenJnlLine."Source Code" := 'PAYMENTJNL';
                    GenJnlLine."Line No." := LineNo;
                    GenJnlLine."Posting Date" := Rec."Cheque Date";
                    if CustomerPayLinesExist then
                        GenJnlLine."Document Type" := GenJnlLine."document type"::" "
                    else
                        GenJnlLine."Document Type" := GenJnlLine."document type"::Payment;
                    GenJnlLine."Document No." := PayLine.No;
                    GenJnlLine."External Document No." := Rec."Cheque No";
                    GenJnlLine."Account Type" := GenJnlLine."account type"::"G/L Account";
                    GenJnlLine."Account No." := TarriffCodes."G/L Account";
                    GenJnlLine.Validate(GenJnlLine."Account No.");
                    GenJnlLine."Currency Code" := Payments."Currency Code";
                    GenJnlLine.Validate(GenJnlLine."Currency Code");
                    //CurrFactor
                    GenJnlLine."Currency Factor" := Payments."Currency Factor";
                    GenJnlLine.Validate("Currency Factor");

                    GenJnlLine."Gen. Posting Type" := GenJnlLine."gen. posting type"::" ";
                    GenJnlLine.Validate(GenJnlLine."Gen. Posting Type");
                    GenJnlLine."Gen. Bus. Posting Group" := '';
                    GenJnlLine.Validate(GenJnlLine."Gen. Bus. Posting Group");
                    GenJnlLine."Gen. Prod. Posting Group" := '';
                    GenJnlLine.Validate(GenJnlLine."Gen. Prod. Posting Group");
                    GenJnlLine."VAT Bus. Posting Group" := '';
                    GenJnlLine.Validate(GenJnlLine."VAT Bus. Posting Group");
                    GenJnlLine."VAT Prod. Posting Group" := '';
                    GenJnlLine.Validate(GenJnlLine."VAT Prod. Posting Group");
                    GenJnlLine.Amount := -PayLine."Withholding Tax Amount";
                    GenJnlLine.Validate(GenJnlLine.Amount);
                    GenJnlLine."Bal. Account Type" := PayLine."Account Type";
                    // GenJnlLine."Bal. Account No.":=PayLine."Account No.";
                    // GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                    GenJnlLine.Description := CopyStr('W/Tax:' + Format(PayLine."Account Name"), 1, 50);
                    GenJnlLine."Shortcut Dimension 1 Code" := PayLine."Global Dimension 1 Code";
                    GenJnlLine."Shortcut Dimension 2 Code" := PayLine."Shortcut Dimension 2 Code";
                    GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
                    GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                    GenJnlLine.ValidateShortcutDimCode(3, PayLine."Shortcut Dimension 3 Code");
                    GenJnlLine.ValidateShortcutDimCode(4, PayLine."Shortcut Dimension 4 Code");

                    if GenJnlLine.Amount <> 0 then
                        GenJnlLine.Insert;
                end;

                ///////////////Post P.A.Y.E////////////////////////////////////////////////////

                TarriffCodes.Reset;
                TarriffCodes.SetRange(TarriffCodes.Code, PayLine."PAYE Code");
                if TarriffCodes.Find('-') then begin
                    TarriffCodes.TestField(TarriffCodes."G/L Account");
                    LineNo := LineNo + 1000;
                    GenJnlLine.Init;
                    GenJnlLine."Journal Template Name" := JTemplate;
                    GenJnlLine.Validate(GenJnlLine."Journal Template Name");
                    GenJnlLine."Journal Batch Name" := JBatch;
                    GenJnlLine.Validate(GenJnlLine."Journal Batch Name");
                    GenJnlLine."Source Code" := 'PAYMENTJNL';
                    GenJnlLine."Line No." := LineNo;
                    GenJnlLine."Posting Date" := Rec."Cheque Date";
                    GenJnlLine."Document Type" := GenJnlLine."document type"::Payment;
                    GenJnlLine."Document No." := PayLine.No;
                    GenJnlLine."External Document No." := Rec."Cheque No";
                    GenJnlLine."Account Type" := GenJnlLine."account type"::"G/L Account";
                    GenJnlLine."Account No." := TarriffCodes."G/L Account";
                    GenJnlLine.Validate(GenJnlLine."Account No.");
                    GenJnlLine."Currency Code" := Payments."Currency Code";
                    GenJnlLine.Validate(GenJnlLine."Currency Code");
                    GenJnlLine."Gen. Posting Type" := GenJnlLine."gen. posting type"::" ";
                    GenJnlLine.Validate(GenJnlLine."Gen. Posting Type");
                    GenJnlLine."Gen. Bus. Posting Group" := '';
                    GenJnlLine.Validate(GenJnlLine."Gen. Bus. Posting Group");
                    GenJnlLine."Gen. Prod. Posting Group" := '';
                    GenJnlLine.Validate(GenJnlLine."Gen. Prod. Posting Group");
                    GenJnlLine."VAT Bus. Posting Group" := '';
                    GenJnlLine.Validate(GenJnlLine."VAT Bus. Posting Group");
                    GenJnlLine."VAT Prod. Posting Group" := '';
                    GenJnlLine.Validate(GenJnlLine."VAT Prod. Posting Group");
                    GenJnlLine.Amount := -PayLine."PAYE Amount";
                    GenJnlLine.Validate(GenJnlLine.Amount);
                    GenJnlLine."Bal. Account Type" := GenJnlLine."bal. account type"::"G/L Account";
                    GenJnlLine."Bal. Account No." := '';
                    GenJnlLine.Description := CopyStr('p.a.y.e:' + Format(PayLine."Account Type") + '::' + Format(PayLine."Account Name"), 1, 50);
                    GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
                    GenJnlLine."Shortcut Dimension 1 Code" := PayLine."Global Dimension 1 Code";
                    GenJnlLine."Shortcut Dimension 2 Code" := PayLine."Shortcut Dimension 2 Code";
                    GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
                    GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                    GenJnlLine.ValidateShortcutDimCode(3, PayLine."Shortcut Dimension 3 Code");
                    GenJnlLine.ValidateShortcutDimCode(4, PayLine."Shortcut Dimension 4 Code");

                    if GenJnlLine.Amount <> 0 then GenJnlLine.Insert;
                end;

                //Post VAT Balancing Entry Goes to Vendor
                LineNo := LineNo + 1000;
                GenJnlLine.Init;
                GenJnlLine."Journal Template Name" := JTemplate;
                GenJnlLine.Validate(GenJnlLine."Journal Template Name");
                GenJnlLine."Journal Batch Name" := JBatch;
                GenJnlLine.Validate(GenJnlLine."Journal Batch Name");
                GenJnlLine."Source Code" := 'PAYMENTJNL';
                GenJnlLine."Line No." := LineNo;
                GenJnlLine."Posting Date" := Rec."Cheque Date";
                if CustomerPayLinesExist then
                    GenJnlLine."Document Type" := GenJnlLine."document type"::" "
                else
                    GenJnlLine."Document Type" := GenJnlLine."document type"::Payment;
                GenJnlLine."Document No." := PayLine.No;
                GenJnlLine."External Document No." := Rec."Cheque No";
                GenJnlLine."Account Type" := PayLine."Account Type";
                GenJnlLine."Account No." := PayLine."Account No.";
                GenJnlLine.Validate(GenJnlLine."Account No.");
                GenJnlLine."Currency Code" := Payments."Currency Code";
                GenJnlLine.Validate(GenJnlLine."Currency Code");
                //CurrFactor
                GenJnlLine."Currency Factor" := Payments."Currency Factor";
                GenJnlLine.Validate("Currency Factor");

                if PayLine."VAT Code" = '' then begin
                    GenJnlLine.Amount := 0;
                end
                else begin
                    GenJnlLine.Amount := PayLine."VAT Amount";
                end;
                GenJnlLine.Validate(GenJnlLine.Amount);
                GenJnlLine."Bal. Account Type" := GenJnlLine."bal. account type"::"G/L Account";
                GenJnlLine."Bal. Account No." := '';
                GenJnlLine.Description := CopyStr('VAT:' + Format(PayLine."Account Type") + '::' + Format(PayLine."Account Name"), 1, 50);
                GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
                GenJnlLine."Shortcut Dimension 1 Code" := PayLine."Global Dimension 1 Code";
                GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                GenJnlLine."Shortcut Dimension 2 Code" := PayLine."Shortcut Dimension 2 Code";
                GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
                GenJnlLine.ValidateShortcutDimCode(3, PayLine."Shortcut Dimension 3 Code");
                GenJnlLine.ValidateShortcutDimCode(4, PayLine."Shortcut Dimension 4 Code");
                GenJnlLine."Applies-to Doc. Type" := GenJnlLine."applies-to doc. type"::Invoice;
                GenJnlLine."Applies-to Doc. No." := PayLine."Apply to";
                GenJnlLine.Validate(GenJnlLine."Applies-to Doc. No.");
                GenJnlLine."Applies-to ID" := PayLine."Apply to ID";
                if GenJnlLine.Amount <> 0 then
                    //  GenJnlLine.INSERT;

                    //Post W/TAX Balancing Entry Goes to Vendor
                    LineNo := LineNo + 1000;
                GenJnlLine.Init;
                GenJnlLine."Journal Template Name" := JTemplate;
                GenJnlLine.Validate(GenJnlLine."Journal Template Name");
                GenJnlLine."Journal Batch Name" := JBatch;
                GenJnlLine.Validate(GenJnlLine."Journal Batch Name");
                GenJnlLine."Source Code" := 'PAYMENTJNL';
                GenJnlLine."Line No." := LineNo;
                GenJnlLine."Posting Date" := Rec."Cheque Date";
                if CustomerPayLinesExist then
                    GenJnlLine."Document Type" := GenJnlLine."document type"::" "
                else
                    GenJnlLine."Document Type" := GenJnlLine."document type"::Payment;
                GenJnlLine."Document No." := PayLine.No;
                GenJnlLine."External Document No." := Rec."Cheque No";
                GenJnlLine."Account Type" := PayLine."Account Type";
                GenJnlLine."Account No." := PayLine."Account No.";
                GenJnlLine.Validate(GenJnlLine."Account No.");
                GenJnlLine."Currency Code" := Payments."Currency Code";
                GenJnlLine.Validate(GenJnlLine."Currency Code");
                //CurrFactor
                GenJnlLine."Currency Factor" := Payments."Currency Factor";
                GenJnlLine.Validate("Currency Factor");

                GenJnlLine."Gen. Posting Type" := GenJnlLine."gen. posting type"::" ";
                GenJnlLine.Validate(GenJnlLine."Gen. Posting Type");
                GenJnlLine."Gen. Bus. Posting Group" := '';
                GenJnlLine.Validate(GenJnlLine."Gen. Bus. Posting Group");
                GenJnlLine."Gen. Prod. Posting Group" := '';
                GenJnlLine.Validate(GenJnlLine."Gen. Prod. Posting Group");
                GenJnlLine."VAT Bus. Posting Group" := '';
                GenJnlLine.Validate(GenJnlLine."VAT Bus. Posting Group");
                GenJnlLine."VAT Prod. Posting Group" := '';
                GenJnlLine.Validate(GenJnlLine."VAT Prod. Posting Group");
                GenJnlLine.Amount := PayLine."Withholding Tax Amount";//1
                GenJnlLine.Validate(GenJnlLine.Amount);
                GenJnlLine."Bal. Account Type" := GenJnlLine."bal. account type"::"G/L Account";
                GenJnlLine."Bal. Account No." := '';
                GenJnlLine.Description := CopyStr('W/Tax:', 1, 50);
                GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
                GenJnlLine."Shortcut Dimension 1 Code" := PayLine."Global Dimension 1 Code";
                GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                GenJnlLine."Shortcut Dimension 2 Code" := PayLine."Shortcut Dimension 2 Code";
                GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
                GenJnlLine.ValidateShortcutDimCode(3, PayLine."Shortcut Dimension 3 Code");
                GenJnlLine.ValidateShortcutDimCode(4, PayLine."Shortcut Dimension 4 Code");
                GenJnlLine."Applies-to Doc. Type" := GenJnlLine."applies-to doc. type"::Invoice;
                GenJnlLine."Applies-to Doc. No." := PayLine."Apply to";
                GenJnlLine.Validate(GenJnlLine."Applies-to Doc. No.");
                GenJnlLine."Applies-to ID" := PayLine."Apply to ID";
                if GenJnlLine.Amount <> 0 then
                    GenJnlLine.Insert;
                //Post P.A.YE Balancing Entry Goes to Vendor
                LineNo := LineNo + 1000;
                GenJnlLine.Init;
                GenJnlLine."Journal Template Name" := JTemplate;
                GenJnlLine.Validate(GenJnlLine."Journal Template Name");
                GenJnlLine."Journal Batch Name" := JBatch;
                GenJnlLine.Validate(GenJnlLine."Journal Batch Name");
                GenJnlLine."Source Code" := 'PAYMENTJNL';
                GenJnlLine."Line No." := LineNo;
                GenJnlLine."Posting Date" := Rec."Cheque Date";
                if CustomerPayLinesExist then
                    GenJnlLine."Document Type" := GenJnlLine."document type"::" "
                else
                    GenJnlLine."Document Type" := GenJnlLine."document type"::Payment;
                GenJnlLine."Document No." := PayLine.No;
                GenJnlLine."External Document No." := Rec."Cheque No";
                GenJnlLine."Account Type" := PayLine."Account Type";
                GenJnlLine."Account No." := PayLine."Account No.";
                GenJnlLine.Validate(GenJnlLine."Account No.");
                GenJnlLine."Currency Code" := Payments."Currency Code";
                GenJnlLine.Validate(GenJnlLine."Currency Code");
                //CurrFactor
                GenJnlLine."Currency Factor" := Payments."Currency Factor";
                GenJnlLine.Validate("Currency Factor");

                GenJnlLine."Gen. Posting Type" := GenJnlLine."gen. posting type"::" ";
                GenJnlLine.Validate(GenJnlLine."Gen. Posting Type");
                GenJnlLine."Gen. Bus. Posting Group" := '';
                GenJnlLine.Validate(GenJnlLine."Gen. Bus. Posting Group");
                GenJnlLine."Gen. Prod. Posting Group" := '';
                GenJnlLine.Validate(GenJnlLine."Gen. Prod. Posting Group");
                GenJnlLine."VAT Bus. Posting Group" := '';
                GenJnlLine.Validate(GenJnlLine."VAT Bus. Posting Group");
                GenJnlLine."VAT Prod. Posting Group" := '';
                GenJnlLine.Validate(GenJnlLine."VAT Prod. Posting Group");
                GenJnlLine.Amount := PayLine."PAYE Amount";
                GenJnlLine.Validate(GenJnlLine.Amount);
                GenJnlLine."Bal. Account Type" := GenJnlLine."bal. account type"::"G/L Account";
                GenJnlLine."Bal. Account No." := '';
                GenJnlLine.Description := CopyStr('PAYE:', 1, 50);
                GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
                GenJnlLine."Shortcut Dimension 1 Code" := PayLine."Global Dimension 1 Code";
                GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                GenJnlLine."Shortcut Dimension 2 Code" := PayLine."Shortcut Dimension 2 Code";
                GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
                GenJnlLine.ValidateShortcutDimCode(3, PayLine."Shortcut Dimension 3 Code");
                GenJnlLine.ValidateShortcutDimCode(4, PayLine."Shortcut Dimension 4 Code");
                GenJnlLine."Applies-to Doc. Type" := GenJnlLine."applies-to doc. type"::Invoice;
                GenJnlLine."Applies-to Doc. No." := PayLine."Apply to";
                GenJnlLine.Validate(GenJnlLine."Applies-to Doc. No.");
                GenJnlLine."Applies-to ID" := PayLine."Apply to ID";
                if GenJnlLine.Amount <> 0 then
                    GenJnlLine.Insert;


            until PayLine.Next = 0;

            Commit;
            //Post the Journal Lines
            GenJnlLine.Reset;
            GenJnlLine.SetRange(GenJnlLine."Journal Template Name", JTemplate);
            GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", JBatch);
            //Adjust Gen Jnl Exchange Rate Rounding Balances
            AdjustGenJnl.Run(GenJnlLine);
            //End Adjust Gen Jnl Exchange Rate Rounding Balances


            //Before posting if paymode is cheque print the cheque
            if (Payments."Pay Mode" = Payments."pay mode"::Cheque) and (Payments."Cheque Type" = Payments."cheque type"::"Computer Check") then begin
                DocPrint.PrintCheck(GenJnlLine);
                Codeunit.Run(Codeunit::"Adjust Gen. Journal Balance", GenJnlLine);
                //Confirm Cheque printed //Not necessary.
            end;


            Codeunit.Run(Codeunit::"Gen. Jnl.-Post Bill", GenJnlLine);


            if IsPosted.PostedSuccessfully(Payments."No.") then begin
                PayLine.Reset;
                PayLine.SetRange(No, Payments."No.");
                if PayLine.FindFirst then begin
                    repeat
                        PayLine."Date Posted" := Today;
                        PayLine."Time Posted" := Time;
                        PayLine."Posted By" := UserId;
                        PayLine.Status := PayLine.Status::Posted;
                        PayLine.Modify;
                    until PayLine.Next = 0;
                end;
                Payments.Posted := true;
                Payments."Posted By" := UserId;
                Payments."Cheque No." := Rec."Cheque No";
                Payments."Payment Release Date" := Rec."Cheque Date";
                Payments.Modify;

            end;

        end;
    end;

    procedure CustomerPayLinesExist(): Boolean
    begin
        // PayLine.RESET;
        // PayLine.SETRANGE(PayLine.No,"No.");
        // PayLine.SETRANGE(PayLine."Account Type",PayLine."Account Type"::Customer);
        // EXIT(PayLine.FINDFIRST);
    end;

    procedure PostScheduleHeader()
    var
        Setup: Record "Cash Office Setup";
        Temp: Record "Cash Office User Template";
    begin

        Rec.TestField("Cheque Date");
        Rec.TestField("Paying Bank No");
        Rec.TestField("Cheque No");


        Setup.Get;
        Setup.TestField("Payment Split Account");

        //IF Posted=TRUE THEN ERROR('The Document is already Posted!');
        /*Check if the user has selcted all the relevant fields*/
        Temp.Get(UserId);
        JTemplate := Temp."Payment Journal Template";
        JBatch := Temp."Payment Journal Batch";

        if JTemplate = '' then Error('Please ensure that the Payment Template is setup in the cash management setup!!');
        if JBatch = '' then Error('Please ensure that the Payment Batch is setup in the cash management setup!!');

        if Temp.Get(UserId) then begin
            GenJnlLine.Reset;
            GenJnlLine.SetRange(GenJnlLine."Journal Template Name", JTemplate);
            GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", JBatch);
            GenJnlLine.DeleteAll;
        end;

        LineNo := LineNo + 1000;
        GenJnlLine.Init;
        GenJnlLine."Journal Template Name" := JTemplate;
        GenJnlLine."Journal Batch Name" := JBatch;
        GenJnlLine."Line No." := LineNo;
        GenJnlLine."Source Code" := 'PAYMENTJNL';
        GenJnlLine."Posting Date" := Rec."Cheque Date";
        GenJnlLine."Document Type" := GenJnlLine."document type"::Payment;
        GenJnlLine."Document No." := Rec.No;
        GenJnlLine."External Document No." := Rec."Cheque No";
        GenJnlLine."Account Type" := GenJnlLine."account type"::"G/L Account";
        GenJnlLine."Account No." := Setup."Payment Split Account";
        GenJnlLine.Validate(GenJnlLine."Account No.");
        GenJnlLine.Description := Rec.Payee;
        Rec.CalcFields("Total Amount");
        GenJnlLine.Amount := Rec."Total Amount";
        GenJnlLine.Validate(GenJnlLine.Amount);
        GenJnlLine."Bal. Account Type" := GenJnlLine."bal. account type"::"Bank Account";
        GenJnlLine."Bal. Account No." := Rec."Paying Bank No";
        GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
        //Added for Currency Codes
        //GenJnlLine."Currency Code":=cuu;
        //GenJnlLine.VALIDATE("Currency Code");
        //GenJnlLine."Currency Factor":=ImpH."Currency Factor";
        //GenJnlLine.VALIDATE("Currency Factor");
        /*
        GenJnlLine."Currency Factor":=Payments."Currency Factor";
        GenJnlLine.VALIDATE("Currency Factor");
        
        GenJnlLine."Shortcut Dimension 1 Code":=ImpH."Global Dimension 1 Code";
        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
        GenJnlLine."Shortcut Dimension 2 Code":=ImpH."Shortcut Dimension 2 Code";
        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
        GenJnlLine.ValidateShortcutDimCode(3,ImpH."Shortcut Dimension 3 Code");
        GenJnlLine.ValidateShortcutDimCode(4,ImpH."Shortcut Dimension 4 Code");
        */
        if GenJnlLine.Amount <> 0 then
            GenJnlLine.Insert;

        //IF GLEntry.FINDLAST THEN LastEntry:=GLEntry."Entry No.";


        GenJnlLine.Reset;
        GenJnlLine.SetRange(GenJnlLine."Journal Template Name", JTemplate);
        GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", JBatch);
        Codeunit.Run(Codeunit::"Gen. Jnl.-Post Bill", GenJnlLine);

        //END;

    end;

    procedure PostClaim()
    var
        Setup: Record "Cash Office Setup";
        Temp: Record "Cash Office User Template";
        ImpH: Record "Staff Claims Header";
        PayLine: Record "Staff Claim Lines";
    begin
        PSline.Reset;
        PSline.SetRange(No, Rec.No);
        PSline.SetRange("Document Type", PSline."document type"::"Staff Claim");
        if PSline.Find('-') then begin
            repeat
                Rec.TestField("Cheque Date");
                Rec.TestField("Paying Bank No");
                Rec.TestField("Cheque No");

                ImpH.Get(PSline."Payment No");
                Setup.Get;
                Setup.TestField("Payment Split Account");

                //IF Posted=TRUE THEN ERROR('The Document is already Posted!');
                /*Check if the user has selcted all the relevant fields*/
                Temp.Get(UserId);
                JTemplate := Temp."Payment Journal Template";
                JBatch := Temp."Payment Journal Batch";

                if JTemplate = '' then Error('Please ensure that the Payment Template is setup in the cash management setup!!');
                if JBatch = '' then Error('Please ensure that the Payment Batch is setup in the cash management setup!!');

                if Temp.Get(UserId) then begin
                    GenJnlLine.Reset;
                    GenJnlLine.SetRange(GenJnlLine."Journal Template Name", JTemplate);
                    GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", JBatch);
                    GenJnlLine.DeleteAll;
                end;
                /*
                LineNo:=LineNo+1000;
                GenJnlLine.INIT;
                GenJnlLine."Journal Template Name":=JTemplate;
                GenJnlLine."Journal Batch Name":=JBatch;
                GenJnlLine."Line No.":=LineNo;
                GenJnlLine."Source Code":='PAYMENTJNL';
                GenJnlLine."Posting Date":="Cheque Date";
                GenJnlLine."Document Type":=GenJnlLine."Document Type"::Payment;
                GenJnlLine."Document No.":=PSline."Payment No";
                GenJnlLine."External Document No.":="Cheque No";
                GenJnlLine."Account Type":=GenJnlLine."Account Type"::"G/L Account";
                GenJnlLine."Account No.":=Setup."Payment Split Account";
                GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                GenJnlLine.Description:='Payment: '+No+':'+"Cheque No";

                GenJnlLine.Amount:=PSline."Cheque Amount";
                GenJnlLine.VALIDATE(GenJnlLine.Amount);
                GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::"Bank Account";
                GenJnlLine."Bal. Account No.":="Paying Bank No";
                GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                //Added for Currency Codes
                GenJnlLine."Currency Code":=ImpH."Currency Code";
                GenJnlLine.VALIDATE("Currency Code");
                GenJnlLine."Currency Factor":=ImpH."Currency Factor";
                GenJnlLine.VALIDATE("Currency Factor");
                {
                GenJnlLine."Currency Factor":=Payments."Currency Factor";
                GenJnlLine.VALIDATE("Currency Factor");
                }
                GenJnlLine."Shortcut Dimension 1 Code":=ImpH."Global Dimension 1 Code";
                GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                GenJnlLine."Shortcut Dimension 2 Code":=ImpH."Shortcut Dimension 2 Code";
                GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
                GenJnlLine.ValidateShortcutDimCode(3,ImpH."Shortcut Dimension 3 Code");
                GenJnlLine.ValidateShortcutDimCode(4,ImpH."Shortcut Dimension 4 Code");

                IF GenJnlLine.Amount<>0 THEN
                GenJnlLine.INSERT;

                //IF GLEntry.FINDLAST THEN LastEntry:=GLEntry."Entry No.";


                GenJnlLine.RESET;
                GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name",JTemplate);
                GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name",JBatch);
                CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post",GenJnlLine);
                */
                if ImpH.Posted = false then begin

                    if Temp.Get(UserId) then begin
                        GenJnlLine.Reset;
                        GenJnlLine.SetRange(GenJnlLine."Journal Template Name", JTemplate);
                        GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", JBatch);
                        GenJnlLine.DeleteAll;
                    end;
                    PayLine.RESET;
                    PayLine.SETRANGE(PayLine.No, ImpH."No.");
                    IF PayLine.FIND('-') THEN BEGIN
                        REPEAT
                            LineNo := LineNo + 1000;
                            GenJnlLine.Init;
                            GenJnlLine."Journal Template Name" := JTemplate;
                            GenJnlLine."Journal Batch Name" := JBatch;
                            GenJnlLine."Line No." := LineNo;
                            GenJnlLine."Source Code" := 'PAYMENTJNL';
                            GenJnlLine."Posting Date" := Today;
                            GenJnlLine."Document Type" := GenJnlLine."document type"::Invoice;
                            GenJnlLine."Document No." := ImpH."No.";
                            //GenJnlLine."External Document No.":="Cheque No.";
                            GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                            GenJnlLine."Account No." := PayLine."Account No:";
                            GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                            GenJnlLine.Description := Imph.Purpose;
                            GenJnlLine."Debit Amount" := PayLine.Amount;
                            GenJnlLine.VALIDATE(GenJnlLine."Debit Amount");
                            GenJnlLine.Validate(GenJnlLine.Amount);
                            GenJnlLine."Bal. Account Type" := GenJnlLine."bal. account type"::"G/L Account";
                            GenJnlLine."Bal. Account No." := Setup."Payment Split Account";
                            GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
                            //Added for Currency Codes
                            GenJnlLine."Currency Code" := ImpH."Currency Code";
                            GenJnlLine.Validate("Currency Code");
                            GenJnlLine."Currency Factor" := ImpH."Currency Factor";
                            GenJnlLine.Validate("Currency Factor");
                            /*
                            GenJnlLine."Currency Factor":=Payments."Currency Factor";
                            GenJnlLine.VALIDATE("Currency Factor");
                            */
                            GenJnlLine."Shortcut Dimension 1 Code" := ImpH."Global Dimension 1 Code";
                            GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                            GenJnlLine."Shortcut Dimension 2 Code" := ImpH."Shortcut Dimension 2 Code";
                            GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
                            GenJnlLine.ValidateShortcutDimCode(3, ImpH."Shortcut Dimension 3 Code");
                            GenJnlLine.ValidateShortcutDimCode(4, ImpH."Shortcut Dimension 4 Code");

                            if GenJnlLine.Amount <> 0 then
                                GenJnlLine.Insert;
                        until PayLine.next = 0;
                    end;

                    GenJnlLine.Reset;
                    GenJnlLine.SetRange(GenJnlLine."Journal Template Name", JTemplate);
                    GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", JBatch);
                    Codeunit.Run(Codeunit::"Gen. Jnl.-Post Bill", GenJnlLine);

                    if IsPosted.PostedSuccessfully(ImpH."No.") then begin
                        ImpH.Posted := true;
                        ImpH."Posted By" := UserId;
                        ImpH."Date Posted" := Today;
                        ImpH.Modify;
                    end;
                end;

                ImpH.CalcFields("Paid Amount");
                ImpH.CalcFields("Total Net Amount");
                if ImpH."Total Net Amount" = ImpH."Paid Amount" then begin
                    ImpH."Fully Paid" := true;
                    ImpH.Modify;
                end;
            until PSline.Next = 0;
        end;
    end;
}

