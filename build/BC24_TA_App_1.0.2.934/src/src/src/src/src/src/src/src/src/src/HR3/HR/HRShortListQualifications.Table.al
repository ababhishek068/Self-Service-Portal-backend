Table 50799 "HR ShortListQualifications"
{
    Caption = 'HR Qualifications';
    DataCaptionFields = "Code", Description;
    DrillDownPageID = "HR ShortListQualifications";
    LookupPageID = "HR ShortListQualifications";

    fields
    {
        field(1; "ShortList Type"; Code[50])
        {
            TableRelation = "HR Lookup Values".Code where(Type = const("ShortListing Criteria"));
        }
        field(2; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(6; Description; Text[100])
        {
            Caption = 'Description';
            NotBlank = true;
        }
    }

    keys
    {
        key(Key1; "ShortList Type", "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

