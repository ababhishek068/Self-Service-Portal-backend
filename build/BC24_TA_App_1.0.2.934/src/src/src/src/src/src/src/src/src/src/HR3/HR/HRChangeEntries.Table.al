Table 50797 "HR Change Entries"
{

    fields
    {
        field(1; "Line No"; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "employee No"; Code[50]) { }
        field(3; "Change Date"; Date) { }
        field(4; "Change Description"; Text[250]) { }
        field(5; "Old Value"; Text[250]) { }
        field(6; "New Value"; Text[250]) { }
        field(7; UserID; Code[50]) { }
        field(8; "Time Modified"; time) { }
        field(9; "Field Changed"; Text[200]) { }


    }

    keys
    {
        key(Key1; "Line No")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

