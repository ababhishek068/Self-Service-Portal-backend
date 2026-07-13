Table 50168 "Fore Court Setup"
{

    fields
    {
        field(1; "Dipping Nos"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(2; "Shift Nos"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(3; "Shift Allocation Nos"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(4; "Pump Reading Nos"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(5; "Return to Stock Nos"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(8; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }

        field(10; "Transfer Nos"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(11; "Clearance Nos"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(12; "Maximum Reading Variance"; Decimal)
        {
            InitValue = 1.0;
        }
        field(13; "Item Journal Template"; Code[20])
        {
            TableRelation = "Item Journal Template".Name;
        }
        field(14; "Item Journal Batch"; Code[20])
        {
            TableRelation = "Item Journal Batch".Name where("Journal Template Name" = field("Item Journal Template"));
        }
        field(15; "Invoice Clearance Account"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(16; "ForeCourt Department"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = filter(2));
        }



    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

