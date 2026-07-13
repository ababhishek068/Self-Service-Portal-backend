table 50242 "Vendor Eligibility"
{
    DataClassification = ToBeClassified;
    LookupPageId = "Vendor Eligibility";
    DrillDownPageId = "Vendor Eligibility";
    fields
    {
        field(1; Code; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Description; text[120])
        {
            DataClassification = ToBeClassified;

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