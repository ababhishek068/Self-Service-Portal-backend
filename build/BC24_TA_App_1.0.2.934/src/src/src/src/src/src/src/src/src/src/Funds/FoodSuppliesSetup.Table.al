Table 50752 "Food Supplies Setup"
{

    fields
    {
        field(1; Setup; Code[10]) { }
        field(2; "Prepared By"; Text[50]) { }
        field(3; "Approved By"; Text[50]) { }
        field(4; "Review Status"; Code[10]) { }
        field(5; "Record No"; Code[20]) { }
        field(6; "Review Date"; Date) { }
        field(7; "Next Review Date"; Date) { }
        field(8; Period; Text[30]) { }
    }

    keys
    {
        key(Key1; Setup)
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

