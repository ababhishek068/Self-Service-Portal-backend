Table 50377 "Compliance journal"
{
    // DrillDownPageID = "Exams Coordinator Role Centre";
    //  LookupPageID = "Exams Coordinator Role Centre";

    fields
    {
        field(1; "Grant No"; Code[20])
        {
            TableRelation = Jobs."No.";
        }
        field(2; "Compliance Code"; Code[20]) { }
        field(3; Description; Text[250]) { }
        field(4; "Document No"; Code[50])
        {
            TableRelation = "Purchase Header"."No.";
        }
        field(5; "Document Date"; Date) { }
        field(6; User; Code[50]) { }
        field(7; Amount; Decimal) { }
        field(8; Comments; Text[250]) { }
        field(9; Complied; Boolean) { }
    }

    keys
    {
        key(Key1; "Grant No", "Compliance Code", "Document No")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

