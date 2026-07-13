table 50267 "HR Job Qualifications"
{
    Caption = 'HR Qualifications';
    DataCaptionFields = "Code", Description;
    // DrillDownPageID = 58021;
    //  LookupPageID = 58021;

    fields
    {
        field(1; "Qualification Type"; Code[50])
        {
            TableRelation = "HR Lookup Values".Code WHERE(Type = CONST("Qualification Type"));
        }
        field(2; "Code"; Code[50])
        {
            Caption = 'Code';
        }
        field(6; Description; Text[250])
        {
            Caption = 'Description';
            NotBlank = true;
        }
        field(7; Level; Code[100])
        {
            TableRelation = "HR Lookup Values".Code;
        }
        field(8; "Order"; Integer) { }
        field(9; "Category Description"; Text[250]) { }
        field(10; Category; Code[100]) { }
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

