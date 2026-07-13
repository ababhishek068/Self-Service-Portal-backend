Table 50099 "Unit Prerequisite"
{
    // LookupPageId = "Unit Prerequisite";
    fields
    {
        field(1; Unit; Code[20])
        {

            TableRelation = "Courses Master".Code;
        }
        field(2; "Prerequisite Unit"; Code[20])
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
        key(Key1; Unit, "Prerequisite Unit")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

