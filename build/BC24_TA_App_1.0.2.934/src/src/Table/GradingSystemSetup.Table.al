Table 50048 "Grading System Setup"
{


    fields
    {
        field(1; Category; Code[20])
        {
            NotBlank = true;
            TableRelation = "Exam Category".code;
        }
        field(2; Grade; Code[20])
        {
            NotBlank = true;
            TableRelation = "Allowed Grades".code;
            trigger OnValidate()
            var
                AGrades: record "Allowed Grades";
            begin
                if AGrades.get(Grade) then
                    Failed := AGrades.Fail;
            end;
        }
        field(3; Description; Text[150]) { }
        field(4; "Up to"; Decimal) { }
        field(5; Remarks; Text[150]) { }
        field(6; Failed; Boolean) { }
        field(7; Range; Text[150]) { }
        field(8; "Programme Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = Programme.code;
        }
        field(9; "Stage Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Programme Stages".Code where("Programme Code" = field("Programme Filter"));
        }
        field(10; "Semester Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Programme Semesters".Semester where("Programme Code" = field("Programme Filter"));
        }
        field(50000; "GPA Points"; Decimal)
        {
            DecimalPlaces = 1 : 1;
        }
        field(50001; From; Decimal) { }
        field(50002; "To"; Decimal) { }
        field(50003; "Student Count"; Integer)
        {
            CalcFormula = count("Student Units" where(Grade = field(Grade),
                                                       Semester = field("Semester Filter"),
                                                       Programme = field("Programme Filter"),
                                                       Stage = field("Stage Filter"),
                                                       Unit = field("Unit Filter")));
            FieldClass = FlowField;
        }
        field(50013; "Semester Grade Count"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Student Units" where(Grade = field(Grade),
                                                       Semester = field("Semester Filter"),
                                                       Programme = field("Programme Filter"),
                                                       Stage = field("Stage Filter"),
                                                       Unit = field("Unit Filter")));

        }

        field(50004; "Unit Filter"; Code[20])
        {
            FieldClass = FlowFilter;
        }
        field(50005; "Repeat Remarks"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(50023; "Class Grade Count"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Course Registration" where("Exam Grade" = field(Grade),
                                                       Semester = field("Semester Filter"),
                                                       Programme = field("Programme Filter"),
                                                       Stage = field("Stage Filter")));

        }
    }

    keys
    {
        key(Key1; Category, "Up to")
        {
            Clustered = true;
        }
        key(Key2; Grade) { }
    }

    fieldgroups { }
}

