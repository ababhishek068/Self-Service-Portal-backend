table 50180 "Fuel Branch Pricing"
{
    DataClassification = ToBeClassified;
    LookupPageId = "Fuel Branch Pricing";
    fields
    {
        field(1; Code; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Item."No.";

            trigger OnValidate()
            var
                Itm: Record Item;
            begin
                if Itm.get(Code) then begin
                    "Item Description" := itm.Description;
                    "Unit Price" := Itm."Unit Price";
                end;
            end;
        }
        field(4; "Branch Code"; code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = filter(1));

        }
        field(2; Description; Text[200])
        {
            DataClassification = ToBeClassified;

        }
        field(5; "Item Description"; Text[200])
        {
            DataClassification = ToBeClassified;

        }
        field(3; "Unit Price"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(8; "Start Date"; date)
        {
            DataClassification = ToBeClassified;

        }
        field(9; "End Date"; date)
        {
            DataClassification = ToBeClassified;

        }
        field(10; "Active"; Boolean)
        {
            DataClassification = ToBeClassified;

        }

    }

    keys
    {
        key(Key1; code, "Branch Code", "Start Date")
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