table 50163 "Return to Tank Line"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No"; code[20])
        {
            DataClassification = ToBeClassified;

        }

        field(2; "Tank Code"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Tanks."Tank Code" where("Station Code" = field("Station Code"));
            trigger OnValidate()
            var
                FuelType: Record "Fuel Type";
                TankS: Record Tanks;
            begin
                if TankS.get("Tank Code") then begin
                    "Fuel Type" := TankS."Fuel Type";
                    if FuelType.get("Fuel Type") then
                        "Unit Price" := FuelType."Unit Price";
                    "Amount" := "Quantity" * "Unit Price";
                end;


            end;
        }


        field(7; "Unit Price"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = FALSE;

        }
        field(8; "Unit Cost"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(9; "Unit Discount"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(10; "Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;

        }
        field(11; "Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                "Amount" := "Quantity" * "Unit Price";
            end;


        }
        field(12; "Line No"; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(15; "Station Code"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = filter(1));

        }
        field(16; "Staff No"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser".Code where("Global Dimension 1 Code" = field("Station Code"));

        }
        field(29; "Shift No"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Shift Allocation".No;

        }
        field(17; "Reason"; text[200])
        {
            DataClassification = ToBeClassified;


        }
        field(18; "Fuel Type"; code[20])
        {
            TableRelation = "Fuel Type".code;


        }
        field(19; "Pump Code"; code[20])
        {
            TableRelation = Pump.Code where("Tank Code" = field("Tank Code"));


        }
    }

    keys
    {
        key(Key1; No, "Line No", "Shift No", "Station Code")
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