table 50702 "Shift Allocation Line"
{
    DataClassification = ToBeClassified;
    LookupPageId = "Shift Allocation Lines";
    fields
    {
        field(1; "No"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Shift Allocation".No;
        }


        field(12; "Line No"; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(15; "Station Code"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code;

        }
        field(28; "Pump Code"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Pump.Code where("Station Code" = field("Station Code"));
        }
        field(16; "Staff No"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser".Code;

            trigger OnValidate()
            var
                HREmp: Record "Salesperson/Purchaser";
                ShiftH: record "Shift Allocation";
            begin
                if HREmp.get("Staff No") then
                    "Staff Name" := HREmp.Name;
                if ShiftH.get(No) then
                    "Station Code" := ShiftH."Station Code";
            end;

        }
        field(18; "Staff Name"; text[200])
        {
            DataClassification = ToBeClassified;
            Editable = false;

        }
        field(17; "Remarks"; text[200])
        {
            DataClassification = ToBeClassified;


        }

        field(20; "Shift Sales Amount"; Decimal)
        {

            FieldClass = FlowField;
            CalcFormula = sum("Pump Reading Header"."Total Reading Amount" where("Staff No" = field("Staff No"), "Shift No" = field("No")));

        }
        field(21; "Fuel Type"; code[20])
        {

            FieldClass = FlowField;
            CalcFormula = lookup("Pump Reading Line"."Fuel Type" where("Staff No" = field("Staff No"), "Shift No" = field("No")));

        }
        field(22; "Posted"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(23; "Open"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(24; "Mpesa Amount"; Decimal)
        {

            FieldClass = FlowField;
            CalcFormula = sum("Receipts Header"."Amount Recieved" where("Sales Person" = field("Staff No"), "Shift No" = field("No"), "Pay Mode" = filter(MPESA)));

        }
        field(25; "Cash Amount"; Decimal)
        {

            FieldClass = FlowField;
            CalcFormula = sum("Receipts Header"."Amount Recieved" where("Sales Person" = field("Staff No"), "Shift No" = field("No"), "Pay Mode" = filter(Cash)));

        }
        field(26; "Credit Amount"; Decimal)
        {

            FieldClass = FlowField;
            CalcFormula = sum("Pump Reading Header"."Total Invoice Amount" where("Staff No" = field("Staff No"), "Shift No" = field("No")));

        }
        field(27; "Pump Out Amount"; Decimal)
        {

            FieldClass = FlowField;
            CalcFormula = sum("Pump Reading Header"."Total Pump Return Amount" where("Staff No" = field("Staff No"), "Shift No" = field("No")));

        }
        field(29; "Return Amount"; Decimal)
        {

            FieldClass = FlowField;
            CalcFormula = sum("Pump Reading Header"."Total Pump Return Amount" where("Staff No" = field("Staff No"), "Shift No" = field("No")));

        }
    }

    keys
    {
        key(Key1; No, "Line No", "Station Code", "Staff No")
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