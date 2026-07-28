Table 50532 "HR Leave Application"
{
    DrillDownPageID = "HR Leave Applications List";
    LookupPageID = "HR Leave Applications List";

    fields
    {
        field(1; "Application Code"; Code[50])
        {
        }
        field(3; "Leave Type"; Code[30])
        {
            //TableRelation = "HR Leave Types".Code;
            TableRelation = "Leave Types".Code;


            trigger OnValidate()
            var
                leavtype: Record "Leave Types";
            begin
                if "User ID"<>'' then begin

                HREmp.Reset;
        HREmp.SetRange("User ID", UserId);
        if HREmp.FindFirst() then begin
            if HREmp.Count > 1 then Error('User ID [ %1 ] is linked to [ %2 ] Staff Nos.', UserId, HREmp.Count);
            if HREmp.Status = HREmp.Status::InActive then Error('Inactive employee cannot apply');
            HREmp.TestField("Responsibility Center");
            HREmp.TestField(Gender);
            Gender := HREmp.Gender;
            if "Leave Type"<>'' then begin
                HRLeaveTypes.Reset();
                HRLeaveTypes.SetRange(HRLeaveTypes.Code,"Leave Type");
                if HRLeaveTypes.FindFirst() then begin                   
                    if HRLeaveTypes.Gender<>HREmp.Gender then begin
                        if HRLeaveTypes.Gender<>HRLeaveTypes.Gender::Both then begin
                            Error('The leave can only be applied by'+Format(HRLeaveTypes.Gender));
                        end;
                    end;
                end;
            end;
        end;
                end;

                "maternity?" := false;
                Mourning := false;
                Annual := false;
                unlimited := false;
                "No of Limited days" := 0;
                leavtype.Reset();
                leavtype.SetRange(leavtype.Code, "Leave Type");
                if leavtype.FindFirst() then begin
                    rec."leave Name":=leavtype.Description;
                    if leavtype."Maternity?" = true then begin
                        "maternity?" := true;
                    end;
                    if leavtype."Unlimited Days" = true then begin
                        rec.unlimited := true;
                        leavtype.TestField("Maximum Application Days");
                        //Message(Format(leavtype."Maximum Application Days"));
                        rec."No of Limited days" := leavtype."Maximum Application Days";
                        //rec.Modify();
                    end;
                    if leavtype."Mourning leave?" = true then begin
                        Mourning := true;
                        //modify;
                    end else if leavtype.Annual = true then begin
                        Annual := true;
                    end
                end;


                //Validate("Days Applied");
            end;
        }
        field(4; "Days Applied"; Decimal)
        {
            DecimalPlaces = 0 : 1;
            MinValue = 0.5;

            trigger OnValidate()
            var
                mourningleave: record "Mourning Leave Setup";
                CardAnnualBalance: Decimal;
            begin
                TestField("Leave Type");
                if rec."Select Whether Half Day" <> rec."Select Whether Half Day"::Normal then begin
                    Error('Days applied can only be used for Normal leaves');

                end;
                //Initialize
                //CLEAR("Days Applied");
                // Clear("Reimbursed Days");
                // Clear("Allocated Days");
                // Clear("Current Leave Balance");
                // Clear("Current Total Leave Taken");
                if Annual = false then begin
                    if "Days Applied" < 1 then begin
                        "Days Applied" := round("Days Applied", 1, '<');
                    end
                end;
                if Mourning = true then begin
                    //TestField("Family Member");
                    // if "Family Member"="Family Member"::" " then
                    // Error('Kindly select correct family member');
                    //if "Family Member"<> "Family Member"::" " then
                    mourningleave.Reset();
                    mourningleave.SetRange(mourningleave."Family Member", rec."Family Member");
                    if mourningleave.FindFirst() then begin
                        mourningleave.TestField("No of Days");
                        if "Days Applied" > mourningleave."No of Days" then
                            Error('Mourning leave days must not be greater than ' + Format(mourningleave."No of Days"));
                    end;
                end;
                yearend := 365;
                Clear("Reimbursed Days");
                Clear("Allocated Days");
                Clear("Current Leave Balance");
                Clear("Current Total Leave Taken");
                //Check Calendar
                HRLeaveCal.Reset;
                HRLeaveCal.SetRange(Current, true);
                if HRLeaveCal.FindFirst() then begin
                    HRLeaveCal.TestField("Start Date");
                    //More than once calendar exists
                    if HRLeaveCal.Count > 1 then Error(ERR_ACTIVE_LEAVE_CALENDAR, HRLeaveCal.Count);

                    //Total Leave Taken
                    HRLeaveAlloc.Reset;
                    HRLeaveAlloc.SetRange("No.", "Employee No.");
                    HRLeaveAlloc.SetRange("Calendar Code", HRLeaveCal.Code);
                    HRLeaveAlloc.SetRange("Entry Type", HRLeaveAlloc."entry type"::"Negative Adjustment");
                    HRLeaveAlloc.SetRange("Leave Type", "Leave Type");
                    HRLeaveAlloc.SetRange("Posting Type", HRLeaveAlloc."posting type"::Normal);
                    if HRLeaveAlloc.FindSet then begin
                        HRLeaveAlloc.CalcSums("No. Of days");
                        "Current Total Leave Taken" := (HRLeaveAlloc."No. Of days") * -1;
                        Modify;
                    end;

                    //Reimburesed Days
                    HRLeaveAlloc.Reset;
                    HRLeaveAlloc.SetRange("No.", "Employee No.");
                    HRLeaveAlloc.SetRange("Calendar Code", HRLeaveCal.Code);
                    HRLeaveAlloc.SetRange("Leave Type", "Leave Type");
                    HRLeaveAlloc.SetRange("Entry Type", HRLeaveAlloc."entry type"::"Positive Adjustment");
                    HRLeaveAlloc.SetRange("Posting Type", HRLeaveAlloc."posting type"::Reimbursement);
                    if HRLeaveAlloc.FindSet then begin
                        HRLeaveAlloc.CalcSums("No. Of days");
                        "Reimbursed Days" := HRLeaveAlloc."No. Of days";
                        Modify;
                    end;

                    //Allocated Days
                    HRLeaveAlloc.Reset;
                    HRLeaveAlloc.SetRange("No.", "Employee No.");
                    HRLeaveAlloc.SetRange("Calendar Code", HRLeaveCal.Code);
                    HRLeaveAlloc.SetRange("Entry Type", HRLeaveAlloc."entry type"::"Positive Adjustment");
                    HRLeaveAlloc.SetRange("Leave Type", "Leave Type");
                    HRLeaveAlloc.SetRange("Posting Type", HRLeaveAlloc."posting type"::Normal);
                    if HRLeaveAlloc.FindSet then begin
                        HRLeaveAlloc.CalcSums("No. Of days");
                        "Allocated Days" := HRLeaveAlloc."No. Of days";
                        "Current Leave Balance" := ("Allocated Days" + "Reimbursed Days") - "Current Total Leave Taken";
                        Modify;
                    end;

                    // Annual leave: employee-card net balance overrides ledger components
                    // before the days-applied ceiling check (ledger split can read 0 incorrectly).
                    if Annual then begin
                        TestField("Employee No.");
                        HREmp.Reset();
                        HREmp.SetRange(HREmp."No.", rec."Employee No.");
                        if HREmp.FindFirst() then begin
                            HREmp.CalcFields("Annual Leave balance");
                            CardAnnualBalance := HREmp."Annual Leave balance";
                            "Current Leave Balance" := CardAnnualBalance;
                            "Earned Leave Days" := CardAnnualBalance;
                            Modify;
                        end;
                    end;

                    if unlimited = false then begin

                        if "Current Leave Balance" < "Days Applied" then begin
                            Error('Your current leave balance is less than days applied');
                        end;
                    end else if rec.unlimited = true then begin
                        if "Days Applied" > rec."No of Limited days" then
                            Error('You cannot apply more than ' + Format(rec."No of Limited days") + ' days.');

                    end;
                    "Application Date" := today;

                    if Annual = true then begin
                        TestField("Employee No.");
                        HREmp.Reset();
                        HREmp.SetRange(HREmp."No.", rec."Employee No.");
                        if HREmp.FindFirst() then begin
                            HREmp.TestField("Date Of Joining the Company");
                            if HREmp.Status = HREmp.Status::Active then begin
                                if HREmp."Date Of Joining the Company" > HRLeaveCal."Start Date" then begin
                                    noofdaysworked := "Application Date" - HREmp."Date Of Joining the Company";
                                end else
                                    if HREmp."Date Of Joining the Company" < HRLeaveCal."Start Date" then
                                        noofdaysworked := ("Application Date" - HRLeaveCal."Start Date");
                            end else
                                if HREmp.Status = HREmp.Status::InActive then
                                    noofdaysworked := HREmp."Date Of Leaving the Company" - HRLeaveCal."End Date";
                        end;

                        noofdaysworked := noofdaysworked + 1;

                        if noofdaysworked > 366 then
                            Error('The HR calendar has more than 365 days');

                        if CardAnnualBalance = 0 then begin
                            HREmp.CalcFields("Annual Leave balance");
                            CardAnnualBalance := HREmp."Annual Leave balance";
                            "Current Leave Balance" := CardAnnualBalance;
                            "Earned Leave Days" := CardAnnualBalance;
                        end;

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
                            Error('You must not apply more days than earned days ' + Format("Earned Leave Days"));

                    end;
                end else begin
                    Error('No Leave Calendar Exists');
                end;

                if "Days Applied" <> 0 then begin
                    if rec."Start Date" <> 0D then
                        rec.Validate("Start Date");
                end;




            end;

        }
        field(5; "Start Date"; Date)
        {

            trigger OnValidate()
            begin
                // "Return Date" := 0D;
                // "End Date" := 0D;
                TestField("Leave Type");
                if "maternity?" = true then begin
                    TestField("Delivery Date");
                end;
                //Message('Adding leave return date');


                if "Start Date" <> 0D then begin
                    if DetermineIfIsNonWorking(rec."Start Date") = true then begin
                        Error('The Start date must be a working day');
                    end;
                    //Validate("Days Applied");

                    //Message('Adding leave return date 1');
                    //Calculate Return and End Dates
                    if (rec."Days Applied" <> 0) and (rec."Start Date" <> 0D) then begin
                        //Message('Adding leave return date 2');

                        rec."Return Date" := DetermineLeaveReturnDate(rec."Start Date", rec."Days Applied");
                        rec."End Date" := DeterminethisLeaveEndDate(rec."Return Date");
                        Modify;
                    end;


                    ;
                end;
                HRCalendar.Reset();
                HRCalendar.SetRange(Current, true);
                if HRCalendar.FindFirst() then
                    HRCalendar.TestField("Start Date");

                "Application Date" := Today;
                ///  "User ID" := UserId;

                NoofMonthsWorked := ABS(DATE2DMY("Application Date", 2) - DATE2DMY(HRCalendar."Start Date", 2));

                IF DATE2DMY("Application Date", 3) = DATE2DMY(HRCalendar."Start Date", 3) THEN BEGIN
                    NoofMonthsWorked := DATE2DMY("Application Date", 2) - DATE2DMY(HRCalendar."Start Date", 2);
                END;

                IF DATE2DMY("Application Date", 3) <> DATE2DMY(HRCalendar."Start Date", 3) THEN BEGIN
                    NoofMonthsWorked := (DATE2DMY("Application Date", 2) + 12) - DATE2DMY(HRCalendar."Start Date", 2);
                END;
                noofdaysworked := ("Application Date" - HRCalendar."Start Date") + 1;

                //TestField("Start Date");
                //Message(Format(noofdaysworked));
                //TestField("Allocated Days");
                // "Days Applied"

                //TestField("Current Leave Balance");

                //Error('Worked for %1 months', NoofMonthsWorked);

                //Validate("Days Applied");
            end;
        }
        field(6; "Return Date"; Date)
        {
            Caption = 'Return Date';
            Editable = true;
        }
        field(7; "Application Date"; Date) { }
        field(8; Status; Option)
        {
            Editable = false;
            OptionMembers = Open,"Pending Approval",Approved,Rejected,Canceled,Posted;
            trigger OnValidate()
            var
                CurrCalender: Record "HR Leave Calendar.";
                HRWebportal: Codeunit HRWebportal;
                msg: Text;
            begin
                if Status = Status::Approved then begin
                    //Allow if emails configured

                    if HREmp.Get("Employee No.") then begin
                        msg := 'Dear Sir/Madam,<br /><br />';
                        msg := msg + 'Your leave application has been approved.<br /><br />';
                        msg := msg + 'Details:<br /><br />';
                        msg := msg + 'Type of Leave: ' + "Leave Type" + '<br /><br />';
                        msg := msg + 'Start Date: ' + Format("Start Date") + '<br /><br />';
                        msg := msg + 'End Date: ' + Format("End Date") + '<br /><br />';
                        msg := msg + 'Return Date: ' + Format("Return Date") + '<br /><br />';
                        msg := msg + 'No of Days: ' + Format("Days Applied") + '<br /><br />';
                        // HRWebportal.SendEmail(HREmp."Company E-Mail", 'Approved Leave: ' + "Application Code" + ' (Leave Number)', msg);
                    end;

                    HREmp.Reset;
                    HREmp.Get("Employee No.");

                    //Post Leave
                    HRLeaveAlloc.Reset;
                    HRLeaveAlloc."Entry No." := fn_LastLineNo;

                    CurrCalender.Reset;
                    CurrCalender.SetRange(Current, true);
                    if CurrCalender.FindFirst() then begin
                        if CurrCalender.Count > 1 then Error('No active calendar exists', CurrCalender.Count);
                        HRLeaveAlloc."Calendar Code" := CurrCalender.Code;

                        HRLeaveAlloc."No." := HREmp."No.";
                        HRLeaveAlloc."Staff Name" := HREmp."Full Name";

                        HRLeaveAlloc."Posting Date" := Today;

                        HRLeaveAlloc."Entry Type" := HRLeaveAlloc."entry type"::"Negative Adjustment";
                        HRLeaveAlloc."Posting Type" := HRLeaveAlloc."posting type"::Normal;
                        if rec."Select Whether Half Day" = rec."Select Whether Half Day"::Normal then begin
                            HRLeaveAlloc."No. Of days" := ("Days Applied") * -1;
                        end else begin
                            HRLeaveAlloc."No. Of days" := 0.5 * -1;

                        end;


                        HRLeaveAlloc."Leave Type" := "Leave Type";

                        HRLeaveAlloc."Posting Description" := Format(HRLeaveAlloc."Entry Type") + ' Allocation - ' + Format(Today);
                        HRLeaveAlloc."Posted By" := UserId;

                        HRLeaveAlloc.Posted := true;

                        HRLeaveAlloc."Calendar Start Date" := CurrCalender."Start Date";
                        HRLeaveAlloc."Calendar End Date" := CurrCalender."End Date";
                        HRLeaveAlloc."Document No." := "Application Code";
                        HRLeaveAlloc."Posting Source" := HRLeaveAlloc."posting source"::Document;

                        //Application Date
                        HRLeaveAlloc."Application Start Date" := "Start Date";
                        HRLeaveAlloc."Application End Date" := "End Date";
                        HRLeaveAlloc."Application Return Date" := "Return Date";

                        HRLeaveAlloc.Insert;
                        //Now change status of document to posted
                        Status := Status::Posted;
                        Posted := true;
                        "Posted By" := userid;
                        "Date Posted" := today;
                        "Time Posted" := time;
                        Modify;
                    end;
                end;
                //fn_PostLeaveApplication("Application Code");
            end;
        }
        field(9; "No Series"; Code[30]) { }
        field(10; Posted; Boolean) { }
        field(11; "Posted By"; Text[250]) { }
        field(12; "Date Posted"; Date) { }
        field(13; "Time Posted"; Time) { }
        field(14; "Request Leave Allowance"; Boolean) { }
        field(15; "User ID"; Code[50]) { }
        field(16; "Employee No."; Code[50])
        {
            TableRelation = "HR-Employee"."No.";
        }
        field(17; "Supervisor ID"; Code[50])
        {
            TableRelation = "User Setup"."User ID";
        }
        field(18; "Responsibility Center"; Code[50])
        {
            TableRelation = "Responsibility Center BR".Code;
        }
        field(19; Gender; Option)
        {
            OptionMembers = " ",Male,Female;
        }
        field(20; "Allocated Days"; Decimal)
        {
            Editable = false;
        }
        field(21; "Reimbursed Days"; Decimal)
        {
            Editable = false;
            caption = 'Balance Carried Forward';
        }

        field(22; "Current Total Leave Taken"; Decimal)
        {
            Editable = false;
        }
        field(23; "Current Leave Balance"; Decimal)
        {
            Editable = false;
        }
        field(24; "End Date"; Date)
        {
            Editable = false;
        }
        field(25; Supervisor; Code[10]) { }
        field(26; "Supervisor E-Mail"; Text[100]) { }
        field(27; "Empoyee Name"; Text[100])
        {
            Editable = false;
        }

        field(28; "Earned Leave Days"; Decimal)
        {
            DataClassification = ToBeClassified;
        }

        field(29; "HR User ID"; code[20])
        {
            TableRelation = "User Setup"."User ID";
        }

        field(30; "Approver ID"; Code[20])
        {
            TableRelation = "User Setup"."User ID";
        }

        field(31; "Reason for leave"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(32; Reliever; Text[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR-Employee"."No." where(Status = filter(Active));
            trigger OnValidate()
            begin
                if HREmp.get(Reliever) then
                    "Reliever Name" := HREmp."Full Name";
            end;
        }
        field(33; "Reliever Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(34; Reversed; Boolean) { }
        field(35; "Reversed By"; code[20]) { }
        field(36; "Reversed Date"; date) { }
        field(37; Department; Code[50])
        {
            TableRelation = "Dimension value".Code where("Global Dimension No." = filter(2));
            trigger OnValidate()
            var
                DimRec: Record "Dimension Value";
            begin
                dimrec.reset;
                dimrec.setrange(Code, Department);
                if Dimrec.find('-') then
                    "Department Name" := DimRec.Name;

            end;
        }
        field(38; "Department Name"; Text[100]) { }
        field(39; "Ignore Resp. Center"; Boolean) { }
        field(40; "Is HOD"; Boolean) { }
        field(41; "Global Dimension 1 Code"; Code[30])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            Description = 'Stores the reference to the first global dimension in the database';
            NotBlank = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

            trigger OnValidate()
            begin
                DimVal.Reset;
                DimVal.SetRange(DimVal."Global Dimension No.", 1);
                DimVal.SetRange(DimVal.Code, "Global Dimension 1 Code");
                if DimVal.Find('-') then
                    Dim1 := DimVal.Name;
            end;
        }

        field(42; "Shortcut Dimension 2 Code"; Code[30])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            Description = 'Stores the reference of the second global dimension in the database';
            NotBlank = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2),
                                                          Blocked = const(false));

            trigger OnValidate()
            begin
                DimVal.Reset;
                DimVal.SetRange(DimVal."Global Dimension No.", 2);
                DimVal.SetRange(DimVal.Code, "Shortcut Dimension 2 Code");
                if DimVal.Find('-') then
                    Dim2 := DimVal.Name;
            end;
        }

        field(43; "Shortcut Dimension 3 Code"; Code[30])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            Description = 'Stores the reference of the Third global dimension in the database';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));

            trigger OnValidate()
            begin
                DimVal.Reset;
                DimVal.SetRange(DimVal."Global Dimension No.", 3);
                DimVal.SetRange(DimVal.Code, "Shortcut Dimension 3 Code");
                if DimVal.Find('-') then
                    Dim3 := DimVal.Name;
            end;
        }
        field(44; "Shortcut Dimension 4 Code"; Code[30])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            Description = 'Stores the reference of the Third global dimension in the database';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4));

            trigger OnValidate()
            begin
                DimVal.Reset;
                DimVal.SetRange(DimVal.Code, "Shortcut Dimension 4 Code");
                DimVal.SetRange(DimVal."Global Dimension No.", 4);
                if DimVal.Find('-') then
                    Dim4 := DimVal.Name;
            end;
        }
        field(45; Dim1; Text[50]) { }
        field(46; Dim2; Text[50]) { }
        field(47; Dim3; Text[50]) { }
        field(48; Dim4; Text[50]) { }
        field(49; "Approval Status"; Option)
        {
            OptionCaption = 'Open,Appoved';
            OptionMembers = Open,Approved,Posted;
            trigger OnValidate()
            var
                AppEntry: Record "Approval Entry";
            begin
                AppEntry.Reset();
                AppEntry.SetRange(AppEntry."Record ID to Approve", RecordId);
                AppEntry.SetRange(AppEntry."Document No.", '');
                if AppEntry.Find('-') then begin
                    repeat
                        AppEntry."Document No." := "Application Code";
                        AppEntry.Modify();
                    until AppEntry.Next = 0;
                end;
                CalcFields("Final Approver Status");
                CalcFields("Open Approver Count");
                if ("Final Approver Status" = "Final Approver Status"::Approved) and ("Open Approver Count" = 0) then begin
                    Status := Status::Approved;
                    "Approval Status" := "Approval Status"::Approved;
                end;

                if ("Final Approver Status" = "Final Approver Status"::Created) and ("Open Approver Count" = 0) then begin
                    AppEntry.Reset();
                    AppEntry.SetRange(AppEntry."Record ID to Approve", RecordId);
                    // AppEntry.SetRange(AppEntry."Document No.", "Application Code");
                    AppEntry.SetRange(AppEntry.Status, AppEntry.Status::Created);
                    if AppEntry.FindFirst() then begin
                        AppEntry.Status := AppEntry.Status::Open;
                        AppEntry.Modify();
                    end;

                end;

            end;
        }
        field(50; "Final Approver Status"; Enum "Approval Status")
        {
            FieldClass = FlowField;
            CalcFormula = max("Approval Entry".Status where("Document No." = field("Application Code")));

        }
        field(51; "Open Approver Count"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Approval Entry" where("Document No." = field("Application Code"), Status = filter(Open)));
        }
        field(52; "Delivery Date"; Date)
        {

            trigger OnValidate()
            var
                leavetype: record "Leave Types";
                daystoadd: Text[20];
            begin
                TestField("Leave Type");
                //TestField(Gender,Gender::Female);
                leavetype.Reset();
                leavetype.SetRange(leavetype.Code, rec."Leave Type");
                leavetype.SetRange(leavetype."Maternity?", true);
                if leavetype.FindFirst() then begin
                    leavetype.TestField("Days before Delivery");
                    // CALCDATE('<+1M>', TODAY);
                    daystoadd := format(leavetype."Days before Delivery");
                    rec."Start Date" := CalcDate('<' + '-' + daystoadd + 'D' + '>', "Delivery Date");
                    //Validate("Start Date");
                    //message(daystoadd + ' ' + Format(rec."Start Date") + '-' + Format("Start Date"));
                    // Validate("Start Date");
                    rec."Return Date" := DetermineLeaveReturnDate(rec."Start Date", leavetype.Days);
                    rec."End Date" := DeterminethisLeaveEndDate(rec."Return Date");
                end;


            end;
        }
        field(53; "maternity?"; Boolean) { }
        field(54; Mourning; Boolean) { }
        field(55; "Mourning Date"; Date) { }
        field(56; "Family Member"; Option)
        {

            OptionMembers = " ",Aunt,Brother,Child,Father,"Father-in-law","Grand-Parents",Mother,"Mother-in-Law",Sister,"Step-Dad","Step-Mom",Inlaw,Uncle;
            trigger OnValidate()
            var
                mourningleave: Record "Mourning Leave Setup";
            begin
                if "Family Member" <> "Family Member"::" " then
                    mourningleave.Reset();
                mourningleave.SetRange(mourningleave."Family Member", rec."Family Member");
                if mourningleave.FindFirst() then begin
                    mourningleave.TestField("No of Days");
                end;

            end;
        }
        field(57; "History"; Integer)
        {
            CalcFormula = count("HR Leave Application" where("Leave Type" = field("Leave Type"), "Employee No." = field("Employee No."), Posted = filter(true)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(58; "Annual"; Boolean) { }
        field(59; "Select Whether Half Day"; Option)
        {
            OptionMembers = ,"Normal","Half Day Morning","Half Day Evening";
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                applieddayshalfday: Decimal;
                dayofweek: Integer;
            begin
                applieddayshalfday := 1;


                if "Select Whether Half Day" = "Select Whether Half Day"::"Half Day Morning" then begin
                    TestField(Annual, true);
                    if rec."Start Date" = 0D then
                        Error('Please select start date');
                    dayofweek := Date2DWY("Start Date", 1);
                    if dayofweek < 6 then begin
                        yearend := 365;
                Clear("Reimbursed Days");
                Clear("Allocated Days");
                Clear("Current Leave Balance");
                Clear("Current Total Leave Taken");
                //Check Calendar
                HRLeaveCal.Reset;
                HRLeaveCal.SetRange(Current, true);
                if HRLeaveCal.FindFirst() then begin
                    HRLeaveCal.TestField("Start Date");
                    //More than once calendar exists
                    if HRLeaveCal.Count > 1 then Error(ERR_ACTIVE_LEAVE_CALENDAR, HRLeaveCal.Count);

                    //Total Leave Taken
                    HRLeaveAlloc.Reset;
                    HRLeaveAlloc.SetRange("No.", "Employee No.");
                    HRLeaveAlloc.SetRange("Calendar Code", HRLeaveCal.Code);
                    HRLeaveAlloc.SetRange("Entry Type", HRLeaveAlloc."entry type"::"Negative Adjustment");
                    HRLeaveAlloc.SetRange("Leave Type", "Leave Type");
                    HRLeaveAlloc.SetRange("Posting Type", HRLeaveAlloc."posting type"::Normal);
                    if HRLeaveAlloc.FindSet then begin
                        HRLeaveAlloc.CalcSums("No. Of days");
                        "Current Total Leave Taken" := (HRLeaveAlloc."No. Of days") * -1;
                        Modify;
                    end;

                    //Reimburesed Days
                    HRLeaveAlloc.Reset;
                    HRLeaveAlloc.SetRange("No.", "Employee No.");
                    HRLeaveAlloc.SetRange("Calendar Code", HRLeaveCal.Code);
                    HRLeaveAlloc.SetRange("Leave Type", "Leave Type");
                    HRLeaveAlloc.SetRange("Entry Type", HRLeaveAlloc."entry type"::"Positive Adjustment");
                    HRLeaveAlloc.SetRange("Posting Type", HRLeaveAlloc."posting type"::Reimbursement);
                    if HRLeaveAlloc.FindSet then begin
                        HRLeaveAlloc.CalcSums("No. Of days");
                        "Reimbursed Days" := HRLeaveAlloc."No. Of days";
                        Modify;
                    end;

                    //Allocated Days
                    HRLeaveAlloc.Reset;
                    HRLeaveAlloc.SetRange("No.", "Employee No.");
                    HRLeaveAlloc.SetRange("Calendar Code", HRLeaveCal.Code);
                    HRLeaveAlloc.SetRange("Entry Type", HRLeaveAlloc."entry type"::"Positive Adjustment");
                    HRLeaveAlloc.SetRange("Leave Type", "Leave Type");
                    HRLeaveAlloc.SetRange("Posting Type", HRLeaveAlloc."posting type"::Normal);
                    if HRLeaveAlloc.FindSet then begin
                        HRLeaveAlloc.CalcSums("No. Of days");
                        "Allocated Days" := HRLeaveAlloc."No. Of days";
                        "Current Leave Balance" := ("Allocated Days" + "Reimbursed Days") - "Current Total Leave Taken";
                        Modify;
                    end;
                    end;
                      if "Current Leave Balance"<0.5 then Error('Your leave balance is below 0.5 days');
                        "End Date" := "Start Date";
                        "Return Date" := "Start Date";
                        
                    end else begin
                        yearend := 365;
                Clear("Reimbursed Days");
                Clear("Allocated Days");
                Clear("Current Leave Balance");
                Clear("Current Total Leave Taken");
                //Check Calendar
                HRLeaveCal.Reset;
                HRLeaveCal.SetRange(Current, true);
                if HRLeaveCal.FindFirst() then begin
                    HRLeaveCal.TestField("Start Date");
                    //More than once calendar exists
                    if HRLeaveCal.Count > 1 then Error(ERR_ACTIVE_LEAVE_CALENDAR, HRLeaveCal.Count);

                    //Total Leave Taken
                    HRLeaveAlloc.Reset;
                    HRLeaveAlloc.SetRange("No.", "Employee No.");
                    HRLeaveAlloc.SetRange("Calendar Code", HRLeaveCal.Code);
                    HRLeaveAlloc.SetRange("Entry Type", HRLeaveAlloc."entry type"::"Negative Adjustment");
                    HRLeaveAlloc.SetRange("Leave Type", "Leave Type");
                    HRLeaveAlloc.SetRange("Posting Type", HRLeaveAlloc."posting type"::Normal);
                    if HRLeaveAlloc.FindSet then begin
                        HRLeaveAlloc.CalcSums("No. Of days");
                        "Current Total Leave Taken" := (HRLeaveAlloc."No. Of days") * -1;
                        Modify;
                    end;

                    //Reimburesed Days
                    HRLeaveAlloc.Reset;
                    HRLeaveAlloc.SetRange("No.", "Employee No.");
                    HRLeaveAlloc.SetRange("Calendar Code", HRLeaveCal.Code);
                    HRLeaveAlloc.SetRange("Leave Type", "Leave Type");
                    HRLeaveAlloc.SetRange("Entry Type", HRLeaveAlloc."entry type"::"Positive Adjustment");
                    HRLeaveAlloc.SetRange("Posting Type", HRLeaveAlloc."posting type"::Reimbursement);
                    if HRLeaveAlloc.FindSet then begin
                        HRLeaveAlloc.CalcSums("No. Of days");
                        "Reimbursed Days" := HRLeaveAlloc."No. Of days";
                        Modify;
                    end;

                    //Allocated Days
                    HRLeaveAlloc.Reset;
                    HRLeaveAlloc.SetRange("No.", "Employee No.");
                    HRLeaveAlloc.SetRange("Calendar Code", HRLeaveCal.Code);
                    HRLeaveAlloc.SetRange("Entry Type", HRLeaveAlloc."entry type"::"Positive Adjustment");
                    HRLeaveAlloc.SetRange("Leave Type", "Leave Type");
                    HRLeaveAlloc.SetRange("Posting Type", HRLeaveAlloc."posting type"::Normal);
                    if HRLeaveAlloc.FindSet then begin
                        HRLeaveAlloc.CalcSums("No. Of days");
                        "Allocated Days" := HRLeaveAlloc."No. Of days";
                        "Current Leave Balance" := ("Allocated Days" + "Reimbursed Days") - "Current Total Leave Taken";
                        Modify;
                    end;
                    end;
                      if "Current Leave Balance"<0.5 then Error('Your leave balance is below 0.5 days');
                        "End Date" := "Start Date";
                        "Return Date" := DetermineLeaveReturnDate(rec."Start Date", applieddayshalfday);
                    end;
                end else if "Select Whether Half Day" = "Select Whether Half Day"::"Half Day Evening" then begin
                    TestField(Annual, true);
                    dayofweek := Date2DWY("Start Date", 1);
                    if dayofweek < 6 then begin
                        yearend := 365;
                Clear("Reimbursed Days");
                Clear("Allocated Days");
                Clear("Current Leave Balance");
                Clear("Current Total Leave Taken");
                //Check Calendar
                HRLeaveCal.Reset;
                HRLeaveCal.SetRange(Current, true);
                if HRLeaveCal.FindFirst() then begin
                    HRLeaveCal.TestField("Start Date");
                    //More than once calendar exists
                    if HRLeaveCal.Count > 1 then Error(ERR_ACTIVE_LEAVE_CALENDAR, HRLeaveCal.Count);

                    //Total Leave Taken
                    HRLeaveAlloc.Reset;
                    HRLeaveAlloc.SetRange("No.", "Employee No.");
                    HRLeaveAlloc.SetRange("Calendar Code", HRLeaveCal.Code);
                    HRLeaveAlloc.SetRange("Entry Type", HRLeaveAlloc."entry type"::"Negative Adjustment");
                    HRLeaveAlloc.SetRange("Leave Type", "Leave Type");
                    HRLeaveAlloc.SetRange("Posting Type", HRLeaveAlloc."posting type"::Normal);
                    if HRLeaveAlloc.FindSet then begin
                        HRLeaveAlloc.CalcSums("No. Of days");
                        "Current Total Leave Taken" := (HRLeaveAlloc."No. Of days") * -1;
                        Modify;
                    end;

                    //Reimburesed Days
                    HRLeaveAlloc.Reset;
                    HRLeaveAlloc.SetRange("No.", "Employee No.");
                    HRLeaveAlloc.SetRange("Calendar Code", HRLeaveCal.Code);
                    HRLeaveAlloc.SetRange("Leave Type", "Leave Type");
                    HRLeaveAlloc.SetRange("Entry Type", HRLeaveAlloc."entry type"::"Positive Adjustment");
                    HRLeaveAlloc.SetRange("Posting Type", HRLeaveAlloc."posting type"::Reimbursement);
                    if HRLeaveAlloc.FindSet then begin
                        HRLeaveAlloc.CalcSums("No. Of days");
                        "Reimbursed Days" := HRLeaveAlloc."No. Of days";
                        Modify;
                    end;

                    //Allocated Days
                    HRLeaveAlloc.Reset;
                    HRLeaveAlloc.SetRange("No.", "Employee No.");
                    HRLeaveAlloc.SetRange("Calendar Code", HRLeaveCal.Code);
                    HRLeaveAlloc.SetRange("Entry Type", HRLeaveAlloc."entry type"::"Positive Adjustment");
                    HRLeaveAlloc.SetRange("Leave Type", "Leave Type");
                    HRLeaveAlloc.SetRange("Posting Type", HRLeaveAlloc."posting type"::Normal);
                    if HRLeaveAlloc.FindSet then begin
                        HRLeaveAlloc.CalcSums("No. Of days");
                        "Allocated Days" := HRLeaveAlloc."No. Of days";
                        "Current Leave Balance" := ("Allocated Days" + "Reimbursed Days") - "Current Total Leave Taken";
                        Modify;
                    end;
                    end;
                      if "Current Leave Balance"<0.5 then Error('Your leave balance is below 0.5 days');
                        "End Date" := "Start Date";
                        //"Return Date" := CalcDate('1D', "Start Date");
                        "Return Date" := DetermineLeaveReturnDate(rec."Start Date", applieddayshalfday);
                    end else begin
                        if rec."Branch Code" = '' then begin
                            Error('You cannot apply half day leave on this day');
                        end else if rec."Branch Code" <> '' then begin
                            yearend := 365;
                Clear("Reimbursed Days");
                Clear("Allocated Days");
                Clear("Current Leave Balance");
                Clear("Current Total Leave Taken");
                //Check Calendar
                HRLeaveCal.Reset;
                HRLeaveCal.SetRange(Current, true);
                if HRLeaveCal.FindFirst() then begin
                    HRLeaveCal.TestField("Start Date");
                    //More than once calendar exists
                    if HRLeaveCal.Count > 1 then Error(ERR_ACTIVE_LEAVE_CALENDAR, HRLeaveCal.Count);

                    //Total Leave Taken
                    HRLeaveAlloc.Reset;
                    HRLeaveAlloc.SetRange("No.", "Employee No.");
                    HRLeaveAlloc.SetRange("Calendar Code", HRLeaveCal.Code);
                    HRLeaveAlloc.SetRange("Entry Type", HRLeaveAlloc."entry type"::"Negative Adjustment");
                    HRLeaveAlloc.SetRange("Leave Type", "Leave Type");
                    HRLeaveAlloc.SetRange("Posting Type", HRLeaveAlloc."posting type"::Normal);
                    if HRLeaveAlloc.FindSet then begin
                        HRLeaveAlloc.CalcSums("No. Of days");
                        "Current Total Leave Taken" := (HRLeaveAlloc."No. Of days") * -1;
                        Modify;
                    end;

                    //Reimburesed Days
                    HRLeaveAlloc.Reset;
                    HRLeaveAlloc.SetRange("No.", "Employee No.");
                    HRLeaveAlloc.SetRange("Calendar Code", HRLeaveCal.Code);
                    HRLeaveAlloc.SetRange("Leave Type", "Leave Type");
                    HRLeaveAlloc.SetRange("Entry Type", HRLeaveAlloc."entry type"::"Positive Adjustment");
                    HRLeaveAlloc.SetRange("Posting Type", HRLeaveAlloc."posting type"::Reimbursement);
                    if HRLeaveAlloc.FindSet then begin
                        HRLeaveAlloc.CalcSums("No. Of days");
                        "Reimbursed Days" := HRLeaveAlloc."No. Of days";
                        Modify;
                    end;

                    //Allocated Days
                    HRLeaveAlloc.Reset;
                    HRLeaveAlloc.SetRange("No.", "Employee No.");
                    HRLeaveAlloc.SetRange("Calendar Code", HRLeaveCal.Code);
                    HRLeaveAlloc.SetRange("Entry Type", HRLeaveAlloc."entry type"::"Positive Adjustment");
                    HRLeaveAlloc.SetRange("Leave Type", "Leave Type");
                    HRLeaveAlloc.SetRange("Posting Type", HRLeaveAlloc."posting type"::Normal);
                    if HRLeaveAlloc.FindSet then begin
                        HRLeaveAlloc.CalcSums("No. Of days");
                        "Allocated Days" := HRLeaveAlloc."No. Of days";
                        "Current Leave Balance" := ("Allocated Days" + "Reimbursed Days") - "Current Total Leave Taken";
                        Modify;
                    end;
                    end;
                      if "Current Leave Balance"<0.5 then Error('Your leave balance is below 0.5 days');
                            "End Date" := "Start Date";
                            //"Return Date" := CalcDate('1D', "Start Date");
                            "Return Date" := DetermineLeaveReturnDate(rec."Start Date", applieddayshalfday);
                        end;

                    end;
                end;
            end;
        }
        field(60; unlimited; Boolean)
        {

        }
        field(61; "No of Limited days"; Integer) { }
        field(62; "Branch Code"; Code[20]) { }

        field(64;"leave Name";Text[150]){
            Editable=false;
        }

    }

    keys
    {
        key(Key1; "Application Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnDelete()
    begin
        //ERROR('Please edit document instead of deleting');
    end;

    trigger OnInsert()
    var
        TheTable: Record "HR Leave Application";
        NoofMonthsWorked: Decimal;
        noofdaysworked: Integer;
        HRCalendar: Record "HR Leave Calendar.";
    begin

        if "Application Code" = '' then begin
            IF "Application Code" = '' THEN BEGIN
                TheTable.RESET;
                IF TheTable.FINDLAST THEN BEGIN
                    //Message(TheTable."Application Code");
                    "Application Code" := INCSTR(TheTable."Application Code")
                END ELSE BEGIN
                    "Application Code" := 'LV00001';
                END;
            END;
            HRCalendar.Reset();
            HRCalendar.SetRange(Current, true);
            if HRCalendar.FindFirst() then
                HRCalendar.TestField("Start Date");
            "Application Date" := Today;

            NoofMonthsWorked := ABS(DATE2DMY("Application Date", 2) - DATE2DMY(HRCalendar."Start Date", 2));

            IF DATE2DMY("Application Date", 3) = DATE2DMY(HRCalendar."Start Date", 3) THEN BEGIN
                NoofMonthsWorked := DATE2DMY("Application Date", 2) - DATE2DMY(HRCalendar."Start Date", 2);
            END;

            IF DATE2DMY("Application Date", 3) <> DATE2DMY(HRCalendar."Start Date", 3) THEN BEGIN
                NoofMonthsWorked := (DATE2DMY("Application Date", 2) + 12) - DATE2DMY(HRCalendar."Start Date", 2);
            END;
        end;
        //Staff Details
        HREmp.Reset;
        HREmp.SetRange("User ID", UserId);
        if HREmp.FindFirst() then begin
            if HREmp.Count > 1 then Error('User ID [ %1 ] is linked to [ %2 ] Staff Nos.', UserId, HREmp.Count);
            if HREmp.Status = HREmp.Status::InActive then Error('Inactive employee cannot apply');
            HREmp.TestField("Responsibility Center");
            HREmp.TestField(Gender);
            Gender := HREmp.Gender;
            if "Leave Type"<>'' then begin
                HRLeaveTypes.Reset();
                HRLeaveTypes.SetRange(HRLeaveTypes.Code,"Leave Type");
                if HRLeaveTypes.FindFirst() then begin                   
                    if HRLeaveTypes.Gender<>HREmp.Gender then begin
                        if HRLeaveTypes.Gender<>HRLeaveTypes.Gender::Both then begin
                            Error('The leave can only be applied by'+Format(HRLeaveTypes.Gender));
                        end;
                    end;
                end;
            end;
            "Employee No." := HREmp."No.";
            "Empoyee Name" := HREmp."Full Name";
            "Branch Code" := HREmp."Global Dimension 3 Code";
            "Supervisor ID" := HREmp."Supervisor User ID";
            "Responsibility Center" := HREmp."Responsibility Center";
            
        end else begin
            Error('User ID [ %1 ] has not been mapped to any "No."', UserId);
        end;
    end;

    var
        HREmp: Record "HR-Employee";
        HRLeaveTypes: Record "Leave Types";
        HRLeaveAlloc: Record "HR Leave Allocation";
        noofdaysworked: Integer;
        limiteddays: Integer;
        yearend: Integer;
        NoofMonthsWorked: Integer;
        maternityeditable: Boolean;
        HRLeaveCal: Record "HR Leave Calendar.";
        HRCalendar: Record "HR Leave Calendar.";
        nooflimiteddays: Integer;
        DimVal: Record "Dimension Value";
        ERR_ACTIVE_LEAVE_CALENDAR: label 'There are currently [ %1 ] Active Leave Calendars. Please ensure one calendar is Active';

    procedure DetermineLeaveReturnDate(var fBeginDate: Date; var fDays: Decimal) fReturnDate: Date
    var
        varDaysApplied: Decimal;
        HRLeaveCalendarLines: Record "HR Leave Calendar Lines";
        LeaveRemaining: Decimal;
        DayOfWeek: Integer;
        CalendarCode: Code[20];
    begin
        LeaveRemaining := fDays;
        fReturnDate := fBeginDate;
        repeat // If the leave type does not count non working days in its calculations, proceed
            if DetermineIfIncludesNonWorking("Leave Type") = false then begin
                // If the current date is a non working day, add the leaves remaining plus 1, else keep them as is.
                if DetermineIfIsNonWorking(fReturnDate) then
                    LeaveRemaining := LeaveRemaining + 1
                else
                    LeaveRemaining := LeaveRemaining;
                // Get the day of the week for the current date we are looping
                DayOfWeek := Date2DWY(fReturnDate, 1);
                // If the current day is a saturday and saturday is a working day, then reduce the leave remaining with 0.5, else reduce 1 day
                if (DayOfWeek = 6) and (not DetermineIfIsNonWorking(fReturnDate)) then
                    LeaveRemaining := LeaveRemaining - 0.5
                else
                    LeaveRemaining := LeaveRemaining - 1;
                fReturnDate := CalcDate('<+1D>', fReturnDate);
            end
            // if the leave type counts non working days in its calculations, proceeds
            else begin
                DayOfWeek := Date2DWY(fReturnDate, 1);
                LeaveRemaining := LeaveRemaining - 1;
                fReturnDate := CalcDate('<+1D>', fReturnDate);
            end;
        until LeaveRemaining <= 0;
        //if current Date is working then get next working date
        if DetermineIfIsNonWorking(fReturnDate) then begin
            CalendarCode := fn_GetCurrCalendar();
            HRLeaveCalendarLines.Reset();
            HRLeaveCalendarLines.SetRange(Code, CalendarCode);
            HRLeaveCalendarLines.SetRange("Non Working", false);
            HRLeaveCalendarLines.SetFilter(Date, '>%1', fReturnDate);
            if HRLeaveCalendarLines.FindFirst() then fReturnDate := HRLeaveCalendarLines.Date;
        end;
        exit(fReturnDate);
    end;

    local procedure fn_GetCurrCalendar(): Code[20]
    var
        hrLeaveCalendar: Record "HR Leave Calendar.";
    begin
        hrLeaveCalendar.Reset();
        //hrLeaveCalendar.SetRange("Global Dimension 1 Code", "Global Dimension 1 Code");
        hrLeaveCalendar.SetRange(Current, true);
        if hrLeaveCalendar.FindFirst() then
            exit(hrLeaveCalendar.Code)
        else
            Error('There is no Current Active Calender');
    end;

    procedure DetermineIfIncludesNonWorking(var fLeaveCode: Code[30]): Boolean
    begin
        if HRLeaveTypes.Get(fLeaveCode) then begin
            if HRLeaveTypes."Inclusive of Non Working Days" = true then begin
                exit(true)
            end else begin
                exit(false);
            end;
        end;
    end;

    local procedure ValidateOverlappingLeave(
    EmployeeNo: Code[20];
    ApplicationCode: Code[20];
    StartDate: Date;
    EndDate: Date)
var
    LeaveApplication: Record "HR Leave Application";
    LeaveAllocation: Record "HR Leave Allocation";
begin
    //=========================================
    // Check Open / Pending Leave Applications
    //=========================================
    LeaveApplication.Reset();
    LeaveApplication.SetRange("Employee No.", EmployeeNo);
    LeaveApplication.SetFilter("Application Code", '<>%1', ApplicationCode);

    LeaveApplication.SetFilter(
        Status,
        '%1|%2',
        LeaveApplication.Status::Open,
        LeaveApplication.Status::"Pending Approval");

    LeaveApplication.SetFilter("Start Date", '<=%1', EndDate);
    LeaveApplication.SetFilter("End Date", '>=%1', StartDate);

    if LeaveApplication.FindFirst() then
        Error(
            'Leave overlaps with pending application %1 (%2 to %3).',
            LeaveApplication."Application Code",
            LeaveApplication."Start Date",
            LeaveApplication."End Date");

    //=========================================
    // Check Posted Leave
    //=========================================
    LeaveAllocation.Reset();
    LeaveAllocation.SetRange("No.", EmployeeNo);
    LeaveAllocation.SetRange(Posted, true);
    LeaveAllocation.SetRange("Entry Type", LeaveAllocation."Entry Type"::"Negative Adjustment");
    LeaveAllocation.SetRange("Posting Type", LeaveAllocation."Posting Type"::Normal);

    // Ignore the same application if it already exists
    LeaveAllocation.SetFilter("Document No.", '<>%1', ApplicationCode);

    LeaveAllocation.SetFilter("Application Start Date", '<=%1', EndDate);
    LeaveAllocation.SetFilter("Application End Date", '>=%1', StartDate);

    if LeaveAllocation.FindFirst() then
        Error(
            'Leave overlaps with posted leave %1 (%2 to %3).',
            LeaveAllocation."Document No.",
            LeaveAllocation."Application Start Date",
            LeaveAllocation."Application End Date");
end;

    procedure DetermineIfIsNonWorking(var bcDate: Date) Isnonworking: Boolean
    var
        HRLeave_Calendar: Record "HR Leave Calendar Lines";
    begin

        HRLeave_Calendar.Reset;
        HRLeave_Calendar.SetRange(HRLeave_Calendar.Date, bcDate);
        if HRLeave_Calendar.FindFirst() then begin
            if HRLeave_Calendar."Non Working" = true then
                exit(true)
            else
                exit(false);
        end;
    end;

    procedure DeterminethisLeaveEndDate(var fDate: Date) fEndDate: Date
    var
        ReturnDateLoop: Boolean;
    begin
        ReturnDateLoop := true;
        fEndDate := fDate;
        if fEndDate <> 0D then begin
            if "Select Whether Half Day" <> "Select Whether Half Day"::"Half Day Morning" then
                fEndDate := CalcDate('-1D', fEndDate);
            while (ReturnDateLoop) do begin
                if DetermineIfIsNonWorking(fEndDate) then
                    fEndDate := CalcDate('-1D', fEndDate)
                else
                    ReturnDateLoop := false;
            end
        end;
        if (fDate <> 0D) and
           (fEndDate <> 0D) then
            ValidateOverlappingLeave(
                Rec."Employee No.",
                Rec."Application Code",
                Rec."Start Date",
                Rec."End Date");
    

        exit(fEndDate);
    end;

    procedure fn_PostLeaveApplication(LeaveDocNo: Code[50])
    var
        HRLeaveAppToPost: Record "HR Leave Application";
        CurrCalender: Record "HR Leave Calendar.";
    begin

        //Get Leave Details
        HRLeaveAppToPost.Reset;
        HRLeaveAppToPost.SetRange("Application Code", LeaveDocNo);
        if HRLeaveAppToPost.FindSet(true, false) then begin

            if HRLeaveAppToPost.Status = HRLeaveAppToPost.Status::Posted then Error('Document no [ %1 ] has already been posted');
            //Staff Details
            HREmp.Reset;
            HREmp.Get(HRLeaveAppToPost."Employee No.");

            //Post Leave
            HRLeaveAlloc.Reset;
            HRLeaveAlloc."Entry No." := fn_LastLineNo;

            CurrCalender.Reset;
            CurrCalender.SetRange(Current, true);
            if CurrCalender.FindFirst() then begin
                if CurrCalender.Count > 1 then Error('No active calendar exists', CurrCalender.Count);
                HRLeaveAlloc."Calendar Code" := CurrCalender.Code;
            end;
            HRLeaveAlloc."No." := HREmp."No.";
            HRLeaveAlloc."Staff Name" := HREmp."Full Name";

            HRLeaveAlloc."Posting Date" := Today;

            HRLeaveAlloc."Entry Type" := HRLeaveAlloc."entry type"::"Negative Adjustment";
            HRLeaveAlloc."Posting Type" := HRLeaveAlloc."posting type"::Normal;

            HRLeaveAlloc."No. Of days" := (HRLeaveAppToPost."Days Applied") * -1;
            HRLeaveAlloc."Leave Type" := HRLeaveAppToPost."Leave Type";

            HRLeaveAlloc."Posting Description" := Format(HRLeaveAlloc."Entry Type") + ' Allocation - ' + Format(Today);
            HRLeaveAlloc."Posted By" := UserId;

            HRLeaveAlloc.Posted := true;

            HRLeaveAlloc."Calendar Start Date" := 20200101D;
            HRLeaveAlloc."Calendar End Date" := 20200101D;
            HRLeaveAlloc."Document No." := HRLeaveAppToPost."Application Code";
            HRLeaveAlloc."Posting Source" := HRLeaveAlloc."posting source"::Document;

            //Application Date
            HRLeaveAlloc."Application Start Date" := HRLeaveAppToPost."Start Date";
            HRLeaveAlloc."Application End Date" := HRLeaveAppToPost."End Date";
            HRLeaveAlloc."Application Return Date" := HRLeaveAppToPost."Return Date";

            HRLeaveAlloc.Insert;
            //Now change status of document to posted
            HRLeaveAppToPost.Status := HRLeaveAppToPost.Status::Posted;
            HRLeaveAppToPost.Posted := true;
            HRLeaveAppToPost."Posted By" := userid;
            HRLeaveAppToPost."Date Posted" := today;
            HRLeaveAppToPost."Time Posted" := time;
            HRLeaveAppToPost.Modify;
        end;
    end;

    procedure fn_Reverse_PostedLeaveApplication(LeaveDocNo: Code[50])
    var
        HRLeaveAppToPost: Record "HR Leave Application";
    begin

        //Get Leave Details
        HRLeaveAppToPost.Reset;
        if HRLeaveAppToPost.Get(LeaveDocNo) then begin

            if HRLeaveAppToPost.Status = HRLeaveAppToPost.Status::Posted then Error('Document no [ %1 ] has already been posted');
            //Staff Details
            HREmp.Reset;
            HREmp.Get(HRLeaveAppToPost."Employee No.");

            //Post Leave
            HRLeaveAlloc.Reset;
            HRLeaveAlloc."Entry No." := fn_LastLineNo;
            HRLeaveAlloc."Calendar Code" := 'CAL-00001';

            HRLeaveAlloc."No." := HREmp."No.";
            HRLeaveAlloc."Staff Name" := HREmp."Full Name";

            HRLeaveAlloc."Posting Date" := Today;

            HRLeaveAlloc."Entry Type" := HRLeaveAlloc."entry type"::"Positive Adjustment";
            HRLeaveAlloc."Posting Type" := HRLeaveAlloc."posting type"::Normal;

            HRLeaveAlloc."No. Of days" := (HRLeaveAppToPost."Days Applied");
            HRLeaveAlloc."Leave Type" := HRLeaveAppToPost."Leave Type";

            HRLeaveAlloc."Posting Description" := Format(HRLeaveAlloc."Entry Type") + ' Reversal - ' + Format(Today);
            HRLeaveAlloc."Posted By" := UserId;

            HRLeaveAlloc.Posted := true;

            HRLeaveAlloc."Calendar Start Date" := 20200101D;
            HRLeaveAlloc."Calendar End Date" := 20200101D;
            HRLeaveAlloc."Document No." := HRLeaveAppToPost."Application Code";
            HRLeaveAlloc."Posting Source" := HRLeaveAlloc."posting source"::Document;

            //Application Date
            HRLeaveAlloc."Application Start Date" := HRLeaveAppToPost."Start Date";
            HRLeaveAlloc."Application End Date" := HRLeaveAppToPost."End Date";
            HRLeaveAlloc."Application Return Date" := HRLeaveAppToPost."Return Date";

            HRLeaveAlloc.Insert;
            //Now change status of document to posted
            HRLeaveAppToPost.Reversed := true;
            HRLeaveAppToPost."Reversed By" := userid;
            HRLeaveAppToPost."Reversed Date" := today;
            HRLeaveAppToPost.Modify;
        end;
    end;

    local procedure fn_LastLineNo(): Integer
    var
        HRLeaveAllocation_2: Record "HR Leave Allocation";
    begin
        HRLeaveAllocation_2.Reset;
        if HRLeaveAllocation_2.Find('+') then begin
            exit(HRLeaveAllocation_2."Entry No." + 1);
        end else begin
            exit(1);
        end;
    end;
}

