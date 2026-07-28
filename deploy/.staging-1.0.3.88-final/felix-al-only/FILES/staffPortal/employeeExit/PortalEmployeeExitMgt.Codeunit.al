codeunit 52101 "Portal Employee Exit Mgt."
{
    procedure SaveEmployeeExitRequest(EmployeeNo: Code[20]; RequestType: Text[30]; DetailsJson: Text): Code[20]
    begin
        // Backward-compatible entry point for an older portal. New SSP builds call the routed
        // method below so approval is always based on the employee's real BC User Setup.
        exit(SaveEmployeeExitRequestRouted(EmployeeNo, CopyStr(UserId, 1, 50), RequestType, DetailsJson));
    end;

    procedure SaveEmployeeExitRequestRouted(EmployeeNo: Code[20]; RequesterUserId: Code[50]; RequestType: Text[30]; DetailsJson: Text): Code[20]
    var
        ExitRequest: Record "Portal Employee Exit Request";
        ExistingRequest: Record "Portal Employee Exit Request";
        Details: JsonObject;
    begin
        if not Details.ReadFrom(DetailsJson) then
            Error('Employee Exit request details are not valid JSON.');

        ExitRequest.Init();
        SetRequestType(ExitRequest, RequestType);
        ExistingRequest.SetRange("Employee No.", EmployeeNo);
        ExistingRequest.SetRange("Request Type", ExitRequest."Request Type");
        ExistingRequest.SetFilter(
            Status,
            '%1|%2|%3|%4',
            ExistingRequest.Status::Open,
            ExistingRequest.Status::PendingApproval,
            ExistingRequest.Status::PendingHRApproval,
            ExistingRequest.Status::CancellationPending);
        if ExistingRequest.FindFirst() then begin
            if ExistingRequest.Status <> ExistingRequest.Status::Open then
                Error('Employee %1 already has an active %2.', EmployeeNo, Format(ExitRequest."Request Type"));
            ExitRequest := ExistingRequest;
            ApplyEmployeeDetails(ExitRequest, EmployeeNo, Details);
            ApplyRequestDetails(ExitRequest, Details);
            ApplyApprovalRouting(ExitRequest, RequesterUserId);
            ExitRequest.ValidateForSubmission(true);
            ExitRequest.Modify(true);
            exit(ExitRequest."No.");
        end;

        ApplyEmployeeDetails(ExitRequest, EmployeeNo, Details);
        ApplyRequestDetails(ExitRequest, Details);
        ApplyApprovalRouting(ExitRequest, RequesterUserId);
        ExitRequest.ValidateForSubmission(true);
        ExitRequest.Insert(true);
        exit(ExitRequest."No.");
    end;

    procedure GetEmployeeExitRequests(EmployeeNo: Code[20]): Text
    var
        ExitRequest: Record "Portal Employee Exit Request";
        Rows: JsonArray;
        Row: JsonObject;
        Result: Text;
    begin
        ExitRequest.SetRange("Employee No.", EmployeeNo);
        ExitRequest.SetCurrentKey("Employee No.", "Request Type", Status);
        if ExitRequest.FindSet() then
            repeat
                Clear(Row);
                AddRequestJson(Row, ExitRequest);
                Rows.Add(Row);
            until ExitRequest.Next() = 0;
        Rows.WriteTo(Result);
        exit(Result);
    end;

    procedure SubmitEmployeeExitForApproval(EmployeeNo: Code[20]; RequestNo: Code[20]): Boolean
    var
        ExitRequest: Record "Portal Employee Exit Request";
        ExitWorkflow: Codeunit "Portal Employee Exit Workflow";
    begin
        GetEmployeeRequest(ExitRequest, EmployeeNo, RequestNo);
        ExitWorkflow.SendApprovalRequest(ExitRequest);
        exit(true);
    end;

    procedure CancelEmployeeExitApproval(EmployeeNo: Code[20]; RequestNo: Code[20]): Boolean
    var
        ExitRequest: Record "Portal Employee Exit Request";
        ExitWorkflow: Codeunit "Portal Employee Exit Workflow";
    begin
        GetEmployeeRequest(ExitRequest, EmployeeNo, RequestNo);
        ExitWorkflow.CancelApprovalRequest(ExitRequest);
        exit(true);
    end;

    procedure RequestEmployeeExitCancellation(EmployeeNo: Code[20]; RequestNo: Code[20]; CancellationReason: Text[250]): Boolean
    var
        ExitRequest: Record "Portal Employee Exit Request";
        ExitWorkflow: Codeunit "Portal Employee Exit Workflow";
    begin
        GetEmployeeRequest(ExitRequest, EmployeeNo, RequestNo);
        ExitWorkflow.RequestCancellation(ExitRequest, CancellationReason);
        exit(true);
    end;

    /// <summary>Withdraw a request that is still Open or Pending Approval (not yet approved).</summary>
    procedure WithdrawEmployeeExitRequest(EmployeeNo: Code[20]; RequestNo: Code[20]): Boolean
    var
        ExitRequest: Record "Portal Employee Exit Request";
        ExitWorkflow: Codeunit "Portal Employee Exit Workflow";
    begin
        GetEmployeeRequest(ExitRequest, EmployeeNo, RequestNo);
        ExitWorkflow.WithdrawRequest(ExitRequest);
        exit(true);
    end;

    /// <summary>Return one Employee Exit request as JSON (used by the portal approver queue).</summary>
    procedure GetEmployeeExitRequestByNo(RequestNo: Code[20]): Text
    var
        ExitRequest: Record "Portal Employee Exit Request";
        Rows: JsonArray;
        Row: JsonObject;
        Result: Text;
    begin
        if ExitRequest.Get(RequestNo) then begin
            Clear(Row);
            AddRequestJson(Row, ExitRequest);
            Rows.Add(Row);
        end;
        Rows.WriteTo(Result);
        exit(Result);
    end;

    /// <summary>Transfer / Resignation requests with an OPEN approval entry for this approver.</summary>
    procedure GetEmployeeExitApprovals(ApproverUserIds: Text): Text
    var
        ExitRequest: Record "Portal Employee Exit Request";
        ApprovalEntry: Record "Approval Entry";
        Rows: JsonArray;
        Row: JsonObject;
        Result: Text;
    begin
        if DelChr(ApproverUserIds, '=', ' ') <> '' then begin
            ApprovalEntry.SetRange("Table ID", Database::"Portal Employee Exit Request");
            ApprovalEntry.SetFilter("Approver ID", ApproverUserIds);
            ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Open);
            if ApprovalEntry.FindSet() then
                repeat
                    if ExitRequest.Get(ApprovalEntry."Document No.") then begin
                        Clear(Row);
                        AddRequestJson(Row, ExitRequest);
                        Row.Add('pendingStage', ApprovalEntry."Sequence No.");
                        Row.Add('pendingStageLabel', StageLabel(ApprovalEntry."Sequence No."));
                        Rows.Add(Row);
                    end;
                until ApprovalEntry.Next() = 0;

            // Header can be Pending HR Approval while the stage-2 Open entry is missing.
            ExitRequest.Reset();
            ExitRequest.SetRange(Status, ExitRequest.Status::PendingHRApproval);
            if ExitRequest.FindSet() then
                repeat
                    if ApproverIdInList(ExitRequest."HR Approver User ID", ApproverUserIds) then begin
                        Clear(Row);
                        AddRequestJson(Row, ExitRequest);
                        Row.Add('pendingStage', 2);
                        Row.Add('pendingStageLabel', StageLabel(2));
                        Rows.Add(Row);
                    end;
                until ExitRequest.Next() = 0;

            // Supervisor approved in BC but the header status never advanced to Pending HR Approval.
            ExitRequest.Reset();
            ExitRequest.SetRange(Status, ExitRequest.Status::PendingApproval);
            if ExitRequest.FindSet() then
                repeat
                    if (ExitRequest."Supervisor Decision By" <> '') and (ExitRequest."HR Decision By" = '') then
                        if ApproverIdInList(ExitRequest."HR Approver User ID", ApproverUserIds) then begin
                            Clear(Row);
                            AddRequestJson(Row, ExitRequest);
                            Row.Add('pendingStage', 2);
                            Row.Add('pendingStageLabel', StageLabel(2));
                            Rows.Add(Row);
                        end;
                until ExitRequest.Next() = 0;
        end;
        Rows.WriteTo(Result);
        exit(Result);
    end;

    /// <summary>Approve or reject as the logged-in approver (portal passes the real BC user id).</summary>
    procedure DecideEmployeeExitApproval(ApproverUserIds: Text; RequestNo: Code[20]; Approve: Boolean; Remarks: Text[250]): Boolean
    var
        ExitRequest: Record "Portal Employee Exit Request";
        ExitWorkflow: Codeunit "Portal Employee Exit Workflow";
    begin
        if DelChr(ApproverUserIds, '=', ' ') = '' then
            Error('An approver User ID is required.');
        if not ExitRequest.Get(RequestNo) then
            Error('Employee Exit request %1 was not found.', RequestNo);
        if (not Approve) and (DelChr(Remarks, '=', ' ') = '') then
            Error('A reason is required to reject a request.');
        ExitWorkflow.SyncHeaderFromApprovalEntries(ExitRequest);
        ExitWorkflow.EnsureHrApprovalEntryIfMissing(ExitRequest);
        if Approve then
            ExitWorkflow.ApproveRequestAs(ExitRequest, ApproverUserIds, Remarks)
        else
            ExitWorkflow.RejectRequestAs(ExitRequest, ApproverUserIds, Remarks);
        exit(true);
    end;

    local procedure StageLabel(SequenceNo: Integer): Text
    begin
        case SequenceNo of
            1:
                exit('Immediate Supervisor');
            2:
                exit('HR');
            else
                exit('Approval');
        end;
    end;

    local procedure ApproverIdInList(TargetId: Code[50]; DelimitedList: Text): Boolean
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

    local procedure GetEmployeeRequest(var ExitRequest: Record "Portal Employee Exit Request"; EmployeeNo: Code[20]; RequestNo: Code[20])
    begin
        if not ExitRequest.Get(RequestNo) then
            Error('Employee Exit request %1 was not found.', RequestNo);
        if ExitRequest."Employee No." <> EmployeeNo then
            Error('Employee %1 is not allowed to access request %2.', EmployeeNo, RequestNo);
    end;

    local procedure SetRequestType(var ExitRequest: Record "Portal Employee Exit Request"; RequestType: Text[30])
    begin
        case LowerCase(RequestType) of
            'transfer':
                ExitRequest."Request Type" := ExitRequest."Request Type"::Transfer;
            'resignation':
                ExitRequest."Request Type" := ExitRequest."Request Type"::Resignation;
            'exit-interview':
                ExitRequest."Request Type" := ExitRequest."Request Type"::ExitInterview;
            else
                Error('Employee Exit request type %1 is not supported.', RequestType);
        end;
    end;

    local procedure ApplyRequestDetails(var ExitRequest: Record "Portal Employee Exit Request"; Details: JsonObject)
    begin
        case ExitRequest."Request Type" of
            ExitRequest."Request Type"::Transfer:
                begin
                    ExitRequest."Desired Department" := CopyStr(GetJsonText(Details, 'desiredDepartment'), 1, MaxStrLen(ExitRequest."Desired Department"));
                    ExitRequest."Desired Location" := CopyStr(GetJsonText(Details, 'desiredLocation'), 1, MaxStrLen(ExitRequest."Desired Location"));
                    // UAT 25/07/2026: the portal transfer form sends typeOfTransfer; older builds sent transferType.
                    ExitRequest."Transfer Type" := CopyStr(GetJsonText(Details, 'typeOfTransfer'), 1, MaxStrLen(ExitRequest."Transfer Type"));
                    if ExitRequest."Transfer Type" = '' then
                        ExitRequest."Transfer Type" := CopyStr(GetJsonText(Details, 'transferType'), 1, MaxStrLen(ExitRequest."Transfer Type"));
                    Clear(ExitRequest."Transfer Duration");
                    ExitRequest."Requested Effective Date" := GetJsonDate(Details, 'requestedEffectiveDate');
                    ExitRequest."Transfer Reason" := CopyStr(GetJsonText(Details, 'reason'), 1, MaxStrLen(ExitRequest."Transfer Reason"));
                    ExitRequest."Transfer Handover Plan" := CopyStr(GetJsonText(Details, 'handoverPlan'), 1, MaxStrLen(ExitRequest."Transfer Handover Plan"));
                    ExitRequest."Transfer Supporting Info" := CopyStr(GetJsonText(Details, 'supportingInformation'), 1, MaxStrLen(ExitRequest."Transfer Supporting Info"));
                end;
            ExitRequest."Request Type"::Resignation:
                begin
                    ExitRequest."Proposed Last Working Date" := GetJsonDate(Details, 'lastWorkingDate');
                    ExitRequest."Resignation Reason" := CopyStr(GetJsonText(Details, 'resignationReason'), 1, MaxStrLen(ExitRequest."Resignation Reason"));
                    ExitRequest."Notice Acknowledged" := GetJsonBoolean(Details, 'noticePeriodAcknowledged');
                    ExitRequest."Resignation Handover Plan" := CopyStr(GetJsonText(Details, 'handoverPlan'), 1, MaxStrLen(ExitRequest."Resignation Handover Plan"));
                    ExitRequest."Personal Email" := CopyStr(GetJsonText(Details, 'personalEmail'), 1, MaxStrLen(ExitRequest."Personal Email"));
                    ExitRequest."Personal Phone" := CopyStr(GetJsonText(Details, 'personalPhone'), 1, MaxStrLen(ExitRequest."Personal Phone"));
                    ExitRequest."Forwarding Address" := CopyStr(GetJsonText(Details, 'forwardingAddress'), 1, MaxStrLen(ExitRequest."Forwarding Address"));
                    ExitRequest."Company Property Notes" := CopyStr(GetJsonText(Details, 'companyPropertyNotes'), 1, MaxStrLen(ExitRequest."Company Property Notes"));
                end;
            ExitRequest."Request Type"::ExitInterview:
                begin
                    // Hijra Bank's 17-07-2026 Employee Exit SSP template.
                    ExitRequest."Supervisor Name" := CopyStr(GetJsonText(Details, 'supervisorName'), 1, MaxStrLen(ExitRequest."Supervisor Name"));
                    ExitRequest."Contract Termination Date" := GetJsonDate(Details, 'contractTerminationDate');
                    // UAT 22-07-2026 (HB): transfer type was removed from the Exit Interview form.
                    Clear(ExitRequest."Transfer Type");
                    ExitRequest."Leaving Reasons" := CopyStr(GetJsonText(Details, 'leavingReasons'), 1, MaxStrLen(ExitRequest."Leaving Reasons"));
                    ExitRequest."Main Leaving Reason" := CopyStr(GetJsonText(Details, 'mainReason'), 1, MaxStrLen(ExitRequest."Main Leaving Reason"));
                    ExitRequest."Other Leaving Reason" := CopyStr(GetJsonText(Details, 'otherReason'), 1, MaxStrLen(ExitRequest."Other Leaving Reason"));
                    ExitRequest."Joining Another Company" := GetJsonBoolean(Details, 'joiningAnotherCompany');
                    ExitRequest."New Employer Sector" := CopyStr(GetJsonText(Details, 'newEmployerSector'), 1, MaxStrLen(ExitRequest."New Employer Sector"));
                    ExitRequest."New Employer Sector Other" := CopyStr(GetJsonText(Details, 'newEmployerSectorOther'), 1, MaxStrLen(ExitRequest."New Employer Sector Other"));
                    ExitRequest."New Employer Attraction" := CopyStr(GetJsonText(Details, 'attraction'), 1, MaxStrLen(ExitRequest."New Employer Attraction"));
                    ExitRequest."Starting Own Business" := GetJsonBoolean(Details, 'startOwnBusiness');
                    ExitRequest."Other Plans" := CopyStr(GetJsonText(Details, 'otherPlans'), 1, MaxStrLen(ExitRequest."Other Plans"));
                    ExitRequest."Would Return" := CopyStr(GetJsonText(Details, 'wouldReturn'), 1, MaxStrLen(ExitRequest."Would Return"));
                    ExitRequest."Most Satisfying" := CopyStr(GetJsonText(Details, 'mostSatisfying'), 1, MaxStrLen(ExitRequest."Most Satisfying"));
                    ExitRequest."Most Frustrating" := CopyStr(GetJsonText(Details, 'mostFrustrating'), 1, MaxStrLen(ExitRequest."Most Frustrating"));
                    ExitRequest."Exit Comments" := CopyStr(GetJsonText(Details, 'additionalComments'), 1, MaxStrLen(ExitRequest."Exit Comments"));
                    if ExitRequest."Exit Comments" = '' then
                        ExitRequest."Exit Comments" := CopyStr(GetJsonText(Details, 'comments'), 1, MaxStrLen(ExitRequest."Exit Comments"));
                    ExitRequest."Confidentiality Acknowledged" := GetJsonBoolean(Details, 'confidentialityAcknowledged');
                end;
        end;
    end;

    local procedure ApplyEmployeeDetails(var ExitRequest: Record "Portal Employee Exit Request"; EmployeeNo: Code[20]; Details: JsonObject)
    begin
        ExitRequest."Employee No." := EmployeeNo;
        ExitRequest."Employee Name" := CopyStr(GetJsonText(Details, 'employeeName'), 1, MaxStrLen(ExitRequest."Employee Name"));
        ExitRequest."Current Department" := CopyStr(GetJsonText(Details, 'departmentName'), 1, MaxStrLen(ExitRequest."Current Department"));
    end;

    local procedure ApplyApprovalRouting(var ExitRequest: Record "Portal Employee Exit Request"; RequesterUserId: Code[50])
    var
        RequesterSetup: Record "User Setup";
        HrSetup: Record "Portal Employee Transfer Setup";
        SupervisorUserId: Code[50];
    begin
        if RequesterUserId = '' then
            Error('The requester User ID is required for approval routing.');
        ExitRequest."Requester User ID" := RequesterUserId;
        if ExitRequest."Request Type" = ExitRequest."Request Type"::ExitInterview then begin
            Clear(ExitRequest."Supervisor User ID");
            Clear(ExitRequest."HR Approver User ID");
            exit;
        end;

        if not RequesterSetup.Get(RequesterUserId) then
            Error('Business Central User Setup was not found for requester %1.', RequesterUserId);

        if not HrSetup.Get('TRANSFER') then
            Error('Open Portal Employee Transfer Setup in Business Central and set the Immediate Supervisor User ID and HR Approver User ID used for Employee Transfer and Employee Resignation approvals.');

        SupervisorUserId := RequesterSetup."Approver ID";
        if SupervisorUserId = '' then
            SupervisorUserId := HrSetup."Immediate Supervisor User ID";
        if SupervisorUserId = '' then
            Error('No Immediate Supervisor is configured. Either set the Approver ID on the User Setup card for %1, or set the Immediate Supervisor User ID on Portal Employee Transfer Setup.', RequesterUserId);
        if SupervisorUserId = RequesterUserId then
            Error('The requester cannot be their own Immediate Supervisor.');
        ExitRequest."Supervisor User ID" := SupervisorUserId;

        HrSetup.TestField("HR Approver User ID");
        if HrSetup."HR Approver User ID" = RequesterUserId then
            Error('The requester cannot be their own HR approver.');
        if HrSetup."HR Approver User ID" = ExitRequest."Supervisor User ID" then
            Error('The Immediate Supervisor and HR approver must be different users.');
        ExitRequest."HR Approver User ID" := HrSetup."HR Approver User ID";
    end;

    local procedure GetJsonText(Details: JsonObject; PropertyName: Text): Text
    var
        Token: JsonToken;
    begin
        if not Details.Get(PropertyName, Token) then
            exit('');
        if Token.AsValue().IsNull() then
            exit('');
        exit(Token.AsValue().AsText());
    end;

    local procedure GetJsonBoolean(Details: JsonObject; PropertyName: Text): Boolean
    var
        ValueText: Text;
    begin
        ValueText := UpperCase(GetJsonText(Details, PropertyName));
        exit((ValueText = 'TRUE') or (ValueText = 'YES') or (ValueText = '1'));
    end;

    local procedure GetJsonDate(Details: JsonObject; PropertyName: Text): Date
    var
        DateText: Text;
        Result: Date;
    begin
        DateText := GetJsonText(Details, PropertyName);
        if DateText = '' then
            exit(0D);
        if not Evaluate(Result, DateText, 9) then
            Error('%1 must be a valid ISO date.', PropertyName);
        exit(Result);
    end;

    local procedure AddRequestJson(var Row: JsonObject; ExitRequest: Record "Portal Employee Exit Request")
    var
        Details: JsonObject;
        RequestTypeValue: Text;
        RequestTypeLabel: Text;
        SubmittedAt: DateTime;
    begin
        case ExitRequest."Request Type" of
            ExitRequest."Request Type"::Transfer:
                begin
                    RequestTypeValue := 'transfer';
                    RequestTypeLabel := 'Transfer Request';
                    Details.Add('desiredDepartment', ExitRequest."Desired Department");
                    Details.Add('desiredLocation', ExitRequest."Desired Location");
                    Details.Add('transferType', ExitRequest."Transfer Type");
                    Details.Add('typeOfTransfer', ExitRequest."Transfer Type");
                    Details.Add('requestedEffectiveDate', Format(ExitRequest."Requested Effective Date", 0, 9));
                    Details.Add('reason', ExitRequest."Transfer Reason");
                    Details.Add('handoverPlan', ExitRequest."Transfer Handover Plan");
                    Details.Add('supportingInformation', ExitRequest."Transfer Supporting Info");
                end;
            ExitRequest."Request Type"::Resignation:
                begin
                    RequestTypeValue := 'resignation';
                    RequestTypeLabel := 'Resignation Application';
                    Details.Add('lastWorkingDate', Format(ExitRequest."Proposed Last Working Date", 0, 9));
                    Details.Add('resignationReason', ExitRequest."Resignation Reason");
                    Details.Add('noticePeriodAcknowledged', YesNoText(ExitRequest."Notice Acknowledged"));
                    Details.Add('handoverPlan', ExitRequest."Resignation Handover Plan");
                    Details.Add('personalEmail', ExitRequest."Personal Email");
                    Details.Add('personalPhone', ExitRequest."Personal Phone");
                    Details.Add('forwardingAddress', ExitRequest."Forwarding Address");
                    Details.Add('companyPropertyNotes', ExitRequest."Company Property Notes");
                end;
            ExitRequest."Request Type"::ExitInterview:
                begin
                    RequestTypeValue := 'exit-interview';
                    RequestTypeLabel := 'Employee Exit Form';
                    Details.Add('supervisorName', ExitRequest."Supervisor Name");
                    Details.Add('contractTerminationDate', Format(ExitRequest."Contract Termination Date", 0, 9));
                    // UAT 22-07-2026 (HB): transfer type is not part of the Exit Interview form.
                    Details.Add('leavingReasons', ExitRequest."Leaving Reasons");
                    Details.Add('mainReason', ExitRequest."Main Leaving Reason");
                    Details.Add('otherReason', ExitRequest."Other Leaving Reason");
                    Details.Add('joiningAnotherCompany', YesNoText(ExitRequest."Joining Another Company"));
                    Details.Add('newEmployerSector', ExitRequest."New Employer Sector");
                    Details.Add('newEmployerSectorOther', ExitRequest."New Employer Sector Other");
                    Details.Add('attraction', ExitRequest."New Employer Attraction");
                    Details.Add('startOwnBusiness', YesNoText(ExitRequest."Starting Own Business"));
                    Details.Add('otherPlans', ExitRequest."Other Plans");
                    Details.Add('wouldReturn', ExitRequest."Would Return");
                    Details.Add('mostSatisfying', ExitRequest."Most Satisfying");
                    Details.Add('mostFrustrating', ExitRequest."Most Frustrating");
                    Details.Add('additionalComments', ExitRequest."Exit Comments");
                    // Kept for interviews recorded before the official template landed.
                    if ExitRequest."Proposed Interview Date" <> 0D then
                        Details.Add('exitInterviewDate', Format(ExitRequest."Proposed Interview Date", 0, 9));
                    if ExitRequest."Suggested Improvements" <> '' then
                        Details.Add('improvements', ExitRequest."Suggested Improvements");
                    Details.Add('confidentialityAcknowledged', YesNoText(ExitRequest."Confidentiality Acknowledged"));
                end;
        end;

        SubmittedAt := ExitRequest."Submitted On";
        if SubmittedAt = 0DT then
            SubmittedAt := ExitRequest."Created On";
        Row.Add('id', ExitRequest."No.");
        Row.Add('requestNo', ExitRequest."No.");
        Row.Add('requestType', RequestTypeValue);
        Row.Add('requestTypeLabel', RequestTypeLabel);
        Row.Add('status', Format(ExitRequest.Status));
        Row.Add('submittedAt', Format(SubmittedAt, 0, 9));
        Row.Add('updatedAt', Format(ExitRequest.SystemModifiedAt, 0, 9));
        Row.Add('employeeNo', ExitRequest."Employee No.");
        Row.Add('employeeName', ExitRequest."Employee Name");
        Row.Add('departmentName', ExitRequest."Current Department");
        Row.Add('details', Details);
        Row.Add('approvalRequired', ExitRequest."Approval Required");
        Row.Add('erpWorkflowConnected', true);
        Row.Add('requesterUserId', ExitRequest."Requester User ID");
        Row.Add('supervisorUserId', ExitRequest."Supervisor User ID");
        Row.Add('hrApproverUserId', ExitRequest."HR Approver User ID");
        Row.Add('supervisorDecisionBy', ExitRequest."Supervisor Decision By");
        Row.Add('supervisorDecisionAt', FormatDateTimeOrBlank(ExitRequest."Supervisor Decision On"));
        Row.Add('hrDecisionBy', ExitRequest."HR Decision By");
        Row.Add('hrDecisionAt', FormatDateTimeOrBlank(ExitRequest."HR Decision On"));
        Row.Add('rejectedAtStage', ExitRequest."Rejected At Stage");
        // The requester must see WHY a transfer/resignation was rejected (UAT).
        Row.Add('decisionRemarks', ExitRequest."Decision Remarks");
        Row.Add('cancellationReason', ExitRequest."Cancellation Reason");
        if ExitRequest."Cancellation Requested" then
            Row.Add('cancellationRequestedAt', Format(ExitRequest.SystemModifiedAt, 0, 9));
    end;

    local procedure YesNoText(Value: Boolean): Text
    begin
        if Value then
            exit('Yes');
        exit('No');
    end;

    local procedure FormatDateTimeOrBlank(Value: DateTime): Text
    begin
        if Value = 0DT then
            exit('');
        exit(Format(Value, 0, 9));
    end;
}
