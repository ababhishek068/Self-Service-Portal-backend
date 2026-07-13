Table 50145 "Rules & Regulations"
{
    // LookupPageID = UnknownPage39005786;

    fields
    {
        field(1; "Code"; Code[20]) { }
        field(2; Date; Date) { }
        field(3; "Rules & Regulations"; Text[250]) { }
        field(4; "Document Link"; Text[200]) { }
        field(5; Remarks; Text[200])
        {
            NotBlank = true;
        }
        field(6; "Language Code (Default)"; Code[10]) { }
        field(7; Attachement; Option)
        {
            OptionMembers = No,Yes;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

