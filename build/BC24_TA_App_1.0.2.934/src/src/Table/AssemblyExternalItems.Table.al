table 50146 "Assembly External Items"
{
    DataClassification = ToBeClassified;
    LookupPageId = "Assembly External Items";
    fields
    {
        field(1; "Line No"; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(2; "No"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(3; "Assembly Stage"; code[20])
        {
            TableRelation = "Production Status".code;
            DataClassification = ToBeClassified;

        }
        field(4; "Material Code"; code[20])
        {
            DataClassification = ToBeClassified;
            //  TableRelation = "Prod. Item Material"."Material Code";
            TableRelation = "Prod.Order Item Material"."Material Code" where("Item No" = field(No));
            trigger OnValidate()
            var
                ProdMat: Record "Prod.Order Item Material";
            begin
                ProdMat.reset;
                ProdMat.setrange("Item No", No);
                ProdMat.setrange("Material Code", "Material Code");
                if ProdMat.find('-') then begin
                    Description := ProdMat.Description;
                    "Received Qty" := ProdMat.Quantity;
                end;
                "Remaining Qty" := "Received Qty" - "Used Qty";
            end;
        }
        field(5; "Description"; text[200])
        {
            DataClassification = ToBeClassified;

        }
        field(6; "Used Qty"; decimal)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                "Remaining Qty" := "Received Qty" - "Used Qty";
            end;

        }
        field(7; "Received Qty"; decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(8; "Remaining Qty"; decimal)
        {
            DataClassification = ToBeClassified;

        }

    }

    keys
    {
        key(Key1; "Line No", No)
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