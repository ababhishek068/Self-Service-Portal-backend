Table 50913 "Supplier Category"
{
    LookupPageId = "Supplier Category";
    DrillDownPageId = "Supplier Category";
    Caption = 'Supplier Categories';
    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[150])
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

