table 50922 "Job Family"
{
    Caption = 'Job Family';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Job Family Code"; Code[20])
        {
            Caption = 'Job Family Code';
            DataClassification = CustomerContent;
        }
        field(2; "Job Family Description"; Text[50])
        {
            Caption = 'Job Family Description';
            DataClassification = CustomerContent;
        }

    }
    keys
    {
        key(PK; "Job Family Code")
        {
            Clustered = true;
        }
    }
}
