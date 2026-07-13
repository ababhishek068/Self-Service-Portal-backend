table 50943 "Consolidated Budget"
{
    Caption = 'Consolidated Budget';
    DataClassification = ToBeClassified;
    
    fields
    {
        field(1; Budget; Code[20])
        {
            Caption = 'Budget Number';
            Editable=true;
            TableRelation="G/L Budget Name".Name;
        }
        field(2; "Financial Year"; Code[20])
        {
            Caption = 'Financial Year';
        }
    }
    keys
    {
        key(PK; Budget)
        {
            Clustered = true;
        }
    }
}
