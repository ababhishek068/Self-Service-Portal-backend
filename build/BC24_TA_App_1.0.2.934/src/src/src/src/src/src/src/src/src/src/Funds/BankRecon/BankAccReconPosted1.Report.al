Report 50064 "Bank Acc. Recon. -Posted1"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/BankAccReconPosted1.rdlc';
    Caption = 'Bank Acc. Recon. - Test';
    ApplicationArea = All;

    dataset
    {
        dataitem("Bank Account Statement"; "Bank Account Statement")
        {
            RequestFilterFields = "Statement No.";
            column(ReportForNavId_38; 38) { }
            column(BankAccountNo_BankAccountStatement; "Bank Account Statement"."Bank Account No.") { }
            column(StatementNo_BankAccountStatement; "Bank Account Statement"."Statement No.") { }
            column(StatementEndingBalance_BankAccountStatement; "Bank Account Statement"."Statement Ending Balance") { }
            column(StatementDate_BankAccountStatement; "Bank Account Statement"."Statement Date") { }
            column(BalanceLastStatement_BankAccountStatement; "Bank Account Statement"."Balance Last Statement") { }
            column(CashBookBalance_BankAccountStatement; "Bank Account Statement"."Cash Book Balance") { }
            column(BankCode; BankCode) { }
            column(BankAccountNo; BankAccountNo) { }
            column(BankName; BankName) { }
            column(BankAccountBalanceasperCashBook; BankAccountBalanceasperCashBook) { }
            column(UnpresentedChequesTotal; UnpresentedChequesTotal) { }
            column(UncreditedBanking; UncreditedBanking) { }
            column(UnpresentedChequesTotal2; UnpresentedChequesTotal2) { }
            column(UncreditedBanking2; UncreditedBanking2) { }
            column(CompanyName; CompanyInfo.Name) { }
            column(CompanyAddress; CompanyInfo.Address) { }
            column(DifferencesInBankTotalDebits; DifferencesInBankTotalDebits) { }
            column(DifferencesInBankTotalCredits; DifferencesInBankTotalCredits) { }
            dataitem(BankAccountLedgerEntry; "PosteBank Account Ledger Entry")
            {
                DataItemLink = "Bank Account No." = field("Bank Account No."), "Statement No." = field("Statement No.");
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
                    SetFilter("Posting Date", '%1..%2', 20010101D, "Bank Account Statement"."Statement Date");
                    SetFilter("Statement Status", '%1', "statement status"::Open);
                    SetFilter(Open, '%1', true);
                    SetFilter(Reversed, '%1', false);

                    //BankAccountLedgerEntry.SETFILTER("Statement Difference",'<>%1',0);
                    SetFilter(Amount, '<%1', 0);
                    //SETFILTER("Statement Difference",'<%1',0);
                end;
            }
            dataitem(BankAccountLedgerEntry1; "PosteBank Account Ledger Entry")
            {
                DataItemLink = "Bank Account No." = field("Bank Account No."), "Statement No." = field("Statement No.");
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
                    SetFilter("Posting Date", '%1..%2', 20010101D, "Bank Account Statement"."Statement Date");
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
                column(BankDebits; BankDebits) { }
                column(BankCredits; BankCredits) { }
                column(CreditAmount_BankAccReconciliationLine; "Bank Acc. Reconciliation Line"."Credit Amount") { }
                column(DebitAmount_BankAccReconciliationLine; "Bank Acc. Reconciliation Line"."Debit Amount") { }
                column(CheckNo_BankAccReconciliationLine; "Bank Acc. Reconciliation Line"."Check No.") { }
                column(AdditionalTransactionInfo_BankAccReconciliationLine; "Bank Acc. Reconciliation Line"."Additional Transaction Info") { }
            }
            dataitem(BankAccReconciliationLine1; "Bank Account Statement Line1")
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


                trigger OnPreDataItem()
                begin
                    BankAccReconciliationLine1.SetFilter(Difference, '>%1', 0);
                end;
            }
            dataitem(BankAccReconciliationLine3; "Bank Account Statement Line1")
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


                trigger OnPreDataItem()
                begin
                    BankAccReconciliationLine3.SetFilter(Difference, '<%1', 0);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                BankCode := '';
                BankAccountNo := '';
                BankName := '';
                BankAccountBalanceasperCashBook := 0;
                UnpresentedChequesTotal := 0;
                UncreditedBanking := 0;

                /*Bank.RESET;
                Bank.SETRANGE(Bank."No.","Bank Account No.");
                IF Bank.FIND('-') THEN BEGIN
                  BankCode:=Bank."No.";
                  BankAccountNo:=Bank."Bank Account No.";
                  BankName:=Bank.Name;
                 // Bank.CALCFIELDS(Bank.Balance);
                 // BankAccountBalanceasperCashBook:="Cash Book Balance";
                   BankAccountBalanceasperCashBook:="Bank Account Statement"."Cash Book Balance";
                */
                Bank.Reset;
                Bank.SetRange(Bank."No.", "Bank Account No.");
                if Bank.Find('-') then begin
                    BankCode := Bank."No.";
                    BankAccountNo := Bank."Bank Account No.";
                    BankName := Bank.Name;
                    Bank.SetRange(Bank."Date Filter", 0D, "Statement Date");
                    Bank.CalcFields(Bank."Net Change");
                    BankAccountBalanceasperCashBook := Bank."Net Change" + Bank."Min. Balance";

                    BankStatementLine.Reset;
                    BankStatementLine.SetRange(BankStatementLine."Bank Account No.", Bank."No.");
                    BankStatementLine.SetRange(BankStatementLine."Statement No.", "Statement No.");
                    BankStatementLine.SetRange(BankStatementLine.Reconciled, false);
                    BankStatementLine.SetFilter(BankStatementLine."Applied Amount", '=%1', 0);
                    if BankStatementLine.Find('-') then
                        repeat
                            if BankStatementLine.Difference < 0 then
                                UnpresentedChequesTotal := UnpresentedChequesTotal + BankStatementLine.Difference
                            else
                                if BankStatementLine."Statement Amount" > 0 then
                                    UncreditedBanking := UncreditedBanking + BankStatementLine.Difference;
                        until BankStatementLine.Next = 0;

                    UnpresentedChequesTotal := UnpresentedChequesTotal * -1;

                    //BankStatementLine


                end;
                UnpresentedChequesTotal2 := 0;
                UncreditedBanking2 := 0;
                //ERROR('Test '+FORMAT(Bank."No."));
                BankAccountLedgerEntry.Reset;
                BankAccountLedgerEntry.SetRange("Bank Account No.", Bank."No.");
                BankAccountLedgerEntry.SetRange(Open, true);
                BankAccountLedgerEntry.SetRange(Reversed, false);
                BankAccountLedgerEntry.SetRange("Statement No.", "Bank Account Statement"."Statement No.");
                BankAccountLedgerEntry.SetFilter("Posting Date", '%1..%2', 20010101D, "Bank Account Statement"."Statement Date");
                //BankAccountLedgerEntry2.SETFILTER("Statement Difference",'<>%1',0);
                if BankAccountLedgerEntry.Find('-') then begin
                    repeat

                        //IsApplied :=FALSE;
                        IsApplied := BankAccountLedgerEntry."Statement Status" = BankAccountLedgerEntry."statement status"::Open;

                        if IsApplied then begin
                            if BankAccountLedgerEntry.Amount < 0 then
                                UnpresentedChequesTotal2 := UnpresentedChequesTotal2 + BankAccountLedgerEntry.Amount
                            else
                                if BankAccountLedgerEntry.Amount > 0 then
                                    UncreditedBanking2 := UncreditedBanking2 + BankAccountLedgerEntry.Amount;

                        end;
                    until BankAccountLedgerEntry.Next = 0;
                end;
                UnpresentedChequesTotal2 := UnpresentedChequesTotal2 * -1;

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
                                UserName3 := UserRec2.UserName;
                                UserDesign3 := UserRec2."Approval Title";
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
        TotalDifference: Decimal;
        BankRecPresented: Record "Bank Acc. Reconciliation Line";
        SNo: Integer;
        SNo1: Integer;
        DifferencesInBankTotalDebits: Decimal;
        DifferencesInBankTotalCredits: Decimal;
        IsApplied: Boolean;
        BankDebits: Decimal;
        BankCredits: Decimal;
        UnpresentedChequesTotal2: Decimal;
        UncreditedBanking2: Decimal;
        ApprovalEntry: Record "Approval Entry";
        UserRec1: Record "User Setup";
        UserRec2: Record "User Setup";
        UserRec3: Record "User Setup";
        UserRec4: Record "User Setup";
        UserRec5: Record "User Setup";
        UserName1: text[100];
        UserDesign1: text[100];
        ApprovalDate1: DateTime;
        UserName2: text[100];
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
        UserRec6: Record "User Setup";
        SenderName: text[100];
        SenderDesign: text[100];
        SendDate: DateTime;
        HREmp: Record "HR-Employee";

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
        BankRecPresented.SetRange(BankRecPresented."Bank Account No.", "Bank Account Statement"."Bank Account No.");
        BankRecPresented.SetRange(BankRecPresented."Statement No.", "Bank Account Statement"."Statement No.");
        //BankRecPresented.SETRANGE(BankRecPresented.Reconciled,TRUE);
        if BankRecPresented.Find('-') then
            repeat
                TotalDifference := TotalDifference + BankRecPresented.Difference;
            until BankRecPresented.Next = 0;
        //MESSAGE('%1',TotalDifference);
    end;
}

