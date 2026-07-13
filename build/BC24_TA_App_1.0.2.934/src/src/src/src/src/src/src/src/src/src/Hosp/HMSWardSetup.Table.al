Table 50610 "HMS Ward Setup"
{
    // LookupPageID = "ELECT Candidate Line";

    fields
    {
        field(1; "Ward Code"; Code[20]) { }
        field(2; "Ward Name"; Text[50]) { }
        field(3; "Room Charges"; Decimal) { }
        field(4; "Insurance Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Charges Code"; Code[20])
        {
            TableRelation = "HMS Charges".Code;
        }
    }

    keys
    {
        key(Key1; "Ward Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

