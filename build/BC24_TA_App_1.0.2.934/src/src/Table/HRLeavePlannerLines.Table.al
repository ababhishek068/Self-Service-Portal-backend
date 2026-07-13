table 50306 "HR Leave Planner Lines"
{

    fields
    {
        field(1; "Application Code"; Code[20]) { }
        field(3; "Leave Type"; Code[20])
        {
            TableRelation = "Leave Types".Code;

            trigger OnValidate()
            begin
                /*
                //RESET;
                //SETRANGE("Employee No",LeaveHeader."Employee No");
                IF LeaveHeader.FIND('-') THEN
                "Employee No":= LeaveHeader."Employee No";
                
                 {
                HRLeaveTypes.GET("Leave Type");
                HREmp.GET("Employee No");
                IF HREmp.Gender=HRLeaveTypes.Gender THEN
                EXIT
                ELSE
                ERROR('This leave type is restricted to the '+ FORMAT(HRLeaveTypes.Gender) +' gender')
                }
                */

            end;
        }
        field(4; "Days Applied"; Decimal)
        {
            DecimalPlaces = 2 : 2;

            trigger OnValidate()
            begin


                //TESTFIELD("Leave Type");
                //CALCULATE THE END DATE AND RETURN DATE
                begin
                    if ("Days Applied" <> 0) and ("Start Date" <> 0D) then begin
                        "Return Date" := DetermineLeaveReturnDate("Start Date", "Days Applied");
                        "End Date" := DeterminethisLeaveEndDate("Return Date");
                        Modify;
                    end;
                end;
            end;
        }
        field(5; "Start Date"; Date)
        {

            trigger OnValidate()
            begin

                if "Start Date" = 0D then begin
                    "Return Date" := 0D;
                    exit;
                end else begin
                    if DetermineIfIsNonWorking("Start Date") = true then begin
                        ERROR('Start date must be a working day');
                    end;
                    VALIDATE("Days Applied");
                end;
            end;
        }
        field(6; "Return Date"; Date)
        {
            Caption = 'Return Date';
            Editable = false;
        }
        field(7; "Application Date"; Date) { }
        field(15; "Applicant Comments"; Text[250]) { }
        field(17; "No series"; Code[30]) { }
        field(28; Selected; Boolean) { }
        field(31; "Current Balance"; Decimal) { }
        field(3900; "End Date"; Date)
        {
            Editable = true;
        }
        field(3901; "Total Taken"; Decimal)
        {
            DecimalPlaces = 2 : 2;
        }
        field(3902; "Line No."; Integer)
        {
            AutoIncrement = true;
        }
        field(3921; "E-mail Address"; Date)
        {
            Editable = false;
        }
        field(3924; "Entry No"; Integer) { }
        field(3929; "Start Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(3936; "Cell Phone Number"; Text[50]) { }
        field(3937; "Request Leave Allowance"; Boolean) { }
        field(3939; Picture; BLOB) { }
        field(3940; Names; Text[100]) { }
        field(3942; "Leave Allowance Entittlement"; Boolean) { }
        field(3943; "Leave Allowance Amount"; Decimal) { }
        field(3945; "Details of Examination"; Text[200]) { }
        field(3947; "Date of Exam"; Date) { }
        field(3949; Reliever; Code[50])
        {
            TableRelation = "HR-Employee"."No.";

            trigger OnValidate()
            begin
                //DISPLAY RELEIVERS NAME
                if HREmp.GET(Reliever) then
                    "Reliever Name" := HREmp."First Name" + ' ' + HREmp."Middle Name" + ' ' + HREmp."Last Name";
            end;
        }
        field(3950; "Reliever Name"; Text[100]) { }
        field(3952; Description; Text[30]) { }
        field(3956; "Number of Previous Attempts"; Text[200]) { }
        field(3961; "Employee No"; Code[20]) { }
        field(3969; "Responsibility Center"; Code[10])
        {
            TableRelation = "Responsibility Center BR".Code;
        }
        field(3970; "Approved days"; Integer)
        {

            trigger OnValidate()
            begin
                /* IF "Approved days">"Days Applied" THEN
                 ERROR(TEXT001);
                */

            end;
        }
        field(3971; "Annual Leave Account"; Decimal) { }
        field(3972; "Compassionate Leave Acc."; Decimal) { }
        field(3973; "Maternity Leave Acc."; Decimal) { }
        field(3974; "Paternity Leave Acc."; Decimal) { }
        field(3975; "Sick Leave Acc."; Decimal) { }
        field(3976; "Study Leave Acc"; Decimal) { }
        field(3977; OffDays; Decimal) { }
    }

    keys
    {
        key(Key1; "Application Code", "Line No.") { }
    }

    fieldgroups { }

    var
        HREmp: Record "HR-Employee";
        HRLeaveTypes: Record "HR Leave Types";

    procedure DetermineLeaveReturnDate(var fBeginDate: Date; var fDays: Decimal) fReturnDate: Date
    var
        varDaysApplied: Integer;
    begin
        varDaysApplied := fDays;
        fReturnDate := fBeginDate;
        repeat
            if DetermineIfIncludesNonWorking("Leave Type") = false then begin
                fReturnDate := CalcDate('1D', fReturnDate);
                if DetermineIfIsNonWorking(fReturnDate) then
                    varDaysApplied := varDaysApplied + 1
                else
                    varDaysApplied := varDaysApplied;
                varDaysApplied := varDaysApplied - 1
            end
            else begin
                fReturnDate := CalcDate('1D', fReturnDate);
                varDaysApplied := varDaysApplied - 1;
            end;
        until varDaysApplied = 0;
        exit(fReturnDate);
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
            fEndDate := CalcDate('-1D', fEndDate);
            while (ReturnDateLoop) do begin
                if DetermineIfIsNonWorking(fEndDate) then
                    fEndDate := CalcDate('-1D', fEndDate)
                else
                    ReturnDateLoop := false;
            end
        end;
        exit(fEndDate);
    end;

    procedure NotifyApplicant()
    begin
        /*HREmp.GET("Employee No");
        HREmp.TESTFIELD(HREmp."Company E-Mail");
        
        //GET E-MAIL PARAMETERS FOR GENERAL E-MAILS
        HREmailParameters.RESET;
        HREmailParameters.SETRANGE(HREmailParameters."Associate With",HREmailParameters."Associate With"::"Training Invitation");
        IF HREmailParameters.FIND('-') THEN
        BEGIN
        
        
             HREmp.TESTFIELD(HREmp."Company E-Mail");
             SMTP.CreateMessage(HREmailParameters."Sender Name",HREmailParameters."Sender Address",HREmp."Company E-Mail",
             HREmailParameters.Subject,'Dear'+' '+ HREmp."First Name" +' '+
             HREmailParameters.Body+' '+"Application Code"+' '+ HREmailParameters."Body 2",TRUE);
             SMTP.Send();
        
        
        MESSAGE('Leave applicant has been notified successfully');
        END;
        */

    end;
}

