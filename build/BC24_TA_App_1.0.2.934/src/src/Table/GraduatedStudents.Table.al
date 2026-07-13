Table 50049 "Graduated Students"
{

    fields
    {
        field(1; "Student No"; Code[20]) { }
        field(2; Name; Text[100]) { }
        field(3; "Applied Count"; Integer)
        {
            CalcFormula = count("Graduation Request" where(Code = field("Student No")));
            FieldClass = FlowField;
        }
        field(4; "Graduation Year"; Code[20])
        {
            TableRelation = "Exam Periods".Code;
        }
    }

    keys
    {
        key(Key1; "Student No")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

