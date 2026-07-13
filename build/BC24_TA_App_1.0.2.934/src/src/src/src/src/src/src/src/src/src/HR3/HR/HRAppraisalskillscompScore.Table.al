Table 50406 "HR Appraisal skills comp Score"
{

    fields
    {
        field(1; "Appraisal No"; Code[30]) { }
        field(2; "Appraisal Period"; Code[30]) { }
        field(3; Competence; Text[250]) { }
        field(4; Score; Decimal) { }
        field(5; "Question Number"; Integer) { }
        field(6; "Line No"; Integer)
        {
            AutoIncrement = true;
            MinValue = 1;
        }
    }

    keys
    {
        key(Key1; "Appraisal No", "Question Number")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

