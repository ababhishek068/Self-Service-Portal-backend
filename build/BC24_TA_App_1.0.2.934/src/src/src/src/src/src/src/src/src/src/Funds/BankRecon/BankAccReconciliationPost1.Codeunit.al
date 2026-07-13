Codeunit 50005 "Bank Acc. Reconciliation Post1"
{
    Permissions = TableData "Bank Account Ledger Entry" = rm,
                  TableData "Check Ledger Entry" = rm,
                  TableData "Bank Account Statement" = ri,
                  TableData "Bank Account Statement Line" = ri,
                  TableData "Posted Payment Recon. Hdr" = ri;
    TableNo = "Bank Acc. Reconciliation";

    trigger OnRun()
    begin
        Window.Open(
          '#1#################################\\' +
          Text000);
        Window.Update(1, StrSubstNo('%1 %2', Rec."Bank Account No.", Rec."Statement No."));

        InitPost(Rec);
        //Insert entries to Posted Bank Account Ledger Entries
        PostToPostedBankAccLedgerEntry(Rec);
        Post(Rec);
        //End of Inserting
        FinalizePost(Rec);

        Window.Close;

        Commit;
    end;

    var
        Text000: label 'Posting lines              #2######';
        Text001: label '%1 is not equal to Total Balance.';
        Text002: label 'There is nothing to post.';
        Text003: label 'The application is not correct. The total amount applied is %1; it should be %2.';
        Text004: label 'The total difference is %1. It must be %2.';
        BankAcc: Record "Bank Account";
        BankAccLedgEntry: Record "Bank Account Ledger Entry";
        CheckLedgEntry: Record "Check Ledger Entry";
        GenJnlLine: Record "Gen. Journal Line";
        SourceCodeSetup: Record "Source Code Setup";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        Window: Dialog;
        SourceCode: Code[10];
        TotalAmount: Decimal;
        TotalAppliedAmount: Decimal;
        TotalDiff: Decimal;
        Lines: Integer;
        Difference: Decimal;
        ExcessiveAmtErr: label 'You must apply the excessive amount of %1 %2 manually.', Comment = '%1 a decimal number, %2 currency code';
        PostPaymentsOnly: Boolean;
        NotFullyAppliedErr: label 'One or more payments are not fully applied.\\The sum of applied amounts is %1. It must be %2.', Comment = '%1 - total applied amount, %2 - total transaction amount';
        LineNoTAppliedErr: label 'The line with transaction date %1 and transaction text ''%2'' is not applied. You must apply all lines.', Comment = '%1 - transaction date, %2 - arbitrary text';
        StatementAmount_2: Decimal;

    local procedure InitPost(BankAccRecon: Record "Bank Acc. Reconciliation")
    begin
        case BankAccRecon."Statement Type" of
            BankAccRecon."statement type"::"Bank Reconciliation":
                begin
                    BankAccRecon.TestField("Statement Date");
                    CheckLinesMatchEndingBalance(BankAccRecon, Difference);
                end;
            BankAccRecon."statement type"::"Payment Application":
                begin
                    SourceCodeSetup.Get;
                    SourceCode := SourceCodeSetup."Payment Reconciliation Journal";
                    //PostPaymentsOnly := "Post Payments Only";
                end;
        end;
    end;

    local procedure Post(BankAccRecon: Record "Bank Acc. Reconciliation")
    var
        BankAccReconLine: Record "Bank Acc. Reconciliation Line";
        AppliedAmount: Decimal;
        TotalTransAmtNotAppliedErr: Text;
    begin
        // Run through lines
        BankAccReconLine.FilterBankRecLines(BankAccRecon);
        TotalAmount := 0;
        TotalAppliedAmount := 0;
        TotalDiff := 0;
        Lines := 0;
        if BankAccReconLine.IsEmpty then
            Error(Text002);
        BankAccLedgEntry.LockTable;
        CheckLedgEntry.LockTable;

        if BankAccReconLine.FindSet then
            repeat
                Lines := Lines + 1;
                Window.Update(2, Lines);
                AppliedAmount := 0;
                // Adjust entries
                // Test amount and settled amount
                case BankAccRecon."Statement Type" of
                    BankAccRecon."statement type"::"Bank Reconciliation":
                        //case BankAccReconLine.Type of
                            //BankAccReconLine.Type::"Bank Account Ledger Entry":
                                CloseBankAccLedgEntry(BankAccReconLine, AppliedAmount);
                            //BankAccReconLine.Type::"Check Ledger Entry":
                                //CloseCheckLedgEntry(BankAccReconLine, AppliedAmount);
                           // BankAccReconLine.Type::Difference:
                                //TotalDiff += BankAccReconLine."Statement Amount";
                      
                    BankAccRecon."statement type"::"Payment Application":
                        PostPaymentApplications(BankAccReconLine, AppliedAmount);
                end;
            /*BankAccReconLine.TESTFIELD("Applied Amount",AppliedAmount);
            TotalAmount += BankAccReconLine."Statement Amount";
            TotalAppliedAmount += AppliedAmount;*/
            until BankAccReconLine.Next = 0;

        // Test amount
        if BankAccRecon."Statement Type" = BankAccRecon."statement type"::"Payment Application" then
            TotalTransAmtNotAppliedErr := NotFullyAppliedErr
        else
            TotalTransAmtNotAppliedErr := Text003;

        if TotalAmount <> TotalAppliedAmount + TotalDiff then
            //if difference is more than 2 OR less than 2
            // IF (TotalAmount-(TotalAppliedAmount + TotalDiff)>2)  OR ((TotalAmount-(TotalAppliedAmount + TotalDiff))<-2) THEN
            //ERROR(
            // TotalTransAmtNotAppliedErr,
            // TotalAppliedAmount + TotalDiff,TotalAmount);
            if Difference <> TotalDiff then
                ////if difference is more than 2 OR less than 2
                if ((Difference - TotalDiff) > 2) or ((Difference - TotalDiff) < -2) then
                    Error(Text004, Difference, TotalDiff);

        // Get bank
        UpdateBank(BankAccRecon, TotalAmount);

        case BankAccRecon."Statement Type" of
            BankAccRecon."statement type"::"Bank Reconciliation":
                TransferToBankStmt(BankAccRecon);
            BankAccRecon."statement type"::"Payment Application":
                TransferToPostPmtAppln(BankAccRecon);
        end;

    end;

    local procedure FinalizePost(BankAccRecon: Record "Bank Acc. Reconciliation")
    var
        BankAccReconLine: Record "Bank Acc. Reconciliation Line";
        AppliedPmtEntry: Record "Applied Payment Entry";
    begin
        // Delete statement
        if BankAccReconLine.LinesExist(BankAccRecon) then
            repeat
                AppliedPmtEntry.FilterAppliedPmtEntry(BankAccReconLine);
                AppliedPmtEntry.DeleteAll;

                BankAccReconLine.Delete;
                BankAccReconLine.ClearDataExchEntries;
            until BankAccReconLine.Next = 0;

        BankAccRecon.Find;
        BankAccRecon.Delete;
    end;

    local procedure CheckLinesMatchEndingBalance(BankAccRecon: Record "Bank Acc. Reconciliation"; var Difference: Decimal)
    var
        BankAccReconLine: Record "Bank Acc. Reconciliation Line";
    begin
        BankAccReconLine.LinesExist(BankAccRecon);
        BankAccReconLine.CalcSums("Statement Amount", Difference);
        //<<<
        StatementAmount_2 := fnGetStatementAmount_2(BankAccRecon."Bank Account No.", BankAccRecon."Statement No.");
        //>>

        if (StatementAmount_2 <> BankAccRecon."Statement Ending Balance" - BankAccRecon."Balance Last Statement")
          and (StatementAmount_2 - (BankAccRecon."Statement Ending Balance" - BankAccRecon."Balance Last Statement") > 10) // Rounding Margin of 10
        then
            Error(Text001, BankAccRecon.FieldCaption("Statement Ending Balance"));
        Difference := BankAccReconLine.Difference;

        //ERROR('Usimalize');
    end;

    local procedure CloseBankAccLedgEntry(BankAccReconLine: Record "Bank Acc. Reconciliation Line"; var AppliedAmount: Decimal)
    begin
        BankAccLedgEntry.Reset;
        BankAccLedgEntry.SetCurrentkey("Bank Account No.", Open);
        BankAccLedgEntry.SetRange("Bank Account No.", BankAccReconLine."Bank Account No.");
        BankAccLedgEntry.SetRange(Open, true);
        BankAccLedgEntry.SetRange(
          "Statement Status", BankAccLedgEntry."statement status"::"Bank Acc. Entry Applied");
        BankAccLedgEntry.SetRange("Statement No.", BankAccReconLine."Statement No.");
        BankAccLedgEntry.SetRange("Statement Line No.", BankAccReconLine."Statement Line No.");
        if BankAccLedgEntry.Find('-') then
            repeat
                AppliedAmount += BankAccLedgEntry."Remaining Amount";
                BankAccLedgEntry."Remaining Amount" := 0;
                BankAccLedgEntry.Open := false;
                BankAccLedgEntry."Statement Status" := BankAccLedgEntry."statement status"::Closed;
                BankAccLedgEntry.Modify;

                CheckLedgEntry.Reset;
                CheckLedgEntry.SetCurrentkey("Bank Account Ledger Entry No.");
                CheckLedgEntry.SetRange(
                  "Bank Account Ledger Entry No.", BankAccLedgEntry."Entry No.");
                CheckLedgEntry.SetRange(Open, true);
                if CheckLedgEntry.Find('-') then
                    repeat
                        CheckLedgEntry.TestField(Open, true);
                        CheckLedgEntry.TestField(
                          "Statement Status",
                          CheckLedgEntry."statement status"::"Bank Acc. Entry Applied");
                        CheckLedgEntry.TestField("Statement No.", '');
                        CheckLedgEntry.TestField("Statement Line No.", 0);
                        CheckLedgEntry.Open := false;
                        CheckLedgEntry."Statement Status" := CheckLedgEntry."statement status"::Closed;
                        CheckLedgEntry.Modify;
                    until CheckLedgEntry.Next = 0;
            until BankAccLedgEntry.Next = 0;
    end;

    local procedure CloseCheckLedgEntry(BankAccReconLine: Record "Bank Acc. Reconciliation Line"; var AppliedAmount: Decimal)
    var
        CheckLedgEntry2: Record "Check Ledger Entry";
    begin
        CheckLedgEntry.Reset;
        CheckLedgEntry.SetCurrentkey("Bank Account No.", Open);
        CheckLedgEntry.SetRange("Bank Account No.", BankAccReconLine."Bank Account No.");
        CheckLedgEntry.SetRange(Open, true);
        CheckLedgEntry.SetRange(
          "Statement Status", CheckLedgEntry."statement status"::"Check Entry Applied");
        CheckLedgEntry.SetRange("Statement No.", BankAccReconLine."Statement No.");
        CheckLedgEntry.SetRange("Statement Line No.", BankAccReconLine."Statement Line No.");
        if CheckLedgEntry.Find('-') then
            repeat
                AppliedAmount -= CheckLedgEntry.Amount;
                CheckLedgEntry.Open := false;
                CheckLedgEntry."Statement Status" := CheckLedgEntry."statement status"::Closed;
                CheckLedgEntry.Modify;

                BankAccLedgEntry.Get(CheckLedgEntry."Bank Account Ledger Entry No.");
                BankAccLedgEntry.TestField(Open, true);
                BankAccLedgEntry.TestField(
                  "Statement Status", BankAccLedgEntry."statement status"::"Check Entry Applied");
                BankAccLedgEntry.TestField("Statement No.", '');
                BankAccLedgEntry.TestField("Statement Line No.", 0);
                BankAccLedgEntry."Remaining Amount" :=
                  BankAccLedgEntry."Remaining Amount" + CheckLedgEntry.Amount;
                if BankAccLedgEntry."Remaining Amount" = 0 then begin
                    BankAccLedgEntry.Open := false;
                    BankAccLedgEntry."Statement Status" := BankAccLedgEntry."statement status"::Closed;
                    BankAccLedgEntry."Statement No." := BankAccReconLine."Statement No.";
                    BankAccLedgEntry."Statement Line No." := CheckLedgEntry."Statement Line No.";
                end else begin
                    CheckLedgEntry2.Reset;
                    CheckLedgEntry2.SetCurrentkey("Bank Account Ledger Entry No.");
                    CheckLedgEntry2.SetRange("Bank Account Ledger Entry No.", BankAccLedgEntry."Entry No.");
                    CheckLedgEntry2.SetRange(Open, true);
                    CheckLedgEntry2.SetRange("Check Type", CheckLedgEntry2."check type"::"Partial Check");
                    CheckLedgEntry2.SetRange(
                      "Statement Status", CheckLedgEntry2."statement status"::"Check Entry Applied");
                    if not CheckLedgEntry2.FindFirst then
                        BankAccLedgEntry."Statement Status" := BankAccLedgEntry."statement status"::Open;
                end;
                BankAccLedgEntry.Modify;
            until CheckLedgEntry.Next = 0;
    end;

    local procedure PostPaymentApplications(BankAccReconLine: Record "Bank Acc. Reconciliation Line"; var AppliedAmount: Decimal)
    var
        AppliedPmtEntry: Record "Applied Payment Entry";
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
        GLSetup: Record "General Ledger Setup";
        PaymentLineAmount: Decimal;
        RemainingAmount: Decimal;
    begin
        //IF BankAccReconLine.IsTransactionPostedAndReconciled THEN
        //  ERROR(TransactionAlreadyReconciledErr,BankAccReconLine."Transaction Date",BankAccReconLine."Transaction Text");
        if BankAccReconLine."Account No." = '' then
            Error(LineNoTAppliedErr, BankAccReconLine."Transaction Date", BankAccReconLine."Transaction Text");
        BankAcc.Get(BankAccReconLine."Bank Account No.");
        GenJnlLine.Init;
        GenJnlLine."Document Type" := GenJnlLine."document type"::Payment;

        if IsRefund(BankAccReconLine) then
            GenJnlLine."Document Type" := GenJnlLine."document type"::Refund;

        GenJnlLine."Shortcut Dimension 1 Code" := BankAccReconLine."Shortcut Dimension 1 Code";
        GenJnlLine."Shortcut Dimension 2 Code" := BankAccReconLine."Shortcut Dimension 2 Code";
        //"Account Type" := BankAccReconLine.GetAppliedToAccountType;
        //VALIDATE("Account No.",BankAccReconLine.GetAppliedToAccountNo);
        GenJnlLine."Dimension Set ID" := BankAccReconLine."Dimension Set ID";

        GenJnlLine."Posting Date" := BankAccReconLine."Transaction Date";
        GenJnlLine.Description := BankAccReconLine.Description;

        GenJnlLine."Document No." := BankAccReconLine."Statement No.";
        GenJnlLine."Bal. Account Type" := GenJnlLine."bal. account type"::"Bank Account";
        GenJnlLine."Bal. Account No." := BankAcc."No.";

        GenJnlLine."Source Code" := SourceCode;
        GenJnlLine."Allow Zero-Amount Posting" := true;

        GenJnlLine."Applies-to ID" := BankAccReconLine."Statement No.";

        if AppliedPmtEntry.AppliedPmtEntryLinesExist(BankAccReconLine) then
            repeat
                AppliedAmount += AppliedPmtEntry."Applied Amount" - AppliedPmtEntry."Applied Pmt. Discount";
                PaymentLineAmount += AppliedPmtEntry."Applied Amount" - AppliedPmtEntry."Applied Pmt. Discount";
                AppliedPmtEntry.TestField("Account Type", BankAccReconLine."Account Type");
                AppliedPmtEntry.TestField("Account No.", BankAccReconLine."Account No.");
                if AppliedPmtEntry."Applies-to Entry No." <> 0 then
                    case AppliedPmtEntry."Account Type" of
                        AppliedPmtEntry."account type"::Customer:
                            ApplyCustLedgEntry(
                              AppliedPmtEntry, GenJnlLine."Applies-to ID", GenJnlLine."Posting Date", 0D, 0D, AppliedPmtEntry."Applied Pmt. Discount");
                        AppliedPmtEntry."account type"::Vendor:
                            ApplyVendLedgEntry(
                              AppliedPmtEntry, GenJnlLine."Applies-to ID", GenJnlLine."Posting Date", 0D, 0D, AppliedPmtEntry."Applied Pmt. Discount");
                        AppliedPmtEntry."account type"::"Bank Account":
                            begin
                                BankAccountLedgerEntry.Get(AppliedPmtEntry."Applies-to Entry No.");
                                RemainingAmount := BankAccountLedgerEntry."Remaining Amount";
                                case true of
                                    RemainingAmount = AppliedPmtEntry."Applied Amount":
                                        begin
                                            if not PostPaymentsOnly then
                                                CloseBankAccountLedgerEntry(AppliedPmtEntry."Applies-to Entry No.", AppliedPmtEntry."Applied Amount");
                                            PaymentLineAmount -= AppliedPmtEntry."Applied Amount";
                                        end;
                                    Abs(RemainingAmount) > Abs(AppliedPmtEntry."Applied Amount"):
                                        begin
                                            if not PostPaymentsOnly then begin
                                                BankAccountLedgerEntry."Remaining Amount" -= AppliedPmtEntry."Applied Amount";
                                                BankAccountLedgerEntry.Modify;
                                            end;
                                            PaymentLineAmount -= AppliedPmtEntry."Applied Amount";
                                        end;
                                    Abs(RemainingAmount) < Abs(AppliedPmtEntry."Applied Amount"):
                                        begin
                                            if not PostPaymentsOnly then
                                                CloseBankAccountLedgerEntry(AppliedPmtEntry."Applies-to Entry No.", RemainingAmount);
                                            PaymentLineAmount -= RemainingAmount;
                                        end;
                                end;
                            end;
                    end;
            until AppliedPmtEntry.Next = 0;

        if PaymentLineAmount <> 0 then begin
            if GenJnlLine."Account Type" <> GenJnlLine."account type"::"Bank Account" then begin
                GenJnlLine.Validate("Currency Code", BankAcc."Currency Code");
                GenJnlLine.Amount := -PaymentLineAmount;
                GenJnlLine.Validate("VAT %");
                GenJnlLine.Validate("Bal. VAT %")
            end else begin
                GLSetup.Get;
                Error(ExcessiveAmtErr, PaymentLineAmount, GLSetup.GetCurrencyCode(BankAcc."Currency Code"));
            end;
            GenJnlPostLine.RunWithCheck(GenJnlLine);
            if not PostPaymentsOnly then begin
                BankAccountLedgerEntry.SetRange(Open, true);
                BankAccountLedgerEntry.SetRange("Bank Account No.", BankAcc."No.");
                BankAccountLedgerEntry.SetRange("Document Type", GenJnlLine."document type"::Payment);
                BankAccountLedgerEntry.SetRange("Document No.", BankAccReconLine."Statement No.");
                BankAccountLedgerEntry.SetRange("Posting Date", GenJnlLine."Posting Date");
                if BankAccountLedgerEntry.FindLast then
                    CloseBankAccountLedgerEntry(BankAccountLedgerEntry."Entry No.", BankAccountLedgerEntry.Amount);
            end;
        end;
    end;

    local procedure UpdateBank(BankAccRecon: Record "Bank Acc. Reconciliation"; Amt: Decimal)
    begin
        BankAcc.LockTable;
        BankAcc.Get(BankAccRecon."Bank Account No.");
        BankAcc.TestField(Blocked, false);
        BankAcc."Last Statement No." := BankAccRecon."Statement No.";
        BankAcc."Balance Last Statement" := BankAccRecon."Balance Last Statement" + Amt;
        BankAcc.Modify;
    end;

    local procedure TransferToBankStmt(BankAccRecon: Record "Bank Acc. Reconciliation")
    var
        BankAccStmt: Record "Bank Account Statement";
        BankAccStmtLine: Record "Bank Account Statement Line";
        BankAccReconLine: Record "Bank Acc. Reconciliation Line";
    begin
        if BankAccReconLine.LinesExist(BankAccRecon) then
            repeat
                BankAccStmtLine.TransferFields(BankAccReconLine);
                BankAccStmtLine.Insert;
                BankAccReconLine.ClearDataExchEntries;
            until BankAccReconLine.Next = 0;

        BankAccStmt.TransferFields(BankAccRecon);
        BankAccStmt.Insert;
    end;

    local procedure TransferToPostPmtAppln(BankAccRecon: Record "Bank Acc. Reconciliation")
    var
        PostedPmtReconHdr: Record "Posted Payment Recon. Hdr";
        PostedPmtReconLine: Record "Posted Payment Recon. Line";
        BankAccReconLine: Record "Bank Acc. Reconciliation Line";
        TypeHelper: Codeunit "Type Helper";
        FieldLength: Integer;
    begin
        if BankAccReconLine.LinesExist(BankAccRecon) then
            repeat
                PostedPmtReconLine.TransferFields(BankAccReconLine);

                FieldLength := TypeHelper.GetFieldLength(Database::"Posted Payment Recon. Line",
                    PostedPmtReconLine.FieldNo("Applied Document No."));
                PostedPmtReconLine."Applied Document No." := CopyStr(BankAccReconLine.GetAppliedToDocumentNo, 1, FieldLength);

                FieldLength := TypeHelper.GetFieldLength(Database::"Posted Payment Recon. Line",
                    PostedPmtReconLine.FieldNo("Applied Entry No."));
                PostedPmtReconLine."Applied Entry No." := CopyStr(BankAccReconLine.GetAppliedToEntryNo, 1, FieldLength);

                PostedPmtReconLine.Reconciled := not PostPaymentsOnly;

                PostedPmtReconLine.Insert;
                BankAccReconLine.ClearDataExchEntries;
            until BankAccReconLine.Next = 0;

        PostedPmtReconHdr.TransferFields(BankAccRecon);
        PostedPmtReconHdr.Insert;
    end;

    procedure ApplyCustLedgEntry(AppliedPmtEntry: Record "Applied Payment Entry"; AppliesToID: Code[50]; PostingDate: Date; PmtDiscDueDate: Date; PmtDiscToleranceDate: Date; RemPmtDiscPossible: Decimal)
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
        CurrExchRate: Record "Currency Exchange Rate";
    begin
        CustLedgEntry.Get(AppliedPmtEntry."Applies-to Entry No.");
        CustLedgEntry.TestField(Open);
        BankAcc.Get(AppliedPmtEntry."Bank Account No.");
        if AppliesToID = '' then begin
            CustLedgEntry."Pmt. Discount Date" := PmtDiscDueDate;
            CustLedgEntry."Pmt. Disc. Tolerance Date" := PmtDiscToleranceDate;

            CustLedgEntry."Remaining Pmt. Disc. Possible" := RemPmtDiscPossible;
            if BankAcc.IsInLocalCurrency then
                CustLedgEntry."Remaining Pmt. Disc. Possible" :=
                  CurrExchRate.ExchangeAmount(CustLedgEntry."Remaining Pmt. Disc. Possible", '', CustLedgEntry."Currency Code", PostingDate);
        end else begin
            CustLedgEntry."Applies-to ID" := AppliesToID;

            CustLedgEntry."Amount to Apply" := AppliedPmtEntry."Applied Amount";
            if BankAcc.IsInLocalCurrency then
                CustLedgEntry."Amount to Apply" :=
                  CurrExchRate.ExchangeAmount(CustLedgEntry."Amount to Apply", '', CustLedgEntry."Currency Code", PostingDate);
        end;

        Codeunit.Run(Codeunit::"Cust. Entry-Edit", CustLedgEntry);
    end;

    procedure ApplyVendLedgEntry(AppliedPmtEntry: Record "Applied Payment Entry"; AppliesToID: Code[50]; PostingDate: Date; PmtDiscDueDate: Date; PmtDiscToleranceDate: Date; RemPmtDiscPossible: Decimal)
    var
        VendLedgEntry: Record "Vendor Ledger Entry";
        CurrExchRate: Record "Currency Exchange Rate";
    begin
        VendLedgEntry.Get(AppliedPmtEntry."Applies-to Entry No.");
        VendLedgEntry.TestField(Open);
        BankAcc.Get(AppliedPmtEntry."Bank Account No.");
        if AppliesToID = '' then begin
            VendLedgEntry."Pmt. Discount Date" := PmtDiscDueDate;
            VendLedgEntry."Pmt. Disc. Tolerance Date" := PmtDiscToleranceDate;

            VendLedgEntry."Remaining Pmt. Disc. Possible" := RemPmtDiscPossible;
            if BankAcc.IsInLocalCurrency then
                VendLedgEntry."Remaining Pmt. Disc. Possible" :=
                  CurrExchRate.ExchangeAmount(VendLedgEntry."Remaining Pmt. Disc. Possible", '', VendLedgEntry."Currency Code", PostingDate);
        end else begin
            VendLedgEntry."Applies-to ID" := AppliesToID;

            VendLedgEntry."Amount to Apply" := AppliedPmtEntry."Applied Amount";
            if BankAcc.IsInLocalCurrency then
                VendLedgEntry."Amount to Apply" :=
                  CurrExchRate.ExchangeAmount(VendLedgEntry."Amount to Apply", '', VendLedgEntry."Currency Code", PostingDate);
        end;

        Codeunit.Run(Codeunit::"Vend. Entry-Edit", VendLedgEntry);
    end;

    local procedure CloseBankAccountLedgerEntry(EntryNo: Integer; AppliedAmount: Decimal)
    var
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
        CheckLedgerEntry: Record "Check Ledger Entry";
    begin
        BankAccountLedgerEntry.Get(EntryNo);
        BankAccountLedgerEntry.TestField(Open);
        BankAccountLedgerEntry.TestField("Remaining Amount", AppliedAmount);
        BankAccountLedgerEntry."Remaining Amount" := 0;
        BankAccountLedgerEntry.Open := false;
        BankAccountLedgerEntry."Statement Status" := BankAccountLedgerEntry."statement status"::Closed;
        BankAccountLedgerEntry.Modify;

        CheckLedgerEntry.Reset;
        CheckLedgerEntry.SetCurrentkey("Bank Account Ledger Entry No.");
        CheckLedgerEntry.SetRange(
          "Bank Account Ledger Entry No.", BankAccountLedgerEntry."Entry No.");
        CheckLedgerEntry.SetRange(Open, true);
        if CheckLedgerEntry.FindSet then
            repeat
                CheckLedgerEntry.Open := false;
                CheckLedgerEntry."Statement Status" := CheckLedgerEntry."statement status"::Closed;
                CheckLedgerEntry.Modify;
            until CheckLedgerEntry.Next = 0;
    end;

    local procedure IsRefund(BankAccReconLine: Record "Bank Acc. Reconciliation Line"): Boolean
    begin
        if (BankAccReconLine."Account Type" = BankAccReconLine."account type"::Customer) and (BankAccReconLine."Statement Amount" < 0) or
   (BankAccReconLine."Account Type" = BankAccReconLine."account type"::Vendor) and (BankAccReconLine."Statement Amount" > 0)
then
            exit(true);
        exit(false);
    end;

    local procedure PostToPostedBankAccLedgerEntry(BankAccRecon: Record "Bank Acc. Reconciliation")
    var
        PosteBankAccountLedgerEntry: Record "PosteBank Account Ledger Entry";
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
        BankAccount: Record "Bank Account";
    begin
        //get the net change of the bank
        BankAccount.Reset;
        BankAccount.SetRange(BankAccount."No.", BankAccRecon."Bank Account No.");
        if BankAccount.Find('-') then begin
            BankAccount.CalcFields(BankAccount."Net Change");
        end;

        PosteBankAccountLedgerEntry.Reset;
        PosteBankAccountLedgerEntry.SetRange(PosteBankAccountLedgerEntry."Bank Account No.", BankAccRecon."Bank Account No.");
        PosteBankAccountLedgerEntry.SetRange(PosteBankAccountLedgerEntry."Statement No.", BankAccRecon."Statement No.");
        if PosteBankAccountLedgerEntry.Find('-') then
            PosteBankAccountLedgerEntry.DeleteAll;

        BankAccountLedgerEntry.Reset;
        BankAccountLedgerEntry.SetCurrentkey("Bank Account No.", Open);
        //BankAccountLedgerEntry.SETRANGE(BankAccountLedgerEntry."Statement No.",BankAccRecon."Statement No.");
        //BankAccountLedgerEntry.SETRANGE(Open,TRUE);
        //BankAccountLedgerEntry.SETRANGE(
        // "Statement Status",BankAccountLedgerEntry."Statement Status"::"Bank Acc. Entry Applied");
        BankAccountLedgerEntry.SetRange(BankAccountLedgerEntry."Bank Account No.", BankAccRecon."Bank Account No.");
        BankAccountLedgerEntry.SetFilter(BankAccountLedgerEntry."Posting Date", '%1..%2', 0D, BankAccRecon."Statement Date");
        if BankAccountLedgerEntry.Find('-') then begin
            repeat
                PosteBankAccountLedgerEntry.Init;
                PosteBankAccountLedgerEntry."Posting Date" := BankAccountLedgerEntry."Posting Date";
                PosteBankAccountLedgerEntry."Document No." := BankAccountLedgerEntry."Document No.";
                PosteBankAccountLedgerEntry."External Document No." := BankAccountLedgerEntry."External Document No.";
                PosteBankAccountLedgerEntry."Statement Line No." := BankAccountLedgerEntry."Statement Line No.";
                PosteBankAccountLedgerEntry."Debit Amount" := BankAccountLedgerEntry."Debit Amount";
                PosteBankAccountLedgerEntry."Credit Amount" := BankAccountLedgerEntry."Credit Amount";
                PosteBankAccountLedgerEntry."Document Type" := BankAccountLedgerEntry."Document Type";
                PosteBankAccountLedgerEntry.Reversed := BankAccountLedgerEntry.Reversed;
                PosteBankAccountLedgerEntry.Open := BankAccountLedgerEntry.Open;
                PosteBankAccountLedgerEntry."Statement Status" := BankAccountLedgerEntry."Statement Status";
                PosteBankAccountLedgerEntry."Entry No." := BankAccountLedgerEntry."Entry No.";
                PosteBankAccountLedgerEntry."Bank Account No." := BankAccountLedgerEntry."Bank Account No.";
                //PosteBankAccountLedgerEntry."Bank Net Change":=BankAccount."Net Change";
                PosteBankAccountLedgerEntry."Statement No." := BankAccRecon."Statement No.";  //BankAccountLedgerEntry."Statement No.";
                PosteBankAccountLedgerEntry.Description := BankAccountLedgerEntry.Description;
                PosteBankAccountLedgerEntry.Amount := BankAccountLedgerEntry.Amount;
                PosteBankAccountLedgerEntry."Statement Difference" := BankAccountLedgerEntry."Statement Diffrence 2";
                // PosteBankAccountLedgerEntry.TRANSFERFIELDS(BankAccountLedgerEntry);
                PosteBankAccountLedgerEntry.Insert;
            until BankAccountLedgerEntry.Next = 0;
        end;
    end;

    local procedure fnGetStatementAmount_2(BankNo: Code[20]; StatNo: Code[10]): Decimal
    var
        BankAccStatementLine1: Record "Bank Acc. Statement Line1";
    begin
        BankAccStatementLine1.Reset;
        BankAccStatementLine1.SetCurrentkey("Statement Type", "Bank Account No.", "Statement No.", "Statement Line No.");
        BankAccStatementLine1.SetRange("Bank Account No.", BankNo);
        BankAccStatementLine1.SetRange("Statement No.", StatNo);
        if BankAccStatementLine1.FindSet then begin
            BankAccStatementLine1.CalcSums("Statement Amount");
            exit(BankAccStatementLine1."Statement Amount");
        end;
    end;
}

