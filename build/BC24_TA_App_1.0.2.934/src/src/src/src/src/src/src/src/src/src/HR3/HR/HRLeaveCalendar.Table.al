Table 50130 "HR Leave Calendar"
{

    fields
    {
        field(1; "Code"; Code[10])
        {
            Editable = true;
        }
        field(2; "Created By"; Text[100]) { }
        field(3; "Start Date"; Date) { }
        field(4; "End Date"; Date) { }
        field(5; Current; Boolean)
        {
            // Editable = false;
            trigger OnValidate()
            var
                HRLeaveCalendar: Record "HR Leave Calendar";
            begin
                if not Current then
                    exit;

                ValidateCalendarPeriod();

                HRLeaveCalendar.Reset();
                HRLeaveCalendar.SetFilter(Code, '<>%1', Code);
                HRLeaveCalendar.SetRange(Current, true);
                if HRLeaveCalendar.FindSet(true, false) then
                    HRLeaveCalendar.ModifyAll(Current, false);
            end;
        }
        field(6; Description; Text[100]) { }
        field(7; "No Series"; Code[10])
        {
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnDelete()
    var
        ERR_CALENDAR_DELETE: label 'You cannot Delete this Calendar [ %1  ] because there are [ %2 ]  Postings assocaited to it in  HR Leave Allocation Entries';
    begin

        HRLeaveAllocation.Reset;
        HRLeaveAllocation.SetRange("Calendar Code", Code);
        if not HRLeaveAllocation.IsEmpty then Error(ERR_CALENDAR_DELETE, Code, HRLeaveAllocation.Count);
    end;

    trigger OnInsert()
    var
        TheTable: Record "HR Leave Calendar";
    begin
        IF "Code" = '' THEN BEGIN
            TheTable.RESET;
            IF TheTable.FINDLAST THEN BEGIN
                Code := INCSTR(TheTable.Code)
            END ELSE BEGIN
                "Code" := 'CAL-00001';
            END;
        END;

    end;

    trigger OnModify()
    begin
        if Current then
            ValidateCalendarPeriod();
    end;

    var
        HRLeaveAllocation: Record "HR Leave Allocation";

    local procedure ValidateCalendarPeriod()
    var
        CalendarDays: Integer;
    begin
        TestField("Start Date");
        TestField("End Date");

        if "End Date" < "Start Date" then
            Error('HR leave calendar %1 has an end date before its start date.', Code);

        CalendarDays := ("End Date" - "Start Date") + 1;
        if CalendarDays > 365 then
            Error('HR leave calendar %1 has %2 days (%3..%4). Use a one-year period of 365 days or less.',
                Code, CalendarDays, "Start Date", "End Date");
    end;
}

