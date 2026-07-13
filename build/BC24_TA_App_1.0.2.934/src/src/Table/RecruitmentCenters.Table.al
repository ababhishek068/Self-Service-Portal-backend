Table 50719 "Recruitment Centers"
{
    LookupPageId = "Recruitment Centers";

    fields
    {
        field(1; Code; Code[50])
        {
            NotBlank = true;
        }
        field(2; Description; Text[150]) { }
        field(3; "Sub Region"; Code[20])
        {
            TableRelation = "Sub Region".Code;
        }
    }

    keys
    {
        key(Key1; code)
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

