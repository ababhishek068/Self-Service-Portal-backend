report 50111 "Bank Acc. Recon. Test1"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Bank Acc. Recon. - Test.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Bank Acc. Reconciliation"; "Bank Acc. Reconciliation")
        {
            RequestFilterFields = "Statement No.";
            column(BankCode; BankCode) { }
            column(BankAccountNo_BankAccReconciliation; "Bank Acc. Reconciliation"."Bank Account No.") { }
            column(StatementNo_BankAccReconciliation; "Bank Acc. Reconciliation"."Statement No.") { }
            column(StatementDate_BankAccReconciliation; "Bank Acc. Reconciliation"."Statement Date") { }
            column(BankAccountNo; BankAccountNo) { }
            column(StatementEndingBalance_BankAccReconciliation; "Bank Acc. Reconciliation"."Statement Ending Balance") { }
            column(BankName; BankName) { }
            column(BankAccountBalanceasperCashBook; BankAccountBalanceasperCashBook) { }
            column(UnpresentedChequesTotal; UnpresentedChequesTotal) { }
            column(UncreditedBanking; UncreditedBanking) { }
            column(ReconciliationStatement; ReconciliationStatement) { }
            column(CompanyName; CompanyInfo.Name) { }
            column(CompanyAddress; CompanyInfo.Address) { }
            column(RecCashBkBal; RecCashBkBal) { }
            column(NotesLine1_BankAccReconciliation; '') { }
            column(NotesLine2_BankAccReconciliation; '') { }
            column(NotesLine3_BankAccReconciliation; '') { }
            column(NotesLine4_BankAccReconciliation; '') { }
            column(NotesLine5_BankAccReconciliation; '') { }
            column(NotesLine6_BankAccReconciliation; '') { }
            column(DifferencesBW; DifferencesBW) { }
            column(DifferencesInBankTotal; DifferencesInBankTotal) { }
            column(DifferencesInBankTotalDebits; DifferencesInBankTotalDebits) { }
            column(DifferencesInBankTotalCredits; DifferencesInBankTotalCredits) { }
            dataitem(BankAccountLedgerEntry; "Bank Account Ledger Entry")
            {
                DataItemLink = "Bank Account No." = FIELD("Bank Account No.");
                DataItemTableView = WHERE("Statement Status" = FILTER(Open),
                                          Reversed = CONST(false),
                                          Open = CONST(true));
                column(StatementLineNo_BankAccountLedgerEntry; BankAccountLedgerEntry."Statement Line No.") { }
                column(DocumentNo_BankAccountLedgerEntry; BankAccountLedgerEntry."Document No.") { }
                column(TransactionDate_BankAccountLedgerEntry; BankAccountLedgerEntry."Posting Date") { }
                column(PayeeName_BankAccountLedgerEntry; BankAccountLedgerEntry."Customer Name") { }
                column(Description_BankAccountLedgerEntry; BankAccountLedgerEntry.Description) { }
                column(StatementAmount_BankAccountLedgerEntry; BankAccountLedgerEntry.Amount) { }
                column(SNo; SNo) { }
                column(Remarks_BankAccountLedgerEntry; BankAccountLedgerEntry.Description) { }
                column(StatementDifference_BankAccountLedgerEntry; BankAccountLedgerEntry."Statement Diffrence 2") { }
                column(ExternalDocumentNo_BankAccountLedgerEntry; BankAccountLedgerEntry."External Document No.") { }

                trigger OnAfterGetRecord();
                begin
                    SNo += 1;
                end;

                trigger OnPreDataItem();
                begin
                    //Reconciled=CONST(No)
                    BankAccountLedgerEntry.SETFILTER("Posting Date", '<=%1', "Bank Acc. Reconciliation"."Statement Date");
                    BankAccountLedgerEntry.SETFILTER("Statement Status", '%1', "Statement Status"::Open);
                    SETFILTER(Reversed, '%1', FALSE);
                    SETFILTER(Amount, '<%1', 0);
                    SETFILTER(Open, '%1', TRUE);
                end;
            }
            dataitem(BankAccountLedgerEntry1; "Bank Account Ledger Entry")
            {
                DataItemLink = "Bank Account No." = FIELD("Bank Account No.");
                DataItemTableView = WHERE("Statement Status" = FILTER(true),
                                          Reversed = CONST(false),
                                          Open = CONST(true));
                column(StatementLineNo_BankAccountLedgerEntry1; BankAccountLedgerEntry1."Statement Line No.") { }
                column(DocumentNo_BankAccountLedgerEntry1; BankAccountLedgerEntry1."Document No.") { }
                column(TransactionDate_BankAccountLedgerEntry1; BankAccountLedgerEntry1."Posting Date") { }
                column(Description_BankAccountLedgerEntry1; BankAccountLedgerEntry1.Description) { }
                column(StatementAmount_BankAccountLedgerEntry1; BankAccountLedgerEntry1.Amount) { }
                column(SNo1; SNo1) { }
                column(Remarks_BankAccountLedgerEntry1; BankAccountLedgerEntry1.Description) { }
                column(StatementDifference_BankAccountLedgerEntry1; BankAccountLedgerEntry1."Statement Diffrence 2") { }
                column(ExternalDocumentNo_BankAccountLedgerEntry1; BankAccountLedgerEntry1."External Document No.") { }

                trigger OnAfterGetRecord();
                begin
                    SNo1 += 1;
                end;

                trigger OnPreDataItem();
                begin
                    //Reconciled=CONST(No)
                    BankAccountLedgerEntry1.SETFILTER("Posting Date", '<=%1', "Bank Acc. Reconciliation"."Statement Date");
                    BankAccountLedgerEntry1.SETFILTER("Debit Amount", '<>%1', 0);
                    SETFILTER(Amount, '>%1', 0);
                    SETFILTER(Reversed, '%1', FALSE);
                    SETFILTER(Open, '%1', TRUE);

                    //SETFILTER(test,'>%1',0);
                end;
            }
            dataitem("Bank Acc. Reconciliation Line"; "Bank Acc. Statement Line1")
            {
                DataItemLink = "Bank Account No." = FIELD("Bank Account No."),
                               "Statement No." = FIELD("Statement No.");
                DataItemTableView = WHERE(Difference = FILTER(<> 0));
                column(StatementLineNo_BankAccReconciliationLine; "Bank Acc. Reconciliation Line"."Statement Line No.") { }
                column(DocumentNo_BankAccReconciliationLine; "Bank Acc. Reconciliation Line"."Document No.") { }
                column(TransactionDate_BankAccReconciliationLine; "Bank Acc. Reconciliation Line"."Transaction Date") { }
                column(Description_BankAccReconciliationLine; "Bank Acc. Reconciliation Line".Description) { }
                column(StatementAmount_BankAccReconciliationLine; "Bank Acc. Reconciliation Line"."Statement Amount") { }
                column(Difference_BankAccReconciliationLine; "Bank Acc. Reconciliation Line".Difference) { }
                column(CheckNo_BankAccReconciliationLine; "Bank Acc. Reconciliation Line"."Check No.") { }
                column(AdditionalTransactionInfo_BankAccReconciliationLine; "Bank Acc. Reconciliation Line"."Additional Transaction Info") { }
            }
            dataitem(BankAccReconciliationLine1; "Bank Acc. Statement Line1")
            {
                DataItemLink = "Bank Account No." = FIELD("Bank Account No."),
                               "Statement No." = FIELD("Statement No.");
                DataItemTableView = WHERE(Difference = FILTER(< 0));
                column(StatementLineNo_BankAccReconciliationLine1; BankAccReconciliationLine1."Statement Line No.") { }
                column(DocumentNo_BankAccReconciliationLine1; BankAccReconciliationLine1."Document No.") { }
                column(TransactionDate_BankAccReconciliationLine1; BankAccReconciliationLine1."Transaction Date") { }
                column(Description_BankAccReconciliationLine1; BankAccReconciliationLine1.Description) { }
                column(StatementAmount_BankAccReconciliationLine1; BankAccReconciliationLine1."Statement Amount") { }
                column(Difference_BankAccReconciliationLine1; BankAccReconciliationLine1.Difference) { }
                column(CheckNo_BankAccReconciliationLine1; BankAccReconciliationLine1."Check No.") { }
                column(AdditionalTransactionInfo_BankAccReconciliationLine1; BankAccReconciliationLine1."Additional Transaction Info") { }
            }

            trigger OnAfterGetRecord();
            var
                BankAccountLedgerEntry2: Record "Bank Account Ledger Entry";
            begin
                BankCode := '';
                BankAccountNo := '';
                BankName := '';
                BankAccountBalanceasperCashBook := 0;
                UnpresentedChequesTotal := 0;
                UncreditedBanking := 0;

                RecCashBkBal := 0;

                TotalDiffFunc();

                Bank.RESET;
                Bank.SETRANGE(Bank."No.", "Bank Account No.");
                IF Bank.FIND('-') THEN BEGIN
                    BankCode := Bank."No.";
                    BankAccountNo := Bank."Bank Account No.";
                    BankName := Bank.Name;
                    Bank.SETRANGE(Bank."Date Filter", 0D, "Statement Date");
                    Bank.CALCFIELDS(Bank."Net Change");
                    BankAccountBalanceasperCashBook := Bank."Net Change";
                    /*
                      BankStatementLine.RESET;
                      BankStatementLine.SETRANGE(BankStatementLine."Bank Account No.",Bank."No.");
                      BankStatementLine.SETRANGE(BankStatementLine."Statement No.","Statement No.");
                      BankStatementLine.SETRANGE(BankStatementLine.Reconciled,FALSE);
                      IF BankStatementLine.FIND('-') THEN REPEAT
                        IF BankStatementLine."Statement Amount"<0 THEN
                         UnpresentedChequesTotal:=UnpresentedChequesTotal+BankStatementLine."Statement Amount"
                        ELSE IF BankStatementLine."Statement Amount">0 THEN
                         UncreditedBanking:=UncreditedBanking+BankStatementLine."Statement Amount";
                      UNTIL BankStatementLine.NEXT=0;
                    */

                    BankStatementLine.RESET;
                    BankStatementLine.SETRANGE(BankStatementLine."Bank Account No.", Bank."No.");
                    BankStatementLine.SETRANGE(BankStatementLine."Statement No.", "Statement No.");
                    //BankStatementLine.SETRANGE(BankStatementLine.Reconciled,FALSE);
                    IF BankStatementLine.FIND('-') THEN
                        REPEAT
                            RecCashBkBal += BankStatementLine."Applied Amount";
                        UNTIL BankStatementLine.NEXT = 0;

                    BankAccountLedgerEntry2.RESET;
                    BankAccountLedgerEntry2.SETRANGE("Bank Account No.", Bank."No.");
                    BankAccountLedgerEntry2.SETRANGE(Open, TRUE);
                    BankAccountLedgerEntry2.SETRANGE(Reversed, FALSE);
                    BankAccountLedgerEntry2.SETFILTER("Posting Date", '%1..%2', 01010101D, "Bank Acc. Reconciliation"."Statement Date");
                    //BankAccountLedgerEntry2.SETFILTER("Statement Difference",'<>%1',0);
                    IF BankAccountLedgerEntry2.FIND('-') THEN
                        REPEAT

                            IsApplied := (BankAccountLedgerEntry2."Statement Status" = BankAccountLedgerEntry2."Statement Status"::Open);
                            IF IsApplied THEN
                                IF BankAccountLedgerEntry2.Amount < 0 THEN
                                    UnpresentedChequesTotal := UnpresentedChequesTotal + BankAccountLedgerEntry2.Amount
                                ELSE
                                    IF BankAccountLedgerEntry2.Amount > 0 THEN
                                        UncreditedBanking := UncreditedBanking + BankAccountLedgerEntry2.Amount;
                        UNTIL BankAccountLedgerEntry2.NEXT = 0;

                    UnpresentedChequesTotal := UnpresentedChequesTotal * -1;

                    BankStatBalance := "Bank Acc. Reconciliation"."Statement Ending Balance";

                    DifferencesBW := 0;
                    /*BankAccReconciliationLine.RESET;
                    BankAccReconciliationLine.SETRANGE(BankAccReconciliationLine."Bank Account No.","Bank Acc. Reconciliation"."Bank Account No.");
                    BankAccReconciliationLine.SETRANGE(BankAccReconciliationLine."Statement No.","Bank Acc. Reconciliation"."Statement No.");
                    BankAccReconciliationLine.SETRANGE(Imported,FALSE);
                    BankAccReconciliationLine.SETRANGE(BankAccReconciliationLine.Type,BankAccReconciliationLine.Type::"Bank Account Ledger Entry");
                    BankAccReconciliationLine.SETFILTER("Applied Amount",'<>%1',0);
                    IF BankAccReconciliationLine.FINDSET THEN
                    BEGIN
                      BankAccReconciliationLine.CALCSUMS(Difference);
                      DifferencesBW := BankAccReconciliationLine.Difference;
                    END;
                    */
                    DifferencesInBankTotal := 0;
                    DifferencesInBankTotalDebits := 0;
                    DifferencesInBankTotalCredits := 0;

                    BankAccReconciliationLine2.RESET;
                    BankAccReconciliationLine2.SETRANGE(BankAccReconciliationLine2."Bank Account No.", "Bank Acc. Reconciliation"."Bank Account No.");
                    BankAccReconciliationLine2.SETRANGE(BankAccReconciliationLine2."Statement No.", "Bank Acc. Reconciliation"."Statement No.");
                    BankAccReconciliationLine2.SETFILTER(Difference, '<>%1', 0);
                    IF BankAccReconciliationLine2.FINDSET THEN BEGIN
                        BankAccReconciliationLine2.CALCSUMS(Difference);
                        DifferencesInBankTotal := BankAccReconciliationLine2.Difference;
                    END;
                    //Have deits and credits Separate
                    BankAccReconciliationLine2.RESET;
                    BankAccReconciliationLine2.SETRANGE(BankAccReconciliationLine2."Bank Account No.", "Bank Acc. Reconciliation"."Bank Account No.");
                    BankAccReconciliationLine2.SETRANGE(BankAccReconciliationLine2."Statement No.", "Bank Acc. Reconciliation"."Statement No.");
                    BankAccReconciliationLine2.SETFILTER(Difference, '<>%1', 0);
                    IF BankAccReconciliationLine2.FINDSET THEN BEGIN
                        REPEAT
                            IF BankAccReconciliationLine2.Difference > 0 THEN
                                DifferencesInBankTotalDebits := DifferencesInBankTotalDebits + BankAccReconciliationLine2.Difference
                            ELSE
                                IF BankAccReconciliationLine2.Difference < 0 THEN
                                    DifferencesInBankTotalCredits := (DifferencesInBankTotalCredits + BankAccReconciliationLine2.Difference * -1)

                  UNTIL BankAccReconciliationLine2.NEXT = 0
                    END;




                    IF ((BankAccountBalanceasperCashBook + UnpresentedChequesTotal - UncreditedBanking) + TotalDifference - DifferencesBW = "Statement Ending Balance") THEN
                        ReconciliationStatement := ''
                    ELSE
                        ReconciliationStatement := 'Reconciliation is incomplete please go through it again';
                END;

            end;

            trigger OnPreDataItem();
            begin
                CompanyInfo.GET;
                CompanyInfo.CALCFIELDS(Picture);
            end;
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }

    trigger OnPreReport();
    begin
        //BankAccReconFilter := "Bank Acc. Reconciliation".GETFILTERS;
    end;

    var
        Bank: Record "Bank Account";
        BankCode: Code[20];
        BankAccountNo: Code[20];
        BankName: Text;
        BankAccountBalanceasperCashBook: Decimal;
        UnpresentedChequesTotal: Decimal;
        UncreditedBanking: Decimal;
        BankStatementLine: Record "Bank Acc. Reconciliation Line";
        CompanyInfo: Record "Company Information";
        ReconciliationStatement: Text;
        TotalDifference: Decimal;
        BankRecPresented: Record "Bank Acc. Reconciliation Line";
        BankStatBalance: Decimal;
        RecCashBkBal: Decimal;
        SNo: Integer;
        SNo1: Integer;
        DifferencesBW: Decimal;
        DifferencesInBankTotal: Decimal;
        BankAccReconciliationLine2: Record "Bank Acc. Statement Line1";
        DifferencesInBankTotalDebits: Decimal;
        DifferencesInBankTotalCredits: Decimal;
        IsApplied: Boolean;

    local procedure AddError(Text: Text[250]);
    begin
        /*
        ErrorCounter := ErrorCounter + 1;
        ErrorText[ErrorCounter] := Text;
        */

    end;

    procedure TotalDiffFunc();
    begin
        BankRecPresented.RESET;
        BankRecPresented.SETRANGE(BankRecPresented."Bank Account No.", "Bank Acc. Reconciliation"."Bank Account No.");
        BankRecPresented.SETRANGE(BankRecPresented."Statement No.", "Bank Acc. Reconciliation"."Statement No.");
        //BankRecPresented.SETRANGE(BankRecPresented.Reconciled,TRUE);
        IF BankRecPresented.FIND('-') THEN
            REPEAT
                TotalDifference := TotalDifference + BankRecPresented.Difference;
            UNTIL BankRecPresented.NEXT = 0;
        //MESSAGE('%1',TotalDifference);
    end;
}

