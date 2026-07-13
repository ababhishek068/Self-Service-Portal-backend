Table 50873 "Quotation Request Vendors"
{

    fields
    {
        field(1; "Document Type"; Option)
        {
            OptionMembers = "Quotation Request","Open Tender","Restricted Tender";
        }
        field(2; "Requisition Document No."; Code[20]) { }
        field(3; "Vendor No."; Code[20])
        {
            TableRelation = Vendor."No.";
        }
        field(4; "Vendor Name"; Text[100])
        {
            CalcFormula = lookup(Vendor.Name where("No." = field("Vendor No.")));
            FieldClass = FlowField;
            Editable = false;
        }
        field(8; "Description 2"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Supplier Category"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Supplier Category".Code;
        }
        field(10; "Request Summary"; Text[230])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Date Assigned"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Product Category"; Code[100])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Product Categories"."Product Code";
        }
        field(13; "Sub Product Category"; Code[100])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Product Categories"."Sub Product Code";
        }
        field(14; Total; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Purchase Line".Amount where("RFQ No." = field("Requisition Document No."), "Buy-from Vendor No." = field("Vendor No.")));
        }

    }

    keys
    {
        key(Key1; "Document Type", "Requisition Document No.", "Vendor No.")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

