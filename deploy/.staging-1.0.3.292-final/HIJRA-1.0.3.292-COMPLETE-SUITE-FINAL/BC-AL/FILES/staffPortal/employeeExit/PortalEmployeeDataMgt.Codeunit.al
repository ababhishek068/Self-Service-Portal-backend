/// <summary>
/// Supplies the SSP with the same leave balance Business Central shows on the leave application card.
/// Publish as SOAP service CuPortalEmployeeData (method GetLeaveBalance).
/// </summary>
codeunit 52105 "Portal Employee Data Mgt."
{
    procedure GetLeaveBalance(employeeNo: Code[20]; leaveType: Code[30]): Text
    var
        Employee: Record "HR-Employee";
        LeaveTypeSetup: Record "Leave Types";
        HRLeaveCal: Record "HR Leave Calendar.";
        HRLeaveAlloc: Record "HR Leave Allocation";
        Result: JsonObject;
        ResultText: Text;
        AllocatedDays: Decimal;
        ReimbursedDays: Decimal;
        CurrentTotalLeaveTaken: Decimal;
        CurrentLeaveBalance: Decimal;
        CardAnnualBalance: Decimal;
        IsAnnual: Boolean;
        CurrentPeriod: Integer;
        OpenNet: Decimal;
        CurrentPeriodNet: Decimal;
        HasOpenEntries: Boolean;
        HasCurrentPeriodEntries: Boolean;
        Ledger: Record "HR Leave Ledger";
    begin
        CurrentPeriod := Date2DMY(Today, 3);
        Employee.Get(employeeNo);

        Employee.SetRange("Period Year Filter", CurrentPeriod);
        Employee.SetFilter("Date Filter", '..%1', Today);
        // Employee.Page.al calculates the Annual Leave balance displayed on the
        // Employee Card from these three posted allocation FlowFields. The
        // "Annual Leave balance" table field itself is a normal Decimal field,
        // so reading it directly can return a stale value outside that page.
        Employee.CalcFields("Leave Allocation");
        Employee.CalcFields("Carry forward");
        Employee.CalcFields("Total Leave Taken");
        CardAnnualBalance :=
          Employee."Leave Allocation" + Employee."Carry forward" + Employee."Total Leave Taken";

        IsAnnual := false;
        if LeaveTypeSetup.Get(leaveType) then
            IsAnnual := LeaveTypeSetup.Annual;

        Clear(AllocatedDays);
        Clear(ReimbursedDays);
        Clear(CurrentTotalLeaveTaken);
        Clear(CurrentLeaveBalance);

        // Mirror HRLeaveApplication.field(4;"Days Applied").OnValidate — active calendar only.
        HRLeaveCal.Reset();
        HRLeaveCal.SetRange(Current, true);
        if HRLeaveCal.FindFirst() then begin
            if HRLeaveCal.Count > 1 then
                Error('There are currently %1 Active Leave Calendars. Please ensure one calendar is Active.', HRLeaveCal.Count);

            HRLeaveAlloc.Reset();
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

            CurrentLeaveBalance := (AllocatedDays + ReimbursedDays) - CurrentTotalLeaveTaken;
        end;

        if IsAnnual then begin
            CurrentLeaveBalance := CardAnnualBalance;
        end;

        // Keep the all-time statement total as diagnostic/non-annual fallback.
        // Never replace the annual Employee Card balance with this value: doing
        // that sums historical calendars and made E0083 display 162.37 instead
        // of the current Employee Card balance 57.00.
        HRLeaveAlloc.Reset();
        HRLeaveAlloc.SetRange("No.", employeeNo);
        HRLeaveAlloc.SetRange("Leave Type", leaveType);
        HRLeaveAlloc.SetRange(Posted, true);
        if not HRLeaveAlloc.IsEmpty() then begin
            HRLeaveAlloc.CalcSums("No. Of days");
            if not IsAnnual then
                CurrentLeaveBalance := HRLeaveAlloc."No. Of days";
        end;

        // Ledger metadata kept for diagnostics / annual fallbacks in older portal builds.
        Ledger.SetRange("Employee No", employeeNo);
        Ledger.SetRange("Leave Type", leaveType);
        Ledger.SetRange(Closed, false);
        HasOpenEntries := not Ledger.IsEmpty();
        Ledger.CalcSums("No. of Days");
        OpenNet := Ledger."No. of Days";

        Ledger.SetRange("Leave Period", CurrentPeriod);
        HasCurrentPeriodEntries := not Ledger.IsEmpty();
        Ledger.CalcSums("No. of Days");
        CurrentPeriodNet := Ledger."No. of Days";

        Result.Add('employeeNo', employeeNo);
        Result.Add('leaveType', leaveType);
        Result.Add('annualLeaveCode', Employee."Annual Leave Code");
        Result.Add('isAnnualLeave', IsAnnual);
        Result.Add('activeCalendarCode', HRLeaveCal.Code);
        Result.Add('allocatedDays', AllocatedDays);
        Result.Add('reimbursedDays', ReimbursedDays);
        Result.Add('currentTotalLeaveTaken', CurrentTotalLeaveTaken);
        Result.Add('currentLeaveBalance', CurrentLeaveBalance);
        Result.Add('cardAnnualLeaveBalance', CardAnnualBalance);
        // Employee."Earned Leave Days" is a single per-employee ANNUAL accrual
        // figure, not scoped to any leave type. Returning it unconditionally
        // leaked the employee's annual accrual (e.g. -30.32) into every
        // non-annual leave type's balance (Sick, Special, etc.) — only surface
        // it when the requested leaveType actually IS the annual type.
        if IsAnnual then
            Result.Add('earnedLeaveDays', Employee."Earned Leave Days")
        else
            Result.Add('earnedLeaveDays', 0);
        if LeaveTypeSetup.Get(leaveType) then begin
            Result.Add('setupDays', LeaveTypeSetup.Days);
            Result.Add('unlimitedDays', LeaveTypeSetup."Unlimited Days");
            AddMaximumApplicationDays(Result, LeaveTypeSetup);
        end;
        Result.Add('hasOpenEntries', HasOpenEntries);
        Result.Add('openNet', OpenNet);
        Result.Add('hasCurrentPeriodEntries', HasCurrentPeriodEntries);
        Result.Add('currentPeriodNet', CurrentPeriodNet);
        Result.WriteTo(ResultText);
        exit(ResultText);
    end;

    local procedure AddMaximumApplicationDays(var Result: JsonObject; LeaveTypeSetup: Record "Leave Types")
    var
        FieldMetadata: Record Field;
        LeaveTypeRef: RecordRef;
        MaximumDaysField: FieldRef;
    begin
        FieldMetadata.SetRange(TableNo, Database::"Leave Types");
        FieldMetadata.SetRange(FieldName, 'Maximum Application Days');
        if not FieldMetadata.FindFirst() then begin
            Result.Add('maximumApplicationDays', 0);
            exit;
        end;
        LeaveTypeRef.GetTable(LeaveTypeSetup);
        MaximumDaysField := LeaveTypeRef.Field(FieldMetadata."No.");
        Result.Add('maximumApplicationDays', Format(MaximumDaysField.Value, 0, 9));
    end;
}
