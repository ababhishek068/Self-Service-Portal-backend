Table 50863 "FLT-Transport Requisition"
{
    DrillDownPageID = "FLT Transport Requisition List";
    LookupPageID = "FLT Transport Requisition List";

    fields
    {
        field(1; "Transport Requisition No"; Code[20]) { }
        field(2; Commencement; Text[30]) { }
        field(3; Destination; Text[30]) { }
        field(4; "Vehicle Allocated"; Code[20])
        {
            TableRelation = "FLT-Vehicle Header"."Registration No.";
        }
        field(5; "Driver Allocated"; Code[20])
        {
            TableRelation = "Flt Driver".Driver;

            trigger OnValidate()
            var
                DriverRec: record "Flt Driver";
                SendMail: Codeunit email;
                SMTPMail: Codeunit "Email Message";
                FltSetup: Record "FLT-Fleet Mgt Setup";
            begin
                FltSetup.get;
                if HrEmployee.Get("Driver Allocated") then begin
                    "Driver Name" := HrEmployee."First Name" + ' ' + HrEmployee."Middle Name" + ' ' + HrEmployee."Last Name";
                end;
                "Authorized  By" := UserId;

                userset.Reset;
                userset.SetRange(userset."User ID", UserId);
                if userset.Find('-') then begin
                    Emp.Reset;
                    Emp.SetRange(Emp."No.", userset."Employee No.");
                    if Emp.Find('-') then begin
                        "TO Name" := Emp."First Name" + ' ' + Emp."Middle Name" + ' ' + Emp."Last Name";
                    end;
                end;
                if DriverRec.get("Driver Allocated") then begin
                    "Fuel Card No" := DriverRec."Fuel Card No";
                    if DriverRec."Next License Renewal" <> 0D then begin
                        if (DriverRec."Next License Renewal" - today < 30) then begin
                            FltSetup.TestField("Notification Email");
                            SMTPMail.Create(FltSetup."Notification Email", 'Driver License Renewal Notice'
                            , 'The driver license for ' + DriverRec."Driver Name" + ' will be expiring in the next ' + format(DriverRec."Next License Renewal" - today) + ' days');
                            SendMail.Send(SMTPMail);
                        end;
                    end;
                end;
            end;
        }
        field(6; "Requested By"; Code[20]) { }
        field(7; "Date of Request"; Date) { }
        field(8; "Vehicle Allocated by"; Code[20]) { }
        field(9; "Opening Odometer Reading"; Decimal)
        {
            DecimalPlaces = 0 : 0;
            trigger OnValidate()
            var
                SendMail: codeunit email;
                SMTPMail: Codeunit "Email Message";
                FltSetup: record "FLT-Fleet Mgt Setup";
                Vihicle: record "FLT-Vehicle Header";
            begin
                TestField("Vehicle Allocated");
                FltSetup.get;
                FltSetup.TestField("Notification Email");
                Vihicle.get("Vehicle Allocated");
                if (Vihicle."Next Service Kilometers" - "Opening Odometer Reading" > 5000) then begin

                    SMTPMail.Create(FltSetup."Notification Email", 'Vehicle Service Notification',
                    'Vehicle Registration No. ' + "Vehicle Allocated" + ' will be due for service in the next ' + format(Vihicle."Next Service Kilometers" - "Opening Odometer Reading"));
                    SendMail.send(SMTPMail);
                end;
            end;
        }
        field(10; Status; Option)
        {
            OptionMembers = Open,"Pending Approval",Approved,Closed;

            trigger OnValidate()
            var
                HREmp: Record "HR-Employee";
                msg: Text;
                WebPortal: Codeunit HRWebportal;
            begin
                if Status = Status::Approved then begin
                    fltman2.Reset;
                    fltman2.SetRange(fltman2."Finance Approver", true);
                    if fltman2.Find('-') then begin
                        "Checked By" := fltman2.UserID;
                        "Checked Designation" := 'FIN OFFICER';
                    end;
                    if HREmp.Get("Empoyee No") then begin
                        if HREmp."Company E-Mail" <> '' then begin
                            msg := '';
                            msg := 'Dear ' + HREmp."First Name" + ' ' + HREmp."Middle Name" + ' ' + HREmp."Last Name" + ',<br /><br />';
                            msg := msg + 'Your transport requisition has been approved.<br /><br />';
                            msg := msg + '<b>Assigned Vehicle:</b><i>' + "Vehicle Allocated" + '</i>';
                            msg := msg + '<b>Assigned Driver:</b><i>' + "Driver Allocated" + '-' + "Driver Name" + '</i>';
                            msg := msg + '<b>Date of Trip:</b><i>' + Format("Date of Trip") + '</i>';
                            msg := msg + '<b>From :</b><i>' + Commencement + '</i>';
                            msg := msg + '<b>Destination:</b><i>' + Designation + '</i>';
                            WebPortal.SendEmail(HREmp."Company E-Mail", 'APPROVED TRANPORT REQUISITION : ' + "Transport Requisition No" + ' (Transport Number)', msg);
                        end;
                    end;
                end;
            end;
        }
        field(13; "Date of Trip"; Date) {

            trigger OnValidate()
            begin
                TestField("Vehicle Type");
                if ("Vehicle Type"="Vehicle Type"::City) then  begin
                    if(("Date of Trip"-today)<2) then begin
                        if Urgent=false then begin
                            Error('For city trips booked less than 2 days, you must select urgent, request will be forwarded to director for approval ');
                        end;
                        
                    end;

                end else if ("Vehicle Type"="Vehicle Type"::Trip) then begin
                    if (("Date of Trip"-Today)<7) then begin
                        Error('You cannot book for less than 7 days in advance');
                    end;
                end;
            end;
         }
        field(14; "Purpose of Trip"; Text[250]) { }
        field(60; "No. Series"; Code[20])
        {
            Description = 'Stores the number series in the database';
        }
        field(61; Comments; Text[250]) { }
        field(62; Department; Code[20]) { }
        field(63; "Driver Name"; Text[100]) { }
        field(64; "Responsibility Center"; Code[30])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center BR";

            trigger OnValidate()
            begin

                TestField(Status, Status::Open);
                if not UserMgt.CheckRespCenter(1, Department) then
                    Error(
                      Text001,
                      RespCenter.TableCaption, UserMgt.GetPurchasesFilter);
            end;
        }
        field(65; "Loaded to WorkTicket"; Boolean) { }
        field(66; "Time out"; Time) { }
        field(67; "Time In"; Time) { }
        field(68; "Journey Route"; Text[250]) { }
        field(69; "Time Requested"; Time) { }
        field(70; "Closing Odometer Reading"; Decimal)
        {
            DecimalPlaces = 0 : 0;
        }
        field(71; "Work Ticket No"; Code[20]) { }
        field(72; "No of Days Requested"; Integer) { }
        field(73; "Authorized  By"; Text[30]) { }
        field(74; Position; Text[30]) { }
        field(50000; Name; Code[200]) { }
        field(50001; Signature; Blob) { }
        field(50002; "Time of trip"; Time) { }
        field(50003; "Supervosor Recommendations"; Text[250]) { }
        field(50004; "Date Requisition Received"; Date) { }
        field(50005; "Time Requisition Received"; Time) { }
        field(50006; "Transport Officer Remarks"; Text[250])
        {

            trigger OnValidate()
            begin
                "TO ID" := UserId;
                "TO Approval Date" := Today;
                userset.Reset;
                userset.SetRange(userset."User ID", UserId);
                if userset.Find('-') then begin
                    empno.Reset;
                    empno.SetRange(empno."No.", userset."Employee No.");
                    if empno.Find('-') then begin
                        "TO Name" := Emp."First Name" + ' ' + Emp."Middle Name" + ' ' + Emp."Last Name";

                    end;
                end;
                Modify;
            end;
        }
        field(50007; "Checked By"; Code[50]) { }
        field(50008; "Checked Designation"; Code[100]) { }
        field(50009; "P/NO"; Code[20]) { }
        field(50010; Designation; Code[30]) { }
        field(50011; "No Of Passangers"; Integer)
        {
            CalcFormula = count("FLT-Travel Requisition Staff" where("Req No" = field("Transport Requisition No")));
            FieldClass = FlowField;
        }
        field(50012; "HOD Recommendations"; Text[100])
        {

            trigger OnValidate()
            begin
                "HOD ID" := UserId;
                "Checked By" := UserId;

                userset.Reset;
                userset.SetRange(userset."User ID", UserId);
                if userset.Find('-') then begin
                    empno.Reset;
                    empno.SetRange(empno."No.", userset."Employee No.");
                    if empno.Find('-') then begin
                        "HOD Name" := Emp."First Name" + ' ' + Emp."Middle Name" + ' ' + Emp."Last Name";
                        "Checked Designation" := empno.Initials;
                    end;
                end;
                Modify;
            end;
        }
        field(50013; Make; Code[20])
        {
            CalcFormula = lookup("FLT-Vehicle Header".Make where("Registration No." = field("Vehicle Allocated")));
            FieldClass = FlowField;
        }
        field(50014; Model; Code[20])
        {
            CalcFormula = lookup("FLT-Vehicle Header".Model where("Registration No." = field("Vehicle Allocated")));
            FieldClass = FlowField;
        }
        field(50015; "Finance Officer Comments"; Text[250])
        {

            trigger OnValidate()
            begin
                "FO ID" := UserId;
                fltman5.Reset;
                fltman5.SetRange(fltman5.UserID, UserId);
                if fltman5.Find('-') then begin
                    if fltman5."Finance Approver" = true then begin
                        userset.Reset;
                        userset.SetRange(userset."User ID", UserId);
                        if userset.Find('-') then begin
                            empno.Reset;
                            empno.SetRange(empno."No.", userset."Employee No.");
                            if empno.Find('-') then begin
                                "FO Name" := Emp."First Name" + ' ' + Emp."Middle Name" + ' ' + Emp."Last Name";
                            end;
                        end;
                    end;
                end;

                Modify;
            end;
        }
        field(50016; "TO Name"; Text[150]) { }
        field(50017; "FO Name"; Text[150]) { }
        field(50018; "HOD Name"; Text[150]) { }
        field(50019; "HOD ID"; Code[20]) { }
        field(50020; "Checked By Name"; Code[150]) { }
        field(50021; "FO ID"; Code[20]) { }
        field(50022; "TO ID"; Code[20]) { }
        field(50023; "TO Approval Date"; Date) { }
        field(50024; "Opening ODO"; Decimal) { }
        field(50025; "Clossing ODO"; Decimal) { }
        field(50026; "Driver Allocated2"; Code[20])
        {
            TableRelation = "Flt Driver";

            trigger OnValidate()
            begin
                if HrEmployee.Get("Driver Allocated") then begin
                    "Driver Name" := HrEmployee."First Name" + ' ' + HrEmployee."Middle Name" + ' ' + HrEmployee."Last Name";
                end;
                "Authorized  By" := UserId;

                userset.Reset;
                userset.SetRange(userset."User ID", UserId);
                if userset.Find('-') then begin
                    Emp.Reset;
                    Emp.SetRange(Emp."No.", userset."Employee No.");
                    if Emp.Find('-') then begin
                        "TO Name" := Emp."First Name" + ' ' + Emp."Middle Name" + ' ' + Emp."Last Name";
                        ;
                    end;
                end;
                Modify;
            end;
        }
        field(50027; "Driver Allocated3"; Code[20])
        {
            TableRelation = "Flt Driver";

            trigger OnValidate()
            begin
                if HrEmployee.Get("Driver Allocated") then begin
                    "Driver Name" := HrEmployee."First Name" + ' ' + HrEmployee."Middle Name" + ' ' + HrEmployee."Last Name";
                end;
                "Authorized  By" := UserId;

                userset.Reset;
                userset.SetRange(userset."User ID", UserId);
                if userset.Find('-') then begin
                    Emp.Reset;
                    Emp.SetRange(Emp."No.", userset."Employee No.");
                    if Emp.Find('-') then begin
                        "TO Name" := Emp."First Name" + ' ' + Emp."Middle Name" + ' ' + Emp."Last Name";
                        ;
                    end;
                end;
                Modify;
            end;
        }
        field(50028; "Empoyee No"; Code[20])
        {
            TableRelation = "HR-Employee"."No.";
        }
        field(50029; "Is HOD"; Boolean) { }
        field(50030; "Travel Memo No"; Code[20])
        {
            TableRelation = "FLT-Safari Notice"."Safari No.";
        }
        field(50031; "No of External Passengers"; Integer) { }
        field(50032; "Vehicle Type"; Option)
        {
            OptionMembers = ,City,Trip;
            OptionCaption = ',City, Field Trip';
        }
        field(50033; "Fuel Card No"; Code[20])
        {
            TableRelation = "Fuel Card Setup"."Card No";
        }
        field(50034; "External Vehicle"; Text[50]) { }
        field(50036; "Vehicle Registration"; Text[30])
        {
            CalcFormula = lookup("FLT-Vehicle Header"."Serial No." where("Registration No." = field("Vehicle Allocated")));
            FieldClass = FlowField;
        }
        field(50037; "External Driver"; Text[50]) { }
         field(50038; Urgent; Boolean) { }
         field(50039; "Litres Refilled"; Decimal) { }
         field(50040;"Total Price";Decimal){}
    }

    keys
    {
        key(Key1; "Transport Requisition No")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnInsert()
    begin

        if "Transport Requisition No" = '' then begin
            FltMgtSetup.Get;
            FltMgtSetup.TestField("Transport Req No");
            "Transport Requisition No" := NoSeriesMgt.GetNextNo(FltMgtSetup."Transport Req No", 0D, true);
        end;

        userset.Reset;
        userset.SetRange(userset."User ID", UserId);
        if userset.Find('-') then begin
            empno.Reset;
            empno.SetRange(empno."No.", userset."Employee No.");
            if empno.Find('-') then begin
                userset.CalcFields(userset."User Signature");
                Signature := userset."User Signature";
                Name := empno."First Name" + ' ' + empno."Middle Name" + ' ' + empno."Last Name";
                "P/NO" := empno."No.";
                Designation := empno.Initials;
            end;// ELSE ERROR('Please ensure that you have been setup by the System Administrator.')
        end;
    end;

    trigger OnModify()
    begin
        // if (Status = Status::Approved) or (Status = Status::Approved) then
        //     Error(Text0001);

        if xRec."Vehicle Allocated" <> "Vehicle Allocated" then begin
            fltman5.Reset;
            fltman5.SetRange(fltman5."Transport Mger Approver", true);
            if fltman5.Find('-') then begin
                "Authorized  By" := fltman5.UserID;
                userset5.Reset;
                userset5.SetRange(userset5."User ID", fltman5.UserID);
                if userset5.Find('-') then begin
                    Emp1.Reset;
                    Emp1.SetRange(Emp1."No.", userset5."User ID");
                    if Emp1.Find('-') then begin
                        Position := Emp1.Initials;
                    end;
                end;
            end;
            Modify;
        end;
    end;

    var
        FltMgtSetup: Record "FLT-Fleet Mgt Setup";
        NoSeriesMgt: Codeunit "No. Series";
        Text0001: label 'You cannot modify an Approved or Closed Record';
        HrEmployee: Record "HR-Employee";
        UserMgt: Codeunit "User Setup Management";
        Text001: label 'Your identification is set up to process from %1 %2 only.';
        RespCenter: Record "Responsibility Center";
        userset: Record "User Setup";
        empno: Record "HR-Employee";
        fltman2: Record "Flt Mgt Approval Setups";
        Emp: Record "HR-Employee";
        fltman5: Record "Flt Mgt Approval Setups";
        Emp1: Record "HR-Employee";
        userset5: Record "User Setup";
}

