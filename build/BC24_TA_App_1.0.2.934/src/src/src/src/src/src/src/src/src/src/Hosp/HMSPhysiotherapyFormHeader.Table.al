Table 50560 "HMS Physiotherapy Form Header"
{
    //  LookupPageID = UnknownPage70135085;

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
        field(6; "Observation Remarks"; Text[200]) { }
        field(7; "Patient No."; Code[20])
        {
            TableRelation = "HMS Patient"."Patient No.";

            trigger OnValidate()
            begin
                Patient.Reset;
                Patient.Get("Patient No.");
                "Student No." := Patient."Student No.";
                "Employee No." := Patient."Employee No.";
                "Relative No." := Patient."Relative No.";
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
    }

    keys
    {
        key(Key1; "Observation No.")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

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

    end;

    var
        Patient: Record "HMS Patient";
}

