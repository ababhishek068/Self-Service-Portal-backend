Table 50173 "Service Sub Duties"

{

    LookupPageId = "Service Sub Duties";
    fields
    {
        field(1; Code; Code[50])
        {
            NotBlank = true;
        }
        field(2; Description; Text[150]) { }
        field(3; "Main Duty"; Code[50])
        {
            TableRelation = "Service Duties".code;
        }
    }

    keys
    {
        key(Key1; code, "Main Duty")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

