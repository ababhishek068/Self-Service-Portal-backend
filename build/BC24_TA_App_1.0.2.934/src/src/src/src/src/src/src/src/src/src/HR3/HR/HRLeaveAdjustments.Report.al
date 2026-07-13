Report 50177 "HR Leave Adjustments"
{
    ProcessingOnly = true;
    ApplicationArea = All;

    dataset
    {
        dataitem("HR Employees"; "HR-Employee")
        {
            DataItemTableView = where(Status = const(Active));
            RequestFilterFields = "No.";
            column(ReportForNavId_1000000000; 1000000000) { }
            trigger OnAfterGetRecord()
            var
                NoofMonthsToWork: Integer;
            begin
                HRLeaveCalendar.Reset;
                HRLeaveCalendar.SetRange(Current, true);
                if HRLeaveCalendar.FindFirst() then begin
                    //More than once calendar exists
                    if HRLeaveCalendar.Count > 1 then Error('No active calendar exists', HRLeaveCalendar.Count);

                    LineNo := LineNo + 1;

                    HRLeaveAllocation."Entry No." := LineNo;
                    HRLeaveAllocation."Calendar Code" := HRLeaveCalendar.Code;

                    HRLeaveAllocation."No." := "HR Employees"."No.";
                    HRLeaveAllocation."Staff Name" := "HR Employees"."First Name" + ' ' + "HR Employees"."Middle Name" + ' ' + "HR Employees"."Last Name";

                    HRLeaveAllocation."Posting Date" := Today;

                    HRLeaveAllocation."Entry Type" := EntryType;
                    HRLeaveAllocation."Posting Type" := PostingType;

                    if LeaveType = 'ANNUAL' then begin
                        if PostingType = PostingType::"Carry Forward" then begin
                            Error('You cannot perform this function!');
                        end else begin
                            if "HR Employees"."Date Of Joining the Company" <> 0D then begin
                                if "HR Employees"."Date Of Joining the Company" > HRLeaveCalendar."Start Date" then begin
                                    if HRLeaveAllocation."Entry Type" = EntryType::"Negative Adjustment" then
                                        HRLeaveAllocation."No. Of days" := (HRLeaveType.Days * -1)
                                    else begin
                                        NoofMonthsToWork := ABS(DATE2DMY("HR Employees"."Date Of Joining the Company" - DATE2DMY(Today, 2), 2));
                                        IF DATE2DMY(Today, 3) = DATE2DMY("HR Employees"."Date Of Joining the Company", 3) THEN BEGIN
                                            NoofMonthsToWork := ABS(DATE2DMY("HR Employees"."Date Of Joining the Company", 2) - DATE2DMY(Today, 2));
                                        END;
                                        IF DATE2DMY(Today, 3) <> DATE2DMY("HR Employees"."Date Of Joining the Company", 3) THEN BEGIN
                                            NoofMonthsToWork := ABS(DATE2DMY("HR Employees"."Date Of Joining the Company", 2) - (DATE2DMY(Today, 2) + 12));
                                        END;
                                        HRLeaveAllocation."No. Of days" := (NoofMonthsToWork / 12) * HRLeaveType.Days;
                                    end;
                                end else begin
                                    if HRLeaveAllocation."Entry Type" = EntryType::"Negative Adjustment" then
                                        HRLeaveAllocation."No. Of days" := (HRLeaveType.Days * -1)
                                    else
                                        HRLeaveAllocation."No. Of days" := HRLeaveType.Days;
                                end;
                            end else
                                Error('Date of join for employee ' + "HR Employees"."First Name" + ' ' + "HR Employees"."Middle Name" + ' ' + "HR Employees"."Last Name" + ' not set');
                        end;
                    end else begin
                        if HRLeaveAllocation."Entry Type" = EntryType::"Negative Adjustment" then
                            HRLeaveAllocation."No. Of days" := (HRLeaveType.Days * -1)
                        else
                            HRLeaveAllocation."No. Of days" := HRLeaveType.Days;
                    end;

                    HRLeaveAllocation."Leave Type" := LeaveType;

                    HRLeaveAllocation."Posting Description" := Format(EntryType) + ' Allocation - ' + Format(Today);
                    HRLeaveAllocation."Posted By" := UserId;

                    HRLeaveAllocation.Posted := false;
                    HRLeaveAllocation."Calendar Start Date" := HRLeaveCalendar."Start Date";
                    HRLeaveAllocation."Calendar End Date" := HRLeaveCalendar."End Date";
                    HRLeaveAllocation."Document No." := 'BATCH-' + HRLeaveCalendar.Code;
                    HRLeaveAllocation."Posting Source" := HRLeaveAllocation."posting source"::Batch;
                    HRLeaveAllocation.Closed := false;
                    HRLeaveAllocation.Insert;
                    //  Postentries.PostLeaveAllocation(HRLeaveAllocation."Entry No.", HRLeaveAllocation."No.", HRLeaveAllocation."Leave Type", HRLeaveAllocation."Calendar Code");

                end else
                    Error('No HR calender found');
            end;

            trigger OnPreDataItem()
            begin
                //Factor in Gender
                case HRLeaveType.Gender of
                    //Male
                    HRLeaveType.Gender::Female:
                        begin
                            "HR Employees".SetRange("HR Employees".Gender, HRLeaveType.Gender);
                        end;
                    //Female
                    HRLeaveType.Gender::Male:
                        begin
                            "HR Employees".SetRange("HR Employees".Gender, HRLeaveType.Gender);
                        end;
                end;
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
                field(LeaveType; LeaveType)
                {
                    ApplicationArea = Basic;
                    Caption = 'Leave Type';
                    TableRelation = "Leave Types".Code;
                    ToolTip = 'Specifies the value of the Leave Type field.';
                }
                field(EntryType; EntryType)
                {
                    ApplicationArea = Basic;
                    Caption = 'Entry Type';
                    ToolTip = 'Specifies the value of the Entry Type field.';
                }
                field(PostingType; PostingType)
                {
                    ApplicationArea = Basic;
                    Caption = 'Posting Type';
                    ToolTip = 'Specifies the value of the Posting Type field.';
                }
            }
        }
        actions { }
    }

    labels { }

    trigger OnPreReport()
    var
        ERR_LEAVE_TYPE: label 'Please specify Leave Type';
        ERR_ENTRY_TYPE: label 'Please specify Entry Type as either "Positive Adjustment or Negative Adjustment"';
        ERR_CALENDAR_DUPLICATE: label 'There are currently [ %1 - Active ] Calendars, Please setup only 1 Active Calendar';
        CNF_0001: label 'There are currently [ %1  ] Entries Awaiting Posting. \\Do you wish to Delete and Generate a New Batch?';
    begin
        //Testfields
        if EntryType = Entrytype::" " then Error(ERR_ENTRY_TYPE);
        if LeaveType = '' then Error(ERR_LEAVE_TYPE);

        //Calendar Exists
        HRLeaveCalendar.Reset;
        HRLeaveCalendar.SetRange(Current, true);
        HRLeaveCalendar.FindFirst;

        if HRLeaveCalendar.Count > 1 then Error(ERR_CALENDAR_DUPLICATE, HRLeaveCalendar.Count);

        //Line No.
        LineNo := 0;

        HRLeaveAllocation.Reset;
        if HRLeaveAllocation.FindLast then LineNo := HRLeaveAllocation."Entry No.";

        //Leave Type
        HRLeaveType.Reset;
        HRLeaveType.Get(LeaveType);

        if not HRLeaveType."Unlimited Days" then HRLeaveType.TestField(Days);

        //Clear Page with existing entries if not posted
        HRLeaveAllocation.Reset;
        HRLeaveAllocation.SetRange(Posted, false);
        if not HRLeaveAllocation.IsEmpty then begin
            if Confirm(CNF_0001, false, HRLeaveAllocation.Count) = false then Error('Process Aborted');
        end;
    end;

    var
        LineNo: Integer;
        HRLeaveCalendar: Record "HR Leave Calendar";
        HRLeaveAllocation: Record "HR Leave Allocation";
        HRLeaveType: Record "Leave Types";
        LeaveType: Code[50];
        EntryType: Option " ","Positive Adjustment","Negative Adjustment";
        PostingType: Option Normal,Reimbursement,"Carry Forward";
}

