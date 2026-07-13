Table 50680 "Applicants Comments/Views"
{

    fields
    {
        field(1; "Applicant No"; Code[20]) { }
        field(2; Date; Date) { }
        field(3; "Views/Comments"; Text[150]) { }
    }

    keys
    {
        key(Key1; "Applicant No", Date, "Views/Comments")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

