Table 50045 "Exam Category"
{
    DrillDownPageID = "Exam Category";
    LookupPageID = "Exam Category";

    fields
    {
        field(1; "Code"; Code[20]) { }
        field(2; Description; Text[150]) { }
        field(3; Series; Integer) { }
        field(4; "CAT Count"; Integer)
        {
            CalcFormula = count("Exams Setup" where(Category = field(Code),
                                                     Type = const(CAT)));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; Series, "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

