Table 50468 Temp
{

    fields
    {
        field(1; No; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Transcation Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Balance; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; No, "Transcation Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

