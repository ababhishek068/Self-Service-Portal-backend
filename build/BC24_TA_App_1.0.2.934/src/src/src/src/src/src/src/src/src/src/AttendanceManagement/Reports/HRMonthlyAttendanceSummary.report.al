namespace PTL.HRMIS;
using Microsoft.Foundation.Company;
using Microsoft.Finance.Dimension;

report 52202537 "HR Monthly Attendance Summary"
{
    ApplicationArea = All;
    Caption = 'Attendance Monthly Summary';
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/AttendanceMonthlySummary.rdl';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(HREmployee; "HR-Employee")
        {
            RequestFilterFields = "No.", "Date Filter", "Global Dimension 1 Code", Status;

            column(No; "No.") { }
            column(FullName; "Full Name") { }
            //column(Project_Market; "Project Market") { }
            column(Cell_Phone_Number; "Cell Phone Number") { }
            column(E_Mail; "E-Mail") { }
            column(Company_E_Mail; "Company E-Mail") { }
            column(GlobalDimension1Code; "Global Dimension 1 Code") { }
            column(GlobalDimension2Code; "Global Dimension 2 Code") { }
            column(CompInfo_Name; CompInfo.Name) { }
            column(CompInfo_Email; CompInfo."E-Mail") { }
            column(CompInfo_Address; CompInfo.Address) { }
            column(CompInfo_Picture; CompInfo.Picture) { }
            column(ID_Number; "ID Number") { }
            column(Responsibility_Center; "Responsibility Center") { }
            column(Line_Manger_Names; "Supervisor No.") { }
            
            column(Tribe; Tribe) { }
            column(Work_Station; "Work Station") { }
            column(Gender; Gender) { }
            column(Marital_Status; "Marital Status") { }
            column(Date_Of_Joining_the_Company; "Date Of Joining the Company") { }
            column(Job_Title; "Job Title") { }
            
            column(Current_Contract_Start; "Date Of Joining the Company") { }
            column(Contract_End_Date; "Contract End Date") { }
            column(NHIF_No_; "NHIF No.") { }
            //column(SHIF_No_; "SHIF No.") { }
            //column(PIN_No_; "PIN No.") { }
            column(Daily_Rate; "Daily Rate") { }
            column(onleaveLbl; onleaveLbl)
            {
            }
            column(LeaveType; LeaveType)
            {
            }
            column(AbsentDays; AbsentDays)
            {
            }
            column(onLeaveDays; onLeaveDays)
            {

            }
            column(daysAttended; daysAttended)
            {
            }
            column(hoursWorked; Round(hoursWorked, 1, '>'))
            {
            }
            column(StartDateFilter; StartDate)
            {
            }
            column(EndDateFilter; EndDate)
            {
            }
            column(WorkingDays; WorkingDays)
            {

            }
            column(NonWorkingDays; NonWorkingDays)
            {

            }
            column(TotalMonthDays; TotalMonthDays)
            {

            }
            column(ReportTitle; ReportTitle)
            {

            }

            trigger OnPreDataItem()
            begin
                StartDate := StartDateFilter;
                EndDate := EndDateFilter;
                SetFilter("Global Dimension 1 Code", projectCode);
            end;

            trigger OnAfterGetRecord()
            begin
                daysAttended := 0;
                hoursWorked := 0;
                AbsentDays := 0;
                onLeaveDays := 0;

                CurrentDate := StartDate;

                while CurrentDate <= EndDate do begin

                    HRAttendanceLedger.Reset();
                    HRAttendanceLedger.SetRange("Staff No.", HREmployee."No.");
                    HRAttendanceLedger.SetRange(date, CurrentDate);
                    if hrAttendanceLedger.Find('-') then begin
                        if HRAttendanceLedger."Entry Type" = HRAttendanceLedger."Entry Type"::Present then begin
                            daysAttended += 1;
                            // FIXME: Calculate hoursworked with job queue which is to run at 8 pm for those who have signed out
                            hoursWorked += Round(HrAttendanceLedger."Hours Worked", 1, '=');
                        end;
                        if HRAttendanceLedger."Entry Type" = HRAttendanceLedger."Entry Type"::Absence then
                            AbsentDays += 1;
                        if HRAttendanceLedger."Entry Type" = HRAttendanceLedger."Entry Type"::"On Leave" then
                            onLeaveDays += 1;
                    end;

                    CurrentDate := CalcDate('<+1D>', CurrentDate);
                end;


                // PTLFactory.UpdateEmployeeAbsence(StartDateFilter, EndDateFilter, HREmployee."No.");
                // Calculate Days Attended and Hours Worked
                /* HrAttendanceLedger.Reset();
                HrAttendanceLedger.SetRange("Staff No.", "No.");
                HrAttendanceLedger.SetRange(Date, StartDateFilter, EndDateFilter);
                HrAttendanceLedger.SetRange("Entry Type", HrAttendanceLedger."Entry Type"::Present);
                if HrAttendanceLedger.FindSet() then
                    repeat
                        // Increment the number of days attended
                        daysAttended += 1;
                        // Increment the number of hours worked
                        hoursWorked += Round(HrAttendanceLedger."Hours Worked", 1, '=');
                    until HrAttendanceLedger.Next() = 0; */

            end;
        }
    }

    requestpage
    {
        SaveValues = true;
        layout
        {
            area(content)
            {
                group("Date Filter")
                {
                    field(StartDate2; StartDateFilter)
                    {
                        Caption = 'Start Date';
                        ToolTip = 'Specifies the value of the Start Date field.';
                    }
                    field(EndDate2; EndDateFilter)
                    {
                        Caption = 'End Date';
                        ToolTip = 'Specifies the value of the End Date field.';
                    }
                    field(projectCode; projectCode)
                    {
                        ApplicationArea = All;
                        Caption = 'Project Code';
                        TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
                        ToolTip = 'Project Code';
                    }
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
    trigger OnPreReport()
    begin
        CompInfo.Get();
        CompInfo.CalcFields(CompInfo.Picture);
        NonWorkingDays := 0;
        WorkingDays := 0;
        TotalMonthDays := 0;


        if StartDateFilter = 0D then
            Error('Start Date is required');
        if EndDateFilter = 0D then
            Error('End Date is required');
        if projectCode = '' then
            //Error('Project is required');

        ReportTitle := projectCode + ' Monthly Attendance Summary Report' + ' From ' + Format(StartDateFilter) + ' To ' + Format(EndDateFilter);


        // HREmployee.SetFilter(IsWaitingExit, '=%1', false);
        // HREmployee.SetFilter(Status, '=%1', HREmployee.Status::Active);
        HRLeaveCalendar.Reset();
        //HRLeaveCalendar.SetRange("Global Dimension 1 Code", projectCode);
        HRLeaveCalendar.SetRange(Current, true);
        if HRLeaveCalendar.FindFirst() then begin
            HRLeaveCalendarLines.Reset();
            HRLeaveCalendarLines.SetRange("Code", HRLeaveCalendar.Code);
            HRLeaveCalendarLines.SetRange(Date, StartDateFilter, EndDateFilter);
            HRLeaveCalendarLines.setrange("Non Working", true);
            NonWorkingDays := HRLeaveCalendarLines.Count();

            HRLeaveCalendarLines.Reset();
            HRLeaveCalendarLines.SetRange("Code", HRLeaveCalendar.Code);
            HRLeaveCalendarLines.SetRange(Date, StartDateFilter, EndDateFilter);
            HRLeaveCalendarLines.setrange("Non Working", false);
            WorkingDays := HRLeaveCalendarLines.Count();
        end;

        TotalMonthDays := WorkingDays + NonWorkingDays;

    end;

    var
        CompInfo: Record "Company Information";
        HrAttendanceLedger: Record "HR Attendance Ledger";
        HRLeaveCalendar: Record "HR Leave Calendar";
        HRLeaveCalendarLines: Record "HR Leave Calendar Lines";
        projectCode: Code[20];
        CurrentDate: Date;
        EndDate: Date;
        EndDateFilter: Date;
        StartDate: Date;
        StartDateFilter: Date;
        hoursWorked: Decimal;
        AbsentDays: Integer;
        daysAttended: Integer;
        NonWorkingDays: Integer;
        onLeaveDays: Integer;
        WorkingDays: Integer;
        TotalMonthDays: Integer;
        LeaveType: Text;
        onleaveLbl: Text;
        ReportTitle: Text;
}
