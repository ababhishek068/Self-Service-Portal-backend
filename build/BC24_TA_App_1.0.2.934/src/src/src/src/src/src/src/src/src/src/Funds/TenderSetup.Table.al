Table 50751 "Tender Setup"
{

    fields
    {
        field(1; Setup; Code[20]) { }
        field(2; "Non Refundable Fee"; Decimal) { }
        field(3; "From Time"; Text[100]) { }
        field(4; "To Time"; Text[100]) { }
        field(5; Period; Text[100]) { }
        field(6; "Opening Date"; Text[100]) { }
    }

    keys
    {
        key(Key1; Setup)
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnDelete()
    begin
        Error('You cannot delete data from this table');
    end;
}

