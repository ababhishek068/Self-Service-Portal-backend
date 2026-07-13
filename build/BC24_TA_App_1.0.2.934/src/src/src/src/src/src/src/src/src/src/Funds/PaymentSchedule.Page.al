page 51384 "Payment Schedule"
{
    PageType = Card;
    SourceTable = "Payment Schedule";
    UsageCategory = Lists;
    ApplicationArea = Basic;
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
                field("Paying Bank No"; Rec."Paying Bank No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Paying Bank No field.';
                }
                field("Cheque No"; Rec."Cheque No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cheque No field.';
                }
                field("Cheque Date"; Rec."Cheque Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cheque Date field.';
                }
                field(Payee; Rec.Payee)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Payee field.';
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    Editable = false;
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Total Amount field.';
                }
                field("Cheque Format"; Rec."Cheque Format")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cheque Format field.';
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
            group(Lines)
            {
                part(Control6; "Payment Schedule Line")
                {
                    ApplicationArea = basic;
                    SubPageLink = No = FIELD(No);
                }
            }
        }
    }

    actions
    {
        area(Reporting)
        {
            action("Print Cheque")
            {
                Image = PreviewChecks;
                Promoted = true;
                ApplicationArea = Basic;
                PromotedCategory = Report;
                ToolTip = 'Executes the Print Cheque action.';

                trigger OnAction()
                begin
                    if Confirm('Do you really want to post the selected the payments?', false) then
                        //  IF "Cheque Format"="Cheque Format"::"Kalamazoo Format" THEN PrintKalamzoo;
                        //  IF "Cheque Format"="Cheque Format"::"Plain Format" THEN PrintNormal;
                        PostPaymentVoucher;
                end;
            }
            separator(Separator15) { }
            action(Test)
            {
                ToolTip = 'Executes the Test action.';
                // RunObject = Report "Payment Cheque";
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
        AdjustGenJnl: Codeunit "Adjust Gen. Journal Balance";
        ImpH: Record "Imprest Header";
        PS: Record "Payment Schedule";
        BankRec: Record "Bank Account";
        PostChequeNo: Codeunit "Gen. Jnl.-Post B";
        CheckLedger: Record "Check Ledger Entry";

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

        Rec.Posted := true;
        // Status:=Payments.Status::Posted;
        Rec."Posted By" := UserId;
        Rec."Posting Dated" := Today;
        Rec.Modify;


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
                    PostChequeNo.UpdateBankCheque(Rec."Paying Bank No", PSline."Payment No", Rec."Cheque No");
                end;
                if ImpH.Get(PSline."Payment No") then begin
                    ImpH."Cheque No." := Rec."Cheque No";
                    ImpH."Payment Release Date" := Rec."Cheque Date";
                    //Imph.ch:=TRUE;
                    ImpH."Payment Schedule No" := Rec.No;
                    PostChequeNo.UpdateBankCheque(Rec."Paying Bank No", PSline."Payment No", Rec."Cheque No");
                    CheckLedger.Reset;
                    if CheckLedger.FindLast() then LineNo := CheckLedger."Entry No.";
                    //        CheckLedger.INIT;
                    //        CheckLedger."Document No.":=No;
                    //        CheckLedger."Posting Date":=TODAY;
                    //        CheckLedger."Bank Account No.":="Paying Bank No";
                    //        CheckLedger."Check Date":="Cheque Date";
                    //        CheckLedger."Check No.":="Cheque No";
                    //        CheckLedger."Entry No.":=LineNo;
                    //        CheckLedger.INSERT;
                    ImpH.Modify;
                end;
            until PSline.Next = 0;
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
        //    IF Payments."Cheque No."='' THEN
        //      BEGIN
        //        ERROR ('Please ensure that the EFT number is inserted');
        //      END;
        //  END;
        //
        // IF Payments."Pay Mode"=Payments."Pay Mode"::"Account Transfer" THEN
        //  BEGIN
        //    IF Payments."Cheque No."='' THEN
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

        GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
        GenJnlLine."Document No." := Rec.No;
        GenJnlLine."External Document No." := Rec."Cheque No";

        GenJnlLine."Account Type" := GenJnlLine."Account Type"::"Bank Account";
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
        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"Bank Account";
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

        GenJnlLine."Bank Payment Type" := GenJnlLine."Bank Payment Type"::"Computer Check";
        //GenJnlLine.Payee := Payee;
        if GenJnlLine.Amount <> 0 then
            GenJnlLine.Insert;


        //
        GenJnlLine.Reset;
        GenJnlLine.SetRange(GenJnlLine."Journal Template Name", JTemplate);
        GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", JBatch);
        if GenJnlLine.Find('-') then begin
            AdjustGenJnl.Run(GenJnlLine);
            if Rec."Cheque Format" = Rec."Cheque Format"::"Kalamazoo Format" then begin
                REPORT.Run(70134841, false, false, GenJnlLine)
            end else begin
                // REPORT.RUN(70134836,FALSE,FALSE,GenJnlLine);
                PS.Reset;
                PS.SetFilter(No, Rec.No);
                if PSline.Find('-') then
                    REPORT.Run(50090, false, false, PS);

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

        GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
        GenJnlLine."Document No." := Rec.No;
        GenJnlLine."External Document No." := Rec."Cheque No";

        GenJnlLine."Account Type" := GenJnlLine."Account Type"::"Bank Account";
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
        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"Bank Account";
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

        GenJnlLine."Bank Payment Type" := GenJnlLine."Bank Payment Type"::"Computer Check";
        //GenJnlLine.Payee := Payee;
        if GenJnlLine.Amount <> 0 then
            GenJnlLine.Insert;

    end;

    local procedure PrintKalamzoo()
    begin
    end;
}

