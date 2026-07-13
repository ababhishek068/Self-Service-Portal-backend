Table 50561 "HMS Physio Line Process"
{

    fields
    {
        field(1; "No."; Code[20])
        {
            NotBlank = true;
        }
        field(2; "Process No."; Code[20])
        {
            NotBlank = true;
        }
        field(3; "Process Name"; Text[30])
        {
            FieldClass = Normal;
        }
        field(4; "Process Mandatory"; Boolean)
        {
            FieldClass = Normal;
        }
        field(5; "Process Remarks"; Text[250]) { }
        field(6; "Process Result"; Text[30]) { }
    }

    keys
    {
        key(Key1; "No.", "Process No.")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

