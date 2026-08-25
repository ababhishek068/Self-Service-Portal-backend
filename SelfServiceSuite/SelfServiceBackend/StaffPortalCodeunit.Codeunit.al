codeunit 50049 "Staff Portal Codeunit"
{

    trigger OnRun()
    begin
    end;

    var
        NextNo: Code[20];
        CuNoSeriesMgt: Codeunit "No. Series";
        TbApprovalEntry: Record "Approval Entry";
        TbApprovalCommentLine: Record "Approval Comment Line";
        TbHRLeaveRequisition: Record "HR Leave Application";
        TbPrSalaryCard: Record "PR Salary Card";
        TbGeneralSetup: Record "General Set-Up";
        FILESPATH: Text[250];
        filename: Text[250];
        TbEmployeeMaster: Record "HR-Employee";
        Convert: DotNet Convert;
        IOFile: dotnet File;
        TbEmployee: Record "HR-Employee";
        TbImprestRequisitionHeader: Record "Imprest Header";
        TbImprestRequisitionLines: Record "Imprest Lines";
        TbCashOfficeSetup: Record "Cash Office Setup";
        TbAdvFinSetup: Record "General Ledger Setup";
        VarVariant: Variant;
        CuCustomApprovals: Codeunit "Custom Approvals Codeunit";
        CuLeaveApprovals: Codeunit "Custom Approvals CU";
        CuApprovalsManagement: Codeunit "Approvals Mgmt.";
        TbCommitments: Record Committment;
        CuBudgetaryControl: Codeunit "GLBudget-Open";
        // TbReceiptPaymentType: Record UnknownRecord52202804;
        TbCustomer: Record Customer;
        TbStoreRequisition: Record "Store Requistion Header";
        TbStoreRequisitionLine: Record "Store Requistion Lines";
        TbItem: Record Item;
        TbPurchaseHeader: Record "Purchase Header";
        TbPurchaseLine: Record "Purchase Line";
        TbProcurementSetup: Record "Purchases & Payables Setup";
        TbTransportRequisition: Record "FLT-Transport Requisition";
        TbUserSetup: Record "User Setup";
        TbDocumentAttachment: Record "Document Attachment";
        TbImprestSurrenderHeader: Record "Imprest Surrender Header";
        TbImprestSurrenderHeader2: Record "Imprest Surrender Header";
        PettyCashHeaderTbl: Record "Payments Header";
        PettyCashLineTbl: Record "Payment Line";
        TbImprestSurrenderLines: Record "Imprest Surrender Details";
        TbStaffClaimsHeader: Record "Staff Claims Header";
        // TbHRJobs: Record UnknownRecord52202538;
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application","Staff Advance","Staff Advance Accounting";
        DocState: Option Open,"Pending Approval",Cancelled,Approved;
        RpLeaveStatement: Report "Leave statements1";
        TbLeaveLedger: Record "HR Leave Ledger";
        TbLeaveLedger2: Record "HR Leave Ledger";
        TbStaffClaimHeader: Record "Staff Claims Header";
        TbStaffClaimLines: Record "Staff Claim Lines";
        TbTenantMedia: Record "Tenant Media";
        IndividualPayslip: Report "Individual Payslips mst";
        RpPayslip: Report "PR Individual Payslip";
        RpPnine: Report "P9 Report (Final)";
        TbEmployeePnine: Record "HR-Employee";
        // CuImprestMgt: Codeunit UnknownCodeunit52202434;
        // TbClaimSetup: Record UnknownRecord52202487;
        TbHRSetup: Record "HR Setup";
        TbPVHeader: Record "Payments Header";
        TbPVLine: Record "Payment Line";
        // TbCashMgtSetup: Record UnknownRecord52202787;
        // TODO: Staff Portal: Find correct Payment Voucher
        RpPV: Report "Payment Voucher Vend";
        TbPaPerTrans: Record "PR Period Transactions";
        TbLeavePeriod: Record "HR Leave Calendar.";
        TbEmp99Info: Record "PR Employee P9 Info";
        PRSalaryCard: Record "PR Salary Card";
        // TODO: Staff Portal Get Correct Payroll summary Detailed
        RpMasterRoll: Report "Company Payroll Summary";
        MyRecordRef: RecordRef;
        MyOutstream: OutStream;
        TbTempBlob: Codeunit "Temp Blob";
        // TODO: Staff Portal: Align Training MOdule
        TbTrainingHe: Record "HR Training Applications";
        // TODO: Staff Portal: Align Training MOdule
        TbTrainingParticipant: Record "HR Training Participants";
        // TODO: Staff Portal: Align Appraisla Module
        // TbAppraisalScore: Record UnknownRecord52202473;
        TbAppraisalHe: Record "HR Appraisal Header - UP";
        DocumentAttachment: Record "Document Attachment";
        HRLeaveApplication: Record "HR Leave Application";

    procedure DocumentApproval(entryNo: Integer; docNo: Code[100]; userID: Code[100]; isApprove: Boolean; comments: Text[250]) return_value: Boolean
    var
        RequesterUserID: Code[50];
        PortalApproverID: Code[50];
        DocTypeForComment: Integer;
        RecordIdForComment: RecordId;
        SequenceNoForComment: Integer;
        TableIdForComment: Integer;
    begin
        // Portal SOAP runs as ADMIN/service account. The real approver identity is supplied
        // by the portal in userID. Do not require Approval Administrator on ADMIN: BC
        // explicitly forbids that setup, and the approval audit must retain the real user.
        return_value := false;
        PortalApproverID := userID;
        if PortalApproverID = '' then
            Error('Approver user ID is required.');

        if not FnFindOpenApprovalEntry(entryNo, docNo, PortalApproverID) then
            Error('Record to approve not found for approver %1.', PortalApproverID);

        if (TbApprovalEntry."Sender ID" = '') or (TbApprovalEntry."Sender ID" = 'ADMIN') then begin
            RequesterUserID := FnStoreReqRequesterUserID(docNo, '');
            if (RequesterUserID <> '') and (RequesterUserID <> 'ADMIN') then begin
                TbApprovalEntry."Sender ID" := RequesterUserID;
                TbApprovalEntry.Modify();
                Commit();
            end;
        end;

        DocTypeForComment := TbApprovalEntry."Document Type";
        RecordIdForComment := TbApprovalEntry."Record ID to Approve";
        SequenceNoForComment := TbApprovalEntry."Sequence No.";
        TableIdForComment := TbApprovalEntry."Table ID";

        FnApproveOrRejectOnBehalfOfPortalUser(TbApprovalEntry, PortalApproverID, isApprove);

        DocumentApprovalComments(docNo, comments, PortalApproverID, DocTypeForComment, RecordIdForComment, SequenceNoForComment, TableIdForComment);

        if not FnApprovalDecisionCompleted(entryNo, isApprove) then
            Error('Approval decision for %1 did not complete for approver %2.', docNo, PortalApproverID);

        return_value := true;
    end;

    procedure LeaveDocumentApproval(entryNo: Integer; docNo: Code[100]; userID: Code[100]; isApprove: Boolean; comments: Text[250]; leaveReliever: Code[30]) return_value: Boolean
    var
        TbLeaveApp: Record "HR Leave Application";
        PortalApproverID: Code[50];
        DocTypeForComment: Integer;
        RecordIdForComment: RecordId;
        SequenceNoForComment: Integer;
        TableIdForComment: Integer;
    begin
        return_value := false;
        PortalApproverID := userID;
        if PortalApproverID = '' then
            Error('Approver user ID is required.');

        if not FnFindOpenApprovalEntry(entryNo, docNo, PortalApproverID) then
            Error('Record to approve not found for approver %1.', PortalApproverID);

        DocTypeForComment := TbApprovalEntry."Document Type";
        RecordIdForComment := TbApprovalEntry."Record ID to Approve";
        SequenceNoForComment := TbApprovalEntry."Sequence No.";
        TableIdForComment := TbApprovalEntry."Table ID";

        if isApprove and (SequenceNoForComment = 1) and (leaveReliever <> '') then begin
            TbLeaveApp.Reset;
            TbLeaveApp.SetRange(TbLeaveApp."Application Code", docNo);
            TbLeaveApp.SetRange(Status, TbLeaveApp.Status::"Pending Approval");
            if TbLeaveApp.FindFirst() then begin
                TbLeaveApp.Reliever := leaveReliever;
                TbLeaveApp.Validate(Reliever);
                TbLeaveApp.Modify();
            end;
        end;

        FnApproveOrRejectOnBehalfOfPortalUser(TbApprovalEntry, PortalApproverID, isApprove);

        DocumentApprovalComments(docNo, comments, PortalApproverID, DocTypeForComment, RecordIdForComment, SequenceNoForComment, TableIdForComment);

        if not FnApprovalDecisionCompleted(entryNo, isApprove) then
            Error('Approval decision for %1 did not complete for approver %2.', docNo, PortalApproverID);

        return_value := true;
    end;

    local procedure FnFindOpenApprovalEntry(entryNo: Integer; docNo: Code[100]; portalApproverID: Code[50]): Boolean
    begin
        TbApprovalEntry.Reset;
        TbApprovalEntry.SetRange("Entry No.", entryNo);
        TbApprovalEntry.SetRange("Document No.", docNo);
        TbApprovalEntry.SetRange("Approver ID", portalApproverID);
        TbApprovalEntry.SetRange(Status, TbApprovalEntry.Status::Open);
        if TbApprovalEntry.FindFirst() then
            exit(true);

        // Permit only formatting/case differences in a portal alias. The entry number,
        // document number, and Open status still have to match exactly.
        TbApprovalEntry.Reset;
        TbApprovalEntry.SetRange("Entry No.", entryNo);
        TbApprovalEntry.SetRange("Document No.", docNo);
        TbApprovalEntry.SetRange(Status, TbApprovalEntry.Status::Open);
        if TbApprovalEntry.FindFirst() then
            if UpperCase(DelChr(TbApprovalEntry."Approver ID", '=', '._- ')) = UpperCase(DelChr(portalApproverID, '=', '._- ')) then
                exit(true);

        exit(false);
    end;

    local procedure FnApprovalDecisionCompleted(entryNo: Integer; isApprove: Boolean): Boolean
    begin
        TbApprovalEntry.Reset;
        if not TbApprovalEntry.Get(entryNo) then
            exit(false);

        if isApprove then
            exit(TbApprovalEntry.Status = TbApprovalEntry.Status::Approved);

        exit(TbApprovalEntry.Status = TbApprovalEntry.Status::Rejected);
    end;

    local procedure FnApproveOrRejectOnBehalfOfPortalUser(var ApprovalEntry: Record "Approval Entry"; PortalApproverID: Code[50]; isApprove: Boolean)
    var
        EntryNo: Integer;
        DocNo: Code[20];
        TableID: Integer;
        SeqNo: Integer;
    begin
        // Approvals Mgmt. authorizes the current BC session (ADMIN), not the portal user.
        // Complete the same workflow outcome while retaining the real approver in the audit.
        EntryNo := ApprovalEntry."Entry No.";
        DocNo := ApprovalEntry."Document No.";
        TableID := ApprovalEntry."Table ID";
        SeqNo := ApprovalEntry."Sequence No.";

        if isApprove then
            FnPortalCompleteApprove(EntryNo, DocNo, TableID, SeqNo, PortalApproverID)
        else
            FnPortalCompleteReject(EntryNo, PortalApproverID);
    end;

    local procedure FnPortalCompleteApprove(EntryNo: Integer; DocNo: Code[20]; TableID: Integer; SeqNo: Integer; PortalApproverID: Code[50])
    var
        AppEntry: Record "Approval Entry";
        StoreReq: Record "Store Requistion Header";
        PurchaseH: Record "Purchase Header";
        PaymentHeader: Record "Payments Header";
        ImprestH: Record "Imprest Header";
        ClaimH: Record "Staff Claims Header";
        ImpSurrender: Record "Imprest Surrender Header";
        LeaveApp: Record "HR Leave Application";
        StaffAdvanceHeader: Record "Staff Advance Header";
    begin
        AppEntry.Reset;
        AppEntry.SetRange("Document No.", DocNo);
        AppEntry.SetRange("Table ID", TableID);
        AppEntry.SetRange("Sequence No.", SeqNo);
        AppEntry.SetRange(Status, AppEntry.Status::Open);
        if AppEntry.FindSet() then
            repeat
                AppEntry.Status := AppEntry.Status::Approved;
                AppEntry."Approver ID" := PortalApproverID;
                AppEntry."Last Modified By User ID" := PortalApproverID;
                AppEntry.Modify();
            until AppEntry.Next() = 0
        else
            if AppEntry.Get(EntryNo) then begin
                AppEntry.Status := AppEntry.Status::Approved;
                AppEntry."Approver ID" := PortalApproverID;
                AppEntry."Last Modified By User ID" := PortalApproverID;
                AppEntry.Modify();
            end;

        AppEntry.Reset;
        AppEntry.SetRange("Document No.", DocNo);
        AppEntry.SetRange("Table ID", TableID);
        AppEntry.SetRange(Status, AppEntry.Status::Open);
        if AppEntry.FindFirst() then
            exit;

        // Sequential workflows store later steps as Created. Open only the next sequence.
        if FnActivateNextCreatedApprovalEntry(DocNo, TableID) then
            exit;

        if TableID = Database::"Store Requistion Header" then
            if StoreReq.Get(DocNo) then
                if StoreReq.Status = StoreReq.Status::"Pending Approval" then begin
                    StoreReq.Status := StoreReq.Status::Released;
                    StoreReq.Modify(false);
                    exit;
                end;

        if TableID = Database::"Purchase Header" then begin
            PurchaseH.Reset;
            PurchaseH.SetRange("No.", DocNo);
            if PurchaseH.FindFirst() then
                if PurchaseH.Status = PurchaseH.Status::"Pending Approval" then begin
                    PurchaseH.Status := PurchaseH.Status::Released;
                    PurchaseH.Modify();
                    exit;
                end;
        end;

        if TableID = Database::"Payments Header" then
            if PaymentHeader.Get(DocNo) then
                if PaymentHeader.Status = PaymentHeader.Status::"Pending Approval" then begin
                    PaymentHeader.Status := PaymentHeader.Status::Approved;
                    PaymentHeader.Modify();
                    exit;
                end;

        if TableID = Database::"Staff Claims Header" then
            if ClaimH.Get(DocNo) then
                if ClaimH.Status = ClaimH.Status::"Pending Approval" then begin
                    ClaimH.Status := ClaimH.Status::Approved;
                    ClaimH.Modify();
                    exit;
                end;

        if TableID = Database::"Imprest Header" then
            if ImprestH.Get(DocNo) then
                if ImprestH.Status = ImprestH.Status::"Pending Approval" then begin
                    ImprestH.Status := ImprestH.Status::Approved;
                    ImprestH.Modify();
                    exit;
                end;

        if TableID = Database::"Imprest Surrender Header" then
            if ImpSurrender.Get(DocNo) then
                if ImpSurrender.Status = ImpSurrender.Status::"Pending Approval" then begin
                    ImpSurrender.Status := ImpSurrender.Status::Approved;
                    ImpSurrender.Modify();
                    exit;
                end;

        if TableID = Database::"Staff Advance Header" then
            if StaffAdvanceHeader.Get(DocNo) then
                if StaffAdvanceHeader.Status = StaffAdvanceHeader.Status::"Pending Approval" then begin
                    StaffAdvanceHeader.Validate(Status, StaffAdvanceHeader.Status::Approved);
                    StaffAdvanceHeader.Modify(true);
                    exit;
                end;

        if TableID = Database::"HR Leave Application" then begin
            LeaveApp.Reset;
            LeaveApp.SetRange("Application Code", DocNo);
            if LeaveApp.FindFirst() then
                if LeaveApp.Status = LeaveApp.Status::"Pending Approval" then begin
                    LeaveApp.Validate(Status, LeaveApp.Status::Approved);
                    LeaveApp."Approval Status" := LeaveApp."Approval Status"::Approved;
                    LeaveApp.Modify(true);
                end;
        end;
    end;

    local procedure FnActivateNextCreatedApprovalEntry(DocNo: Code[20]; TableID: Integer): Boolean
    var
        AppEntry: Record "Approval Entry";
        NextSequenceNo: Integer;
    begin
        AppEntry.Reset;
        AppEntry.SetRange("Document No.", DocNo);
        AppEntry.SetRange("Table ID", TableID);
        AppEntry.SetRange(Status, AppEntry.Status::Created);
        if AppEntry.FindSet() then
            repeat
                if (NextSequenceNo = 0) or (AppEntry."Sequence No." < NextSequenceNo) then
                    NextSequenceNo := AppEntry."Sequence No.";
            until AppEntry.Next() = 0;

        if NextSequenceNo = 0 then
            exit(false);

        AppEntry.Reset;
        AppEntry.SetRange("Document No.", DocNo);
        AppEntry.SetRange("Table ID", TableID);
        AppEntry.SetRange("Sequence No.", NextSequenceNo);
        AppEntry.SetRange(Status, AppEntry.Status::Created);
        if AppEntry.FindSet() then
            repeat
                AppEntry.Status := AppEntry.Status::Open;
                AppEntry."Date-Time Sent for Approval" := CurrentDateTime;
                AppEntry.Modify(false);
            until AppEntry.Next() = 0;
        exit(true);
    end;

    local procedure FnPortalCompleteReject(EntryNo: Integer; PortalApproverID: Code[50])
    var
        AppEntry: Record "Approval Entry";
        PendingEntry: Record "Approval Entry";
        LeaveApp: Record "HR Leave Application";
        StaffAdvanceHeader: Record "Staff Advance Header";
        StoreReqHeader: Record "Store Requistion Header";
        PurchaseHeader: Record "Purchase Header";
        DocNo: Code[20];
        TableID: Integer;
    begin
        if AppEntry.Get(EntryNo) then begin
            DocNo := AppEntry."Document No.";
            TableID := AppEntry."Table ID";
            AppEntry.Status := AppEntry.Status::Rejected;
            AppEntry."Approver ID" := PortalApproverID;
            AppEntry."Last Modified By User ID" := PortalApproverID;
            AppEntry.Modify(false);

            PendingEntry.Reset;
            PendingEntry.SetRange("Document No.", DocNo);
            PendingEntry.SetRange("Table ID", TableID);
            PendingEntry.SetFilter(Status, '%1|%2', PendingEntry.Status::Open, PendingEntry.Status::Created);
            if PendingEntry.FindSet() then
                repeat
                    PendingEntry.Status := PendingEntry.Status::Canceled;
                    PendingEntry.Modify(false);
                until PendingEntry.Next() = 0;

            if TableID = Database::"HR Leave Application" then begin
                LeaveApp.Reset;
                LeaveApp.SetRange("Application Code", DocNo);
                if LeaveApp.FindFirst() then begin
                    LeaveApp.Validate(Status, LeaveApp.Status::Rejected);
                    LeaveApp.Modify(true);
                end;
            end;

            if TableID = Database::"Staff Advance Header" then
                if StaffAdvanceHeader.Get(DocNo) then begin
                    StaffAdvanceHeader.Validate(Status, StaffAdvanceHeader.Status::Cancelled);
                    StaffAdvanceHeader.Modify(true);
                end;

            if TableID = Database::"Store Requistion Header" then
                if StoreReqHeader.Get(DocNo) then begin
                    StoreReqHeader.Status := StoreReqHeader.Status::Cancelled;
                    StoreReqHeader.Modify(false);
                end;

            if TableID = Database::"Purchase Header" then begin
                PurchaseHeader.Reset();
                PurchaseHeader.SetRange("Document Type", PurchaseHeader."Document Type"::Quote);
                PurchaseHeader.SetRange("No.", DocNo);
                PurchaseHeader.SetRange(DocApprovalType, PurchaseHeader.DocApprovalType::Requisition);
                if PurchaseHeader.FindFirst() then
                    if PurchaseHeader.Status = PurchaseHeader.Status::"Pending Approval" then begin
                        PurchaseHeader.Validate(Status, PurchaseHeader.Status::Open);
                        PurchaseHeader.Modify(true);
                    end;
            end;
        end;
    end;

    local procedure FnStoreReqRequesterUserID(StoreReqNo: Code[100]; EmployeeNo: Code[100]) RequesterUserID: Code[50]
    var
        StoreReqHeader: Record "Store Requistion Header";
    begin
        if StoreReqHeader.Get(StoreReqNo) then begin
            RequesterUserID := StoreReqHeader."User ID";
            if (RequesterUserID <> '') and (RequesterUserID <> 'ADMIN') then
                exit(RequesterUserID);

            if EmployeeNo = '' then
                EmployeeNo := StoreReqHeader."Employee No";
        end;

        if EmployeeNo <> '' then begin
            TbUserSetup.Reset();
            TbUserSetup.SetRange("Employee No.", EmployeeNo);
            if TbUserSetup.FindFirst() then
                if (TbUserSetup."User ID" <> '') and (TbUserSetup."User ID" <> 'ADMIN') then
                    exit(TbUserSetup."User ID");

            TbEmployee.Reset();
            TbEmployee.SetRange("No.", EmployeeNo);
            if TbEmployee.FindFirst() then
                if (TbEmployee."User ID" <> '') and (TbEmployee."User ID" <> 'ADMIN') then
                    exit(TbEmployee."User ID");
        end;

        exit(RequesterUserID);
    end;

    procedure DocumentApprovalComments(docNo: Code[100]; comments: Text[250]; userID: Code[100]; docType: Integer; recordID: RecordID; sequenceNo: Integer; tableID: Integer) return_value: Boolean
    var
        NextEntryNo: Integer;
    begin
        return_value := false;
        TbApprovalCommentLine.Reset;
        if TbApprovalCommentLine.FindLast() then
            NextEntryNo := TbApprovalCommentLine."Entry No." + 1
        else
            NextEntryNo := 1;
        //
        TbApprovalCommentLine.Reset;
        TbApprovalCommentLine.Init;
        TbApprovalCommentLine."Entry No." := NextEntryNo;
        TbApprovalCommentLine."Table ID" := tableID;
        TbApprovalCommentLine."Document Type" := docType;
        TbApprovalCommentLine."Document No." := docNo;
        TbApprovalCommentLine."User ID" := userID;
        TbApprovalCommentLine.Comment := comments;
        TbApprovalCommentLine."Date and Time" := CurrentDatetime;
        //TbApprovalCommentLine."Seqeunce No.":=sequenceNo;
        TbApprovalCommentLine."Record ID to Approve" := recordID;
        TbApprovalCommentLine.Insert;
        return_value := true;
    end;

    procedure LeaveApplication(leaveNo: Code[100]; employeeNo: Code[100]; leaveType: Code[30]; reason: Text[250]; daysApplied: Decimal; startDate: DateTime; reliever: Code[30]; isRequestLeaveAllowance: Boolean; "action": Text; myUserID: Code[30]; endDate: DateTime; isHalfDayLeave: Boolean; returnDate: DateTime; familyMember: Text[30]; deliveryDate: DateTime) return_value: Code[30]
    begin
        return_value := '';
        TbHRLeaveRequisition.Reset;
        if action = 'create' then begin
            if TbHRLeaveRequisition.FindLast then
                NextNo := IncStr(TbHRLeaveRequisition."Application Code")
            else
                NextNo := 'LV-00001';
            TbHRLeaveRequisition.Init;
            TbHRLeaveRequisition."Application Code" := NextNo;
            TbHRLeaveRequisition."Application Date" := Today;
            TbHRLeaveRequisition."Employee No." := employeeNo;
            TbHRLeaveRequisition."User ID" := myUserID;
            // Insert before validating. "Days Applied" OnValidate calls Modify internally, which
            // fails with "The HR Leave Application does not exist" while the record is Init-only.
            TbHRLeaveRequisition.Insert(true);
            ApplyPortalLeaveFields(
              TbHRLeaveRequisition, employeeNo, leaveType, reason, daysApplied, startDate, endDate,
              returnDate, reliever, isRequestLeaveAllowance, isHalfDayLeave, myUserID, familyMember, deliveryDate);
            TbHRLeaveRequisition.Modify(true);
            return_value := TbHRLeaveRequisition."Application Code";
        end else begin
            TbHRLeaveRequisition.SetRange(TbHRLeaveRequisition."Application Code", leaveNo);
            TbHRLeaveRequisition.SetRange("Employee No.", employeeNo);
            TbHRLeaveRequisition.SetRange(Status, TbHRLeaveRequisition.Status::Open);
            if TbHRLeaveRequisition.FindFirst() then begin
                ApplyPortalLeaveFields(
                  TbHRLeaveRequisition, employeeNo, leaveType, reason, daysApplied, startDate, endDate,
                  returnDate, reliever, isRequestLeaveAllowance, isHalfDayLeave, myUserID, familyMember, deliveryDate);
                TbHRLeaveRequisition.Modify(true);
                return_value := TbHRLeaveRequisition."Application Code";
            end else
                Error('Leave application is not editable or was not found');
        end;
    end;

    procedure CancelLeaveApplication(employeeNo: Code[100]; requisitionNo: Code[100]) return_value: Boolean
    begin
        return_value := false;
        TbHRLeaveRequisition.Reset;
        TbHRLeaveRequisition.SetRange(TbHRLeaveRequisition."Application Code", requisitionNo);
        TbHRLeaveRequisition.SetRange("Employee No.", employeeNo);
        TbHRLeaveRequisition.SetRange(Status, TbHRLeaveRequisition.Status::"Pending Approval");
        if TbHRLeaveRequisition.FindFirst() then begin
            CancelPortalLeaveApproval(TbHRLeaveRequisition);
            CancelActiveLeaveApprovalEntries(TbHRLeaveRequisition);

            if TbHRLeaveRequisition.Status <> TbHRLeaveRequisition.Status::Open then
                TbHRLeaveRequisition.Validate(Status, TbHRLeaveRequisition.Status::Open);
            TbHRLeaveRequisition."Approval Status" := TbHRLeaveRequisition."Approval Status"::Open;
            TbHRLeaveRequisition.Modify(true);
            return_value := true;
        end else begin
            Error('Leave application cannot be cancelled or was not found');
        end;
    end;

    procedure DeleteLeaveApplication(employeeNo: Code[100]; requisitionNo: Code[100]) return_value: Boolean
    var
        PortalAttachment: Record "Document Attachment";
        ActiveApprovalEntry: Record "Approval Entry";
    begin
        return_value := false;
        TbHRLeaveRequisition.Reset();
        TbHRLeaveRequisition.SetRange("Application Code", requisitionNo);
        TbHRLeaveRequisition.SetRange("Employee No.", employeeNo);
        TbHRLeaveRequisition.SetRange(Status, TbHRLeaveRequisition.Status::Open);
        if not TbHRLeaveRequisition.FindFirst() then
            Error('Only an open leave draft can be deleted.');

        if FindActiveLeaveApprovalEntry(TbHRLeaveRequisition.RecordId, ActiveApprovalEntry) then
            Error('Cancel the pending leave approval before deleting this draft.');

        PortalAttachment.Reset();
        PortalAttachment.SetRange("Table ID", Database::"HR Leave Application");
        PortalAttachment.SetRange("No.", requisitionNo);
        if not PortalAttachment.IsEmpty then
            PortalAttachment.DeleteAll(true);

        TbHRLeaveRequisition.Delete(true);
        return_value := true;
    end;

    local procedure CancelActiveLeaveApprovalEntries(var LeaveApp: Record "HR Leave Application")
    var
        ApprovalEntry: Record "Approval Entry";
        WorkflowStepInstance: Record "Workflow Step Instance";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        WorkflowManagement: Codeunit "Workflow Management";
        RecordRestrictionMgt: Codeunit "Record Restriction Mgt.";
        LeaveRecRef: RecordRef;
        ActiveEntryNo: Integer;
        WorkflowInstanceId: Guid;
    begin
        LeaveRecRef.GetTable(LeaveApp);

        // A cancellation workflow can be enabled without a matching cancellation
        // response. Always reconcile the actual approval rows before reopening the
        // document. Standard approval management preserves the entries as Canceled
        // and creates the normal cancellation notifications.
        while FindActiveLeaveApprovalEntry(LeaveApp.RecordId, ApprovalEntry) do begin
            ActiveEntryNo := ApprovalEntry."Entry No.";
            WorkflowInstanceId := ApprovalEntry."Workflow Step Instance ID";

            if not IsNullGuid(WorkflowInstanceId) then begin
                WorkflowStepInstance.Reset();
                WorkflowStepInstance.SetRange(ID, WorkflowInstanceId);
                if WorkflowStepInstance.FindFirst() then begin
                    ApprovalsMgmt.CancelApprovalRequestsForRecord(LeaveRecRef, WorkflowStepInstance);
                    WorkflowManagement.ArchiveWorkflowInstance(WorkflowStepInstance);
                end;
            end;

            // Legacy ABH approvals can have no live workflow step instance. Keep
            // the approval row for audit, but close it so the document is no longer
            // restricted. This also guards against an incomplete configured response.
            if ApprovalEntry.Get(ActiveEntryNo) and
               (ApprovalEntry.Status in [ApprovalEntry.Status::Open, ApprovalEntry.Status::Created])
            then begin
                ApprovalEntry.Validate(Status, ApprovalEntry.Status::Canceled);
                ApprovalEntry.Modify(true);
            end;
        end;

        // Workflow-step deletion normally removes the record restriction. The
        // explicit allow is required for legacy approval entries whose workflow
        // step instance was already orphaned before this cancellation.
        RecordRestrictionMgt.AllowRecordUsage(LeaveApp);
    end;

    local procedure FindActiveLeaveApprovalEntry(LeaveRecordId: RecordId; var ApprovalEntry: Record "Approval Entry"): Boolean
    begin
        ApprovalEntry.Reset();
        ApprovalEntry.SetRange("Table ID", Database::"HR Leave Application");
        ApprovalEntry.SetRange("Record ID to Approve", LeaveRecordId);
        ApprovalEntry.SetFilter(Status, '%1|%2', ApprovalEntry.Status::Open, ApprovalEntry.Status::Created);
        exit(ApprovalEntry.FindFirst());
    end;

    local procedure FindOpenLeaveApplication(requisitionNo: Code[100]; employeeNo: Code[100]; var LeaveApp: Record "HR Leave Application"): Boolean
    begin
        LeaveApp.Reset;
        LeaveApp.SetRange("Application Code", requisitionNo);
        LeaveApp.SetRange(Status, LeaveApp.Status::Open);
        if employeeNo <> '' then begin
            LeaveApp.SetRange("Employee No.", employeeNo);
            if LeaveApp.FindFirst() then
                exit(true);
            LeaveApp.SetRange("Employee No.");
        end;
        exit(LeaveApp.FindFirst());
    end;

    local procedure SendPortalLeaveApproval(var LeaveApp: Record "HR Leave Application")
    var
        WorkflowManagement: Codeunit "Workflow Management";
        LeaveVariant: Variant;
        LeaveCuEvent: Code[128];
        HrLeaveEvent: Code[128];
    begin
        LeaveVariant := LeaveApp;
        LeaveCuEvent := CopyStr('RUNWORKFLOWONSEND_LEAVE_APPLICATION_FORAPPROVAL', 1, MaxStrLen(LeaveCuEvent));
        HrLeaveEvent := CopyStr('RUNWORKFLOWONSENDHRLEAVEFORAPPROVAL', 1, MaxStrLen(HrLeaveEvent));
        // BC Leave card uses Custom Approvals Codeunit (HRLEAVE). Portal used to
        // fire only Custom Approvals CU (LEAVE_APPLICATION). Send on whichever
        // workflow is actually enabled.
        if WorkflowManagement.CanExecuteWorkflow(LeaveVariant, LeaveCuEvent) then begin
            CuLeaveApprovals.RunWorkflowOnSendApprovalRequest(LeaveVariant);
            exit;
        end;
        if WorkflowManagement.CanExecuteWorkflow(LeaveVariant, HrLeaveEvent) then begin
            CuCustomApprovals.RunWorkflowOnSendApprovalRequest(LeaveVariant);
            exit;
        end;
        Error(
            'Leave application %1 has no enabled approval workflow. Enable a Leave Application workflow whose first event is either "Approval of a LEAVE_APPLICATION is requested" or "An Approval Request for Leave application has been Requested", then assign an approver in Approval User Setup.',
            LeaveApp."Application Code");
    end;

    local procedure CancelPortalLeaveApproval(var LeaveApp: Record "HR Leave Application")
    var
        WorkflowManagement: Codeunit "Workflow Management";
        LeaveVariant: Variant;
        LeaveCuEvent: Code[128];
        HrLeaveEvent: Code[128];
    begin
        LeaveVariant := LeaveApp;
        LeaveCuEvent := CopyStr('RUNWORKFLOWONCANCEL_LEAVE_APPLICATION_FORAPPROVAL', 1, MaxStrLen(LeaveCuEvent));
        HrLeaveEvent := CopyStr('RUNWORKFLOWONCANCELHRLEAVEFORAPPROVAL', 1, MaxStrLen(HrLeaveEvent));
        if WorkflowManagement.CanExecuteWorkflow(LeaveVariant, LeaveCuEvent) then begin
            CuLeaveApprovals.OnCancelDocApprovalRequest(LeaveVariant);
            exit;
        end;
        if WorkflowManagement.CanExecuteWorkflow(LeaveVariant, HrLeaveEvent) then begin
            CuCustomApprovals.OnCancelDocApprovalRequest(LeaveVariant);
            exit;
        end;
        CuLeaveApprovals.OnCancelDocApprovalRequest(LeaveVariant);
        CuCustomApprovals.OnCancelDocApprovalRequest(LeaveVariant);
    end;

    procedure RequestLeaveApproval(employeeNo: Code[100]; requisitionNo: Code[100]; tableID: Integer) return_value: Boolean
    var
        LeaveAfterApproval: Record "HR Leave Application";
        LeaveRecRef: RecordRef;
        RecordIdToApprove: RecordId;
        HasApprovalEntry: Boolean;
    begin
        return_value := false;
        if not FindOpenLeaveApplication(requisitionNo, employeeNo, TbHRLeaveRequisition) then
            Error('Leave application %1 cannot be sent for approval or was not found (must still be Open).', requisitionNo);

        TbHRLeaveRequisition.TestField("Days Applied");
        TbHRLeaveRequisition.TestField("Reason for leave");
        if TbHRLeaveRequisition."Return Date" = 0D then
            Error('Return Date must be populated before sending leave for approval.');

        if (TbHRLeaveRequisition."Earned Leave Days" > 0) and
           (TbHRLeaveRequisition."Days Applied" > TbHRLeaveRequisition."Earned Leave Days") then
            Error('Days applied cannot exceed earned leave days');

        if LeaveRequiresMedicalAttachment(TbHRLeaveRequisition) and
           not HasPortalDocumentAttachment(Database::"HR Leave Application", requisitionNo)
        then
            Error('A supporting attachment is required before requesting approval for sick leave.');

        SendPortalLeaveApproval(TbHRLeaveRequisition);
        Commit;

        if not LeaveAfterApproval.Get(requisitionNo) then
            Error('Leave application %1 was not found after requesting approval.', requisitionNo);

        LeaveRecRef.GetTable(LeaveAfterApproval);
        RecordIdToApprove := LeaveRecRef.RecordId;
        if LeaveAfterApproval."User ID" <> '' then begin
            FnUpdateApprovalEntries(requisitionNo, LeaveAfterApproval."User ID", RecordIdToApprove);
            Commit();
        end;

        TbApprovalEntry.Reset;
        TbApprovalEntry.SetRange("Record ID to Approve", RecordIdToApprove);
        TbApprovalEntry.SetRange("Table ID", Database::"HR Leave Application");
        TbApprovalEntry.SetFilter(Status, '%1|%2', TbApprovalEntry.Status::Open, TbApprovalEntry.Status::Created);
        HasApprovalEntry := not TbApprovalEntry.IsEmpty;
        if not HasApprovalEntry then begin
            TbApprovalEntry.Reset;
            TbApprovalEntry.SetRange("Document No.", requisitionNo);
            TbApprovalEntry.SetRange("Table ID", Database::"HR Leave Application");
            TbApprovalEntry.SetFilter(Status, '%1|%2', TbApprovalEntry.Status::Open, TbApprovalEntry.Status::Created);
            HasApprovalEntry := not TbApprovalEntry.IsEmpty;
        end;

        if (LeaveAfterApproval.Status <> LeaveAfterApproval.Status::"Pending Approval") and HasApprovalEntry then begin
            LeaveAfterApproval.Validate(Status, LeaveAfterApproval.Status::"Pending Approval");
            LeaveAfterApproval.Modify(false);
            Commit();
        end;

        if LeaveAfterApproval.Get(requisitionNo) then
            return_value := (LeaveAfterApproval.Status = LeaveAfterApproval.Status::"Pending Approval") or HasApprovalEntry;

        if not return_value then
            Error(
                'Business Central did not create approval entries for leave application %1. Enable the Leave workflow and confirm Approval User Setup has an approver for the requester.',
                requisitionNo);
    end;

    local procedure HasPortalDocumentAttachment(TableId: Integer; DocumentNo: Code[100]): Boolean
    var
        PortalAttachment: Record "Document Attachment";
    begin
        PortalAttachment.Reset();
        PortalAttachment.SetRange("Table ID", TableId);
        PortalAttachment.SetRange("No.", DocumentNo);
        exit(PortalAttachment.FindFirst());
    end;

    local procedure HasPortalAttachmentDescription(TableId: Integer; DocumentNo: Code[100]; SearchText: Text): Boolean
    var
        PortalAttachment: Record "Document Attachment";
    begin
        PortalAttachment.Reset();
        PortalAttachment.SetRange("Table ID", TableId);
        PortalAttachment.SetRange("No.", DocumentNo);
        if PortalAttachment.FindSet() then
            repeat
                if (StrPos(UpperCase(PortalAttachment."Document Description"), UpperCase(SearchText)) > 0) or
                (StrPos(UpperCase(PortalAttachment."File Name"), UpperCase(SearchText)) > 0) then
                    exit(true);
            until PortalAttachment.Next() = 0;
        exit(false);
    end;

    local procedure LeaveRequiresMedicalAttachment(LeaveApplication: Record "HR Leave Application"): Boolean
    var
        LeaveType: Record "Leave Types";
        SearchText: Text;
    begin
        SearchText := UpperCase(LeaveApplication."Leave Type");
        if LeaveType.Get(LeaveApplication."Leave Type") then
            SearchText += ' ' + UpperCase(LeaveType.Code) + ' ' + UpperCase(LeaveType.Description);
        exit(
            (StrPos(SearchText, 'SICK') > 0) or
            (StrPos(SearchText, 'MEDICAL') > 0) or
            (StrPos(SearchText, 'ILLNESS') > 0) or
            (StrPos(SearchText, 'HOSPITAL') > 0));
    end;

    procedure GeneratePayslip(employeeNo: Code[100]; year: Integer; month: Integer; filenameFromApp: Text[200]) return_value: Text
    var
        Period: Date;
        MyRecordRef: RecordRef;
        MyOutstream: OutStream;
        TbTempBlob: Codeunit "Temp Blob";
        FileName2: Text;
        Convert: dotnet Convert;
        IOFile: dotnet File;
        base64txt: Text;
        PeriodDate: Date;
    begin
        return_value := '';
        TbGeneralSetup.Get;
        TbGeneralSetup.TestField("Portal Reports File Path");
        FILESPATH := TbGeneralSetup."Portal Reports File Path";
        filename := FILESPATH + filenameFromApp;
        FileName2 := FILESPATH + '-Encr-' + filenameFromApp;
        // 'C:\Users\erp\Documents\PortalReports\E0083_ps.pdf
        if Exists(filename) then
            Erase(filename);

        PeriodDate := Dmy2date(1, month, year);

        PRSalaryCard.Reset;
        PRSalaryCard.SetFilter("Employee Code", '=%1', employeeNo);
        PRSalaryCard.SetFilter("Portal Period Filter", '=%1', PeriodDate);
        if PRSalaryCard.FindFirst() then begin
            IndividualPayslip.SetTableview(PRSalaryCard);
            IndividualPayslip.SaveAsPdf(filename);

            // MyRecordRef.GetTable(PRSalaryCard);
            // TbTempBlob.CreateOutstream(MyOutstream);
            // IndividualPayslip.SaveAs(filename, Reportformat::Pdf, MyOutstream, MyRecordRef);

            return_value := Convert.ToBase64String(IOFile.ReadAllBytes(filename));

            if Exists(filename) then
                Erase(filename);
        end else begin
            Error('No data found in Employee D');
        end;
    end;

    procedure GeneratePNine(employeeNo: Code[100]; year: Integer; filenameFromApp: Text[200]) return_value: Text
    var
        MyRecordRef: RecordRef;
        MyOutstream: OutStream;
        TbTempBlob: Codeunit "Temp Blob";
        FileName2: Text;
        Convert: dotnet Convert;
        IOFile: dotnet File;
        base64txt: Text;
    begin
        return_value := '';
        TbGeneralSetup.Get;
        FILESPATH := TbGeneralSetup."Portal Reports File Path";
        filename := FILESPATH + filenameFromApp;
        FileName2 := FILESPATH + '-Encr-' + filenameFromApp;
        if Exists(filename) then
            Erase(filename);
        // RpPnine.FnInitiateYear(year);
        TbEmployee.Reset;
        TbEmployee.SetFilter(TbEmployee."No.", '=%1', employeeNo);
        TbEmployee.SetFilter(TbEmployee."Period Year Filter", '=%1', year);
        if TbEmployee.FindFirst() then begin
            RpPnine.SetTableview(TbEmployee);
        end else begin
            Error('No data found in Employee');
        end;
        TbEmp99Info.Reset;
        TbEmp99Info.SetFilter("Employee Code", '=%1', employeeNo);
        TbEmp99Info.SetFilter("Payroll Period", '%1..%2', Dmy2date(1, 1, year), Dmy2date(31, 12, year));
        if TbEmp99Info.FindSet then begin
            RpPnine.SetTableview(TbEmp99Info);
        end;

        MyRecordRef.GetTable(TbEmployee);
        TbTempBlob.CreateOutstream(MyOutstream);
        RpPnine.SaveAs(filename, Reportformat::Pdf, MyOutstream, MyRecordRef);
        return_value := Convert.ToBase64String(IOFile.ReadAllBytes(filename));
        /*PDFEncriptor:= PDFEncriptorCode.PDFProtect();
        RpPnine.SAVEASPDF(filename);
        IF(PDFEncriptor.PdfProtect(filename,FileName2,TbEmployee."ID Number")='Success') THEN BEGIN
          base64txt := Convert.ToBase64String(IOFile.ReadAllBytes(FileName2));
          return_value := base64txt;
        END;
        */
        if Exists(filename) then
            Erase(filename);
        if Exists(FileName2) then
            Erase(FileName2);
        /*RpPnine.FnInitiateDates(startDate,endDate);
        MyRecordRef.GETTABLE(TbEmployee);
      TbTempBlob.Blob.CREATEOUTSTREAM(MyOutstream);
      RpPnine.SAVEAS(filename, REPORTFORMAT::Pdf, MyOutstream, MyRecordRef);
      return_value := TbTempBlob.ToBase64String();
        IF EXISTS(filename) THEN
          ERASE(filename);*/

    end;

    local procedure ResolvePortalImprestHolder(ImprestHeader: Record "Imprest Header"; EmployeeNo: Code[20]): Code[20]
    var
        PortalCustomer: Record Customer;
    begin
        // Prefer employee Customer No so portal users work when User Setup Imprest Account is blank.
        if EmployeeNo <> '' then
            if TbEmployee.Get(EmployeeNo) then
                if TbEmployee."Customer No" <> '' then
                    exit(TbEmployee."Customer No");

        // Migration-safe fallback: ABH can already have the staff IMPREST
        // customer linked by Customer."Staff No." without backfilling the
        // employee/user-setup account fields.
        if EmployeeNo <> '' then begin
            PortalCustomer.Reset();
            PortalCustomer.SetRange("Staff No.", EmployeeNo);
            if PortalCustomer.FindFirst() then
                exit(PortalCustomer."No.");
        end;

        exit(ImprestHeader."Account No.");
    end;

    local procedure SetPortalImprestAccount(var ImprestHeader: Record "Imprest Header"; EmployeeNo: Code[20])
    var
        ImprestHolder: Code[20];
    begin
        ImprestHolder := ResolvePortalImprestHolder(ImprestHeader, EmployeeNo);
        if ImprestHolder = '' then
            Error(
                'No imprest/customer account is configured for employee %1. Update the employee card (Customer No) or User Setup Imprest Account before creating an imprest.',
                EmployeeNo);

        if (ImprestHeader."Account Type" = ImprestHeader."Account Type"::Customer) and
           (ImprestHeader."Account No." = ImprestHolder) then
            exit;

        ImprestHeader."Account Type" := ImprestHeader."Account Type"::Customer;
        ImprestHeader.Validate("Account No.", ImprestHolder);
    end;

    procedure ImprestRequisitionHeader(myUserId: Code[100]; "action": Text; DocNo: Code[50]; purpose: Text; travelDestination: Text[250]; travelDate: Date; returnDate: Date; EmployeeNo: Code[20]; dateRequired: Date) return_value: Code[50]
    begin
        return_value := '';
        TbImprestRequisitionHeader.Reset;
        if action = 'create' then begin
            TbCashOfficeSetup.Get;
            TbCashOfficeSetup.TestField("Imprest Req No");
            NextNo := CuNoSeriesMgt.GetNextNo(TbCashOfficeSetup."Imprest Req No", 0D, true);
            //
            TbImprestRequisitionHeader.Init;
            TbImprestRequisitionHeader."No." := NextNo;
            TbImprestRequisitionHeader.Date := Today;
            TbImprestRequisitionHeader."Requested By" := myUserId;
            TbImprestRequisitionHeader.Cashier := myUserId;
            TbImprestRequisitionHeader.Purpose := purpose;
            TbImprestRequisitionHeader."Employee No." := EmployeeNo;
            if TbEmployee.Get(EmployeeNo) then begin
                TbImprestRequisitionHeader."Global Dimension 1 Code" := TbEmployee."Global Dimension 1 Code";
                TbImprestRequisitionHeader."Shortcut Dimension 2 Code" := TbEmployee."Global Dimension 2 Code";
            end;
            TbImprestRequisitionHeader."Expected Return Date" := returnDate;
            if dateRequired <> 0D then
                TbImprestRequisitionHeader."Date Required" := dateRequired;
            if travelDate <> 0D then
                TbImprestRequisitionHeader.Date := travelDate;

            TbImprestRequisitionHeader.Insert(true);
            // OnInsert may stamp a blank/service account; force the portal employee's customer.
            SetPortalImprestAccount(TbImprestRequisitionHeader, EmployeeNo);
            TbImprestRequisitionHeader.Modify(true);
            return_value := NextNo;
        end else begin
            TbImprestRequisitionHeader.SetRange("No.", DocNo);
            TbImprestRequisitionHeader.SetRange(Status, TbImprestRequisitionHeader.Status::Pending);
            if TbImprestRequisitionHeader.FindFirst() then begin
                TbImprestRequisitionHeader.Purpose := purpose;
                TbImprestRequisitionHeader."Employee No." := EmployeeNo;
                TbImprestRequisitionHeader."Expected Return Date" := returnDate;
                if dateRequired <> 0D then
                    TbImprestRequisitionHeader."Date Required" := dateRequired;
                if travelDate <> 0D then
                    TbImprestRequisitionHeader.Date := travelDate;
                TbImprestRequisitionHeader.Cashier := myUserId;
                SetPortalImprestAccount(TbImprestRequisitionHeader, EmployeeNo);
                TbImprestRequisitionHeader.Modify();
                return_value := DocNo;
            end else begin
                Error('Requisition is no longer editable or it does not exist.');
            end;
        end;
    end;

    procedure FetchImprestLineAmount(headerNo: Code[20]; noOfDays: Integer; advanceType: Code[20]; destinationCode: Code[20]) returnValue: Decimal
    var
        ImprestHdr: Record "Imprest Header";
    begin
        // UAT 25/07/2026: the portal "requested amount" never picked up the ERP daily rate.
        // Cause: this validated Destination, whose OnValidate no longer calculates anything
        // (CalculateTravelRates is commented out), and the Imprest Holder was never set — so
        // CalculateTravelAmounts() never ran and Amount stayed 0.
        // Fix: set the Imprest Holder from the header (needed to resolve the employee Job Group
        // -> Job Grade Advance Rates), then Validate "No of Days", which runs
        // CalculateTravelAmounts() and stamps "Daily Rate(Amount)" + Amount from the ERP setup.
        TbImprestRequisitionLines.Init();
        TbImprestRequisitionLines.No := headerNo;
        TbImprestRequisitionLines."Advance Type" := advanceType;
        TbImprestRequisitionLines."Destination Code" := destinationCode;

        if ImprestHdr.Get(headerNo) then
            TbImprestRequisitionLines."Imprest Holder" :=
                ResolvePortalImprestHolder(ImprestHdr, ImprestHdr."Employee No.");

        TbImprestRequisitionLines.Validate("No of Days", noOfDays);

        returnValue := TbImprestRequisitionLines.Amount;
    end;

    procedure ImprestRequisitionLine("action": Text; lineNo: Integer; docNo: Code[50]; advanceType: Code[30]; amount: Decimal; destination: Code[30]; noOfDays: Decimal; dutyArea: Text; employeeNo: Code[30]; dailyRate: Decimal) return_value: Boolean
    begin
        return_value := false;
        //
        TbImprestRequisitionHeader.SetRange("No.", docNo);
        if TbImprestRequisitionHeader.FindFirst() then;
        //
        TbImprestRequisitionLines.Reset;
        if action = 'create' then begin
            TbImprestRequisitionLines.Reset;
            if TbImprestRequisitionLines.FindLast then
                lineNo := TbImprestRequisitionLines."Line No." + 1
            else
                lineNo := 1;
            //
            TbImprestRequisitionLines.Init;
            TbImprestRequisitionLines.No := docNo;
            TbImprestRequisitionLines."Line No." := lineNo;    //
            TbImprestRequisitionLines."Advance Type" := advanceType;    //
            TbImprestRequisitionLines.Validate("Advance Type");
            TbImprestRequisitionLines."Imprest Holder" :=
                ResolvePortalImprestHolder(TbImprestRequisitionHeader, employeeNo);
            TbImprestRequisitionLines."Destination Code" := destination;
            if dutyArea <> '' then TbImprestRequisitionLines.Purpose := CopyStr(dutyArea, 1, MaxStrLen(TbImprestRequisitionLines.Purpose));
            // UAT 29/07/2026: Manual rate-source advance types (e.g. PETTY CASH) have no
            // per-diem rate in the ERP master, so the "No of Days" validation errors with
            // "Please enter Daily Rate...". Stamp the requester/ERP daily rate first so the
            // validation passes; Job Grade rate-source types overwrite it with the setup rate.
            if dailyRate > 0 then
                TbImprestRequisitionLines."Daily Rate(Amount)" := dailyRate;
            // UAT 28/07/2026: Validate days so BC stamps Daily Rate + Amount from ERP setup.
            TbImprestRequisitionLines.Validate("No of Days", noOfDays);
            if amount > 0 then
                TbImprestRequisitionLines.Amount := amount;
            TbImprestRequisitionLines.Insert(true);
            return_value := true;
        end else begin
            TbImprestRequisitionLines.SetRange(No, docNo);
            TbImprestRequisitionLines.SetRange("Line No.", lineNo);
            if TbImprestRequisitionLines.FindFirst() then begin
                TbImprestRequisitionLines."Advance Type" := advanceType;    //
                TbImprestRequisitionLines.Validate("Advance Type");
                if dutyArea <> '' then TbImprestRequisitionLines.Purpose := CopyStr(dutyArea, 1, MaxStrLen(TbImprestRequisitionLines.Purpose));
                TbImprestRequisitionLines."Imprest Holder" :=
                    ResolvePortalImprestHolder(TbImprestRequisitionHeader, employeeNo);
                TbImprestRequisitionLines."Destination Code" := destination;
                if dailyRate > 0 then
                    TbImprestRequisitionLines."Daily Rate(Amount)" := dailyRate;
                TbImprestRequisitionLines.Validate("No of Days", noOfDays);
                if amount > 0 then
                    TbImprestRequisitionLines.Amount := amount;
                TbImprestRequisitionLines.Modify;
                return_value := true;
            end else begin
                Error('Requisition line is no longer editable or it does not exist.');
            end;
        end;
    end;

    procedure DeleteImprestLine(lineNo: Integer; requisitionNo: Code[100]) return_value: Boolean
    begin
        return_value := false;
        TbImprestRequisitionLines.Reset;
        TbImprestRequisitionLines.SetRange(No, requisitionNo);
        TbImprestRequisitionLines.SetRange("Line No.", lineNo);
        if TbImprestRequisitionLines.FindFirst() then begin
            TbImprestRequisitionLines.Delete;
            return_value := true;
        end else begin
            Error('Requisition line cannot be deleted or was not found');
        end;
    end;

    procedure CancelImprestRequisition(employeeNo: Code[100]; requisitionNo: Code[100]; tableID: Integer) return_value: Boolean
    var
        blnparam: Boolean;
    begin
        return_value := false;
        TbImprestRequisitionHeader.Reset;
        TbImprestRequisitionHeader.SetRange("No.", requisitionNo);
        TbImprestRequisitionHeader.SetRange("Employee No.", employeeNo);
        if TbImprestRequisitionHeader.FindFirst() then begin
            VarVariant := TbImprestRequisitionHeader;
            CuCustomApprovals.OnCancelDocApprovalRequest(VarVariant);
            return_value := true;
        end else begin
            Error('Requisition cannot be cancelled or was not found');
        end;
    end;

    procedure RequestImprestApproval(employeeNo: Code[100]; reqNo: Code[50]; tableID: Integer) return_value: Boolean
    var
        ImprestAfterApproval: Record "Imprest Header";
        ImprestRecRef: RecordRef;
        RecordIdToApprove: RecordId;
        HasApprovalEntry: Boolean;
    begin
        return_value := false;
        if not IsImprestLinesExists(reqNo) then
            Error('You must add imprest lines before Sending an imprest for approval.');
        TbImprestRequisitionHeader.Reset;
        TbImprestRequisitionHeader.SetRange("No.", reqNo);
        TbImprestRequisitionHeader.SetRange("Employee No.", employeeNo);
        if TbImprestRequisitionHeader.FindFirst() then begin
            //First Check whether other lines are already committed.
            TbCommitments.Reset;
            TbCommitments.SetRange(TbCommitments."Document Type", TbCommitments."document type"::Imprest);
            TbCommitments.SetRange(TbCommitments."Document No.", reqNo);
            TbCommitments.DeleteAll;

            VarVariant := TbImprestRequisitionHeader;
            if not CuCustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) then
                Error('Business Central approval workflow is not configured for imprest %1.', reqNo);

            CuCustomApprovals.OnSendDocForApproval(VarVariant);
            Commit();

            if not ImprestAfterApproval.Get(reqNo) then
                Error('Imprest %1 was not found after requesting approval.', reqNo);

            ImprestRecRef.GetTable(ImprestAfterApproval);
            RecordIdToApprove := ImprestRecRef.RecordId;
            if ImprestAfterApproval.Cashier <> '' then begin
                FnUpdateApprovalEntries(reqNo, ImprestAfterApproval.Cashier, RecordIdToApprove);
                Commit();
            end;

            TbApprovalEntry.Reset;
            TbApprovalEntry.SetRange("Record ID to Approve", RecordIdToApprove);
            TbApprovalEntry.SetRange("Table ID", Database::"Imprest Header");
            TbApprovalEntry.SetFilter(Status, '%1|%2', TbApprovalEntry.Status::Open, TbApprovalEntry.Status::Created);
            HasApprovalEntry := not TbApprovalEntry.IsEmpty;

            if (ImprestAfterApproval.Status <> ImprestAfterApproval.Status::"Pending Approval") and HasApprovalEntry then begin
                ImprestAfterApproval.Validate(Status, ImprestAfterApproval.Status::"Pending Approval");
                ImprestAfterApproval.Modify(false);
                Commit();
            end;

            if ImprestAfterApproval.Get(reqNo) then
                return_value := (ImprestAfterApproval.Status = ImprestAfterApproval.Status::"Pending Approval") and HasApprovalEntry;

            if not return_value then
                Error(
                    'Business Central did not create approval entries for imprest %1. Enable the Imprest workflow and confirm Approval User Setup has an approver for %2.',
                    reqNo, ImprestAfterApproval.Cashier);

        end else begin
            Error('Requisition is no longer editable or it does not exist.');
        end;
    end;

    procedure IsImprestLinesExists(reqNo: Code[100]) hasLines: Boolean
    begin
        hasLines := false;
        TbImprestRequisitionLines.Reset;
        TbImprestRequisitionLines.SetRange(TbImprestRequisitionLines.No, reqNo);
        if TbImprestRequisitionLines.FindFirst() then begin
            hasLines := true;
        end;
    end;

    procedure ImprestSurrenderHeader(myUserID: Code[30]; employeeNo: Code[30]; imprestNo: Code[30]; myAction: Text[100]; docNo: Code[30]; imprestIssueDocNo: Code[30]; receivedFrom: Code[50]; PVNo: Code[30]) return_value: Code[50]
    begin
        return_value := '';
        if myAction = 'create' then begin
            TbCashOfficeSetup.Get;
            TbCashOfficeSetup.TestField("Imprest Surrender No");
            NextNo := CuNoSeriesMgt.GetNextNo(TbCashOfficeSetup."Imprest Surrender No", 0D, true);
            if imprestIssueDocNo = '' then
                Error('Select the imprest to surrender.');
            if not TbImprestRequisitionHeader.Get(imprestIssueDocNo) then
                Error('Imprest %1 was not found.', imprestIssueDocNo);
            TbImprestSurrenderHeader.No := NextNo;
            TbImprestSurrenderHeader."Surrender Date" := Today;
            TbImprestSurrenderHeader."User ID" := myUserID;
            if employeeNo <> '' then
                TbImprestSurrenderHeader.Validate("Employee No", employeeNo);
            TbImprestSurrenderHeader."Imprest Surrender Type" := TbImprestRequisitionHeader."imprest TYpe";
            if TbImprestRequisitionHeader."Account No." <> '' then
                TbImprestSurrenderHeader."Account No." := TbImprestRequisitionHeader."Account No."
            else
                TbImprestSurrenderHeader."Account No." := imprestNo;
            TbImprestSurrenderHeader."Imprest Issue Doc. No" := imprestIssueDocNo;
            TbImprestSurrenderHeader."Received From" := receivedFrom;
            TbImprestSurrenderHeader."PV No" := PVNo;
            //TbImprestSurrenderHeader."Financial Period":=financialPeriod;
            if TbImprestSurrenderHeader.Insert(true) then begin
                Commit;
                TbImprestSurrenderHeader.Reset;
                TbImprestSurrenderHeader.SetRange(No, NextNo);
                if TbImprestSurrenderHeader.FindFirst then begin
                    TbImprestSurrenderHeader.Validate("Imprest Issue Doc. No");
                    TbImprestSurrenderHeader.Validate("PV No");
                    TbImprestSurrenderHeader.Modify;
                end;
            end;
            return_value := NextNo;
        end else begin
            TbImprestSurrenderHeader.Reset;
            TbImprestSurrenderHeader.SetRange(No, docNo);
            if TbImprestSurrenderHeader.FindFirst then begin
                if employeeNo <> '' then
                    TbImprestSurrenderHeader.Validate("Employee No", employeeNo);
                if imprestIssueDocNo <> '' then
                    if TbImprestRequisitionHeader.Get(imprestIssueDocNo) then begin
                        TbImprestSurrenderHeader."Imprest Surrender Type" := TbImprestRequisitionHeader."imprest TYpe";
                        if TbImprestRequisitionHeader."Account No." <> '' then
                            TbImprestSurrenderHeader."Account No." := TbImprestRequisitionHeader."Account No."
                        else
                            if imprestNo <> '' then
                                TbImprestSurrenderHeader."Account No." := imprestNo;
                        TbImprestSurrenderHeader."Imprest Issue Doc. No" := imprestIssueDocNo;
                    end;
                TbImprestSurrenderHeader.Validate("Imprest Issue Doc. No");
                TbImprestSurrenderHeader."Received From" := receivedFrom;
                TbImprestSurrenderHeader."PV No" := PVNo;
                TbImprestSurrenderHeader.Validate("PV No");
                //TbImprestSurrenderHeader."Financial Period":=financialPeriod;
                TbImprestSurrenderHeader.Validate("Financial Period");
                TbImprestSurrenderHeader.Modify(true);
                return_value := docNo;
            end;
        end;
    end;

    procedure ImprestSurrenderLine(docNo: Code[50]; lineNo: Integer; actualSpent: Decimal; cashReceiptNo: Code[30]; cashReceiptAmount: Decimal; accountNo: Code[30]) return_value: Boolean
    begin
        return_value := false;
        TbImprestSurrenderLines.Reset;
        TbImprestSurrenderLines.SetRange("Surrender Doc No.", docNo);
        if accountNo <> '' then begin
            TbImprestSurrenderLines.SetRange("Account No:", accountNo);
            if not TbImprestSurrenderLines.FindFirst() then begin
                TbImprestSurrenderLines.SetRange("Account No:");
                TbImprestSurrenderLines.SetRange(TbImprestSurrenderLines."Entry No", lineNo);
                if not TbImprestSurrenderLines.FindFirst() then
                    Error('Imprest surrender line is no longer editable or it does not exist.');
            end;
        end else begin
            TbImprestSurrenderLines.SetRange(TbImprestSurrenderLines."Entry No", lineNo);
            if not TbImprestSurrenderLines.FindFirst() then
                Error('Imprest surrender line is no longer editable or it does not exist.');
        end;
        TbImprestSurrenderLines."Actual Spent" := actualSpent;
        TbImprestSurrenderLines."Cash Receipt No" := cashReceiptNo;
        TbImprestSurrenderLines."Cash Receipt Amount" := cashReceiptAmount;
        TbImprestSurrenderLines.Validate("Actual Spent");
        TbImprestSurrenderLines.Modify;
        return_value := true;
    end;

    procedure DeletImprestSurrenderLine(accountNo: Code[50]; requisitionNo: Code[100]; LineNo: Integer) return_value: Boolean
    begin
        return_value := false;
        TbImprestSurrenderLines.Reset;
        TbImprestSurrenderLines.SetRange("Surrender Doc No.", requisitionNo);
        TbImprestSurrenderLines.SetRange(TbImprestSurrenderLines."Entry No", LineNo);
        TbImprestSurrenderLines.SetRange("Account No:", accountNo);
        if TbImprestSurrenderLines.FindFirst() then begin
            TbImprestSurrenderLines.Delete;
            return_value := true;
        end else begin
            Error('Imprest surrender details cannot be deleted or was not found');
        end;
    end;

    procedure RequestImprestSurrenderApproval(docNo: Code[100]) return_value: Boolean
    var
        ApprovalEntry: Record "Approval Entry";
        WorkflowOk: Boolean;
    begin
        return_value := false;
        TbImprestSurrenderHeader.Reset;
        TbImprestSurrenderHeader.SetRange(No, docNo);
        if not TbImprestSurrenderHeader.FindFirst() then
            Error('Imprest Surrender %1 was not found.', docNo);

        VarVariant := TbImprestSurrenderHeader;
        if not CuCustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) then
            Error(
                'Imprest Surrender approval workflow is not enabled for %1.\\' +
                'Baby steps in Business Central: (1) Tell Me → Workflows. (2) Create/enable a workflow for Imprest Surrender ' +
                '(event: Approval of a Imprest Surrender is requested). (3) User Setup → set Approver ID for the requester. (4) Try Request Approval again.',
                docNo);

        CuCustomApprovals.OnSendDocForApproval(VarVariant);
        Commit();

        if TbImprestSurrenderHeader.Get(docNo) then
            if TbImprestSurrenderHeader.Status = TbImprestSurrenderHeader.Status::"Pending Approval" then
                WorkflowOk := true;

        if not WorkflowOk then begin
            ApprovalEntry.Reset();
            ApprovalEntry.SetRange("Table ID", Database::"Imprest Surrender Header");
            ApprovalEntry.SetRange("Document No.", docNo);
            ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Open);
            WorkflowOk := not ApprovalEntry.IsEmpty();
        end;

        if not WorkflowOk then
            Error(
                'Business Central did not create approval entries for Imprest Surrender %1.\\' +
                'Baby steps: enable the Imprest Surrender workflow, set Approver ID on User Setup for the surrender owner, then request approval again.',
                docNo);

        return_value := true;
    end;

    procedure CancelImprestSurrender(employeeNo: Code[100]; requisitionNo: Code[100]; tableID: Integer) return_value: Boolean
    var
        blnparam: Boolean;
    begin
        return_value := false;
        TbImprestSurrenderHeader.Reset;
        TbImprestSurrenderHeader.SetRange(No, requisitionNo);
        if TbImprestSurrenderHeader.FindFirst() then begin
            VarVariant := TbImprestSurrenderHeader;
            CuCustomApprovals.OnCancelDocApprovalRequest(VarVariant);
        end else begin
            Error('Imprest Surrender cannot be cancelled or was not found');
        end;
    end;

    // Start Petty Cash

    /*  procedure PettyCashHeader(myUserID: Code[30]; myAction: Text[100]; docNo: Code[30]; imprestIssueDocNo: Code[30]; receivedFrom: Code[50]; PVNo: Code[30]) return_value: Code[50]
     begin
         return_value := '';
         if myAction = 'create' then begin
             TbCashOfficeSetup.Get;
             TbCashOfficeSetup.TestField("Petty Cash Payments No");
             NextNo := CuNoSeriesMgt.GetNextNo(TbCashOfficeSetup."Petty Cash Payments No", 0D, true);
             PettyCashHeaderTbl."No." := NextNo;
             PettyCashHeaderTbl.Date := Today;
             PettyCashHeaderTbl."Payment Type" := PettyCashHeaderTbl."Payment Type"::"Petty Cash";
             TbImprestSurrenderHeader."Account No." := GetUserCustomerNo(myUserID, '');
             TbImprestSurrenderHeader."Imprest Issue Doc. No" := imprestIssueDocNo;
             TbImprestSurrenderHeader."Received From" := receivedFrom;
             TbImprestSurrenderHeader."PV No" := PVNo;
             //TbImprestSurrenderHeader."Financial Period":=financialPeriod;
             if TbImprestSurrenderHeader.Insert() then begin
                 Commit;
                 TbImprestSurrenderHeader.Reset;
                 TbImprestSurrenderHeader.SetRange(No, NextNo);
                 if TbImprestSurrenderHeader.FindFirst then begin
                     TbImprestSurrenderHeader.Validate("Imprest Issue Doc. No");
                     TbImprestSurrenderHeader.Validate("PV No");
                     TbImprestSurrenderHeader.Modify;
                 end;
             end;
             return_value := NextNo;
         end else begin
             TbImprestSurrenderHeader.Reset;
             TbImprestSurrenderHeader.SetRange(No, docNo);
             if TbImprestSurrenderHeader.FindFirst then begin
                 TbImprestSurrenderHeader."Imprest Issue Doc. No" := imprestIssueDocNo;
                 TbImprestSurrenderHeader.Validate("Imprest Issue Doc. No");
                 TbImprestSurrenderHeader."Received From" := receivedFrom;
                 TbImprestSurrenderHeader."PV No" := PVNo;
                 TbImprestSurrenderHeader.Validate("PV No");
                 //TbImprestSurrenderHeader."Financial Period":=financialPeriod;
                 TbImprestSurrenderHeader.Validate("Financial Period");
                 TbImprestSurrenderHeader.Modify(true);
                 return_value := docNo;
             end;
         end;
     end;

     procedure PettyCashLine(docNo: Code[50]; lineNo: Integer; actualSpent: Decimal; cashReceiptNo: Code[30]; cashReceiptAmount: Decimal) return_value: Boolean
     begin
         return_value := false;
         TbImprestSurrenderLines.Reset;
         TbImprestSurrenderLines.SetRange("Surrender Doc No.", docNo);
         TbImprestSurrenderLines.SetRange(TbImprestSurrenderLines."Entry No", lineNo);
         if TbImprestSurrenderLines.FindFirst() then begin
             TbImprestSurrenderLines."Actual Spent" := actualSpent;
             TbImprestSurrenderLines."Cash Receipt No" := cashReceiptNo;
             TbImprestSurrenderLines."Cash Receipt Amount" := cashReceiptAmount;
             TbImprestSurrenderLines.Validate("Actual Spent");
             TbImprestSurrenderLines.Modify;
             return_value := true;
         end else begin
             Error('Imprest surrender line is no longer editable or it does not exist.');
         end;
     end; */
    //
    procedure FnPettyCashHeader(myAction: Text; requiredDate: Date; staffNo: Code[30]; recId: Text; myUserId: Code[30]; narration: Text) returnValue: Text
    var
        dimensionSet: Text;
        PettyCashHeader: Record "Payments Header";
    begin
        returnValue := '';
        case myAction of
            'create':
                begin
                    TbCashOfficeSetup.Get();
                    TbCashOfficeSetup.TestField("Petty Cash Payments No");
                    NextNo := CuNoSeriesMgt.GetNextNo(TbCashOfficeSetup."Petty Cash Payments No", 0D, true);

                    PettyCashHeader.INIT;
                    PettyCashHeader."No." := NextNo;
                    PettyCashHeader.Date := requiredDate;
                    PettyCashHeader."Payment Type" := PettyCashHeader."Payment Type"::"Petty Cash";
                    PettyCashHeader.Validate("Payment Type");
                    PettyCashHeader."Employee No" := staffNo;
                    PettyCashHeader.VALIDATE("Employee No");
                    TbEmployee.Reset();
                    TbEmployee.SetRange("No.", PettyCashHeader."Employee No");
                    if TbEmployee.FindFirst() then begin
                        PettyCashHeader.Payee := TbEmployee."Full Name";
                        PettyCashHeader."On Behalf Of" := TbEmployee."Full Name";
                    end;
                    PettyCashHeader."Payment Narration" := narration;
                    PettyCashHeader.Cashier := myUserId;
                    if PettyCashHeader.Insert(true) then begin
                        // Payments Header.OnInsert runs as the SOAP service account
                        // and replaces Cashier with ADMIN. Restore the portal user so
                        // Approval User Setup resolves the employee's real approver.
                        PettyCashHeader.Cashier := myUserId;
                        PettyCashHeader.Modify(false);
                        returnValue := NextNo;
                    end;
                end;
            'edit':
                begin
                    PettyCashHeader.Reset();
                    PettyCashHeader.SetRange(PettyCashHeader."No.", recId);
                    PettyCashHeader.SetRange(PettyCashHeader.Status, PettyCashHeader.Status::Pending);
                    if PettyCashHeader.FindFirst() then begin
                        PettyCashHeader."Payment Type" := PettyCashHeader."Payment Type"::"Petty Cash";
                        PettyCashHeader.Date := requiredDate;
                        PettyCashHeader."Employee No" := staffNo;
                        PettyCashHeader.VALIDATE("Employee No");
                        TbEmployee.Reset();
                        TbEmployee.SetRange("No.", PettyCashHeader."Employee No");
                        if TbEmployee.FindFirst() then begin
                            PettyCashHeader.Payee := TbEmployee."Full Name";
                            PettyCashHeader."On Behalf Of" := TbEmployee."Full Name";
                        end;
                        PettyCashHeader."Payment Narration" := narration;
                        PettyCashHeader.Cashier := myUserId;
                        if PettyCashHeader.Modify(true) then
                            returnValue := PettyCashHeader."No.";
                    end;
                end;
            'delete':
                begin
                    PettyCashHeader.Reset();
                    PettyCashHeader.SetRange(PettyCashHeader.SystemId, recId);
                    PettyCashHeader.SetRange(PettyCashHeader.Status, PettyCashHeader.Status::Pending);
                    if PettyCashHeader.FindFirst() then begin
                        if PettyCashHeader.Delete(true) then
                            returnValue := 'success';
                    end;
                end;

        end;
    end;
    //TODO: Start Form Here
    procedure FnPettyCashLine(MyAction: Text; staffNo: Code[30]; myUserId: Code[30]; recId: Integer; LineNo: Integer; parentId: Code[30]; type: Code[20]; amount: Decimal) returnValue: Text
    var
        TbHeader: Record "Payments Header";
        TbRec: Record "Payment Line";
    begin
        returnValue := '';
        //
        TbHeader.reset;
        TbHeader.setrange("No.", parentId);
        TbHeader.setrange(TbHeader.Status, TbHeader.Status::Pending);
        IF NOT TbHeader.findfirst THEN
            ERROR('Document no %1 not found or is not editable.', parentId);
        //
        case myAction of
            'create':
                begin
                    TbRec.INIT;
                    TbRec.No := parentId;
                    TbRec."Payment Type" := TbRec."Payment Type"::"Petty Cash";
                    TbRec.Type := type;
                    TbRec.VALIDATE(Type);
                    TbRec."Global Dimension 1 Code" := TbHeader."Global Dimension 1 Code";
                    TbRec."Shortcut Dimension 2 Code" := TbHeader."Shortcut Dimension 2 Code";
                    TbRec.Amount := amount;
                    TbRec.VALIDATE(Amount);
                    if TbRec."Net Amount" = 0 then begin
                        TbRec."Net Amount" := amount;
                        TbRec.VALIDATE("Net Amount");
                    end;
                    IF TbRec.insert(TRUE) THEN
                        returnValue := 'success';
                end;
            'edit':
                begin
                    TbRec.Reset();
                    TbRec.SetRange(TbRec."Line No.", recId);
                    TbRec.SetRange(TbRec.No, parentId);
                    if TbRec.FindFirst() then begin
                        TbRec.Type := type;
                        TbRec.VALIDATE(Type);
                        TbRec."Global Dimension 1 Code" := TbHeader."Global Dimension 1 Code";
                        TbRec."Shortcut Dimension 2 Code" := TbHeader."Shortcut Dimension 2 Code";
                        TbRec.Amount := amount;
                        TbRec.VALIDATE(Amount);
                        if TbRec."Net Amount" = 0 then begin
                            TbRec."Net Amount" := amount;
                            TbRec.VALIDATE("Net Amount");
                        end;
                        if TbRec.Modify(true) then
                            returnValue := 'success';
                    end else
                        Error('Line not found');
                end;
            'delete':
                begin
                    TbRec.Reset();
                    TbRec.SetRange(TbRec."Line No.", recId);
                    TbRec.SetRange(TbRec.No, parentId);
                    if TbRec.FindFirst() then begin
                        if TbRec.Delete(true) then
                            returnValue := 'success';
                    end else
                        Error('Line not found');
                end;
        end;
    end;

    procedure RequestPettyCashApproval(docNo: Code[100]) return_value: Boolean
    var
        PettyCashAfterApproval: Record "Payments Header";
        PettyCashRecRef: RecordRef;
        RecordIdToApprove: RecordId;
        HasApprovalEntry: Boolean;
        RequesterUserID: Code[50];
    begin
        return_value := false;
        PettyCashHeaderTbl.Reset;
        PettyCashHeaderTbl.SetRange(PettyCashHeaderTbl."No.", docNo);
        PettyCashHeaderTbl.SetRange("Payment Type", PettyCashHeaderTbl."Payment Type"::"Petty Cash");
        PettyCashHeaderTbl.SetRange(Status, PettyCashHeaderTbl.Status::Pending);
        if PettyCashHeaderTbl.FindFirst() then begin
            if not HasPortalDocumentAttachment(Database::"Payments Header", docNo) then
                Error('Attach at least one supporting document before requesting approval for petty cash.');

            // Repair drafts created before the Cashier fix above.
            if PettyCashHeaderTbl."Employee No" <> '' then begin
                TbUserSetup.Reset();
                TbUserSetup.SetRange("Employee No.", PettyCashHeaderTbl."Employee No");
                if TbUserSetup.FindFirst() then begin
                    RequesterUserID := TbUserSetup."User ID";
                    if (RequesterUserID <> '') and (PettyCashHeaderTbl.Cashier <> RequesterUserID) then begin
                        PettyCashHeaderTbl.Cashier := RequesterUserID;
                        PettyCashHeaderTbl.Modify(false);
                        Commit();
                    end;
                end;
            end;

            VarVariant := PettyCashHeaderTbl;
            if not CuCustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) then
                Error('Business Central approval workflow is not configured for petty cash %1.', docNo);

            CuCustomApprovals.OnSendDocForApproval(VarVariant);
            Commit();

            if not PettyCashAfterApproval.Get(docNo) then
                Error('Petty cash %1 was not found after requesting approval.', docNo);

            PettyCashRecRef.GetTable(PettyCashAfterApproval);
            RecordIdToApprove := PettyCashRecRef.RecordId;
            if PettyCashAfterApproval.Cashier <> '' then begin
                FnUpdateApprovalEntries(docNo, PettyCashAfterApproval.Cashier, RecordIdToApprove);
                Commit();
            end;

            TbApprovalEntry.Reset();
            TbApprovalEntry.SetRange("Record ID to Approve", RecordIdToApprove);
            TbApprovalEntry.SetRange("Table ID", Database::"Payments Header");
            TbApprovalEntry.SetFilter(Status, '%1|%2', TbApprovalEntry.Status::Open, TbApprovalEntry.Status::Created);
            HasApprovalEntry := not TbApprovalEntry.IsEmpty;

            if (PettyCashAfterApproval.Status <> PettyCashAfterApproval.Status::"Pending Approval") and HasApprovalEntry then begin
                PettyCashAfterApproval.Validate(Status, PettyCashAfterApproval.Status::"Pending Approval");
                PettyCashAfterApproval.Modify(false);
                Commit();
            end;

            if PettyCashAfterApproval.Get(docNo) then
                return_value := (PettyCashAfterApproval.Status = PettyCashAfterApproval.Status::"Pending Approval") and HasApprovalEntry;

            if not return_value then
                Error(
                    'Business Central did not create approval entries for petty cash %1. Enable the Petty Cash workflow and confirm Approval User Setup has an approver for %2.',
                    docNo, PettyCashAfterApproval.Cashier);
        end else begin
            Error('Petty Cash cannot be sent for approval, is not a draft, or was not found');
        end;
    end;

    procedure CancelPettyCashRequest(requisitionNo: Code[100]; docNo: Code[100]) return_value: Boolean
    var
        blnparam: Boolean;
    begin
        return_value := false;
        if requisitionNo = '' then
            requisitionNo := docNo;
        PettyCashHeaderTbl.Reset;
        PettyCashHeaderTbl.SetRange("No.", requisitionNo);
        if PettyCashHeaderTbl.FindFirst() then begin
            VarVariant := PettyCashHeaderTbl;
            CuCustomApprovals.OnCancelDocApprovalRequest(VarVariant);
            return_value := true;
        end else begin
            Error('Petty Cash cannot be cancelled or was not found');
        end;
    end;

    // Stop Petty Cash

    procedure StoreRequisitionHeader(myUserID: Code[100]; myAction: Text; docNo: Code[30]; requestDate: Date; requestDescription: Text; issuingStore: Code[30]; justification: Text[250]; priority: Integer; storeRequisitionType: Integer) return_value: Code[50]
    begin
        return_value := '';
        TbStoreRequisition.Reset;
        if myAction = 'create' then begin
            TbCashOfficeSetup.Get;
            TbCashOfficeSetup.TestField("Stores Requisition No");
            NextNo := CuNoSeriesMgt.GetNextNo(TbCashOfficeSetup."Stores Requisition No", 0D, true);
            TbStoreRequisition.Init;
            TbStoreRequisition."No." := NextNo;
            TbStoreRequisition."User ID" := myUserID;
            TbStoreRequisition."Requester ID" := CopyStr(myUserID, 1, MaxStrLen(TbStoreRequisition."Requester ID"));
            TbStoreRequisition."Request date" := Today;
            TbStoreRequisition."Required Date" := requestDate;
            if (requestDate <> 0D) and (requestDate < Today) then
                Error('Required Date cannot be in the past.');
            TbStoreRequisition."Request Description" := requestDescription;
            if justification <> '' then
                TbStoreRequisition.Justification := justification;
            if (priority >= 0) and (priority <= 3) then
                TbStoreRequisition.Priority := priority;
            if (storeRequisitionType >= 0) and (storeRequisitionType <= 1) then
                TbStoreRequisition."Store Requisition Type" := storeRequisitionType;
            // v1.0.2.360: header-level Issuing Store selected in the portal
            // (mirrors the Store Requisition Header UP page).
            if issuingStore <> '' then
                TbStoreRequisition."Issuing Store" := issuingStore;
            //
            TbUserSetup.Get(myUserID);
            TbUserSetup.TestField("Employee No.");
            TbStoreRequisition."Employee No" := TbUserSetup."Employee No.";
            TbEmployee.Reset;
            TbEmployee.SetRange("No.", TbUserSetup."Employee No.");
            if TbEmployee.FindFirst then begin
                // TbEmployee.TestField("Global Dimension 1 Code");
                // TbEmployee.TestField("Global Dimension 2 Code");
                // TbEmployee.TestField("Responsibility Center");
                TbStoreRequisition.Validate("Global Dimension 1 Code", TbEmployee."Global Dimension 1 Code");
                TbStoreRequisition.Validate("Shortcut Dimension 2 Code", TbEmployee."Global Dimension 2 Code");
                TbStoreRequisition."Shortcut Dimension 3 Code" := TbEmployee."Global Dimension 3 Code";
                TbStoreRequisition."Responsibility Center" := TbEmployee."Responsibility Center";
            end;
            TbStoreRequisition.Insert(true);
            // The table OnInsert trigger runs under the SOAP service account and
            // replaces Requester ID/Employee No. with ADMIN. Restore the actual
            // portal requester after the trigger so BC workflow resolves the
            // employee's Approval User Setup instead of the service account.
            TbStoreRequisition."User ID" := myUserID;
            TbStoreRequisition."Requester ID" := CopyStr(myUserID, 1, MaxStrLen(TbStoreRequisition."Requester ID"));
            TbStoreRequisition."Employee No" := TbUserSetup."Employee No.";
            if TbEmployee."No." <> '' then begin
                TbStoreRequisition.Validate("Global Dimension 1 Code", TbEmployee."Global Dimension 1 Code");
                TbStoreRequisition.Validate("Shortcut Dimension 2 Code", TbEmployee."Global Dimension 2 Code");
            end;
            TbStoreRequisition.Modify(false);
            return_value := NextNo;
        end else begin
            TbStoreRequisition.SetRange("No.", docNo);
            if TbStoreRequisition.FindFirst() then begin
                TbStoreRequisition."Required Date" := requestDate;
                if (requestDate <> 0D) and (TbStoreRequisition."Request date" <> 0D) then
                    if requestDate < TbStoreRequisition."Request date" then
                        Error('Required Date cannot be before Request Date.');
                TbStoreRequisition."Request Description" := requestDescription;
                if justification <> '' then
                    TbStoreRequisition.Justification := justification;
                if (priority >= 0) and (priority <= 3) then
                    TbStoreRequisition.Priority := priority;
                if (storeRequisitionType >= 0) and (storeRequisitionType <= 1) then
                    TbStoreRequisition."Store Requisition Type" := storeRequisitionType;
                // v1.0.2.360: header-level Issuing Store selected in the portal.
                if issuingStore <> '' then
                    TbStoreRequisition."Issuing Store" := issuingStore;
                //
                TbUserSetup.Get(myUserID);
                TbUserSetup.TestField("Employee No.");
                TbStoreRequisition."User ID" := myUserID;
                TbStoreRequisition."Requester ID" := CopyStr(myUserID, 1, MaxStrLen(TbStoreRequisition."Requester ID"));
                TbStoreRequisition."Employee No" := TbUserSetup."Employee No.";
                TbEmployee.Reset;
                TbEmployee.SetRange("No.", TbUserSetup."Employee No.");
                if TbEmployee.FindFirst then begin
                    // TbEmployee.TestField("Global Dimension 1 Code");
                    // TbEmployee.TestField("Global Dimension 2 Code");
                    // TbEmployee.TestField("Responsibility Center");
                    TbStoreRequisition.Validate("Global Dimension 1 Code", TbEmployee."Global Dimension 1 Code");
                    TbStoreRequisition.Validate("Shortcut Dimension 2 Code", TbEmployee."Global Dimension 2 Code");
                    TbStoreRequisition."Shortcut Dimension 3 Code" := TbEmployee."Global Dimension 3 Code";
                    TbStoreRequisition."Responsibility Center" := TbEmployee."Responsibility Center";
                end;
                TbStoreRequisition.Modify;
                return_value := docNo;
            end else begin
                Error('Requisition is no longer editable or it does not exist.');
            end;
        end;
    end;

    procedure StoreRequisitionLine("action": Text; lineNo: Integer; type: Integer; reqNo: Code[50]; itemNo: Code[100]; location: Code[30]; quantity: Decimal; description: Text[70]; unitOfMeasure: Code[20]; preferredBrandModel: Text[50]; remarks: Text[200]) return_value: Boolean
    var
        ItemRec: Record Item;
        FARec: Record "Fixed Asset";
        resolvedItemNo: Code[20];
        lineDescription: Text[70];
    begin
        return_value := false;
        resolvedItemNo := '';
        lineDescription := description;
        if itemNo <> '' then begin
            if type = 1 then begin
                if ItemRec.Get(CopyStr(itemNo, 1, MaxStrLen(ItemRec."No."))) then begin
                    resolvedItemNo := ItemRec."No.";
                    if lineDescription = '' then
                        lineDescription := CopyStr(ItemRec.Description, 1, MaxStrLen(lineDescription));
                end;
            end else
                if type = 2 then begin
                    if FARec.Get(CopyStr(itemNo, 1, MaxStrLen(FARec."No."))) then begin
                        resolvedItemNo := FARec."No.";
                        if lineDescription = '' then
                            lineDescription := CopyStr(FARec.Description, 1, MaxStrLen(lineDescription));
                    end;
                end;
            // Unknown codes are ignored — free-text name/description still saves.
            if (resolvedItemNo = '') and (lineDescription = '') then
                lineDescription := CopyStr(itemNo, 1, MaxStrLen(lineDescription));
        end;
        if lineDescription = '' then
            Error('Item / asset name is required when no valid BC item code is provided.');

        TbStoreRequisitionLine.Reset;
        if action = 'create' then begin
            TbStoreRequisitionLine.Reset;
            TbStoreRequisitionLine.SetRange("Requistion No", reqNo);
            if TbStoreRequisitionLine.FindLast then
                lineNo := TbStoreRequisitionLine."Line No." + 10000
            else
                lineNo := 10000;
            TbStoreRequisitionLine.Init;
            TbStoreRequisitionLine."Line No." := lineNo;
            TbStoreRequisitionLine."Requistion No" := reqNo;
            TbStoreRequisitionLine.Type := type;
            TbStoreRequisitionLine."Issuing Store" := location;
            TbStoreRequisitionLine.Quantity := quantity;
            TbStoreRequisitionLine."Quantity Requested" := quantity;
            TbStoreRequisitionLine.Description := lineDescription;
            if preferredBrandModel <> '' then
                TbStoreRequisitionLine."Description 2" := preferredBrandModel;
            if resolvedItemNo <> '' then begin
                TbStoreRequisitionLine."No." := resolvedItemNo;
                TbStoreRequisitionLine.Validate("No.");
                // Keep requestor free-text description when provided.
                if description <> '' then
                    TbStoreRequisitionLine.Description := description;
                if preferredBrandModel <> '' then
                    TbStoreRequisitionLine."Description 2" := preferredBrandModel;
            end else
                if itemNo <> '' then
                    // ValidateTableRelation = false — keep typed code for portal display.
                    TbStoreRequisitionLine."No." := CopyStr(itemNo, 1, MaxStrLen(TbStoreRequisitionLine."No."));
            if unitOfMeasure <> '' then
                TbStoreRequisitionLine."Unit of Measure" := unitOfMeasure;
            TbStoreRequisitionLine.Remarks := remarks;
            TbStoreRequisitionLine.Validate(Quantity);
            TbStoreRequisitionLine.Validate("Quantity Requested");
            if unitOfMeasure <> '' then
                TbStoreRequisitionLine."Unit of Measure" := unitOfMeasure;
            TbStoreRequisitionLine.Insert(true);
            return_value := true;
        end else begin
            TbStoreRequisitionLine.SetRange("Requistion No", reqNo);
            TbStoreRequisitionLine.SetRange("Line No.", lineNo);
            if TbStoreRequisitionLine.FindFirst() then begin
                TbStoreRequisitionLine."Requistion No" := reqNo;
                TbStoreRequisitionLine.Type := type;
                TbStoreRequisitionLine."Issuing Store" := location;
                TbStoreRequisitionLine.Quantity := quantity;
                TbStoreRequisitionLine."Quantity Requested" := quantity;
                TbStoreRequisitionLine.Description := lineDescription;
                if preferredBrandModel <> '' then
                    TbStoreRequisitionLine."Description 2" := preferredBrandModel;
                if resolvedItemNo <> '' then begin
                    TbStoreRequisitionLine."No." := resolvedItemNo;
                    TbStoreRequisitionLine.Validate("No.");
                    if description <> '' then
                        TbStoreRequisitionLine.Description := description;
                    if preferredBrandModel <> '' then
                        TbStoreRequisitionLine."Description 2" := preferredBrandModel;
                end else
                    if itemNo <> '' then
                        TbStoreRequisitionLine."No." := CopyStr(itemNo, 1, MaxStrLen(TbStoreRequisitionLine."No."))
                    else
                        Clear(TbStoreRequisitionLine."No.");
                if unitOfMeasure <> '' then
                    TbStoreRequisitionLine."Unit of Measure" := unitOfMeasure;
                TbStoreRequisitionLine.Remarks := remarks;
                TbStoreRequisitionLine.Validate(Quantity);
                TbStoreRequisitionLine.Validate("Quantity Requested");
                if unitOfMeasure <> '' then
                    TbStoreRequisitionLine."Unit of Measure" := unitOfMeasure;
                TbStoreRequisitionLine.Modify(true);
                return_value := true;
            end else begin
                Error('Store requisition line is no longer editable or it does not exist.');
            end;
        end;
    end;

    procedure DeleteStoreReqLine(lineNo: Integer; requisitionNo: Code[100]) return_value: Boolean
    begin
        return_value := false;
        TbStoreRequisitionLine.Reset;
        TbStoreRequisitionLine.SetRange("Requistion No", requisitionNo);
        TbStoreRequisitionLine.SetRange("Line No.", lineNo);
        if TbStoreRequisitionLine.FindFirst() then begin
            TbStoreRequisitionLine.Delete;
            return_value := true;
        end else begin
            Error('Requisition line cannot be deleted or was not found');
        end;
    end;

    procedure CancelStoreRequisition(employeeNo: Code[100]; requisitionNo: Code[100]; tableID: Integer) return_value: Boolean
    var
        blnparam: Boolean;
    begin
        return_value := false;
        TbStoreRequisition.Reset;
        TbStoreRequisition.SetRange("No.", requisitionNo);
        if TbStoreRequisition.FindFirst() then begin
            VarVariant := TbStoreRequisition;
            CuCustomApprovals.OnCancelDocApprovalRequest(VarVariant);
            return_value := true;
        end else begin
            Error('Requisition cannot be cancelled or was not found');
        end;
    end;

    procedure RequestStoreReqApproval(employeeNo: Code[100]; reqNo: Code[50]; tableID: Integer) return_value: Boolean
    var
        StoreReqAfterApproval: Record "Store Requistion Header";
        StoreReqRecRef: RecordRef;
        RecordIdToApprove: RecordId;
        HasApprovalEntry: Boolean;
        RequesterUserID: Code[50];
    begin
        return_value := false;
        if not IsStoreReqLinesExists(reqNo) then
            Error('You must add store requisition lines before sending the requisition for approval.');
        TbStoreRequisition.Reset;
        TbStoreRequisition.SetRange("No.", reqNo);
        TbStoreRequisition.SetRange(Status, TbStoreRequisition.Status::Open);
        if TbStoreRequisition.FindFirst() then begin
            // Repair older portal drafts that were stamped as ADMIN by the table
            // OnInsert trigger. Approval must be sent as the employee's mapped BC
            // user so the correct approver chain is selected.
            if employeeNo <> '' then begin
                TbUserSetup.Reset();
                TbUserSetup.SetRange("Employee No.", employeeNo);
                if TbUserSetup.FindFirst() then begin
                    RequesterUserID := TbUserSetup."User ID";
                    if RequesterUserID <> '' then begin
                        TbStoreRequisition."User ID" := CopyStr(RequesterUserID, 1, MaxStrLen(TbStoreRequisition."User ID"));
                        TbStoreRequisition."Requester ID" := CopyStr(RequesterUserID, 1, MaxStrLen(TbStoreRequisition."Requester ID"));
                    end;
                    TbStoreRequisition."Employee No" := CopyStr(employeeNo, 1, MaxStrLen(TbStoreRequisition."Employee No"));
                    TbStoreRequisition.Modify(false);
                    Commit();
                end;
            end;

            if TbStoreRequisition.Justification = '' then
                Error('Purpose / Justification is required.');
            if TbStoreRequisition."Required Date" = 0D then
                Error('Required Date is required.');
            if not HasPortalDocumentAttachment(Database::"Store Requistion Header", reqNo) then
                Error('Attach at least one supporting document before requesting approval for store requisition.');
            if RequesterUserID = '' then
                RequesterUserID := TbStoreRequisition."User ID";
            if RequesterUserID <> '' then
                if TbUserSetup.Get(RequesterUserID) then
                    if TbUserSetup."Approver ID" = '' then
                        Error(
                            'Approval User Setup for %1 has no Approver ID. Store requisition flow is Supervisor → Department Head → Division Head → Finance and Admin Head. If the requester is a supervisor, set Approver ID to the Department Head. If Department Head, set it to the Division Head. If Division Head, set it to the Finance and Admin Head.',
                            RequesterUserID);

            VarVariant := TbStoreRequisition;
            if not CuCustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) then
                Error('Business Central approval workflow is not configured for store requisition %1.', reqNo);

            CuCustomApprovals.OnSendDocForApproval(VarVariant);
            Commit();

            if not StoreReqAfterApproval.Get(reqNo) then
                Error('Store requisition %1 was not found after requesting approval.', reqNo);

            StoreReqRecRef.GetTable(StoreReqAfterApproval);
            RecordIdToApprove := StoreReqRecRef.RecordId;
            TbApprovalEntry.Reset();
            TbApprovalEntry.SetRange("Record ID to Approve", RecordIdToApprove);
            TbApprovalEntry.SetRange("Table ID", Database::"Store Requistion Header");
            TbApprovalEntry.SetFilter(Status, '%1|%2', TbApprovalEntry.Status::Open, TbApprovalEntry.Status::Created);
            HasApprovalEntry := not TbApprovalEntry.IsEmpty;

            return_value := HasApprovalEntry;
            if not return_value then
                Error(
                    'Business Central did not create approval entries for store requisition %1. Enable the Store Requisition workflow and confirm Approval User Setup is assigned for the requester.',
                    reqNo);
        end else begin
            Error('Requisition is no longer editable or it does not exist.');
        end;
    end;

    procedure IsStoreReqLinesExists(reqNo: Code[100]) hasLines: Boolean
    begin
        hasLines := false;
        TbStoreRequisitionLine.Reset;
        TbStoreRequisitionLine.SetRange(TbStoreRequisitionLine."Requistion No", reqNo);
        if TbStoreRequisitionLine.FindFirst() then begin
            hasLines := true;
        end;
    end;

    procedure PurchaseRequisitionHeader("action": Text; myUserId: Code[100]; reqNo: Code[100]; postingDescription: Text; orderDate: Date; pricesIncludingVAT: Boolean; requestingDepartment: Code[30]; priority: Integer; purchaseRequestType: Integer; projectCode: Code[10]; justification: Text[250]; currencyCode: Code[10]; technicalRequirement: Text[250]; otherRequirements: Text[250]; scopeOfWork: Text[250]) return_value: Code[50]
    var
        DimValue: Record "Dimension Value";
        Currency: Record Currency;
    begin
        return_value := '';
        TbProcurementSetup.Get();
        TbProcurementSetup.TestField("Quote Nos.");
        TbPurchaseHeader.Reset;
        if action = 'create' then begin
            NextNo := CuNoSeriesMgt.GetNextNo(TbProcurementSetup."Quote Nos.", 0D, true);
            TbPurchaseHeader.Init;
            TbPurchaseHeader."Document Type" := TbPurchaseHeader."Document Type"::Quote;
            TbPurchaseHeader."Document Type 2" := TbPurchaseHeader."Document Type 2"::Requisition;
            TbPurchaseHeader.DocApprovalType := TbPurchaseHeader.DocApprovalType::Requisition;
            TbPurchaseHeader."No." := NextNo;
            // Assign fields without Validate before Insert — Validate on Dimension/
            // Currency/Vendor can Get(Document Type, No.) and fail with
            // "Purchase Header does not exist" because the row is not saved yet.
            TbPurchaseHeader."Assigned User ID" := myUserId;
            TbPurchaseHeader."Requested Receipt Date" := orderDate;
            TbPurchaseHeader."Order Date" := Today;
            TbPurchaseHeader."Document Date" := Today;
            if (orderDate <> 0D) and (orderDate < Today) then
                Error('Required Date cannot be earlier than the request date.');
            TbPurchaseHeader."Posting Description" := postingDescription;
            TbPurchaseHeader."Request Description" := CopyStr(postingDescription, 1, MaxStrLen(TbPurchaseHeader."Request Description"));
            if justification <> '' then
                TbPurchaseHeader.Justification := justification
            else
                TbPurchaseHeader.Justification := CopyStr(postingDescription, 1, MaxStrLen(TbPurchaseHeader.Justification));
            if (priority >= 0) and (priority <= 3) then
                TbPurchaseHeader.Priority := priority;
            if (purchaseRequestType >= 0) and (purchaseRequestType <= 4) then
                TbPurchaseHeader."Purchase Request Type" := purchaseRequestType;
            if projectCode <> '' then begin
                TbPurchaseHeader."Budget Type" := TbPurchaseHeader."Budget Type"::Project;
                TbPurchaseHeader."Project Code" := projectCode;
            end else begin
                TbPurchaseHeader."Budget Type" := TbPurchaseHeader."Budget Type"::"Non-Project";
                Clear(TbPurchaseHeader."Project Code");
            end;
            if currencyCode <> '' then begin
                Currency.Reset();
                if Currency.Get(currencyCode) then
                    TbPurchaseHeader."Currency Code" := currencyCode;
            end;
            TbPurchaseHeader."Technical Requirement" := technicalRequirement;
            TbPurchaseHeader."Other Requirements" := otherRequirements;
            TbPurchaseHeader."Scope of Work" := scopeOfWork;
            TbPurchaseHeader."Prices Including VAT" := pricesIncludingVAT;
            TbPurchaseHeader."Buy-from Vendor No." := TbProcurementSetup."Requisition Default Vendor";
            TbPurchaseHeader."Pay-to Vendor No." := TbProcurementSetup."Requisition Default Vendor";

            TbUserSetup.Get(myUserId);
            TbUserSetup.TestField("Employee No.");
            TbEmployee.Reset;
            TbEmployee.SetRange("No.", TbUserSetup."Employee No.");
            if TbEmployee.FindFirst then begin
                TbPurchaseHeader."Shortcut Dimension 1 Code" := TbEmployee."Global Dimension 1 Code";
                TbPurchaseHeader."Shortcut Dimension 2 Code" := TbEmployee."Global Dimension 2 Code";
                TbPurchaseHeader."Shortcut Dimension 3 Code" := TbEmployee."Global Dimension 3 Code";
                TbPurchaseHeader.Department := TbEmployee."Global Dimension 2 Code";
                TbPurchaseHeader."Employee No." := TbEmployee."No.";
                TbPurchaseHeader."Responsibility Center" := TbEmployee."Responsibility Center";
                TbPurchaseHeader."Requestor Name" := CopyStr(TbEmployee."Full Name", 1, MaxStrLen(TbPurchaseHeader."Requestor Name"));
            end;
            if requestingDepartment <> '' then begin
                TbPurchaseHeader.Department := CopyStr(requestingDepartment, 1, MaxStrLen(TbPurchaseHeader.Department));
                DimValue.Reset();
                DimValue.SetRange(Code, TbPurchaseHeader.Department);
                DimValue.SetFilter("Dimension Code", '%1|%2', 'DEPARTMENT', 'DEPART/DIST');
                if not DimValue.FindFirst() then begin
                    DimValue.Reset();
                    DimValue.SetRange("Global Dimension No.", 2);
                    DimValue.SetRange(Code, TbPurchaseHeader.Department);
                end;
                if DimValue.FindFirst() then
                    TbPurchaseHeader."Shortcut Dimension 2 Code" := DimValue.Code;
            end;

            TbPurchaseHeader.Insert(true);

            // OnAfterInsert stamps Assigned User ID with the SOAP service account.
            // Restore the portal requester and apply Validates now that the row exists.
            if TbPurchaseHeader.Get(TbPurchaseHeader."Document Type"::Quote, TbPurchaseHeader."No.") then begin
                TbPurchaseHeader."Assigned User ID" := myUserId;
                TbPurchaseHeader."Employee No." := TbUserSetup."Employee No.";
                if TbEmployee."No." <> '' then
                    TbPurchaseHeader."Requestor Name" := CopyStr(TbEmployee."Full Name", 1, MaxStrLen(TbPurchaseHeader."Requestor Name"));
                if requestingDepartment <> '' then
                    TbPurchaseHeader.Department := CopyStr(requestingDepartment, 1, MaxStrLen(TbPurchaseHeader.Department));
                if TbPurchaseHeader."Shortcut Dimension 2 Code" <> '' then
                    TbPurchaseHeader.Validate("Shortcut Dimension 2 Code", TbPurchaseHeader."Shortcut Dimension 2 Code");
                if (TbPurchaseHeader."Currency Code" <> '') and Currency.Get(TbPurchaseHeader."Currency Code") then
                    TbPurchaseHeader.Validate("Currency Code", TbPurchaseHeader."Currency Code");
                TbPurchaseHeader.Modify(true);
            end;
            return_value := TbPurchaseHeader."No.";
        end else begin
            TbPurchaseHeader.Reset;
            TbPurchaseHeader.SetRange("No.", reqNo);
            TbPurchaseHeader.SetRange("Document Type", TbPurchaseHeader."Document Type"::Quote);
            TbPurchaseHeader.SetRange(Status, TbPurchaseHeader.Status::Open);
            if TbPurchaseHeader.FindFirst() then begin
                TbPurchaseHeader.DocApprovalType := TbPurchaseHeader.DocApprovalType::Requisition;
                TbPurchaseHeader."Document Type 2" := TbPurchaseHeader."Document Type 2"::Requisition;
                TbPurchaseHeader."Assigned User ID" := myUserId;
                TbPurchaseHeader."Requested Receipt Date" := orderDate;
                if (orderDate <> 0D) and (TbPurchaseHeader."Document Date" <> 0D) then
                    if orderDate < TbPurchaseHeader."Document Date" then
                        Error('Required Date cannot be earlier than the request date.');
                TbPurchaseHeader."Posting Description" := postingDescription;
                TbPurchaseHeader."Request Description" := CopyStr(postingDescription, 1, MaxStrLen(TbPurchaseHeader."Request Description"));
                if justification <> '' then
                    TbPurchaseHeader.Justification := justification
                else
                    TbPurchaseHeader.Justification := CopyStr(postingDescription, 1, MaxStrLen(TbPurchaseHeader.Justification));
                if (priority >= 0) and (priority <= 3) then
                    TbPurchaseHeader.Priority := priority;
                if (purchaseRequestType >= 0) and (purchaseRequestType <= 4) then
                    TbPurchaseHeader."Purchase Request Type" := purchaseRequestType;
                if projectCode <> '' then begin
                    TbPurchaseHeader."Budget Type" := TbPurchaseHeader."Budget Type"::Project;
                    TbPurchaseHeader."Project Code" := projectCode;
                end else begin
                    TbPurchaseHeader."Budget Type" := TbPurchaseHeader."Budget Type"::"Non-Project";
                    Clear(TbPurchaseHeader."Project Code");
                end;
                if currencyCode <> '' then begin
                    Currency.Reset();
                    if Currency.Get(currencyCode) then
                        TbPurchaseHeader.Validate("Currency Code", currencyCode);
                end;
                TbPurchaseHeader."Technical Requirement" := technicalRequirement;
                TbPurchaseHeader."Other Requirements" := otherRequirements;
                TbPurchaseHeader."Scope of Work" := scopeOfWork;
                TbPurchaseHeader."Prices Including VAT" := pricesIncludingVAT;
                //
                TbUserSetup.Get(myUserId);
                TbUserSetup.TestField("Employee No.");
                TbEmployee.Reset;
                TbEmployee.SetRange("No.", TbUserSetup."Employee No.");
                if TbEmployee.FindFirst then begin
                    TbPurchaseHeader."Shortcut Dimension 1 Code" := TbEmployee."Global Dimension 1 Code";
                    TbPurchaseHeader."Shortcut Dimension 2 Code" := TbEmployee."Global Dimension 2 Code";
                    TbPurchaseHeader."Shortcut Dimension 3 Code" := TbEmployee."Global Dimension 3 Code";
                    TbPurchaseHeader.Department := TbEmployee."Global Dimension 2 Code";
                    TbPurchaseHeader."Employee No." := TbEmployee."No.";
                    TbPurchaseHeader."Responsibility Center" := TbEmployee."Responsibility Center";
                    TbPurchaseHeader."Requestor Name" := CopyStr(TbEmployee."Full Name", 1, MaxStrLen(TbPurchaseHeader."Requestor Name"));
                end;
                // Portal requestingDepartment maps to Purchase Header.Department (ABH).
                // Assign without Dimension Value Validate — see create branch.
                if requestingDepartment <> '' then begin
                    TbPurchaseHeader.Department := CopyStr(requestingDepartment, 1, MaxStrLen(TbPurchaseHeader.Department));
                    DimValue.Reset();
                    DimValue.SetRange(Code, TbPurchaseHeader.Department);
                    DimValue.SetFilter("Dimension Code", '%1|%2', 'DEPARTMENT', 'DEPART/DIST');
                    if not DimValue.FindFirst() then begin
                        DimValue.Reset();
                        DimValue.SetRange("Global Dimension No.", 2);
                        DimValue.SetRange(Code, TbPurchaseHeader.Department);
                    end;
                    if DimValue.FindFirst() then
                        TbPurchaseHeader.Validate("Shortcut Dimension 2 Code", DimValue.Code);
                end;
                TbPurchaseHeader.Modify(true);
                return_value := reqNo;
            end else begin
                Error('Requisition is no longer editable or it does not exist.');
            end;
        end;
    end;

    procedure PurchaseRequisitionLine("action": Text; reqNo: Code[50]; lineNo: Integer; itemNo: Code[50]; location: Code[50]; quantity: Decimal; type: Integer; procurementPlan: Code[30]; reasonForRequest: Text; specification: Text; itemName: Text[100]; unitOfMeasure: Code[10]; estimatedUnitPrice: Decimal; preferredBrandModel: Text[50]; suggestedSupplier: Text[100]; remarks: Text[100]; category: Text[50]; requiredDate: Date) return_value: Boolean
    var
        effectiveSpecification: Text;
        effectiveDescription: Text;
        ItemRec: Record Item;
        FARec: Record "Fixed Asset";
        GLRec: Record "G/L Account";
        resolvedNo: Code[20];
    begin
        return_value := false;
        effectiveSpecification := specification;
        if effectiveSpecification = '' then
            effectiveSpecification := reasonForRequest;
        effectiveDescription := itemName;

        // Only stamp Purchase Line."No." when the code exists in the matching master.
        // Portal Item/Service Code is optional free text — unknown codes must not Validate.
        resolvedNo := '';
        if itemNo <> '' then begin
            case type of
                1:
                    if GLRec.Get(CopyStr(itemNo, 1, MaxStrLen(GLRec."No."))) then begin
                        resolvedNo := GLRec."No.";
                        if effectiveDescription = '' then
                            effectiveDescription := GLRec.Name;
                    end;
                2:
                    if ItemRec.Get(CopyStr(itemNo, 1, MaxStrLen(ItemRec."No."))) then begin
                        resolvedNo := ItemRec."No.";
                        if effectiveDescription = '' then
                            effectiveDescription := ItemRec.Description;
                    end;
                4:
                    if FARec.Get(CopyStr(itemNo, 1, MaxStrLen(FARec."No."))) then begin
                        resolvedNo := FARec."No.";
                        if effectiveDescription = '' then
                            effectiveDescription := FARec.Description;
                    end;
            end;
            if (resolvedNo = '') and (effectiveDescription = '') then
                effectiveDescription := CopyStr(itemNo, 1, MaxStrLen(TbPurchaseLine.Description));
        end;
        if effectiveDescription = '' then
            Error('Item / service name is required when no valid BC item, service, or asset code is provided.');

        TbPurchaseLine.Reset;
        if action = 'create' then begin
            TbPurchaseHeader.Reset();
            TbPurchaseHeader.SetRange("Document Type", TbPurchaseHeader."Document Type"::Quote);
            TbPurchaseHeader.SetRange("No.", reqNo);
            if not TbPurchaseHeader.FindFirst() then
                Error('Purchase requisition %1 was not found.', reqNo);
            TbPurchaseLine.SetRange("Document Type", TbPurchaseHeader."Document Type");
            TbPurchaseLine.SetRange("Document No.", reqNo);
            if TbPurchaseLine.FindLast then
                lineNo := TbPurchaseLine."Line No." + 10000
            else
                lineNo := 10000;
            TbPurchaseLine.Reset;
            TbPurchaseLine.Init;
            TbPurchaseLine."Document Type" := TbPurchaseHeader."Document Type";
            TbPurchaseLine."Document Type 2" := TbPurchaseLine."Document Type 2"::Requisition;
            TbPurchaseLine."Line No." := lineNo;
            TbPurchaseLine."Document No." := reqNo;
            if resolvedNo <> '' then begin
                TbPurchaseLine.Validate(Type, type);
                TbPurchaseLine.Validate("No.", resolvedNo);
            end else begin
                // BC requires No. for Item / G/L / FA lines. Free-text portal
                // requests (optional unknown codes) use Comment type so Description
                // / specification / estimate can still be saved for procurement.
                TbPurchaseLine.Validate(Type, TbPurchaseLine.Type::" ");
                Clear(TbPurchaseLine."No.");
            end;
            TbPurchaseLine."Shortcut Dimension 1 Code" := TbPurchaseHeader."Shortcut Dimension 1 Code";
            TbPurchaseLine."Shortcut Dimension 2 Code" := TbPurchaseHeader."Shortcut Dimension 2 Code";
            TbPurchaseLine."Location Code" := location;
            TbPurchaseLine.Quantity := quantity;
            TbPurchaseLine."Request Summary" := CopyStr(effectiveSpecification, 1, MaxStrLen(TbPurchaseLine."Request Summary"));
            // Comment (free-text) lines must not carry Direct Unit Cost — BC tax/VAT
            // calc then fails with "Tax Amount Line does not exist" on approval.
            if (resolvedNo <> '') and (estimatedUnitPrice > 0) then begin
                TbPurchaseLine."Direct Unit Cost" := estimatedUnitPrice;
                TbPurchaseLine.Validate("Direct Unit Cost");
            end;
            if category <> '' then
                TbPurchaseLine."Request Category" := CopyStr(category, 1, MaxStrLen(TbPurchaseLine."Request Category"));
            if requiredDate <> 0D then
                TbPurchaseLine."Expected Receipt Date" := requiredDate;
            if preferredBrandModel <> '' then begin
                TbPurchaseLine."Preferred Brand Model" := preferredBrandModel;
                TbPurchaseLine."RFQ Remarks" := CopyStr(preferredBrandModel, 1, MaxStrLen(TbPurchaseLine."RFQ Remarks"));
            end;
            if suggestedSupplier <> '' then
                TbPurchaseLine."Suggested Supplier" := suggestedSupplier;
            TbPurchaseLine."Extended Description" := CopyStr(remarks, 1, MaxStrLen(TbPurchaseLine."Extended Description"));
            TbPurchaseLine.Description := CopyStr(effectiveDescription, 1, MaxStrLen(TbPurchaseLine.Description));
            TbPurchaseLine."Portal Line Description" := CopyStr(reasonForRequest, 1, MaxStrLen(TbPurchaseLine."Portal Line Description"));
            TbPurchaseLine."Portal Estimated Unit Price" := estimatedUnitPrice;
            TbPurchaseLine."Portal Remarks" := CopyStr(remarks, 1, MaxStrLen(TbPurchaseLine."Portal Remarks"));
            // Preserve portal Type/Code/UOM for Comment (free-text) lines — BC Type is blank.
            TbPurchaseLine."Portal Line Type" := type;
            if itemNo <> '' then
                TbPurchaseLine."Portal Item Code" := CopyStr(itemNo, 1, MaxStrLen(TbPurchaseLine."Portal Item Code"))
            else
                if resolvedNo <> '' then
                    TbPurchaseLine."Portal Item Code" := CopyStr(resolvedNo, 1, MaxStrLen(TbPurchaseLine."Portal Item Code"));
            if unitOfMeasure <> '' then
                TbPurchaseLine."Unit of Measure Code" := unitOfMeasure;
            TbPurchaseLine.Validate(Quantity);
            if unitOfMeasure <> '' then
                TbPurchaseLine."Unit of Measure Code" := unitOfMeasure;
            TbPurchaseLine.Insert(true);
            // Re-stamp requestor text / portal display fields after insert triggers.
            TbPurchaseLine.Description := CopyStr(effectiveDescription, 1, MaxStrLen(TbPurchaseLine.Description));
            TbPurchaseLine."Portal Line Description" := CopyStr(reasonForRequest, 1, MaxStrLen(TbPurchaseLine."Portal Line Description"));
            TbPurchaseLine."Portal Estimated Unit Price" := estimatedUnitPrice;
            TbPurchaseLine."Portal Remarks" := CopyStr(remarks, 1, MaxStrLen(TbPurchaseLine."Portal Remarks"));
            if effectiveSpecification <> '' then
                TbPurchaseLine."Request Summary" := CopyStr(effectiveSpecification, 1, MaxStrLen(TbPurchaseLine."Request Summary"));
            if preferredBrandModel <> '' then begin
                TbPurchaseLine."Preferred Brand Model" := preferredBrandModel;
                TbPurchaseLine."RFQ Remarks" := CopyStr(preferredBrandModel, 1, MaxStrLen(TbPurchaseLine."RFQ Remarks"));
            end;
            if suggestedSupplier <> '' then
                TbPurchaseLine."Suggested Supplier" := suggestedSupplier;
            TbPurchaseLine."Extended Description" := CopyStr(remarks, 1, MaxStrLen(TbPurchaseLine."Extended Description"));
            TbPurchaseLine."Portal Line Type" := type;
            if itemNo <> '' then
                TbPurchaseLine."Portal Item Code" := CopyStr(itemNo, 1, MaxStrLen(TbPurchaseLine."Portal Item Code"))
            else
                if resolvedNo <> '' then
                    TbPurchaseLine."Portal Item Code" := CopyStr(resolvedNo, 1, MaxStrLen(TbPurchaseLine."Portal Item Code"));
            if unitOfMeasure <> '' then
                TbPurchaseLine."Unit of Measure Code" := unitOfMeasure;
            TbPurchaseLine.Modify(true);
            return_value := true;
        end else begin
            TbPurchaseLine.SetRange("Document No.", reqNo);
            TbPurchaseLine.SetRange("Line No.", lineNo);
            if TbPurchaseLine.FindFirst() then begin
                if not TbPurchaseHeader.Get(TbPurchaseLine."Document Type", reqNo) then
                    Error('Purchase requisition %1 was not found.', reqNo);
                if resolvedNo <> '' then begin
                    TbPurchaseLine.Validate(Type, type);
                    TbPurchaseLine.Validate("No.", resolvedNo);
                end else begin
                    TbPurchaseLine.Validate(Type, TbPurchaseLine.Type::" ");
                    Clear(TbPurchaseLine."No.");
                end;
                TbPurchaseLine."Shortcut Dimension 1 Code" := TbPurchaseHeader."Shortcut Dimension 1 Code";
                TbPurchaseLine."Shortcut Dimension 2 Code" := TbPurchaseHeader."Shortcut Dimension 2 Code";
                TbPurchaseLine."Location Code" := location;
                TbPurchaseLine.Quantity := quantity;
                TbPurchaseLine."Request Summary" := CopyStr(effectiveSpecification, 1, MaxStrLen(TbPurchaseLine."Request Summary"));
                if (resolvedNo <> '') and (estimatedUnitPrice > 0) then begin
                    TbPurchaseLine."Direct Unit Cost" := estimatedUnitPrice;
                    TbPurchaseLine.Validate("Direct Unit Cost");
                end else
                    if resolvedNo = '' then begin
                        TbPurchaseLine."Direct Unit Cost" := 0;
                        TbPurchaseLine.Amount := 0;
                        TbPurchaseLine."Amount Including VAT" := 0;
                        TbPurchaseLine."Line Amount" := 0;
                    end;
                if category <> '' then
                    TbPurchaseLine."Request Category" := CopyStr(category, 1, MaxStrLen(TbPurchaseLine."Request Category"));
                if requiredDate <> 0D then
                    TbPurchaseLine."Expected Receipt Date" := requiredDate;
                if preferredBrandModel <> '' then begin
                    TbPurchaseLine."Preferred Brand Model" := preferredBrandModel;
                    TbPurchaseLine."RFQ Remarks" := CopyStr(preferredBrandModel, 1, MaxStrLen(TbPurchaseLine."RFQ Remarks"));
                end;
                if suggestedSupplier <> '' then
                    TbPurchaseLine."Suggested Supplier" := suggestedSupplier;
                TbPurchaseLine."Extended Description" := CopyStr(remarks, 1, MaxStrLen(TbPurchaseLine."Extended Description"));
                TbPurchaseLine.Description := CopyStr(effectiveDescription, 1, MaxStrLen(TbPurchaseLine.Description));
                TbPurchaseLine."Portal Line Description" := CopyStr(reasonForRequest, 1, MaxStrLen(TbPurchaseLine."Portal Line Description"));
                TbPurchaseLine."Portal Estimated Unit Price" := estimatedUnitPrice;
                TbPurchaseLine."Portal Remarks" := CopyStr(remarks, 1, MaxStrLen(TbPurchaseLine."Portal Remarks"));
                TbPurchaseLine."Portal Line Type" := type;
                if itemNo <> '' then
                    TbPurchaseLine."Portal Item Code" := CopyStr(itemNo, 1, MaxStrLen(TbPurchaseLine."Portal Item Code"))
                else
                    if resolvedNo <> '' then
                        TbPurchaseLine."Portal Item Code" := CopyStr(resolvedNo, 1, MaxStrLen(TbPurchaseLine."Portal Item Code"))
                    else
                        Clear(TbPurchaseLine."Portal Item Code");
                if unitOfMeasure <> '' then
                    TbPurchaseLine."Unit of Measure Code" := unitOfMeasure;
                TbPurchaseLine.Validate(Quantity);
                if unitOfMeasure <> '' then
                    TbPurchaseLine."Unit of Measure Code" := unitOfMeasure;
                TbPurchaseLine.Modify(true);
                return_value := true;
            end else begin
                Error('Requisition line is no longer editable or it does not exist.');
            end;
        end;
    end;

    procedure DeletePurchaseReqLine(lineNo: Integer; requisitionNo: Code[100]) return_value: Boolean
    begin
        return_value := false;
        TbPurchaseLine.Reset;
        TbPurchaseLine.SetRange("Document No.", requisitionNo);
        TbPurchaseLine.SetRange("Line No.", lineNo);
        if TbPurchaseLine.FindFirst() then begin
            TbPurchaseLine.Delete;
            return_value := true;
        end else begin
            Error('Requisition line cannot be deleted or was not found');
        end;
    end;

    procedure CancelPurchaseRequisition(employeeNo: Code[100]; requisitionNo: Code[100]; tableID: Integer) return_value: Boolean
    var
        blnparam: Boolean;
    begin
        return_value := false;
        TbPurchaseHeader.Reset;
        TbPurchaseHeader.SetRange("No.", requisitionNo);
        if TbPurchaseHeader.FindFirst() then begin
            // Purchase requisitions use Felix's custom requisition workflow event,
            // not the standard purchase-document approval event.
            VarVariant := TbPurchaseHeader;
            CuCustomApprovals.OnCancelDocApprovalRequest(VarVariant);
            return_value := true;
        end else begin
            Error('Requisition cannot be cancelled or was not found');
        end;
    end;

    local procedure NormalizePurchaseReqCommentLines(reqNo: Code[50])
    var
        PurchaseLine: Record "Purchase Line";
        PurchaseHeader: Record "Purchase Header";
        EstimateNote: Text[250];
    begin
        // Free-text Comment lines with Direct Unit Cost trip BC Tax Amount Line
        // Get during OnSendDocForApproval. Zero amounts; keep estimate in text.
        if not PurchaseHeader.Get(PurchaseHeader."Document Type"::Quote, reqNo) then
            exit;
        PurchaseLine.Reset();
        PurchaseLine.SetRange("Document Type", PurchaseHeader."Document Type");
        PurchaseLine.SetRange("Document No.", reqNo);
        PurchaseLine.SetRange(Type, PurchaseLine.Type::" ");
        if PurchaseLine.FindSet(true) then
            repeat
                if PurchaseLine."Direct Unit Cost" <> 0 then begin
                    EstimateNote :=
                        CopyStr(
                            StrSubstNo('Est. unit %1. %2', PurchaseLine."Direct Unit Cost", PurchaseLine."Extended Description"),
                            1,
                            MaxStrLen(PurchaseLine."Extended Description"));
                    PurchaseLine."Extended Description" := EstimateNote;
                    PurchaseLine."Direct Unit Cost" := 0;
                    PurchaseLine."Unit Cost (LCY)" := 0;
                    PurchaseLine.Amount := 0;
                    PurchaseLine."Amount Including VAT" := 0;
                    PurchaseLine."Line Amount" := 0;
                    PurchaseLine."VAT Base Amount" := 0;
                    PurchaseLine."VAT %" := 0;
                    Clear(PurchaseLine."Tax Area Code");
                    Clear(PurchaseLine."Tax Group Code");
                    PurchaseLine.Modify(true);
                end;
            until PurchaseLine.Next() = 0;
    end;

    procedure RequestPurchaseReqApproval(employeeNo: Code[100]; reqNo: Code[50]; tableID: Integer) return_value: Boolean
    var
        PurchaseAfterApproval: Record "Purchase Header";
        PurchaseRecRef: RecordRef;
        RecordIdToApprove: RecordId;
        HasApprovalEntry: Boolean;
        PurchaseDocumentType: Enum "Purchase Document Type";
        RequesterUserID: Code[50];
    begin
        return_value := false;
        if not IsPurchaseReqLinesExists(reqNo) then
            Error('You must add purchase requisition lines before sending the requisition for approval.');
        ValidatePurchaseReqLinesForApproval(reqNo);
        NormalizePurchaseReqCommentLines(reqNo);
        TbPurchaseHeader.Reset;
        TbPurchaseHeader.SetRange("Document Type", TbPurchaseHeader."Document Type"::Quote);
        TbPurchaseHeader.SetRange("No.", reqNo);
        if TbPurchaseHeader.FindFirst() then begin
            PurchaseDocumentType := TbPurchaseHeader."Document Type";

            // Repair old portal drafts whose assigned user is blank or the SOAP
            // service account, using the employee's User Setup mapping.
            if employeeNo <> '' then begin
                TbUserSetup.Reset();
                TbUserSetup.SetRange("Employee No.", employeeNo);
                if TbUserSetup.FindFirst() then begin
                    RequesterUserID := TbUserSetup."User ID";
                    if (RequesterUserID <> '') and (TbPurchaseHeader."Assigned User ID" <> RequesterUserID) then begin
                        TbPurchaseHeader.Validate("Assigned User ID", RequesterUserID);
                        TbPurchaseHeader.Modify(true);
                        Commit();
                    end;
                end;
            end;

            if TbPurchaseHeader.Justification = '' then
                Error('Purpose / Justification is required.');
            if TbPurchaseHeader."Requested Receipt Date" = 0D then
                Error('Required Date is required.');
            if (TbPurchaseHeader."Budget Type" = TbPurchaseHeader."Budget Type"::Project) and
               (TbPurchaseHeader."Project Code" = '')
            then
                Error('Project Name / Project Code is required when Budget Type is Project.');
            if TbPurchaseHeader.Department = '' then
                Error('Department is required.');
            if TbPurchaseHeader."Shortcut Dimension 1 Code" = '' then
                Error('Division (Shortcut Dimension 1) is required. Refresh the employee card dimensions before approval.');
            if TbPurchaseHeader."Shortcut Dimension 2 Code" = '' then
                Error('Department (Shortcut Dimension 2) is required. Refresh the employee card dimensions before approval.');
            if TbPurchaseHeader.Department <> TbPurchaseHeader."Shortcut Dimension 2 Code" then
                Error(
                    'Department %1 does not match Shortcut Dimension 2 %2. Refresh the employee card dimensions before approval.',
                    TbPurchaseHeader.Department,
                    TbPurchaseHeader."Shortcut Dimension 2 Code");
            if RequesterUserID = '' then
                RequesterUserID := TbPurchaseHeader."Assigned User ID";
            // Same as Leave: first approver comes from Employee Card Supervisor → User Setup Approver ID.
            EnsurePurchaseApproverFromSupervisor(employeeNo, RequesterUserID);
            if RequesterUserID <> '' then
                if TbUserSetup.Get(RequesterUserID) then
                    if TbUserSetup."Approver ID" = '' then
                        Error(
                            'Approval User Setup for %1 has no Approver ID. Purchase requisition uses the same chain as Leave: Supervisor (Employee Card Supervisor No.) → Department Head → Division Head → Finance & Administration. Set Approver ID from the supervisor''s Employee User ID, and create department Purchase Approval workflows like Leave Approval-IT / Leave Approval-FINANCE.',
                            RequesterUserID);

            VarVariant := TbPurchaseHeader;
            if not CuCustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) then
                Error('Business Central approval workflow is not configured for purchase requisition %1.', reqNo);

            CuCustomApprovals.OnSendDocForApproval(VarVariant);
            Commit();

            if not PurchaseAfterApproval.Get(PurchaseDocumentType, reqNo) then
                Error('Purchase requisition %1 was not found after requesting approval.', reqNo);

            PurchaseRecRef.GetTable(PurchaseAfterApproval);
            RecordIdToApprove := PurchaseRecRef.RecordId;
            TbApprovalEntry.Reset();
            TbApprovalEntry.SetRange("Record ID to Approve", RecordIdToApprove);
            TbApprovalEntry.SetRange("Table ID", Database::"Purchase Header");
            TbApprovalEntry.SetFilter(Status, '%1|%2', TbApprovalEntry.Status::Open, TbApprovalEntry.Status::Created);
            HasApprovalEntry := not TbApprovalEntry.IsEmpty;

            if (PurchaseAfterApproval.Status <> PurchaseAfterApproval.Status::"Pending Approval") and HasApprovalEntry then begin
                PurchaseAfterApproval.Validate(Status, PurchaseAfterApproval.Status::"Pending Approval");
                PurchaseAfterApproval.Modify(true);
                Commit();
            end;

            if PurchaseAfterApproval.Get(PurchaseDocumentType, reqNo) then
                return_value := (PurchaseAfterApproval.Status = PurchaseAfterApproval.Status::"Pending Approval") and HasApprovalEntry;

            if not return_value then
                Error(
                    'Business Central did not create approval entries for purchase requisition %1. Enable Purchase Requisition workflows the same way as Leave (for example Purchase Approval-IT, Purchase Approval-FINANCE per department), and confirm Approval User Setup Approver ID matches Employee Card Supervisor.',
                    reqNo);
        end else begin
            Error('Requisition is no longer editable or it does not exist.');
        end;
    end;

    local procedure ValidatePurchaseReqLinesForApproval(reqNo: Code[50])
    var
        PurchaseLine: Record "Purchase Line";
    begin
        PurchaseLine.Reset();
        PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Quote);
        PurchaseLine.SetRange("Document No.", reqNo);
        if not PurchaseLine.FindSet() then
            Error('You must add purchase requisition lines before sending the requisition for approval.');

        repeat
            if PurchaseLine.Quantity <= 0 then
                Error('Purchase line %1 must have a quantity greater than zero.', PurchaseLine."Line No.");
            if DelChr(PurchaseLine.Description, '=', ' ') = '' then
                Error('Item / service name is required on purchase line %1.', PurchaseLine."Line No.");
            if DelChr(PurchaseLine."Portal Line Description", '=', ' ') = '' then
                Error('Description is required on purchase line %1.', PurchaseLine."Line No.");
            if DelChr(PurchaseLine."Request Summary", '=', ' ') = '' then
                Error('Specification is required on purchase line %1.', PurchaseLine."Line No.");
            if PurchaseLine."Unit of Measure Code" = '' then
                Error('Unit of Measure is required on purchase line %1.', PurchaseLine."Line No.");
            if DelChr(PurchaseLine."Request Category", '=', ' ') = '' then
                Error('Category is required on purchase line %1.', PurchaseLine."Line No.");
        until PurchaseLine.Next() = 0;
    end;

    local procedure EnsurePurchaseApproverFromSupervisor(employeeNo: Code[100]; requesterUserID: Code[50])
    var
        Requester: Record "HR-Employee";
        Supervisor: Record "HR-Employee";
        UserSetupRec: Record "User Setup";
        SupervisorSetup: Record "User Setup";
        SupervisorUserID: Code[50];
    begin
        if requesterUserID = '' then
            exit;
        if not UserSetupRec.Get(requesterUserID) then
            exit;
        if UserSetupRec."Approver ID" <> '' then
            exit;

        // Mirror Leave: first approver is Employee Card Supervisor No. → that person's User ID.
        if employeeNo <> '' then
            if Requester.Get(employeeNo) then begin
                SupervisorUserID := CopyStr(Requester."Supervisor User ID", 1, MaxStrLen(SupervisorUserID));
                if (SupervisorUserID = '') and (Requester."Supervisor No." <> '') then
                    if Supervisor.Get(Requester."Supervisor No.") then
                        SupervisorUserID := CopyStr(Supervisor."User ID", 1, MaxStrLen(SupervisorUserID));
            end;

        if SupervisorUserID = '' then
            Error(
                'Employee %1 has no Supervisor set. Purchase requisition uses the same first approver as Leave — set Supervisor No. (and Employee User ID on the supervisor) on the Employee Card, or set Approver ID in User Setup.',
                employeeNo);

        if not SupervisorSetup.Get(SupervisorUserID) then
            Error(
                'Supervisor user %1 is not in User Setup. Add the supervisor to User Setup so Purchase / Leave approval can route like Leave.',
                SupervisorUserID);

        UserSetupRec."Approver ID" := SupervisorUserID;
        UserSetupRec.Modify(true);
        Commit();
    end;

    procedure IsPurchaseReqLinesExists(reqNo: Code[100]) hasLines: Boolean
    begin
        hasLines := false;
        TbPurchaseLine.Reset;
        TbPurchaseLine.SetRange(TbPurchaseLine."Document Type", TbPurchaseLine."Document Type"::Quote);
        TbPurchaseLine.SetRange(TbPurchaseLine."Document No.", reqNo);
        if TbPurchaseLine.FindFirst() then begin
            hasLines := true;
        end;
    end;

    procedure TransportRequisition(employeeNo: Code[100]; purpose: Text[250]; responsibilityCenter: Code[100]; "action": Text; reqNo: Code[50]; destination: Text; commenceFrom: Text[200]; dateOfTrip: Date; noOfDays: Integer; noOfPassengers: Integer; requestType: Integer; travelType: Integer; noSeries: Code[50]) return_value: Boolean
    var
        supervisorId: Text;
        FLTTransportRequisition: Record "FLT-Transport Requisition";
    begin
        return_value := FALSE;
        FLTTransportRequisition.RESET;
        IF action = 'create' THEN BEGIN
            FLTTransportRequisition.INIT;
            NextNo := CuNoSeriesMgt.GetNextNo(noSeries, 0D, TRUE);
            TbEmployee.RESET;
            TbEmployee.SETRANGE(TbEmployee."No.", employeeNo);

            IF TbEmployee.FINDFIRST THEN BEGIN
                FLTTransportRequisition."Requested By" := TbEmployee."User ID";
                FLTTransportRequisition.Department := TbEmployee."Department Code";
                FLTTransportRequisition.Name := TbEmployee."Full Name";
                TbUserSetup.RESET;
                TbUserSetup.SETRANGE(TbUserSetup."User ID", TbEmployee."User ID");
                IF TbUserSetup.FINDFIRST THEN BEGIN
                    supervisorId := TbUserSetup."Approver ID";
                END;
            END;
            FLTTransportRequisition."Transport Requisition No" := NextNo;
            FLTTransportRequisition.Commencement := commenceFrom;
            FLTTransportRequisition.Destination := destination;
            FLTTransportRequisition."Date of Request" := TODAY;
            FLTTransportRequisition."Time Requested" := TIME;
            FLTTransportRequisition."Date of Trip" := dateOfTrip;
            FLTTransportRequisition."Purpose of Trip" := purpose;
            FLTTransportRequisition."No. Series" := noSeries;
            FLTTransportRequisition."Responsibility Center" := responsibilityCenter;
            FLTTransportRequisition."No of Days Requested" := noOfDays;
            FLTTransportRequisition."No Of Passangers" := noOfPassengers;
            FLTTransportRequisition."Vehicle Type" := requestType;
            FLTTransportRequisition.INSERT;
            return_value := TRUE;
        END ELSE BEGIN
            FLTTransportRequisition.RESET;
            FLTTransportRequisition.SETRANGE("Transport Requisition No", reqNo);
            FLTTransportRequisition.SETRANGE(Status, FLTTransportRequisition.Status::Open);
            IF FLTTransportRequisition.FINDFIRST() THEN BEGIN
                FLTTransportRequisition.Commencement := commenceFrom;
                FLTTransportRequisition.Destination := destination;
                FLTTransportRequisition."Date of Request" := TODAY;
                FLTTransportRequisition."Time Requested" := TIME;
                FLTTransportRequisition."Date of Trip" := dateOfTrip;
                FLTTransportRequisition."Vehicle Type" := requestType;
                FLTTransportRequisition."Purpose of Trip" := purpose;
                FLTTransportRequisition."No. Series" := noSeries;
                FLTTransportRequisition."Responsibility Center" := responsibilityCenter;
                FLTTransportRequisition."No of Days Requested" := noOfDays;
                FLTTransportRequisition."No Of Passangers" := noOfPassengers;
                FLTTransportRequisition.MODIFY();
                return_value := TRUE;
            END ELSE BEGIN
                ERROR('Requisition is no longer editable or it does not exist.');
            END;
        END;

    end;

    procedure TransportRequisitionPassenger(myAction: Text; recId: Text; transportNo: Code[30]; passengerType: Text; employeeNo: Code[30]; externalPassName: Text; externalPassOrganization: Text) return_value: Boolean
    var
        FLTExternalPassengers: Record "FLT-External Passengers";
        FLTTravelRequisitionStaff: Record "FLT-Travel Requisition Staff";
    begin
        case myAction of
            'create':
                begin
                    if passengerType = 'Staff' then begin
                        // Save Employee Passenger
                        FLTTravelRequisitionStaff.Init();
                        FLTTravelRequisitionStaff.No := employeeNo;
                        FLTTravelRequisitionStaff.Validate(No);
                        FLTTravelRequisitionStaff."Req No" := transportNo;
                        if FLTTravelRequisitionStaff.insert(true) then
                            return_value := true;
                    end else begin
                        // Save External Passenger
                        FLTExternalPassengers.Init();
                        FLTExternalPassengers."Transport No." := transportNo;
                        FLTExternalPassengers."Passenger Names" := externalPassName;
                        FLTExternalPassengers."Passenger Organization" := ExternalPassOrganization;
                        if FLTExternalPassengers.Insert(true) then
                            return_value := true;
                    end;
                end;
            'delete':
                begin
                    if passengerType = 'Staff' then begin
                        // delete from Employee Staff pass
                        FLTTravelRequisitionStaff.Reset();
                        FLTTravelRequisitionStaff.SetRange(SystemId, recId);
                        if FLTTravelRequisitionStaff.FindFirst() then begin
                            FLTTravelRequisitionStaff.Delete();
                            return_value := true;
                        end;
                    end else begin
                        // delete from Externall  pass
                        FLTExternalPassengers.Reset();
                        FLTExternalPassengers.SetRange(SystemId, recId);
                        if FLTExternalPassengers.FindFirst() then begin
                            FLTExternalPassengers.Delete();
                            return_value := true;
                        end;
                    end;
                end;

        end;
    end;

    procedure CancelTransportRequisition(employeeNo: Code[100]; requisitionNo: Code[100]; tableID: Integer) return_value: Boolean
    var
        blnparam: Boolean;
    begin
        return_value := FALSE;
        TbTransportRequisition.RESET;
        TbTransportRequisition.SETRANGE("Transport Requisition No", requisitionNo);
        //TbTransportRequisition.SETRANGE("Requested By",employeeNo);
        IF TbTransportRequisition.FINDFIRST() THEN BEGIN
            VarVariant := TbTransportRequisition;
            IF CuCustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) THEN BEGIN
                CuCustomApprovals.OnCancelDocApprovalRequest(VarVariant);
                return_value := TRUE;
            END;
        END ELSE BEGIN
            ERROR('Requisition cannot be cancelled or was not found');
        END;

    end;

    procedure RequestTransportReqApproval(employeeNo: Code[100]; reqNo: Code[50]; tableID: Integer) return_value: Boolean
    begin
        return_value := FALSE;
        TbTransportRequisition.RESET;
        TbTransportRequisition.SETRANGE("Transport Requisition No", reqNo);
        IF TbTransportRequisition.FINDFIRST() THEN BEGIN

            VarVariant := TbTransportRequisition;
            if CuCustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) then begin
                CuCustomApprovals.OnSendDocForApproval(VarVariant);
                return_value := TRUE;
            end;
        END ELSE BEGIN
            ERROR('Requisition is no longer editable or it does not exist.');
        END;

    end;

    local procedure BindPortalAttachmentSource(docNo: Code[100]; tableID: Integer; var FromRecRef: RecordRef): Boolean
    var
        HrPolicyDocument: Record "Hr Document Downloads";
    begin
        case tableID of
            50885:
                begin
                    TbStaffClaimHeader.Reset;
                    TbStaffClaimHeader.SetRange("No.", docNo);
                    if not TbStaffClaimHeader.FindFirst() then
                        exit(false);
                    FromRecRef.GetTable(TbStaffClaimHeader);
                    exit(true);
                end;
            50532:
                begin
                    HRLeaveApplication.Reset;
                    HRLeaveApplication.SetRange("Application Code", docNo);
                    if not HRLeaveApplication.FindFirst() then
                        exit(false);
                    FromRecRef.GetTable(HRLeaveApplication);
                    exit(true);
                end;
            50891:
                begin
                    TbImprestRequisitionHeader.Reset;
                    TbImprestRequisitionHeader.SetRange("No.", docNo);
                    if not TbImprestRequisitionHeader.FindFirst() then
                        exit(false);
                    FromRecRef.GetTable(TbImprestRequisitionHeader);
                    exit(true);
                end;
            50884:
                begin
                    TbImprestSurrenderHeader.Reset;
                    TbImprestSurrenderHeader.SetRange(No, docNo);
                    if not TbImprestSurrenderHeader.FindFirst() then
                        exit(false);
                    FromRecRef.GetTable(TbImprestSurrenderHeader);
                    exit(true);
                end;
            50887:
                begin
                    PettyCashHeaderTbl.Reset;
                    PettyCashHeaderTbl.SetRange("No.", docNo);
                    if not PettyCashHeaderTbl.FindFirst() then
                        exit(false);
                    FromRecRef.GetTable(PettyCashHeaderTbl);
                    exit(true);
                end;
            50575:
                begin
                    TbStoreRequisition.Reset;
                    TbStoreRequisition.SetRange("No.", docNo);
                    if not TbStoreRequisition.FindFirst() then
                        exit(false);
                    FromRecRef.GetTable(TbStoreRequisition);
                    exit(true);
                end;
            38, 52121800:
                begin
                    TbPurchaseHeader.Reset;
                    TbPurchaseHeader.SetRange("No.", docNo);
                    TbPurchaseHeader.SetRange("Document Type", TbPurchaseHeader."Document Type"::Quote);
                    if not TbPurchaseHeader.FindFirst() then begin
                        TbPurchaseHeader.Reset;
                        TbPurchaseHeader.SetRange("No.", docNo);
                        if not TbPurchaseHeader.FindFirst() then
                            exit(false);
                    end;
                    FromRecRef.GetTable(TbPurchaseHeader);
                    exit(true);
                end;
            Database::"Hr Document Downloads":
                begin
                    HrPolicyDocument.Reset();
                    HrPolicyDocument.SetRange("Document No", docNo);
                    if not HrPolicyDocument.FindFirst() then
                        exit(false);
                    FromRecRef.GetTable(HrPolicyDocument);
                    exit(true);
                end;
        end;
        exit(false);
    end;

    procedure UploadDocumentAttachment(docNo: Code[100]; docNo2: Code[100]; fileName: Text[250]; file: BigText; tableID: Integer; description: Text[250]) return_value: Boolean
    var
        FromRecRef: RecordRef;
        CuFileManagement: Codeunit "File Management";
        Bytes: dotnet Array;
        Convert: dotnet Convert;
        MemoryStream: dotnet MemoryStream;
    begin
        return_value := false;
        if fileName = '' then
            Error('File name cannot be blank');
        if not BindPortalAttachmentSource(docNo, tableID, FromRecRef) then
            Error('Related table or record for attached file was not found');

        Clear(TbDocumentAttachment);
        TbDocumentAttachment.Init();
        TbDocumentAttachment.Validate("File Extension", CuFileManagement.GetExtension(fileName));
        TbDocumentAttachment.Validate("File Name", CopyStr(CuFileManagement.GetFileNameWithoutExtension(fileName), 1, MaxStrLen(fileName)));
        TbDocumentAttachment.Validate("Table ID", FromRecRef.Number);
        TbDocumentAttachment.Validate("No.", docNo);
        if description <> '' then
            TbDocumentAttachment."Document Description" := CopyStr(description, 1, MaxStrLen(TbDocumentAttachment."Document Description"));
        if FromRecRef.Number = Database::"Purchase Header" then
            TbDocumentAttachment."Document Type" := TbPurchaseHeader."Document Type";
        Bytes := Convert.FromBase64String(file);
        MemoryStream := MemoryStream.MemoryStream(Bytes);
        TbDocumentAttachment."Document Reference ID".ImportStream(MemoryStream, '', fileName);
        TbDocumentAttachment.Insert(true);
        return_value := true;
        if CuFileManagement.DeleteServerFile(fileName) then;
    end;

    procedure DeleteDocumentAttachment(docNo: Code[100]; docID: Integer) return_value: Boolean
    var
        FromRecRef: RecordRef;
        CuFileManagement: Codeunit "File Management";
        Bytes: dotnet Array;
        Convert: dotnet Convert;
        MemoryStream: dotnet MemoryStream;
        Ostream: OutStream;
        isTableFound: Boolean;
        RecordRef1: RecordRef;
        RecordRef2: RecordRef;
        RecordID: RecordID;
        FieldRef: FieldRef;
    begin
        return_value := false;
        TbDocumentAttachment.Reset();
        // TbDocumentAttachment.SetRange("Table ID", tableID);
        TbDocumentAttachment.SetRange("No.", docNo);
        TbDocumentAttachment.SetRange(ID, docID);
        if TbDocumentAttachment.FindFirst() then begin
            if TbDocumentAttachment."Document Reference ID".Hasvalue then begin
                Clear(TbDocumentAttachment."Document Reference ID");
                TbDocumentAttachment.Modify(true);
            end;
            TbDocumentAttachment.Delete(true);
            return_value := true;
        end;
    end;

    procedure CreateHrPolicyDocument(description: Text[150]; category: Text[50]; publish: Boolean; fileName: Text[250]; file: BigText) return_value: Text[30]
    var
        HrPolicyDocument: Record "Hr Document Downloads";
    begin
        if description = '' then
            Error('Document title cannot be blank.');
        if fileName = '' then
            Error('Document file name cannot be blank.');

        HrPolicyDocument.Init();
        case LowerCase(category) of
            'contract':
                HrPolicyDocument."Document Category" := HrPolicyDocument."Document Category"::Contract;
            'pin':
                HrPolicyDocument."Document Category" := HrPolicyDocument."Document Category"::PIN;
            'exit form':
                HrPolicyDocument."Document Category" := HrPolicyDocument."Document Category"::"Exit Form";
            else
                HrPolicyDocument."Document Category" := HrPolicyDocument."Document Category"::"Policy Document";
        end;
        HrPolicyDocument."Document Description" := description;
        HrPolicyDocument.Publish := publish;
        HrPolicyDocument.Insert(true);

        if not UploadDocumentAttachment(
            HrPolicyDocument."Document No",
            HrPolicyDocument."Document No",
            fileName,
            file,
            Database::"Hr Document Downloads",
            description)
        then
            Error('The HR document attachment could not be stored.');

        return_value := HrPolicyDocument."Document No";
    end;

    procedure DeleteHrPolicyDocument(docNo: Code[30]) return_value: Boolean
    var
        HrPolicyDocument: Record "Hr Document Downloads";
        PolicyAttachment: Record "Document Attachment";
    begin
        return_value := false;
        if not HrPolicyDocument.Get(docNo) then
            exit(false);

        PolicyAttachment.Reset();
        PolicyAttachment.SetRange("Table ID", Database::"Hr Document Downloads");
        PolicyAttachment.SetRange("No.", docNo);
        if not PolicyAttachment.IsEmpty() then
            PolicyAttachment.DeleteAll(true);

        HrPolicyDocument.Delete(true);
        return_value := true;
    end;

    procedure GetStaffName(staffNo: Code[100]) name: Text[250]
    begin
        TbEmployee.Reset;
        TbEmployee.SetRange(TbEmployee."No.", staffNo);

        if TbEmployee.FindFirst then begin
            name := TbEmployee."First Name" + ' ' + TbEmployee."Middle Name" + ' ' + TbEmployee."Last Name";
        end;
    end;

    procedure UpdatePassword(staffNo: Code[50]; password: Text[200]) inserted: Boolean
    begin
        inserted := false;
        TbEmployee.Reset;
        TbEmployee.SetRange(TbEmployee."No.", staffNo);
        if TbEmployee.FindFirst then begin
            TbEmployee."Portal Password" := password;
            TbEmployee."Token Expired?" := true;
            TbEmployee."Changed Password" := true;
            TbEmployee.Modify;
            inserted := true;
        end;
    end;

    procedure UpdatePasswordToken(password_token: Code[20]; staffNo: Code[50]) updated: Boolean
    begin
        updated := false;
        TbEmployee.Reset;
        TbEmployee.SetRange("No.", staffNo);
        if TbEmployee.FindFirst then begin
            TbEmployee."Reset Token" := password_token;
            TbEmployee."Token Expired?" := false;
            TbEmployee.Modify;
            updated := true;
        end;
    end;

    procedure SendEmail(receiver: Text[250]; subject: Text[50]; message: Text[1000]) returnValue: Boolean
    var
        CuEmail: Codeunit Email;
        CuEmailMessage: Codeunit "Email Message";
        BCcRecipients: List of [Text];
        CcRecipients2: List of [Text];
        EmailRecipients: List of [Text];
    begin
        returnValue := FALSE;
        EmailRecipients := receiver.Split(';');
        CuEmailMessage.Create(EmailRecipients, subject, message, true);
        CuEmail.Send(CuEmailMessage, Enum::"Email Scenario"::Default);
        returnValue := true;
    end;

    procedure RequestDocumentApproval(docNo: Code[100]; docNoFieldId: Integer; tableID: Integer) return_value: Boolean
    var
        FromRecRef: RecordRef;
        RecordRef1: RecordRef;
        RecordRef2: RecordRef;
        RecordID: RecordID;
        FieldRef: FieldRef;
    begin
        return_value := false;
        /*RecordRef1.OPEN(tableID);
        FieldRef := RecordRef1.FIELD(docNoFieldId);
        FieldRef.VALUE := docNo;
        IF RecordRef1.FIND('=') THEN BEGIN
          RecordRef2:=RecordRef1;
          VarVariant := RecordRef2;
          IF CuCustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) THEN
              CuCustomApprovals.OnSendDocForApproval(VarVariant);
        END ELSE BEGIN
          ERROR('Related table or record was not found');
        END;*/

    end;

    procedure GenerateLeaveStatement(employeeNo: Code[100]; filenameFromApp: Text[200]; leaveType: Code[50]) return_value: Text
    var
        HRLeaveAllocation: Record "HR Leave Allocation";
        MyRecordRef: RecordRef;
        TbTempBlob: Codeunit "Temp Blob";
        Base64Convert: Codeunit "Base64 Convert";
        MyOutstream: OutStream;
        MyInstream: InStream;
    begin
        return_value := '';
        TbGeneralSetup.Get;
        TbGeneralSetup.TestField("Portal Reports File Path");
        FILESPATH := TbGeneralSetup."Portal Reports File Path";
        filename := FILESPATH + filenameFromApp;

        HRLeaveAllocation.Reset();
        HRLeaveAllocation.SetRange("No.", employeeNo);
        HRLeaveAllocation.SetRange("Leave Type", leaveType);
        if not HRLeaveAllocation.FindFirst() then
            Error('No data found');

        MyRecordRef.GetTable(HRLeaveAllocation);

        TbTempBlob.CreateOutStream(MyOutstream);
        RpLeaveStatement.SetTableView(HRLeaveAllocation); // Assuming RpLeaveStatement is your report var
        RpLeaveStatement.SaveAs('', ReportFormat::Pdf, MyOutstream, MyRecordRef);

        if not TbTempBlob.HasValue() then
            Error('Failed to generate PDF');

        TbTempBlob.CreateInStream(MyInstream);
        return_value := Base64Convert.ToBase64(MyInstream);
    end;

    procedure ClaimRequisitionHeader(myUserID: Code[30]; "action": Text; reqNo: Code[50]; staffNo: Code[30]; claimDescription: Text; claimDate: Date; department: Code[20]) return_value: Code[50]
    var
        custNo: Code[50];
    begin
        return_value := '';
        TbStaffClaimHeader.Reset;
        if action = 'create' then begin
            TbCashOfficeSetup.Get;
            TbCashOfficeSetup.TestField("Staff Claim No");
            NextNo := CuNoSeriesMgt.GetNextNo(TbCashOfficeSetup."Staff Claim No", 0D, true);
            //
            TbStaffClaimHeader.Init;
            TbStaffClaimHeader."No." := NextNo;
            TbStaffClaimHeader.Cashier := myUserID;
            TbStaffClaimHeader."Employee No" := staffNo;
            TbStaffClaimHeader.Validate("Employee No");
            // Resolve the claim account from the actual employee first. The
            // portal SOAP service user can be different from the requester and
            // must not leave the Customer/Imprest account blank.
            TbStaffClaimHeader."Account No." := GetUserCustomerNo(myUserID, staffNo);
            TbStaffClaimHeader."Account Type" := TbStaffClaimHeader."account type"::Customer;
            TbStaffClaimHeader.Validate("Account No.");
            TbStaffClaimHeader.Purpose := claimDescription;
            if claimDate <> 0D then
                TbStaffClaimHeader."Date" := claimDate;
            //
            TbEmployee.Reset;
            TbEmployee.SetRange("No.", staffNo);
            if TbEmployee.FindFirst then begin
                // TbEmployee.TestField("Global Dimension 1 Code");
                // TbEmployee.TestField("Global Dimension 2 Code");
                // TbEmployee.TestField("Responsibility Center");
                TbStaffClaimHeader."Global Dimension 1 Code" := TbEmployee."Global Dimension 1 Code";
                TbStaffClaimHeader."Shortcut Dimension 2 Code" := TbEmployee."Global Dimension 2 Code";
                TbStaffClaimHeader."Shortcut Dimension 3 Code" := TbEmployee."Global Dimension 3 Code";
                TbStaffClaimHeader."Responsibility Center" := TbEmployee."Responsibility Center";
            end;
            if department <> '' then
                TbStaffClaimHeader."Shortcut Dimension 2 Code" := department;
            TbStaffClaimHeader.Insert(true);
            return_value := NextNo;
        end else begin
            TbStaffClaimHeader.SetRange("No.", reqNo);
            TbStaffClaimHeader.SetRange("Employee No", staffNo);
            TbStaffClaimHeader.SetRange(Status, TbStaffClaimHeader.Status::Pending);
            if TbStaffClaimHeader.FindFirst() then begin
                TbStaffClaimHeader."Employee No" := staffNo;
                TbStaffClaimHeader.Validate("Employee No");
                TbStaffClaimHeader."Account No." := GetUserCustomerNo(myUserID, staffNo);
                TbStaffClaimHeader."Account Type" := TbStaffClaimHeader."account type"::Customer;
                TbStaffClaimHeader.Validate("Account No.");
                TbStaffClaimHeader.Purpose := claimDescription;
                if claimDate <> 0D then
                    TbStaffClaimHeader."Date" := claimDate;
                //
                TbEmployee.Reset;
                TbEmployee.SetRange("No.", staffNo);
                if TbEmployee.FindFirst then begin
                    // TbEmployee.TestField("Global Dimension 1 Code");
                    // TbEmployee.TestField("Global Dimension 2 Code");
                    // TbEmployee.TestField("Responsibility Center");
                    TbStaffClaimHeader."Global Dimension 1 Code" := TbEmployee."Global Dimension 1 Code";
                    TbStaffClaimHeader."Shortcut Dimension 2 Code" := TbEmployee."Global Dimension 2 Code";
                    TbStaffClaimHeader."Responsibility Center" := TbEmployee."Responsibility Center";
                end;
                if department <> '' then
                    TbStaffClaimHeader."Shortcut Dimension 2 Code" := department;
                TbStaffClaimHeader.Modify;
                return_value := reqNo;
            end else begin
                Error('Requisition is no longer editable or it does not exist.');
            end;
        end;
    end;

    procedure FetchMedicalClaimAmount(medicalAmount: Decimal; hospitalCategory: Integer) returnValue: Text
    var
        ResponseObj: JsonObject;
    begin
        TbStaffClaimLines.Init();
        TbStaffClaimLines."Medical Amount" := medicalAmount;
        TbStaffClaimLines."Hospital Category" := hospitalCategory;

        TbStaffClaimLines.Validate("Hospital Category");

        if TbStaffClaimLines."Amount to refund" = 0 then
            case hospitalCategory of
                0:
                    TbStaffClaimLines."Amount to refund" := medicalAmount;
                1:
                    TbStaffClaimLines."Amount to refund" := Round(medicalAmount * 0.6, 0.01, '=');
                2:
                    TbStaffClaimLines."Amount to refund" := Round(medicalAmount * 0.9, 0.01, '=');
            end;
        TbStaffClaimLines.Amount := TbStaffClaimLines."Amount to refund";

        ResponseObj.Add('Amount', TbStaffClaimLines.Amount);
        ResponseObj.Add('AmountToRefund', TbStaffClaimLines."Amount to refund");

        returnValue := Format(ResponseObj);
    end;

    // UAT 25/07/2026: employeeNo added because the portal has always sent it with the line.

    procedure ClaimRequisitionLine("action": Text; reqNo: Code[50]; lineNo: Integer; claimType: Code[30]; accountNo: Code[30]; amount: Decimal; medicalAmount: Decimal; claimReceiptNo: Code[20]; expenditureDate: Date; expenditureDescription: Text; hospitalCategory: Integer; patient: Integer; relationship: Integer; dependant: Code[100]) return_value: Integer
    begin
        return_value := 0;
        TbStaffClaimHeader.Reset;
        if action = 'create' then begin
            TbStaffClaimLines.Reset();
            TbStaffClaimLines.SetRange(No, reqNo);
            if TbStaffClaimLines.FindLast then
                lineNo := TbStaffClaimLines."Line No." + 1
            else
                lineNo := 1;

            TbStaffClaimLines.Reset;
            TbStaffClaimLines.Init;
            TbStaffClaimLines.No := reqNo;
            TbStaffClaimLines."Line No." := lineNo;
            TbStaffClaimLines."Advance Type" := claimType;
            if TbStaffClaimLines."Advance Type" = 'MEDICAL' then begin
                ApplyMedicalClaimLineDetails(TbStaffClaimLines, reqNo, hospitalCategory, patient, relationship, dependant);
                TbStaffClaimLines.Validate("Hospital Category");
            end;
            TbStaffClaimLines."Account No:" := accountNo;
            TbStaffClaimLines.Validate("Account No:");
            TbStaffClaimLines.Amount := amount;
            if TbStaffClaimLines."Advance Type" = 'MEDICAL' then
                TbStaffClaimLines.Validate("Medical Amount", medicalAmount)
            else
                TbStaffClaimLines."Medical Amount" := medicalAmount;
            TbStaffClaimLines."Claim Receipt No" := claimReceiptNo;
            TbStaffClaimLines."Expenditure Date" := expenditureDate;
            TbStaffClaimLines.Purpose := expenditureDescription;
            TbStaffClaimLines.Insert(true);
            return_value := lineNo;
        end else begin
            TbStaffClaimLines.SetRange(No, reqNo);
            TbStaffClaimLines.SetRange("Line No.", lineNo);
            if TbStaffClaimLines.FindFirst() then begin
                TbStaffClaimLines."Advance Type" := claimType;
                if TbStaffClaimLines."Advance Type" = 'MEDICAL' then begin
                    ApplyMedicalClaimLineDetails(TbStaffClaimLines, reqNo, hospitalCategory, patient, relationship, dependant);
                    TbStaffClaimLines.Validate("Hospital Category");
                    TbStaffClaimLines.Validate("Medical Amount", medicalAmount);
                end else
                    TbStaffClaimLines."Medical Amount" := medicalAmount;
                TbStaffClaimLines."Account No:" := accountNo;
                TbStaffClaimLines.Validate("Account No:");
                TbStaffClaimLines.Amount := amount;
                TbStaffClaimLines."Claim Receipt No" := claimReceiptNo;
                TbStaffClaimLines."Expenditure Date" := expenditureDate;
                TbStaffClaimLines.Purpose := expenditureDescription;
                TbStaffClaimLines.Modify;
                return_value := lineNo;
            end else begin
                Error('Requisition line is no longer editable or it does not exist.');
            end;
        end;
    end;

    local procedure ApplyMedicalClaimLineDetails(var ClaimLine: Record "Staff Claim Lines"; ReqNo: Code[50]; HospitalCategory: Integer; Patient: Integer; Relationship: Integer; Dependant: Code[100])
    begin
        ClaimLine.IsMedicalClaim := true;
        ClaimLine."Hospital Category" := HospitalCategory;
        TbStaffClaimHeader.Reset();
        TbStaffClaimHeader.SetRange("No.", ReqNo);
        if not TbStaffClaimHeader.FindFirst() then
            Error('Staff claim %1 was not found.', ReqNo);
        TbStaffClaimHeader.TestField("Employee No");
        ClaimLine."Staff No" := TbStaffClaimHeader."Employee No";

        if Patient = 2 then begin
            ClaimLine.Validate(Patient, ClaimLine.Patient::Dependant);
            if Relationship <> 0 then
                ClaimLine.Validate(Relationship, Relationship);
        end else
            ClaimLine.Validate(Patient, ClaimLine.Patient::Self);

        if Dependant <> '' then
            ClaimLine.Validate(Dependant, Dependant)
        else
            if Patient = 2 then
                ClaimLine.TestField(Dependant);
    end;

    procedure DeleteClaimLine(lineNo: Integer; requisitionNo: Code[100]) return_value: Boolean
    begin
        return_value := false;
        TbStaffClaimLines.Reset;
        TbStaffClaimLines.SetRange(No, requisitionNo);
        TbStaffClaimLines.SetRange("Line No.", lineNo);
        if TbStaffClaimLines.FindFirst() then begin
            TbStaffClaimLines.Delete;
            return_value := true;
        end else begin
            Error('Requisition line cannot be deleted or was not found');
        end;
    end;

    procedure CancelClaimRequisition(employeeNo: Code[100]; requisitionNo: Code[100]; tableID: Integer) return_value: Boolean
    begin
        return_value := false;
        TbStaffClaimHeader.Reset;
        TbStaffClaimHeader.SetRange("No.", requisitionNo);
        TbStaffClaimHeader.SetRange("Employee No", employeeNo);
        TbStaffClaimHeader.SetRange(Status, TbStaffClaimHeader.Status::"Pending Approval");
        if TbStaffClaimHeader.FindFirst() then begin
            VarVariant := TbStaffClaimHeader;
            CuCustomApprovals.OnCancelDocApprovalRequest(VarVariant);
            Commit();
            return_value := true;
        end else begin
            Error('Staff claim approval request cannot be cancelled because the claim was not found or is not pending approval.');
        end;
    end;

    procedure RequestClaimApproval(employeeNo: Code[100]; reqNo: Code[50]) return_value: Boolean
    var
        ClaimAfterApproval: Record "Staff Claims Header";
        ClaimRecRef: RecordRef;
        RecordIdToApprove: RecordId;
        WorkflowWasEnabled: Boolean;
        HasApprovalEntry: Boolean;
    begin
        return_value := false;
        if not IsClaimLinesExists(reqNo) then
            Error('You must add claim lines before sending a claim for approval.');
        if not HasPortalDocumentAttachment(Database::"Staff Claims Header", reqNo) then
            Error('Attach at least one supporting document before requesting approval for a claim.');
        TbStaffClaimHeader.Reset;
        TbStaffClaimHeader.SetRange("No.", reqNo);
        TbStaffClaimHeader.SetRange("Employee No", employeeNo);
        TbStaffClaimHeader.SetRange(Status, TbStaffClaimHeader.Status::Pending);
        if TbStaffClaimHeader.FindFirst() then begin
            VarVariant := TbStaffClaimHeader;

            WorkflowWasEnabled := CuCustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant);
            if not WorkflowWasEnabled then
                Error('Business Central approval workflow is not configured for staff claim %1.', reqNo);

            CuCustomApprovals.OnSendDocForApproval(VarVariant);

            Commit();

            if not ClaimAfterApproval.Get(reqNo) then
                Error('Staff claim %1 was not found after requesting approval.', reqNo);

            ClaimRecRef.GetTable(ClaimAfterApproval);
            RecordIdToApprove := ClaimRecRef.RecordId;

            if ClaimAfterApproval.Cashier <> '' then begin
                FnUpdateApprovalEntries(reqNo, ClaimAfterApproval.Cashier, RecordIdToApprove);
                Commit();
            end;

            TbApprovalEntry.Reset;
            TbApprovalEntry.SetRange("Record ID to Approve", RecordIdToApprove);
            TbApprovalEntry.SetRange("Table ID", Database::"Staff Claims Header");
            TbApprovalEntry.SetFilter(Status, '%1|%2', TbApprovalEntry.Status::Open, TbApprovalEntry.Status::Created);
            HasApprovalEntry := not TbApprovalEntry.IsEmpty;

            if (ClaimAfterApproval.Status <> ClaimAfterApproval.Status::"Pending Approval") and HasApprovalEntry then begin
                ClaimAfterApproval.Validate(Status, ClaimAfterApproval.Status::"Pending Approval");
                ClaimAfterApproval.Modify();
                Commit();
            end;

            if ClaimAfterApproval.Get(reqNo) then
                return_value := (ClaimAfterApproval.Status = ClaimAfterApproval.Status::"Pending Approval") and HasApprovalEntry;

            if not return_value then
                Error('Business Central did not create approval entries for staff claim %1. Enable the Staff Claim approval workflow and confirm Approval User Setup has an approver for %2.', reqNo, ClaimAfterApproval.Cashier);
        end else begin
            Error('Requisition is no longer editable or it does not exist.');
        end;
    end;

    procedure IsClaimLinesExists(reqNo: Code[100]) hasLines: Boolean
    begin
        hasLines := false;
        TbStaffClaimLines.Reset;
        TbStaffClaimLines.SetRange(TbStaffClaimLines.No, reqNo);
        if TbStaffClaimLines.FindFirst() then begin
            hasLines := true;
        end;
    end;

    local procedure GetUserCustomerNo(myUserID: Code[30]; employeeNo: Code[50]) customerNo: Code[50]
    begin
        customerNo := '';
        if employeeNo <> '' then begin
            TbUserSetup.Reset;
            TbUserSetup.SetRange("Employee No.", employeeNo);
            if TbUserSetup.FindFirst() then
                customerNo := TbUserSetup."Imprest Account";

            if customerNo = '' then begin
                TbEmployee.Reset;
                TbEmployee.SetRange("No.", employeeNo);
                if TbEmployee.FindFirst() then
                    customerNo := TbEmployee."Customer No";
            end;
        end;
        if (customerNo = '') and (myUserID <> '') then begin
            TbUserSetup.Reset;
            TbUserSetup.SetRange("User ID", myUserID);
            if TbUserSetup.FindFirst() then
                customerNo := TbUserSetup."Imprest Account";
        end;
    end;

    procedure GetDocumentAttachment(docNo: Code[100]; attachmentID: Integer; tableID: Integer) BaseImage: Text
    var
        FromRecRef: RecordRef;
        CuFileManagement: Codeunit "File Management";
        Bytes: dotnet Array;
        Convert: dotnet Convert;
        MemoryStream: dotnet MemoryStream;
        Ostream: OutStream;
        isTableFound: Boolean;
        RecordRef1: RecordRef;
        RecordRef2: RecordRef;
        RecordID: RecordID;
        FieldRef: FieldRef;
        tableFound: Boolean;
        imageID: Guid;
        Istream: InStream;
    begin
        TbDocumentAttachment.Reset();
        TbDocumentAttachment.SetRange("No.", docNo);
        TbDocumentAttachment.SetRange(ID, attachmentID);
        if tableID <> 0 then
            TbDocumentAttachment.SetRange("Table ID", tableID);
        if not TbDocumentAttachment.FindFirst() then begin
            TbDocumentAttachment.Reset();
            TbDocumentAttachment.SetRange("No.", docNo);
            TbDocumentAttachment.SetRange(ID, attachmentID);
            if (tableID = 52121800) or (tableID = 38) then
                TbDocumentAttachment.SetRange("Table ID", Database::"Purchase Header");
        end;
        if TbDocumentAttachment.FindFirst() then begin
            if TbDocumentAttachment."Document Reference ID".Hasvalue then begin
                imageID := TbDocumentAttachment."Document Reference ID".MediaId;
                if TbTenantMedia.Get(imageID) then begin
                    TbTenantMedia.CalcFields(Content);
                    TbTenantMedia.Content.CreateInstream(Istream);
                    MemoryStream := MemoryStream.MemoryStream();
                    CopyStream(MemoryStream, Istream);
                    Bytes := MemoryStream.GetBuffer();
                    BaseImage := Convert.ToBase64String(Bytes);
                end;
            end;
        end;
    end;

    procedure GetPassportPhoto(no: Code[20]; userType: Text) BaseImage: Text
    var
        ToFile: Text;
        IStream: InStream;
        Bytes: dotnet Array;
        Convert: dotnet Convert;
        MemoryStream: dotnet MemoryStream;
    begin
        if userType = 'staff' then begin
            TbEmployee.Reset;
            TbEmployee.SetRange(TbEmployee."No.", no);

            if TbEmployee.FindFirst then begin
                if TbEmployee.Picture.Hasvalue then begin
                    TbEmployee.CalcFields(Picture);
                    TbEmployee.Picture.CreateInstream(IStream);
                    MemoryStream := MemoryStream.MemoryStream();
                    CopyStream(MemoryStream, IStream);
                    Bytes := MemoryStream.GetBuffer();
                    BaseImage := Convert.ToBase64String(Bytes);
                end;
            end;
        end;
    end;

    procedure FnMemoHeader(DocNo: Code[30]; toWho: Text; from: Text; subject: Text; dimension1: Code[20]; dimension2: Code[20]; body: Text[250]; body2: Text[250]; body3: Text[250]; activityDate: Date; MyAction: Text; MyUserID: Code[30]) return: Code[20]
    begin
        /*return:='';
        TbMemoHeader.RESET;
        CASE MyAction OF
          'create':
          BEGIN
            TbMemoHeader.INIT;
            TbProcurementSetup.GET;
            TbProcurementSetup.TESTFIELD("Memo Nos");
            NextNo:=FORMAT(DATE2DMY(TODAY,3))+'/'+CuNoSeriesMgt.GetNextNo(TbProcurementSetup."Memo Nos",TODAY,TRUE);
            TbMemoHeader."Memo No" := NextNo;
            TbMemoHeader."To:":= toWho;
            TbMemoHeader."From:":= from;
            TbMemoHeader.Subject:= subject;
            TbMemoHeader."Global Dimension 1 Code":= dimension1;
             TbMemoHeader."Global Dimension 2 Code":= dimension2;
            TbMemoHeader.Body:= body;
            TbMemoHeader."body 2":= body2;
            TbMemoHeader."body 3":= body3;
            TbMemoHeader."User ID":= MyUserID;
            TbMemoHeader."Activity Date":= activityDate;
            IF TbMemoHeader.INSERT(TRUE) THEN
              return:=NextNo;
          END;
          'edit':
          BEGIN
            TbMemoHeader.RESET;
            TbMemoHeader.SETRANGE("Memo No",DocNo);
            TbMemoHeader.SETRANGE(Status,TbMemoHeader.Status::Open);
            IF TbMemoHeader.FINDFIRST THEN BEGIN
              TbMemoHeader."To:":= toWho;
              TbMemoHeader."From:":= from;
              TbMemoHeader.Subject:= subject;
              TbMemoHeader."Global Dimension 1 Code":= dimension1;
              TbMemoHeader."Global Dimension 2 Code":= dimension2;
              TbMemoHeader.Body:= body;
              TbMemoHeader."body 2":= body2;
              TbMemoHeader."body 3":= body3;
              TbMemoHeader."Activity Date":= activityDate;
              IF TbMemoHeader.MODIFY THEN
                return:=DocNo;
            END;
          END;
        END;*/

    end;

    procedure FnMemoLine(docNo: Code[30]; lineNo: Integer; expenseCode: Code[30]; MyAction: Text) return: Boolean
    begin
        /*return:=FALSE;
        TbMemoLine.RESET;
        CASE MyAction OF
          'create':
          BEGIN
            TbMemoLine.RESET;
            IF TbMemoLine.FINDLAST THEN lineNo:= TbMemoLine."Line No"+1 ELSE lineNo:=1;
            TbMemoLine.INIT;
            TbMemoLine."Memo No" := docNo;
            TbMemoLine."Line No":= lineNo;
            TbMemoLine."Expense Code":= expenseCode;
            TbMemoLine.VALIDATE("Expense Code");
            {TbMemoLine.Quantity:= quantity;
            TbMemoLine.VALIDATE(Quantity);
            TbMemoLine."No of Attendees":= amount;
            TbMemoLine.VALIDATE("No of Attendees");
            TbMemoLine."Total Amount":= noOfDays;
            TbMemoLine.VALIDATE("Total Amount");}
            IF TbMemoLine.INSERT(TRUE) THEN
              return:=TRUE;
          END;
          'edit':
          BEGIN
            TbMemoLine.RESET;
            TbMemoLine.SETRANGE("Memo No",docNo);
            TbMemoLine.SETRANGE("Line No",lineNo);
            IF TbMemoLine.FINDFIRST THEN BEGIN
              TbMemoLine."Expense Code":= expenseCode;
              TbMemoLine.VALIDATE("Expense Code");
              {TbMemoLine.Quantity:= quantity;
              TbMemoLine.VALIDATE(Quantity);
              TbMemoLine."No of Attendees":= amount;
              TbMemoLine.VALIDATE("No of Attendees");
              TbMemoLine."Total Amount":= noOfDays;
              TbMemoLine.VALIDATE("Total Amount");}
              IF TbMemoLine.MODIFY(TRUE) THEN
                return:=TRUE;
            END;
          END;
           'delete':
          BEGIN
            TbMemoLine.RESET;
            TbMemoLine.SETRANGE("Memo No",docNo);
            TbMemoLine.SETRANGE("Line No",lineNo);
            IF TbMemoLine.FINDFIRST THEN BEGIN
              IF TbMemoLine.DELETE THEN
                return:=TRUE;
            END;
           END;
        END;*/

    end;

    procedure MemoApprovalAction(UserNo: Code[100]; MemoNo: Code[50]; MyAction: Text) return_value: Boolean
    begin
        /*return_value:=FALSE;
        TbMemoHeader.RESET;
        TbMemoHeader.SETRANGE("Memo No",MemoNo);
        TbMemoHeader.SETRANGE("User ID",UserNo);
        IF TbMemoHeader.FINDFIRST() THEN BEGIN
          IF MyAction = 'RequestApproval' THEN BEGIN
            CuCustomApprovals.OnSendMemoForApproval(TbMemoHeader);
            return_value:=TRUE;
            COMMIT;
            FnUpdateApprovalEntries(MemoNo,TbMemoHeader."User ID",TbMemoHeader.RECORDID);
          END
          ELSE IF MyAction = 'CancelApproval' THEN BEGIN
            CuCustomApprovals.OnCancelMemoApprovalRequest(TbMemoHeader);
            return_value:=TRUE;
          END;
        END ELSE BEGIN
          ERROR('TbMemoHeader is no longer editable or it does not exist.');
        END;*/

    end;

    local procedure FnUpdateApprovalEntries(DocID: Code[30]; ToUserID: Code[30]; RecID: RecordID)
    begin
        TbApprovalEntry.Reset;
        TbApprovalEntry.SetRange(TbApprovalEntry."Document No.", DocID);
        TbApprovalEntry.SetRange("Table ID", RecID.TableNo);
        TbApprovalEntry.SetFilter(TbApprovalEntry."Sender ID", '%1|%2', 'ADMIN', UserId);
        TbApprovalEntry.SetFilter(TbApprovalEntry.Status, '%1|%2', TbApprovalEntry.Status::Open, TbApprovalEntry.Status::Created);
        if TbApprovalEntry.FindSet then begin
            repeat
                TbApprovalEntry."Sender ID" := ToUserID;
                TbApprovalEntry.Modify;
            until TbApprovalEntry.Next = 0;
        end;
    end;

    procedure FnMemoLineAttendees(memoNo: Code[30]; expenseCode: Code[30]; type: Integer; idNoOrStaffNo: Code[30]; Name: Text; Amount: Decimal; NoOfDays: Integer; MyAction: Text) return: Boolean
    begin
        /*return:=FALSE;
        CASE MyAction OF
          'create':
          BEGIN
            TbPerdiemStaff.RESET;
            TbPerdiemStaff.INIT;
            TbPerdiemStaff."Memo No" := memoNo;
            TbPerdiemStaff."Expense Code":= expenseCode;
            TbPerdiemStaff.Type:= type;
            TbPerdiemStaff."ID No/Staff No":= idNoOrStaffNo;
            TbPerdiemStaff.Name:= Name;
            TbPerdiemStaff.Amount:= Amount;
            TbPerdiemStaff."No of Days":= NoOfDays;
            TbPerdiemStaff.VALIDATE("No of Days");
            IF TbPerdiemStaff.INSERT(TRUE) THEN
              return:=TRUE;
          END;
          'delete':
          BEGIN
            TbPerdiemStaff.RESET;
            TbPerdiemStaff.SETRANGE("Memo No",memoNo);
            TbPerdiemStaff.SETRANGE("Expense Code",expenseCode);
            TbPerdiemStaff.SETRANGE(Type,type);
            TbPerdiemStaff.SETRANGE("ID No/Staff No",idNoOrStaffNo);
            IF TbPerdiemStaff.FINDFIRST THEN BEGIN
              IF TbPerdiemStaff.DELETE THEN
                return:=TRUE;
            END;
           END;
        END;*/

    end;

    procedure GenerateMemoReport(employeeNo: Code[100]; memoNo: Code[30]; filenameFromApp: Text[200]; myUserID: Code[30]) return_value: Text
    var
        MyRecordRef: RecordRef;
        MyOutstream: OutStream;
        TbTempBlob: Codeunit "Temp Blob";
        FileName2: Text;
        Convert: dotnet Convert;
        IOFile: dotnet File;
        base64txt: Text;
    begin
        /*return_value:='';
        TbGeneralSetup.GET;
        FILESPATH := TbGeneralSetup."Portal Reports File Path";
        filename := FILESPATH + filenameFromApp;
        FileName2 := FILESPATH +'-Encr-'+ filenameFromApp;
        IF EXISTS(filename) THEN
            ERASE(filename);
          TbMemoHeader.RESET;
          TbMemoHeader.SETFILTER(TbMemoHeader."Memo No",'=%1', memoNo);
          IF TbMemoHeader.FINDFIRST() THEN BEGIN
            RpMemo.SETTABLEVIEW(TbMemoHeader);
          END ELSE BEGIN
            ERROR('Memo not found');
          END;
          MyRecordRef.GETTABLE(TbMemoHeader);
          TbTempBlob.Blob.CREATEOUTSTREAM(MyOutstream);
          RpMemo.SAVEAS(filename, REPORTFORMAT::Pdf, MyOutstream, MyRecordRef);
          return_value := TbTempBlob.ToBase64String();
          IF EXISTS(filename) THEN
            ERASE(filename);*/

    end;

    procedure FnPVHeader(MyUserID: Code[30]; MyAction: Text; DocNo: Code[30]; dimension1: Code[30]; dimension2: Code[30]; responsibilityCenter: Code[30]; applyToDocType: Integer; applyToDocNo: Code[30]; payMode: Integer; chequeType: Integer; chequeNo: Code[10]; chequeAmount: Decimal; paymentType: Integer; payingBankAccount: Code[30]; paymentTo: Code[10]; paymentNarration: Code[20]) return: Code[20]
    begin
        return := '';
        TbPVHeader.Reset;
        case MyAction of
            'create':
                begin
                    TbPVHeader.Init;
                    TbCashOfficeSetup.Get;
                    TbCashOfficeSetup.TestField("Normal Payments No");
                    NextNo := CuNoSeriesMgt.GetNextNo(TbCashOfficeSetup."Normal Payments No", Today, true);
                    TbPVHeader."No." := NextNo;
                    TbPVHeader.Cashier := MyUserID;
                    TbPVHeader.Date := Today;
                    TbPVHeader."Payment Type" := TbPVHeader."payment type"::Normal;
                    TbPVHeader."Global Dimension 1 Code" := dimension1;
                    TbPVHeader."Shortcut Dimension 2 Code" := dimension2;
                    TbPVHeader."Responsibility Center" := responsibilityCenter;
                    TbPVHeader."Apply to Document Type" := applyToDocType;
                    TbPVHeader."Apply to Document No" := applyToDocNo;
                    TbPVHeader."Pay Mode" := payMode;
                    TbPVHeader."Cheque Type" := chequeType;
                    TbPVHeader."Cheque No." := chequeNo;
                    TbPVHeader."Paid Amount" := chequeAmount;
                    TbPVHeader."Payment Type" := paymentType;
                    TbPVHeader."Paying Bank Account" := payingBankAccount;
                    TbPVHeader.Validate("Paying Bank Account");
                    TbPVHeader.Payee := paymentTo;
                    TbPVHeader."Payment Narration" := paymentNarration;
                    if TbPVHeader.Insert(true) then
                        return := NextNo;
                end;
            'edit':
                begin
                    TbPVHeader.Reset;
                    TbPVHeader.SetRange("No.", DocNo);
                    TbPVHeader.SetRange(TbPVHeader.Status, TbPVHeader.Status::Pending);
                    if TbPVHeader.FindFirst then begin
                        TbPVHeader."Payment Type" := TbPVHeader."payment type"::Normal;
                        TbPVHeader."Global Dimension 1 Code" := dimension1;
                        TbPVHeader."Shortcut Dimension 2 Code" := dimension2;
                        TbPVHeader."Responsibility Center" := responsibilityCenter;
                        TbPVHeader."Apply to Document Type" := applyToDocType;
                        TbPVHeader."Apply to Document No" := applyToDocNo;
                        TbPVHeader."Pay Mode" := payMode;
                        TbPVHeader."Cheque Type" := chequeType;
                        TbPVHeader."Cheque No." := chequeNo;
                        TbPVHeader."Paid Amount" := chequeAmount;
                        TbPVHeader."Payment Type" := paymentType;
                        TbPVHeader."Paying Bank Account" := payingBankAccount;
                        TbPVHeader.Validate("Paying Bank Account");
                        TbPVHeader.Payee := paymentTo;
                        TbPVHeader."Payment Narration" := paymentNarration;
                        if TbPVHeader.Modify(true) then
                            return := DocNo;
                    end else
                        Error('Error: Either the document was not found or it is no longer editable');
                end;
        end;
    end;

    procedure FnPVLine(myAction: Text; docNo: Code[30]; lineNo: Integer; type: Code[30]; accountType: Integer; accountNo: Code[30]; amount: Decimal; vatWithHoldCode: Code[20]; withHoldTaxCode: Code[20]) return: Boolean
    begin
        return := false;
        TbPVLine.Reset;
        case myAction of
            'create':
                begin
                    TbPVLine.Reset;
                    if TbPVLine.FindLast then lineNo := TbPVLine."Line No." + 1 else lineNo := 1;
                    TbPVLine.Init;
                    TbPVLine.No := docNo;
                    TbPVLine."Line No." := lineNo;
                    TbPVLine."Account Type" := accountType;
                    TbPVLine."Account No." := accountNo;
                    TbPVLine.Validate("Account No.");
                    TbPVLine.Amount := amount;
                    TbPVLine."VAT Withheld Code" := vatWithHoldCode;
                    TbPVLine.Validate("VAT Withheld Code");
                    TbPVLine."Withholding Tax Code" := withHoldTaxCode;
                    TbPVLine.Validate("Withholding Tax Code");
                    if TbPVLine.Insert(true) then
                        return := true;
                end;
            'edit':
                begin
                    TbPVLine.Reset;
                    TbPVLine.SetRange(No, docNo);
                    TbPVLine.SetRange("Line No.", lineNo);
                    if TbPVLine.FindFirst then begin
                        TbPVLine."Account Type" := accountType;
                        TbPVLine."Account No." := accountNo;
                        TbPVLine.Validate("Account No.");
                        TbPVLine.Amount := amount;
                        TbPVLine."VAT Withheld Code" := vatWithHoldCode;
                        TbPVLine.Validate("VAT Withheld Code");
                        TbPVLine."Withholding Tax Code" := withHoldTaxCode;
                        TbPVLine.Validate("Withholding Tax Code");
                        if TbPVLine.Modify(true) then
                            return := true;
                    end;
                end;
            'delete':
                begin
                    TbPVLine.Reset;
                    TbPVLine.SetRange(No, docNo);
                    TbPVLine.SetRange("Line No.", lineNo);
                    if TbPVLine.FindFirst then begin
                        if TbPVLine.Delete then
                            return := true;
                    end;
                end;
        end;
    end;

    procedure PVApprovalAction(docNo: Code[50]; MyAction: Text) return_value: Boolean
    begin
        return_value := false;
        TbPVHeader.Reset;
        TbPVHeader.SetRange("No.", docNo);
        if TbPVHeader.FindFirst() then begin
            if MyAction = 'RequestApproval' then begin
                VarVariant := TbPVHeader;
                CuCustomApprovals.OnSendDocForApproval(VarVariant);
                return_value := true;
                Commit;
                FnUpdateApprovalEntries(docNo, TbPVHeader.Cashier, TbPVHeader.RecordId);
            end
            else if MyAction = 'CancelApproval' then begin
                VarVariant := TbPVHeader;
                CuCustomApprovals.OnCancelDocApprovalRequest(VarVariant);
                return_value := true;
            end;
        end else begin
            Error('PV header is no longer editable or it does not exist.');
        end;
    end;

    procedure GeneratePVReport(docNo: Code[30]; filenameFromApp: Text[200]; myUserID: Code[30]) return_value: Text
    var
        MyRecordRef: RecordRef;
        MyOutstream: OutStream;
        TbTempBlob: Codeunit "Temp Blob";
        FileName2: Text;
        Convert: dotnet Convert;
        IOFile: dotnet File;
        base64txt: Text;
    begin
        return_value := '';
        TbGeneralSetup.Get;
        FILESPATH := TbGeneralSetup."Portal Reports File Path";
        filename := FILESPATH + filenameFromApp;
        if Exists(filename) then
            Erase(filename);
        TbPVHeader.Reset;
        TbPVHeader.SetFilter(TbPVHeader."No.", '=%1', docNo);
        if TbPVHeader.FindFirst() then begin
            RpPV.SetTableview(TbPVHeader);
        end else begin
            Error('Header not found');
        end;
        MyRecordRef.GetTable(TbPVHeader);
        TbTempBlob.CreateOutstream(MyOutstream);
        RpPV.SaveAs(filename, Reportformat::Pdf, MyOutstream, MyRecordRef);
        return_value := Convert.ToBase64String(IOFile.ReadAllBytes(filename));
        if Exists(filename) then
            Erase(filename);
    end;

    local procedure FnGetCurrentLeavePeriod() return_value: Code[30]
    begin
        TbLeavePeriod.Reset;
        TbLeavePeriod.SetRange(TbLeavePeriod.Current, true);
        if TbLeavePeriod.FindLast then begin
            return_value := TbLeavePeriod.Code
        end;
    end;

    procedure FnPayrollMasterRollReport(year: Integer; month: Integer; postingGroup: Code[30]; filenameFromApp: Text) return_value: Text
    begin
        TbGeneralSetup.Get;
        TbGeneralSetup.TestField("Portal Reports File Path");
        FILESPATH := TbGeneralSetup."Portal Reports File Path";
        filename := FILESPATH + filenameFromApp;
        //
        TbPaPerTrans.Reset;
        TbPaPerTrans.SetRange("Payroll Period", Dmy2date(1, month, year));
        TbPaPerTrans.SetRange("Period Month", month);
        TbPaPerTrans.SetRange("Period Year", year);
        if TbPaPerTrans.FindSet then begin
            RpMasterRoll.SetTableview(TbPaPerTrans);
            MyRecordRef.GetTable(TbPaPerTrans);
            TbTempBlob.CreateOutstream(MyOutstream);
            RpMasterRoll.SaveAs(filename, Reportformat::Pdf, MyOutstream, MyRecordRef);
            return_value := Convert.ToBase64String(IOFile.ReadAllBytes(filename));
            if Exists(filename) then
                Erase(filename);
        end else
            Error('No payaroll data found for period %1', Dmy2date(1, month, year));
    end;

    procedure FnTrainingRequest(MyUserID: Code[30]; MyAction: Text; DocNo: Code[30]; trainingCourseCode: Code[30]; purpose: Text; employeeNo: Code[30]) return: Code[20]
    begin
        return := '';
        TbTrainingHe.Reset;
        case MyAction of
            'create':
                begin
                    if TbTrainingHe.FindLast then NextNo := IncStr(TbTrainingHe."Application No") else NextNo := 'TAP-00001';
                    TbTrainingHe.Init;
                    TbTrainingHe."Application No" := NextNo;
                    TbTrainingHe."User ID" := MyUserID;
                    TbTrainingHe."Application Date" := Today;
                    TbTrainingHe."Course Title" := trainingCourseCode;
                    TbTrainingHe.Validate("Course Title");
                    TbTrainingHe."Purpose of Training" := purpose;
                    if TbTrainingHe.Insert(true) then begin
                        TbTrainingParticipant.Init;
                        TbTrainingParticipant."Training Code" := NextNo;
                        TbTrainingParticipant."Employee Code" := employeeNo;
                        TbTrainingParticipant.Validate("Employee Code");
                        TbTrainingParticipant.Insert(true);
                        return := NextNo;
                    end;
                end;
            'edit':
                begin
                    TbTrainingHe.SetRange("Application No", DocNo);
                    TbTrainingHe.SetRange(TbTrainingHe.Status, TbTrainingHe.Status::New);
                    if TbTrainingHe.FindFirst then begin
                        TbTrainingHe."Application Date" := Today;
                        TbTrainingHe."Course Title" := trainingCourseCode;
                        TbTrainingHe.Validate("Course Title");
                        TbTrainingHe."Purpose of Training" := purpose;
                        if TbTrainingHe.Modify(true) then
                            return := DocNo;
                    end else
                        Error('Error: Either the document was not found or it is no longer editable');
                end;
        end;
    end;

    procedure TrainingApproval(docNo: Code[50]; MyAction: Text) return_value: Boolean
    begin
        return_value := false;
        TbTrainingHe.Reset;
        TbTrainingHe.SetRange("Application No", docNo);
        if TbTrainingHe.FindFirst() then begin
            if MyAction = 'requestApproval' then begin
                VarVariant := TbTrainingHe;
                CuCustomApprovals.OnSendDocForApproval(VarVariant);
                return_value := true;
                Commit;
                FnUpdateApprovalEntries(docNo, TbTrainingHe."User ID", TbTrainingHe.RecordId);
            end
            else if MyAction = 'cancelApproval' then begin
                VarVariant := TbTrainingHe;
                CuCustomApprovals.OnCancelDocApprovalRequest(VarVariant);
                return_value := true;
            end;
        end else begin
            Error('Training header is no longer editable or it does not exist.');
        end;
    end;

    // TODO: Staff Portal: IMplement Attendance Management? Check in and Checkout using location coodinates and time

    // procedure FnCheckinCheckout(employeeNo: Code[30]; type: Text; myUserID: Code[50]; location: Text) return_value: Text
    // var
    //     reportingTime: Time;
    //     newTime: Time;
    //     closingTime: Time;
    //     timeDifference: Integer;
    //     TbHrAtteLedg: Record attendance;
    //     TbHrAtteLedg2: Record UnknownRecord52202935;
    // begin
    //     //
    //     return_value := '';
    //     reportingTime := 083000T;
    //     closingTime := 170000T;
    //     //
    //     TbHrAtteLedg2.Reset();
    //     TbHrAtteLedg2.SetRange(TbHrAtteLedg2."Staff No.", employeeNo);
    //     TbHrAtteLedg2.SetRange(TbHrAtteLedg2."Transaction Date", Today);
    //     if not TbHrAtteLedg2.FindFirst() then begin
    //         if (type = 'checkout') then
    //             Error('You cannot checkout before checking in.');
    //         TbHRSetup.Get();
    //         TbHRSetup.TestField(TbHRSetup."Staff Register Nos");
    //         NextNo := CuNoSeriesMgt.GetNextNo(TbHRSetup."Staff Register Nos", Today, true);
    //         TbHrAtteLedg."Visit No." := NextNo;
    //         TbHrAtteLedg."Staff No." := employeeNo;
    //         TbHrAtteLedg.Validate("Staff No.");
    //         TbHrAtteLedg."Transaction Date" := Today;
    //         //TbHrAtteLedg."login date time" := CurrentDateTime;
    //         TbHrAtteLedg."Time In" := Time;
    //         TbHrAtteLedg."Time Out" := 0T;
    //         TbHrAtteLedg."Hours Worked" := 0;
    //         TbHrAtteLedg."Signed in by" := myUserID;
    //         timeDifference := ROUND((TbHrAtteLedg."Time In" - reportingTime) / 60000, 1, '=');
    //         if timeDifference > 0 then
    //             return_value := 'Signed in late by ' + Format(timeDifference) + ' minutes'
    //         else
    //             return_value := 'Signed in on time';
    //         TbHrAtteLedg."Location Coordinates" := location;
    //         TbHrAtteLedg."Sign in Comments" := return_value;
    //         TbHrAtteLedg.Insert(true);
    //         return_value := 'Signed in successfully - ' + return_value;
    //     end else begin
    //         if (type = 'checkin') then
    //             Error('You have already signed in at %1', TbHrAtteLedg2."Time In");
    //         if (type = 'checkout') and (TbHrAtteLedg2."Time In" = 0T) then
    //             Error('You cannot sign out before signing in.');
    //         if (type = 'checkout') and (TbHrAtteLedg2."Time Out" <> 0T) then
    //             Error('You have already signed out at %1', TbHrAtteLedg2."Time Out");
    //         TbHrAtteLedg2.Validate("Staff No.");
    //         TbHrAtteLedg2."Transaction Date" := Today;
    //         TbHrAtteLedg2."Time Out" := Time;
    //         TbHrAtteLedg2.Validate("Time Out");
    //         TbHrAtteLedg2."Signed Out By" := myUserID;
    //         timeDifference := ROUND((TbHrAtteLedg2."Time Out" - closingTime) / 60000, 1, '=');
    //         if timeDifference < 0 then
    //             return_value := 'You have signed out early by ' + Format(timeDifference) + ' minutes'
    //         else
    //             return_value := 'Signed out on time';
    //         TbHrAtteLedg2."Location Coordinates" := location;
    //         TbHrAtteLedg2."Sign out Comments" := return_value;
    //         TbHrAtteLedg2.Modify(true);
    //         return_value := 'Signed out successfully - ' + return_value;
    //     end;
    // end;

    procedure FnGetLeaveDetails(empNo: Code[30]; startDate: Date; endDate: Date; leaveType: Code[30]) returValue: Text
    begin
        TbHRLeaveRequisition.Reset;
        TbHRLeaveRequisition.Init;
        TbHRLeaveRequisition."Leave Type" := leaveType;
        TbHRLeaveRequisition."Employee No." := empNo;
        TbHRLeaveRequisition."Start Date" := startDate;
        TbHRLeaveRequisition."End Date" := endDate;
        TbHRLeaveRequisition.Validate("End Date");
        returValue := Format(TbHRLeaveRequisition."Return Date") + '##' + Format(TbHRLeaveRequisition."Days Applied");
    end;

    /// Returns the employee-card job title and related profile fields so the
    /// self-service portal displays the actual BC designation instead of a
    /// generic role label such as Staff.
    procedure FnGetEmployeeProfile(employeeNo: Code[30]) return_value: Text
    var
        HREmployee: Record "HR-Employee";
    begin
        return_value := '';
        if not HREmployee.Get(employeeNo) then
            exit;

        return_value :=
          'JobTitle=' + HREmployee."Job Title" +
          '#JobID=' + HREmployee."Job ID" +
          '#CustomerNo=' + HREmployee."Customer No" +
          '#FullName=' + HREmployee."Full Name" +
          '#Gender=' + Format(HREmployee.Gender) +
          '#MaritalStatus=' + Format(HREmployee."Marital Status");
    end;

    procedure GetLeaveDates(empNo: Code[30]; leaveType: code[30]; startDate: Date; noOfDays: Decimal) return_value: text
    var
        returnDate: Date;
        endDate2: Date;
        calendarDays: Integer;
    begin
        return_value := '';
        if startDate = 0D then
            Error('Start Date is required.');
        calendarDays := Round(noOfDays, 1, '>');
        if calendarDays < 1 then
            calendarDays := 1;
        endDate2 := startDate + calendarDays - 1;
        returnDate := endDate2 + 1;
        return_value := 'EndDate=' + format(endDate2) + '#ReturnDate=' + format(returnDate);
    end;

    // TODO: Staff Portal: Appraisal and performance type?
    /*  procedure FnAppraisalEmployeeRating(docNo: Code[30]; "area": Code[50]; measure: Text; employeeRating: Decimal; employeeComments: Text) return: Boolean
     begin
         return := false;
         TbAppraisalScore.Reset;
         TbAppraisalScore.SetRange("Appraisal No", docNo);
         TbAppraisalScore.SetRange("Key Result Area", area);
         TbAppraisalScore.SetRange("Performance Measure", measure);
         if TbAppraisalScore.FindFirst then begin
             TbAppraisalScore."Employee Rating" := employeeRating;
             TbAppraisalScore.Validate("Employee Rating");
             TbAppraisalScore."Employee Comments" := employeeComments;
             TbAppraisalScore.Modify;
             return := true;
         end;
     end;

     procedure FnAppraisalSupervisorRating(docNo: Code[30]; "area": Code[50]; measure: Text; supervisorRating: Decimal; supervisorComments: Text) return: Boolean
     begin
         return := false;
         TbAppraisalScore.Reset;
         TbAppraisalScore.SetRange("Appraisal No", docNo);
         TbAppraisalScore.SetRange("Key Result Area", area);
         TbAppraisalScore.SetRange("Performance Measure", measure);
         if TbAppraisalScore.FindFirst then begin
             TbAppraisalScore."Supervisor Rating" := supervisorRating;
             TbAppraisalScore.Validate("Supervisor Rating");
             TbAppraisalScore."Supervisor Comments" := supervisorComments;
             TbAppraisalScore.Modify;
             return := true;
         end;
     end;

     procedure FnAppraisalSubmit(docNo: Code[30]; employeeNo: Code[30]) return: Boolean
     begin
         return := false;
         TbAppraisalHe.Reset;
         TbAppraisalHe.SetRange("Appraisal No", docNo);
         if TbAppraisalHe.FindFirst then begin
             if TbAppraisalHe."Employee No" = employeeNo then
                 TbAppraisalHe.Status := TbAppraisalHe.Status::"Pending Approval";
             if TbAppraisalHe.Supervisor = employeeNo then
                 TbAppraisalHe.Status := TbAppraisalHe.Status::Closed;
             TbAppraisalHe.Modify;
             return := true;
         end;
     end;
  */
    procedure FnAttachment("action": Text; attachmentID: Integer; accountNo: Code[30]; description: Text[250]; b64File: Text; fileName: Text; TableID: Integer) return_value: Boolean
    var
        FromRecRef: RecordRef;
        Bytes: dotnet Array;
        Convert: dotnet Convert;
        MemoryStream: dotnet MemoryStream;
        Ostream: OutStream;
        FileManagement: Codeunit "File Management";
    begin
        return_value := false;
        DocumentAttachment.Reset;
        case action of
            'insert':
                begin
                    Clear(DocumentAttachment);
                    DocumentAttachment.Init;
                    DocumentAttachment.Validate("File Extension", FileManagement.GetExtension(fileName));
                    DocumentAttachment.Validate("File Name", CopyStr(FileManagement.GetFileNameWithoutExtension(fileName), 1, MaxStrLen(fileName)));
                    DocumentAttachment.Validate("Table ID", TableID);
                    DocumentAttachment.Validate("No.", accountNo);

                    Bytes := Convert.FromBase64String(b64File);
                    MemoryStream := MemoryStream.MemoryStream(Bytes);
                    DocumentAttachment."Document Reference ID".ImportStream(MemoryStream, '', fileName);
                    DocumentAttachment.Insert(true);
                    if FileManagement.DeleteServerFile(fileName) then
                        return_value := true;
                end;
            'delete':
                begin
                    DocumentAttachment.SetRange("Table ID", TableID);
                    DocumentAttachment.SetRange("No.", accountNo);
                    DocumentAttachment.SetRange(ID, attachmentID);
                    if DocumentAttachment.FindFirst then begin
                        DocumentAttachment.Delete;
                        return_value := true;
                    end;
                end;
        end;
        exit(return_value);
    end;

    procedure FnCheckinCheckout(employeeNo: Code[30]; type: Text; myUserID: Code[50]; location: Text) return_value: Text
    var
        TbHrAtteLedg2: Record "HR Attendance Ledger";
        TbHrAtteLedg: Record "HR Attendance Ledger";
        reportingTime: Time;
        reportingGraceTime: Time;
        closingTime: Time;
        closingGraceTime: Time;
        automaticClosingTime: Time;
        timeDifference: Integer;
    begin
        return_value := '';
        reportingTime := 083000T;
        reportingGraceTime := 085000T;
        closingTime := 173000T;
        closingGraceTime := 172000T;
        automaticClosingTime := 190000T;
        if (type = 'checkin') and (Time >= automaticClosingTime) then
            Error('Check-in is not available after the automatic 7:00 PM sign-out time.');
        //
        TbHrAtteLedg2.RESET();
        TbHrAtteLedg2.SETRANGE(TbHrAtteLedg2."Staff No.", employeeNo);
        TbHrAtteLedg2.SETRANGE(TbHrAtteLedg2.Date, TODAY);
        IF NOT TbHrAtteLedg2.FINDFIRST() THEN BEGIN
            IF (type = 'checkout') THEN BEGIN
                // Close a prior-day open session when the employee forgot to sign out.
                TbHrAtteLedg.RESET();
                TbHrAtteLedg.SETRANGE("Staff No.", employeeNo);
                TbHrAtteLedg.SETFILTER("Time Out", '%1', 0T);
                TbHrAtteLedg.SETFILTER("Time In", '<>%1', 0T);
                IF TbHrAtteLedg.FINDLAST() THEN BEGIN
                    TbHrAtteLedg.VALIDATE("Staff No.");
                    IF TbHrAtteLedg."Time In" > automaticClosingTime THEN
                        TbHrAtteLedg."Time Out" := 235959T
                    ELSE
                        TbHrAtteLedg."Time Out" := automaticClosingTime;
                    TbHrAtteLedg.VALIDATE("Time Out");
                    return_value := 'Closed open session from ' + FORMAT(TbHrAtteLedg.Date);
                    IF TbHrAtteLedg.Date <> TODAY THEN
                        return_value += ' (signed out on ' + FORMAT(TODAY) + ')';
                    TbHrAtteLedg."Location Coordinates" := location;
                    TbHrAtteLedg."Sign out Comments" := return_value;
                    TbHrAtteLedg.MODIFY(TRUE);
                    return_value := 'Signed out successfully - ' + return_value;
                    EXIT(return_value);
                END;
                ERROR('You cannot checkout before checking in.');
            END;
            TbHRSetup.GET();
            TbHRSetup.TESTFIELD(TbHRSetup."Attendance Nos");
            NextNo := CuNoSeriesMgt.GetNextNo(TbHRSetup."Attendance Nos", TODAY, TRUE);
            TbHrAtteLedg."No." := NextNo;
            TbHrAtteLedg."Staff No." := employeeNo;
            TbHrAtteLedg.VALIDATE("Staff No.");
            TbHrAtteLedg.Date := TODAY;
            TbHrAtteLedg."login date time" := CurrentDateTime;
            TbHrAtteLedg."Time In" := TIME;
            TbHrAtteLedg."Time Out" := 0T;
            TbHrAtteLedg."Hours Worked" := 0;
            // TbHrAtteLedg."Signed in by" := myUserID;
            timeDifference := ROUND((TbHrAtteLedg."Time In" - reportingTime) / 60000, 1, '=');
            IF TbHrAtteLedg."Time In" > reportingGraceTime THEN
                return_value := 'Signed in late by ' + FORMAT(timeDifference) + ' minutes'
            ELSE IF TbHrAtteLedg."Time In" > reportingTime THEN
                return_value := 'Signed in within the 8:50 AM grace period'
            ELSE
                return_value := 'Signed in on time';
            TbHrAtteLedg."Location Coordinates" := location;
            TbHrAtteLedg."Sign in Comments" := return_value;
            TbHrAtteLedg.INSERT(TRUE);
            return_value := 'Signed in successfully - ' + return_value;
        END ELSE BEGIN
            IF (type = 'checkin') THEN
                ERROR('You have already signed in at %1', TbHrAtteLedg2."Time In");
            IF (type = 'checkout') AND (TbHrAtteLedg2."Time In" = 0T) THEN
                ERROR('You cannot sign out before signing in.');
            IF (type = 'checkout') AND (TbHrAtteLedg2."Time Out" <> 0T) THEN
                ERROR('You have already signed out at %1', TbHrAtteLedg2."Time Out");
            TbHrAtteLedg2.VALIDATE("Staff No.");
            TbHrAtteLedg2.Date := TODAY;
            TbHrAtteLedg2."Time Out" := TIME;
            TbHrAtteLedg2.VALIDATE("Time Out");
            // TbHrAtteLedg2."Signed Out By" := myUserID;
            timeDifference := ROUND((closingTime - TbHrAtteLedg2."Time Out") / 60000, 1, '=');
            IF TbHrAtteLedg2."Time Out" < closingGraceTime THEN
                return_value := 'You have signed out early by ' + FORMAT(timeDifference) + ' minutes'
            ELSE IF TbHrAtteLedg2."Time Out" < closingTime THEN
                return_value := 'Signed out within the 5:20 PM grace period'
            ELSE
                return_value := 'Signed out on time';
            TbHrAtteLedg2."Location Coordinates" := location;
            TbHrAtteLedg2."Sign out Comments" := return_value;
            // TbHrAtteLedg2.l
            TbHrAtteLedg2.MODIFY(TRUE);
            return_value := 'Signed out successfully - ' + return_value;
        END;

    end;

    procedure RunAttendanceAutoSignOut() return_value: Integer
    var
        AttendanceLedger: Record "HR Attendance Ledger";
        AutomaticClosingTime: Time;
    begin
        return_value := 0;
        AutomaticClosingTime := 190000T;
        if Time < AutomaticClosingTime then
            exit(return_value);

        AttendanceLedger.Reset();
        AttendanceLedger.SetFilter(Date, '<=%1', Today);
        AttendanceLedger.SetFilter("Time In", '<>%1', 0T);
        AttendanceLedger.SetRange("Time Out", 0T);
        if AttendanceLedger.FindSet(true) then
            repeat
                if AttendanceLedger."Time In" > AutomaticClosingTime then
                    AttendanceLedger."Time Out" := 235959T
                else
                    AttendanceLedger."Time Out" := AutomaticClosingTime;
                AttendanceLedger.Validate("Time Out");
                AttendanceLedger."Sign out Comments" := 'Automatically signed out at 7:00 PM';
                AttendanceLedger.Modify(true);
                return_value += 1;
            until AttendanceLedger.Next() = 0;
    end;

    procedure FnGetDocumentAttachmentBase64(docNo: Code[30]; tableID: Integer) BaseImage: Text;
    var
        FromRecRef: RecordRef;
        CuFileManagement: Codeunit "File Management";
        Bytes: DotNet Array;
        Convert: DotNet Convert;
        MemoryStream: DotNet MemoryStream;
        Ostream: OutStream;
        isTableFound: Boolean;
        MyInStream: InStream;
        tableFound: Boolean;
        imageID: GUID;
        Istream: InStream;
        CuTempBlob: Codeunit "Temp Blob";
        TbDocumentAttachment: record "Document Attachment";
        TbTenantMedia: Record "Tenant Media";
    begin
        TbHRSetup.Get();
        TbHRSetup.TestField("Portal Reports File Path");

        FILESPATH := TbHRSetup."Portal Reports File Path";

        DocumentAttachment.RESET();
        DocumentAttachment.SETRANGE("Table ID", tableID);
        // DocumentAttachment.SetRange(Current, true);
        DocumentAttachment.SETRANGE("No.", docNo);
        if DocumentAttachment.FINDFIRST() then begin
            /*  if DocumentAttachment."Document Reference ID".HASVALUE then begin
                 imageID := TbDocumentAttachment."Document Reference ID".MEDIAID;
                 if TbTenantMedia.GET(imageID) then begin
                     TbTenantMedia.CALCFIELDS(Content);
                     TbTenantMedia.Content.CREATEINSTREAM(Istream);
                     MemoryStream := MemoryStream.MemoryStream();
                     COPYSTREAM(MemoryStream, Istream);
                     Bytes := MemoryStream.GetBuffer();
                     BaseImage := Convert.ToBase64String(Bytes);
                 end;
             end; */
            if DocumentAttachment."Document Reference ID".HasValue then begin
                // DocumentAttachment.CalcFields("Document Reference ID");
                CuTempBlob.CreateOutStream(MyOutstream);
                DocumentAttachment."Document Reference ID".ExportStream(MyOutstream);

                FileName := FILESPATH + DocumentAttachment."File Name" + DocumentAttachment."File Extension";

                // CuFileManagement.BLOBImportFromServerFile(CuTempBlob, FileName);
                CuTempBlob.CreateInStream(MyInStream);
                MemoryStream := MemoryStream.MemoryStream();
                COPYSTREAM(MemoryStream, MyInStream);
                Bytes := MemoryStream.GetBuffer();
                BaseImage := Convert.ToBase64String(Bytes);
                IF EXISTS(filename) THEN
                    ERASE(filename);
            end;
        end;

    end;

    procedure FnSalaryAdvanceHeader(staffNo: Code[30]; purpose: Text; myAction: Text; recId: Text; percentageSalary: Decimal) return_value: Text
    var
        StaffAdvanceHeader: Record "Staff Advance Header";
        StaffAdvanceLines: Record "Staff Advance Lines";
    begin
        return_value := '';
        case myAction of
            'create':
                begin
                    StaffAdvanceHeader.Init();
                    StaffAdvanceHeader."Staff ID" := staffNo;
                    StaffAdvanceHeader.Validate("Staff ID");
                    StaffAdvanceHeader.Purpose := purpose;
                    // StaffAdvanceHeader.Status := StaffAdvanceHeader.Status::Approved;
                    if StaffAdvanceHeader.Insert(true) then begin
                        StaffAdvanceLines.Init();
                        StaffAdvanceLines.No := StaffAdvanceHeader."No.";
                        StaffAdvanceLines."Advance Type" := 'SALARY';
                        StaffAdvanceLines.Validate("Advance Type");
                        StaffAdvanceLines."Account No:" := StaffAdvanceHeader."Customer No";
                        StaffAdvanceLines."Percentage of Salary" := percentageSalary;
                        StaffAdvanceLines.Validate("Percentage of Salary");
                        StaffAdvanceLines.Purpose := purpose;
                        StaffAdvanceLines.Insert(true);
                        return_value := StaffAdvanceHeader."No.";
                    end;
                end;
            'edit':
                begin
                    StaffAdvanceHeader.Reset();
                    StaffAdvanceHeader.SetRange(SystemId, recId);
                    if StaffAdvanceHeader.FindFirst() then begin
                        StaffAdvanceHeader.Purpose := Purpose;

                        StaffAdvanceLines.Reset();
                        StaffAdvanceLines.SetRange("Advance Type", 'SALARY');
                        StaffAdvanceLines.SetRange(No, StaffAdvanceHeader."No.");
                        if StaffAdvanceLines.FindFirst() then begin
                            StaffAdvanceLines."Percentage of Salary" := percentageSalary;
                            StaffAdvanceLines.Validate("Percentage of Salary");
                            StaffAdvanceLines.Purpose := purpose;
                            StaffAdvanceLines.Modify();
                            if StaffAdvanceHeader.Modify(true) then
                                return_value := StaffAdvanceHeader."No.";
                        end;
                    end;
                end;
        end;
    end;

    procedure FnSalaryAdvanceApprovalAction(docNo: Code[30]; action: Text) return_value: Boolean
    var
        StaffAdvanceHeader: Record "Staff Advance Header";
    begin
        return_value := false;

        StaffAdvanceHeader.Reset;
        StaffAdvanceHeader.SetRange(StaffAdvanceHeader."No.", docNo);
        if StaffAdvanceHeader.FindFirst() then begin
            VarVariant := StaffAdvanceHeader;
            if CuCustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) then begin
                if action = 'request' then
                    CuCustomApprovals.OnSendDocForApproval(VarVariant);

                if action = 'cancel' then
                    CuCustomApprovals.OnCancelDocApprovalRequest(VarVariant);

                return_value := true;
            end;
        end else begin
            Error('Adavance Request was not found');
        end;
    end;

    procedure FnGetEmployeeLeaveBalances(employeeNo: Code[30]) return_value: Text
    var
        HREmployee: Record "HR-Employee";
        LeaveEntitlement: Decimal;
        CarryForward: Decimal;
        TotalAvailableLeaveBalance: Decimal;
        LeaveAccruedToDate: Decimal;
        TotalLeaveTakenToDate: Decimal;
        AvailableLeaveBalance: Decimal;
        AccruedDays: Decimal;
        CarryForwardBalance: Decimal;
    begin
        if not HREmployee.Get(employeeNo) then
            Error('Employee %1 was not found.', employeeNo);

        CalculatePortalAnnualLeaveMetrics(
            HREmployee,
            LeaveEntitlement,
            CarryForward,
            TotalAvailableLeaveBalance,
            LeaveAccruedToDate,
            TotalLeaveTakenToDate,
            AvailableLeaveBalance,
            AccruedDays,
            CarryForwardBalance);

        // Keep every legacy key and append explicit employee-facing metrics. Older
        // portals continue to read AnnualLeaveBalance/EarnedLeaveDays; updated portals
        // use AvailableLeaveBalance as the only annual-leave application limit.
        return_value :=
          StrSubstNo(
            'AnnualLeaveBalance=%1#LeaveBalance=%2#EarnedLeaveDays=%3#AccruedDays=%4#CarryForwardBalance=%5#LeaveEntitlement=%6#CarryForward=%7#TotalAvailableLeaveBalance=%1#LeaveAccruedToDate=%3#TotalLeaveTakenToDate=%8#AvailableLeaveBalance=%2',
            Format(TotalAvailableLeaveBalance, 0, 9),
            Format(AvailableLeaveBalance, 0, 9),
            Format(LeaveAccruedToDate, 0, 9),
            Format(AccruedDays, 0, 9),
            Format(CarryForwardBalance, 0, 9),
            Format(LeaveEntitlement, 0, 9),
            Format(CarryForward, 0, 9),
            Format(TotalLeaveTakenToDate, 0, 9));
        exit(return_value);
    end;

    procedure FnGetEmployeeMedicalBalances(employeeNo: Code[30]) return_value: Text
    var
        HREmployee: Record "HR-Employee";
        Result: JsonObject;
    begin
        if not HREmployee.Get(employeeNo) then
            Error('Employee %1 was not found.', employeeNo);

        HREmployee.CalcFields("medical Claim balance-Self", "Medical Claim Balance-Dependant");
        Result.Add('self', HREmployee."medical Claim balance-Self");
        Result.Add('dependant', HREmployee."Medical Claim Balance-Dependant");
        Result.WriteTo(return_value);
        exit(return_value);
    end;

    procedure GetLeaveBalance(employeeNo: Code[20]; leaveType: Code[30]) return_value: Text
    var
        Employee: Record "HR-Employee";
        LeaveTypeSetup: Record "Leave Types";
        HRLeaveCal: Record "HR Leave Calendar.";
        HRLeaveAlloc: Record "HR Leave Allocation";
        Result: JsonObject;
        ResultText: Text;
        AllocatedDays: Decimal;
        ReimbursedDays: Decimal;
        CarryForwardBalance: Decimal;
        CurrentTotalLeaveTaken: Decimal;
        CurrentLeaveBalance: Decimal;
        AnnualCardBalance: Decimal;
        AnnualLeaveEntitlement: Decimal;
        AnnualCarryForward: Decimal;
        AnnualLeaveAccruedToDate: Decimal;
        AnnualTotalLeaveTakenToDate: Decimal;
        AnnualAvailableLeaveBalance: Decimal;
        AnnualAccruedDays: Decimal;
        AnnualCarryForwardBalance: Decimal;
        IsAnnual: Boolean;
    begin
        Employee.Get(employeeNo);
        CalculatePortalAnnualLeaveMetrics(
            Employee,
            AnnualLeaveEntitlement,
            AnnualCarryForward,
            AnnualCardBalance,
            AnnualLeaveAccruedToDate,
            AnnualTotalLeaveTakenToDate,
            AnnualAvailableLeaveBalance,
            AnnualAccruedDays,
            AnnualCarryForwardBalance);
        IsAnnual := false;
        if LeaveTypeSetup.Get(leaveType) then
            IsAnnual := LeaveTypeSetup.Annual or
              (UpperCase(LeaveTypeSetup.Code) = 'ANNUAL') or
              (UpperCase(LeaveTypeSetup.Code) = '0001') or
              (StrPos(UpperCase(LeaveTypeSetup.Description), 'ANNUAL') > 0);

        HRLeaveCal.SetRange(Current, true);
        if HRLeaveCal.FindFirst() then begin
            if HRLeaveCal.Count > 1 then
                Error('There are currently %1 Active Leave Calendars. Please ensure one calendar is Active.', HRLeaveCal.Count);

            HRLeaveAlloc.SetRange("No.", employeeNo);
            HRLeaveAlloc.SetRange("Calendar Code", HRLeaveCal.Code);
            HRLeaveAlloc.SetRange("Entry Type", HRLeaveAlloc."Entry Type"::"Negative Adjustment");
            HRLeaveAlloc.SetRange("Leave Type", leaveType);
            HRLeaveAlloc.SetRange("Posting Type", HRLeaveAlloc."Posting Type"::Normal);
            if HRLeaveAlloc.FindSet() then begin
                HRLeaveAlloc.CalcSums("No. Of days");
                CurrentTotalLeaveTaken := HRLeaveAlloc."No. Of days" * -1;
            end;

            HRLeaveAlloc.Reset();
            HRLeaveAlloc.SetRange("No.", employeeNo);
            HRLeaveAlloc.SetRange("Calendar Code", HRLeaveCal.Code);
            HRLeaveAlloc.SetRange("Leave Type", leaveType);
            HRLeaveAlloc.SetRange("Entry Type", HRLeaveAlloc."Entry Type"::"Positive Adjustment");
            HRLeaveAlloc.SetRange("Posting Type", HRLeaveAlloc."Posting Type"::Reimbursement);
            if HRLeaveAlloc.FindSet() then begin
                HRLeaveAlloc.CalcSums("No. Of days");
                ReimbursedDays := HRLeaveAlloc."No. Of days";
            end;

            HRLeaveAlloc.Reset();
            HRLeaveAlloc.SetRange("No.", employeeNo);
            HRLeaveAlloc.SetRange("Calendar Code", HRLeaveCal.Code);
            HRLeaveAlloc.SetRange("Entry Type", HRLeaveAlloc."Entry Type"::"Positive Adjustment");
            HRLeaveAlloc.SetRange("Leave Type", leaveType);
            HRLeaveAlloc.SetRange("Posting Type", HRLeaveAlloc."Posting Type"::Normal);
            if HRLeaveAlloc.FindSet() then begin
                HRLeaveAlloc.CalcSums("No. Of days");
                AllocatedDays := HRLeaveAlloc."No. Of days";
            end;

            HRLeaveAlloc.Reset();
            HRLeaveAlloc.SetRange("No.", employeeNo);
            HRLeaveAlloc.SetRange("Calendar Code", HRLeaveCal.Code);
            HRLeaveAlloc.SetRange("Leave Type", leaveType);
            HRLeaveAlloc.SetRange("Posting Type", HRLeaveAlloc."Posting Type"::"Carry Forward");
            if HRLeaveAlloc.FindSet() then begin
                HRLeaveAlloc.CalcSums("No. Of days");
                CarryForwardBalance := HRLeaveAlloc."No. Of days";
            end;
        end;

        // ABH production leave application flow uses Leave Type.Days when HR has not
        // generated a positive allocation row (notably Sick and other special types).
        // Returning zero here made the portal disagree with the BC application itself.
        if (AllocatedDays = 0) and (LeaveTypeSetup.Days > 0) then
            AllocatedDays := LeaveTypeSetup.Days;

        if IsAnnual then begin
            AllocatedDays := AnnualLeaveEntitlement;
            CarryForwardBalance := AnnualCarryForward;
            CurrentTotalLeaveTaken := AnnualTotalLeaveTakenToDate;
            CurrentLeaveBalance := AnnualAvailableLeaveBalance;
        end else
            CurrentLeaveBalance :=
              (AllocatedDays + ReimbursedDays + CarryForwardBalance) - CurrentTotalLeaveTaken;

        Result.Add('employeeNo', employeeNo);
        Result.Add('leaveType', leaveType);
        Result.Add('isAnnualLeave', IsAnnual);
        Result.Add('activeCalendarCode', HRLeaveCal.Code);
        Result.Add('allocatedDays', AllocatedDays);
        Result.Add('reimbursedDays', ReimbursedDays);
        Result.Add('carryForwardBalanceForType', CarryForwardBalance);
        Result.Add('currentTotalLeaveTaken', CurrentTotalLeaveTaken);
        Result.Add('currentLeaveBalance', CurrentLeaveBalance);
        Result.Add('cardAnnualLeaveBalance', AnnualCardBalance);
        Result.Add('accruedDays', AnnualAccruedDays);
        Result.Add('earnedLeaveDays', AnnualLeaveAccruedToDate);
        Result.Add('leaveAccruedToDate', AnnualLeaveAccruedToDate);
        Result.Add('carryForwardBalance', AnnualCarryForwardBalance);
        Result.Add('leaveEntitlement', AnnualLeaveEntitlement);
        Result.Add('carryForward', AnnualCarryForward);
        Result.Add('totalAvailableLeaveBalance', AnnualCardBalance);
        Result.Add('totalLeaveTakenToDate', AnnualTotalLeaveTakenToDate);
        Result.Add('availableLeaveBalance', AnnualAvailableLeaveBalance);
        Result.Add('applicationLimit', CurrentLeaveBalance);
        if LeaveTypeSetup.Get(leaveType) then begin
            Result.Add('setupDays', LeaveTypeSetup.Days);
            Result.Add('unlimitedDays', LeaveTypeSetup."Unlimited Days");
        end;
        Result.WriteTo(ResultText);
        return_value := ResultText;
        exit(return_value);
    end;

    local procedure ApplyPortalLeaveFields(var LeaveApp: Record "HR Leave Application"; employeeNo: Code[100]; leaveType: Code[30]; reason: Text[250]; daysApplied: Decimal; startDate: DateTime; endDate: DateTime; returnDate: DateTime; reliever: Code[30]; isRequestLeaveAllowance: Boolean; isHalfDayLeave: Boolean; myUserID: Code[30]; familyMember: Text[30]; deliveryDate: DateTime)
    var
        CalendarDays: Integer;
    begin
        AssertPortalLeaveEligibility(employeeNo, leaveType, Dt2Date(startDate));
        LeaveApp."Employee No." := employeeNo;
        LeaveApp.Validate("Employee No.");
        LeaveApp."User ID" := myUserID;
        LeaveApp."Leave Type" := leaveType;
        LeaveApp.Validate("Leave Type");
        LeaveApp."Reason for leave" := reason;

        // Maternity leave derives its dates from Delivery Date, mourning leave derives its
        // entitled days from Family Member via Mourning Leave Setup. Both stay untouched
        // for every other leave type.
        if Dt2Date(deliveryDate) <> 0D then begin
            LeaveApp."Delivery Date" := Dt2Date(deliveryDate);
            LeaveApp.Validate("Delivery Date");
        end;
        if familyMember <> '' then
            if Evaluate(LeaveApp."Family Member", familyMember) then
                LeaveApp.Validate("Family Member");

        // Clear Days Applied before Start Date validation so table OnValidate cannot
        // reject via the broken earned-days calculation on an empty draft.
        Clear(LeaveApp."Days Applied");
        LeaveApp."Start Date" := Dt2Date(startDate);
        LeaveApp.Validate("Start Date");

        if Dt2Date(deliveryDate) = 0D then begin
            CalendarDays := Round(daysApplied, 1, '>');
            if CalendarDays < 1 then
                CalendarDays := 1;
            LeaveApp."End Date" := LeaveApp."Start Date" + CalendarDays - 1;
        end else
            if (LeaveApp."End Date" = 0D) and (Dt2Date(endDate) <> 0D) then
                LeaveApp."End Date" := Dt2Date(endDate);

        ApplyPortalReturnDate(LeaveApp, returnDate, LeaveApp."End Date");
        if isHalfDayLeave then
            LeaveApp."Days Applied" := 0.5
        else
            LeaveApp."Days Applied" := daysApplied;

        AssertNoPortalLeaveDateOverlap(LeaveApp);
        PortalValidateDaysApplied(LeaveApp);
        LeaveApp.Reliever := reliever;
        LeaveApp.Validate(Reliever);
        LeaveApp."Request Leave Allowance" := isRequestLeaveAllowance;
    end;

    local procedure AssertPortalLeaveEligibility(employeeNo: Code[100]; leaveType: Code[30]; startDate: Date)
    var
        Employee: Record "HR-Employee";
    begin
        if not Employee.Get(employeeNo) then
            Error('Employee %1 was not found.', employeeNo);

        if PortalLeaveIsMarriage(leaveType) and
           (Employee."Marital Status" = Employee."Marital Status"::Married)
        then
            Error('Marriage leave is not available because the Employee Card is already marked Married.');

        if PortalLeaveIsSick(leaveType) and
           ((startDate < Today) or (startDate > Today + 1))
        then
            Error('Sick leave can only start today or tomorrow.');
    end;

    local procedure PortalLeaveIsMarriage(leaveType: Code[30]): Boolean
    var
        LeaveTypeSetup: Record "Leave Types";
        SearchText: Text;
    begin
        SearchText := UpperCase(leaveType);
        if LeaveTypeSetup.Get(leaveType) then
            SearchText += ' ' + UpperCase(LeaveTypeSetup.Description);
        exit((StrPos(SearchText, 'MARRIAGE') > 0) or (StrPos(SearchText, 'WEDDING') > 0));
    end;

    local procedure PortalLeaveIsSick(leaveType: Code[30]): Boolean
    var
        LeaveTypeSetup: Record "Leave Types";
        SearchText: Text;
    begin
        SearchText := UpperCase(leaveType);
        if LeaveTypeSetup.Get(leaveType) then
            SearchText += ' ' + UpperCase(LeaveTypeSetup.Description);
        exit(
            (StrPos(SearchText, 'SICK') > 0) or
            (StrPos(SearchText, 'MEDICAL') > 0) or
            (StrPos(SearchText, 'ILLNESS') > 0) or
            (StrPos(SearchText, 'HOSPITAL') > 0));
    end;

    local procedure AssertNoPortalLeaveDateOverlap(var LeaveApp: Record "HR Leave Application")
    var
        ExistingLeave: Record "HR Leave Application";
        ExistingEndDate: Date;
    begin
        if (LeaveApp."Start Date" = 0D) or (LeaveApp."End Date" = 0D) then
            exit;

        ExistingLeave.Reset();
        ExistingLeave.SetRange("Employee No.", LeaveApp."Employee No.");
        ExistingLeave.SetFilter(
            Status,
            '%1|%2|%3',
            ExistingLeave.Status::Open,
            ExistingLeave.Status::"Pending Approval",
            ExistingLeave.Status::Approved);
        ExistingLeave.SetFilter("Application Code", '<>%1', LeaveApp."Application Code");
        if ExistingLeave.FindSet() then
            repeat
                ExistingEndDate := ExistingLeave."End Date";
                if ExistingEndDate = 0D then
                    ExistingEndDate := ExistingLeave."Start Date";
                if (LeaveApp."Start Date" <= ExistingEndDate) and
                   (LeaveApp."End Date" >= ExistingLeave."Start Date")
                then
                    Error(
                        'These dates overlap leave application %1 (%2 to %3).',
                        ExistingLeave."Application Code",
                        ExistingLeave."Start Date",
                        ExistingEndDate);
            until ExistingLeave.Next() = 0;
    end;

    local procedure PortalValidateDaysApplied(var LeaveApp: Record "HR Leave Application")
    var
        HRLeaveCal: Record "HR Leave Calendar.";
        HRLeaveAlloc: Record "HR Leave Allocation";
        LeaveTypes: Record "Leave Types";
        HREmployee: Record "HR-Employee";
        LeaveEntitlement: Decimal;
        CarryForward: Decimal;
        TotalAvailableLeaveBalance: Decimal;
        LeaveAccruedToDate: Decimal;
        TotalLeaveTakenToDate: Decimal;
        AvailableLeaveBalance: Decimal;
        AccruedDays: Decimal;
        CarryForwardBalance: Decimal;
        IsAnnualLeave: Boolean;
    begin
        LeaveApp.TestField("Leave Type");

        Clear(LeaveApp."Reimbursed Days");
        Clear(LeaveApp."Allocated Days");
        Clear(LeaveApp."Carry Forward Balance");
        Clear(LeaveApp."Current Leave Balance");
        Clear(LeaveApp."Current Total Leave Taken");

        HRLeaveCal.Reset();
        HRLeaveCal.SetRange(Current, true);
        if not HRLeaveCal.FindFirst() then
            Error('No Leave Calendar Exists');
        if HRLeaveCal.Count > 1 then
            Error('No active calendar exists');

        HRLeaveAlloc.Reset();
        HRLeaveAlloc.SetRange("No.", LeaveApp."Employee No.");
        HRLeaveAlloc.SetRange("Entry Type", HRLeaveAlloc."Entry Type"::"Negative Adjustment");
        HRLeaveAlloc.SetRange("Leave Type", LeaveApp."Leave Type");
        HRLeaveAlloc.SetRange("Posting Type", HRLeaveAlloc."Posting Type"::Normal);
        if HRLeaveAlloc.FindSet() then begin
            HRLeaveAlloc.CalcSums("No. Of days");
            LeaveApp."Current Total Leave Taken" := (HRLeaveAlloc."No. Of days") * -1;
        end;

        HRLeaveAlloc.Reset();
        HRLeaveAlloc.SetRange("No.", LeaveApp."Employee No.");
        HRLeaveAlloc.SetRange("Leave Type", LeaveApp."Leave Type");
        HRLeaveAlloc.SetRange("Entry Type", HRLeaveAlloc."Entry Type"::"Positive Adjustment");
        HRLeaveAlloc.SetRange("Posting Type", HRLeaveAlloc."Posting Type"::Reimbursement);
        if HRLeaveAlloc.FindSet() then begin
            HRLeaveAlloc.CalcSums("No. Of days");
            LeaveApp."Reimbursed Days" := HRLeaveAlloc."No. Of days";
        end;

        HRLeaveAlloc.Reset();
        HRLeaveAlloc.SetRange("No.", LeaveApp."Employee No.");
        HRLeaveAlloc.SetRange("Entry Type", HRLeaveAlloc."Entry Type"::"Positive Adjustment");
        HRLeaveAlloc.SetRange("Leave Type", LeaveApp."Leave Type");
        HRLeaveAlloc.SetRange("Posting Type", HRLeaveAlloc."Posting Type"::Normal);
        if HRLeaveAlloc.FindSet() then begin
            HRLeaveAlloc.CalcSums("No. Of days");
            LeaveApp."Allocated Days" := HRLeaveAlloc."No. Of days";
        end;

        HRLeaveAlloc.Reset();
        HRLeaveAlloc.SetRange("No.", LeaveApp."Employee No.");
        HRLeaveAlloc.SetRange("Leave Type", LeaveApp."Leave Type");
        HRLeaveAlloc.SetRange("Posting Type", HRLeaveAlloc."Posting Type"::"Carry Forward");
        if HRLeaveAlloc.FindSet() then begin
            HRLeaveAlloc.CalcSums("No. Of days");
            LeaveApp."Carry Forward Balance" := HRLeaveAlloc."No. Of days";
        end;

        if LeaveTypes.Get(LeaveApp."Leave Type") then begin
            IsAnnualLeave := LeaveTypes.Annual or
                (UpperCase(LeaveTypes.Code) = 'ANNUAL') or
                (UpperCase(LeaveTypes.Code) = '0001') or
                (StrPos(UpperCase(LeaveTypes.Description), 'ANNUAL') > 0);
            if (LeaveApp."Allocated Days" = 0) and (LeaveTypes.Days > 0) then
                LeaveApp."Allocated Days" := LeaveTypes.Days;
        end;

        if IsAnnualLeave then begin
            if not HREmployee.Get(LeaveApp."Employee No.") then
                Error('Employee %1 was not found.', LeaveApp."Employee No.");
            CalculatePortalAnnualLeaveMetrics(
                HREmployee,
                LeaveEntitlement,
                CarryForward,
                TotalAvailableLeaveBalance,
                LeaveAccruedToDate,
                TotalLeaveTakenToDate,
                AvailableLeaveBalance,
                AccruedDays,
                CarryForwardBalance);
            LeaveApp."Allocated Days" := LeaveEntitlement;
            LeaveApp."Carry Forward" := CarryForward;
            LeaveApp."Carry Forward Balance" := CarryForwardBalance;
            LeaveApp."Current Total Leave Taken" := TotalLeaveTakenToDate;
            LeaveApp."Earned Leave Days" := LeaveAccruedToDate;
            // This is intentionally the accrued/application balance, not the
            // employee's larger full-year Total Available Leave Balance.
            LeaveApp."Current Leave Balance" := AvailableLeaveBalance;
        end else
            LeaveApp."Current Leave Balance" :=
                (LeaveApp."Allocated Days" + LeaveApp."Reimbursed Days" + LeaveApp."Carry Forward Balance") -
                LeaveApp."Current Total Leave Taken";

        if LeaveApp."Current Leave Balance" < LeaveApp."Days Applied" then
            Error('Your current leave balance is less than days applied');

        LeaveApp."Application Date" := Today;
    end;

    local procedure CalculatePortalAnnualLeaveBalance(var HREmployee: Record "HR-Employee"): Decimal
    var
        LeaveEntitlement: Decimal;
        CarryForward: Decimal;
        TotalAvailableLeaveBalance: Decimal;
        LeaveAccruedToDate: Decimal;
        TotalLeaveTakenToDate: Decimal;
        AvailableLeaveBalance: Decimal;
        AccruedDays: Decimal;
        CarryForwardBalance: Decimal;
    begin
        CalculatePortalAnnualLeaveMetrics(
            HREmployee,
            LeaveEntitlement,
            CarryForward,
            TotalAvailableLeaveBalance,
            LeaveAccruedToDate,
            TotalLeaveTakenToDate,
            AvailableLeaveBalance,
            AccruedDays,
            CarryForwardBalance);
        exit(TotalAvailableLeaveBalance);
    end;

    local procedure CalculatePortalAnnualLeaveMetrics(
        var HREmployee: Record "HR-Employee";
        var LeaveEntitlement: Decimal;
        var CarryForward: Decimal;
        var TotalAvailableLeaveBalance: Decimal;
        var LeaveAccruedToDate: Decimal;
        var TotalLeaveTakenToDate: Decimal;
        var AvailableLeaveBalance: Decimal;
        var AccruedDays: Decimal;
        var CarryForwardBalance: Decimal)
    begin
        // Read the same fields used by the ABH Employee Card. FlowFields are
        // recalculated here so SOAP does not depend on somebody opening the card.
        HREmployee.CalcFields("Current HR Calender");
        HREmployee.CalcFields(
            "Leave Allocation",
            "Carry forward",
            "Carry forward Balance",
            "Total Leave Taken");

        LeaveEntitlement := HREmployee."Leave Allocation";
        CarryForward := HREmployee."Carry forward";
        AccruedDays := HREmployee."Earned Leave Days";
        CarryForwardBalance := HREmployee."Carry forward Balance";
        TotalLeaveTakenToDate := Abs(HREmployee."Total Leave Taken");

        // Employee Card "Annual Leave balance": full-year entitlement remaining.
        TotalAvailableLeaveBalance :=
            LeaveEntitlement + CarryForward - TotalLeaveTakenToDate;
        if TotalAvailableLeaveBalance < 0 then
            TotalAvailableLeaveBalance := 0;

        // Employee Card "Leave Accrued To-Date".
        LeaveAccruedToDate := CarryForwardBalance + AccruedDays;
        if LeaveAccruedToDate < 0 then
            LeaveAccruedToDate := 0;

        // The employee can apply only up to what has accrued, while never
        // exceeding the remaining full-year balance.
        AvailableLeaveBalance := LeaveAccruedToDate;
        if TotalAvailableLeaveBalance < AvailableLeaveBalance then
            AvailableLeaveBalance := TotalAvailableLeaveBalance;
    end;

    procedure GetPurchaseProcurementProcess(requestNo: Code[50]) return_value: Text
    var
        ProcurementMgt: Codeunit "Portal Procurement Mgt.";
    begin
        exit(ProcurementMgt.GetProcess(requestNo));
    end;

    procedure UpdatePurchaseProcurementProcess(requestNo: Code[50]; actionCode: Text[50]; linkedDocumentNo: Code[50]; actionComment: Text[250]; actorUserID: Code[100]; actorJobTitle: Text[100]) return_value: Text
    var
        ProcurementMgt: Codeunit "Portal Procurement Mgt.";
    begin
        exit(ProcurementMgt.UpdateProcess(requestNo, actionCode, linkedDocumentNo, actionComment, actorUserID, actorJobTitle));
    end;

    procedure GetStoreRequisitionProcess(requestNo: Code[50]) return_value: Text
    var
        ProcurementMgt: Codeunit "Portal Procurement Mgt.";
    begin
        exit(ProcurementMgt.GetStoreProcess(requestNo));
    end;

    procedure UpdateStoreRequisitionProcess(requestNo: Code[50]; actionCode: Text[50]; linkedDocumentNo: Code[50]; actionComment: Text[250]; actorUserID: Code[100]; actorJobTitle: Text[100]) return_value: Text
    var
        ProcurementMgt: Codeunit "Portal Procurement Mgt.";
    begin
        exit(ProcurementMgt.UpdateStoreProcess(requestNo, actionCode, linkedDocumentNo, actionComment, actorUserID, actorJobTitle));
    end;

    local procedure ApplyPortalReturnDate(var LeaveApp: Record "HR Leave Application"; returnDate: DateTime; endDate: Date)
    var
        portalReturn: Date;
    begin
        if endDate = 0D then
            exit;

        // ABH production invariant: an employee returns on the calendar day
        // immediately after the final leave day.
        portalReturn := endDate + 1;
        LeaveApp."Return Date" := portalReturn;
    end;
}
