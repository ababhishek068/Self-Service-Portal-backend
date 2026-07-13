Table 50591 "HMS Laboratory Form Header"
{
    // DrillDownPageID = UnknownPage70135171;
    // LookupPageID = UnknownPage70135171;

    fields
    {
        field(1; "Laboratory No."; Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            begin
                if "Laboratory No." <> xRec."Laboratory No." then begin
                    HMSSetup.Get;
                    NoSeriesMgt.TestManual(HMSSetup."Lab Test Request Nos");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Laboratory Date"; Date) { }
        field(3; "Laboratory Time"; Time) { }
        field(4; "Patient No."; Code[20]) { }
        field(5; "Student No."; Code[20]) { }
        field(6; "Employee No."; Code[20]) { }
        field(7; "Relative No."; Integer) { }
        field(8; "Scheduled Date"; Date) { }
        field(9; "Scheduled Time"; Time) { }
        field(10; "Supervisor ID"; Code[20]) { }
        field(11; Status; Option)
        {
            OptionMembers = New,Forwarded,Cancelled,Completed;
        }
        field(12; "Link Type"; Code[20]) { }
        field(13; "Link No."; Code[20]) { }
        field(14; Remarks; Text[100]) { }
        field(15; "Request Area"; Option)
        {
            OptionMembers = Doctor,Admission;
        }
        field(16; "No. Series"; Code[20]) { }
        field(17; "Patient Type"; Option)
        {
            CalcFormula = lookup("HMS Patient"."Patient Type" where("Patient No." = field("Patient No.")));
            FieldClass = FlowField;
            OptionCaption = ' ,Others,Student,Employee,Dependant,High School Student,High School Staff,Primary School Student,Primary School Staff,Roses Staff,Relative';
            OptionMembers = " ",Others,Student,Employee,Dependant,"High School Student","High School Staff","Primary School Student","Primary School Staff","Roses Staff",Relative;
        }
        field(18; "Lab. Reference No."; Code[20]) { }
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
        field(30; "ID Number"; Code[20])
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
        field(35; "Settlement Type"; Option)
        {
            CalcFormula = lookup("HMS Patient"."Patient Type" where("Patient No." = field("Patient No.")));
            FieldClass = FlowField;
            OptionCaption = ' ,Corporate,Cash';
            OptionMembers = " ",Corporate,Cash;
        }
        field(36; "Cash Sale"; Boolean) { }
        field(37; "ADM No."; Code[20])
        {
            CalcFormula = lookup("HMS Patient"."Adm No." where("Patient No." = field("Patient No.")));
            FieldClass = FlowField;
        }
        field(38; "Memeber No"; Code[30])
        {
            CalcFormula = lookup("HMS Patient"."Membership No" where("Patient No." = field("Patient No.")));
            FieldClass = FlowField;
        }
        field(39; "Receipt Count"; Integer)
        {
            CalcFormula = count("Receipts Header" where("Laboratory No" = field("Laboratory No.")));
            FieldClass = FlowField;
        }
        field(40; "Open Charges"; Decimal)
        {
            CalcFormula = sum("HMS Patient Charges".Amount where("Patient No." = field("Patient No."),
                                                                  Posted = const(false)));
            FieldClass = FlowField;
        }
        field(41; "Walk-In"; Boolean) { }
        field(42; "Doctor ID"; Code[50]) { }
        field(43; "Completion Date"; Date) { }
        field(44; "Completion Time"; Time) { }
        field(45; "Insurance Name"; Text[100])
        {
            CalcFormula = lookup("HMS Patient"."Insurance Name" where("Patient No." = field("Patient No.")));
            FieldClass = FlowField;
        }
        field(46; "Appointment No"; Code[30])
        {
            CalcFormula = lookup("HMS Treatment Form Header"."Link No." where("Treatment No." = field("Link No.")));
            FieldClass = FlowField;
        }
        field(47; "Waiting At"; Option)
        {
            CalcFormula = lookup("HMS Appointment Form Header"."Waiting At" where("Appointment No." = field("Appointment No")));
            FieldClass = FlowField;
            OptionCaption = ',Registration,Triage,Doctor,Lab,Pharmacy,Imaging,Lab Results';
            OptionMembers = ,Registration,Triage,Doctor,Lab,Pharmacy,Imaging,"Lab Results";
        }
        field(48; "Patient Names"; Text[200])
        {
            CalcFormula = lookup("HMS Patient"."Search Name" where("Patient No." = field("Patient No.")));
            FieldClass = FlowField;
        }
        field(49; "Doctor Names"; Text[100])
        {
            CalcFormula = lookup("HMS Setup Doctor"."Doctors Name" where("Doctor ID" = field("Doctor ID")));
            FieldClass = FlowField;
        }
        field(50; Age; Integer)
        {
            CalcFormula = lookup("HMS Patient"."Age in Years" where("Patient No." = field("Patient No.")));
            FieldClass = FlowField;
        }
        field(51; Branch; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('BRANCH'));
        }
        field(52; "Global Dimension 1"; Code[30])
        {
            CalcFormula = lookup("HMS Patient"."Global Dimension 1 Code" where("Patient No." = field("Patient No.")));
            FieldClass = FlowField;
        }
        field(53; "Test Voided"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(54; "Reason For Voiding"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(55; "Sampled Received"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(56; "Received by"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Laboratory No.")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        if "Laboratory No." = '' then begin
            HMSSetup.Get;
            HMSSetup.TestField("Lab Test Request Nos");
            "Laboratory No.":=NoSeriesMgt.GetNextNo(HMSSetup."Lab Test Request Nos", 0D, true);
        end;
    end;

    var
        HMSSetup: Record "HMS Setup";
        NoSeriesMgt: Codeunit "No. Series";
}

