table 50181 "Pump Attend. Invoice Alloc."
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; No; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Customer No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer."No." where("Customer Type" = filter(<> "Pump Attendance"));
            trigger OnValidate()
            var
                Cust: Record customer;
                PumpReading: Record "Pump Reading Header";
            begin
                if Cust.get("Customer No") then
                    Names := Cust.Name;
                if PumpReading.get(No) then begin
                    "Shift No" := PumpReading."Shift No";
                    "Staff No" := PumpReading."Shift No";
                end;
            end;
        }
        field(3; "Fuel Type"; Code[20])
        {
            TableRelation = "Fuel Type".code;
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                FuelType: Record "Fuel Type";
            begin
                if FuelType.get("Fuel Type") then
                    "Unit Price" := FuelType."Unit Price";
            end;
        }
        field(9; "Unit Price"; Decimal)
        {

            DataClassification = ToBeClassified;

        }
        field(6; Quantity; Decimal)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                TestField("Customer No");
                TestField("Fuel Type");
                Amount := "Unit Price" * Quantity;
                if (Amount > 0) and (Quantity > 0) then
                    "Sale Unit Price" := Amount / Quantity;
            end;
        }
        field(4; Amount; Decimal)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                TestField("Customer No");
                TestField("Fuel Type");
                TestField("Reg No.");
                TestField("Driver Names");
                TestField(Quantity);
                if (Amount > 0) and (Quantity > 0) then
                    "Sale Unit Price" := Amount / Quantity;
            end;
        }
        field(5; "Names"; text[200])
        {
            Editable = false;
            DataClassification = ToBeClassified;

        }
        field(15; "Reg No."; text[50])
        {

            DataClassification = ToBeClassified;

        }
        field(16; "Driver Names"; text[200])
        {

            DataClassification = ToBeClassified;

        }
        field(17; "Line No"; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;

        }
        field(18; "Sale Unit Price"; decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(19; "Discount Amount"; decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(20; "Shift No"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(21; "Staff No"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(22; "Suggested"; Boolean)
        {
            DataClassification = ToBeClassified;

        }
        field(23; "Suggested Inv No."; code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;

        }
    }

    keys
    {
        key(Key1; No, "Customer No", "Fuel Type", "Line No")
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