table 50710 "Dipping Lines"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; No; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Line No"; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(3; "Tank Code"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Tanks."Tank Code" where("Station Code" = field("Station Code"));
            trigger OnValidate()
            var
                Itm: Record Item;
                PHeader: Record "Dipping Header";
                DDate: date;

            begin
                CalcFields("Fuel Type");
                PHeader.Reset();
                IF PHeader.GET(No) THEN
                    DDate := PHeader.Date;



                Itm.reset;
                Itm.SetFilter("Location Filter", "Tank Code");
                Itm.SetFilter("date filter", format(DDate));
                //Itm.setfilter("Global Dimension 1 Filter", "Station Code");
                itm.setfilter("No.", "Fuel Type");
                if Itm.find('-') then begin
                    itm.CalcFields(Inventory);
                    "Expected Quantity" := itm.Inventory;

                end;
            end;
        }
        field(4; "Station Code"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = filter(1));

        }
        field(5; "Expected Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(6; "Actual Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                Itm: Record Item;
                FuelType: Record "Fuel Type";
            begin
                CalcFields("Fuel Type");
                FuelType.get("Fuel Type");
                Itm.reset;
                Itm.SetFilter("Location Filter", "Tank Code");
                // Itm.setfilter("Global Dimension 1 Filter", "Station Code");
                itm.setfilter("No.", "Fuel Type");
                if Itm.find('-') then begin
                    itm.CalcFields(Inventory);
                    "Variance Quantity" := "Actual Quantity" - "Expected Quantity";
                    "Variant Cost" := "Variance Quantity" * FuelType."Unit Price";
                end;
            end;
        }
        field(7; "Variance Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(8; "Unit Cost"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Variant Cost"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(10; "Fuel Type"; code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Tanks."Fuel Type" where("Tank Code" = field("Tank Code")));


        }

    }

    keys
    {
        key(Key1; No, "Line No", "Station Code")
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