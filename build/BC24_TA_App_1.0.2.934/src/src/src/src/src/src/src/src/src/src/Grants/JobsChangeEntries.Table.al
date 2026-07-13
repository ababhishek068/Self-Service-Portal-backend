Table 50447 "Jobs Change Entries"
{
    DrillDownPageID = "HMS Patient Charges List";
    LookupPageID = "HMS Patient Charges List";

    fields
    {
        field(1; "integer"; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Project No"; Code[50]) { }
        field(3; "Change Date"; Date) { }
        field(4; "Change Description"; Text[250]) { }
        field(5; "Old Value"; Text[250]) { }
        field(6; "New Value"; Text[250]) { }
        field(7; UserID; Code[50]) { }
    }

    keys
    {
        key(Key1; "integer")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

