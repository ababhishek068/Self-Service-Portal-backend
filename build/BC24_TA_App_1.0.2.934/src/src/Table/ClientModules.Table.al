Table 50363 "Client Modules"
{

    fields
    {
        field(1; "Entry No"; Integer)
        {
            AutoIncrement = true;
        }
        field(2; Customer; Code[20])
        {
            TableRelation = Customer."No.";
        }
        field(3; Module; Code[30])
        {
            TableRelation = Modules.Code;
        }
        field(4; Description; Text[100]) { }
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

