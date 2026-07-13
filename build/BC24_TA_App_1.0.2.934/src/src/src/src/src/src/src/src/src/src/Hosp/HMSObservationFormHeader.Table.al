Table 50580 "HMS Observation Form Header"
{
    // DrillDownPageID = UnknownPage70135139;
    // LookupPageID = UnknownPage70135139;

    fields
    {
        field(1; "Observation No."; Code[20])
        {

            trigger OnValidate()
            begin
                /*
                IF "Observation No." <> xRec."Observation No." THEN BEGIN
                  HMSSetup.GET;
                  NoSeriesMgt.TestManual(HMSSetup."Observation Nos");
                  "No. Series" := '';
                END;
                 */

            end;
        }
        field(2; "Observation Type"; Option)
        {
            OptionMembers = Appointment,Visit,Admission;
        }
        field(3; "Observation Date"; Date) { }
        field(4; "Observation Time"; Time) { }
        field(5; "Observation User ID"; Code[20])
        {
            TableRelation = User;
        }
        field(6; "Observation Remarks"; Text[250]) { }
        field(7; "Patient No."; Code[20])
        {
            TableRelation = "HMS Patient"."Patient No.";

            trigger OnValidate()
            begin
                Patient.Reset;
                Patient.Get("Patient No.");

                Names := Patient.Surname + ' ' + Patient."Middle Name" + ' ' + Patient."Last Name";
            end;
        }
        field(8; "Student No."; Code[20])
        {
            TableRelation = Customer."No.";
        }
        field(9; "Employee No."; Code[20])
        {
            TableRelation = Employee."No.";
        }
        field(10; "Relative No."; Integer)
        {
            TableRelation = "Employee Relative"."Line No." where("Employee No." = field("Employee No."));
        }
        field(11; "Link Type"; Code[20]) { }
        field(12; "Link No."; Code[20])
        {
            TableRelation = if ("Observation Type" = const(Appointment)) "HMS Appointment Form Header"."Appointment No." where(Status = const(Dispatched),
                                                                                                                              "Dispatch To" = const(Observation))
            else
            if ("Observation Type" = const(Visit)) "HMS Treatment Form Header"."Treatment No." where(Status = const(New))
            else
            if ("Observation Type" = const(Admission)) "HMS Admission Form Header"."Admission No." where(Status = const(Admitted));
        }
        field(13; "No. Series"; Code[20]) { }
        field(14; Closed; Boolean) { }
        field(15; Status; Option)
        {
            OptionMembers = New,Pending,Closed;
        }
        field(16; Completed; Boolean) { }
        field(17; "Patient Name"; Code[100])
        {
            CalcFormula = lookup("HMS Patient".Surname where("Patient No." = field("Patient No.")));
            FieldClass = FlowField;
        }
        field(18; "Observation Remarks2"; Text[250]) { }
        field(19; Doctor; Code[20])
        {
            TableRelation = "HMS Setup Doctor"."Doctor ID";
        }
        field(20; Names; Text[150])
        {
            CalcFormula = lookup("HMS Patient"."Middle Name" where("Patient No." = field("Patient No.")));
            FieldClass = FlowField;

            trigger OnLookup()
            begin
                Patient.Get("Patient No.");
                Names := Patient.Surname + ' ' + Patient."Middle Name" + ' ' + Patient."Last Name";
            end;

            trigger OnValidate()
            begin
                Patient.Get("Patient No.");
                Names := Patient.Surname + ' ' + Patient."Middle Name" + ' ' + Patient."Last Name";
            end;
        }
        field(45; InPatient; Boolean)
        {
            TableRelation = "HMS Patient".Inpatient where("Patient No." = field("Patient No."));
        }
        field(46; "Status Remarks"; Text[30]) { }
        field(47; Physio; Boolean) { }
        field(48; "Queued Doc"; Code[30])
        {
            CalcFormula = lookup("HMS Appointment Form Header".Doctor where("Appointment No." = field("Link No.")));
            FieldClass = FlowField;
        }
        field(49; "Treatment No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50; "Doctor Name"; Text[50])
        {
            CalcFormula = lookup("HMS Setup Doctor"."Doctors Name" where("Doctor ID" = field(Doctor)));
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
        key(Key1; "Observation No.")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnDelete()
    begin
        Patient.Get("Patient No.");
        Names := Patient.Surname + ' ' + Patient."Middle Name" + ' ' + Patient."Last Name";
    end;

    trigger OnInsert()
    begin
        /*
        IF "Observation No." = '' THEN BEGIN
          HMSSetup.GET;
          HMSSetup.TESTFIELD("Observation Nos");
          NoSeriesMgt.GetNextNo(HMSSetup."Observation Nos",xRec."No. Series",0D,"Observation No.","No. Series");
        END;
        */
        //"Observation User ID":=USERID;
        Patient.Get("Patient No.");
        Names := Patient.Surname + ' ' + Patient."Middle Name" + ' ' + Patient."Last Name";

    end;

    trigger OnModify()
    begin
        Patient.Get("Patient No.");
        Names := Patient.Surname + ' ' + Patient."Middle Name" + ' ' + Patient."Last Name";
    end;

    trigger OnRename()
    begin
        Patient.Get("Patient No.");
        Names := Patient.Surname + ' ' + Patient."Middle Name" + ' ' + Patient."Last Name";
    end;

    var
        Patient: Record "HMS Patient";
}

