table 50683 "Contract Suppliers"
{
    DataClassification = ToBeClassified;
    LookupPageId = "Contract Suppliers";
    DrillDownPageId = "Contract Suppliers";
    fields
    {
        field(1; "Line No"; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;

        }
        field(2; "Contract No"; code[20])
        {

            DataClassification = ToBeClassified;

        }
        field(3; "Vendor No"; code[20])
        {
            TableRelation = Vendor."No.";
            DataClassification = ToBeClassified;
            trigger OnValidate()
            Var
                Vend: record Vendor;
            begin
                if Vend.get("Vendor No") then
                    Name := vend.Name;
            end;

        }
        field(4; "Name"; text[200])
        {

            DataClassification = ToBeClassified;

        }

    }

    keys
    {
        key(PK; "Line No", "Contract No")
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