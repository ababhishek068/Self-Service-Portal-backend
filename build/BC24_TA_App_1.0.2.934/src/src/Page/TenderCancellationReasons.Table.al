table 50979 "Tender Cancellation Reasons"
{
    Caption = 'Tender Cancellation Reasons';
    DataClassification = ToBeClassified;
    
    fields
    {
        field(1; "Reason Code"; Code[20])
        {
            Caption = 'Reason Code';
        }
        field(2; "Reason Description"; Text[100])
        {
            Caption = 'Reason Description';
        }
    }
    keys
    {
        key(PK; "Reason Code")
        {
            Clustered = true;
        }
    }
}
