Table 50867 "FLT-Ticket Authorizing Off."
{
    DrillDownPageID = "FLT-Ticket Authorizing Off.";
    LookupPageID = "FLT-Ticket Authorizing Off.";

    fields
    {
        field(1; "Officer Line no."; Integer) { }
        field(2; "Ticket No."; Code[10]) { }
        field(3; "Officer No."; Code[10])
        {
            TableRelation = "HR-Employee"."No.";
        }
        field(4; "Officer Name"; Text[30])
        {
            CalcFormula = lookup("HR-Employee"."First Name" where("No." = field("Officer No.")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Officer Line no.", "Ticket No.", "Officer No.")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

