Table 50310 "Int. Audit Sections"
{
    LookupPageId = "Int. Audit Sections";
    fields
    {
        field(1; "Code"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Description"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Ranking; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(4; Responsibility; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Expected Days"; Decimal)
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

    fieldgroups
    {
        fieldgroup(DropDown; "Code") { }
    }
}

