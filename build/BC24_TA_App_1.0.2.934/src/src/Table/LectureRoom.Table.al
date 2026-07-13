Table 50056 "Lecture Room"
{
    DrillDownPageID = "Lecture Rooms";
    LookupPageID = "Lecture Rooms";

    fields
    {
        field(1; "Building Code"; Code[20])
        {
            NotBlank = true;
            TableRelation = Building.Code;
        }
        field(2; "Code"; Code[20])
        {
            NotBlank = true;
        }
        field(3; Description; Text[150]) { }
        field(4; "Minimum Capacity"; Decimal) { }
        field(5; "Maximum Capacity"; Decimal) { }
        field(6; Remarks; Text[150]) { }
        field(7; Facilities; Text[200]) { }
        field(8; "Reserve For"; Code[20]) { }
        field(9; "User ID"; Code[20])
        {
            TableRelation = User."User Name";
        }
        field(10; "No."; Integer) { }
        field(11; "Room Type"; Option)
        {
            OptionCaption = 'Lecture Hall,Lab';
            OptionMembers = "Lecture Hall",Lab;
        }
        field(12; "Lab No."; Integer) { }
        field(17; "Global Dimension 1"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
    }

    keys
    {
        key(Key1; "Building Code", "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

