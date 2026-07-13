Table 50642 "Catering Prepayment Ledger"
{

    fields
    {
        field(1; "Entry No"; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Customer No"; Code[20])
        {
            TableRelation = Customer."No.";
        }
        field(3; "Entry Type"; Option)
        {
            OptionCaption = ' ,Debit Transfer,Credit Transfer,Consumption';
            OptionMembers = " ","Debit Transfer","Credit Transfer",Consumption;
        }
        field(4; Date; Date) { }
        field(5; Description; Text[80]) { }
        field(6; Amount; Decimal) { }
        field(7; "User ID"; Code[50]) { }
        field(8; Reversed; Boolean) { }
        field(9; "Reversed On"; Date) { }
    }

    keys
    {
        key(Key1; "Entry No")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

