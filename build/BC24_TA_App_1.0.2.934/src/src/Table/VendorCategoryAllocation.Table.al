Table 50914 "Vendor Category Allocation"
{

    fields
    {
        field(1; "Vendor No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Category; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Supplier Category".Code;
        }
        field(3; "Vendor Name"; Text[50])
        {
            CalcFormula = lookup(Vendor.Name where("No." = field("Vendor No")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Vendor No", Category)
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

