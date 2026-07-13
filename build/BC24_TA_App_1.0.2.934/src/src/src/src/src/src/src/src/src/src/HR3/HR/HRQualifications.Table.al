Table 50792 "HR Qualifications"
{
    Caption = 'HR Qualifications';
    DataCaptionFields = "Code", Description;
    DrillDownPageID = "HR Qualifications";
    LookupPageID = "HR Qualifications";

    fields
    {
        field(1; "Qualification Type"; Code[50])
        {
            TableRelation = "HR Lookup Values".Code where(Type = const("Qualification Type"));
        }
        field(2; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(6; Description; Text[200])
        {
            Caption = 'Description';
            NotBlank = true;
        }
        field(7; "Academic Level"; Code[20])
        {
            TableRelation = "Payment Schedule Line".No;
        }
    }

    keys
    {
        key(Key1; "Qualification Type", "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

