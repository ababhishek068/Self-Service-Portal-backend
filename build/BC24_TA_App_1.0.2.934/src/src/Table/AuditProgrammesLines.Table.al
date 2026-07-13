Table 50250 "Audit Programmes Lines"
{

    fields
    {
        field(1; "Code"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Line No"; integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(3; "Audit Objectives"; text[800])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Risks"; Text[800])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Expected Internal Controls"; Text[1000])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Audit Test Code"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Audit Test"; Text[1000])
        {
            DataClassification = ToBeClassified;
        }

    }

    keys
    {
        key(Key1; "Code", "Line No")
        {
            Clustered = true;
        }

    }

    fieldgroups { }
}

