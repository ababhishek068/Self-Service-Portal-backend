table 50969 "Satff Medical Claims Setup"
{
    Caption = 'Satff Medical Claims Refund Setup';
    DataClassification = ToBeClassified;
    
    fields
    {
        field(1; Entry_No; Integer)
        {
            Caption = 'Entry_No';
            AutoIncrement=true;
        }
        field(2; "Hospital Classification"; Option)
        {
            Caption = 'Hospital Classification';
            OptionMembers=Government,Private,Outline;
        }
        field(3; "Percentage refund"; decimal)
        {
            Caption = 'Percentage refund';
        }
    }
    keys
    {
        key(PK; "Hospital Classification")
        {
            Clustered = true;
        }
    }
}
