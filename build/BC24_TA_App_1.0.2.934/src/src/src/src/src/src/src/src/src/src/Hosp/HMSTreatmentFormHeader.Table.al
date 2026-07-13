Table 50583 "HMS Treatment Form Header"
{
    //  DrillDownPageID = UnknownPage70135154;
    //  LookupPageID = UnknownPage70135154;

    fields
    {
        field(1; "Treatment No."; Code[20])
        {

            trigger OnValidate()
            begin
                if "Treatment No." <> xRec."Treatment No." then begin
                    HMSSetup.Get;
                    NoSeriesMgt.TestManual(HMSSetup."Visit Nos");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Treatment Type"; Option)
        {
            OptionMembers = Outpatient,Inpatient;
        }
        field(3; "Treatment Date"; Date) { }
        field(4; "Treatment Time"; Time) { }
        field(5; "Doctor ID"; Code[20])
        {
            TableRelation = "HMS Setup Doctor"."Doctor ID";

            trigger OnValidate()
            begin
                if Doc.Get("Doctor ID") then begin
                    "Doctor's Name" := Doc."Doctors Name";
                end;
            end;
        }
        field(6; "Patient No."; Code[20])
        {
            TableRelation = "HMS Patient"."Patient No.";
        }
        field(7; "Student No."; Code[20]) { }
        field(8; "Employee No."; Code[20]) { }
        field(9; "Relative No."; Integer) { }
        field(10; "Doctor Notes"; Text[200]) { }
        field(11; Status; Option)
        {
            OptionMembers = New,Completed,Referred,Cancelled;
        }
        field(12; "Link No."; Code[20])
        {
            TableRelation = if ("Treatment Type" = const(Outpatient),
                                Direct = const(false)) "HMS Observation Form Header"."Observation No." where(Closed = const(true),
                                                                                                            Status = const(Pending),
                                                                                                            Completed = const(false))
            else
            if ("Treatment Type" = const(Inpatient)) "HMS Admission Form Header"."Admission No." where(Status = const(Admitted))
            else
            if ("Treatment Type" = const(Outpatient),
                                                                                                                     Direct = const(true)) "HMS Appointment Form Header"."Appointment No." where(Status = const(Dispatched),
                                                                                                                                                                                                "Dispatch To" = const(Doctor));
        }
        field(13; "Link Type"; Code[20]) { }
        field(14; "No. Series"; Code[20]) { }
        field(15; "Off Duty Days"; Decimal) { }
        field(16; "Light Duty Days"; Decimal) { }
        field(17; "Off Duty Comments"; Text[200]) { }
        field(18; "Off Duty"; Boolean) { }
        field(19; "Treatment Location"; Option)
        {
            OptionMembers = Main;
        }
        field(20; "Patient Type"; Option)
        {
            CalcFormula = lookup("HMS Patient"."Patient Type" where("Patient No." = field("Patient No.")));
            FieldClass = FlowField;
            OptionCaption = ' ,Corporate,Cash';
            OptionMembers = " ",Corporate,Cash;
        }
        field(21; Direct; Boolean) { }
        field(22; "Lab Status"; Option)
        {
            OptionCaption = ' ,Pending,Cleared';
            OptionMembers = " ",Pending,Cleared;
        }
        field(23; "Radiology Status"; Option)
        {
            OptionCaption = ' ,Pending,Cleared';
            OptionMembers = " ",Pending,Cleared;
        }
        field(24; "Pharmacy Status"; Option)
        {
            OptionCaption = ' ,Pending,Cleared';
            OptionMembers = " ",Pending,Cleared;
        }
        field(25; "Injection Status"; Option)
        {
            OptionCaption = ' ,Pending,Cleared';
            OptionMembers = " ",Pending,Cleared;
        }
        field(27; Surname; Text[100])
        {
            CalcFormula = lookup("HMS Patient".Surname where("Patient No." = field("Patient No.")));
            FieldClass = FlowField;
        }
        field(28; "Middle Name"; Text[30])
        {
            CalcFormula = lookup("HMS Patient"."Middle Name" where("Patient No." = field("Patient No.")));
            FieldClass = FlowField;
        }
        field(29; "Last Name"; Text[50])
        {
            CalcFormula = lookup("HMS Patient"."Last Name" where("Patient No." = field("Patient No.")));
            FieldClass = FlowField;
        }
        field(30; "ID Number"; Code[24])
        {
            CalcFormula = lookup("HMS Patient"."ID Number" where("Patient No." = field("Patient No.")));
            FieldClass = FlowField;
        }
        field(31; "Correspondence Address 1"; Text[100])
        {
            CalcFormula = lookup("HMS Patient"."Correspondence Address 1" where("Patient No." = field("Patient No.")));
            FieldClass = FlowField;
        }
        field(32; "Telephone No. 1"; Code[100])
        {
            CalcFormula = lookup("HMS Patient"."Telephone No. 1" where("Patient No." = field("Patient No.")));
            FieldClass = FlowField;
        }
        field(33; Email; Text[100])
        {
            CalcFormula = lookup("HMS Patient".Email where("Patient No." = field("Patient No.")));
            FieldClass = FlowField;
        }
        field(34; "Patient Ref. No."; Code[20])
        {
            CalcFormula = lookup("HMS Patient"."Patient Ref. No." where("Patient No." = field("Patient No.")));
            FieldClass = FlowField;
        }
        field(35; "Patient Name"; Code[100])
        {
            CalcFormula = lookup("HMS Patient"."Search Name" where("Patient No." = field("Patient No.")));
            FieldClass = FlowField;
        }
        field(36; "Settlement Type"; Option)
        {
            CalcFormula = lookup("HMS Appointment Form Header"."Settlement Type" where("Appointment No." = field("Link No.")));
            FieldClass = FlowField;
            OptionCaption = ' ,Cash,Insurance,Credit';
            OptionMembers = " ",Cash,Insurance,Credit;
        }
        field(37; "Membership No"; Code[20])
        {
            CalcFormula = lookup("HMS Patient"."Membership No" where("Patient No." = field("Patient No.")));
            FieldClass = FlowField;
        }
        field(38; "Insurance Name"; Text[100])
        {
            CalcFormula = lookup("HMS Patient"."Insurance Name" where("Patient No." = field("Patient No.")));
            FieldClass = FlowField;
        }
        field(39; "Adm No."; Code[20])
        {
            CalcFormula = lookup("HMS Patient"."Adm No." where("Patient No." = field("Patient No.")));
            FieldClass = FlowField;
        }
        field(40; "Lk No"; Code[20])
        {
            CalcFormula = lookup("HMS Appointment Form Header"."Appointment No." where("Patient No." = field("Patient No."),
                                                                                        "Appointment Date" = field("Treatment Date")));
            FieldClass = FlowField;
        }
        field(41; "Triage Notes"; Text[200]) { }
        field(42; "Next Appointment Date"; Date) { }
        field(43; "Sick Off Start Date"; Date) { }
        field(44; "Sick Off End Date"; Date) { }
        field(45; InPatient; Boolean)
        {
            TableRelation = "HMS Patient".Inpatient where("Patient No." = field("Patient No."));
        }
        field(46; "Status Remarks"; Text[30]) { }
        field(47; Clinic; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',Medical,Optical,Dental,Ortho,Neural,Gynaecology';
            OptionMembers = ,Medical,Optical,Dental,Ortho,Neural,Gynaecology;
        }
        field(48; "Doctor's Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(49; "Waiting At"; Option)
        {
            CalcFormula = lookup("HMS Appointment Form Header"."Waiting At" where("Appointment No." = field("Link No.")));
            FieldClass = FlowField;
            OptionCaption = ',Registration,Triage,Doctor,Lab,Pharmacy,Imaging,Lab Results';
            OptionMembers = ,Registration,Triage,Doctor,Lab,Pharmacy,Imaging,"Lab Results";
        }
        field(50; "Lab No"; Code[10])
        {
            CalcFormula = lookup("HMS Laboratory Form Header"."Laboratory No." where("Link No." = field("Treatment No.")));
            FieldClass = FlowField;
        }
        field(51; Branch; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('BRANCH'));
        }
    }

    keys
    {
        key(Key1; "Treatment No.")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        if "Treatment No." = '' then begin
            HMSSetup.Get;
            HMSSetup.TestField("Visit Nos");
            "Treatment No.":=NoSeriesMgt.GetNextNo(HMSSetup."Visit Nos", 0D,true);
        end;
    end;

    var
        HMSSetup: Record "HMS Setup";
        NoSeriesMgt: Codeunit "No. Series";
        Doc: Record "HMS Setup Doctor";
}

