Table 50679 "Applicants Medical Info."
{

    fields
    {
        field(1; "Applicant No"; Code[20])
        {
            NotBlank = true;
        }
        field(2; Description; Text[150])
        {
            NotBlank = true;
            TableRelation = "Medical Information".Description;
        }
        field(3; Results; Text[200]) { }
        field(4; Date; Date) { }
        field(5; Remarks; Text[200]) { }
    }

    keys
    {
        key(Key1; "Applicant No", Description)
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

