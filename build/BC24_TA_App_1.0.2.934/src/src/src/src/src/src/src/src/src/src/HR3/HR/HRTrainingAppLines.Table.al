Table 50742 "HR Training App Lines"
{
    // DrillDownPageID = UnknownPage70135367;
    // LookupPageID = UnknownPage70135367;

    fields
    {
        field(1; "Line No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Application No."; Code[20]) { }
        field(3; "Employee No."; Code[20])
        {
            Editable = false;
            TableRelation = "HR-Employee"."No.";
        }
        field(4; Name; Text[50]) { }
        field(5; Objectives; Text[250]) { }
        field(6; "Job ID"; Code[10]) { }
        field(7; "Job Title"; Text[50]) { }
        field(8; Notified; Boolean) { }
        field(9; Suggested; Boolean)
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Line No.", "Application No.")
        {
            Clustered = true;
        }

    }

    fieldgroups { }
}

