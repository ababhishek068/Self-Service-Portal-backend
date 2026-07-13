namespace PTL.HRMIS;
using Microsoft.Foundation.Company;
using Microsoft.Finance.Dimension;

report 52202551 "HR Attendance Register"
{
    ApplicationArea = All;
    Caption = 'Attendance Register';
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Attendance/AttendanceReportColumn.rdl';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(HREmployee; "HR-Employee")
        {
            // exclude those employees who are under exit
            // and those who are not active
            RequestFilterFields = "No.", "Global Dimension 1 Code";

            // DataItemTableView =
            column(CompInfo_Name; CompInfo.Name) { }
            column(CompInfo_Email; CompInfo."E-Mail") { }
            column(CompInfo_Address; CompInfo.Address) { }
            column(CompInfo_Picture; CompInfo.Picture) { }
            column(No; "No.")
            {
            }
            column(fullName; "Full Name")
            {
            }
            //column(Project_Market; "Project Market") { }
            column(Cell_Phone_Number; "Cell Phone Number") { }
            column(E_Mail; "E-Mail") { }
            column(Company_E_Mail; "Company E-Mail") { }
            column(GlobalDimension1Code; "Global Dimension 1 Code") { }
            column(GlobalDimension2Code; "Global Dimension 2 Code") { }
            
            column(ID_Number; "ID Number") { }
            column(Responsibility_Center; "Responsibility Center") { }
            column(Supervisor_No_;"Supervisor No."){}
            column(Tribe;Tribe) { }
            column(Work_Station; "Work Station") { }
            column(Gender; Gender) { }
            column(Marital_Status; "Marital Status") { }
            column(Date_Of_Joining_the_Company; "Date Of Joining the Company") { }
            column(Job_Title; "Job Title") { }
            //column(Current_Contract_Start; "Current Contract Start") { }
            column(Contract_End_Date; "Contract End Date") { }
            column(NHIF_No_; "NHIF No.") { }
            // column(SHIF_No_; "SHIF No.") { }
            // column(PIN_No_; "PIN No.") { }
            column(Daily_Rate; "Daily Rate") { }
            column(noOfDays; noOfDays) { }
            column(NoofLeaves; NoofLeaves) { }
            column(AbsentDays; AbsentDays) { }
            column(NoOfDaysInMonth; NoOfDaysInMonth) { }
            column(NonWorkingDays; NonWorkingDays) { }
            column(WorkingDays; WorkingDays) { }
            column(ReportTitle; ReportTitle) { }
            column(w1; w1) { }
            column(w2; w2) { }
            column(w3; w3) { }
            column(w4; w4) { }
            column(w5; w5) { }
            column(w6; w6) { }
            column(w7; w7) { }
            column(w8; w8) { }
            column(w9; w9) { }
            column(w10; w10) { }
            column(w11; w11) { }
            column(w12; w12) { }
            column(w13; w13) { }
            column(w14; w14) { }
            column(w15; w15) { }
            column(w16; w16) { }
            column(w17; w17) { }
            column(w18; w18) { }
            column(w19; w19) { }
            column(w20; w20) { }
            column(w21; w21) { }
            column(w22; w22) { }
            column(w23; w23) { }
            column(w24; w24) { }
            column(w25; w25) { }
            column(w26; w26) { }
            column(w27; w27) { }
            column(w28; w28) { }
            column(w29; w29) { }
            column(w30; w30) { }
            column(w31; w31) { }
            column(d1; d1) { }
            column(d2; d2) { }
            column(d3; d3) { }
            column(d4; d4) { }
            column(d5; d5) { }
            column(d6; d6) { }
            column(d7; d7) { }
            column(d8; d8) { }
            column(d9; d9) { }
            column(d10; d10) { }
            column(d11; d11) { }
            column(d12; d12) { }
            column(d13; d13) { }
            column(d14; d14) { }
            column(d15; d15) { }
            column(d16; d16) { }
            column(d17; d17) { }
            column(d18; d18) { }
            column(d19; d19) { }
            column(d20; d20) { }
            column(d21; d21) { }
            column(d22; d22) { }
            column(d23; d23) { }
            column(d24; d24) { }
            column(d25; d25) { }
            column(d26; d26) { }
            column(d27; d27) { }
            column(d28; d28) { }
            column(d29; d29) { }
            column(d30; d30) { }
            column(d31; d31) { }
            column(AttendanceTime1; format(AttendanceTime[1])) { }
            column(AttendanceTime2; format(AttendanceTime[2])) { }
            column(AttendanceTime3; format(AttendanceTime[3])) { }
            column(AttendanceTime4; format(AttendanceTime[4])) { }
            column(AttendanceTime5; format(AttendanceTime[5])) { }
            column(AttendanceTime6; format(AttendanceTime[6])) { }
            column(AttendanceTime7; format(AttendanceTime[7])) { }
            column(AttendanceTime8; format(AttendanceTime[8])) { }
            column(AttendanceTime9; format(AttendanceTime[9])) { }
            column(AttendanceTime10; format(AttendanceTime[10])) { }
            column(AttendanceTime11; format(AttendanceTime[11])) { }
            column(AttendanceTime12; format(AttendanceTime[12])) { }
            column(AttendanceTime13; format(AttendanceTime[13])) { }
            column(AttendanceTime14; format(AttendanceTime[14])) { }
            column(AttendanceTime15; format(AttendanceTime[15])) { }
            column(AttendanceTime16; format(AttendanceTime[16])) { }
            column(AttendanceTime17; format(AttendanceTime[17])) { }
            column(AttendanceTime18; format(AttendanceTime[18])) { }
            column(AttendanceTime19; format(AttendanceTime[19])) { }
            column(AttendanceTime20; format(AttendanceTime[20])) { }
            column(AttendanceTime21; format(AttendanceTime[21])) { }
            column(AttendanceTime22; format(AttendanceTime[22])) { }
            column(AttendanceTime23; format(AttendanceTime[23])) { }
            column(AttendanceTime24; format(AttendanceTime[24])) { }
            column(AttendanceTime25; format(AttendanceTime[25])) { }
            column(AttendanceTime26; format(AttendanceTime[26])) { }
            column(AttendanceTime27; format(AttendanceTime[27])) { }
            column(AttendanceTime28; format(AttendanceTime[28])) { }
            column(AttendanceTime29; format(AttendanceTime[29])) { }
            column(AttendanceTime30; format(AttendanceTime[30])) { }
            column(AttendanceTime31; format(AttendanceTime[31])) { }

            trigger OnPreDataItem()
            begin
                HREmployee.SetFilter("Global Dimension 1 Code", projectCode);
            end;

            trigger OnAfterGetRecord()
            begin

                noOfDays := 0;
                NoofLeaves := 0;
                AbsentDays := 0;
                Counter += 1;

                EmpCurrentDate := StartDate;

                NoOfDaysInMonth := Date2DMY(EndDate, 1);

                for k := 1 to NoOfDaysInMonth do
                    AttendanceTime[k] := '';

                // loop though days of the month while increasing the date by 1
                // for each day check if the employee is present or absent
                //
                for k := 1 to NoOfDaysInMonth do begin

                    HRAttendanceLedger.Reset();
                    HRAttendanceLedger.SetRange("Staff No.", HREmployee."No.");
                    HRAttendanceLedger.SetRange(date, EmpCurrentDate);
                    if hrAttendanceLedger.Find('-') then begin
                        if HRAttendanceLedger."Entry Type" = HRAttendanceLedger."Entry Type"::Present then 
                        begin
                            noOfDays += 1;
                            AttendanceTime[k] := Format(HRAttendanceLedger."Time In");

                        end;
                        if HRAttendanceLedger."Entry Type" = HRAttendanceLedger."Entry Type"::Absence then
                        begin
                            AbsentDays += 1;
                            AttendanceTime[k] := 'Absent';
                        end;
                        if HRAttendanceLedger."Entry Type" = HRAttendanceLedger."Entry Type"::"On Leave" then
                        begin
                            NoofLeaves += 1;
                            AttendanceTime[k] := 'On Leave';
                        end;
                    end;

                    EmpCurrentDate := CalcDate('<+1D>', EmpCurrentDate); // May not calculate the last day
                end;

                /* while EmpCurrentDate <= EndDate do begin

                    HRAttendanceLedger.Reset();
                    HRAttendanceLedger.SetLoadFields("Entry Type", "Staff No.", Date, "login date time");
                    HRAttendanceLedger.SetRange("Staff No.", HREmployee."No.");
                    HRAttendanceLedger.SetRange(date, EmpCurrentDate);
                    if hrAttendanceLedger.Find('-') then begin
                        if HRAttendanceLedger."Entry Type" = HRAttendanceLedger."Entry Type"::Present then begin
                            noOfDays += 1;
                            // AttendanceTime[l] := Format(HRAttendanceLedger."Time In");
                            AttendanceTime[k] := 'Present';
                        end;
                        if HRAttendanceLedger."Entry Type" = HRAttendanceLedger."Entry Type"::Absence then begin
                            AbsentDays += 1;
                            AttendanceTime[k] := 'Absent';
                        end;
                        if HRAttendanceLedger."Entry Type" = HRAttendanceLedger."Entry Type"::"On Leave" then begin
                            NoofLeaves += 1;
                            AttendanceTime[k] := 'On Leave';
                        end;
                    end;

                    EmpCurrentDate := CalcDate('<+1D>', EmpCurrentDate);
                end; */
            end;
        }
    }
    requestpage
    {
        SaveValues = true;
        layout
        {
            area(Content)
            {
                group(Filters)
                {
                    field(projectCode; projectCode)
                    {
                        ApplicationArea = All;
                        Caption = 'Project Code';
                        TableRelation = "Dimension Value".Code where("Global Dimension No." = filter(1));
                        ToolTip = 'Project Code';
                    }
                    field(StartDate; StartDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Start Date';
                        ToolTip = 'Start Date';
                    }
                    field(EndDate; EndDate)
                    {
                        ApplicationArea = All;
                        Caption = 'End Date';
                        ToolTip = 'End Date';
                    }
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
    trigger OnPreReport()
    begin
        CompInfo.Get();
        CompInfo.CalcFields(CompInfo.Picture);

        i := 0;
        WorkingDays := 0;
        NonWorkingDays := 0;
        WeekDay := '';
        WeekDay1 := '';
        TotalDays := 0;
        TotalHours := 0;
        Counter := 0;

        if StartDate = 0D then
            Error('Start Date is required');
        if EndDate = 0D then
            Error('End Date is required');
        // if projectCode = '' then
        //     Error('Project is required');

        ReportTitle :=' Attendance Register' + ' From ' + Format(StartDate) + ' To ' + Format(EndDate);
        //ReportTitle := projectCode + ' Attendance Register' + ' From ' + Format(StartDate) + ' To ' + Format(EndDate);

        CurrentDate := StartDate;

        // Calculate total number of working and non-working days in the month
        HRLeaveCalendar.Reset();
        //HRLeaveCalendar.SetRange("Global Dimension 1 Code", projectCode);
        HRLeaveCalendar.SetRange(Current, true);
        if HRLeaveCalendar.FindFirst() then begin
            HRLeaveCalendarLines.Reset();
            HRLeaveCalendarLines.SetRange("Code", HRLeaveCalendar.Code);
            HRLeaveCalendarLines.SetRange(Date, StartDate, EndDate);
            HRLeaveCalendarLines.setrange("Non Working", true);
            if HRLeaveCalendarLines.Find('-') then
                NonWorkingDays := HRLeaveCalendarLines.Count;

            HRLeaveCalendarLines.Reset();
            HRLeaveCalendarLines.SetRange("Code", HRLeaveCalendar.Code);
            HRLeaveCalendarLines.SetRange(Date, StartDate, EndDate);
            HRLeaveCalendarLines.setrange("Non Working", false);
            if HRLeaveCalendarLines.Find('-') then
                WorkingDays := HRLeaveCalendarLines.Count;
        end;

        // Get the number of days in the month from end date
        NoOfDaysInMonth := Date2DMY(EndDate, 1);

        // Get week numbers now
        for i := 1 to NoOfDaysInMonth do begin
            WeekDay := Format(CurrentDate, 0, '<Weekday Text>');
            Weekday1 := COPYSTR(Weekday1, 1, 3);

            j := i;
            case j of
                1:
                    BEGIN
                        w1 := Weekday;
                        d1 := '1st';

                        CurrentDate := CurrentDate + 1;
                    END;
                2:
                    BEGIN
                        w2 := Weekday;
                        d2 := '2nd';

                        CurrentDate := CurrentDate + 1;
                    END;
                3:
                    BEGIN
                        w3 := Weekday;
                        d3 := '3rd';

                        CurrentDate := CurrentDate + 1;
                    END;
                4:
                    BEGIN
                        w4 := Weekday;
                        d4 := '4th';

                        CurrentDate := CurrentDate + 1;
                    END;
                5:
                    BEGIN
                        w5 := Weekday;
                        d5 := '5th';

                        CurrentDate := CurrentDate + 1;
                    END;
                6:
                    BEGIN
                        w6 := Weekday;
                        d6 := '6th';

                        CurrentDate := CurrentDate + 1;
                    END;
                7:
                    BEGIN
                        w7 := Weekday;
                        d7 := '7th';

                        CurrentDate := CurrentDate + 1;
                    END;
                8:
                    BEGIN
                        w8 := Weekday;
                        d8 := '8th';

                        CurrentDate := CurrentDate + 1;
                    END;
                9:
                    BEGIN
                        w9 := Weekday;
                        d9 := '9th';

                        CurrentDate := CurrentDate + 1;
                    END;
                10:
                    BEGIN
                        w10 := Weekday;
                        d10 := '10th';
                        CurrentDate := CurrentDate + 1;
                    END;
                11:
                    BEGIN
                        w11 := Weekday;
                        d11 := '11th';

                        CurrentDate := CurrentDate + 1;
                    END;
                12:
                    BEGIN
                        w12 := Weekday;
                        d12 := '12th';

                        CurrentDate := CurrentDate + 1;
                    END;
                13:
                    BEGIN
                        w13 := Weekday;
                        d13 := '13th';

                        CurrentDate := CurrentDate + 1;
                    END;
                14:
                    BEGIN
                        w14 := Weekday;
                        d14 := '14th';

                        CurrentDate := CurrentDate + 1;
                    END;
                15:
                    BEGIN
                        w15 := Weekday;
                        d15 := '15th';

                        CurrentDate := CurrentDate + 1;
                    END;
                16:
                    BEGIN
                        w16 := Weekday;
                        d16 := '16th';

                        CurrentDate := CurrentDate + 1;
                    END;
                17:
                    BEGIN
                        w17 := Weekday;
                        d17 := '17th';

                        CurrentDate := CurrentDate + 1;
                    END;
                18:
                    BEGIN
                        w18 := Weekday;
                        d18 := '18th';

                        CurrentDate := CurrentDate + 1;
                    END;
                19:
                    BEGIN
                        w19 := Weekday;
                        d19 := '19th';

                        CurrentDate := CurrentDate + 1;
                    END;
                20:
                    BEGIN
                        w20 := Weekday;
                        d20 := '20th';

                        CurrentDate := CurrentDate + 1;
                    END;
                21:
                    BEGIN
                        w21 := Weekday;
                        d21 := '21st';

                        CurrentDate := CurrentDate + 1;
                    END;
                22:
                    BEGIN
                        w22 := Weekday;
                        d22 := '22nd';

                        CurrentDate := CurrentDate + 1;
                    END;
                23:
                    BEGIN
                        w23 := Weekday;
                        d23 := '23rd';

                        CurrentDate := CurrentDate + 1;
                    END;
                24:
                    BEGIN
                        w24 := Weekday;
                        d24 := '24th';

                        CurrentDate := CurrentDate + 1;
                    END;
                25:
                    BEGIN
                        w25 := Weekday;
                        d25 := '25th';

                        CurrentDate := CurrentDate + 1;
                    END;
                26:
                    BEGIN
                        w26 := Weekday;
                        d26 := '26th';

                        CurrentDate := CurrentDate + 1;
                    END;
                27:
                    BEGIN
                        w27 := Weekday;
                        d27 := '27th';

                        CurrentDate := CurrentDate + 1;
                    END;
                28:
                    BEGIN
                        w28 := Weekday;
                        d28 := '28th';

                        CurrentDate := CurrentDate + 1;
                    END;
                29:
                    BEGIN
                        w29 := Weekday;
                        d29 := '29th';

                        CurrentDate := CurrentDate + 1;
                    END;
                30:
                    BEGIN
                        w30 := Weekday;
                        d30 := '30th';

                        CurrentDate := CurrentDate + 1;
                    END;
                31:
                    BEGIN
                        w31 := Weekday1;
                        d31 := '31st';

                        CurrentDate := CurrentDate + 1;
                    END
            end;
        end;
    end;

    var
        CompInfo: Record "Company Information";
        HRAttendanceLedger: Record "HR Attendance Ledger";
        HRLeaveCalendar: Record "HR Leave Calendar";
        HRLeaveCalendarLines: Record "HR Leave Calendar Lines";
        projectCode: Code[20];
        CurrentDate: Date;
        EmpCurrentDate: Date;
        EndDate: date;
        StartDate: Date;
        TotalHours: Decimal;
        Counter: Integer;
        i: Integer;
        j: Integer;
        k: Integer;
        l: Integer;
        NonWorkingDays: Integer;
        noOfDays: Integer;
        NoOfDaysInMonth: Integer;
        NoofLeaves: Integer;
        AbsentDays: Integer;
        TotalDays: Integer;
        WorkingDays: Integer;
        d1: Text[20];
        d2: Text[20];
        d3: Text[20];
        d4: Text[20];
        d5: Text[20];
        d6: Text[20];
        d7: Text[20];
        d8: Text[20];
        d9: Text[20];
        d10: Text[20];
        d11: Text[20];
        d12: Text[20];
        d13: Text[20];
        d14: Text[20];
        d15: Text[20];
        d16: Text[20];
        d17: Text[20];
        d18: Text[20];
        d19: Text[20];
        d20: Text[20];
        d21: Text[20];
        d22: Text[20];
        d23: Text[20];
        d24: Text[20];
        d25: Text[20];
        d26: Text[20];
        d27: Text[20];
        d28: Text[20];
        d29: Text[20];
        d30: Text[20];
        d31: Text[20];
        w1: Text[20];
        w2: Text[20];
        w3: Text[20];
        w4: Text[20];
        w5: Text[20];
        w6: Text[20];
        w7: Text[20];
        w8: Text[20];
        w9: Text[20];
        w10: Text[20];
        w11: Text[20];
        w12: Text[20];
        w13: Text[20];
        w14: Text[20];
        w15: Text[20];
        w16: Text[20];
        w17: Text[20];
        w18: Text[20];
        w19: Text[20];
        w20: Text[20];
        w21: Text[20];
        w22: Text[20];
        w23: Text[20];
        w24: Text[20];
        w25: Text[20];
        w26: Text[20];
        w27: Text[20];
        w28: Text[20];
        w29: Text[20];
        w30: Text[20];
        w31: Text[20];
        WeekDay: Text[20];
        WeekDay1: Text[20];
        ReportTitle: Text[150];
        // array of 30 values
        AttendanceTime: array[31] of Text;
}
