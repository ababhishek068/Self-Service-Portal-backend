Table 50477 Days
{

    fields
    {
        field(1; Day; Code[20])
        {
            NotBlank = true;
        }
        field(2; Description; Text[150]) { }
        field(3; Exams; Boolean) { }
        field(4; "Exam No."; Integer) { }
        field(5; Lost; Integer) { }
    }

    keys
    {
        key(Key1; Day)
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

