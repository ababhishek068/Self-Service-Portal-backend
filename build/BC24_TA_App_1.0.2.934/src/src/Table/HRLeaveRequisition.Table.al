Table 50788 "HR Leave Requisition"
{
    DrillDownPageID = "HR Leave Application List";
    LookupPageID = "HR Leave Application List";

    fields
    {
        field(1; "No."; Code[20]) { }
        field(2; Date; Date) { }
        field(3; "Employee No"; Code[20])
        {
            TableRelation = "HR-Employee"."No.";

            trigger OnValidate()
            begin

                if Emp.Get("Employee No") then begin
                    Emp.CalcFields(Emp."Leave Balance");
                    "Employee Name" := Emp."First Name" + ' ' + Emp."Middle Name" + ' ' + Emp."Last Name";
                    "Leave Balance" := Emp."Leave Balance";
                    "Department Code" := Emp."Department Code";
                end;
                EmpLeaveApps.Reset;
                EmpLeaveApps.SetRange(EmpLeaveApps."Employee No", "Employee No");
                // EmpLeaveApps.SETFILTER(EmpLeaveApps.Status,'<>%1',EmpLeaveApps.Status::Released);
                EmpLeaveApps.SetFilter(EmpLeaveApps.Status, '=%1', EmpLeaveApps.Status::Open);
                if EmpLeaveApps.Count > 0 then Error('Please note that you already have a pending leave application');
            end;
        }
        field(4; "Employee Name"; Text[100]) { }
        field(5; "Global Dimension 1 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(6; "Department Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(7; "Applied Days"; Decimal)
        {
            DecimalPlaces = 0 : 0;

            trigger OnValidate()
            begin

                CalcFields("Availlable Days");
                //IF "Leave Type"='ANNUAL' THEN BEGIN
                if (("Availlable Days" = 0) or ("Applied Days" > "Availlable Days")) then begin
                    Error('Applied days must not be more than leave balance.');
                end;
                //END;
                if ("Applied Days" <> 0) and ("Starting Date" <> 0D) then begin
                    "End Date" := CalcEndDate("Starting Date", "Applied Days");
                    "Return Date" := CalcReturnDate("End Date");
                    Validate("Starting Date")
                end;
            end;
        }
        field(8; "Starting Date"; Date)
        {

            trigger OnValidate()
            begin
                dates.Reset;
                dates.SetRange(dates."Period Start", "Starting Date");
                dates.SetFilter(dates."Period Type", '=%1', dates."period type"::Date);
                if dates.Find('-') then
                    if ((dates."Period Name" = 'Sunday') or (dates."Period Name" = 'Saturday')) then begin
                        if (dates."Period Name" = 'Sunday') then
                            Error('You can not start your leave on a Sunday')
                        else
                            if (dates."Period Name" = 'Saturday') then Error('You can not start your leave on a Saturday')
                    end;

                // Check if the start date is a holliday
                //BaseCalendar.RESET;
                //BaseCalendar.SETRANGE(BaseCalendar.Date,"Starting Date");
                //BaseCalendar.SETFILTER(BaseCalendar."Recurring System",'=%1',BaseCalendar."Recurring System"::"Annual Recurring");
                //I/F BaseCalendar.FIND('-') THEN BEGIN
                //IF BaseCalendar.Description<>'' THEN
                // ERROR('You can not start your Leave on a Holiday - '''+BaseCalendar.Description+'''')
                // ELSE ERROR('You can not start your Leave on a Holiday');
                //END;
                // For one of Hollidays Like Isther
                BaseCalendar.Reset;
                BaseCalendar.SetFilter(BaseCalendar."Base Calendar Code", GeneralOptions."Base Calendar");
                BaseCalendar.SetRange(BaseCalendar.Date, "Starting Date");
                if BaseCalendar.Find('-') then begin
                    repeat
                        if BaseCalendar.Nonworking = true then begin
                            if BaseCalendar.Description <> '' then
                                Error('You can not start your Leave on a Holiday - ''' + BaseCalendar.Description + '''')
                            else
                                Error('You can not start your Leave on a Holiday');
                        end;
                    until BaseCalendar.Next = 0;
                end;

                // For Annual Holidays
                BaseCalendar.Reset;
                BaseCalendar.SetFilter(BaseCalendar."Base Calendar Code", GeneralOptions."Base Calendar");
                BaseCalendar.SetRange(BaseCalendar."Recurring System", BaseCalendar."recurring system"::"Annual Recurring");
                if BaseCalendar.Find('-') then begin
                    repeat
                        if ((Date2dmy("Starting Date", 1) = BaseCalendar."Date Day") and (Date2dmy("Starting Date", 2) = BaseCalendar."Date Month")) then begin
                            if BaseCalendar.Nonworking = true then begin
                                if BaseCalendar.Description <> '' then
                                    Error('You can not start your Leave on a Holiday - ''' + BaseCalendar.Description + '''')
                                else
                                    Error('You can not start your Leave on a Holiday');
                            end;
                        end;
                    until BaseCalendar.Next = 0;
                end;


                if ("Applied Days" <> 0) and ("Starting Date" <> 0D) then begin
                    "End Date" := CalcEndDate("Starting Date", "Applied Days");
                    "Return Date" := CalcReturnDate("End Date");
                    //"Approved End Date":="End Date";

                end;
            end;
        }
        field(9; "End Date"; Date) { }
        field(10; Purpose; Text[200]) { }
        field(11; "Leave Type"; Code[20])
        {
            TableRelation = "Leave Types".Code;

            trigger OnValidate()
            begin
                CalcFields("Availlable Days");
                if Emp.Get("Employee No") then begin
                    Emp.CalcFields(Emp."Leave Balance");
                    "Leave Balance" := Emp."Leave Balance";
                end;
            end;
        }
        field(12; "Leave Balance"; Decimal)
        {
            DecimalPlaces = 0 : 0;
        }
        field(13; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(14; Status; Option)
        {
            Editable = true;
            OptionCaption = 'Open,Released,Pending Approval,Pending Prepayment,Cancelled,Posted';
            OptionMembers = Open,Released,"Pending Approval","Pending Prepayment",Cancelled,Posted;

            trigger OnValidate()
            begin
                /*
                  IF Status = Status::Posted THEN BEGIN
                 leaveLedgers.RESET;
                 IF leaveLedgers.FIND('+') THEN
                 lastNo:=leaveLedgers."Entry No."+10
                 ELSE lastNo:=10;
                  // post the leave application to ledger entries with a negative adjustment
                  leaveLedgers.INIT;
                   leaveLedgers."Entry No.":=lastNo;
                   leaveLedgers."Employee No":="Employee No";
                   leaveLedgers."Document No":="No.";
                   leaveLedgers."Leave Type":="Leave Type";
                   leaveLedgers."Transaction Date":=TODAY;
                   leaveLedgers."Transaction Type":=leaveLedgers."Transaction Type"::Application;
                   leaveLedgers."No. of Days":=(("Applied Days")*(-1));
                   leaveLedgers."Transaction Description":='Leave Application';
                   leaveLedgers."Leave Period":=DATE2DWY(TODAY,3);
                  leaveLedgers.INSERT;
                  "Leave Balance":="Availlable Days";
                  MODIFY
                 END;
                 */

            end;
        }
        field(15; "User ID"; Code[30]) { }
        field(16; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center BR".Code;

            trigger OnValidate()
            begin

                TestField(Status, Status::Open);
                //  if not UserMgt.CheckRespCenter(1, "Responsibility Center") then
                //     Error(
                //       Text001,
                //        RespCenter.TableCaption, UserMgt.GetPurchasesFilter);
                /*
               "Location Code" := UserMgt.GetLocation(1,'',"Responsibility Center");
               IF "Location Code" = '' THEN BEGIN
                 IF InvtSetup.GET THEN
                   "Inbound Whse. Handling Time" := InvtSetup."Inbound Whse. Handling Time";
               END ELSE BEGIN
                 IF Location.GET("Location Code") THEN;
                 "Inbound Whse. Handling Time" := Location."Inbound Whse. Handling Time";
               END;

               UpdateShipToAddress;
                  */
                /*
             CreateDim(
               DATABASE::"Responsibility Center","Responsibility Center",
               DATABASE::Vendor,"Pay-to Vendor No.",
               DATABASE::"Salesperson/Purchaser","Purchaser Code",
               DATABASE::Campaign,"Campaign No.");

             IF xRec."Responsibility Center" <> "Responsibility Center" THEN BEGIN
               RecreatePurchLines(FIELDCAPTION("Responsibility Center"));
               "Assigned User ID" := '';
             END;
               */

            end;
        }
        field(17; Posted; Boolean) { }
        field(18; "Posted By"; Code[20]) { }
        field(19; "Posting Date"; Date) { }
        field(20; "Process Leave Allowance"; Boolean) { }
        field(21; "Availlable Days"; Decimal)
        {
            CalcFormula = sum("HR Leave Ledger"."No. of Days" where("Employee No" = field("Employee No"),
                                                                     "Leave Type" = field("Leave Type")));
            DecimalPlaces = 0 : 0;
            FieldClass = FlowField;
        }
        field(22; "Return Date"; Date) { }
        field(23; "Reliever No."; Code[30])
        {
            TableRelation = "HR-Employee"."No.";

            trigger OnValidate()
            begin
                if Emp3.Get("Reliever No.") then
                    "Reliever Name" := Emp3."First Name" + ' ' + Emp3."Middle Name" + ' ' + Emp3."Last Name";
            end;
        }
        field(24; "Reliever Name"; Text[250]) { }
        field(25; "Employee Dept"; Code[50])
        {
            CalcFormula = lookup("HR-Employee"."Department Code" where("No." = field("Employee No")));
            FieldClass = FlowField;
        }
        field(26; HOD; Code[50])
        {
            CalcFormula = lookup("Dimension Value".HOD where(Code = field("Department Code")));
            FieldClass = FlowField;
        }
        field(27; "Approver ID"; Code[50])
        {
            CalcFormula = lookup("HR-Employee"."User ID" where("No." = field(HOD)));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnDelete()
    begin
        // IF Status<>Status::Open THEN ERROR('You can only delete a document if its status is still Open!')
    end;

    trigger OnInsert()
    begin

        if "No." = '' then begin
            GenLedgerSetup.Get();
            GenLedgerSetup.TestField(GenLedgerSetup."Leave Application Nos.");
             "No.":=NoSeriesMgt.GetNextNo(GenLedgerSetup."Leave Application Nos.", 0D, true);
        end;
        "User ID" := UserId;
        Date := Today;
        Status := Status::Open;

        if usersetup.Get(UserId) then begin
            if usersetup."Employee No." = '' then
                Error('You are not authorized to use the leave application page. Please consult the system administrator.');
            if Employee.Get(CopyStr(usersetup."Employee No.", 4, ((StrLen(usersetup."Employee No.")) - 3))) then begin
                "Employee No" := Employee."No.";
                Validate("Employee No");
                "Global Dimension 1 Code" := usersetup."Global Dimension 1 Code";
                "Department Code" := usersetup."Global Dimension 2 Code";
                Date := Today;
            end;
        end;
    end;

    var
        GenLedgerSetup: Record "HR Setup";
        Emp3: Record "HR-Employee";
        Emp: Record "HR-Employee";
        BaseCalendar: Record "Base Calendar Change2";
        LeaveTypes: Record "Leave Types";
        NoSeriesMgt: Codeunit "No. Series";
        varDaysApplied: Integer;
        ReturnDateLoop: Boolean;
        Employee: Record "HR-Employee";
        EmpLeaveApps: Record "HR Leave Requisition";
        GeneralOptions: Record "HR Setup";
        objPeriod: Record "pr Payroll Periods";
        PayPeriod: Date;
        usersetup: Record "User Setup";
        dates: Record Date;

    procedure DetermineIfIsNonWorking(var bcDate: Date; var ltype: Record "Leave Types") ItsNonWorking: Boolean
    var
        dates: Record Date;
    begin
        Clear(ItsNonWorking);
        GeneralOptions.Find('-');
        //One off Hollidays like Good Friday
        BaseCalendar.Reset;
        BaseCalendar.SetFilter(BaseCalendar."Base Calendar Code", GeneralOptions."Base Calendar");
        BaseCalendar.SetRange(BaseCalendar.Date, bcDate);
        if BaseCalendar.Find('-') then begin
            if BaseCalendar.Nonworking = true then
                ItsNonWorking := true;
        end;

        // For Annual Holidays
        BaseCalendar.Reset;
        BaseCalendar.SetFilter(BaseCalendar."Base Calendar Code", GeneralOptions."Base Calendar");
        BaseCalendar.SetRange(BaseCalendar."Recurring System", BaseCalendar."recurring system"::"Annual Recurring");
        if BaseCalendar.Find('-') then begin
            repeat
                if ((Date2dmy(bcDate, 1) = BaseCalendar."Date Day") and (Date2dmy(bcDate, 2) = BaseCalendar."Date Month")) then begin
                    if BaseCalendar.Nonworking = true then
                        ItsNonWorking := true;
                end;
            until BaseCalendar.Next = 0;
        end;

        if ItsNonWorking = false then begin
            // Check if its a weekend
            dates.Reset;
            dates.SetRange(dates."Period Type", dates."period type"::Date);
            dates.SetRange(dates."Period Start", bcDate);
            if dates.Find('-') then begin
                //if date is a sunday
                if dates."Period Name" = 'Sunday' then begin
                    //check if Leave includes sunday
                    if ltype."Inclusive of Sunday" = false then ItsNonWorking := true;
                end else
                    if dates."Period Name" = 'Saturday' then begin
                        //check if Leave includes sato
                        if ltype."Inclusive of Saturday" = false then ItsNonWorking := true;
                    end;
            end;
        end;
    end;

    procedure DetermineIfIncludesNonWorking(var fLeaveCode: Code[10]): Boolean
    begin
        if LeaveTypes.Get(fLeaveCode) then begin
            if LeaveTypes."Inclusive of Non Working Days" = true then
                exit(true);
        end;
    end;

    procedure DetermineLeaveReturnDate(var fBeginDate: Date; var fDays: Decimal) fReturnDate: Date
    var
        ltype: Record "Leave Types";
    begin
        ltype.Reset;
        if ltype.Get("Leave Type") then begin
        end;
        varDaysApplied := fDays;
        fReturnDate := fBeginDate;
        repeat
            if DetermineIfIncludesNonWorking("Leave Type") = false then begin
                fReturnDate := CalcDate('1D', fReturnDate);
                if DetermineIfIsNonWorking(fReturnDate, ltype) then begin
                    varDaysApplied := varDaysApplied + 1;
                end else
                    varDaysApplied := varDaysApplied;
                varDaysApplied := varDaysApplied + 1
            end
            else begin
                fReturnDate := CalcDate('1D', fReturnDate);
                varDaysApplied := varDaysApplied - 1;
            end;
        until varDaysApplied = 0;
        exit(fReturnDate);
    end;

    procedure DeterminethisLeaveEndDate(var fDate: Date) fEndDate: Date
    var
        ltype: Record "Leave Types";
    begin
        if ltype.Get("Leave Type") then begin
        end;
        ReturnDateLoop := true;
        fEndDate := fDate;
        if fEndDate <> 0D then begin
            fEndDate := CalcDate('1D', fEndDate);
            while (ReturnDateLoop) do begin
                if DetermineIfIsNonWorking(fEndDate, ltype) then
                    fEndDate := CalcDate('-1D', fEndDate)
                else
                    ReturnDateLoop := false;
            end
        end;
        exit(fEndDate);
    end;

    procedure GetPayPeriod()
    begin
        objPeriod.Reset;
        objPeriod.SetRange(objPeriod.Closed, false);
        if objPeriod.Find('-') then
            PayPeriod := objPeriod."Date Opened";
    end;

    procedure CalcEndDate(SDate: Date; LDays: Integer) LEndDate: Date
    var
        EndLeave: Boolean;
        DayCount: Integer;
        ltype: Record "Leave Types";
    begin
        ltype.Reset;
        if ltype.Get("Leave Type") then begin
        end;
        SDate := SDate - 1;
        if not DetermineIfIsNonWorking(SDate, ltype) then begin
            DayCount := 1;
            SDate := SDate + 1;
        end
        else
            DayCount := 1;

        EndLeave := false;
        while EndLeave = false do begin
            if not DetermineIfIsNonWorking(SDate, ltype) then
                DayCount := DayCount + 1;
            SDate := SDate + 1;
            if DayCount > LDays then
                EndLeave := true;
        end;
        LEndDate := SDate - 1;

        while DetermineIfIsNonWorking(LEndDate, ltype) = true do begin
            LEndDate := LEndDate + 1;
        end;
    end;

    procedure CalcReturnDate(EndDate: Date) RDate: Date
    var
        ltype: Record "Leave Types";
    begin
        if ltype.Get("Leave Type") then begin
        end;
        /*  EndLeave:=FALSE;
         EndDate:=EndDate+1;
         LEndDate:=EndDate;
         CLEAR(DayCount);
         WHILE EndLeave=FALSE DO BEGIN
         IF NOT DetermineIfIsNonWorking(EndDate,ltype) THEN BEGIN
         DayCount:=DayCount+1;
         EndDate:=EndDate+1;

         END ELSE BEGIN
         EndLeave:=TRUE;
         END;
         END;
           */
        RDate := EndDate + 1;
        while DetermineIfIsNonWorking(RDate, ltype) = true do begin
            RDate := RDate + 1;
        end;

    end;

    procedure GetDate(var Applied_Dayes: Integer; var Start_Date: Date)
    begin
        /*clear(DaysCount);
        clear(NewDate);
         NewDate:=Start_Date;
        repeat
        DaysCount:=DaysCount+1;
        Last_is_WotkingDay:=false;
        
        until (() AND ()) */

    end;

    procedure ItsHolliday(var Start_Date: Date) holliday: Boolean
    var
        baseCal: Record "Base Calendar Change";
        days: Integer;
        Months: Integer;
        bool_Non_Working: Boolean;
    begin
        Clear(days);
        Clear(Months);
        Clear(bool_Non_Working);
        days := Date2dmy(Start_Date, 1);
        Months := Date2dmy(Start_Date, 2);
        baseCal.Reset;
        baseCal.SetFilter(baseCal."Recurring System", '=%1', baseCal."recurring system"::"Annual Recurring");
        if baseCal.Find('-') then begin
            repeat
                if ((Months = Date2dmy(baseCal.Date, 1)) and (days = Date2dmy(baseCal.Date, 1))) then bool_Non_Working := true;
            until ((((Months = Date2dmy(baseCal.Date, 1)) and (days = Date2dmy(baseCal.Date, 1)))) or (baseCal.Next = 0))
        end;
    end;

    procedure ItsSunday(var Start_Date: Date; var LeaveType: Integer)
    begin
    end;
}

