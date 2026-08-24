// PATCH 4 — HRLeaveApplication.Table.al (table 50532)
// File: src/src/src/src/src/src/src/src/src/HR3/HR/HRLeaveApplication.Table.al
//
// Root cause (LV00125 / UAT 25 Jul 2026):
//   Days Applied OnValidate sums leave allocation WITHOUT filtering the active calendar.
//   When Allocated Days = 0 but prior-period leave was taken, the prorated formula
//     Earned := (daysWorked/365 * Allocated) - Taken
//   goes negative (e.g. -0.328767…) and blocks even 1 day with:
//     "You must not apply more days than earned days -0.32876712328767124"
//
// Fix:
//   1. Filter every HR Leave Allocation query by the active calendar code.
//   2. For annual leave, use the employee-card "Annual Leave balance" FlowField as the
//      authoritative entitlement (same source BC shows on the employee card).
//
// ---------------------------------------------------------------------------
// STEP A — In field(4; "Days Applied") trigger OnValidate var section ADD:
// ---------------------------------------------------------------------------
//     CardAnnualBalance: Decimal;
//
// ---------------------------------------------------------------------------
// STEP B — After HRLeaveCal.FindFirst() and the Count > 1 check, the three allocation
// blocks must each include the calendar filter. Example for "Total Leave Taken":
// ---------------------------------------------------------------------------
//
//     HRLeaveAlloc.Reset;
//     HRLeaveAlloc.SetRange("No.", "Employee No.");
//     HRLeaveAlloc.SetRange("Calendar Code", HRLeaveCal.Code);   // <-- ADD
//     HRLeaveAlloc.SetRange("Entry Type", HRLeaveAlloc."entry type"::"Negative Adjustment");
//     ...
//
// Repeat the SetRange("Calendar Code", HRLeaveCal.Code) line in the Reimbursed and
// Allocated blocks as well.
//
// ---------------------------------------------------------------------------
// STEP C — AFTER the Allocated Days block and BEFORE "if unlimited = false", ADD:
// ---------------------------------------------------------------------------
//
//     if Annual then begin
//         TestField("Employee No.");
//         HREmp.Reset();
//         HREmp.SetRange(HREmp."No.", rec."Employee No.");
//         if HREmp.FindFirst() then begin
//             HREmp.CalcFields("Annual Leave balance");
//             CardAnnualBalance := HREmp."Annual Leave balance";
//             "Current Leave Balance" := CardAnnualBalance;
//             "Earned Leave Days" := CardAnnualBalance;
//             Modify;
//         end;
//     end;
//
// This must run BEFORE the "Current Leave Balance < Days Applied" check so annual
// leave is not blocked when ledger components read 0 but the card shows a balance.
//
// ---------------------------------------------------------------------------
// STEP D — REPLACE the inner annual-leave block (prorated earned-days Error) with:
// ---------------------------------------------------------------------------

                    if Annual = true then begin
                        TestField("Employee No.");
                        HREmp.Reset();
                        HREmp.SetRange(HREmp."No.", rec."Employee No.");
                        if HREmp.FindFirst() then begin
                            HREmp.TestField("Date Of Joining the Company");
                            if HREmp.Status = HREmp.Status::Active then begin
                                if HREmp."Date Of Joining the Company" > HRLeaveCal."Start Date" then
                                    noofdaysworked := "Application Date" - HREmp."Date Of Joining the Company"
                                else
                                    if HREmp."Date Of Joining the Company" < HRLeaveCal."Start Date" then
                                        noofdaysworked := ("Application Date" - HRLeaveCal."Start Date");
                            end else
                                if HREmp.Status = HREmp.Status::InActive then
                                    noofdaysworked := HREmp."Date Of Leaving the Company" - HRLeaveCal."End Date";
                        end;

                        noofdaysworked := noofdaysworked + 1;
                        if noofdaysworked > 366 then
                            Error('The HR calendar has more than 365 days');

                        HREmp.CalcFields("Annual Leave balance");
                        CardAnnualBalance := HREmp."Annual Leave balance";

                        // Employee-card net balance is authoritative for annual leave.
                        "Current Leave Balance" := CardAnnualBalance;
                        "Earned Leave Days" := CardAnnualBalance;

                        // Keep prorated figure for display when allocation exists, but never
                        // let a negative prorated value block the application.
                        if ("Allocated Days" + "Reimbursed Days") > 0 then begin
                            if noofdaysworked <> 0 then
                                "Earned Leave Days" :=
                                    ((noofdaysworked / yearend) * ("Allocated Days" + "Reimbursed Days")) -
                                    "Current Total Leave Taken";
                            if "Earned Leave Days" < 0 then
                                "Earned Leave Days" := CardAnnualBalance;
                            if "Earned Leave Days" > CardAnnualBalance then
                                "Earned Leave Days" := CardAnnualBalance;
                        end;

                        Modify;

                        if "Days Applied" > "Earned Leave Days" then
                            Error(
                              'You must not apply more days than earned days ' +
                              Format("Earned Leave Days"));
                    end;

// ---------------------------------------------------------------------------
// STEP D — Apply the same SetRange("Calendar Code", HRLeaveCal.Code) to the duplicated
// allocation blocks inside field(59; "Select Whether Half Day") OnValidate (4 copies).
// ---------------------------------------------------------------------------
