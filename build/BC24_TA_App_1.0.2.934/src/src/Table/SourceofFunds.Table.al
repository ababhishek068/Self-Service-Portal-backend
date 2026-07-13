table 50538 "Source of Funds"
{
    Caption = 'Table 50005 - Source of Funds';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Code."; Code[20])
        {
            Caption = 'Code.';
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }

        field(3; "Blocked"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Code.")
        {
            Clustered = true;
        }
    }

}
