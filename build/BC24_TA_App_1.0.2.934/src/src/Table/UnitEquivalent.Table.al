Table 50095 "Unit Equivalent"
{
    //LookupPageId="Unit Equivalent";
    fields
    {
        field(1; Unit; Code[20])
        {

            TableRelation = "Courses Master".Code;
        }
        field(2; "Equivalent Unit"; Code[20])
        {

            TableRelation = "Courses Master".Code;
        }
        field(3; Requirement; Text[150])
        {
            NotBlank = true;
        }
        field(4; Mandatory; Boolean) { }
    }

    keys
    {
        key(Key1; Unit, "Equivalent Unit")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

