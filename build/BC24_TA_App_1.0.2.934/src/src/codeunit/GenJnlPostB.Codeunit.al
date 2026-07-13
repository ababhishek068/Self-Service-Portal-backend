Codeunit 50018 "Gen. Jnl.-Post B"
{
    TableNo = "Gen. Journal Line";

    trigger OnRun()
    begin
        GenJnlLine.Copy(Rec);
        Code;
        Rec.Copy(GenJnlLine);
    end;

    var
        Text000: label 'cannot be filtered when posting recurring journals';
        Text002: label 'There is nothing to post.';
        GenJnlTemplate: Record "Gen. Journal Template";
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlPostBatch: Codeunit "Gen. Jnl.-Post Batch";
        TempJnlBatchName: Code[10];

    local procedure "Code"()
    begin
        GenJnlTemplate.Get(GenJnlLine."Journal Template Name");
        GenJnlTemplate.TestField("Force Posting Report", false);
        if GenJnlTemplate.Recurring and (GenJnlLine.GetFilter("Posting Date") <> '') then
            GenJnlLine.FieldError("Posting Date", Text000);

        //IF NOT CONFIRM(Text001,FALSE) THEN
        //EXIT;

        TempJnlBatchName := GenJnlLine."Journal Batch Name";

        GenJnlPostBatch.Run(GenJnlLine);

        if GenJnlLine."Line No." = 0 then
            Message(Text002)
        else
            /*
              IF TempJnlBatchName = "Journal Batch Name" THEN
                MESSAGE(Text003)
              ELSE
                MESSAGE(
                  Text004,
                  "Journal Batch Name");
            */
            if not GenJnlLine.Find('=><') or (TempJnlBatchName <> GenJnlLine."Journal Batch Name") then begin
                GenJnlLine.Reset;
                GenJnlLine.FilterGroup(2);
                GenJnlLine.SetRange("Journal Template Name", GenJnlLine."Journal Template Name");
                GenJnlLine.SetRange("Journal Batch Name", GenJnlLine."Journal Batch Name");
                GenJnlLine.FilterGroup(0);
                GenJnlLine."Line No." := 1;
            end;

    end;


    procedure RemoveApplications(EntryNo: Integer)
    var
        CustD: Record "Detailed Cust. Ledg. Entry";
    begin
        if CustD.Get(EntryNo) then begin
            CustD.Delete;
        end;
    end;

    procedure UpdateBankRec(BankNo: Code[20]; SDate: Date)
    var
        BankLedger: Record "Bank Account Ledger Entry";
    begin
        BankLedger.Reset;
        BankLedger.SetRange(BankLedger."Bank Account No.", BankNo);
        BankLedger.SetRange(BankLedger.Reversed, false);
        BankLedger.SetFilter(BankLedger."Posting Date", '%1..%2', 20010101D, SDate);
        BankLedger.SetFilter(BankLedger."Statement Line No.", '%1', 0);
        if BankLedger.Find('-') then begin
            repeat
                BankLedger."Statement Difference" := BankLedger.Amount;
                BankLedger.Modify;
            until BankLedger.Next = 0;
        end;
    end;

    procedure UpdateBankCheque(BankNo: Code[20]; DocNo: Code[20]; ChequeNo: Code[20])
    var
        BankL: Record "Bank Account Ledger Entry";
    begin
        BankL.Reset;
        BankL.SetRange("Document No.", DocNo);
        BankL.SetRange("Bank Account No.", BankNo);
        if BankL.Find('-') then begin
            repeat
                BankL."External Document No." := ChequeNo;
                BankL.Modify;
            until BankL.Next = 0;
        end;
    end;

    procedure UpdateBankExternalDoc2(BankNo: Code[20])
    var
        BankAccLedgerMain: Record "Bank Account Ledger Entry";
    begin
        BankAccLedgerMain.Reset;
        BankAccLedgerMain.SetRange(BankAccLedgerMain."Bank Account No.", BankNo);
        //BankAccLedgerMain.SETFILTER(BankAccLedgerMain."External Document No. 2",'<>%1','');
        if BankAccLedgerMain.Find('-') then begin
            repeat
                if BankAccLedgerMain."External Document No. 2" <> CopyStr(BankAccLedgerMain."External Document No.", 1, 21) then begin
                    BankAccLedgerMain."External Document No. 2" := CopyStr(BankAccLedgerMain."External Document No.", 1, 21);
                    BankAccLedgerMain.Modify;
                end;

            until BankAccLedgerMain.Next = 0;
        end;
    end;

    procedure DeleteBankRec(BankAcc: Code[20]; StatementNo: Code[20])
    var
        BankAccLedgEntry: Record "Bank Account Ledger Entry";
    begin
        BankAccLedgEntry.Reset;
        BankAccLedgEntry.SetFilter(BankAccLedgEntry."Bank Account No.", BankAcc);
        BankAccLedgEntry.SetFilter(BankAccLedgEntry."Statement Status", '=%1', BankAccLedgEntry."statement status"::Open);
        //BankAccLedgEntry.SETFILTER("Statement No.",StatementNo);

        //BankAccLedgEntry.SETFILTER(BankAccLedgEntry."Posting Date",'12/29/2017..4/30/2018');
        if BankAccLedgEntry.Find('-') then begin
            repeat
                //MESSAGE('%1',BankAccLedgEntry.COUNT);
                BankAccLedgEntry.Open := true;
                BankAccLedgEntry."Remaining Amount" := BankAccLedgEntry.Amount;
                BankAccLedgEntry."Statement Status" := BankAccLedgEntry."statement status"::Open;
                BankAccLedgEntry."Statement No." := '';
                BankAccLedgEntry."Statement Line No." := 0;
                BankAccLedgEntry.Modify;
            until BankAccLedgEntry.Next = 0;
            BankAccLedgEntry.Modify;
            Message('done');
        end;
    end;

    procedure GenerateMassInvoice(CustNo: code[20]; ChargeCode: code[20]; Amt: Decimal; PDate: date): Code[20]
    var
        SalesSetup: Record "Sales & Receivables Setup";
        Charges: record charge;
        NoSeriesMgt: Codeunit "No. Series";
        NewNo: code[20];
        SaleH: Record "Sales Header";
        SLine: Record "Sales Line";
        Cust: record customer;
        LineNo: Integer;
    begin
        SalesSetup.Get;
        Cust.get(CustNo);
        NewNo := NoSeriesMgt.GetNextNo(SalesSetup."Invoice Nos.", 0D, TRUE);


        SaleH.Init;
        SaleH."Document Type" := SaleH."document type"::Invoice;
        SaleH."No." := NewNo;
        SaleH."Posting Date" := Pdate;
        SaleH."Due Date" := CalcDate('3M', Today);
        SaleH."Shipping No. Series" := SalesSetup."Posted Shipment Nos.";
        SaleH."Document Date" := Today;
        SaleH."Sell-to Customer No." := CustNo;
        SaleH."Bill-to Customer No." := CustNo;
        SaleH."Shortcut Dimension 1 Code" := cust."Global Dimension 1 Code";
        SaleH."Shortcut Dimension 2 Code" := Cust."Global Dimension 2 Code";
        // SaleH."Shortcut Dimension 3 Code" := Cust.Sho
        // SaleH."Shortcut Dimension 4 Code" := Charges."Shortcut Dimension 4 Code";

        SaleH."Shipping No. Series" := SalesSetup."Posted Shipment Nos.";
        SaleH.Insert;
        //END;

        if SaleH.Get(SaleH."Document type"::Invoice, NewNo) then begin
            SaleH.Validate("Sell-to Customer No.");
            SaleH."Shortcut Dimension 1 Code" := Cust."Global Dimension 1 Code";
            SaleH."Shortcut Dimension 2 Code" := Cust."Global Dimension 2 Code";
            // SaleH."Shortcut Dimension 3 Code" := Charges."Shortcut Dimension 3 Code";
            // SaleH."Shortcut Dimension 4 Code" := Charges."Shortcut Dimension 4 Code";

            SaleH.Validate("Shortcut Dimension 1 Code");
            SaleH.Validate("Shortcut Dimension 2 Code");
            //SaleH.Status := SaleH.Status::Released;
            SaleH.modify;

            if SLine.FindLast() then LineNo := SLine."Line No." + 1;

            Charges.Reset;
            Charges.Setfilter(Code, ChargeCode);
            //  Charges.Setfilter(Charges.Amount, '<>%1', 0);
            Charges.Setfilter(Charges."G/L Account", '<>%1', '');
            // Charges.SETRANGE(Charges.Posted,FALSE); //Commented to allow receipts for debtor patient
            if Charges.Find('-') then begin
                repeat

                    SLine.Init;
                    SLine."Line No." := LineNo;
                    SLine."Document No." := SaleH."No.";

                    SLine."Bill-to Customer No." := SaleH."Bill-to Customer No.";
                    SLine."Document Type" := SaleH."Document Type";
                    SLine."Description 2" := Charges.Description;
                    SLine."Sell-to Customer No." := CustNo;
                    SLine.Type := SLine.Type::"G/L Account";

                    SLine."No." := Charges."G/L Account";
                    SLine.Description := Charges.Description;
                    SLine.Quantity := 1;
                    SLine.Validate(SLine.Quantity);
                    SLine."Unit Price" := Amt;

                    SLine.Amount := Round(Amt, 1, '=');
                    SLine."Unit Price" := Round(Amt, 1, '=');

                    SLine.Validate("Unit Price");
                    SLine."Gen. Bus. Posting Group" := 'LOCAL';
                    SLine."Gen. Prod. Posting Group" := 'SERVICES';

                    SLine."Shortcut Dimension 1 Code" := Charges."Global Dimension 1";
                    SLine."Shortcut Dimension 2 Code" := Charges."Global Dimension 2";
                    SLine.Validate("Shortcut Dimension 1 Code");
                    SLine.Validate("Shortcut Dimension 2 Code");
                    SLine.Insert;
                    LineNo := LineNo + 1;


                until Charges.Next = 0;
            end;
        end;
        exit(NewNo);
    end;
}

