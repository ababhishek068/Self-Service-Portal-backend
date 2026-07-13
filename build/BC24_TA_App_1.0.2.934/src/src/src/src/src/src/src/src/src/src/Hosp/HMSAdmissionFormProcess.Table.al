Table 50601 "HMS Admission Form Process"
{

    fields
    {
        field(1; "Admission No."; Code[20])
        {
            NotBlank = true;
        }
        field(2; "Process Code"; Code[20])
        {
            NotBlank = true;
        }
        field(3; Process; Text[100])
        {
            FieldClass = Normal;
        }
        field(4; Mandatory; Boolean) { }
        field(5; Performed; Boolean) { }
        field(6; "Process Date"; Date) { }
        field(7; "Process Time"; Time) { }
        field(8; Remarks; Text[200]) { }
        field(9; "Nurse UserId"; Code[50]) { }
    }

    keys
    {
        key(Key1; "Admission No.", "Process Code", "Process Date", "Process Time")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

