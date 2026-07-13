Table 50027 "Bank Payments"
{

    fields
    {
        field(1; "Line No"; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Doc No"; Code[20]) { }
        field(3; Payee; Code[20]) { }
        field(4; Amount; Decimal) { }
        field(5; "Bank A/C No"; Code[20]) { }
        field(6; "Bank Branch No"; Code[20]) { }
        field(7; "Bank A/C Name"; Text[50]) { }
        field(8; "Bank Code"; Code[20]) { }
        field(9; Status; Option)
        {
            OptionMembers = New,Submitted,Cleared;
        }
        field(10; Date; Date) { }
        field(11; Select; Boolean) { }
        field(12; Type; Option)
        {
            OptionMembers = Creditors,Salaries;
        }
        field(13; Paid; Boolean) { }
        field(14; "Paid By"; Code[20]) { }
        field(15; "Paid Date"; Date) { }
        field(16; OPN; Code[20]) { }
    }

    keys
    {
        key(Key1; "Line No")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnDelete()
    begin
        Error('Please note that you can not delete EFT payments');
    end;
}

