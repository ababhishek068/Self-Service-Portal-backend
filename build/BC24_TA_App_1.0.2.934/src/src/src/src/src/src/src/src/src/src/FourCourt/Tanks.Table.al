table 50713 Tanks
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Tank Code"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Location.code;
        }
        field(2; "Description"; text[100])
        {
            DataClassification = ToBeClassified;

        }
        field(3; "Fuel Type"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Fuel Type".code;
        }
        field(4; "Capacity"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(5; "Initial Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(6; "Station Code"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = filter(1));

        }
        field(7; "Availlable Quantity"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Item Ledger Entry".Quantity where("Item No." = field("Fuel Type"), "Location Code" = field("Tank Code")));
            BlankZero = true;
        }

    }

    keys
    {
        key(Key1; "Tank Code")
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