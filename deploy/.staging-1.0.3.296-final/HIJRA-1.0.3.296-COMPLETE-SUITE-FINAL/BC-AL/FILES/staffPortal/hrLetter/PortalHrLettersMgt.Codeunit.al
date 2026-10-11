/// <summary>
/// SOAP surface for the Self Service Portal HR Service Request Letters.
/// Published as web service "CuPortalHrLetters" (codeunit 52142 install does this).
/// The portal backend (hrServiceLetters.ts) calls exactly these five procedures.
/// The HR approver is the "HR Approver User ID" on Portal Employee Transfer Setup,
/// the same setup record the Employee Exit approvals already use.
/// </summary>
codeunit 52141 "Portal HR Letters Mgt."
{
    /// <summary>Employee's own letter requests as a JSON array.</summary>
    procedure GetHrLetterRequests(employeeNo: Code[20]): Text
    var
        LetterRequest: Record "Portal HR Letter Request";
        Rows: JsonArray;
        Row: JsonObject;
        Result: Text;
    begin
        LetterRequest.SetRange("Employee No.", employeeNo);
        if LetterRequest.FindSet() then
            repeat
                Clear(Row);
                AddRequestJson(Row, LetterRequest);
                Rows.Add(Row);
            until LetterRequest.Next() = 0;
        Rows.WriteTo(Result);
        exit(Result);
    end;

    /// <summary>Create a letter request. Returns the new request number.</summary>
    procedure SaveHrLetterRequest(employeeNo: Code[20]; employeeName: Text[100]; departmentName: Text[100]; letterType: Text[40]; detailsJson: Text): Code[20]
    var
        LetterRequest: Record "Portal HR Letter Request";
        Details: JsonObject;
    begin
        if employeeNo = '' then
            Error('The employee number is required.');
        ValidateLetterType(letterType);
        if not Details.ReadFrom(detailsJson) then
            Error('The letter request details are not valid JSON.');

        LetterRequest.Init();
        LetterRequest."Employee No." := employeeNo;
        LetterRequest."Employee Name" := employeeName;
        LetterRequest."Department Name" := departmentName;
        LetterRequest."Letter Type" := MapLetterType(letterType);
        // Excel HR HB: letters have no approval process — go straight to HR processing.
        LetterRequest.Status := LetterRequest.Status::InProgress;
        LetterRequest.Insert(true);
        LetterRequest.SetDetailsJson(detailsJson);
        LetterRequest.Status := LetterRequest.Status::InProgress;
        LetterRequest.Modify(true);
        exit(LetterRequest."No.");
    end;

    /// <summary>Employee withdraws a request HR has not finished yet.</summary>
    procedure CancelHrLetterRequest(employeeNo: Code[20]; requestNo: Code[20]): Boolean
    var
        LetterRequest: Record "Portal HR Letter Request";
    begin
        if not LetterRequest.Get(requestNo) then
            Error('HR letter request %1 was not found.', requestNo);
        if LetterRequest."Employee No." <> employeeNo then
            Error('Employee %1 is not allowed to access request %2.', employeeNo, requestNo);
        if not (LetterRequest.Status in [LetterRequest.Status::Submitted, LetterRequest.Status::InProgress]) then
            Error('Request %1 can no longer be cancelled because HR already finished it.', requestNo);
        LetterRequest.Status := LetterRequest.Status::Cancelled;
        LetterRequest."Updated On" := CurrentDateTime;
        LetterRequest.Modify(true);
        exit(true);
    end;

    /// <summary>Letter requests waiting for HR, for the configured HR approver only.</summary>
    procedure GetHrLetterApprovals(approverUserIds: Text): Text
    var
        LetterRequest: Record "Portal HR Letter Request";
        Rows: JsonArray;
        Row: JsonObject;
        Result: Text;
    begin
        if IsConfiguredHrApprover(approverUserIds) then begin
            LetterRequest.SetFilter(Status, '%1|%2', LetterRequest.Status::Submitted, LetterRequest.Status::InProgress);
            if LetterRequest.FindSet() then
                repeat
                    Clear(Row);
                    AddRequestJson(Row, LetterRequest);
                    Rows.Add(Row);
                until LetterRequest.Next() = 0;
        end;
        Rows.WriteTo(Result);
        exit(Result);
    end;

    /// <summary>Approve or reject a letter as the configured HR approver.</summary>
    procedure DecideHrLetterApproval(approverUserIds: Text; requestNo: Code[20]; approve: Boolean; remarks: Text[250]): Boolean
    var
        LetterRequest: Record "Portal HR Letter Request";
    begin
        if not IsConfiguredHrApprover(approverUserIds) then
            Error('User %1 is not the configured HR approver for letter requests. Set the HR Approver User ID on Portal Employee Transfer Setup.', approverUserIds);
        if not LetterRequest.Get(requestNo) then
            Error('HR letter request %1 was not found.', requestNo);
        if not (LetterRequest.Status in [LetterRequest.Status::Submitted, LetterRequest.Status::InProgress]) then
            Error('Request %1 has already been decided.', requestNo);
        if DelChr(remarks, '=', ' ') = '' then
            Error('A reason is required to record the decision.');

        if approve then
            LetterRequest.Status := LetterRequest.Status::Approved
        else
            LetterRequest.Status := LetterRequest.Status::Rejected;
        LetterRequest."HR Remarks" := remarks;
        LetterRequest."HR Decision By" := CopyStr(FirstApproverId(approverUserIds), 1, MaxStrLen(LetterRequest."HR Decision By"));
        LetterRequest."HR Decision On" := CurrentDateTime;
        LetterRequest."Updated On" := CurrentDateTime;
        LetterRequest.Modify(true);
        exit(true);
    end;

    local procedure ValidateLetterType(letterType: Text[40])
    begin
        case LowerCase(letterType) of
            'guarantee', 'external-company', 'experience', 'mortgage', 'emergency-staff-loan', 'embassy':
                exit;
            else
                Error('HR letter type %1 is not supported.', letterType);
        end;
    end;

    local procedure MapLetterType(letterType: Text[40]): Enum "Portal HR Letter Type"
    begin
        case LowerCase(letterType) of
            'guarantee':
                exit("Portal HR Letter Type"::Guarantee);
            'external-company':
                exit("Portal HR Letter Type"::ExternalCompany);
            'experience':
                exit("Portal HR Letter Type"::Experience);
            'mortgage':
                exit("Portal HR Letter Type"::Mortgage);
            'emergency-staff-loan':
                exit("Portal HR Letter Type"::EmergencyStaffLoan);
            'embassy':
                exit("Portal HR Letter Type"::Embassy);
        end;
    end;

    local procedure LetterTypeCode(LetterType: Enum "Portal HR Letter Type"): Text
    begin
        case LetterType of
            LetterType::Guarantee:
                exit('guarantee');
            LetterType::ExternalCompany:
                exit('external-company');
            LetterType::Experience:
                exit('experience');
            LetterType::Mortgage:
                exit('mortgage');
            LetterType::EmergencyStaffLoan:
                exit('emergency-staff-loan');
            LetterType::Embassy:
                exit('embassy');
        end;
    end;

    local procedure LetterTypeLabel(LetterType: Enum "Portal HR Letter Type"): Text
    begin
        exit(Format(LetterType));
    end;

    local procedure StatusText(LetterRequest: Record "Portal HR Letter Request"): Text
    begin
        exit(Format(LetterRequest.Status));
    end;

    local procedure IsConfiguredHrApprover(ApproverUserIds: Text): Boolean
    var
        HrSetup: Record "Portal Employee Transfer Setup";
    begin
        if DelChr(ApproverUserIds, '=', ' ') = '' then
            exit(false);
        if not HrSetup.Get('TRANSFER') then
            Error('Open Portal Employee Transfer Setup in Business Central and set the HR Approver User ID; letter approvals use the same HR approver.');
        HrSetup.TestField("HR Approver User ID");
        exit(ApproverIdInList(HrSetup."HR Approver User ID", ApproverUserIds));
    end;

    local procedure FirstApproverId(DelimitedList: Text): Text
    var
        SepPos: Integer;
    begin
        SepPos := StrPos(DelimitedList, '|');
        if SepPos > 0 then
            exit(DelChr(CopyStr(DelimitedList, 1, SepPos - 1), '<>', ' '));
        exit(DelChr(DelimitedList, '<>', ' '));
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

    local procedure AddRequestJson(var Row: JsonObject; LetterRequest: Record "Portal HR Letter Request")
    var
        Details: JsonObject;
        DetailsText: Text;
    begin
        DetailsText := LetterRequest.GetDetailsJson();
        if DetailsText <> '' then
            if not Details.ReadFrom(DetailsText) then
                Clear(Details);

        Row.Add('id', LetterRequest."No.");
        Row.Add('requestNo', LetterRequest."No.");
        Row.Add('letterType', LetterTypeCode(LetterRequest."Letter Type"));
        Row.Add('letterTypeLabel', LetterTypeLabel(LetterRequest."Letter Type"));
        Row.Add('status', StatusText(LetterRequest));
        Row.Add('submittedAt', Format(LetterRequest."Submitted On", 0, 9));
        Row.Add('updatedAt', FormatDateTimeOrBlank(LetterRequest."Updated On"));
        Row.Add('employeeNo', LetterRequest."Employee No.");
        Row.Add('employeeName', LetterRequest."Employee Name");
        Row.Add('departmentName', LetterRequest."Department Name");
        Row.Add('details', Details);
        Row.Add('hrRemarks', LetterRequest."HR Remarks");
        Row.Add('hrDecisionBy', LetterRequest."HR Decision By");
        Row.Add('hrDecisionAt', FormatDateTimeOrBlank(LetterRequest."HR Decision On"));
    end;

    local procedure FormatDateTimeOrBlank(Value: DateTime): Text
    begin
        if Value = 0DT then
            exit('');
        exit(Format(Value, 0, 9));
    end;
}
