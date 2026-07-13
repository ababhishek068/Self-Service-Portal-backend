Table 50376 "Ledger Entry Dimension"
{
    Caption = 'Ledger Entry Dimension';

    fields
    {
        field(1; "Table ID"; Integer)
        {
            Caption = 'Table ID';
            TableRelation = AllObj."Object ID" where("Object Type" = const(Table));
        }
        field(2; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(3; "Dimension Code"; Code[20])
        {
            Caption = 'Dimension Code';
            NotBlank = true;
            TableRelation = Dimension;
        }
        field(4; "Dimension Value Code"; Code[20])
        {
            Caption = 'Dimension Value Code';
            NotBlank = true;
            TableRelation = "Dimension Value".Code where("Dimension Code" = field("Dimension Code"));
        }
    }

    keys
    {
        key(Key1; "Table ID", "Entry No.", "Dimension Code")
        {
            Clustered = true;
        }
        key(Key2; "Dimension Code", "Dimension Value Code") { }
    }

    fieldgroups { }
}

