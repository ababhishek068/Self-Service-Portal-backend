page 50862 "Receipt Header UP"
{
    Caption = 'Receipt';
    DeleteAllowed = false;
    UsageCategory = Documents;
    ApplicationArea = all;
    PageType = Card;
    SourceTable = "Receipts Header";
    SourceTableView = WHERE(Posted = CONST(false));

    layout
    {
        area(content)
        {
            group(Control1)
            {
                ShowCaption = false;
                field("No."; Rec."No.")
                {
                    Caption = 'No.';
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the No. field.';

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
                }
                field(Date; Rec.Date)
                {
                    Caption = 'Receipt Date';
                    Editable = true;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Receipt Date field.';
                }
                field("Document Date"; Rec."Document Date")
                {
                    Caption = 'Deposit Date';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Deposit Date field.';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {

                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                    trigger OnValidate()
                    begin
                        FunctionName := '';
                        DimVal.Reset;
                        DimVal.SetRange(DimVal."Global Dimension No.", 1);
                        DimVal.SetRange(DimVal.Code, Rec."Global Dimension 1 Code");
                        if DimVal.Find('-') then begin
                            FunctionName := DimVal.Name;
                        end;
                    end;
                }
                field(FunctionName; FunctionName)
                {
                    Editable = false;
                    CaptionClass = FunctionName;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the FunctionName field.';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';

                    trigger OnValidate()
                    begin
                        BudgetCenterName := '';
                        DimVal.Reset;
                        DimVal.SetRange(DimVal."Global Dimension No.", 2);
                        DimVal.SetRange(DimVal.Code, Rec."Shortcut Dimension 2 Code");
                        if DimVal.Find('-') then begin
                            BudgetCenterName := DimVal.Name;
                        end;
                    end;
                }
                field(BudgetCenterName; BudgetCenterName)
                {
                    ApplicationArea = all;
                    Editable = false;
                    CaptionClass = BudgetCenterName;
                    ToolTip = 'Specifies the value of the BudgetCenterName field.';
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = all;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Responsibility Center field.';
                }
                field("Pay Mode"; Rec."Pay Mode")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Pay Mode field.';
                }
                field("Bank Code"; Rec."Bank Code")
                {
                    // Editable = multibankUser;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Bank Code field.';
                }
                field("Bank Name"; Rec."Bank Name")
                {
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Bank Name field.';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Currency Code field.';
                }

                field("Negotiated Exchange Rate"; Rec."Negotiated Exchange Rate")
                {
                    Editable = true;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Negotiated Exchange Rate field.';
                }

                field("Amount Recieved"; Rec."Amount Recieved")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Amount Recieved field.';
                }
                field("Received From"; Rec."Received From")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Received From field.';
                }
                field(Description; Description)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies reason for recipting the monies';
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Total Amount field.';
                }
                field(Cashier; Rec.Cashier)
                {
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Cashier field.';
                }
                field("Date Posted"; Rec."Date Posted")
                {
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Date Posted field.';
                }
                field("Time Posted"; Rec."Time Posted")
                {
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Time Posted field.';
                }


                field("Cash Mode"; Rec."Cash Mode")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Cash Mode field.';
                }
                field("Cheque No."; Rec."Cheque No.")
                {
                    Caption = 'Transaction No';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Transaction No field.';
                }
                field(Posted; Rec.Posted)
                {
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Posted field.';
                }
            }
            group(Lines)
            {
                Caption = 'Lines';
                part(Control1000000000; "Receipts Line UP")
                {
                    ApplicationArea = all;
                    SubPageLink = No = FIELD("No.");
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Print)
            {
                Caption = 'Print';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = all;
                ToolTip = 'Executes the Print action.';

                trigger OnAction()
                var
                    //ReceiptReport: Report Receipt;
                    ReceiptHeader: Record "Receipts Header";
                begin
                    //IF Posted=FALSE THEN ERROR('Post the receipt before printing.');
                    ReceiptHeader.Reset();
                    ReceiptHeader.SetRange("No.", Rec."No.");
                    if ReceiptHeader.FindFirst() then begin
                        report.Run(50358, true, false, Rec);
                        //ReceiptReport.SetTableView(Rec);
                        //ReceiptReport.Run();
                    end;
                end;
            }
            action("SalesInv")
            {
                ApplicationArea = Basic;
                Image = Print;
                Caption = 'Print Cash Sale Receipt';
                Promoted = true;
                Visible = false;
                PromotedCategory = Report;
                PromotedIsBig = true;
                ToolTip = 'Executes the Print Cash Sale Receipt action.';
                trigger OnAction()
                var
                    SalesInv: Record "Sales Invoice Header";
                    DelNote: report "Sales - Invoice Cust";

                begin
                    SalesInv.reset;
                    SalesInv.setfilter("No.", Rec."Invoice No");
                    if SalesInv.find('-') then begin
                        DelNote.SetTableView(SalesInv);
                        DelNote.Run();
                    end

                end;
            }
            action(Post)
            {
                Caption = 'Post';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = all;
                ToolTip = 'Executes the Post action.';

                trigger OnAction()
                begin
                    Rec.CalcFields("Posted Count");
                    if Rec."Posted Count" > 0 then begin
                        Rec.Status := Rec.Status::Posted;
                        Rec.Posted := true;
                        Rec.Modify;
                        Error('Posted entries exists in the ledger for the selected document');
                    end;

                    //Check Post Dated
                    if CheckPostDated then
                        Error('One of the Receipt Lines is Post Dated');

                    // Check unsurrendered receipts
                    if BankAcc.Get(Rec."Bank Code") then begin
                        if (BankAcc."Bank Type" = BankAcc."Bank Type"::"Chq Collection") and (Rec."Pay Mode" = Rec."Pay Mode"::Cash) then begin
                            BankAcc.SetFilter("Date Filter", '..%1', CalcDate('-1D', Today));
                            BankAcc.CalcFields(Balance);
                            if (BankAcc.Balance > 50000) then Error('Please note that you have unsurrendered receipts which are more than 24hrs old');
                        end;
                    end;
                    //Post the transaction into the database
                    PerformPost();

                    Rec.CalcFields("Posted Count");
                    if Rec."Posted Count" > 0 then begin
                        PostItems();
                        Rec.Cashier := UserId;
                        //"Bank Code":=USetup."Default Receipts Bank";
                        Rec.Posted := true;
                        Rec."Date Posted" := Today;
                        Rec."Time Posted" := Time;
                        Rec."Posted By" := UserId;
                        Rec.Modify;
                    end;
                    if Rec."Posted Count" > 0 then begin
                        Rec.Cashier := UserId;
                        //"Bank Code":=USetup."Default Receipts Bank";
                        Rec.Posted := true;
                        Rec."Date Posted" := Today;
                        Rec."Time Posted" := Time;
                        Rec."Posted By" := UserId;
                        Rec.Modify;
                    end;



                end;
            }
            separator(Separator13) { }
            action("Cancel Document")
            {
                Image = Cancel;
                ApplicationArea = all;
                ToolTip = 'Executes the Cancel Document action.';

                trigger OnAction()
                begin
                    if Confirm('Do you really want to cancel the document?', false) then begin
                        Rec.Status := Rec.Status::Cancelled;
                        Rec."Posted By" := UserId;
                        Rec.Modify;
                    end;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        OnAfterGetCurrRecord;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        //********************************JACK**********************************//
        Rcpt.Reset;
        Rcpt.SetRange(Rcpt.Posted, false);
        Rcpt.SetRange(Rcpt."Created By", UserId);
        if Rcpt.Count > 0 then begin
            if Confirm('There are still some unposted receipts. Continue?', false) = false then begin
                Error('There are still some unposted receipts. Please utilise them first');
            end;
        end;
        //********************************END **********************************//
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Responsibility Center" := UserMgt.GetSalesFilter();
        //Add dimensions if set by default here
        Rec."Global Dimension 1 Code" := UserMgt.GetSetDimensions(UserId, 1);
        Rec."Shortcut Dimension 2 Code" := UserMgt.GetSetDimensions(UserId, 2);
        Rec."Shortcut Dimension 3 Code" := UserMgt.GetSetDimensions(UserId, 3);
        Rec.Validate("Shortcut Dimension 3 Code");
        Rec."Shortcut Dimension 4 Code" := UserMgt.GetSetDimensions(UserId, 4);
        Rec.Validate("Shortcut Dimension 4 Code");
        Rec.Date := Today;
        // "Global Dimension 1 Code" := 'MAIN';
        // "Responsibility Center" := 'MAIN';
        OnAfterGetCurrRecord;

        multibankUser := false;
        if mUserSetup.Get(UserId) then begin
            if mUserSetup."Multiple Banks" = true then multibankUser := true else multibankUser := false;
        end;
    end;

    trigger OnOpenPage()
    begin

        multibankUser := false;
        if mUserSetup.Get(UserId) then begin
            if mUserSetup."Multiple Banks" = true then multibankUser := true else multibankUser := false;
        end;


        UserSetup.Reset;

        if UserSetup.Get(UserId) then begin
            JTemplate := UserSetup."Receipt Journal Template";
            JBatch := UserSetup."Receipt Journal Batch";

        end;
        if (JTemplate = '') or (JBatch = '') then begin
            Error('Please contact the system administrator to be setup as a receipting user');
        end;
        if UserSetup."Default Receipts Bank" = '' then;
        Rec.SetFilter(Status, ' ');

        //***************************JACK***************************//
        // SETRANGE("Created By",USERID);
        /*
       IF UserMgt.GetSalesFilter() <> '' THEN BEGIN
         FILTERGROUP(2);
         SETRANGE("Responsibility Center",UserMgt.GetSalesFilter());
         FILTERGROUP(0);
       END;
        */
        //***************************END ***************************//

    end;

    var
        GenJnlLine: Record "Gen. Journal Line";
        ReceiptLine: Record "Receipt Line q";
        tAmount: Decimal;
        DefaultBatch: Record "Gen. Journal Batch";
        FunctionName: Text[100];
        BudgetCenterName: Text[100];
        BankName: Text[100];
        Rcpt: Record "Receipts Header";
        DimVal: Record "Dimension Value";
        BankAcc: Record "Bank Account";
        UserSetup: Record "Cash Office User Template";
        JTemplate: Code[10];
        JBatch: Code[10];
        GLine: Record "Gen. Journal Line";
        LineNo: Integer;
        BAmount: Decimal;
        SRSetup: Record "Sales & Receivables Setup";
        Post: Boolean;
        USetup: Record "Cash Office User Template";
        StrInvoices: Text[250];
        Appl: Record "CshMgt Application";
        UserMgt: Codeunit "User Setup Management BR";
        JournalPosted: Codeunit "Journal Post Successful";
        AdjustGenJnl: Codeunit "Adjust Gen. Journal Balance";
        IsCashAccount: Boolean;
        VAmount: Decimal;
        Tarrif: Record "VAT Posting Setup";
        //  BankBuff: Record "Bank Transactions Buffer";
        multibankUser: Boolean;
        mUserSetup: Record "User Setup";
        Itm: Record Item;
        InvGroup: Record "General Posting Setup";
        CashOfficeSetup: Record "Cash Office Setup";
        PostREceiptLater: Boolean;

        recCurrency: Record "Currency Exchange Rate";

    procedure PerformPost()
    begin

        //get all the invoices that have been paid for using the receipt
        StrInvoices := '';
        Appl.Reset;
        Appl.SetRange(Appl."Document Type", Appl."Document Type"::Receipt);
        Appl.SetRange(Appl."Document No.", Rec."No.");
        if Appl.FindFirst then begin
            repeat
                StrInvoices := StrInvoices + ',' + Appl."Appl. Doc. No";
            until Appl.Next = 0;
        end;

        CashOfficeSetup.Get();
        PostREceiptLater := CashOfficeSetup."Receipts Posted Later";

        If PostREceiptLater = false then begin  // Added to allow for those who posts receipts later.
                                                //Cater for Cash Accounts
            IsCashAccount := false;
            BankAcc.Reset;
            if BankAcc.Get(Rec."Bank Code") then begin
                if BankAcc."Bank Type" = BankAcc."Bank Type"::Cash then
                    IsCashAccount := true;
            end;

            if IsCashAccount then begin
                CashOfficeSetup.get();
                if NOT CashOfficeSetup."Receipts Posted Later" then
                    Rec.TestField(Date, WorkDate);
            end;
            //End Cater for Cash Account
        end;


        USetup.Reset;
        USetup.SetRange(USetup.UserID, UserId);
        if USetup.FindFirst then begin
            if USetup."Receipt Journal Template" = '' then begin
                Error('Please ensure that the Administrator sets you up as a cashier');
            end;
            if USetup."Receipt Journal Batch" = '' then begin
                Error('Please ensure that the Administrator sets you up as a cashier');
            end;
            if USetup."Default Receipts Bank" = '' then;
        end
        else begin
            Error('Please ensure that the Administrator sets you up as a cashier');
        end;


        //check if the receipt has any post dated cheques.
        //check if the amounts are similar

        Rec.CalcFields("Total Amount");
        if Rec."Total Amount" <> Rec."Amount Recieved" then begin
            Error('Please note that the Total Amount and the Amount Received Must be the same');
        end;

        //if any then the amount to be posted must be less the post dated amount
        if Rec.Posted = true then begin
            Error('A Transaction Posted cannot be posted again');
        end;

        //check if the person received from has been selected
        Rec.TestField(Date);
        Rec.TestField("Bank Code");
        Rec.TestField("Global Dimension 1 Code");
        Rec.TestField("Shortcut Dimension 2 Code");
        Rec.TestField("Received From");
        /*Check if the amount received is equal to the total amount*/
        tAmount := 0;

        //Check Bank
        CheckBnkCurrency(Rec."Bank Code", Rec."Currency Code");

        //----adjust currency---
        if Rec."Negotiated Exchange Rate" <> 0 then begin
            recCurrency.Reset();
            recCurrency.SetRange(recCurrency."Starting Date", Rec.Date);
            recCurrency.SetRange(recCurrency."Currency Code", Rec."Currency Code");
            if recCurrency.Find('-') then begin
                recCurrency."Relational Exch. Rate Amount" := Rec."Negotiated Exchange Rate";
                recCurrency."Adjustment Exch. Rate Amount" := Rec."Negotiated Exchange Rate";
                recCurrency."Relational Adjmt Exch Rate Amt" := Rec."Negotiated Exchange Rate";
                recCurrency.Modify;
            end else begin
                recCurrency.Init();
                recCurrency."Starting Date" := Rec.Date;
                recCurrency."Currency Code" := Rec."Currency Code";
                recCurrency."Exchange Rate Amount" := 1;
                recCurrency."Relational Exch. Rate Amount" := Rec."Negotiated Exchange Rate";
                recCurrency."Adjustment Exch. Rate Amount" := Rec."Negotiated Exchange Rate";
                recCurrency."Relational Adjmt Exch Rate Amt" := Rec."Negotiated Exchange Rate";
                recCurrency.Insert();
            end;
        end;

        ReceiptLine.Reset;
        ReceiptLine.SetRange(ReceiptLine.No, Rec."No.");
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
            GenJnlLine."Posting Date" := Rec.Date;
            GenJnlLine."Document Date" := Rec."Document Date";
            GenJnlLine."Document No." := Rec."No.";
            GenJnlLine."External Document No." := ReceiptLine."Cheque/Deposit Slip No";
            GenJnlLine."Document Date" := Rec."Document Date";
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::"Bank Account";

            GenJnlLine."Account No." := Rec."Bank Code";//USetup."Default Receipts Bank";
            GenJnlLine.Validate(GenJnlLine."Account No.");
            GenJnlLine."Currency Code" := Rec."Currency Code";
            GenJnlLine.Validate(GenJnlLine."Currency Code");
            GenJnlLine.Amount := (tAmount);
            GenJnlLine.Validate(GenJnlLine.Amount);

            GenJnlLine."Shortcut Dimension 1 Code" := Rec."Global Dimension 1 Code";
            GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
            GenJnlLine."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
            GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
            GenJnlLine.ValidateShortcutDimCode(3, Rec."Shortcut Dimension 3 Code");
            GenJnlLine.ValidateShortcutDimCode(4, Rec."Shortcut Dimension 4 Code");

            GenJnlLine.Description := Rec."Received From";
            GenJnlLine.Validate(GenJnlLine.Description);
            if GenJnlLine.Amount <> 0 then
                GenJnlLine.Insert;




            //insert the transaction lines into the database
            ReceiptLine.Reset;
            ReceiptLine.SetRange(ReceiptLine.No, Rec."No.");
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
                        GenJnlLine."Posting Date" := Rec.Date;
                        GenJnlLine."Document No." := ReceiptLine.No;
                        GenJnlLine."Document Date" := Rec."Document Date";
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
                        GenJnlLine."Currency Code" := Rec."Currency Code";
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
                        GenJnlLine.ValidateShortcutDimCode(3, Rec."Shortcut Dimension 3 Code");
                        GenJnlLine.ValidateShortcutDimCode(4, Rec."Shortcut Dimension 4 Code");

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
                                GenJnlLine."Posting Date" := Rec.Date;
                                GenJnlLine."Document Date" := Rec."Document Date";
                                GenJnlLine."Document No." := ReceiptLine.No;
                                GenJnlLine."Document Date" := Rec."Document Date";
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
                                GenJnlLine."Currency Code" := Rec."Currency Code";
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
                                GenJnlLine.ValidateShortcutDimCode(3, Rec."Shortcut Dimension 3 Code");
                                GenJnlLine.ValidateShortcutDimCode(4, Rec."Shortcut Dimension 4 Code");

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
                                GenJnlLine."Posting Date" := Rec.Date;
                                GenJnlLine."Document No." := ReceiptLine.No;
                                GenJnlLine."Document Date" := Rec."Document Date";
                                GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                                GenJnlLine."Account No." := Tarrif."Sales VAT Account";
                                GenJnlLine.Validate(GenJnlLine."Account No.");
                                GenJnlLine."External Document No." := ReceiptLine."Cheque/Deposit Slip No";
                                GenJnlLine."Currency Code" := Rec."Currency Code";
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
                                GenJnlLine.ValidateShortcutDimCode(3, Rec."Shortcut Dimension 3 Code");
                                GenJnlLine.ValidateShortcutDimCode(4, Rec."Shortcut Dimension 4 Code");

                                if GenJnlLine.Amount <> 0 then GenJnlLine.Insert;
                            end;
                        end;
                    end;

                until ReceiptLine.Next = 0;
            end;

            // /*Post the transactions*/
            Post := false;
            GenJnlLine.Reset;
            GenJnlLine.SetRange(GenJnlLine."Journal Template Name", JTemplate);
            GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", JBatch);
            //Adjust Gen Jnl Exchange Rate Rounding Balances
            AdjustGenJnl.Run(GenJnlLine);
            //End Adjust Gen Jnl Exchange Rate Rounding Balances

            CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post", GenJnlLine);
            if JournalPosted.PostedSuccessfully(Rec."No.") then begin
                //Update Header
                Rec.Cashier := UserId;
                //"Bank Code":=USetup."Default Receipts Bank";
                Rec.Posted := true;
                Rec."Date Posted" := Today;
                Rec."Time Posted" := Time;
                Rec."Posted By" := UserId;
                Rec.Modify;


                if Confirm('Do you want to print the receipt for selected transaction?', false) then begin
                    Rcpt.Reset;
                    Rcpt.SetFilter(Rcpt."No.", Rec."No.");
                    if Rcpt.Find('-') then
                        page.Run(50903, Rcpt);
                end;


                // Message('Receipt Posted Successfully');

            end;
        end;

    end;

    procedure PerformPostLine()
    begin
    end;

    procedure CheckPostDated() Exists: Boolean
    begin
        //get the sum total of the post dated cheques is any
        //reset the bank amount first
        Exists := false;
        BAmount := 0;
        ReceiptLine.Reset;
        ReceiptLine.SetRange(ReceiptLine.No, Rec."No.");
        ReceiptLine.SetRange(ReceiptLine."Pay Mode", ReceiptLine."Pay Mode"::Cheque);
        if ReceiptLine.Find('-') then begin
            repeat
                if ReceiptLine."Cheque/Deposit Slip Date" > Today then begin
                    Exists := true;
                    exit;
                    //cheque is post dated
                    // BAmount:=BAmount + ReceiptLine.Amount;
                end;
            until ReceiptLine.Next = 0;
        end;
    end;

    procedure CheckBnkCurrency(BankAcc: Code[20]; CurrCode: Code[20])
    var
        BankAcct: Record "Bank Account";
    begin
        BankAcct.Reset;
        BankAcct.SetRange(BankAcct."No.", BankAcc);
        if BankAcct.Find('-') then begin
            if BankAcct."Currency Code" <> CurrCode then begin
                if BankAcct."Currency Code" = '' then
                    Error('This bank [%1:- %2] can only transact in LOCAL Currency', BankAcct."No.", BankAcct.Name)
                else
                    Error('This bank [%1:- %2] can only transact in %3', BankAcct."No.", BankAcct.Name, BankAcct."Currency Code");
            end;
        end;
    end;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        FunctionName := '';
        DimVal.Reset;
        DimVal.SetRange(DimVal."Global Dimension No.", 1);
        DimVal.SetRange(DimVal.Code, Rec."Global Dimension 1 Code");
        if DimVal.Find('-') then begin
            FunctionName := DimVal.Name;
        end;
        BudgetCenterName := '';
        DimVal.Reset;
        DimVal.SetRange(DimVal."Global Dimension No.", 2);
        DimVal.SetRange(DimVal.Code, Rec."Shortcut Dimension 2 Code");
        if DimVal.Find('-') then begin
            BudgetCenterName := DimVal.Name;
        end;
        BankName := '';
        BankAcc.Reset;
        BankAcc.SetRange(BankAcc."No.", Rec."Bank Code");
        if BankAcc.Find('-') then begin
            BankName := BankAcc.Name;
        end;
    end;

    Procedure PostItems()
    var
        ItemJnlLine: Record "Item Journal Line";
        RecLine: record "Receipt Line q";
        UserTemp: Record "Cash Office User Template";
    begin
        UserTemp.get(Database.UserId);

        ItemJnlLine.reset;
        ItemJnlLine.setrange("Journal Template Name", UserTemp."Item Template");
        ItemJnlLine.setrange("Journal Batch Name", UserTemp."Item Batch");
        if ItemJnlLine.Find('-') then
            ItemJnlLine.DeleteAll();

        RecLine.reset;
        RecLine.setrange(RecLine.No, Rec."No.");
        RecLine.setrange(RecLine."Account Type", RecLine."Account Type"::Item);
        if RecLine.find('-') then begin
            UserTemp.TestField("Item Template");
            UserTemp.TestField("Item Batch");
            repeat
                ItemJnlLine.Init;
                ItemJnlLine."Journal Template Name" := UserTemp."Item Template";
                ItemJnlLine."Journal Batch Name" := UserTemp."Item Batch";
                ItemJnlLine."Line No." := LineNo;
                ItemJnlLine."Posting Date" := Today;
                ItemJnlLine."Document No." := Rec."No.";
                ItemJnlLine."Item No." := RecLine."Account No.";
                ItemJnlLine.Validate(ItemJnlLine."Item No.");
                ItemJnlLine."Location Code" := RecLine."Location Code";
                ItemJnlLine.Validate(ItemJnlLine."Location Code");
                ItemJnlLine.Quantity := RecLine.Quantity;
                ItemJnlLine.Validate(ItemJnlLine.Quantity);
                // ItemJnlLine."Unit of Measure Code" := PharmLine."Measuring Unit";
                // ItemJnlLine.Validate(ItemJnlLine."Unit of Measure Code");

                ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::Sale;
                ItemJnlLine."Unit Amount" := RecLine."Total Amount";

                ItemJnlLine.validate("Unit Amount");
                ItemJnlLine."Shortcut Dimension 1 Code" := Recline."Global Dimension 1 Code";
                ItemJnlLine."Shortcut Dimension 2 Code" := Recline."Shortcut Dimension 2 Code";
                ItemJnlLine.VALIDATE(ItemJnlLine."Unit Amount");
                ItemJnlLine.Validate("Shortcut Dimension 1 Code");
                ItemJnlLine.Validate("Shortcut Dimension 2 Code");
                // ItemJnlLine."External Document No." := PharmLine."Pharmacy No.";
                //  ItemJnlLine."Source No." := Patient."Patient No.";
                ItemJnlLine.Insert();
            until RecLine.next = 0;
        end;
        ItemJnlLine.Reset;
        ItemJnlLine.SetRange("Journal Template Name", UserTemp."Item Template");
        ItemJnlLine.SetRange("Journal Batch Name", UserTemp."Item Batch");
        // ItemJnlLine.SetRange(ItemJnlLine."External Document No.", PharmacyNo);
        if ItemJnlLine.Find('-') then
            CODEUNIT.Run(CODEUNIT::"Item Jnl.-Post Batch", ItemJnlLine);
    end;


}

