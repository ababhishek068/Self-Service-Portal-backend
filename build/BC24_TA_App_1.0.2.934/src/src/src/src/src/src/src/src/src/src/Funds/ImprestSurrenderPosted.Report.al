Report 50290 "Imprest Surrender Posted"
{
    DefaultLayout = RDLC;
    RDLCLayout = './NewLayouts/ImprestSurrenderPosted.rdl';
    ApplicationArea = All;

    dataset
    {
        dataitem("Imprest Surrender Header"; "Imprest Surrender Header")
        {
            RequestFilterFields = No, "Surrender Date";
            column(ReportForNavId_1; 1) { }
            column(No_ImprestSurrenderHeader; "Imprest Surrender Header".No) { }
            column(SurrenderDate_ImprestSurrenderHeader; "Imprest Surrender Header"."Surrender Date") { }
            column(Type_ImprestSurrenderHeader; "Imprest Surrender Header".Type) { }
            column(PayMode_ImprestSurrenderHeader; "Imprest Surrender Header"."Pay Mode") { }
            column(ChequeNo_ImprestSurrenderHeader; "Imprest Surrender Header"."Cheque No") { }
            column(ChequeDate_ImprestSurrenderHeader; "Imprest Surrender Header"."Cheque Date") { }
            column(ChequeType_ImprestSurrenderHeader; "Imprest Surrender Header"."Cheque Type") { }
            column(BankCode_ImprestSurrenderHeader; "Imprest Surrender Header"."Bank Code") { }
            column(ReceivedFrom_ImprestSurrenderHeader; "Imprest Surrender Header"."Received From") { }
            column(OnBehalfOf_ImprestSurrenderHeader; "Imprest Surrender Header"."On Behalf Of") { }
            column(Cashier_ImprestSurrenderHeader; "Imprest Surrender Header".Cashier) { }
            column(AccountType_ImprestSurrenderHeader; "Imprest Surrender Header"."Account Type") { }
            column(AccountNo_ImprestSurrenderHeader; "Imprest Surrender Header"."Account No.") { }
            column(NoSeries_ImprestSurrenderHeader; "Imprest Surrender Header"."No. Series") { }
            column(AccountName_ImprestSurrenderHeader; "Imprest Surrender Header"."Account Name") { }
            column(Posted_ImprestSurrenderHeader; "Imprest Surrender Header".Posted) { }
            column(DatePosted_ImprestSurrenderHeader; "Imprest Surrender Header"."Date Posted") { }
            column(TimePosted_ImprestSurrenderHeader; "Imprest Surrender Header"."Time Posted") { }
            column(PostedBy_ImprestSurrenderHeader; "Imprest Surrender Header"."Posted By") { }
            column(Amount_ImprestSurrenderHeader; "Imprest Surrender Header".Amount) { }
            column(Remarks_ImprestSurrenderHeader; "Imprest Surrender Header".Remarks) { }
            column(TransactionName_ImprestSurrenderHeader; "Imprest Surrender Header"."Transaction Name") { }
            column(NetAmount_ImprestSurrenderHeader; "Imprest Surrender Header"."Net Amount") { }
            column(PayingBankAccount_ImprestSurrenderHeader; "Imprest Surrender Header"."Paying Bank Account") { }
            column(Payee_ImprestSurrenderHeader; "Imprest Surrender Header".Payee) { }
            column(GlobalDimension1Code_ImprestSurrenderHeader; "Imprest Surrender Header"."Global Dimension 1 Code") { }
            column(GlobalDimension2Code_ImprestSurrenderHeader; "Imprest Surrender Header"."Global Dimension 2 Code") { }
            column(BankAccountNo_ImprestSurrenderHeader; "Imprest Surrender Header"."Bank Account No") { }
            column(CashierBankAccount_ImprestSurrenderHeader; "Imprest Surrender Header"."Cashier Bank Account") { }
            column(Status_ImprestSurrenderHeader; "Imprest Surrender Header".Status) { }
            column(Grouping_ImprestSurrenderHeader; "Imprest Surrender Header".Grouping) { }
            column(PaymentType_ImprestSurrenderHeader; "Imprest Surrender Header"."Payment Type") { }
            column(BankType_ImprestSurrenderHeader; "Imprest Surrender Header"."Bank Type") { }
            column(PVType_ImprestSurrenderHeader; "Imprest Surrender Header"."PV Type") { }
            column(ApplytoID_ImprestSurrenderHeader; "Imprest Surrender Header"."Apply to ID") { }
            column(NoPrinted_ImprestSurrenderHeader; "Imprest Surrender Header"."No. Printed") { }
            column(ImprestIssueDate_ImprestSurrenderHeader; "Imprest Surrender Header"."Imprest Issue Date") { }
            column(Surrendered_ImprestSurrenderHeader; "Imprest Surrender Header".Surrendered) { }
            column(ImprestIssueDocNo_ImprestSurrenderHeader; "Imprest Surrender Header"."Imprest Issue Doc. No") { }
            column(VoteBook_ImprestSurrenderHeader; "Imprest Surrender Header"."Vote Book") { }
            column(TotalAllocation_ImprestSurrenderHeader; "Imprest Surrender Header"."Total Allocation") { }
            column(TotalExpenditure_ImprestSurrenderHeader; "Imprest Surrender Header"."Total Expenditure") { }
            column(TotalCommitments_ImprestSurrenderHeader; "Imprest Surrender Header"."Total Commitments") { }
            column(Balance_ImprestSurrenderHeader; "Imprest Surrender Header".Balance) { }
            column(BalanceLessthisEntry_ImprestSurrenderHeader; "Imprest Surrender Header"."Balance Less this Entry") { }
            column(PettyCash_ImprestSurrenderHeader; "Imprest Surrender Header"."Petty Cash") { }
            column(ShortcutDimension2Code_ImprestSurrenderHeader; "Imprest Surrender Header"."Shortcut Dimension 2 Code") { }
            column(FunctionName_ImprestSurrenderHeader; "Imprest Surrender Header"."Function Name") { }
            column(BudgetCenterName_ImprestSurrenderHeader; "Imprest Surrender Header"."Budget Center Name") { }
            column(UserID_ImprestSurrenderHeader; "Imprest Surrender Header"."User ID") { }
            column(IssueVoucherType_ImprestSurrenderHeader; "Imprest Surrender Header"."Issue Voucher Type") { }
            column(ShortcutDimension3Code_ImprestSurrenderHeader; "Imprest Surrender Header"."Shortcut Dimension 3 Code") { }
            column(ShortcutDimension4Code_ImprestSurrenderHeader; "Imprest Surrender Header"."Shortcut Dimension 4 Code") { }
            column(ShortcutDimension5Code_ImprestSurrenderHeader; "Imprest Surrender Header"."Shortcut Dimension 5 Code") { }
            column(Dim3_ImprestSurrenderHeader; "Imprest Surrender Header".Dim3) { }
            column(Dim4_ImprestSurrenderHeader; "Imprest Surrender Header".Dim4) { }
            column(CurrencyFactor_ImprestSurrenderHeader; "Imprest Surrender Header"."Currency Factor") { }
            column(CurrencyCode_ImprestSurrenderHeader; "Imprest Surrender Header"."Currency Code") { }
            column(ResponsibilityCenter_ImprestSurrenderHeader; "Imprest Surrender Header"."Responsibility Center") { }
            column(AmountSurrenderedLCY_ImprestSurrenderHeader; "Imprest Surrender Header"."Amount Surrendered LCY") { }
            column(PVNo_ImprestSurrenderHeader; "Imprest Surrender Header"."PV No") { }
            column(PrintNo_ImprestSurrenderHeader; "Imprest Surrender Header"."Print No.") { }
            column(CashSurrenderAmt_ImprestSurrenderHeader; "Imprest Surrender Header"."Cash Surrender Amt") { }
            column(FinancialPeriod_ImprestSurrenderHeader; "Imprest Surrender Header"."Financial Period") { }
            column(CompanyName; CompInf.Name) { }
            column(CompanyPicture; CompInf.Picture) { }
            column(CompanyAddr1; CompInf.Address) { }
            column(CompanyAddr2; CompInf."Address 2") { }
            column(CompanyPhone; CompInf."Phone No.") { }
            column(CompanyName2; CompInf."Name 2") { }
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
            dataitem("Imprest Surrender Details"; "Imprest Surrender Details")
            {
                DataItemLink = "Surrender Doc No." = field(No);
                column(ReportForNavId_65; 65) { }
                column(SurrenderDocNo_ImprestSurrenderDetails; "Imprest Surrender Details"."Surrender Doc No.") { }
                column(AccountNo_ImprestSurrenderDetails; "Imprest Surrender Details"."Account No:") { }
                column(AccountName_ImprestSurrenderDetails; "Imprest Surrender Details"."Account Name") { }
                column(Amount_ImprestSurrenderDetails; "Imprest Surrender Details".Amount) { }
                column(DueDate_ImprestSurrenderDetails; "Imprest Surrender Details"."Due Date") { }
                column(ImprestHolder_ImprestSurrenderDetails; "Imprest Surrender Details"."Imprest Holder") { }
                column(ActualSpent_ImprestSurrenderDetails; "Imprest Surrender Details"."Actual Spent") { }
                column(Applyto_ImprestSurrenderDetails; "Imprest Surrender Details"."Apply to") { }
                column(ApplytoID_ImprestSurrenderDetails; "Imprest Surrender Details"."Apply to ID") { }
                column(SurrenderDate_ImprestSurrenderDetails; "Imprest Surrender Details"."Surrender Date") { }
                column(Surrendered_ImprestSurrenderDetails; "Imprest Surrender Details".Surrendered) { }
                column(CashReceiptNo_ImprestSurrenderDetails; "Imprest Surrender Details"."Cash Receipt No") { }
                column(DateIssued_ImprestSurrenderDetails; "Imprest Surrender Details"."Date Issued") { }
                column(TypeofSurrender_ImprestSurrenderDetails; "Imprest Surrender Details"."Type of Surrender") { }
                column(DeptVchNo_ImprestSurrenderDetails; "Imprest Surrender Details"."Dept. Vch. No.") { }
                column(CashSurrenderAmt_ImprestSurrenderDetails; "Imprest Surrender Details"."Cash Surrender Amt") { }
                column(BankPettyCash_ImprestSurrenderDetails; "Imprest Surrender Details"."Bank/Petty Cash") { }
                column(DocNo_ImprestSurrenderDetails; "Imprest Surrender Details"."Doc No.") { }
                column(ShortcutDimension1Code_ImprestSurrenderDetails; "Imprest Surrender Details"."Shortcut Dimension 1 Code") { }
                column(ShortcutDimension2Code_ImprestSurrenderDetails; "Imprest Surrender Details"."Shortcut Dimension 2 Code") { }
                column(ShortcutDimension3Code_ImprestSurrenderDetails; "Imprest Surrender Details"."Shortcut Dimension 3 Code") { }
                column(ShortcutDimension4Code_ImprestSurrenderDetails; "Imprest Surrender Details"."Shortcut Dimension 4 Code") { }
                column(ShortcutDimension5Code_ImprestSurrenderDetails; "Imprest Surrender Details"."Shortcut Dimension 5 Code") { }
                column(ShortcutDimension6Code_ImprestSurrenderDetails; "Imprest Surrender Details"."Shortcut Dimension 6 Code") { }
                column(ShortcutDimension7Code_ImprestSurrenderDetails; "Imprest Surrender Details"."Shortcut Dimension 7 Code") { }
                column(ShortcutDimension8Code_ImprestSurrenderDetails; "Imprest Surrender Details"."Shortcut Dimension 8 Code") { }
                column(VATProdPostingGroup_ImprestSurrenderDetails; "Imprest Surrender Details"."VAT Prod. Posting Group") { }
                column(ImprestType_ImprestSurrenderDetails; "Imprest Surrender Details"."Imprest Type") { }
                column(CurrencyFactor_ImprestSurrenderDetails; "Imprest Surrender Details"."Currency Factor") { }
                column(CurrencyCode_ImprestSurrenderDetails; "Imprest Surrender Details"."Currency Code") { }
                column(AmountLCY_ImprestSurrenderDetails; "Imprest Surrender Details"."Amount LCY") { }
                column(CashSurrenderAmtLCY_ImprestSurrenderDetails; "Imprest Surrender Details"."Cash Surrender Amt LCY") { }
                column(ImprestReqAmtLCY_ImprestSurrenderDetails; "Imprest Surrender Details"."Imprest Req Amt LCY") { }
                column(CashReceiptAmount_ImprestSurrenderDetails; "Imprest Surrender Details"."Cash Receipt Amount") { }
                column(ChequeDepositSlipNo_ImprestSurrenderDetails; "Imprest Surrender Details"."Cheque/Deposit Slip No") { }
                column(ChequeDepositSlipDate_ImprestSurrenderDetails; "Imprest Surrender Details"."Cheque/Deposit Slip Date") { }
                column(ChequeDepositSlipType_ImprestSurrenderDetails; "Imprest Surrender Details"."Cheque/Deposit Slip Type") { }
                column(ChequeDepositSlipBank_ImprestSurrenderDetails; "Imprest Surrender Details"."Cheque/Deposit Slip Bank") { }
                column(CashPayMode_ImprestSurrenderDetails; "Imprest Surrender Details"."Cash Pay Mode") { }
                column(OverExpenditure_ImprestSurrenderDetails; "Imprest Surrender Details"."Over Expenditure") { }
                column(NumberText; NumberText[1]) { }
                column(NumberText1; NumberText[2]) { }
                column(Balance; Balance) { }

                trigger OnAfterGetRecord()
                begin
                    Balance := 0;
                    Balance := "Imprest Surrender Details".Amount - "Imprest Surrender Details"."Actual Spent";

                    // "Imprest Surrender Header".CALCFIELDS("Imprest Surrender Header"."Net Amount");
                    CheckReport.FormatNoText(NumberText, "Imprest Surrender Header"."Net Amount", 0,'');
                    //CheckReport.FormatNoText(NumberText, Balance,'');
                end;
            }
            dataitem("Approval Entry"; "Approval Entry")
            {
                DataItemLink = "Document No." = FIELD(No);
                DataItemTableView = WHERE(Status = CONST(Approved));

                column(ApproverID_ApprovalEntry; "Approver ID") { }
                column(ApprovalName_ApprovalEntry; "Approval Name") { }
                column(DateTimeSentforApproval_ApprovalEntry; "Date-Time Sent for Approval") { }
                column(SenderID_ApprovalEntry; "Sender ID") { }
                column(Status_ApprovalEntry; Status) { }
            }

            trigger OnPreDataItem()
            begin
                CompInf.Get;
                CompInf.CalcFields(CompInf.Picture);
            end;

            trigger OnAfterGetRecord()
            begin
                ApprovalEntry.reset;
                ApprovalEntry.setrange("Document No.", "Imprest Surrender Header".No);
                ApprovalEntry.setrange(Status, ApprovalEntry.Status::Approved);
                if ApprovalEntry.find('-') then begin
                    repeat
                        if ApprovalEntry."Sequence No." = 1 then begin
                            UserRec1.reset;
                            UserRec1.setrange("User ID", ApprovalEntry."Approver ID");
                            if UserRec1.find('-') then begin
                                UserRec1.calcfields("User Signature");
                            end;
                        end;
                        if ApprovalEntry."Sequence No." = 2 then begin
                            UserRec2.reset;
                            UserRec2.setrange("User ID", ApprovalEntry."Approver ID");
                            if UserRec2.find('-') then begin
                                UserRec2.calcfields("User Signature");
                            end;
                        end;
                        if ApprovalEntry."Sequence No." = 3 then begin
                            UserRec3.reset;
                            UserRec3.setrange("User ID", ApprovalEntry."Approver ID");
                            if UserRec3.find('-') then begin
                                UserRec3.calcfields("User Signature");
                            end;
                        end;
                        if ApprovalEntry."Sequence No." = 4 then begin
                            UserRec4.reset;
                            UserRec4.setrange("User ID", ApprovalEntry."Approver ID");
                            if UserRec4.find('-') then begin
                                UserRec4.calcfields("User Signature");
                            end;
                        end;
                        if ApprovalEntry."Sequence No." = 5 then begin
                            UserRec5.reset;
                            UserRec5.setrange("User ID", ApprovalEntry."Approver ID");
                            if UserRec5.find('-') then begin
                                UserRec5.calcfields("User Signature");
                            end;
                        end;
                    until ApprovalEntry.next = 0;
                end;
            end;
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }

    var
        CompInf: Record "Company Information";
        CheckReport: Report "Check Translation Management";
        NumberText: array[2] of Text[100];
        Balance: Decimal;
        ApprovalEntry: Record "Approval Entry";
        UserRec1: Record "User Setup";
        UserRec2: Record "User Setup";
        UserRec3: Record "User Setup";
        UserRec4: Record "User Setup";
        UserRec5: Record "User Setup";
}

