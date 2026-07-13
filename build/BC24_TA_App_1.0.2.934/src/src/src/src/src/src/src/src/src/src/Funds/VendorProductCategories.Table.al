Table 50789 "Vendor Product Categories"
{
    DrillDownPageID = "Vendor Product Categories List";
    LookupPageID = "Vendor Product Categories List";

    fields
    {
        field(1; "Vendor No"; Code[20])
        {
            TableRelation = Vendor."No.";
        }
        field(2; Description; Text[250]) { }
        field(3; "Category"; code[100])
        {
            TableRelation = "Product Categories"."Product Code";
        }
        field(4; "Entry No"; Integer)
        {
            AutoIncrement = true;
        }
        field(5; "Sub Category"; code[100])
        {
            TableRelation = "Product Categories"."Sub Product Code";
        }
        field(6; "Sub Category Description"; Text[300])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Product Categories"."Sub Product Description" where("Sub Product Code" = field("Sub Category"), "Product Code" = field(Category)));
        }
        field(7; "Supplier Category"; Code[20])
        {
            TableRelation = "Supplier Category".Code;
        }
        field(8; "Last RFQ Assign Date"; date)
        {
            DataClassification = ToBeClassified;
        }

    }

    keys
    {
        key(Key1; "Entry No")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

