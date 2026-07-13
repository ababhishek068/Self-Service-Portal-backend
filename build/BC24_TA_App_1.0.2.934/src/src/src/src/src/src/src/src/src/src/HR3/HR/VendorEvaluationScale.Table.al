table 50977 "Vendor Evaluation Factors"
{
    Caption = 'Vendor Evaluation Factors';
    DataClassification = ToBeClassified;
    fields
    {
        field(1; "Code"; Integer)
        {
            Caption = 'Code';
            Editable = false;
            AutoIncrement = true;
            DataClassification = CustomerContent;
        }
        field(2; "Rating Factor"; Text[100])
        {
            Caption = 'Rating Factor';
            DataClassification = CustomerContent;
        }
        field(3; "Active?"; Boolean)
        {
            Caption = 'Active?';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Code", "Rating Factor")
        {
            Clustered = true;
        }
    }
}
