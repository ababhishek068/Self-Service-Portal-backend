Table 50769 "HMS Immunization"
{

    fields
    {
        field(1; "No."; Integer)
        {
            AutoIncrement = true;
            NotBlank = false;
        }
        field(2; "Immunization Date"; Date)
        {
            NotBlank = true;
        }
        field(3; "Immunization Time"; Time)
        {
            NotBlank = true;
        }
        field(4; "Patient No."; Code[20])
        {
            NotBlank = true;
            TableRelation = "HMS Patient"."Patient No." where("Patient Type" = field("Patient Type"));
        }
        field(5; "Patient Type"; Option)
        {
            NotBlank = true;
            OptionMembers = Others,Student,Employee,Relative;
        }
        field(6; "Patient Name"; Text[150])
        {
            FieldClass = Normal;
        }


        field(9; Given; Boolean) { }
        field(10; Remarks; Text[200]) { }
        field(11; Posted; Boolean) { }
        field(12; Select; Boolean) { }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

