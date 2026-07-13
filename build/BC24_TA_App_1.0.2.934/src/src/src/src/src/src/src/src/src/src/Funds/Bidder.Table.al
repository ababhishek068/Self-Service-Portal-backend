Table 50496 Bidder
{

    fields
    {
        field(1; "PIN No"; Code[20]) { }
        field(2; "Date Created"; Date) { }
        field(3; "Created By"; Code[20]) { }
        field(4; Password; Text[30])
        {

            trigger OnValidate()
            begin
                "Changed Password" := false;
            end;
        }
        field(5; "Tenderer Name"; Text[100]) { }
        field(6; "Changed Password"; Boolean) { }
        field(7; "Procurement Officer"; Boolean) { }
        field(8; "Posted To Portal"; Boolean) { }
    }

    keys
    {
        key(Key1; "PIN No")
        {
            Clustered = true;
        }
        key(Key2; "Date Created") { }
        key(Key3; "Created By") { }
    }

    fieldgroups { }

    trigger OnDelete()
    begin
        Error('You cannot delete data from this table');
    end;

    trigger OnInsert()
    begin
        "Created By" := UserId;
        "Date Created" := Today;
    end;
}

