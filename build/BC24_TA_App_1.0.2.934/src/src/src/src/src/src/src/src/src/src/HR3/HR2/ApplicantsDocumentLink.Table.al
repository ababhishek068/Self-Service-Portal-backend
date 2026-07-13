Table 50155 "Applicants Document Link"
{

    fields
    {
        field(2; "Document Description"; Text[100])
        {
            NotBlank = true;
        }
        field(3; "Document Link"; Text[200])
        {
            ExtendedDatatype = URL;
        }
        field(5; "Applicant No"; Text[30]) { }
        field(6; "Line No"; Integer)
        {
            AutoIncrement = true;
        }
        field(7; "User Name"; Code[30]) { }
        field(8; "Email Address"; Code[30]) { }
    }

    keys
    {
        key(Key1; "Line No", "Document Description")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

