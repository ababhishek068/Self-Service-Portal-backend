Table 50544 "Investment Setup"
{

    fields
    {
        field(1; "Primary Key"; Text[30]) { }
        field(2; "Investment Nos"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(3; "Investment Template"; Code[20])
        {
            TableRelation = "Gen. Journal Template".Name;
        }
        field(4; "Investment Batch"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Investment Template"));
        }
        field(5; "Investment G/L Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(6; "Interest G/L Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(7; "Withholding Tax G/L Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(8; "Treasury Bill Nos"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(9; "Treasury Bill Interest Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(10; "Treasury Bill Investment A/C"; Code[20])
        {
            TableRelation = "G/L Account";
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

