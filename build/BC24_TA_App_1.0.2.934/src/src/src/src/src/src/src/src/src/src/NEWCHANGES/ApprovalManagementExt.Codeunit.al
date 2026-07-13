Codeunit 50025 "Approval Management Ext"
{

    trigger OnRun()
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnPopulateApprovalEntryArgument', '', true, true)]

    local procedure PopulateApprovalEntryArgument(RecRef: RecordRef; WorkflowStepInstance: Record "Workflow Step Instance"; VAR ApprovalEntryArgument: Record "Approval Entry")
    var
        Customer: Record Customer;
        TransportReq: Record "FLT-Transport Requisition";
        GenJournalBatch: Record "Gen. Journal Batch";
        GenJournalLine: Record "Gen. Journal Line";
        AppCard: Record "HR Appraisal Card1";
        HRJobs: Record "HR Jobs";
        HRLeaveRequisition: Record "HR Leave Application";
        HRTraining: Record "HR Training Applications";
        ImprestReq: Record "Imprest Header";
        ImpSur: Record "Imprest Surrender Header";
        IncomingDocument: Record "Incoming Document";
        InterBank: Record "InterBank Transfers";
        PaymentHeader: Record "Payments Header";
        PayrollP: Record "PR Payroll Periods";
        PurchaseHeader: Record "Purchase Header";
        SalesHeader: Record "Sales Header";
        StaffAdvance: Record "Staff Advance Header";
        StaffClaim: Record "Staff Claims Header";
        StoreReq: Record "Store Requistion Header";
        ApprovalAmount: Decimal;
        ApprovalAmountLCY: Decimal;
    begin
        ApprovalEntryArgument.INIT();
        ApprovalEntryArgument."Table ID" := RecRef.NUMBER;
        ApprovalEntryArgument."Record ID to Approve" := RecRef.RECORDID;
        ApprovalEntryArgument."Document Type" := ApprovalEntryArgument."Document Type"::" ";
        ApprovalEntryArgument."Approval Code" := WorkflowStepInstance."Workflow Code";
        ApprovalEntryArgument."Workflow Step Instance ID" := WorkflowStepInstance.ID;

        CASE RecRef.NUMBER OF
            DATABASE::"Purchase Header":
                begin
                    RecRef.SETTABLE(PurchaseHeader);
                    // CalcPurchaseDocAmount(PurchaseHeader,ApprovalAmount,ApprovalAmountLCY);
                    ApprovalEntryArgument."Document Type" := PurchaseHeader."Document Type";
                    ApprovalEntryArgument."Document No." := PurchaseHeader."No.";
                    ApprovalEntryArgument."Salespers./Purch. Code" := PurchaseHeader."Purchaser Code";
                    ApprovalEntryArgument.Amount := ApprovalAmount;
                    ApprovalEntryArgument."Amount (LCY)" := ApprovalAmountLCY;
                    ApprovalEntryArgument."Currency Code" := PurchaseHeader."Currency Code";
                end;
            DATABASE::"Sales Header":
                begin
                    RecRef.SETTABLE(SalesHeader);
                    // CalcSalesDocAmount(SalesHeader,ApprovalAmount,ApprovalAmountLCY);
                    ApprovalEntryArgument."Document Type" := SalesHeader."Document Type";
                    ApprovalEntryArgument."Document No." := SalesHeader."No.";
                    ApprovalEntryArgument."Salespers./Purch. Code" := SalesHeader."Salesperson Code";
                    ApprovalEntryArgument.Amount := ApprovalAmount;
                    ApprovalEntryArgument."Amount (LCY)" := ApprovalAmountLCY;
                    ApprovalEntryArgument."Currency Code" := SalesHeader."Currency Code";
                    //  ApprovalEntryArgument."Available Credit Limit (LCY)" := GetAvailableCreditLimit(SalesHeader);
                end;
            DATABASE::Customer:
                begin
                    RecRef.SETTABLE(Customer);
                    ApprovalEntryArgument."Salespers./Purch. Code" := Customer."Salesperson Code";
                    ApprovalEntryArgument."Currency Code" := Customer."Currency Code";
                    ApprovalEntryArgument."Available Credit Limit (LCY)" := Customer.CalcAvailableCredit();
                end;
            DATABASE::"Gen. Journal Batch":
                begin
                    RecRef.SETTABLE(GenJournalBatch);
                    PayrollP.Reset();
                    PayrollP.SetRange(Closed, false);
                    if PayrollP.FindFirst() then
                        ApprovalEntryArgument."Document No." := PayrollP."Period Name";
                end;
            DATABASE::"Gen. Journal Line":
                begin
                    RecRef.SETTABLE(GenJournalLine);
                    ApprovalEntryArgument."Document Type" := GenJournalLine."Document Type";
                    ApprovalEntryArgument."Document No." := GenJournalLine."Document No.";
                    ApprovalEntryArgument."Salespers./Purch. Code" := GenJournalLine."Salespers./Purch. Code";
                    ApprovalEntryArgument.Amount := GenJournalLine.Amount;
                    ApprovalEntryArgument."Amount (LCY)" := GenJournalLine."Amount (LCY)";
                    ApprovalEntryArgument."Currency Code" := GenJournalLine."Currency Code";
                end;
            DATABASE::"Incoming Document":
                begin
                    RecRef.SETTABLE(IncomingDocument);
                    ApprovalEntryArgument."Document No." := FORMAT(IncomingDocument."Entry No.");
                end;
            //HR leave Requisition
            DATABASE::"HR Leave Application":
                begin
                    RecRef.SETTABLE(HRLeaveRequisition);
                    ApprovalEntryArgument."Document No." := HRLeaveRequisition."Application Code";
                end;

            //Payment Voucher
            DATABASE::"Payments Header":
                begin
                    RecRef.SETTABLE(PaymentHeader);
                    ApprovalEntryArgument."Document No." := PaymentHeader."No.";
                    ApprovalEntryArgument."Document Type" := PaymentHeader."Document Type";
                end;

            //HR Jobs
            DATABASE::"HR Jobs":
                begin
                    RecRef.SETTABLE(HRJobs);
                    ApprovalEntryArgument."Document No." := HRJobs."Job ID";
                    ApprovalEntryArgument.Description := 'HR Job Applications'
                end;
            //Interbank Transfers
            DATABASE::"InterBank Transfers":
                begin
                    RecRef.SETTABLE(InterBank);
                    ApprovalEntryArgument."Document No." := InterBank.No;
                end;
            //Staff Advance Header
            DATABASE::"Staff Advance Header":
                begin
                    RecRef.SETTABLE(StaffAdvance);
                    ApprovalEntryArgument."Document No." := StaffAdvance."No.";
                end;

            // HR Training App Header
            DATABASE::"HR Training Applications":
                begin
                    RecRef.SETTABLE(HRTraining);
                    ApprovalEntryArgument."Document No." := HRTraining."Application No";
                end;

            // Store Requisition
            DATABASE::"Store Requistion Header":
                begin
                    RecRef.SETTABLE(StoreReq);
                    ApprovalEntryArgument."Document No." := StoreReq."No.";
                end;

            // Imprest Requisition
            DATABASE::"Imprest Header":
                begin
                    RecRef.SETTABLE(ImprestReq);
                    ApprovalEntryArgument."Document No." := ImprestReq."No.";
                    ApprovalEntryArgument.Description := 'Imprest Requisition';
                end;

            // Transport Requisition
            DATABASE::"FLT-Transport Requisition":
                begin
                    RecRef.SETTABLE(TransportReq);
                    ApprovalEntryArgument."Document No." := TransportReq."Transport Requisition No";
                end;

            // Staff Claim 
            DATABASE::"Staff Claims Header":
                begin
                    RecRef.SETTABLE(StaffClaim);
                    ApprovalEntryArgument."Document No." := StaffClaim."No.";
                end;

            // Imprest Surrender Header
            DATABASE::"Imprest Surrender Header":
                begin
                    RecRef.SETTABLE(ImpSur);
                    ApprovalEntryArgument."Document No." := ImpSur.No;
                end;

            // Appraisal Header
            DATABASE::"HR Appraisal Card1":
                begin
                    RecRef.SETTABLE(AppCard);
                    ApprovalEntryArgument."Document No." := AppCard."Appraisal Code";
                end;
        end;
    end;
}