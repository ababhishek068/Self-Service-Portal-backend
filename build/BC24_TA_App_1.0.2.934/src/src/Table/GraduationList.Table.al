Table 50050 "Graduation List"
{

    fields
    {
        field(1; No; Code[20]) { }
        field(2; Names; Text[100]) { }
        field(3; Programme; Code[20])
        {
            TableRelation = Programme.Code;
        }
        field(4; Option; Text[100]) { }
        field(5; Semester; Code[20]) { }
        field(6; "Current Av"; Decimal) { }
        field(7; "Cumm Av"; Decimal) { }
        field(8; Award; Text[100]) { }
        field(9; School; Text[100]) { }
        field(10; "Prog Name"; Text[100])
        {
            CalcFormula = lookup(Programme.Description where(Code = field(Programme)));
            FieldClass = FlowField;
        }
        field(11; "Prog Count"; Integer)
        {
            CalcFormula = count("Graduation List" where(Programme = field(Programme)));
            FieldClass = FlowField;
        }
        field(12; "School Code"; Code[20])
        {
            CalcFormula = lookup(Programme."School Code" where(Code = field(Programme)));
            FieldClass = FlowField;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));
        }
        field(13; "Total CF Taken"; Decimal) { }
        field(14; "Exist in Curr Sem"; Integer)
        {
            CalcFormula = count("Course Registration" where("Student No." = field(No),
                                                             Semester = filter('SEM3 2016')));
            FieldClass = FlowField;
        }
        field(15; "Graduation Year"; Code[20])
        {
            TableRelation = "Exam Periods".Code;
        }
        field(16; "Exists In Graduated"; Integer)
        {
            CalcFormula = count("Graduated Students" where("Student No" = field(No)));
            FieldClass = FlowField;
        }
        field(17; "Semester Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = Semesters.Code;
        }
        field(18; "Required CF"; Decimal) { }
    }

    keys
    {
        key(Key1; No)
        {
            Clustered = true;
        }
        key(Key2; Programme, Option, "Cumm Av") { }
    }

    fieldgroups { }
}

