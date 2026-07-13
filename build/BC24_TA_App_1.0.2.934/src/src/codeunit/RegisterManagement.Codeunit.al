Codeunit 50019 "Register Management"
{
    SingleInstance = true;

    trigger OnRun()
    begin
    end;

    var
        RegisterNo: Integer;
        FromEntryNo: Integer;
        ToEntryNo: Integer;

    procedure ResetValues()
    begin
        RegisterNo := 0;
        FromEntryNo := 0;
        ToEntryNo := 0;
    end;

    procedure SetRegisterNumber(var "No.": Integer)
    begin
        RegisterNo := "No.";
    end;

    procedure SetFromEntryNumber(var "No.": Integer)
    begin
        FromEntryNo := "No.";
    end;

    procedure SetToEntryNumber(var "No.": Integer)
    begin
        ToEntryNo := "No.";
    end;

    procedure GetRegisterNumber() RegisterNumber: Integer
    begin
        RegisterNumber := RegisterNo;
        exit(RegisterNumber);
    end;

    procedure GetFromEntryNo() EntryNo: Integer
    begin
        EntryNo := FromEntryNo;
        exit(EntryNo);
    end;

    procedure GetToEntryNo() EntryNo: Integer
    begin
        EntryNo := ToEntryNo;
        exit(EntryNo);
    end;
}

