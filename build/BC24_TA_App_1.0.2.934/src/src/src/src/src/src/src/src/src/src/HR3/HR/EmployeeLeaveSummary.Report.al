Report 50151 "Employee Leave Summary"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/EmployeeLeaveSummary.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("HR-Employee"; "HR-Employee")
        {
            DataItemTableView = where(Status = const(active));
            RequestFilterFields = "No.", "Date Filter";
            CalcFields = "Carry forward", "Total Leave Taken";
            column(ReportForNavId_1; 1) { }
            column(No_HREmployee; "HR-Employee"."No.") { }
            column(Names; "HR-Employee"."First Name" + ' ' + "HR-Employee"."Middle Name" + ' ' + "HR-Employee"."Last Name") { }
            column(LeaveAllocation_HREmployee; "HR-Employee"."Total (Leave Days)") { }
            column(LeaveTaken_HREmployee; TakenDays) { }

            column(LeaveBalance_HREmployee; "HR-Employee"."Leave Balance") { }
            column(Reimbursed_Leave_Days; "Reimbursed Leave Days") { }
            column(Carry_forward; "Carry forward") { }
            column(DateFilter_HREmployee; "HR-Employee".GetFilter("Date Filter")) { }
            column(Total_Leave_Taken; "Total Leave Taken") { }
            column(BrF; BrF) { }
            column(EarnedDays; EarnedDays) { }
            column(ReimDays; ReimDays) { }
            column(LeaveBal; LeaveBal) { }

            column(SalaryGrade_HREmployee; "HR-Employee"."Salary Grade") { }
            column(JobSpecification_HREmployee; "HR-Employee"."Job Title") { }
            column(CompLogo; CompInf.Picture) { }
            column(CompName; CompInf.Name) { }
            column(HrCalender; HrCalender) { }

            trigger OnAfterGetRecord()
            var
                HRCU: Codeunit "HR Codeunit";
                HRCalendar: Record "HR Leave Calendar";
            begin
                EarnedDays := hrcu.CalculateEarnedDays("HR-Employee"."No.");
                BrF := hrcu.CalculateBrFDays("HR-Employee"."No.");
                TakenDays := ABS(hrcu.CalculateTakenLeaveDays("HR-Employee"."No."));

                "HR-Employee".CalcFields("Leave Balance");
                "HR-Employee".CalcFields("Total Leave Taken");
                "HR-Employee".CalcFields("Reimbursed Leave Days");
                "HR-Employee".CalcFields("Carry forward");

                ReimDays := "HR-Employee"."Reimbursed Leave Days";

                LeaveBal := (EarnedDays + "HR-Employee"."Reimbursed Leave Days" + "HR-Employee"."Carry forward") - TakenDays;

                HRCalendar.Reset();
                HRCalendar.SetRange(Current, true);
                if HRCalendar.Find('-') then HrCalender := HRCalendar.Code + ' - ' + HRCalendar.Description;
            end;

            trigger OnPreDataItem()
            begin
                CompInf.Get;
                CompInf.CalcFields(CompInf.Picture);
            end;
        }
    }

    requestpage
    {

        layout { }
        actions { }
    }

    labels { }

    var
        BrF: Decimal;
        CompInf: Record "Company Information";
        EarnedDays: Decimal;
        ReimDays: Decimal;
        TakenDays: Decimal;
        LeaveBal: Decimal;
        HrCalender: Code[20];
}

