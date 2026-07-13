Report 50107 "Bank Acc. Recon. - Test1"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/BankAccReconTest.rdlc';
    Caption = 'Bank Acc. Recon. - Test';
    ApplicationArea = All;

    dataset
    {
        dataitem("Bank Acc. Reconciliation"; "Bank Acc. Reconciliation")
        {
            RequestFilterFields = "Statement No.";
            column(ReportForNavId_30; 30) { }
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
                DataItemLink = "Bank Account No." = field("Bank Account No.");
                DataItemTableView = where("Statement Status" = filter(Open), Reversed = const(false), Open = const(true));
                column(ReportForNavId_16; 16) { }
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

                trigger OnAfterGetRecord()
                begin
                    SNo += 1;
                end;

                trigger OnPreDataItem()
                begin
                    //Reconciled=CONST(No)
                    BankAccountLedgerEntry.SetFilter("Posting Date", '<=%1', "Bank Acc. Reconciliation"."Statement Date");
                    BankAccountLedgerEntry.SetFilter("Statement Status", '%1', "statement status"::Open);
                    SetFilter(Reversed, '%1', false);
                    SetFilter(Amount, '<%1', 0);
                    SetFilter(Open, '%1', true);
                end;
            }
            dataitem(BankAccountLedgerEntry1; "Bank Account Ledger Entry")
            {
                DataItemLink = "Bank Account No." = field("Bank Account No.");
                DataItemTableView = where("Statement Status" = filter(Open), Reversed = const(false), Open = const(true));
                column(ReportForNavId_8; 8) { }
                column(StatementLineNo_BankAccountLedgerEntry1; BankAccountLedgerEntry1."Statement Line No.") { }
                column(DocumentNo_BankAccountLedgerEntry1; BankAccountLedgerEntry1."Document No.") { }
                column(TransactionDate_BankAccountLedgerEntry1; BankAccountLedgerEntry1."Posting Date") { }
                column(Description_BankAccountLedgerEntry1; BankAccountLedgerEntry1.Description) { }
                column(StatementAmount_BankAccountLedgerEntry1; BankAccountLedgerEntry1.Amount) { }
                column(SNo1; SNo1) { }
                column(Remarks_BankAccountLedgerEntry1; BankAccountLedgerEntry1.Description) { }
                column(StatementDifference_BankAccountLedgerEntry1; BankAccountLedgerEntry1."Statement Diffrence 2") { }
                column(ExternalDocumentNo_BankAccountLedgerEntry1; BankAccountLedgerEntry1."External Document No.") { }

                trigger OnAfterGetRecord()
                begin
                    SNo1 += 1;
                end;

                trigger OnPreDataItem()
                begin
                    //Reconciled=CONST(No)
                    BankAccountLedgerEntry1.SetFilter("Posting Date", '<=%1', "Bank Acc. Reconciliation"."Statement Date");
                    BankAccountLedgerEntry1.SetFilter("Debit Amount", '<>%1', 0);
                    SetFilter(Amount, '>%1', 0);
                    SetFilter(Reversed, '%1', false);
                    SetFilter(Open, '%1', true);

                    //SETFILTER(test,'>%1',0);
                end;
            }
            dataitem("Bank Acc. Reconciliation Line"; "Bank Acc. Statement Line1")
            {
                DataItemLink = "Bank Account No." = field("Bank Account No."), "Statement No." = field("Statement No.");
                DataItemTableView = where(Difference = filter(<> 0));
                column(ReportForNavId_1000000002; 1000000002) { }
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
                DataItemLink = "Bank Account No." = field("Bank Account No."), "Statement No." = field("Statement No.");
                DataItemTableView = where(Difference = filter(< 0));
                column(ReportForNavId_1000000015; 1000000015) { }
                column(StatementLineNo_BankAccReconciliationLine1; BankAccReconciliationLine1."Statement Line No.") { }
                column(DocumentNo_BankAccReconciliationLine1; BankAccReconciliationLine1."Document No.") { }
                column(TransactionDate_BankAccReconciliationLine1; BankAccReconciliationLine1."Transaction Date") { }
                column(Description_BankAccReconciliationLine1; BankAccReconciliationLine1.Description) { }
                column(StatementAmount_BankAccReconciliationLine1; BankAccReconciliationLine1."Statement Amount") { }
                column(Difference_BankAccReconciliationLine1; BankAccReconciliationLine1.Difference) { }
                column(CheckNo_BankAccReconciliationLine1; BankAccReconciliationLine1."Check No.") { }
                column(AdditionalTransactionInfo_BankAccReconciliationLine1; BankAccReconciliationLine1."Additional Transaction Info") { }
            }

            trigger OnAfterGetRecord()
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

                Bank.Reset;
                Bank.SetRange(Bank."No.", "Bank Account No.");
                if Bank.Find('-') then begin
                    BankCode := Bank."No.";
                    BankAccountNo := Bank."Bank Account No.";
                    BankName := Bank.Name;
                    Bank.SetRange(Bank."Date Filter", 0D, "Statement Date");
                    Bank.CalcFields(Bank."Net Change");
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

                    BankStatementLine.Reset;
                    BankStatementLine.SetRange(BankStatementLine."Bank Account No.", Bank."No.");
                    BankStatementLine.SetRange(BankStatementLine."Statement No.", "Statement No.");
                    //BankStatementLine.SETRANGE(BankStatementLine.Reconciled,FALSE);
                    if BankStatementLine.Find('-') then
                        repeat
                            RecCashBkBal += BankStatementLine."Applied Amount";
                        until BankStatementLine.Next = 0;

                    BankAccountLedgerEntry2.Reset;
                    BankAccountLedgerEntry2.SetRange("Bank Account No.", Bank."No.");
                    BankAccountLedgerEntry2.SetRange(Open, true);
                    BankAccountLedgerEntry2.SetRange(Reversed, false);
                    BankAccountLedgerEntry2.SetFilter("Posting Date", '%1..%2', 20010101D, "Bank Acc. Reconciliation"."Statement Date");
                    //BankAccountLedgerEntry2.SETFILTER("Statement Difference",'<>%1',0);
                    if BankAccountLedgerEntry2.Find('-') then
                        repeat

                            IsApplied := (BankAccountLedgerEntry2."Statement Status" = BankAccountLedgerEntry2."statement status"::Open);
                            if IsApplied then
                                if BankAccountLedgerEntry2.Amount < 0 then
                                    UnpresentedChequesTotal := UnpresentedChequesTotal + BankAccountLedgerEntry2.Amount
                                else
                                    if BankAccountLedgerEntry2.Amount > 0 then
                                        UncreditedBanking := UncreditedBanking + BankAccountLedgerEntry2.Amount;
                        until BankAccountLedgerEntry2.Next = 0;

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

                    BankAccReconciliationLine2.Reset;
                    BankAccReconciliationLine2.SetRange(BankAccReconciliationLine2."Bank Account No.", "Bank Acc. Reconciliation"."Bank Account No.");
                    BankAccReconciliationLine2.SetRange(BankAccReconciliationLine2."Statement No.", "Bank Acc. Reconciliation"."Statement No.");
                    BankAccReconciliationLine2.SetFilter(Difference, '<>%1', 0);
                    if BankAccReconciliationLine2.FindSet then begin
                        BankAccReconciliationLine2.CalcSums(Difference);
                        DifferencesInBankTotal := BankAccReconciliationLine2.Difference;
                    end;
                    //Have deits and credits Separate
                    BankAccReconciliationLine2.Reset;
                    BankAccReconciliationLine2.SetRange(BankAccReconciliationLine2."Bank Account No.", "Bank Acc. Reconciliation"."Bank Account No.");
                    BankAccReconciliationLine2.SetRange(BankAccReconciliationLine2."Statement No.", "Bank Acc. Reconciliation"."Statement No.");
                    BankAccReconciliationLine2.SetFilter(Difference, '<>%1', 0);
                    if BankAccReconciliationLine2.FindSet then begin
                        repeat
                            if BankAccReconciliationLine2.Difference > 0 then
                                DifferencesInBankTotalDebits := DifferencesInBankTotalDebits + BankAccReconciliationLine2.Difference
                            else
                                if BankAccReconciliationLine2.Difference < 0 then
                                    DifferencesInBankTotalCredits := (DifferencesInBankTotalCredits + BankAccReconciliationLine2.Difference * -1)

                  until BankAccReconciliationLine2.Next = 0
                    end;




                    if ((BankAccountBalanceasperCashBook + UnpresentedChequesTotal - UncreditedBanking) + TotalDifference - DifferencesBW = "Statement Ending Balance") then
                        ReconciliationStatement := ''
                    else
                        ReconciliationStatement := 'Reconciliation is incomplete please go through it again';
                end;

            end;

            trigger OnPreDataItem()
            begin
                CompanyInfo.Get;
                CompanyInfo.CalcFields(Picture);
            end;
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }

    trigger OnPreReport()
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

    local procedure AddError(Text: Text[250])
    begin
        /*
        ErrorCounter := ErrorCounter + 1;
        ErrorText[ErrorCounter] := Text;
        */

    end;

    procedure TotalDiffFunc()
    begin
        BankRecPresented.Reset;
        BankRecPresented.SetRange(BankRecPresented."Bank Account No.", "Bank Acc. Reconciliation"."Bank Account No.");
        BankRecPresented.SetRange(BankRecPresented."Statement No.", "Bank Acc. Reconciliation"."Statement No.");
        //BankRecPresented.SETRANGE(BankRecPresented.Reconciled,TRUE);
        if BankRecPresented.Find('-') then
            repeat
                TotalDifference := TotalDifference + BankRecPresented.Difference;
            until BankRecPresented.Next = 0;
        //MESSAGE('%1',TotalDifference);
    end;
}

