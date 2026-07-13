table 50159 Pump
{
    DataClassification = ToBeClassified;
    LookupPageId = Pumps;
    fields
    {
        field(1; "Code"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Description"; text[100])
        {
            DataClassification = ToBeClassified;

        }
        field(3; "Tank Code"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Tanks."Tank Code" where("Station Code" = field("Station Code"));
        }

        field(4; "Initial Electronic Cash"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(5; "Initial Electronic Litres"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(6; "Initial Manual Litres"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(7; "Max Electronic Cash Reading"; Decimal)
        {
            DataClassification = ToBeClassified;
            InitValue = 99999999;
        }
        field(8; "Max Electronic Litres Reading"; Decimal)
        {
            DataClassification = ToBeClassified;
            InitValue = 99999999;

        }
        field(9; "Max Manual Litres Reading"; Decimal)
        {
            DataClassification = ToBeClassified;
            InitValue = 99999999;

        }
        field(10; "Station Code"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = filter(1));

        }
        field(11; "Last Elecl. Litres Reading"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(12; "Last Elecl. Cash Reading"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(13; "Last Manual Litres Reading"; Decimal)
        {
            DataClassification = ToBeClassified;

        }

    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}