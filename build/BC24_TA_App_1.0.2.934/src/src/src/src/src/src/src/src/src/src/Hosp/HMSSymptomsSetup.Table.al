Table 50772 "HMS Symptoms Setup"
{
    // LookupPageID = "ELECT Election Result Line";

    fields
    {
        field(1; "Syptom Code"; Code[20]) { }
        field(2; "Symptom Name"; Text[100]) { }
        field(3; "Treatment no"; Code[20])
        {
            TableRelation = "HMS Treatment Form Header"."Treatment No.";
        }
    }

    keys
    {
        key(Key1; "Syptom Code", "Treatment no")
        {
            Clustered = true;
        }
        key(Key2; "Symptom Name") { }
    }

    fieldgroups { }
}

