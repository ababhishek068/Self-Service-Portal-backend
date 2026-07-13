Table 50333 "HR Appraisal Periods - UP"
{
    DrillDownPageID = "HR Appraisal Period List";
    LookupPageID = "HR Appraisal Period List";

    fields
    {
        field(1; "Code"; Code[10]) { }
        field(2; Description; Text[100]) { }
        field(3; "Period Start Date"; Date) { }
        field(4; "Period End Date"; Date) { }
        field(5; Open; Boolean) { }
        field(6; "Close By"; Code[20]) { }
        field(7; "Opened By"; Code[20]) { }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
        key(Key2; Open) { }
    }

    fieldgroups { }

    trigger OnDelete()
    begin
        HRApp_Header.Reset;
        HRApp_Header.SetRange("Appraisal Period", Code);
        if not HRApp_Header.IsEmpty then begin
            Error('You cannot Delete this Period [ %1 ] because it is already in use in %2 Records',
                  Code, HRApp_Header.Count);
        end;
    end;

    trigger OnInsert()
    begin
        if Code = '' then begin
            HRAppPeriod.Reset();
            if HRAppPeriod.FindLast then begin
                Code := IncStr(HRAppPeriod.Code)
            end else begin
                Code := 'PER-0001';
            end;
        end;
    end;

    var
        HRAppPeriod: Record "HR Appraisal Periods - UP";
        HRApp_Header: Record "HR Appraisal Header - UP";
}

