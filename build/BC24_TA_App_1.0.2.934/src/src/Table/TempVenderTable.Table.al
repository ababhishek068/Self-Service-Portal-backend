table 50000 "Temp Vender Table"
{
    Caption = 'Temp Vender Table';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Current No."; Code[20])
        {
            Caption = 'Current No.';
            DataClassification = ToBeClassified;
        }
        field(2; "Old No."; Code[20])
        {
            Caption = 'Old No.';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Current No.")
        {
            Clustered = true;
        }
    }
}
