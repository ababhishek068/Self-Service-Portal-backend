/// <summary>
/// HR Service Request Letters raised from the Self Service Portal (guarantee letters,
/// experience letters, mortgage letters, emergency staff loan letters, embassy letters).
/// UAT 25/07/2026: "HR Service Request Letters ... not integrated with ERP" — this table
/// plus codeunit 52141 (published as CuPortalHrLetters) is that integration.
/// </summary>
table 52140 "Portal HR Letter Request"
{
    Caption = 'Portal HR Letter Request';
    DataClassification = EndUserIdentifiableInformation;
    DrillDownPageId = "Portal HR Letter Requests";
    LookupPageId = "Portal HR Letter Requests";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'Request No.';
            Editable = false;
        }
        field(2; "Letter Type"; Enum "Portal HR Letter Type")
        {
            Caption = 'Letter Type';
            Editable = false;
        }
        field(3; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            Editable = false;
        }
        field(4; "Employee Name"; Text[100])
        {
            Caption = 'Employee Name';
            Editable = false;
        }
        field(5; "Department Name"; Text[100])
        {
            Caption = 'Department Name';
            Editable = false;
        }
        field(6; Status; Enum "Portal HR Letter Status")
        {
            Caption = 'Status';
            Editable = false;
        }
        field(7; "Submitted On"; DateTime)
        {
            Caption = 'Submitted On';
            Editable = false;
        }
        field(8; "Updated On"; DateTime)
        {
            Caption = 'Updated On';
            Editable = false;
        }
        field(9; "Details JSON"; Blob)
        {
            Caption = 'Details JSON';
        }
        field(10; "HR Remarks"; Text[250])
        {
            Caption = 'HR Remarks';
        }
        field(11; "HR Decision By"; Code[50])
        {
            Caption = 'HR Decision By';
            Editable = false;
        }
        field(12; "HR Decision On"; DateTime)
        {
            Caption = 'HR Decision On';
            Editable = false;
        }
        field(13; Purpose; Text[250])
        {
            Caption = 'Purpose';
            Editable = false;
        }
        field(14; "Required By Date"; Date)
        {
            Caption = 'Required By Date';
            Editable = false;
        }
        field(15; "Delivery Method"; Text[50])
        {
            Caption = 'Delivery Method';
            Editable = false;
        }
        field(16; "Monthly Basic Salary"; Decimal)
        {
            Caption = 'Monthly Basic Salary';
            Editable = false;
        }
        field(17; "Requested Loan Amount"; Decimal)
        {
            Caption = 'Requested Loan Amount';
            Editable = false;
        }
        field(18; "Urgency Reason"; Text[250])
        {
            Caption = 'Urgency Reason';
            Editable = false;
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key(Employee; "Employee No.", Status)
        {
        }
    }

    trigger OnInsert()
    begin
        if "No." = '' then
            "No." := GetNextRequestNo();
        "Submitted On" := CurrentDateTime;
        "Updated On" := CurrentDateTime;
        Status := Status::Submitted;
    end;

    procedure SetDetailsJson(Value: Text)
    var
        DetailsOutStream: OutStream;
    begin
        Clear("Details JSON");
        "Details JSON".CreateOutStream(DetailsOutStream, TextEncoding::UTF8);
        DetailsOutStream.WriteText(Value);
        ApplyDetailsFromJson(Value);
    end;

    procedure GetDetailsJson(): Text
    var
        DetailsInStream: InStream;
        Line: Text;
        Result: Text;
    begin
        CalcFields("Details JSON");
        if not "Details JSON".HasValue() then
            exit('');
        "Details JSON".CreateInStream(DetailsInStream, TextEncoding::UTF8);
        while not DetailsInStream.EOS do begin
            DetailsInStream.ReadText(Line);
            Result += Line;
        end;
        exit(Result);
    end;

    local procedure ApplyDetailsFromJson(DetailsJson: Text)
    var
        Details: JsonObject;
        Token: JsonToken;
        DateText: Text;
        AmountText: Text;
    begin
        if not Details.ReadFrom(DetailsJson) then
            exit;

        Purpose := CopyStr(FirstDetailText(Details, 'purpose', 'guaranteePurpose', 'mortgagePurpose', 'loanPurpose', 'purposeOfTravel'), 1, MaxStrLen(Purpose));
        if Details.Get('requiredByDate', Token) then begin
            DateText := CopyStr(Token.AsValue().AsText(), 1, MaxStrLen(DateText));
            if DateText <> '' then
                Evaluate("Required By Date", DateText);
        end;
        "Delivery Method" := CopyStr(DetailText(Details, 'deliveryMethod'), 1, MaxStrLen("Delivery Method"));
        if Details.Get('monthlyBasicSalary', Token) then begin
            AmountText := CopyStr(Token.AsValue().AsText(), 1, MaxStrLen(AmountText));
            if AmountText <> '' then
                Evaluate("Monthly Basic Salary", AmountText);
        end;
        if Details.Get('loanAmount', Token) then begin
            AmountText := CopyStr(Token.AsValue().AsText(), 1, MaxStrLen(AmountText));
            if AmountText <> '' then
                Evaluate("Requested Loan Amount", AmountText);
        end;
        "Urgency Reason" := CopyStr(DetailText(Details, 'urgentReason'), 1, MaxStrLen("Urgency Reason"));
    end;

    local procedure DetailText(Details: JsonObject; FieldKey: Text): Text
    var
        Token: JsonToken;
    begin
        if Details.Get(FieldKey, Token) then
            exit(Token.AsValue().AsText());
        exit('');
    end;

    local procedure FirstDetailText(Details: JsonObject; Key1: Text; Key2: Text; Key3: Text; Key4: Text; Key5: Text): Text
    var
        Token: JsonToken;
        ValueText: Text;
    begin
        if Details.Get(Key1, Token) then begin
            ValueText := Token.AsValue().AsText();
            if ValueText <> '' then
                exit(ValueText);
        end;
        if Details.Get(Key2, Token) then begin
            ValueText := Token.AsValue().AsText();
            if ValueText <> '' then
                exit(ValueText);
        end;
        if Details.Get(Key3, Token) then begin
            ValueText := Token.AsValue().AsText();
            if ValueText <> '' then
                exit(ValueText);
        end;
        if Details.Get(Key4, Token) then begin
            ValueText := Token.AsValue().AsText();
            if ValueText <> '' then
                exit(ValueText);
        end;
        if Details.Get(Key5, Token) then begin
            ValueText := Token.AsValue().AsText();
            if ValueText <> '' then
                exit(ValueText);
        end;
        exit('');
    end;

    local procedure GetNextRequestNo(): Code[20]
    var
        LastRequest: Record "Portal HR Letter Request";
        Existing: Record "Portal HR Letter Request";
        Candidate: Code[20];
        Sequence: Integer;
    begin
        LastRequest.LockTable();
        LastRequest.SetCurrentKey("No.");
        LastRequest.SetFilter("No.", 'LTR-*');
        if LastRequest.FindLast() then
            Sequence := SequenceFromNo(LastRequest."No.");

        repeat
            Sequence += 1;
            Candidate := CopyStr('LTR-' + PadSequence(Sequence), 1, MaxStrLen(Candidate));
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
