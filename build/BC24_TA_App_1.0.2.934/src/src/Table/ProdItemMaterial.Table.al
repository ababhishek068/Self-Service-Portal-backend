table 50133 "Prod. Item Material"
{
    DataClassification = ToBeClassified;
    LookupPageId = "Prod. Item Material";
    fields
    {
        field(1; "Line No"; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(2; "Item No"; code[20])
        {
            TableRelation = Item."No.";
            DataClassification = ToBeClassified;

        }
        field(3; "Material Code"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Production Materials".Code;
        }
        field(4; "Description"; text[200])
        {
            DataClassification = ToBeClassified;

        }
        field(5; "Type"; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(6; "Unit"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(7; "Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(8; "Condition"; text[200])
        {
            DataClassification = ToBeClassified;

        }
        field(9; "Approval"; Option)
        {
            OptionMembers = ,Approved,Rejected;
            DataClassification = ToBeClassified;

        }
    }

    keys
    {
        key(Key1; "Line No", "Item No")
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