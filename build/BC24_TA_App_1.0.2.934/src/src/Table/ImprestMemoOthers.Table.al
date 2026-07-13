table 50947 "Imprest Memo Others"
{
    Caption = 'Imprest Memo Others';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Line No"; Integer)
        {
            Caption = 'Line No';
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(2; "Imprest Memo No"; Code[20])
        {
            Caption = 'Imprest Memo No';
            TableRelation = "Imprest Memo Header"."No.";
            DataClassification = ToBeClassified;
        }
        field(3; Names; Text[250])
        {
            Caption = 'Names';
            DataClassification = ToBeClassified;
        }
        field(4; Designation; Text[150])
        {
            Caption = 'Designation';
            DataClassification = ToBeClassified;
        }
        field(5; "Organization/Institution"; Text[150])
        {
            Caption = 'Organization/Institution';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Line No", "Imprest Memo No")
        {
            Clustered = true;
        }
    }
}
