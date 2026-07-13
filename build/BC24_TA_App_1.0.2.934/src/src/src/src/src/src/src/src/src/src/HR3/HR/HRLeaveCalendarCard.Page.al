Page 50720 "HR Leave Calendar Card"
{
    DeleteAllowed = false;
    InsertAllowed = true;
    ModifyAllowed = true;
    PageType = Document;
    PromotedActionCategories = 'New,Process,Reports,Functions';
    SourceTable = "HR Leave Calendar";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(StartDate; Rec."Start Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Start Date field.';
                }
                field(EndDate; Rec."End Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the End Date field.';
                }
                field(Current; Rec.Current)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Current field.';
                }
            }
            part(Control1102755000; "HR Leave Calendar Lines")
            {
                ApplicationArea = all;
                SubPageLink = Code = field(Code);
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Functions)
            {
                Caption = 'Functions';
                action(CreateCalendar)
                {
                    ApplicationArea = Basic;
                    Caption = 'Create Calendar';
                    Image = CreateYear;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'Executes the Create Calendar action.';

                    trigger OnAction()
                    var
                        TEXT0025: label 'Saturday';
                        TEXT0026: label 'Sunday';
                        ERR_NON_WORKING_NOT_DEFINED: label 'Please Setup Non-Working Days / Dates for the Current Period [ %1 - %2 ]';
                        HRLeaveCalendar: Record "HR Leave Calendar";
                        LvTypes: Record "Leave Types";
                    begin
                        Rec.TestField(Code);
                        Rec.TestField("Start Date");
                        Rec.TestField("End Date");

                        HRLeaveNonWorkingDays.Reset;
                        HRLeaveNonWorkingDays.SetRange(Date, Rec."Start Date", Rec."End Date");
                        if HRLeaveNonWorkingDays.IsEmpty then Error(ERR_NON_WORKING_NOT_DEFINED, Rec."Start Date", Rec."End Date");

                        if Confirm('Are you sure you want to create a new calender?\ NB/: This will close the open calendar(s)', false) = true then begin
                            //CloseLeaveEntries();
                            LvTypes.Reset();
                            LvTypes.SetRange(Code, 'ANNUAL');
                            LvTypes.SetRange(Balance, LvTypes.Balance::"Carry Forward");
                            if LvTypes.Find('-') then begin
                                HREmployeeLeveCarryForward(Rec.Code, Rec."Start Date", Rec."End Date");
                            end;
                            CloseOpencalenders();

                            HRLeaveCalendar.Reset();
                            HRLeaveCalendar.SetFilter(Code, '<>%1', Rec.Code);
                            HRLeaveCalendar.SetFilter("End Date", '>%1', Rec."Start Date");
                            if HRLeaveCalendar.FindSet(true, false) then Error('This calender start date will conflict with the end date of calendar ' + HRLeaveCalendar.Code + '. Make sure your calender dates are correct');

                            if Confirm('Generate Calendar [ %1 ]', false, Rec.Code) = true then begin
                                Date.Reset;
                                Date.SetRange(Date."Period Type", Date."period type"::Date);
                                Date.SetRange(Date."Period Start", Rec."Start Date", Rec."End Date");
                                if Date.FindFirst() then begin
                                    HRCalendarList.Reset;
                                    HRCalendarList.SetRange(Code, Rec.Code);
                                    HRCalendarList.DeleteAll;

                                    repeat
                                        HRCalendarList.Init;

                                        HRCalendarList.Code := Rec.Code;
                                        HRCalendarList.Date := Date."Period Start";
                                        // e.g 01-01-15
                                        HRCalendarList.Day := Date."Period Name";         // e.g Thursday
                                        HRCalendarList."Non Working" := fn_DetermineNonWorking(Date."Period Start");

                                        //Saturday
                                        if (Date."Period Name" = TEXT0025) and not (HRCalendarList."Non Working") then begin
                                            HRCalendarList."Non Working" := true;
                                            HRCalendarList.Reason := TEXT0025;
                                        end;
                                        //Sunday
                                        if (Date."Period Name" = TEXT0026) and not (HRCalendarList."Non Working") then begin
                                            HRCalendarList."Non Working" := true;
                                            HRCalendarList.Reason := TEXT0026;
                                        end;

                                        HRCalendarList.Insert;
                                    until Date.Next = 0;
                                    Rec.Current := true;
                                    Rec.Modify();
                                    Message('Process complete');
                                end else begin
                                    Error('Invalid Date format');
                                end;
                            end else begin
                                //Creation aborted
                                exit;
                            end;
                        end;
                    end;
                }
                action("Non Working Days")
                {
                    ApplicationArea = Basic;
                    Image = CalendarMachine;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page "HR Leave Non Working Days";
                    ToolTip = 'Executes the Non Working Days action.';
                }
            }
        }
    }

    var
        Date: Record Date;
        HRCalendarList: Record "HR Leave Calendar Lines";
        HRLeaveNonWorkingDays: Record "HR Leave Non Working Days";

    local procedure fn_DetermineNonWorking(currDate: Date) isNonWorking: Boolean
    var
        HRNonWorkingDays: Record "HR Leave Non Working Days";
    begin
        isNonWorking := false;
        HRCalendarList.Reason := '';

        HRNonWorkingDays.Reset;
        if HRNonWorkingDays.Get(currDate) then begin
            isNonWorking := true;
            HRCalendarList.Reason := HRNonWorkingDays.Reason;
        end;
    end;

    local procedure CloseLeaveEntries(EmpNo: Code[20]; CalenderCode: Code[20])
    var
        EmpLeaveAlloc: Record "HR Leave Allocation";
    begin
        EmpLeaveAlloc.Reset();
        EmpLeaveAlloc.SetRange(Closed, false);
        EmpLeaveAlloc.SetFilter("Calendar Code", '<>%1', CalenderCode);
        EmpLeaveAlloc.SetRange("No.", EmpNo);
        EmpLeaveAlloc.SetRange(Posted, true);
        if EmpLeaveAlloc.FindSet(true, false) then begin
            repeat
                EmpLeaveAlloc.Closed := true;
                EmpLeaveAlloc.Modify();
            until EmpLeaveAlloc.Next() = 0;
        end;
    end;

    local procedure HREmployeeLeveCarryForward(CalenderCode: Code[20]; startDate: Date; endDate: Date)
    var
        HRLeaveCalendar: Record "HR Leave Calendar";
        EmpLeaveAlloc: Record "HR Leave Allocation";
        HREmp: Record "HR-Employee";
        LineNo: Integer;
        LeaveBal: Decimal;
    begin
        LineNo := 0;
        HREmp.Reset();
        HREmp.SetRange(Status, HREmp.Status::Active);
        if HREmp.Find('-') then begin
            repeat
                HRLeaveCalendar.Reset();
                HRLeaveCalendar.SetRange(Current, true);
                if HRLeaveCalendar.FindSet(true, false) then begin
                    LeaveBal := 0;
                    EmpLeaveAlloc.Reset();
                    EmpLeaveAlloc.SetRange("No.", HREmp."No.");
                    EmpLeaveAlloc.SetRange(Closed, false);
                    EmpLeaveAlloc.SetRange("Leave Type", 'ANNUAL');
                    EmpLeaveAlloc.SetRange("Calendar Code", HRLeaveCalendar.Code);
                    if EmpLeaveAlloc.FindSet(true, false) then begin
                        LineNo := LineNo + 1;
                        EmpLeaveAlloc."Entry No." := LineNo;
                        EmpLeaveAlloc."Calendar Code" := CalenderCode;
                        EmpLeaveAlloc."No." := HREmp."No.";
                        EmpLeaveAlloc."Staff Name" := HREmp."First Name" + ' ' + HREmp."Middle Name" + ' ' + HREmp."Last Name";
                        EmpLeaveAlloc."Posting Date" := Today;
                        EmpLeaveAlloc."Entry Type" := EmpLeaveAlloc."Entry Type"::"Positive Adjustment";
                        EmpLeaveAlloc."Posting Type" := EmpLeaveAlloc."Posting Type"::"Carry Forward";

                        EmpLeaveAlloc.CalcSums("No. Of days");
                        LeaveBal := LeaveBal + EmpLeaveAlloc."No. Of days";
                        if LeaveBal > 15 then
                            EmpLeaveAlloc."No. Of days" := 15
                        else
                            EmpLeaveAlloc."No. Of days" := LeaveBal;

                        EmpLeaveAlloc."Leave Type" := 'ANNUAL';

                        EmpLeaveAlloc."Posting Description" := 'Leave Carry forward Allocation - ' + Format(Today);
                        EmpLeaveAlloc."Posted By" := UserId;

                        EmpLeaveAlloc.Posted := false;
                        EmpLeaveAlloc."Calendar Start Date" := startDate;
                        EmpLeaveAlloc."Calendar End Date" := endDate;
                        EmpLeaveAlloc."Document No." := 'BATCH-' + CalenderCode;
                        EmpLeaveAlloc."Posting Source" := EmpLeaveAlloc."posting source"::Batch;
                        EmpLeaveAlloc.Posted := true;
                        EmpLeaveAlloc.Insert(true);

                        CloseLeaveEntries(HREmp."No.", CalenderCode);
                    end;
                end;
            Until HREmp.Next() = 0;
        end;
    end;

    local procedure CloseOpencalenders()
    var
        HRLeaveCalendar: Record "HR Leave Calendar";
    begin
        HRLeaveCalendar.Reset();
        HRLeaveCalendar.SetRange(Current, true);
        if HRLeaveCalendar.FindSet(true, false) then begin
            HRLeaveCalendar.ModifyAll(Current, false);
        end;
    end;
}

