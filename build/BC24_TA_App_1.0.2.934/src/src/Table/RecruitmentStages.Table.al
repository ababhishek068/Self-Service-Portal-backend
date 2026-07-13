Table 50820 "Recruitment Stages"
{


    fields
    {
        field(1; "Recruitement Stage"; Code[50])
        {
            NotBlank = true;
        }
        field(2; Description; Text[200]) { }
        field(3; "Failed Response Templates"; Code[10])
        {
            TableRelation = "Interaction Template".Code;
        }
        field(4; "Passed Response Templates"; Code[10])
        {
            TableRelation = "Interaction Template".Code;
        }
    }

    keys
    {
        key(Key1; "Recruitement Stage")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

