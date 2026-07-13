Table 50500 "Tender Specifications"
{

    fields
    {
        field(1; "Tender No"; Code[20])
        {
            TableRelation = "Purchase Quote Header"."No." where("Document Type"=const("Open Tender"));
        }
        field(2; "No."; Integer)
        {
            AutoIncrement = true;
            Editable = false;
        }
        field(3; Specification; Text[250])
        {
            NotBlank = false;
        }
        field(4; "Notification Header"; Boolean) { }
    }

    keys
    {
        key(Key1; "Tender No", "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

