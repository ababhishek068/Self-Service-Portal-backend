Table 50909 "CshMgt Approvals"
{

    fields
    {
        field(1; "Line No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Document Type"; Option)
        {
            OptionMembers = PV,PC;
        }
        field(3; "Document No."; Code[20]) { }
        field(4; "Document Date"; Date) { }
        field(5; "Process Date"; Date) { }
        field(6; "Process Time"; Time) { }
        field(7; "Process User ID"; Code[20]) { }
        field(8; "Process Name"; Code[20]) { }
        field(9; "Process Machine"; Text[30]) { }
    }

    keys
    {
        key(Key1; "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

