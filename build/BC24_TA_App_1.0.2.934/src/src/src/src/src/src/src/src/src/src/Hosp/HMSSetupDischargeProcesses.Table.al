Table 50604 "HMS Setup Discharge Processes"
{
    //LookupPageID = "WF Student Other Incident SF";

    fields
    {
        field(1; "Code"; Code[20])
        {
            NotBlank = true;
        }
        field(2; Description; Text[100])
        {
            NotBlank = true;
        }
        field(3; Mandatory; Boolean) { }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

