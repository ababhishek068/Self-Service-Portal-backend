Codeunit 50031 "HR Codeunit"
{

    trigger OnRun()
    begin
    end;

    var
        dayOfWeek: Integer;
        NextDay: Date;
        TEXTDATE1: label 'The Start date cannot be Greater then the end Date.';
        HREmp: Record "HR-Employee";

    procedure DetermineAge(DateOfBirth: Date; DateOfJoin: Date) AgeString: Text[150]
    var
        dayB: Integer;
        monthB: Integer;
        yearB: Integer;
        dayJ: Integer;
        monthJ: Integer;
        yearJ: Integer;
        Year: Integer;
        Month: Integer;
        Day: Integer;
        DateCat: Integer;
    begin
        if ((DateOfBirth <> 0D) and (DateOfJoin <> 0D)) then begin
            dayB := Date2dmy(DateOfBirth, 1);
            monthB := Date2dmy(DateOfBirth, 2);
            yearB := Date2dmy(DateOfBirth, 3);
            dayJ := Date2dmy(DateOfJoin, 1);
            monthJ := Date2dmy(DateOfJoin, 2);
            yearJ := Date2dmy(DateOfJoin, 3);
            Day := 0;
            Month := 0;
            Year := 0;
            DateCat := DateCategory(dayB, dayJ, monthB, monthJ, yearB, yearJ);
            case (DateCat) of
                1:
                    begin
                        Year := yearJ - yearB;
                        if monthJ >= monthB then
                            Month := monthJ - monthB
                        else begin
                            Month := (monthJ + 12) - monthB;
                            Year := Year - 1;
                        end;

                        if (dayJ >= dayB) then
                            Day := dayJ - dayB
                        else
                            if (dayJ < dayB) then begin
                                Day := (DetermineDaysInMonth(monthJ, yearJ) + dayJ) - dayB;
                                Month := Month - 1;
                            end;

                        AgeString := '%1  Years, %2  Months and #3## Days';
                        AgeString := StrSubstNo(AgeString, Year, Month, Day);

                    end;

                2, 3, 7:
                    begin
                        if (monthJ <> monthB) then begin
                            if monthJ >= monthB then
                                Month := monthJ - monthB
                            //  ELSE ERROR('The wrong date category!');
                        end;

                        if (dayJ <> dayB) then begin
                            if (dayJ >= dayB) then
                                Day := dayJ - dayB
                            else
                                if (dayJ < dayB) then begin
                                    Day := (DetermineDaysInMonth(monthJ, yearJ) + dayJ) - dayB;
                                    Month := Month - 1;
                                end;
                        end;

                        AgeString := '%1  Months %2 Days';
                        AgeString := StrSubstNo(AgeString, Month, Day);
                    end;
                4:
                    begin
                        Year := yearJ - yearB;
                        AgeString := '#1## Years';
                        AgeString := StrSubstNo(AgeString, Year);
                    end;
                5:
                    begin
                        if (dayJ >= dayB) then
                            Day := dayJ - dayB
                        else
                            if (dayJ < dayB) then begin
                                Day := (DetermineDaysInMonth(monthJ, yearJ) + dayJ) - dayB;
                                monthJ := monthJ - 1;
                                Month := (monthJ + 12) - monthB;
                                yearJ := yearJ - 1;
                            end;

                        Year := yearJ - yearB;
                        AgeString := '%1  Years, %2 Months and #3## Days';
                        AgeString := StrSubstNo(AgeString, Year, Month, Day);
                    end;
                6:
                    begin
                        if monthJ >= monthB then
                            Month := monthJ - monthB
                        else begin
                            Month := (monthJ + 12) - monthB;
                            yearJ := yearJ - 1;
                        end;
                        Year := yearJ - yearB;
                        AgeString := '%1  Years and #2## Months';
                        AgeString := StrSubstNo(AgeString, Year, Month);
                    end;
                else
                    AgeString := '';
            end;
        end else
            Message('For Date Calculation Enter All Applicable Dates!');
        exit;
    end;

    procedure DetermineDaysInMonth(Month: Integer; Year: Integer) DaysInMonth: Integer
    begin
        case (Month) of
            1:
                DaysInMonth := 31;
            2:
                begin
                    if (LeapYear(Year)) then
                        DaysInMonth := 29
                    else
                        DaysInMonth := 28;
                end;
            3:
                DaysInMonth := 31;
            4:
                DaysInMonth := 30;
            5:
                DaysInMonth := 31;
            6:
                DaysInMonth := 30;
            7:
                DaysInMonth := 31;
            8:
                DaysInMonth := 31;
            9:
                DaysInMonth := 30;
            10:
                DaysInMonth := 31;
            11:
                DaysInMonth := 30;
            12:
                DaysInMonth := 31;
            else
                Message('Not valid date. The month must be between 1 and 12');
        end;

        exit;
    end;

    procedure DateCategory(BDay: Integer; EDay: Integer; BMonth: Integer; EMonth: Integer; BYear: Integer; EYear: Integer) Category: Integer
    begin
        if ((EYear > BYear) and (EMonth <> BMonth) and (EDay <> BDay)) then
            Category := 1
        else
            if ((EYear = BYear) and (EMonth <> BMonth) and (EDay = BDay)) then
                Category := 2
            else
                if ((EYear = BYear) and (EMonth = BMonth) and (EDay <> BDay)) then
                    Category := 3
                else
                    if ((EYear > BYear) and (EMonth = BMonth) and (EDay = BDay)) then
                        Category := 4
                    else
                        if ((EYear > BYear) and (EMonth = BMonth) and (EDay <> BDay)) then
                            Category := 5
                        else
                            if ((EYear > BYear) and (EMonth <> BMonth) and (EDay = BDay)) then
                                Category := 6
                            else
                                if ((EYear = BYear) and (EMonth <> BMonth) and (EDay <> BDay)) then
                                    Category := 7
                                else
                                    if ((EYear = BYear) and (EMonth = BMonth) and (EDay = BDay)) then
                                        Category := 3
                                    else
                                        if ((EYear < BYear)) then
                                            Error(TEXTDATE1)
                                        else begin
                                            Category := 0;
                                            //ERROR('The start date cannot be after the end date.');
                                        end;
        exit;
    end;

    procedure LeapYear(Year: Integer) LY: Boolean
    var
        CenturyYear: Boolean;
        DivByFour: Boolean;
    begin
        CenturyYear := Year MOD 100 = 0;
        DivByFour := Year MOD 4 = 0;
        if ((not CenturyYear and DivByFour) or (Year MOD 400 = 0)) then
            LY := true
        else
            LY := false;
    end;

    procedure DetermineWeekends(DateStart: Date; DateEnd: Date) Weekends: Integer
    begin
        Weekends := 0;
        while (DateStart <= DateEnd) do begin
            dayOfWeek := Date2dwy(DateStart, 1);
            if (dayOfWeek = 6) or (dayOfWeek = 7) then
                Weekends := Weekends + 1;
            NextDay := CalculateNextDay(DateStart);
            DateStart := NextDay;
        end;
    end;

    procedure CalculateNextDay(Date: Date) NextDate: Date
    var
        today: Integer;
        month: Integer;
        year: Integer;
        nextDay: Integer;
        daysInMonth: Integer;
    begin
        today := Date2dmy(Date, 1);
        month := Date2dmy(Date, 2);
        year := Date2dmy(Date, 3);
        daysInMonth := DetermineDaysInMonth(month, year);
        nextDay := today + 1;
        if (nextDay > daysInMonth) then begin
            nextDay := 1;
            month := month + 1;
            if (month > 12) then begin
                month := 1;
                year := year + 1;
            end;
        end;
        NextDate := Dmy2date(nextDay, month, year);
    end;

    procedure ConvertDate(nDate: Date) strDate: Text[30]
    var
        lDay: Integer;
        lMonth: Integer;
        lYear: Integer;
        strDay: Text[4];
        StrMonth: Text[20];
        strYear: Text[6];
    begin
        //this function converts the date to the format required by ksps
        lDay := Date2dmy(nDate, 1);
        lMonth := Date2dmy(nDate, 2);
        lYear := Date2dmy(nDate, 3);

        if lDay = 1 then begin strDay := '1st' end;
        if lDay = 2 then begin strDay := '2nd' end;
        if lDay = 3 then begin strDay := '3rd' end;
        if lDay = 4 then begin strDay := '4th' end;
        if lDay = 5 then begin strDay := '5th' end;
        if lDay = 6 then begin strDay := '6th' end;
        if lDay = 7 then begin strDay := '7th' end;
        if lDay = 8 then begin strDay := '8th' end;
        if lDay = 9 then begin strDay := '9th' end;
        if lDay = 10 then begin strDay := '10th' end;
        if lDay = 11 then begin strDay := '11th' end;
        if lDay = 12 then begin strDay := '12th' end;
        if lDay = 13 then begin strDay := '13th' end;
        if lDay = 14 then begin strDay := '14th' end;
        if lDay = 15 then begin strDay := '15th' end;
        if lDay = 16 then begin strDay := '16th' end;
        if lDay = 17 then begin strDay := '17th' end;
        if lDay = 18 then begin strDay := '18th' end;
        if lDay = 19 then begin strDay := '19th' end;
        if lDay = 20 then begin strDay := '20th' end;
        if lDay = 21 then begin strDay := '21st' end;
        if lDay = 22 then begin strDay := '22nd' end;
        if lDay = 23 then begin strDay := '23rd' end;
        if lDay = 24 then begin strDay := '24th' end;
        if lDay = 25 then begin strDay := '25th' end;
        if lDay = 26 then begin strDay := '26th' end;
        if lDay = 27 then begin strDay := '27th' end;
        if lDay = 28 then begin strDay := '28th' end;
        if lDay = 29 then begin strDay := '29th' end;
        if lDay = 30 then begin strDay := '30th' end;
        if lDay = 31 then begin strDay := '31st' end;

        if lMonth = 1 then begin StrMonth := ' January ' end;
        if lMonth = 2 then begin StrMonth := ' February ' end;
        if lMonth = 3 then begin StrMonth := ' March ' end;
        if lMonth = 4 then begin StrMonth := ' April ' end;
        if lMonth = 5 then begin StrMonth := ' May ' end;
        if lMonth = 6 then begin StrMonth := ' June ' end;
        if lMonth = 7 then begin StrMonth := ' July ' end;
        if lMonth = 8 then begin StrMonth := ' August ' end;
        if lMonth = 9 then begin StrMonth := ' September ' end;
        if lMonth = 10 then begin StrMonth := ' October ' end;
        if lMonth = 11 then begin StrMonth := ' November ' end;
        if lMonth = 12 then begin StrMonth := ' December ' end;

        strYear := Format(lYear);
        //return the date
        strDate := strDay + StrMonth + strYear;
    end;

    procedure fn_CheckIDNumber(curr_IDNo: Code[20]) Exists: Boolean
    var
        IDFOUNDERROR: label 'ID No [ %1  ] is already in use in the System by an Employee.';
    begin
        //Check if ID Number is being used by another staff member
        Exists := false;

        Clear(HREmp);
        HREmp.SetRange(HREmp."ID Number", curr_IDNo);
        Exists := HREmp.Find;
        if Exists then Error(IDFOUNDERROR);
    end;

    procedure fn_SetStyle(curr_Status: Text): Text
    begin
        //DW - :-)

        //All Open / New documents
        if (curr_Status = 'Pending') or
           (curr_Status = 'Open') or
           (curr_Status = 'New')
        then
            exit('StandardAccent');

        //All  docs awaiting approval
        if (curr_Status = 'Pending Approval') then exit('Attention');

        //All Approved document
        if (curr_Status = 'Approved') then exit('AttentionAccent');
    end;

    procedure fn_UpdateControls(currDoc_Status: Text): Boolean
    begin
        if (currDoc_Status = 'New') or (currDoc_Status = 'Open') or (currDoc_Status = 'No') then begin
            exit(true);
        end else begin
            exit(false);
        end;
    end;

    procedure fnLastLineNo() LastLineNo: Integer
    var
        PRChangeLog: Record "HR Change Entries";
    begin
        PRChangeLog.Reset;
        if PRChangeLog.FindLast then begin
            LastLineNo := PRChangeLog."Line No";
        end else begin
            LastLineNo := 1;
        end;
    end;

    procedure fn_SuggestParticipants(SourceLineTable_ID: Integer; SourceDoc_No: Code[20]; Source_ID: Integer)
    var
        HRTrainLines: Record "HR Training App Lines";
    begin

        //  Dann - Function to suggest lines as per filtered list of employees user selects. :-)
        //  ID 1 = Training Application Header
        //  ID 2 = HR Company Activities


        case Source_ID of
            //Training Application Header
            1:
                begin
                    HRTrainLines.Reset;
                    HRTrainLines.SetRange(HRTrainLines."Application No.", SourceDoc_No);
                    if HRTrainLines.Find('-') then begin
                        if Confirm('Clear ALL Lines?') = true then HRTrainLines.DeleteAll else exit;
                        Report.Run(Report::"HR Suggest Participants", false, false, HRTrainLines);
                    end else begin
                        Report.Run(Report::"HR Suggest Participants", true, false, HRTrainLines);
                    end;
                end;
            //Company Activities
            2:
                begin
                end;
        end;
    end;

    procedure fn_HRChangeLog(FieldName: Text; StaffNo: Code[20]; OldValue: Text; NewValue: Text; PayrollPeirod: Date)
    var
    // [RunOnClient]
    // Window: dotnet Interaction;
    // ReasonForChange: Text;
    // Reason1: Text;
    // Reason2: Text;
    // Text3693: label 'Please specify reason for changing Basic Pay';
    // PRChangeLog: Record "HR Change Entries";
    begin
        // Reason1:=Window.InputBox('Enter reason for changing [ ' + UpperCase(FieldName) + ' ] ' +
        //                         ' from [ ' + UpperCase(OldValue) + ' ] to [ '+ UpperCase(NewValue) + ' ] ', 'Staff No.'+StaffNo,'',100,100);
        // Reason2:= DelChr(Reason1,'=');

        // if StrLen(Reason2) <= 0 then
        // begin
        //     Error('Please specify valid reason');
        // end;

        // PRChangeLog.Init;

        // PRChangeLog."Line No":=fnLastLineNo + 10;
        // PRChangeLog."Change Date":=Today;
        // PRChangeLog."Time Modified":=Time;
        // PRChangeLog.UserID:=UserId;
        // PRChangeLog."employee No":=StaffNo;
        // PRChangeLog."Old Value":=OldValue;
        // PRChangeLog."New Value":=NewValue;
        // PRChangeLog."Change Description":=Reason2;
        // PRChangeLog."Field Changed":=FieldName;

        // PRChangeLog.Insert;
    end;

    procedure fn_HRPRAccessList(currUserID: Code[100])
    begin

    end;

    procedure CalculateEarnedDays(EmpNo: code[20]): Decimal
    var
        NoofMonthsWorked: Decimal;
        HRCalendar: Record "HR Leave Calendar";
        EarnedDays: Decimal;
    begin

        HRCalendar.Reset();
        HRCalendar.SetRange(Current, true);
        HRCalendar.FindFirst();
        if HREmp.Get(EmpNo) then begin
            if HREmp."Date Of Joining the Company" <> 0D then begin
                if HREmp."Date Of Joining the Company" > HRCalendar."Start Date" then begin
                    //NoofMonthsWorked := today - HREmp."Date Of Joining the Company";
                    NoofMonthsWorked := ABS(DATE2DMY(Today, 2) - DATE2DMY(HREmp."Date Of Joining the Company", 2));
                    IF DATE2DMY(Today, 3) = DATE2DMY(HREmp."Date Of Joining the Company", 3) THEN BEGIN
                        NoofMonthsWorked := DATE2DMY(Today, 2) - DATE2DMY(HREmp."Date Of Joining the Company", 2);
                    END;

                    IF DATE2DMY(Today, 3) <> DATE2DMY(HREmp."Date Of Joining the Company", 3) THEN BEGIN
                        NoofMonthsWorked := (DATE2DMY(Today, 2) + 12) - DATE2DMY(HREmp."Date Of Joining the Company", 2);
                    END;

                    NoofMonthsWorked := 30 / 12 * NoofMonthsWorked;
                end else begin
                    //NoofMonthsWorked := today - HRCalendar."Start Date";
                    NoofMonthsWorked := ABS(DATE2DMY(Today, 2) - DATE2DMY(HRCalendar."Start Date", 2));
                    IF DATE2DMY(Today, 3) = DATE2DMY(HRCalendar."Start Date", 3) THEN BEGIN
                        NoofMonthsWorked := DATE2DMY(Today, 2) - DATE2DMY(HRCalendar."Start Date", 2);
                    END;

                    IF DATE2DMY(Today, 3) <> DATE2DMY(HRCalendar."Start Date", 3) THEN BEGIN
                        NoofMonthsWorked := (DATE2DMY(Today, 2) + 12) - DATE2DMY(HRCalendar."Start Date", 2);
                    END;

                    NoofMonthsWorked := 30 / 12 * NoofMonthsWorked;
                end;
            end else
                Error('Date of Join is not set for Employee ' + HREmp."First Name" + ' ' + HREmp."Middle Name" + ' ' + HREmp."Last Name");
        end;


        /* IF DATE2DMY(today, 3) = DATE2DMY(HRCalendar."Start Date", 3) THEN BEGIN
            NoofMonthsWorked := DATE2DMY(today, 2) - DATE2DMY(HRCalendar."Start Date", 2);
        END;

        IF DATE2DMY(today, 3) <> DATE2DMY(HRCalendar."Start Date", 3) THEN BEGIN
            NoofMonthsWorked := (DATE2DMY(today, 2) + 12) - DATE2DMY(HRCalendar."Start Date", 2);
        END; */
        //if NoofMonthsWorked > 0 then NoofMonthsWorked := (30 * NoofMonthsWorked) / 365;

        EarnedDays := NoofMonthsWorked;
        exit(EarnedDays);
    end;

    procedure CalculateBrFDays(EmpNo: code[20]): Decimal
    var
        HRCalendar: Record "HR Leave Calendar";
        FwrDays: Decimal;
        LeaveAllocation: Record "HR-Employee";
    begin

        HRCalendar.Reset();
        HRCalendar.SetRange(Current, true);
        HRCalendar.FindFirst();

        LeaveAllocation.reset;
        LeaveAllocation.setrange("No.", EmpNo);
        LeaveAllocation.setfilter(LeaveAllocation."Date Filter", '%1..%2', HRCalendar."Start Date", HRCalendar."End Date");
        if LeaveAllocation.find('-') then begin
            LeaveAllocation.CalcFields("Carry forward");
            FwrDays := LeaveAllocation."Carry forward";

        end;
        exit(FwrDays);
    end;

    procedure CalculateTakenLeaveDays(EmpNo: code[20]): Decimal
    var
        HRCalendar: Record "HR Leave Calendar";
        LDays: Decimal;
        LeaveAllocation: Record "HR-Employee";
    begin

        HRCalendar.Reset();
        HRCalendar.SetRange(Current, true);
        HRCalendar.FindFirst();

        LeaveAllocation.reset;
        LeaveAllocation.setrange("No.", EmpNo);
        LeaveAllocation.setfilter(LeaveAllocation."Date Filter", '%1..%2', HRCalendar."Start Date", HRCalendar."End Date");
        if LeaveAllocation.find('-') then begin
            LeaveAllocation.CalcFields("Total Leave Taken");
            LDays := LeaveAllocation."Total Leave Taken";
        end;
        exit(LDays);
    end;
}

