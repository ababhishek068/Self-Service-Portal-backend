Table 50739 "Catering SetUp"
{

    fields
    {
        field(1; No; Integer)
        {
            AutoIncrement = false;
            MaxValue = 1;
        }
        field(2; "Receipt No"; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(3; "Receiving Bank"; Code[20])
        {
            TableRelation = "Bank Account"."No.";
        }
        field(4; "Sales Template"; Code[20])
        {
            TableRelation = "Gen. Journal Template".Name;
        }
        field(5; "Sales Batch"; Code[20]) { }
        field(6; "Menu No. Series"; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(7; "Catering Income Account"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(8; "Catering Control Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(9; "Cash Receiving Bank Account"; Code[20])
        {
            TableRelation = "Bank Account"."No.";
        }
        field(10; "MPESA Receiving Bank Account"; Code[20])
        {
            TableRelation = "Bank Account"."No.";
        }
        field(11; "PEPEA  Receiving Bank Account"; Code[20])
        {
            TableRelation = "Bank Account"."No.";
        }
        field(12; "Department Meals Exp. Account"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(13; "Card Payments Bank Account"; Code[20])
        {
            TableRelation = "Bank Account"."No.";
        }
        field(14; "Enterprise Meals Exp Account"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(15; "Other Sales Exp Account"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(16; "Item Template"; Code[20])
        {
            TableRelation = "Item Journal Template".Name;
        }
        field(17; "Item Batch"; Code[20]) { }
        field(20; "Biometrics API Endpoint"; Text[100]) { }
    }

    keys
    {
        key(Key1; No)
        {
            Clustered = true;
        }
    }

    fieldgroups { }



    trigger OnInsert()
    begin
        No := 0;
    end;
}

