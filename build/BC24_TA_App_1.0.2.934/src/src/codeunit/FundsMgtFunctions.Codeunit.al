codeunit 50013 "Funds Mgt Functions"
{
    procedure IndentWorkplanActivities()
    var
        Window: Dialog;
        AccNo: Array[10] of Code[20];
        i: Integer;
        Text005: Label 'End-Total %1 is missing a matching Begin-Total.';
        WorkplanActivity: Record "Workplan Activities";
    begin

        IF WorkplanActivity.FIND('-') THEN
            REPEAT
                Window.UPDATE(1, WorkplanActivity."Activity Description");

                IF WorkplanActivity."Account Type" = WorkplanActivity."Account Type"::"End-Total" THEN BEGIN
                    IF i < 1 THEN
                        ERROR(
                          Text005,
                          WorkplanActivity."Activity Code");
                    WorkplanActivity.Totalling := AccNo[i] + '..' + WorkplanActivity."Activity Code";
                    i := i - 1;
                END;

                WorkplanActivity.Indentation := i;
                WorkplanActivity.MODIFY;

                IF WorkplanActivity."Account Type" = WorkplanActivity."Account Type"::"Begin-Total" THEN BEGIN
                    i := i + 1;
                    AccNo[i] := WorkplanActivity."Activity Code";
                END;
            UNTIL WorkplanActivity.NEXT = 0;

        Window.CLOSE;
    end;

    procedure CreateReceipt(CustNo: code[20]; InvNo: code[20]; Amt: Decimal; BankNo: code[20]; PayMode: option; TransNo: code[20]; AutoPost: Boolean)
    var
        CashOfficeSetup: Record "Cash Office Setup";
        RecHeader: Record "Receipts Header";
        RLine: record "Receipt Line q";
        ReceiptNo: code[20];
        UserSetup: Record "User Setup";
        NoSeries: Code[20];
        Cust: record Customer;
        NoSeriesMgt: Codeunit "No. Series";
        ReceiptHeader: Page "Receipt Header UP";
        CashTemp: record "Cash Office User Template";
    begin
        Cust.get(CustNo);
        // Check for unused receipt
        RecHeader.reset;
        RecHeader.setrange(Cashier, Database.UserId);
        RecHeader.setrange(Date, Today);
        RecHeader.setrange(Posted, false);
        RecHeader.setfilter("Posted Count", '%1', 0);

        if RecHeader.find('-') then ReceiptNo := RecHeader."No.";
        Usersetup.get(Database.UserId);
        if ReceiptNo = '' then begin

            /* if UserSetup."Global Dimension 1 Code" <> '' then begin
                Dimrec.reset;
                dimrec.setrange(Code, UserSetup."Global Dimension 1 Code");
                if dimrec.find('-') Then NoSeries := Dimrec."Receipt No. Series";
            end; */
            if NoSeries = '' then begin
                CashOfficeSetup.get;
                CashOfficeSetup.TestField("Receipts No");
                NoSeries := CashOfficeSetup."Receipts No";
            end;
            ReceiptNo := NoSeriesMgt.GetNextNo(NoSeries, 0D, true);
        end;
        if RecHeader.get(ReceiptNo) then RecHeader.DeleteAll();
        //if RLine.get(ReceiptNo) then RLine.DeleteAll();

        RecHeader.init;
        RecHeader."No." := ReceiptNo;
        RecHeader.Date := today;
        RecHeader.Cashier := database."UserID";
        RecHeader."Global Dimension 1 Code" := userSetup."Global Dimension 1 Code";
        RecHeader.validate("Global Dimension 1 Code");
        RecHeader."Shortcut Dimension 2 Code" := UserSetup."Global Dimension 2 Code";
        RecHeader."Customer No" := CustNo;
        RecHeader."Invoice No" := InvNo;
        RecHeader."Received From" := Cust.Name;
        RecHeader."On Behalf Of" := Cust.Name;
        RecHeader."Document Date" := today;
        RecHeader."Amount Recieved" := Amt;
        RecHeader."Pay Mode" := PayMode;
        RecHeader."Bank Code" := BankNo;
        RecHeader."Cheque No." := TransNo;
        RecHeader.insert;

        RLine.Init;
        RLine."Line No." := RLine."Line No." + 10000000;
        RLine.No := ReceiptNo;
        RLine.Date := today;
        RLine.Type := 'CUSTOMER';
        RLine.Validate(RLine.Type);
        RLine."Account No." := CustNo;
        RLine."Cheque/Deposit Slip No" := TransNo;
        RLine."Cheque/Deposit Slip Date" := today;
        RLine."Transaction Name" := Cust.Name;
        RLine."Pay Mode" := PayMode;
        RLine."Bank Code" := BankNo;
        RLine."Transaction No." := TransNo;
        RLine.Amount := Amt;
        RLine."Total Amount" := Amt;
        if CashTemp.get(Database.UserId) then
            RLine."Location Code" := CashTemp."Default Location";
        RLine.Quantity := 1;
        RLine."Applies-to Doc. No." := InvNo;
        RLine."Applies-to Doc. Type" := RLine."Applies-to Doc. Type"::Invoice;
        RLine."Global Dimension 1 Code" := userSetup."Global Dimension 1 Code";
        RLine."Shortcut Dimension 2 Code" := UserSetup."Global Dimension 2 Code";
        RLine.Insert;

        if RecHeader.get(ReceiptNo) then begin
            ReceiptHeader.setTableView(RecHeader);
            if AutoPost = true then begin
                //ReceiptHeader.run();
                PerformPost(RecHeader)
            end

            else
                ReceiptHeader.run();
            ////  page.run(70135338, RecHeader);
        end;
    end;

    procedure PerformPost(ReceiptRec: Record "Receipts Header")
    var
        GenJnlLine: Record "Gen. Journal Line";
        ReceiptLine: Record "Receipt Line q";
        tAmount: Decimal;
        DefaultBatch: Record "Gen. Journal Batch";
        Rcpt: Record "Receipts Header";
        BankAcc: Record "Bank Account";
        JTemplate: Code[10];
        JBatch: Code[10];
        GLine: Record "Gen. Journal Line";
        LineNo: Integer;
        BAmount: Decimal;
        SRSetup: Record "Sales & Receivables Setup";
        Post: Boolean;
        USetup: Record "Cash Office User Template";
        StrInvoices: Text[250];
        JournalPosted: Codeunit "Journal Post Successful";
        AdjustGenJnl: Codeunit "Adjust Gen. Journal Balance";
        IsCashAccount: Boolean;
        VAmount: Decimal;
        Tarrif: Record "VAT Posting Setup";
        Itm: Record Item;
        InvGroup: Record "General Posting Setup";

    begin

        //Cater for Cash Accounts
        IsCashAccount := false;
        BankAcc.Reset;
        if BankAcc.Get(ReceiptRec."Bank Code") then begin
            if BankAcc."Bank Type" = BankAcc."Bank Type"::Cash then
                IsCashAccount := true;
        end;

        if IsCashAccount then
            ReceiptRec.TestField(Date, WorkDate);
        //End Cater for Cash Account


        USetup.Reset;
        USetup.SetRange(USetup.UserID, UserId);
        if USetup.FindFirst then begin
            if USetup."Receipt Journal Template" = '' then begin
                Error('Please ensure that the Administrator sets you up as a cashier');
            end else begin
                JTemplate := USetup."Receipt Journal Template";

            end;
            if USetup."Receipt Journal Batch" = '' then begin
                Error('Please ensure that the Administrator sets you up as a cashier');
            end else begin
                JBatch := USetup."Receipt Journal Batch";

            end;
            if USetup."Default Receipts Bank" = '' then;
        end
        else begin
            Error('Please ensure that the Administrator sets you up as a cashier');
        end;


        //check if the receipt has any post dated cheques.
        //check if the amounts are similar

        ReceiptRec.CalcFields("Total Amount");
        if ReceiptRec."Total Amount" <> ReceiptRec."Amount Recieved" then begin
            Error('Please note that the Total Amount and the Amount Received Must be the same');
        end;

        //if any then the amount to be posted must be less the post dated amount
        if ReceiptRec.Posted = true then begin
            Error('A Transaction Posted cannot be posted again');
        end;

        //check if the person received from has been selected
        ReceiptRec.TestField(Date);
        ReceiptRec.TestField("Bank Code");
        ReceiptRec.TestField("Global Dimension 1 Code");
        ReceiptRec.TestField("Shortcut Dimension 2 Code");
        ReceiptRec.TestField("Received From");
        /*Check if the amount received is equal to the total amount*/
        tAmount := 0;

        //Check Bank
        //CheckBnkCurrency("Bank Code", "Currency Code");

        ReceiptLine.Reset;
        ReceiptLine.SetRange(ReceiptLine.No, ReceiptRec."No.");
        if ReceiptLine.Find('-') then begin
            repeat
                if ReceiptLine."Pay Mode" = ReceiptLine."Pay Mode"::" " then
                    Error('Paymode is Mandatory on the Receipt Line');

                if ReceiptLine."Pay Mode" = ReceiptLine."Pay Mode"::"Deposit Slip" then begin
                    if ReceiptLine."Cheque/Deposit Slip No" = '' then begin
                        Error('The Cheque/Deposit Slip No must be inserted');
                    end;
                    if ReceiptLine.Amount = 0 then begin
                        Error('Amount in Lines must be inserted');
                    end;
                    if ReceiptLine."Cheque/Deposit Slip Date" = 0D then begin
                        Error('The Cheque/Deposit Date must be inserted');
                    end;
                    if ReceiptLine."Transaction No." = '' then begin
                        Error('Please ensure that the Transaction Number is inserted');
                    end;
                    if ReceiptLine.Type = '' then
                        Error('Please ensure that the Receipt Type is inserted');

                end;

                if ReceiptLine."Pay Mode" = ReceiptLine."Pay Mode"::Cheque then begin
                    if ReceiptLine."Cheque/Deposit Slip No" = '' then begin
                        Error('The Cheque/Deposit Slip No must be inserted');
                    end;
                    if ReceiptLine."Cheque/Deposit Slip Date" = 0D then begin
                        Error('The Cheque/Deposit Date must be inserted');
                    end;
                    if ReceiptLine."Pay Mode" = ReceiptLine."Pay Mode"::Cheque then begin
                        if StrLen(ReceiptLine."Cheque/Deposit Slip No") <> 6 then begin
                            Error('Invalid Cheque Number inserted');
                        end;
                    end;
                end;
                tAmount := tAmount + ReceiptLine.Amount;
                VAmount := VAmount + ReceiptLine."VAT Amount";
            until ReceiptLine.Next = 0;
        end;



        // DELETE ANY LINE ITEM THAT MAY BE PRESENT
        GenJnlLine.Reset;
        GenJnlLine.SetRange(GenJnlLine."Journal Template Name", JTemplate);
        GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", JBatch);
        GenJnlLine.DeleteAll;

        if DefaultBatch.Get(JTemplate, JBatch) then
            DefaultBatch.Delete;

        DefaultBatch.Reset;
        DefaultBatch."Journal Template Name" := JTemplate;
        DefaultBatch.Name := JBatch;
        DefaultBatch.Insert;

        /*Insert the bank transaction*/
        if BAmount < tAmount then begin
            GenJnlLine.Init;
            GenJnlLine."Journal Template Name" := JTemplate;
            GenJnlLine."Journal Batch Name" := JBatch;
            GenJnlLine."Source Code" := 'CASHRECJNL';
            GenJnlLine."Line No." := 1;
            GenJnlLine."Posting Date" := ReceiptRec.Date;
            GenJnlLine."Document Date" := ReceiptRec."Document Date";
            GenJnlLine."Document No." := ReceiptRec."No.";
            GenJnlLine."External Document No." := ReceiptLine."Cheque/Deposit Slip No";
            GenJnlLine."Document Date" := ReceiptRec."Document Date";
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::"Bank Account";

            GenJnlLine."Account No." := ReceiptRec."Bank Code";//USetup."Default Receipts Bank";
            GenJnlLine.Validate(GenJnlLine."Account No.");
            GenJnlLine."Currency Code" := ReceiptRec."Currency Code";
            GenJnlLine.Validate(GenJnlLine."Currency Code");
            GenJnlLine.Amount := (tAmount);
            GenJnlLine.Validate(GenJnlLine.Amount);

            GenJnlLine."Shortcut Dimension 1 Code" := ReceiptRec."Global Dimension 1 Code";
            GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
            GenJnlLine."Shortcut Dimension 2 Code" := ReceiptRec."Shortcut Dimension 2 Code";
            GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
            GenJnlLine.ValidateShortcutDimCode(3, ReceiptRec."Shortcut Dimension 3 Code");
            GenJnlLine.ValidateShortcutDimCode(4, ReceiptRec."Shortcut Dimension 4 Code");

            GenJnlLine.Description := ReceiptRec."Received From";
            GenJnlLine.Validate(GenJnlLine.Description);
            if GenJnlLine.Amount <> 0 then
                GenJnlLine.Insert;




            //insert the transaction lines into the database
            ReceiptLine.Reset;
            ReceiptLine.SetRange(ReceiptLine.No, ReceiptRec."No.");
            ReceiptLine.SetRange(ReceiptLine.Posted, false);

            if ReceiptLine.Find('-') then begin

                repeat
                    if ReceiptLine.Amount = 0 then Error('Please enter amount.');

                    if ReceiptLine.Amount < 0 then Error('Amount cannot be less than zero.');

                    ReceiptLine.TestField(ReceiptLine."Global Dimension 1 Code");

                    ReceiptLine.TestField(ReceiptLine."Shortcut Dimension 2 Code");

                    //get the last line number from the general journal line
                    GLine.Reset;


                    GLine.SetRange(GLine."Journal Template Name", JTemplate);
                    GLine.SetRange(GLine."Journal Batch Name", JBatch);
                    LineNo := 0;
                    if GLine.Find('+') then begin LineNo := GLine."Line No."; end;
                    LineNo := LineNo + 1;
                    if ReceiptLine."Pay Mode" <> ReceiptLine."Pay Mode"::Cheque then begin
                        GenJnlLine.Init;
                        GenJnlLine."Journal Template Name" := JTemplate;
                        GenJnlLine."Journal Batch Name" := JBatch;
                        GenJnlLine."Source Code" := 'CASHRECJNL';
                        GenJnlLine."Line No." := LineNo;
                        GenJnlLine."Posting Date" := ReceiptRec.Date;
                        GenJnlLine."Document No." := ReceiptLine.No;
                        GenJnlLine."Document Date" := ReceiptRec."Document Date";
                        if ReceiptLine."Account Type" = ReceiptLine."Account Type"::Item then begin
                            /*SRSetup.GET();
                            GenJnlLine."Account Type":=GenJnlLine."Account Type"::"G/L Account";
                            GenJnlLine."Account No.":=SRSetup."Receivable Batch Account";*/
                            itm.get(ReceiptLine."Account No.");
                            itm.TestField("Inventory Posting Group");
                            InvGroup.get(Itm."VAT Bus. Posting Gr. (Price)", itm."Gen. Prod. Posting Group");
                            GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                            GenJnlLine."Account No." := InvGroup."Sales Account";

                        end
                        else begin
                            GenJnlLine."Account Type" := ReceiptLine."Account Type";
                            GenJnlLine."Account No." := ReceiptLine."Account No.";
                        end;
                        GenJnlLine.Validate(GenJnlLine."Account No.");
                        GenJnlLine."External Document No." := ReceiptLine."Cheque/Deposit Slip No";
                        GenJnlLine."Currency Code" := ReceiptRec."Currency Code";
                        GenJnlLine.Validate(GenJnlLine."Currency Code");

                        GenJnlLine.Amount := -ReceiptLine.Amount;
                        GenJnlLine.Validate(GenJnlLine.Amount);

                        if ReceiptLine."Account Type" = ReceiptLine."Account Type"::Customer then begin
                            GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Invoice;
                            GenJnlLine."Applies-to Doc. No." := ReceiptLine."Applies-to Doc. No.";
                            GenJnlLine.Validate("Applies-to Doc. No.");
                            GenJnlLine."Applies-to ID" := ReceiptLine."Applies-to ID";
                            GenJnlLine.Validate(GenJnlLine."Applies-to ID");
                        end;

                        GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
                        GenJnlLine.Description := CopyStr(ReceiptLine."Account Name" + ':' + Format(ReceiptLine."Pay Mode") +
                          ' Invoices:' + StrInvoices, 1, 50);
                        GenJnlLine."Shortcut Dimension 1 Code" := ReceiptLine."Global Dimension 1 Code";
                        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                        GenJnlLine."Shortcut Dimension 2 Code" := ReceiptLine."Shortcut Dimension 2 Code";
                        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
                        GenJnlLine.ValidateShortcutDimCode(3, ReceiptRec."Shortcut Dimension 3 Code");
                        GenJnlLine.ValidateShortcutDimCode(4, ReceiptRec."Shortcut Dimension 4 Code");

                        if GenJnlLine.Amount <> 0 then GenJnlLine.Insert;
                    end
                    else
                        if ReceiptLine."Pay Mode" = ReceiptLine."Pay Mode"::Cheque then begin
                            if ReceiptLine."Cheque/Deposit Slip Date" <= Today then begin
                                GenJnlLine.Init;
                                GenJnlLine."Journal Template Name" := JTemplate;
                                GenJnlLine."Journal Batch Name" := JBatch;
                                GenJnlLine."Source Code" := 'CASHRECJNL';
                                GenJnlLine."Line No." := LineNo;
                                GenJnlLine."Posting Date" := ReceiptRec.Date;
                                GenJnlLine."Document Date" := ReceiptRec."Document Date";
                                GenJnlLine."Document No." := ReceiptLine.No;
                                GenJnlLine."Document Date" := ReceiptRec."Document Date";
                                if ReceiptLine."Customer Payment On Account" then begin
                                    SRSetup.Get();
                                    GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                                    // GenJnlLine."Account No." := SRSetup."Receivable Batch Account";
                                end
                                else begin
                                    GenJnlLine."Account Type" := ReceiptLine."Account Type";
                                    GenJnlLine."Account No." := ReceiptLine."Account No.";
                                end;
                                GenJnlLine.Validate(GenJnlLine."Account No.");
                                GenJnlLine."External Document No." := ReceiptLine."Cheque/Deposit Slip No";
                                GenJnlLine."Currency Code" := ReceiptRec."Currency Code";
                                GenJnlLine.Validate(GenJnlLine."Currency Code");

                                GenJnlLine.Amount := -ReceiptLine.Amount;
                                GenJnlLine.Validate(GenJnlLine.Amount);

                                if ReceiptLine."Customer Payment On Account" = false then begin
                                    //GenJnlLine."Applies-to Doc. Type":=GenJnlLine."Applies-to Doc. Type"::Invoice;
                                    GenJnlLine."Applies-to Doc. No." := ReceiptLine."Applies-to Doc. No.";
                                    GenJnlLine.Validate("Applies-to Doc. No.");
                                    GenJnlLine."Applies-to ID" := ReceiptLine."Applies-to ID";
                                    GenJnlLine.Validate(GenJnlLine."Applies-to ID");
                                end;
                                GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
                                GenJnlLine.Description := CopyStr(ReceiptLine."Account Name" + ':' + Format(ReceiptLine."Pay Mode")
                                + ' Invoices:' + StrInvoices, 1, 50);
                                GenJnlLine."Shortcut Dimension 1 Code" := ReceiptLine."Global Dimension 1 Code";
                                GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                                GenJnlLine."Shortcut Dimension 2 Code" := ReceiptLine."Shortcut Dimension 2 Code";
                                GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
                                GenJnlLine.ValidateShortcutDimCode(3, ReceiptRec."Shortcut Dimension 3 Code");
                                GenJnlLine.ValidateShortcutDimCode(4, ReceiptRec."Shortcut Dimension 4 Code");

                                if GenJnlLine.Amount <> 0 then GenJnlLine.Insert;
                            end;
                        end;
                    if ReceiptLine."VAT Amount" > 0 then begin
                        if Tarrif.Get(ReceiptLine."VAT Prod. Posting Group") then begin
                            if Tarrif."Sales VAT Account" <> '' then begin
                                GenJnlLine.Init;
                                GenJnlLine."Journal Template Name" := JTemplate;
                                GenJnlLine."Journal Batch Name" := JBatch;
                                GenJnlLine."Source Code" := 'CASHRECJNL';
                                GenJnlLine."Line No." := LineNo;
                                GenJnlLine."Posting Date" := ReceiptRec.Date;
                                GenJnlLine."Document No." := ReceiptLine.No;
                                GenJnlLine."Document Date" := ReceiptRec."Document Date";
                                GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                                GenJnlLine."Account No." := Tarrif."Sales VAT Account";
                                GenJnlLine.Validate(GenJnlLine."Account No.");
                                GenJnlLine."External Document No." := ReceiptLine."Cheque/Deposit Slip No";
                                GenJnlLine."Currency Code" := ReceiptRec."Currency Code";
                                GenJnlLine.Validate(GenJnlLine."Currency Code");

                                GenJnlLine.Amount := -ReceiptLine."VAT Amount";
                                GenJnlLine.Validate(GenJnlLine.Amount);

                                GenJnlLine."Bal. Account Type" := ReceiptLine."Account Type";
                                GenJnlLine."Bal. Account No." := ReceiptLine."Account No.";


                                GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
                                GenJnlLine.Description := CopyStr(ReceiptLine."Account Name" + ':' + Format(ReceiptLine."Pay Mode")
                                + ' Invoices:' + StrInvoices, 1, 50);
                                GenJnlLine."Shortcut Dimension 1 Code" := ReceiptLine."Global Dimension 1 Code";
                                GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                                GenJnlLine."Shortcut Dimension 2 Code" := ReceiptLine."Shortcut Dimension 2 Code";
                                GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
                                GenJnlLine.ValidateShortcutDimCode(3, ReceiptRec."Shortcut Dimension 3 Code");
                                GenJnlLine.ValidateShortcutDimCode(4, ReceiptRec."Shortcut Dimension 4 Code");

                                if GenJnlLine.Amount <> 0 then GenJnlLine.Insert;
                            end;
                        end;
                    end;

                until ReceiptLine.Next = 0;
            end;

            /*Post the transactions*/
            Post := false;
            GenJnlLine.Reset;
            GenJnlLine.SetRange(GenJnlLine."Journal Template Name", JTemplate);
            GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", JBatch);
            //Adjust Gen Jnl Exchange Rate Rounding Balances
            AdjustGenJnl.Run(GenJnlLine);
            //End Adjust Gen Jnl Exchange Rate Rounding Balances

            CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post", GenJnlLine);
            if JournalPosted.PostedSuccessfully(ReceiptRec."No.") then begin
                //Update Header
                ReceiptRec.Cashier := UserId;
                //"Bank Code":=USetup."Default Receipts Bank";
                ReceiptRec.Posted := true;
                ReceiptRec."Date Posted" := Today;
                ReceiptRec."Time Posted" := Time;
                ReceiptRec."Posted By" := UserId;
                ReceiptRec.Modify;


                if Confirm('Do you want to print the receipt for selected transaction?', false) then begin
                    Rcpt.Reset;
                    Rcpt.SetFilter(Rcpt."No.", ReceiptRec."No.");
                    if Rcpt.Find('-') then
                        page.Run(70135377, Rcpt);
                end;


                // Message('Receipt Posted Successfully');

            end;
        end;

    end;

    Procedure ReadFile()
    var

        MyFile: File;
        StreamInTest: InStream;
        Buffer: Text;
        MyFile2: File;
        MyOutStream: OutStream;
        char1: Char;
        char2: Char;
        SourceFile: Text;
        DestFile: Text;
    begin
        MyFile.OPEN(SourceFile);
        MyFile2.CREATE(DestFile);
        MyFile2.CREATEOUTSTREAM(MyOutStream);
        MyFile.CREATEINSTREAM(StreamInTest);
        char1 := 13;
        char2 := 10;
        WHILE NOT StreamInTest.EOS DO BEGIN
            StreamInTest.READTEXT(Buffer);
            /*  NAVObj.RESET;
             NAVObj.SETFILTER("New ID",'%1..%2',50000,99000753);
             IF NAVObj.FIND('-') THEN BEGIN
             REPEAT
               NewObj:='REPORT.RUN('+FORMAT(NAVObj."Old ID")+',';
               OldObj:='REPORT.RUN('+FORMAT(NAVObj."New ID")+',';
               Buffer:=ReplaceString(Buffer,OldObj,NewObj);  
             UNTIL NAVObj.NEXT=0;
             END; */

            MyOutStream.WRITETEXT(Buffer + FORMAT(char1) + FORMAT(char2));

            // Do some processing.  

        END;
        MyFile.CLOSE;
    end;


}