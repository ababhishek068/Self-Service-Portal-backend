Table 50152 DocumentsAndLinks
{

    fields
    {
        field(1; No; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Link Path"; Text[100]) { }
        field(3; "Link Description"; Text[100]) { }
        field(4; "Link Type"; Option)
        {
            OptionCaption = 'NewsFeed,documents';
            OptionMembers = NewsFeed,documents;
        }
    }

    keys
    {
        key(Key1; No)
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

