Table 50594 "HMS Radiology Form Header"
{
    //LookupPageID = UnknownPage70135170;

    fields
    {
        field(1; "Radiology No."; Code[20])
        {
            NotBlank = true;
        }
        field(2; "Radiology Date"; Date)
        {
            NotBlank = true;
        }
        field(3; "Radiology Time"; Time)
        {
            NotBlank = true;
        }
        field(4; "Radiology Area"; Option)
        {
            NotBlank = true;
            OptionMembers = Doctor,Admission;
        }
        field(5; "Patient No."; Code[20])
        {
            NotBlank = true;

            trigger OnValidate()
            begin
                objPat.Reset;
                objPat.SetRange(objPat."Patient No.", "Patient No.");
                if objPat.Find('-') then begin
                    Surname := objPat.Surname;
                    "Middle Name" := objPat."Middle Name";
                    "Last Name" := objPat."Last Name";
                    "Search Names" := objPat.Surname + ' ' + objPat."Middle Name" + ' ' + objPat."Last Name";
                end;
            end;
        }
        field(6; "Student No."; Code[20]) { }
        field(7; "Employee No."; Code[20]) { }
        field(8; "Relative No."; Integer) { }
        field(9; Status; Option)
        {
            OptionMembers = New,Cancelled,Completed,Forwarded;
        }
        field(10; "Link No."; Code[20]) { }
        field(11; "Link Type"; Code[20]) { }
        field(12; "No. Series"; Code[20]) { }
        field(13; "Supervisor ID"; Code[20])
        {
            TableRelation = "User Setup"."User ID";
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
        field(35; "Search Names"; Text[200]) { }
        field(36; "Doctor ID"; Code[50]) { }
        field(37; "Treatment No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(38; Branch; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('BRANCH'));
        }
    }

    keys
    {
        key(Key1; "Radiology No.")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    var
        objPat: Record "HMS Patient";
}

