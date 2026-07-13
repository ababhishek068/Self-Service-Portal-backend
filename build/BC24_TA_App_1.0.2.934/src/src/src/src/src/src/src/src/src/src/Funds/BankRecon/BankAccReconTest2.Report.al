Report 50065 "Bank Acc. Recon. - Test2"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/BankAccReconTest2.rdlc';
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
            column(DifferencesBW; DifferencesBW) { }
            column(DifferencesInBankTotal; DifferencesInBankTotal) { }
            column(DocNo; DocNo) { }
            column(Description; Descr) { }
            column(BankDebits; BankDebits) { }
            column(BankCredits; BankCredits) { }
            column(DifferencesInBankTotalDebits; DifferencesInBankTotalDebits) { }
            column(DifferencesInBankTotalCredits; DifferencesInBankTotalCredits) { }
            column(User_ID; "User ID") { }
            column(Signature_PreparedBy; UserRec."User Signature") { }
            column(PreparedByDesignation_UserSetup; UserRec."Approval Title") { }
            column(Signature_UserSetup; UserRec1."User Signature") { }
            column(ApprovalDesignation_UserSetup; UserRec1."Approval Title") { }
            column(Signature_UserSetup2; UserRec2."User Signature") { }
            column(ApprovalDesignation_UserSetup2; UserRec2."Approval Title") { }
            column(Signature_UserSetup3; UserRec3."User Signature") { }
            column(ApprovalDesignation_UserSetup3; UserRec3."Approval Title") { }
            column(Signature_UserSetup4; UserRec4."User Signature") { }
            column(ApprovalDesignation_UserSetup4; UserRec4."Approval Title") { }
            column(Signature_UserSetup5; UserRec5."User Signature") { }
            column(ApprovalDesignation_UserSetup5; UserRec5."Approval Title") { }
            column(UserDesign1; UserDesign1) { }
            column(UserDesign2; UserDesign2) { }
            column(UserDesign3; UserDesign3) { }
            column(UserDesign4; UserDesign4) { }
            column(UserDesign5; UserDesign5) { }
            column(ApprovalDate1; ApprovalDate1) { }
            column(ApprovalDate2; ApprovalDate2) { }
            column(ApprovalDate3; ApprovalDate3) { }
            column(ApprovalDate4; ApprovalDate4) { }
            column(ApprovalDate5; ApprovalDate5) { }
            column(UserName1; UserName1) { }
            column(UserName2; UserName2) { }
            column(UserName3; UserName3) { }
            column(UserName4; UserName4) { }
            column(UserName5; UserName5) { }

            column(SendDate; SendDate) { }
            column(SenderDesign; SenderDesign) { }
            column(SenderName; SenderName) { }
            column(SenderSignature; UserRec6."User Signature") { }

            dataitem(BankAccountLedgerEntry; "Bank Account Ledger Entry")
            {
                DataItemLink = "Bank Account No." = field("Bank Account No.");
                DataItemTableView = where("Statement Status" = filter(Open), Reversed = const(false), Open = const(true), Amount = filter(< 0), Amount = filter(<> 0));
                column(ReportForNavId_16; 16) { }
                column(StatementLineNo_BankAccountLedgerEntry; BankAccountLedgerEntry."Statement Line No.") { }
                column(DocumentNo_BankAccountLedgerEntry; BankAccountLedgerEntry."Document No.") { }
                column(TransactionDate_BankAccountLedgerEntry; BankAccountLedgerEntry."Posting Date") { }
                column(PayeeName_BankAccountLedgerEntry; BankAccountLedgerEntry."Payee Name") { }
                column(Description_BankAccountLedgerEntry; BankAccountLedgerEntry.Description) { }
                column(StatementAmount_BankAccountLedgerEntry; BankAccountLedgerEntry.Amount) { }
                column(SNo; SNo) { }
                column(Remarks_BankAccountLedgerEntry; BankAccountLedgerEntry.Remarks) { }
                column(StatementDifference_BankAccountLedgerEntry; BankAccountLedgerEntry."Statement Difference") { }
                column(CreditAmount_BankAccountLedgerEntry; BankAccountLedgerEntry."Credit Amount") { }
                column(ExternalDocumentNo_BankAccountLedgerEntry; BankAccountLedgerEntry."External Document No.") { }

                trigger OnAfterGetRecord()
                begin
                    SNo += 1;
                end;

                trigger OnPreDataItem()
                begin
                    //Reconciled=CONST(No)
                    //BankAccountLedgerEntry.SETFILTER("Posting Date",'<=%1',"Bank Acc. Reconciliation"."Statement Date");
                    SetFilter("Posting Date", '%1..%2', 20010101D, "Bank Acc. Reconciliation"."Statement Date");
                    SetFilter("Statement Status", '%1', "statement status"::Open);
                    SetFilter(Open, '%1', true);
                    SetFilter(Reversed, '%1', false);

                    //BankAccountLedgerEntry.SETFILTER("Statement Difference",'<>%1',0);
                    SetFilter(Amount, '<%1', 0);
                    //SETFILTER("Statement Difference",'<%1',0);
                end;
            }
            dataitem(BankAccountLedgerEntry1; "Bank Account Ledger Entry")
            {
                DataItemLink = "Bank Account No." = field("Bank Account No.");
                column(ReportForNavId_8; 8) { }
                column(StatementLineNo_BankAccountLedgerEntry1; BankAccountLedgerEntry1."Statement Line No.") { }
                column(DocumentNo_BankAccountLedgerEntry1; BankAccountLedgerEntry1."Document No.") { }
                column(TransactionDate_BankAccountLedgerEntry1; BankAccountLedgerEntry1."Posting Date") { }
                column(Description_BankAccountLedgerEntry1; BankAccountLedgerEntry1.Description) { }
                column(StatementAmount_BankAccountLedgerEntry1; BankAccountLedgerEntry1.Amount) { }
                column(SNo1; SNo1) { }
                column(Remarks_BankAccountLedgerEntry1; BankAccountLedgerEntry1.Remarks) { }
                column(StatementDifference_BankAccountLedgerEntry1; BankAccountLedgerEntry1."Statement Difference") { }
                column(ExternalDocumentNo_BankAccountLedgerEntry1; BankAccountLedgerEntry1."External Document No.") { }

                trigger OnAfterGetRecord()
                begin
                    SNo1 += 1;
                end;

                trigger OnPreDataItem()
                begin
                    //Reconciled=CONST(No)
                    //BankAccountLedgerEntry1.SETFILTER("Posting Date",'<=%1',"Bank Acc. Reconciliation"."Statement Date");
                    SetFilter("Posting Date", '%1..%2', 20010101D, "Bank Acc. Reconciliation"."Statement Date");
                    SetFilter("Statement Status", '%1', "statement status"::Open);
                    //BankAccountLedgerEntry1.SETFILTER("Statement Difference",'<>%1',0);
                    SetFilter(Open, '%1', true);
                    SetFilter(Reversed, '%1', false);
                    SetFilter(Amount, '>%1', 0);
                    //SETFILTER("Statement Difference",'>%1',0);

                    SetFilter("Debit Amount", '<>%1', 0);
                end;
            }
            dataitem("Bank Acc. Reconciliation Line"; "Bank Acc. Reconciliation Line")
            {
                DataItemLink = "Bank Account No." = field("Bank Account No."), "Statement No." = field("Statement No.");
                DataItemTableView = where(Difference = filter(<> 0), "Applied Amount" = filter(= 0));
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
            dataitem(BankAccReconciliationLine1; "Bank Acc. Statement Line")
            {
                DataItemLink = "Bank Account No." = field("Bank Account No."), "Statement No." = field("Statement No.");
                column(ReportForNavId_1000000015; 1000000015) { }
                column(StatementLineNo_BankAccReconciliationLine1; BankAccReconciliationLine1."Statement Line No.") { }
                column(DocumentNo_BankAccReconciliationLine1; BankAccReconciliationLine1."Document No.") { }
                column(TransactionDate_BankAccReconciliationLine1; BankAccReconciliationLine1."Transaction Date") { }
                column(Description_BankAccReconciliationLine1; BankAccReconciliationLine1.Description) { }
                column(StatementAmount_BankAccReconciliationLine1; BankAccReconciliationLine1."Statement Amount") { }
                column(Difference_BankAccReconciliationLine1; BankAccReconciliationLine1.Difference) { }
                column(CheckNo_BankAccReconciliationLine1; BankAccReconciliationLine1."Check No.") { }
                column(AdditionalTransactionInfo_BankAccReconciliationLine1; BankAccReconciliationLine1."Additional Transaction Info") { }

                trigger OnPreDataItem()
                begin
                    //BankAccReconciliationLine1.SETFILTER(Difference,'>%1',0);
                end;
            }
            dataitem(BankAccReconciliationLine3; "Bank Acc. Statement Line")
            {
                DataItemLink = "Bank Account No." = field("Bank Account No."), "Statement No." = field("Statement No.");
                column(ReportForNavId_52; 52) { }
                column(StatementLineNo_BankAccReconciliationLine3; BankAccReconciliationLine3."Statement Line No.") { }
                column(DocumentNo_BankAccReconciliationLine3; BankAccReconciliationLine3."Document No.") { }
                column(TransactionDate_BankAccReconciliationLine3; BankAccReconciliationLine3."Transaction Date") { }
                column(Description_BankAccReconciliationLine3; BankAccReconciliationLine3.Description) { }
                column(StatementAmount_BankAccReconciliationLine3; BankAccReconciliationLine3."Statement Amount") { }
                column(Difference_BankAccReconciliationLine3; BankAccReconciliationLine3.Difference) { }
                column(CheckNo_BankAccReconciliationLine3; BankAccReconciliationLine3."Check No.") { }
                column(AdditionalTransactionInfo_BankAccReconciliationLine3; BankAccReconciliationLine3."Additional Transaction Info") { }

                trigger OnPreDataItem()
                begin
                    //BankAccReconciliationLine3.SETFILTER(Difference,'<%1',0);
                end;
            }

            trigger OnAfterGetRecord()
            var
                BankAccountLedgerEntry2: Record "Bank Account Ledger Entry";
            begin
                BankCode := '';
                BankAccountNo := '';
                BankName := '';
                BankDebits := 0;
                BankCredits := 0;
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
                    BankAccountBalanceasperCashBook := Bank."Net Change" + Bank."Min. Balance";
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

                    BankAccReconciliationLine.Reset;
                    BankAccReconciliationLine.SetRange(BankAccReconciliationLine."Bank Account No.", "Bank Acc. Reconciliation"."Bank Account No.");
                    BankAccReconciliationLine.SetRange(BankAccReconciliationLine."Statement No.", "Bank Acc. Reconciliation"."Statement No.");
                    //BankAccReconciliationLine.SETRANGE(Imported,FALSE);
                    //BankAccReconciliationLine.SetRange(BankAccReconciliationLine.Type, BankAccReconciliationLine.Type::"Bank Account Ledger Entry");
                    BankAccReconciliationLine.SetFilter("Applied Amount", '=%1', 0);
                    if BankAccReconciliationLine.Difference < 0 then begin
                        BankDebits := BankDebits + BankAccReconciliationLine.Difference;
                    end else begin
                        BankCredits := BankCredits + BankAccReconciliationLine.Difference;
                    end;


                    DifferencesInBankTotal := 0;
                    DifferencesInBankTotalDebits := 0;
                    DifferencesInBankTotalCredits := 0;

                    BankAccReconciliationLine3.Reset;
                    BankAccReconciliationLine3.SetRange(BankAccReconciliationLine3."Bank Account No.", "Bank Acc. Reconciliation"."Bank Account No.");
                    BankAccReconciliationLine3.SetRange(BankAccReconciliationLine3."Statement No.", "Bank Acc. Reconciliation"."Statement No.");
                    BankAccReconciliationLine3.SetFilter(Difference, '<>%1', 0);
                    if BankAccReconciliationLine3.FindSet then begin
                        BankAccReconciliationLine3.CalcSums(Difference);
                        DifferencesInBankTotal := BankAccReconciliationLine3.Difference;
                    end;
                    //Have deits and credits Separate
                    BankAccReconciliationLine.Reset;
                    BankAccReconciliationLine.SetRange(BankAccReconciliationLine."Bank Account No.", "Bank Acc. Reconciliation"."Bank Account No.");
                    BankAccReconciliationLine.SetRange(BankAccReconciliationLine."Statement No.", "Bank Acc. Reconciliation"."Statement No.");
                    BankAccReconciliationLine.SetFilter(Difference, '<>%1', 0);
                    if BankAccReconciliationLine.FindSet then begin
                        repeat
                            if BankAccReconciliationLine.Difference > 0 then
                                DifferencesInBankTotalDebits := DifferencesInBankTotalDebits + BankAccReconciliationLine.Difference
                            else
                                if BankAccReconciliationLine.Difference < 0 then
                                    DifferencesInBankTotalCredits := (DifferencesInBankTotalCredits + BankAccReconciliationLine.Difference * -1)

                  until BankAccReconciliationLine.Next = 0
                    end;

                    BankAccReconciliationLine1.Reset;
                    BankAccReconciliationLine1.SetRange(BankAccReconciliationLine1."Bank Account No.", "Bank Acc. Reconciliation"."Bank Account No.");
                    BankAccReconciliationLine1.SetRange(BankAccReconciliationLine1."Statement No.", "Bank Acc. Reconciliation"."Statement No.");
                    BankAccReconciliationLine1.SetFilter(Difference, '<>%1', 0);
                    if BankAccReconciliationLine.FindSet then
                        //BEGIN
                        if BankAccReconciliationLine1.Difference < 0 then
                            BankDebits := BankDebits + BankAccReconciliationLine1."Statement Amount";

                    //END;

                    if ((BankAccountBalanceasperCashBook + UnpresentedChequesTotal - UncreditedBanking) + TotalDifference - DifferencesBW = "Statement Ending Balance") then
                        ReconciliationStatement := ''
                    else
                        ReconciliationStatement := 'Reconciliation is incomplete please go through it again';
                end;

                myDifferences := 0;

                myDifferences := ("Bank Acc. Reconciliation"."Statement Ending Balance" - UnpresentedChequesTotal - DifferencesInBankTotalDebits + DifferencesInBankTotalCredits + UncreditedBanking) - (BankAccountBalanceasperCashBook);
                if ReconciliationStatement <> '' then begin
                    if myDifferences > 0 then if myDifferences <= 10 then ReconciliationStatement := '';
                    if myDifferences < 0 then if myDifferences >= -10 then ReconciliationStatement := '';
                end;

                UserRec.reset;
                UserRec.setrange("User ID", "Bank Acc. Reconciliation"."User ID");
                if UserRec.find('-') then begin
                    UserRec.calcfields("User Signature");
                    PreparedBy := UserRec.UserName;
                    PrepDesign1 := UserRec."Approval Title";
                end;
                ApprovalEntry.reset;
                ApprovalEntry.setrange("Document No.", "Statement No.");
                ApprovalEntry.setrange(Status, ApprovalEntry.Status::Approved);
                if ApprovalEntry.find('-') then begin
                    repeat
                        if ApprovalEntry."Sequence No." = 1 then begin
                            UserRec1.reset;
                            UserRec1.setrange("User ID", ApprovalEntry."Approver ID");
                            if UserRec1.find('-') then begin
                                UserRec1.calcfields("User Signature");
                                UserName1 := UserRec1.UserName;
                                UserDesign1 := UserRec1."Approval Title";
                                ApprovalDate1 := ApprovalEntry."Last Date-Time Modified";
                            end;
                        end;
                        if ApprovalEntry."Sequence No." = 2 then begin
                            UserRec2.reset;
                            UserRec2.setrange("User ID", ApprovalEntry."Approver ID");
                            if UserRec2.find('-') then begin
                                UserRec2.calcfields("User Signature");
                                UserName2 := UserRec2.UserName;
                                UserDesign2 := UserRec2."Approval Title";
                                ApprovalDate2 := ApprovalEntry."Last Date-Time Modified";
                            end;
                        end;
                        if ApprovalEntry."Sequence No." = 3 then begin
                            UserRec3.reset;
                            UserRec3.setrange("User ID", ApprovalEntry."Approver ID");
                            if UserRec3.find('-') then begin
                                UserRec3.calcfields("User Signature");
                                UserName3 := UserRec3.UserName;
                                UserDesign3 := UserRec3."Approval Title";
                                ApprovalDate3 := ApprovalEntry."Last Date-Time Modified";
                            end;
                        end;
                        if ApprovalEntry."Sequence No." = 4 then begin
                            UserRec4.reset;
                            UserRec4.setrange("User ID", ApprovalEntry."Approver ID");
                            if UserRec4.find('-') then begin
                                UserRec4.calcfields("User Signature");
                                UserName4 := UserRec4.UserName;
                                UserDesign4 := UserRec4."Approval Title";
                                ApprovalDate4 := ApprovalEntry."Last Date-Time Modified";
                            end;
                        end;
                        if ApprovalEntry."Sequence No." = 5 then begin
                            UserRec5.reset;
                            UserRec5.setrange("User ID", ApprovalEntry."Approver ID");
                            if UserRec5.find('-') then begin
                                UserRec5.calcfields("User Signature");
                                UserName5 := UserRec5.UserName;
                                UserDesign5 := UserRec5."Approval Title";
                                ApprovalDate5 := ApprovalEntry."Last Date-Time Modified";
                            end;
                        end;
                        UserRec6.reset;
                        UserRec6.setrange("User ID", ApprovalEntry."Sender ID");
                        if UserRec6.find('-') then begin
                            UserRec6.calcfields("User Signature");
                            if HREmp.get(UserRec6."Employee No.") then;

                            SenderName := UserRec6.UserName;
                            SenderDesign := UserRec6."Approval Title";
                            SendDate := ApprovalEntry."Date-Time Sent for Approval";
                        end;
                    until ApprovalEntry.next = 0;
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
        BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";
        DifferencesInBankTotal: Decimal;
        DifferencesInBankTotalDebits: Decimal;
        DifferencesInBankTotalCredits: Decimal;
        IsApplied: Boolean;
        BankDebits: Decimal;
        BankCredits: Decimal;
        DocNo: Code[30];
        Descr: Text[250];
        myDifferences: Decimal;
        UserRec: Record "User Setup";
        UserRec6: Record "User Setup";
        UserRec1: Record "User Setup";
        UserRec2: Record "User Setup";
        UserRec3: Record "User Setup";
        UserRec4: Record "User Setup";
        UserRec5: Record "User Setup";
        UserName1: text[100];
        ApprovalDate1: DateTime;
        UserName2: text[100];

        UserDesign1: text[100];
        UserDesign2: text[100];
        ApprovalDate2: DateTime;
        UserName3: text[100];
        UserDesign3: text[100];
        ApprovalDate3: DateTime;
        UserName4: text[100];
        UserDesign4: text[100];
        ApprovalDate4: DateTime;
        UserName5: text[100];
        UserDesign5: text[100];
        ApprovalDate5: DateTime;
        SenderName: text[100];
        SenderDesign: text[100];
        SendDate: DateTime;
        HREmp: Record "HR-Employee";
        ApprovalEntry: record "Approval Entry";
        PreparedBy: text[200];
        PrepDesign1: text[200];
    //Approvals Ends

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

