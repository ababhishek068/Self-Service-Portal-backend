table 50706 "PR Third Party Charges"
{
    Caption = 'PR Third Party Charges';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Code; Code[20])
        {
            Caption = 'Code';
            DataClassification = ToBeClassified;
        }
        field(2; Name; Code[50])
        {
            Caption = 'Name';
            DataClassification = ToBeClassified;
        }

        field(3; "Charge Per Transaction"; Decimal)
        {
            BlankZero = true;
        }
    }
    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }

}
