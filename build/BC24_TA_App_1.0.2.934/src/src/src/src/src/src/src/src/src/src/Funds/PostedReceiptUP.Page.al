page 51379 "Posted Receipt UP"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Receipts Header";
    SourceTableView = where("Posted Count" = filter(<> 0));
    UsageCategory = Documents;
    ApplicationArea = basic;
    layout
    {
        area(content)
        {
            group(Control1)
            {
                ShowCaption = false;
                field("No."; Rec."No.")
                {
                    Editable = false;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Document Date field.';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
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
                    ShowCaption = false;
                    ApplicationArea = basic;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = basic;
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
                    Editable = false;
                    ShowCaption = false;
                    ApplicationArea = basic;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 3 Code field.';
                }
                field(Dim3; Rec.Dim3)
                {
                    Editable = false;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Dim3 field.';
                }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 4 Code field.';
                }
                field(Dim4; Rec.Dim4)
                {
                    Editable = false;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Dim4 field.';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Currency Code field.';
                }
                field("Pay Mode"; Rec."Pay Mode")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Pay Mode field.';
                }
                field("Bank Code"; Rec."Bank Code")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Bank Code field.';
                }
                field("Bank Name"; Rec."Bank Name")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Bank Name field.';
                }
                field("Amount Recieved"; Rec."Amount Recieved")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Amount Recieved field.';
                }
                field("Received From"; Rec."Received From")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Received From field.';
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Total Amount field.';
                }
                field(Cashier; Rec.Cashier)
                {
                    Editable = false;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Cashier field.';
                }
                field("Date Posted"; Rec."Date Posted")
                {
                    Editable = false;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Date Posted field.';
                }
                field("Time Posted"; Rec."Time Posted")
                {
                    Editable = false;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Time Posted field.';
                }
                field(Posted; Rec.Posted)
                {
                    Editable = false;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Posted field.';
                }
                field("Surrender No"; Rec."Surrender No")
                {
                    Editable = false;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Surrender No field.';
                }
            }
            group(Lines)
            {
                Caption = 'Lines';
                part(Control1000000000; "Receipts Line Posted UP")
                {
                    ApplicationArea = basic;
                    Editable = false;
                    SubPageLink = No = FIELD("No.");
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Post)
            {
                Caption = 'Post';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;
                ToolTip = 'Executes the Post action.';

                trigger OnAction()
                begin
                    //Check Post Dated
                    if CheckPostDated then
                        Error('One of the Receipt Lines is Post Dated');

                    //Post the transaction into the database
                    PerformPost();
                end;
            }
            action(Print)
            {
                Caption = 'Print';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                Visible = true;
                ToolTip = 'Executes the Print action.';

                trigger OnAction()
                begin
                    //  if Posted = false then Error('Post the receipt before printing.');
                    Rec.Reset;
                    Rec.SetFilter("No.", Rec."No.");
                    REPORT.Run(50200, true, true, Rec);
                    Rec.Reset;
                end;
            }
        }
    }



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

    end;

    trigger OnOpenPage()
    begin

        UserSetup.Reset;

        if UserSetup.Get(UserId) then begin
            JTemplate := UserSetup."Receipt Journal Template";
            JBatch := UserSetup."Receipt Journal Batch";
        end;
        if (JTemplate = '') or (JBatch = '') then begin
            Error('Please contact the system administrator to be setup as a receipting user');
        end;
        //if UserSetup."Default Receipts Bank" = '' then;
        // SetFilter(Status, ' ');
        /*
       //***************************JACK***************************/
        // SETRANGE("Created By", USERID);
        /*   IF UserMgt.GetSalesFilter() <> '' THEN BEGIN
              FILTERGROUP(2);
              SETRANGE("Responsibility Center", UserMgt.GetSalesFilter());
              FILTERGROUP(0);
          END; */

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

        Rec.TestField(Date, WorkDate);

        USetup.Reset;
        USetup.SetRange(USetup.UserID, UserId);
        if USetup.FindFirst then begin
            if USetup."Receipt Journal Template" = '' then begin
                Error('Please ensure that the Administrator sets you up as a cashier');
            end;
            if USetup."Receipt Journal Batch" = '' then begin
                Error('Please ensure that the Administrator sets you up as a cashier');
            end;
            if USetup."Default Receipts Bank" = '' then begin
                Error('Please ensure that the Administrator sets you up as a cashier');
            end;
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
        Rec."Bank Code" := USetup."Default Receipts Bank";
        Rec.Validate("Bank Code");
        //check if the person received from has been selected
        Rec.TestField(Date);
        Rec.TestField("Bank Code");
        Rec.TestField("Global Dimension 1 Code");
        Rec.TestField("Shortcut Dimension 2 Code");
        Rec.TestField("Received From");
        /*Check if the amount received is equal to the total amount*/
        tAmount := 0;

        ReceiptLine.Reset;
        ReceiptLine.SetRange(ReceiptLine.No, Rec."No.");
        if ReceiptLine.Find('-') then begin
            repeat
                if ReceiptLine."Pay Mode" = ReceiptLine."Pay Mode"::"Deposit Slip" then begin
                    if ReceiptLine."Cheque/Deposit Slip No" = '' then begin
                        Error('The Cheque/Deposit Slip No must be inserted');
                    end;
                    if ReceiptLine."Cheque/Deposit Slip Date" = 0D then begin
                        Error('The Cheque/Deposit Date must be inserted');
                    end;
                    if ReceiptLine."Transaction No." = '' then begin
                        Error('Please ensure that the Transaction Number is inserted');
                    end;
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
            GenJnlLine."Document No." := Rec."No.";
            GenJnlLine."Document Date" := Rec."Document Date";
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::"Bank Account";

            GenJnlLine."Account No." := USetup."Default Receipts Bank";
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

            GenJnlLine.Description := CopyStr('On Behalf Of:' + Rec."Received From" + 'Invoices:' + StrInvoices, 1, 50);
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
                            GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Invoice;
                            GenJnlLine."Applies-to ID" := ReceiptLine."Apply to ID";
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
                                GenJnlLine."Document No." := ReceiptLine.No;
                                GenJnlLine."Document Date" := Rec."Document Date";
                                if ReceiptLine."Customer Payment On Account" then begin
                                    SRSetup.Get();
                                    GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                                    //  GenJnlLine."Account No." := SRSetup."Receivable Batch Account";
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
                                    GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Invoice;
                                    GenJnlLine."Applies-to ID" := ReceiptLine."Apply to ID";
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
                until ReceiptLine.Next = 0;
            end;

            /*Post the transactions*/
            Post := false;
            GenJnlLine.Reset;
            GenJnlLine.SetRange(GenJnlLine."Journal Template Name", JTemplate);
            GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", JBatch);
            CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post", GenJnlLine);
            if JournalPosted.PostedSuccessfully(Rec."No.") then begin
                //Update Header
                Rec.Cashier := UserId;
                Rec."Bank Code" := USetup."Default Receipts Bank";
                Rec.Posted := true;
                Rec."Date Posted" := Today;
                Rec."Time Posted" := Time;
                Rec."Posted By" := UserId;

                //Update Lines
                ReceiptLine.Reset;
                ReceiptLine.SetRange(ReceiptLine.No, Rec."No.");
                ReceiptLine.SetRange(ReceiptLine.Posted, false);
                if ReceiptLine.Find('-') then begin
                    repeat
                        ReceiptLine.Posted := true;
                        ReceiptLine."Date Posted" := Today;
                        ReceiptLine."Time Posted" := Time;
                        ReceiptLine."Posted By" := UserId;
                        ReceiptLine.Modify;
                    until ReceiptLine.Next = 0;
                end;

            end;
        end;
        Message('Receipt Posted Successfully');

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

    trigger OnAfterGetCurrRecord()
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
}

