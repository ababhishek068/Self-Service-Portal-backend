table 50709 "Fuel Type"
{
    DataClassification = ToBeClassified;
    LookupPageId = "Fuel Type";
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
                    Description := itm.Description;
                    "Unit Price" := Itm."Unit Price";
                end;
            end;
        }
        field(2; Description; Text[200])
        {
            DataClassification = ToBeClassified;

        }
        field(3; "Unit Price"; Decimal)
        {
            DataClassification = ToBeClassified;

        }

    }

    keys
    {
        key(Key1; code)
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