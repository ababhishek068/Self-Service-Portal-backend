Table 50758 "Registry Files Ledger Entry"
{

    fields
    {
        field(1; "Entry No."; Integer) { }
        field(2; "File No./Folio No."; Code[30]) { }
        field(3; "Transaction Date"; Date) { }
        field(4; "Source Department"; Code[20]) { }
        field(5; "Destination Department"; Code[20]) { }
        field(6; "Dispatch Officer Code"; Code[50]) { }
        field(7; "Receiving Officer Code"; Code[50]) { }
        field(8; "Expected Return Date"; Date) { }
        field(9; "Transaction Type"; Option)
        {
            OptionCaption = ' ,Reg. Inbound,Reg. Outbound,Bringup,Archive';
            OptionMembers = " ","Reg. Inbound","Reg. Outbound",Bringup,Archive;
        }
        field(10; Comments; Text[250]) { }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

