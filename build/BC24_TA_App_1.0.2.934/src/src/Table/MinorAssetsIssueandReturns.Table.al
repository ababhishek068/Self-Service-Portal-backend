Table 50032 "Minor Assets Issue and Returns"
{

    fields
    {
        field(1; "Minor Asset No"; Code[20])
        {

            TableRelation = "Fixed Asset";
        }
        field(2; "Issued To"; Code[20]) { }
        field(3; "Date Issued"; Date) { }
        field(4; "Date Returned"; Date) { }
        field(5; "Issued By"; Code[20])
        {
            Editable = false;
        }
        field(6; "Received By"; Code[20]) { }
        field(7; "Inspection Done By"; Code[20]) { }
        field(8; Remarks; Text[250]) { }
        field(9; Description; Text[250]) { }
        field(10; "Requisition No."; Code[20])
        {
            Editable = false;
        }
        field(11; Select; Boolean) { }
        field(12; Returned; Boolean) { }
        field(13; "Asset Condition"; text[200]) { }
    }

    keys
    {
        key(Key1; "Minor Asset No", "Requisition No.")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

