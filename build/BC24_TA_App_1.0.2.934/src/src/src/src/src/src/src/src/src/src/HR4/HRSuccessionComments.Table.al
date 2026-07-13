Table 50714 "HR Succession Comments"
{

    fields
    {
        field(1; "No."; Code[20]) { }
        field(2; "Position to Succed"; Code[10]) { }
        field(3; Comment; Text[200]) { }
        field(4; Description; Text[200]) { }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

