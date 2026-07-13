Table 50302 "Study Years"
{

    fields
    {
        field(1; "Code"; Code[20]) { }
        field(2; Description; Text[30]) { }
        field(3; "Show on Report"; Boolean) { }
        field(4; "Stage Filter"; Code[100])
        {
            DataClassification = ToBeClassified;
        }
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

