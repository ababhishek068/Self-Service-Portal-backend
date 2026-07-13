Report 50299 "Employee Leave Liability"
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
            column(ReportForNavId_1; 1) { }
            column(No_HREmployee; "HR-Employee"."No.") { }
            column(Names; "HR-Employee"."First Name" + ' ' + "HR-Employee"."Middle Name" + ' ' + "HR-Employee"."Last Name") { }
            column(LeaveAllocation_HREmployee; "HR-Employee"."Total (Leave Days)") { }
            column(LeaveTaken_HREmployee; "HR-Employee"."Total Leave Taken") { }

            column(LeaveBalance_HREmployee; "HR-Employee"."Leave Balance") { }
            column(DateFilter_HREmployee; "HR-Employee".GetFilter("Date Filter")) { }
            column(LeaveOveralBal_HREmployee; "HR-Employee"."Leave Balance") { }
            column(BrF; BrF) { }
            column(SalaryGrade_HREmployee; "HR-Employee"."Salary Grade") { }
            column(JobSpecification_HREmployee; "HR-Employee"."Job Title") { }
            column(CompLogo; CompInf.Picture) { }
            column(CompName; CompInf.Name) { }
            column(CurrSalary; CurrSalary) { }
            column(LeaveSalary; LeaveSalary) { }
            column(EarnedDays; EarnedDays) { }
            column(Total_Leave_Taken; "Total Leave Taken") { }
            column(LeaveBal; LeaveBal) { }

            trigger OnAfterGetRecord()
            var
                HRCU: Codeunit "HR Codeunit";
            begin
                CurrSalary := 0;
                LeaveSalary := 0;
                EarnedDays := hrcu.CalculateEarnedDays("HR-Employee"."No.");

                "HR-Employee".CalcFields("Leave Balance");
                "HR-Employee".CalcFields("Total Leave Taken");
                "HR-Employee".CalcFields("Reimbursed Leave Days");
                "HR-Employee".CalcFields("Carry forward");

                //BrF := "HR-Employee"."Leave Balance" - "HR-Employee"."Leave Balance";
                TakenDays := ABS(hrcu.CalculateTakenLeaveDays("HR-Employee"."No."));
                LeaveBal := (EarnedDays + "HR-Employee"."Carry forward" + "HR-Employee"."Reimbursed Leave Days") - TakenDays;
                if prSalary.get("HR-Employee"."No.") then begin
                    CurrSalary := prSalary."Basic Pay";
                    if CurrSalary > 0 then
                        //LeaveSalary := (CurrSalary / 30) * (EarnedDays - "HR-Employee"."Total Leave Taken");
                        LeaveSalary := (CurrSalary / 30) * LeaveBal;
                end;
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
        prSalary: Record "PR Salary Card";
        CurrSalary: Decimal;
        LeaveSalary: Decimal;
        EarnedDays: Decimal;
        LeaveBal: Decimal;
        TakenDays: Decimal;
}

