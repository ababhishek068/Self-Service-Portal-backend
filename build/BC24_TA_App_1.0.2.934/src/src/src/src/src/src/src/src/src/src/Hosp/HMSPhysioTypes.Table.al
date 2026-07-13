Table 50559 "HMS PhysioTypes"
{

    fields
    {
        field(1; pfno; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Amounttt; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; pfno)
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

