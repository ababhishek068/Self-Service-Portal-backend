Table 50661 "HMS Physio Treatment"
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
        field(3; "Process Name"; Text[30]) { }
        field(4; "Process Mandatory"; Boolean) { }
        field(5; "Process Remarks"; Text[250]) { }
        field(6; "Process Result"; Text[30]) { }
        field(7; Diagnosis; Text[250]) { }
        field(8; Treatment; Text[250]) { }
        field(9; "Frequency Per week"; Decimal) { }
        field(10; Duration; Text[30]) { }
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

