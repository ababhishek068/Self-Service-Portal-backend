codeunit 52100 "Portal Employee Exit Workflow"
{
    Permissions = tabledata "Approval Entry" = RIMD;

    procedure SendApprovalRequest(var ExitRequest: Record "Portal Employee Exit Request")
    begin
        ExitRequest.TestField(Status, ExitRequest.Status::Open);
        ExitRequest.ValidateForSubmission(not ExitRequest."Cancellation Requested");

        // The Employee Exit form is informational and does not enter approval.
        if (ExitRequest."Request Type" = ExitRequest."Request Type"::ExitInterview) and
           not ExitRequest."Cancellation Requested"
        then begin
            ExitRequest."Approval Required" := false;
            ExitRequest.Status := ExitRequest.Status::Completed;
            if ExitRequest."Submitted On" = 0DT then
                ExitRequest."Submitted On" := CurrentDateTime;
            ExitRequest.Modify(true);
            exit;
        end;

        ValidateRouting(ExitRequest);
        EnsureNoOpenApprovalEntry(ExitRequest);
        if not ExitRequest."Cancellation Requested" then begin
            Clear(ExitRequest."Supervisor Decision On");
            Clear(ExitRequest."Supervisor Decision By");
            Clear(ExitRequest."HR Decision On");
            Clear(ExitRequest."HR Decision By");
            Clear(ExitRequest."Rejected At Stage");
        end;
        if ExitRequest."Cancellation Requested" then
            ExitRequest.Status := ExitRequest.Status::CancellationPending
        else
            ExitRequest.Status := ExitRequest.Status::PendingApproval;
        if ExitRequest."Submitted On" = 0DT then
            ExitRequest."Submitted On" := CurrentDateTime;
        ExitRequest.Modify(true);

        CreateApprovalEntry(ExitRequest, ExitRequest."Supervisor User ID", 1);
    end;

    procedure CancelApprovalRequest(var ExitRequest: Record "Portal Employee Exit Request")
    begin
        if not (ExitRequest.Status in [
            ExitRequest.Status::PendingApproval,
            ExitRequest.Status::PendingHRApproval,
            ExitRequest.Status::CancellationPending])
        then
            Error('Only a pending Employee Exit approval request can be cancelled.');

        CancelOpenApprovalEntries(ExitRequest);
        if ExitRequest."Cancellation Requested" then begin
            ExitRequest."Cancellation Requested" := false;
            Clear(ExitRequest."Cancellation Reason");
            ExitRequest.Status := ExitRequest.Status::Approved;
        end else
            ExitRequest.Status := ExitRequest.Status::Open;
        ExitRequest.Modify(true);
    end;

    procedure ApproveRequest(var ExitRequest: Record "Portal Employee Exit Request")
    begin
        DecideAssignedApproval(ExitRequest, true, UserId, '');
    end;

    procedure RejectRequest(var ExitRequest: Record "Portal Employee Exit Request")
    begin
        DecideAssignedApproval(ExitRequest, false, UserId, '');
    end;

    /// <summary>
    /// Decide as a specific approver (used by the Self-Service Portal, where the SOAP session
    /// runs as the service account, not the real approver). The acting user must be the assigned
    /// approver of the current open stage. Remarks are stored so the employee can see the reason.
    /// </summary>
    procedure ApproveRequestAs(var ExitRequest: Record "Portal Employee Exit Request"; ActingUserIds: Text; Remarks: Text[250])
    begin
        DecideAssignedApproval(ExitRequest, true, ActingUserIds, Remarks);
    end;

    procedure RejectRequestAs(var ExitRequest: Record "Portal Employee Exit Request"; ActingUserIds: Text; Remarks: Text[250])
    begin
        DecideAssignedApproval(ExitRequest, false, ActingUserIds, Remarks);
    end;

    /// <summary>
    /// Stage-2 approval entries can be missing when the header advanced to Pending HR Approval
    /// before the workflow subscriber was published. Recreate the open HR entry on demand.
    /// </summary>
    procedure EnsureHrApprovalEntryIfMissing(var ExitRequest: Record "Portal Employee Exit Request")
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        if ExitRequest."HR Decision By" <> '' then
            exit;
        if not IsHrApprovalStage(ExitRequest) then
            exit;

        ApprovalEntry.SetRange("Record ID to Approve", ExitRequest.RecordId);
        ApprovalEntry.SetRange("Sequence No.", 2);
        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Open);
        if ApprovalEntry.IsEmpty() then begin
            if ExitRequest.Status = ExitRequest.Status::PendingApproval then begin
                ExitRequest.Status := ExitRequest.Status::PendingHRApproval;
                ExitRequest.Modify(true);
            end;
            CreateApprovalEntry(ExitRequest, ExitRequest."HR Approver User ID", 2);
        end;
    end;

    /// <summary>
    /// When the supervisor already approved in Approval Entry but the exit header still shows
    /// Pending Approval, sync the header so HR decisions target stage 2.
    /// </summary>
    procedure SyncHeaderFromApprovalEntries(var ExitRequest: Record "Portal Employee Exit Request")
    var
        Stage1: Record "Approval Entry";
    begin
        Stage1.SetRange("Record ID to Approve", ExitRequest.RecordId);
        Stage1.SetRange("Sequence No.", 1);
        Stage1.SetRange(Status, Stage1.Status::Approved);
        if not Stage1.FindFirst() then
            exit;
        if ExitRequest."Supervisor Decision By" = '' then begin
            ExitRequest."Supervisor Decision By" := Stage1."Approver ID";
            ExitRequest."Supervisor Decision On" := Stage1."Last Date-Time Modified";
        end;
        if ExitRequest.Status = ExitRequest.Status::PendingApproval then
            ExitRequest.Status := ExitRequest.Status::PendingHRApproval;
        ExitRequest.Modify(true);
    end;

    procedure CompleteRequest(var ExitRequest: Record "Portal Employee Exit Request")
    begin
        ExitRequest.TestField(Status, ExitRequest.Status::Approved);
        ExitRequest.Status := ExitRequest.Status::Completed;
        ExitRequest.Modify(true);
    end;

    procedure WithdrawRequest(var ExitRequest: Record "Portal Employee Exit Request")
    begin
        if not (ExitRequest.Status in [
            ExitRequest.Status::Open,
            ExitRequest.Status::PendingApproval,
            ExitRequest.Status::PendingHRApproval])
        then
            Error(
              'This request can no longer be withdrawn because it is already %1.',
              Format(ExitRequest.Status));

        CancelOpenApprovalEntries(ExitRequest);
        ExitRequest."Cancellation Requested" := false;
        Clear(ExitRequest."Cancellation Reason");
        ExitRequest.Status := ExitRequest.Status::Cancelled;
        ExitRequest."Cancelled On" := CurrentDateTime;
        ExitRequest.Modify(true);
    end;

    procedure RequestCancellation(var ExitRequest: Record "Portal Employee Exit Request"; CancellationReason: Text[250])
    begin
        if not (ExitRequest."Request Type" in [ExitRequest."Request Type"::Transfer, ExitRequest."Request Type"::Resignation]) then
            Error('Cancellation is available only for Transfer and Resignation requests.');
        SyncHeaderFromApprovalEntries(ExitRequest);
        if ExitRequest.Status <> ExitRequest.Status::Approved then
            Error(
              'Cancellation is only available after the request is fully approved. Current status is %1.',
              ExitRequest.Status);
        if StrLen(DelChr(CancellationReason, '=', ' ')) < 10 then
            Error('Cancellation Reason must contain at least 10 characters.');

        ExitRequest."Cancellation Requested" := true;
        ExitRequest."Cancellation Reason" := CancellationReason;
        ExitRequest.Status := ExitRequest.Status::Open;
        ExitRequest.Modify(true);
        // Stale Open entries from the original approval block a new cancellation workflow.
        CancelOpenApprovalEntries(ExitRequest);
        SendApprovalRequest(ExitRequest);
    end;

    local procedure ValidateRouting(ExitRequest: Record "Portal Employee Exit Request")
    var
        RequesterSetup: Record "User Setup";
        SupervisorSetup: Record "User Setup";
        HrSetup: Record "User Setup";
    begin
        ExitRequest.TestField("Requester User ID");
        ExitRequest.TestField("Supervisor User ID");
        ExitRequest.TestField("HR Approver User ID");
        if not RequesterSetup.Get(ExitRequest."Requester User ID") then
            Error('Business Central User Setup was not found for requester %1.', ExitRequest."Requester User ID");
        if not SupervisorSetup.Get(ExitRequest."Supervisor User ID") then
            Error('Business Central User Setup was not found for Immediate Supervisor %1.', ExitRequest."Supervisor User ID");
        if not HrSetup.Get(ExitRequest."HR Approver User ID") then
            Error('Business Central User Setup was not found for HR approver %1.', ExitRequest."HR Approver User ID");
        if ExitRequest."Requester User ID" = ExitRequest."Supervisor User ID" then
            Error('The requester cannot be their own Immediate Supervisor.');
        if ExitRequest."Supervisor User ID" = ExitRequest."HR Approver User ID" then
            Error('The Immediate Supervisor and HR approver must be different users.');
    end;

    local procedure CreateApprovalEntry(ExitRequest: Record "Portal Employee Exit Request"; ApproverUserId: Code[50]; SequenceNo: Integer)
    var
        ApprovalEntry: Record "Approval Entry";
        LastApprovalEntry: Record "Approval Entry";
        NextEntryNo: Integer;
    begin
        if ApproverUserId = '' then
            Error('Approval stage %1 does not have an assigned approver.', SequenceNo);

        ApprovalEntry.Reset();
        ApprovalEntry.SetRange("Record ID to Approve", ExitRequest.RecordId);
        ApprovalEntry.SetRange("Sequence No.", SequenceNo);
        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Open);
        if ApprovalEntry.FindFirst() then
            Error('An open approval entry already exists for stage %1.', SequenceNo);

        LastApprovalEntry.LockTable();
        if LastApprovalEntry.FindLast() then
            NextEntryNo := LastApprovalEntry."Entry No." + 1
        else
            NextEntryNo := 1;

        ApprovalEntry.Init();
        ApprovalEntry."Entry No." := NextEntryNo;
        ApprovalEntry."Table ID" := Database::"Portal Employee Exit Request";
        ApprovalEntry."Document No." := ExitRequest."No.";
        ApprovalEntry."Sequence No." := SequenceNo;
        // Keep the standard Approval Entry queue easy to audit: Transfer and Resignation
        // share the same sequential engine, but each request type has its own approval code.
        ApprovalEntry."Approval Code" := ApprovalCodeFor(ExitRequest);
        ApprovalEntry."Sender ID" := ExitRequest."Requester User ID";
        ApprovalEntry."Approver ID" := ApproverUserId;
        ApprovalEntry.Status := ApprovalEntry.Status::Open;
        ApprovalEntry."Date-Time Sent for Approval" := CurrentDateTime;
        ApprovalEntry."Record ID to Approve" := ExitRequest.RecordId;
        ApprovalEntry.Insert(true);
    end;

    local procedure ApprovalCodeFor(ExitRequest: Record "Portal Employee Exit Request"): Code[20]
    begin
        case ExitRequest."Request Type" of
            ExitRequest."Request Type"::Transfer:
                exit('PORTAL-EMP-TRANSFER');
            ExitRequest."Request Type"::Resignation:
                exit('PORTAL-EMP-RESIGN');
            else
                exit('PORTAL-EMP-EXIT');
        end;
    end;

    local procedure EnsureNoOpenApprovalEntry(ExitRequest: Record "Portal Employee Exit Request")
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        ApprovalEntry.SetRange("Record ID to Approve", ExitRequest.RecordId);
        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Open);
        if ApprovalEntry.FindFirst() then
            Error('Employee Exit request %1 already has an open approval entry.', ExitRequest."No.");
    end;

    local procedure CancelOpenApprovalEntries(ExitRequest: Record "Portal Employee Exit Request")
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        ApprovalEntry.SetRange("Record ID to Approve", ExitRequest.RecordId);
        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Open);
        if ApprovalEntry.FindSet(true) then
            repeat
                ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                ApprovalEntry."Last Modified By User ID" := CopyStr(UserId, 1, MaxStrLen(ApprovalEntry."Last Modified By User ID"));
                ApprovalEntry.Modify(true);
            until ApprovalEntry.Next() = 0;
    end;

    local procedure DecideAssignedApproval(var ExitRequest: Record "Portal Employee Exit Request"; Approve: Boolean; ActingUserIds: Text; Remarks: Text[250])
    var
        ApprovalEntry: Record "Approval Entry";
        ExpectedSequence: Integer;
    begin
        if DelChr(ActingUserIds, '=', ' ') = '' then
            Error('An approver User ID is required to decide this request.');
        if not (ExitRequest.Status in [
            ExitRequest.Status::PendingApproval,
            ExitRequest.Status::PendingHRApproval,
            ExitRequest.Status::CancellationPending])
        then
            Error('Only a pending Employee Exit request can be decided.');

        ExpectedSequence := CurrentApprovalSequence(ExitRequest);
        if ExpectedSequence = 2 then
            EnsureHrApprovalEntryIfMissing(ExitRequest);

        ApprovalEntry.SetRange("Record ID to Approve", ExitRequest.RecordId);
        ApprovalEntry.SetRange("Sequence No.", ExpectedSequence);
        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Open);
        if not ApprovalEntry.FindFirst() then begin
            if ExpectedSequence = 2 then begin
                if not IdInList(ExitRequest."HR Approver User ID", ActingUserIds) then
                    Error('This approval is assigned to %1, and not to the signed-in user.', ExitRequest."HR Approver User ID");
                EnsureHrApprovalEntryIfMissing(ExitRequest);
                ApprovalEntry.Reset();
                ApprovalEntry.SetRange("Record ID to Approve", ExitRequest.RecordId);
                ApprovalEntry.SetRange("Sequence No.", ExpectedSequence);
                ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Open);
                if not ApprovalEntry.FindFirst() then
                    Error('No open approval entry was found for stage %1.', ExpectedSequence);
            end else
                Error('No open approval entry was found for stage %1.', ExpectedSequence);
        end;
        // The portal login ID does not always equal the stored Approver ID (a user can have more
        // than one User Setup record), so the caller passes every candidate ID, pipe-separated.
        if not IdInList(ApprovalEntry."Approver ID", ActingUserIds) then
            Error('This approval is assigned to %1, and not to the signed-in user.', ApprovalEntry."Approver ID");

        // Record the approver note first so it is already persisted when the OnAfterModify
        // subscriber advances the request to the next stage / final status.
        if Remarks <> '' then begin
            ExitRequest."Decision Remarks" := CopyStr(Remarks, 1, MaxStrLen(ExitRequest."Decision Remarks"));
            ExitRequest.Modify(true);
        end;

        ApprovalEntry."Last Modified By User ID" := CopyStr(ApprovalEntry."Approver ID", 1, MaxStrLen(ApprovalEntry."Last Modified By User ID"));
        if Approve then
            ApprovalEntry.Status := ApprovalEntry.Status::Approved
        else
            ApprovalEntry.Status := ApprovalEntry.Status::Rejected;
        ApprovalEntry.Modify(true);
    end;

    /// <summary>True when TargetId equals one of the pipe-separated ids in the list (case-insensitive).</summary>
    local procedure IsHrApprovalStage(ExitRequest: Record "Portal Employee Exit Request"): Boolean
    var
        Stage1: Record "Approval Entry";
    begin
        if ExitRequest.Status = ExitRequest.Status::PendingHRApproval then
            exit(true);
        if (ExitRequest.Status = ExitRequest.Status::PendingApproval) and
           (ExitRequest."Supervisor Decision By" <> '') and
           (ExitRequest."HR Decision By" = '')
        then
            exit(true);

        // Header can stay Pending Approval after the supervisor already approved in BC.
        Stage1.SetRange("Record ID to Approve", ExitRequest.RecordId);
        Stage1.SetRange("Sequence No.", 1);
        Stage1.SetRange(Status, Stage1.Status::Approved);
        if Stage1.FindFirst() and (ExitRequest."HR Decision By" = '') then
            exit(true);
        exit(false);
    end;

    local procedure CurrentApprovalSequence(ExitRequest: Record "Portal Employee Exit Request"): Integer
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        if IsHrApprovalStage(ExitRequest) then
            exit(2);
        if ExitRequest.Status = ExitRequest.Status::CancellationPending then begin
            ApprovalEntry.SetRange("Record ID to Approve", ExitRequest.RecordId);
            ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Open);
            if ApprovalEntry.FindFirst() then
                exit(ApprovalEntry."Sequence No.");
        end;
        exit(1);
    end;

    local procedure IdInList(TargetId: Code[50]; DelimitedList: Text): Boolean
    var
        Remaining: Text;
        Part: Text;
        SepPos: Integer;
        Target: Text;
    begin
        Target := UpperCase(DelChr(Format(TargetId), '<>', ' '));
        if Target = '' then
            exit(false);
        Remaining := DelimitedList;
        while Remaining <> '' do begin
            SepPos := StrPos(Remaining, '|');
            if SepPos = 0 then begin
                Part := Remaining;
                Remaining := '';
            end else begin
                Part := CopyStr(Remaining, 1, SepPos - 1);
                Remaining := CopyStr(Remaining, SepPos + 1);
            end;
            if UpperCase(DelChr(Part, '<>', ' ')) = Target then
                exit(true);
        end;
        exit(false);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Approval Entry", 'OnAfterModifyEvent', '', false, false)]
    local procedure SynchronizeApprovalDecision(var Rec: Record "Approval Entry"; var xRec: Record "Approval Entry"; RunTrigger: Boolean)
    var
        ExitRequest: Record "Portal Employee Exit Request";
        ExitRequestRef: RecordRef;
    begin
        if Rec."Table ID" <> Database::"Portal Employee Exit Request" then
            exit;
        if Rec.Status = xRec.Status then
            exit;
        if not (Rec.Status in [Rec.Status::Approved, Rec.Status::Rejected]) then
            exit;

        if not ExitRequestRef.Get(Rec."Record ID to Approve") then
            exit;
        ExitRequestRef.SetTable(ExitRequest);
        ProcessApprovalDecision(ExitRequest, Rec);
    end;

    local procedure ProcessApprovalDecision(var ExitRequest: Record "Portal Employee Exit Request"; ApprovalEntry: Record "Approval Entry")
    begin
        if ApprovalEntry.Status = ApprovalEntry.Status::Rejected then begin
            ProcessRejection(ExitRequest, ApprovalEntry);
            exit;
        end;

        if ExitRequest."Cancellation Requested" then begin
            ProcessCancellationApproval(ExitRequest, ApprovalEntry);
            exit;
        end;

        case ApprovalEntry."Sequence No." of
            1:
                begin
                    if not (ExitRequest.Status in [
                        ExitRequest.Status::Open,
                        ExitRequest.Status::PendingApproval])
                    then
                        exit;
                    ExitRequest."Supervisor Decision On" := CurrentDateTime;
                    ExitRequest."Supervisor Decision By" := ApprovalEntry."Approver ID";
                    ExitRequest.Status := ExitRequest.Status::PendingHRApproval;
                    ExitRequest.Modify(true);
                    CreateApprovalEntry(ExitRequest, ExitRequest."HR Approver User ID", 2);
                end;
            2:
                begin
                    // Header can lag at Pending Approval when stage 1 already closed in Approval Entry.
                    if not (ExitRequest.Status in [
                        ExitRequest.Status::PendingApproval,
                        ExitRequest.Status::PendingHRApproval])
                    then
                        exit;
                    ExitRequest."HR Decision On" := CurrentDateTime;
                    ExitRequest."HR Decision By" := ApprovalEntry."Approver ID";
                    ExitRequest.Status := ExitRequest.Status::Approved;
                    ExitRequest.Modify(true);
                end;
        end;
    end;

    local procedure ProcessRejection(var ExitRequest: Record "Portal Employee Exit Request"; ApprovalEntry: Record "Approval Entry")
    begin
        if ExitRequest."Cancellation Requested" then begin
            ExitRequest."Cancellation Requested" := false;
            Clear(ExitRequest."Cancellation Reason");
            ExitRequest.Status := ExitRequest.Status::Approved;
        end else begin
            ExitRequest.Status := ExitRequest.Status::Rejected;
            if ApprovalEntry."Sequence No." = 1 then begin
                ExitRequest."Supervisor Decision On" := CurrentDateTime;
                ExitRequest."Supervisor Decision By" := ApprovalEntry."Approver ID";
                ExitRequest."Rejected At Stage" := 'Immediate Supervisor';
            end else begin
                ExitRequest."HR Decision On" := CurrentDateTime;
                ExitRequest."HR Decision By" := ApprovalEntry."Approver ID";
                ExitRequest."Rejected At Stage" := 'HR';
            end;
        end;
        CancelOpenApprovalEntries(ExitRequest);
        ExitRequest.Modify(true);
    end;

    local procedure ProcessCancellationApproval(var ExitRequest: Record "Portal Employee Exit Request"; ApprovalEntry: Record "Approval Entry")
    begin
        if ApprovalEntry."Sequence No." = 1 then begin
            ExitRequest."Supervisor Decision On" := CurrentDateTime;
            ExitRequest."Supervisor Decision By" := ApprovalEntry."Approver ID";
            ExitRequest.Modify(true);
            CreateApprovalEntry(ExitRequest, ExitRequest."HR Approver User ID", 2);
            exit;
        end;
        if ApprovalEntry."Sequence No." <> 2 then
            exit;

        ExitRequest."HR Decision On" := CurrentDateTime;
        ExitRequest."HR Decision By" := ApprovalEntry."Approver ID";
        ExitRequest."Cancellation Requested" := false;
        ExitRequest.Status := ExitRequest.Status::Cancelled;
        ExitRequest."Cancelled On" := CurrentDateTime;
        ExitRequest.Modify(true);
    end;
}
