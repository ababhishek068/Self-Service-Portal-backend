/// <summary>
/// Stores the SSP assessment and creates training headers with the correct Group category.
/// Publish as SOAP service CuPortalTraining.
/// </summary>
codeunit 52121 "Portal Training Mgt."
{
    procedure SaveTrainingHeader(requesterUserId: Code[50]; myAction: Text; docNo: Code[20]; trainingCourseCode: Code[20]; purpose: Text; employeeNo: Code[20]): Code[20]
    var
        TrainingHeader: Record "HR Training Applications";
        TrainingParticipant: Record "HR Training Participants";
        NextNo: Code[20];
    begin
        TrainingHeader.Reset();
        case LowerCase(myAction) of
            'create':
                begin
                    if TrainingHeader.FindLast() then
                        NextNo := IncStr(TrainingHeader."Application No")
                    else
                        NextNo := 'TAP-00001';
                    TrainingHeader.Init();
                    TrainingHeader."Application No" := NextNo;
                    TrainingHeader."User ID" := requesterUserId;
                    TrainingHeader."Application Date" := Today;
                    if trainingCourseCode <> '' then begin
                        TrainingHeader."Course Title" := trainingCourseCode;
                        TrainingHeader.Validate("Course Title");
                    end;
                    // Portal assessments are always group requests — re-apply after Validate in case the course record overrides category.
                    TrainingHeader."Training Category" := TrainingHeader."Training Category"::Group;
                    if employeeNo <> '' then begin
                        TrainingHeader."Employee No." := employeeNo;
                        TrainingHeader.Validate("Employee No.");
                    end;
                    TrainingHeader."Purpose of Training" := CopyStr(purpose, 1, MaxStrLen(TrainingHeader."Purpose of Training"));
                    if TrainingHeader.Insert(true) then begin
                        if (employeeNo <> '') and (TrainingHeader."Training Category" = TrainingHeader."Training Category"::Group) then begin
                            TrainingParticipant.Init();
                            TrainingParticipant."Training Code" := NextNo;
                            TrainingParticipant."Employee Code" := employeeNo;
                            TrainingParticipant.Validate("Employee Code");
                            TrainingParticipant.Insert(true);
                        end;
                        exit(NextNo);
                    end;
                end;
            'edit':
                begin
                    TrainingHeader.SetRange("Application No", docNo);
                    TrainingHeader.SetRange(Status, TrainingHeader.Status::New);
                    if TrainingHeader.FindFirst() then begin
                        TrainingHeader."Application Date" := Today;
                        if trainingCourseCode <> '' then begin
                            TrainingHeader."Course Title" := trainingCourseCode;
                            TrainingHeader.Validate("Course Title");
                        end;
                        TrainingHeader."Purpose of Training" := CopyStr(purpose, 1, MaxStrLen(TrainingHeader."Purpose of Training"));
                        if TrainingHeader.Modify(true) then
                            exit(docNo);
                    end else
                        Error('Error: Either the document was not found or it is no longer editable');
                end;
        end;
        exit('');
    end;

    procedure SaveTrainingAssessment(applicationNo: Code[20]; employeeNo: Code[20]; requesterUserId: Code[50]; detailsJson: Text): Boolean
    var
        Assessment: Record "Portal Training Assessment";
        TrainingHeader: Record "HR Training Applications";
        RequesterSetup: Record "User Setup";
        Details: JsonObject;
        IsNew: Boolean;
        SupervisorUserId: Code[50];
    begin
        if applicationNo = '' then
            Error('The training application number is required.');
        if requesterUserId = '' then
            Error('The requester User ID is required.');
        if not Details.ReadFrom(detailsJson) then
            Error('Training assessment details are not valid JSON.');
        if not TrainingHeader.Get(applicationNo) then
            Error('Training application %1 was not found.', applicationNo);
        if not RequesterSetup.Get(requesterUserId) then
            Error('Business Central User Setup was not found for requester %1.', requesterUserId);
        SupervisorUserId := ResolveSupervisorUserId(requesterUserId, employeeNo);
        if SupervisorUserId = '' then
            Error('No Immediate Supervisor is configured. Set Approver ID on User Setup for %1, Portal Employee Transfer Setup, or Supervisor User ID on the employee card.', requesterUserId);
        if SupervisorUserId = requesterUserId then
            Error('The requester cannot be their own Immediate Supervisor.');

        // FnTrainingRequest.Insert(true) can overwrite User ID with the SOAP service account.
        // Restore the employee's real ID before the workflow creates its approval entry.
        TrainingHeader."User ID" := requesterUserId;
        TrainingHeader.Modify(true);

        IsNew := not Assessment.Get(applicationNo);
        if IsNew then begin
            Assessment.Init();
            Assessment."Application No" := applicationNo;
        end;
        Assessment."Employee No." := employeeNo;
        Assessment."Requester User ID" := requesterUserId;
        Assessment."Supervisor User ID" := SupervisorUserId;
        Assessment."Training Need Code" := CopyStr(GetJsonText(Details, 'trainingNeed'), 1, MaxStrLen(Assessment."Training Need Code"));
        Assessment.Purpose := CopyStr(GetJsonText(Details, 'purpose'), 1, MaxStrLen(Assessment.Purpose));
        Assessment."Other Training Name" := CopyStr(GetJsonText(Details, 'otherTrainingName'), 1, MaxStrLen(Assessment."Other Training Name"));
        Assessment."Training Type" := CopyStr(GetJsonText(Details, 'trainingType'), 1, MaxStrLen(Assessment."Training Type"));
        Assessment."Duration Days" := GetJsonDecimal(Details, 'durationDays');
        Assessment."Target Group" := CopyStr(GetJsonText(Details, 'targetGroup'), 1, MaxStrLen(Assessment."Target Group"));
        Assessment."No. of Participants" := Round(GetJsonDecimal(Details, 'participants'), 1);
        Assessment.Quarter := CopyStr(GetJsonText(Details, 'quarter'), 1, MaxStrLen(Assessment.Quarter));
        Assessment.Priority := CopyStr(GetJsonText(Details, 'priority'), 1, MaxStrLen(Assessment.Priority));
        Assessment."Recommended Vendor" := CopyStr(GetJsonText(Details, 'vendor'), 1, MaxStrLen(Assessment."Recommended Vendor"));
        Assessment."Estimated Budget" := CopyStr(GetJsonText(Details, 'estimatedBudget'), 1, MaxStrLen(Assessment."Estimated Budget"));
        Assessment.Remark := CopyStr(GetJsonText(Details, 'remark'), 1, MaxStrLen(Assessment.Remark));
        Assessment."Department Code" := CopyStr(GetJsonText(Details, 'department'), 1, MaxStrLen(Assessment."Department Code"));
        Assessment."Training Start Date" := GetJsonDate(Details, 'periodStart');
        Assessment."Training End Date" := GetJsonDate(Details, 'periodEnd');
        if IsNew then
            Assessment.Insert(true)
        else
            Assessment.Modify(true);
        exit(true);
    end;

    /// <summary>
    /// Send training for approval with the employee's real User ID and route the open approval
    /// entry to the Immediate Supervisor stored on the portal assessment.
    /// </summary>
    procedure RequestTrainingApproval(applicationNo: Code[20]; requesterUserId: Code[50]): Boolean
    var
        TrainingHeader: Record "HR Training Applications";
        Assessment: Record "Portal Training Assessment";
        ApprovalEntry: Record "Approval Entry";
        CustomApprovals: Codeunit "Custom Approvals Codeunit";
        Variant: Variant;
    begin
        if applicationNo = '' then
            Error('The training application number is required.');
        if requesterUserId = '' then
            Error('The requester User ID is required.');
        if not TrainingHeader.Get(applicationNo) then
            Error('Training application %1 was not found.', applicationNo);
        if not Assessment.Get(applicationNo) then
            Error('The Training Need Assessment is missing for %1.', applicationNo);
        if Assessment."Supervisor User ID" = '' then
            Error('No Immediate Supervisor is configured for this training request.');

        TrainingHeader."User ID" := requesterUserId;
        TrainingHeader.Modify(true);

        Variant := TrainingHeader;
        CustomApprovals.OnSendDocForApproval(Variant);

        ApprovalEntry.Reset();
        ApprovalEntry.SetRange("Table ID", Database::"HR Training Applications");
        ApprovalEntry.SetRange("Document No.", applicationNo);
        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Open);
        if ApprovalEntry.FindSet(true) then
            repeat
                ApprovalEntry."Sender ID" := requesterUserId;
                ApprovalEntry."Approver ID" := Assessment."Supervisor User ID";
                ApprovalEntry.Modify(true);
            until ApprovalEntry.Next() = 0;

        exit(true);
    end;

    procedure GetTrainingAssessment(applicationNo: Code[20]): Text
    var
        Assessment: Record "Portal Training Assessment";
        TrainingHeader: Record "HR Training Applications";
        Row: JsonObject;
        ResultText: Text;
        TrainingNeed: Text;
        ApprovalStatus: Text;
    begin
        if not Assessment.Get(applicationNo) then
            exit('{}');
        TrainingNeed := Assessment."Training Need Code";
        if TrainingHeader.Get(applicationNo) then begin
            if TrainingNeed = '' then
                TrainingNeed := TrainingHeader."Course Title";
            ApprovalStatus := Format(TrainingHeader.Status);
        end;
        Row.Add('applicationNo', Assessment."Application No");
        Row.Add('employeeNo', Assessment."Employee No.");
        Row.Add('requesterUserId', Assessment."Requester User ID");
        Row.Add('supervisorUserId', Assessment."Supervisor User ID");
        Row.Add('approvalStatus', ApprovalStatus);
        Row.Add('trainingNeed', TrainingNeed);
        Row.Add('purpose', Assessment.Purpose);
        Row.Add('otherTrainingName', Assessment."Other Training Name");
        Row.Add('trainingType', Assessment."Training Type");
        Row.Add('durationDays', Assessment."Duration Days");
        Row.Add('targetGroup', Assessment."Target Group");
        Row.Add('participants', Assessment."No. of Participants");
        Row.Add('quarter', Assessment.Quarter);
        Row.Add('priority', Assessment.Priority);
        Row.Add('vendor', Assessment."Recommended Vendor");
        Row.Add('estimatedBudget', Assessment."Estimated Budget");
        Row.Add('remark', Assessment.Remark);
        Row.Add('department', Assessment."Department Code");
        Row.Add('periodStart', FormatDateForJson(Assessment."Training Start Date"));
        Row.Add('periodEnd', FormatDateForJson(Assessment."Training End Date"));
        Row.WriteTo(ResultText);
        exit(ResultText);
    end;

    local procedure ResolveSupervisorUserId(RequesterUserId: Code[50]; EmployeeNo: Code[20]): Code[50]
    var
        RequesterSetup: Record "User Setup";
        HrSetup: Record "Portal Employee Transfer Setup";
    begin
        if RequesterSetup.Get(RequesterUserId) then
            if RequesterSetup."Approver ID" <> '' then
                exit(RequesterSetup."Approver ID");
        if HrSetup.Get('TRANSFER') then
            if HrSetup."Immediate Supervisor User ID" <> '' then
                exit(HrSetup."Immediate Supervisor User ID");
        exit('');
    end;

    local procedure GetJsonText(Details: JsonObject; PropertyName: Text): Text
    var
        Token: JsonToken;
    begin
        if not Details.Get(PropertyName, Token) then
            exit('');
        if not Token.IsValue() then
            exit('');
        if Token.AsValue().IsNull() then
            exit('');
        exit(Token.AsValue().AsText());
    end;

    local procedure GetJsonDecimal(Details: JsonObject; PropertyName: Text): Decimal
    var
        Value: Text;
        Parsed: Decimal;
    begin
        Value := GetJsonText(Details, PropertyName);
        if Value = '' then
            exit(0);
        if not Evaluate(Parsed, Value, 9) then
            Error('%1 must be a valid number.', PropertyName);
        exit(Parsed);
    end;

    local procedure GetJsonDate(Details: JsonObject; PropertyName: Text): Date
    var
        Value: Text;
        Parsed: Date;
    begin
        Value := GetJsonText(Details, PropertyName);
        if Value = '' then
            exit(0D);
        // The portal sends ISO dates (yyyy-mm-dd); XML format 9 parses them culture-independently.
        if not Evaluate(Parsed, Value, 9) then
            exit(0D);
        exit(Parsed);
    end;

    local procedure FormatDateForJson(Value: Date): Text
    begin
        if Value = 0D then
            exit('');
        exit(Format(Value, 0, '<Year4>-<Month,2>-<Day,2>'));
    end;
}
