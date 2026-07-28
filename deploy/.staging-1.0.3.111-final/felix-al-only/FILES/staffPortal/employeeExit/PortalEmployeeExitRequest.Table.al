table 52100 "Portal Employee Exit Request"
{
    Caption = 'Employee Exit Request';
    DataClassification = EndUserIdentifiableInformation;
    DrillDownPageId = "Portal Employee Exit Requests";
    LookupPageId = "Portal Employee Exit Requests";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'Request No.';
            Editable = false;
        }
        field(2; "Request Type"; Enum "Portal Exit Request Type")
        {
            Caption = 'Request Type';
        }
        field(3; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
        }
        field(4; "Employee Name"; Text[100])
        {
            Caption = 'Employee Name';
            Editable = false;
        }
        field(5; "Current Department"; Code[20])
        {
            Caption = 'Current Department';
            Editable = false;
        }
        field(6; "Current Branch"; Code[20])
        {
            Caption = 'Current Branch';
            Editable = false;
        }
        field(7; "Job Title"; Text[100])
        {
            Caption = 'Job Title';
            Editable = false;
        }
        field(8; Status; Enum "Portal Exit Request Status")
        {
            Caption = 'Status';
            Editable = false;
        }
        field(9; "Created On"; DateTime)
        {
            Caption = 'Created On';
            Editable = false;
        }
        field(10; "Created By"; Code[50])
        {
            Caption = 'Created By';
            Editable = false;
        }
        field(11; "Submitted On"; DateTime)
        {
            Caption = 'Submitted On';
            Editable = false;
        }
        field(12; "Cancellation Requested"; Boolean)
        {
            Caption = 'Cancellation Requested';
            Editable = false;
        }
        field(13; "Cancellation Reason"; Text[250])
        {
            Caption = 'Cancellation Reason';
        }
        field(14; "Cancelled On"; DateTime)
        {
            Caption = 'Cancelled On';
            Editable = false;
        }
        field(15; "Approval Required"; Boolean)
        {
            Caption = 'Approval Required';
            Editable = false;
        }
        field(16; "Requester User ID"; Code[50])
        {
            Caption = 'Requester User ID';
            Editable = false;
            TableRelation = "User Setup"."User ID";
        }
        field(17; "Supervisor User ID"; Code[50])
        {
            Caption = 'Immediate Supervisor';
            Editable = false;
            TableRelation = "User Setup"."User ID";
        }
        field(18; "HR Approver User ID"; Code[50])
        {
            Caption = 'HR Approver';
            Editable = false;
            TableRelation = "User Setup"."User ID";
        }
        field(19; "Supervisor Decision On"; DateTime)
        {
            Caption = 'Supervisor Decision On';
            Editable = false;
        }
        field(20; "Supervisor Decision By"; Code[50])
        {
            Caption = 'Supervisor Decision By';
            Editable = false;
        }
        field(21; "HR Decision On"; DateTime)
        {
            Caption = 'HR Decision On';
            Editable = false;
        }
        field(22; "HR Decision By"; Code[50])
        {
            Caption = 'HR Decision By';
            Editable = false;
        }
        field(23; "Rejected At Stage"; Text[30])
        {
            Caption = 'Rejected At Stage';
            Editable = false;
        }
        field(24; "Decision Remarks"; Text[250])
        {
            Caption = 'Decision Remarks';
            Editable = false;
        }

        field(100; "Desired Department"; Code[20])
        {
            Caption = 'Desired Department';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(101; "Desired Location"; Text[100])
        {
            Caption = 'Desired Location';
        }
        field(102; "Transfer Type"; Text[20])
        {
            Caption = 'Transfer Type';
        }
        field(103; "Transfer Duration"; Text[50])
        {
            Caption = 'Transfer Duration';
        }
        field(104; "Requested Effective Date"; Date)
        {
            Caption = 'Requested Effective Date';
        }
        field(105; "Transfer Reason"; Text[250])
        {
            Caption = 'Transfer Reason';
        }
        field(106; "Transfer Handover Plan"; Text[2048])
        {
            Caption = 'Transfer Handover Plan';
        }
        field(107; "Transfer Supporting Info"; Text[2048])
        {
            Caption = 'Transfer Supporting Information';
        }

        field(200; "Proposed Last Working Date"; Date)
        {
            Caption = 'Proposed Last Working Date';
        }
        field(201; "Resignation Reason"; Text[250])
        {
            Caption = 'Resignation Reason';
        }
        field(202; "Notice Acknowledged"; Boolean)
        {
            Caption = 'Notice Period Acknowledged';
        }
        field(203; "Resignation Handover Plan"; Text[2048])
        {
            Caption = 'Resignation Handover Plan';
        }
        field(204; "Personal Email"; Text[100])
        {
            Caption = 'Personal Email';
        }
        field(205; "Personal Phone"; Text[30])
        {
            Caption = 'Personal Phone';
        }
        field(206; "Forwarding Address"; Text[250])
        {
            Caption = 'Forwarding Address';
        }
        field(207; "Company Property Notes"; Text[2048])
        {
            Caption = 'Company Property Notes';
        }

        field(300; "Proposed Interview Date"; Date)
        {
            Caption = 'Proposed Interview Date';
        }
        field(301; "Main Leaving Reason"; Text[100])
        {
            Caption = 'Main Reason for Leaving';
        }
        field(302; "Other Leaving Reason"; Text[250])
        {
            Caption = 'Other Reason for Leaving';
        }
        field(303; "Joining Another Company"; Boolean)
        {
            Caption = 'Joining Another Company';
        }
        field(304; "New Employer Sector"; Text[100])
        {
            Caption = 'New Employer Sector';
        }
        field(305; "New Employer Attraction"; Text[250])
        {
            Caption = 'New Employer Attraction';
        }
        field(306; "Starting Own Business"; Boolean)
        {
            Caption = 'Starting Own Business';
        }
        field(307; "Suggested Improvements"; Text[2048])
        {
            Caption = 'Suggested Improvements';
        }
        field(308; "Exit Comments"; Text[2048])
        {
            Caption = 'Additional Comments';
        }
        field(309; "Confidentiality Acknowledged"; Boolean)
        {
            Caption = 'Confidentiality Acknowledged';
        }

        // ── Fields from Hijra Bank's official Employee Exit Interview Form ──
        field(310; "Leaving Reasons"; Text[500])
        {
            Caption = 'Reasons for Leaving';
        }
        field(311; "Would Return"; Text[20])
        {
            Caption = 'Would Consider Returning';
        }
        field(312; "Most Satisfying"; Text[2048])
        {
            Caption = 'Most Satisfying During Stay';
        }
        field(313; "Most Frustrating"; Text[2048])
        {
            Caption = 'Most Frustrating During Stay';
        }
        field(314; "Supervisor Name"; Text[100])
        {
            Caption = 'Immediate Supervisor at Termination';
        }
        field(315; "Contract Termination Date"; Date)
        {
            Caption = 'Contract Termination Date';
        }
        field(316; "New Employer Sector Other"; Text[100])
        {
            Caption = 'New Employer Sector (Other)';
        }
        field(317; "Other Plans"; Text[250])
        {
            Caption = 'Other Plans After Leaving';
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key(Employee; "Employee No.", "Request Type", Status)
        {
        }
    }

    trigger OnInsert()
    begin
        if "No." = '' then
            "No." := GetNextRequestNo();
        "Created On" := CurrentDateTime;
        "Created By" := CopyStr(UserId, 1, MaxStrLen("Created By"));
        Status := Status::Open;
        "Approval Required" := "Request Type" <> "Request Type"::ExitInterview;
    end;

    trigger OnDelete()
    begin
        TestField(Status, Status::Open);
    end;

    /// <summary>
    /// CheckDates is false when an already-approved request re-enters the approval flow to
    /// be cancelled: its effective date is usually in the past by then, and re-applying the
    /// past-date rule would trap the employee with a request they can never cancel.
    /// </summary>
    procedure ValidateForSubmission(CheckDates: Boolean)
    begin
        TestField("Employee No.");

        case "Request Type" of
            "Request Type"::Transfer:
                ValidateTransferRequest(CheckDates);
            "Request Type"::Resignation:
                ValidateResignationRequest(CheckDates);
            "Request Type"::ExitInterview:
                ValidateExitInterview(CheckDates);
        end;
    end;

    local procedure ValidateTransferRequest(CheckDates: Boolean)
    begin
        TestField("Desired Department");
        TestField("Desired Location");
        TestField("Transfer Type");
        TestField("Requested Effective Date");
        TestField("Transfer Reason");
        TestField("Transfer Handover Plan");
        if CheckDates and ("Requested Effective Date" < Today) then
            Error('Requested Effective Date cannot be in the past.');
        // UAT 25/07/2026: the SSP transfer form offers Permanent, Temporary and Secondment.
        if (UpperCase("Transfer Type") <> 'PERMANENT') and
           (UpperCase("Transfer Type") <> 'TEMPORARY') and
           (UpperCase("Transfer Type") <> 'SECONDMENT')
        then
            Error('Transfer Type must be Permanent, Temporary or Secondment.');
        // The official SSP template contains exactly seven transfer fields and does not ask
        // for a duration when Temporary is selected. Keep the legacy storage field for
        // upgrade compatibility, but never require it for a new transfer request.
    end;

    local procedure ValidateResignationRequest(CheckDates: Boolean)
    begin
        TestField("Proposed Last Working Date");
        TestField("Resignation Reason");
        TestField("Resignation Handover Plan");
        TestField("Personal Email");
        TestField("Personal Phone");
        if CheckDates and ("Proposed Last Working Date" < Today) then
            Error('Proposed Last Working Date cannot be in the past.');
        if not "Notice Acknowledged" then
            Error('The employee must acknowledge the notice-period requirement.');
    end;

    /// <summary>
    /// Validates against Hijra Bank's 17-07-2026 Employee Exit SSP template. The contract
    /// termination date is allowed to be in the past, so CheckDates is deliberately not applied.
    /// </summary>
    local procedure ValidateExitInterview(CheckDates: Boolean)
    begin
        TestField("Supervisor Name");
        TestField("Contract Termination Date");
        // UAT 22-07-2026 (HB): "transfer type should be removed" from the Exit Interview form,
        // so it is no longer validated here. It remains required on Transfer requests only.
        TestField("Leaving Reasons");
        TestField("Would Return");
        TestField("Most Satisfying");
        TestField("Most Frustrating");
        if not "Confidentiality Acknowledged" then
            Error('The employee must confirm that the information is accurate and may be reviewed.');
    end;

    local procedure GetNextRequestNo(): Code[20]
    var
        LastRequest: Record "Portal Employee Exit Request";
        Existing: Record "Portal Employee Exit Request";
        Candidate: Code[20];
        Sequence: Integer;
    begin
        LastRequest.LockTable();
        LastRequest.SetCurrentKey("No.");
        LastRequest.SetFilter("No.", 'EXIT-*');
        if LastRequest.FindLast() then
            Sequence := SequenceFromNo(LastRequest."No.");

        // Confirm the candidate is free before handing it out, so a missed FindLast can never
        // produce a duplicate primary key.
        repeat
            Sequence += 1;
            Candidate := CopyStr('EXIT-' + PadSequence(Sequence), 1, MaxStrLen(Candidate));
        until not Existing.Get(Candidate);
        exit(Candidate);
    end;

    local procedure SequenceFromNo(RequestNo: Code[20]): Integer
    var
        Digits: Text;
        Position: Integer;
        Parsed: Integer;
    begin
        Position := StrLen(RequestNo);
        // AL does not short-circuit `and`, so guard the index access with the outer while and
        // stop by zeroing Position rather than testing RequestNo[Position] when Position < 1.
        while Position >= 1 do
            if RequestNo[Position] in ['0' .. '9'] then begin
                Digits := Format(RequestNo[Position]) + Digits;
                Position -= 1;
            end else
                Position := 0;
        if (Digits <> '') and Evaluate(Parsed, Digits) then
            exit(Parsed);
        exit(0);
    end;

    local procedure PadSequence(Sequence: Integer): Text
    var
        Result: Text;
    begin
        Result := Format(Sequence);
        while StrLen(Result) < 6 do
            Result := '0' + Result;
        exit(Result);
    end;
}
