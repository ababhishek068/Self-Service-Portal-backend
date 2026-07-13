Table 50912 "Payments Application Lines"
{

    fields
    {
        field(1; No; Code[20]) { }
        field(2; "Document No"; Code[50])
        {
            TableRelation = "Purch. Inv. Header"."No.";
        }
        field(3; Description; Text[100]) { }
        field(4; Date; Date) { }
        field(5; Amount; Decimal) { }
        field(6; "External No"; Code[50]) { }
        field(7; "Vendor No"; Code[20]) { }
        field(8; "Vendor Name"; Text[150])
        {
            CalcFormula = lookup(Vendor.Name where("No." = field("Vendor No")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; No, "Document No")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

