Table 50287 "Units Buffer"
{

    fields
    {
        field(1; "Unit Code"; Code[20]) { }
        field(2; Programme; Code[20]) { }
        field(3; "Student No Filter"; Code[20])
        {
            FieldClass = FlowFilter;
        }
        field(4; "Stage Filter"; Code[20])
        {
            FieldClass = FlowFilter;
        }
        field(5; "Semester Filter"; Code[20])
        {
            FieldClass = FlowFilter;
        }
        field(6; "Total Score"; Decimal)
        {
            CalcFormula = sum("Exam Results".Contribution where(Programme = field(Programme),
                                                                 Stage = field("Stage Filter"),
                                                                 Unit = field("Unit Code"),
                                                                 Semester = field("Semester Filter"),
                                                                 Cancelled = const(false),
                                                                 "Student No." = field("Student No Filter")));
            FieldClass = FlowField;
        }
        field(7; "Units Reg Count"; Integer)
        {
            CalcFormula = count("Student Units" where(Unit = field("Unit Code"),
                                                       Programme = field(Programme),
                                                       Semester = field("Semester Filter"),
                                                       Stage = field("Stage Filter"),
                                                       "Student No." = field("Student No Filter")));
            FieldClass = FlowField;
        }
        field(8; "Unit Description"; Text[100])
        {
            CalcFormula = lookup("Units/Subjects".Desription where("Programme Code" = field(Programme),
                                                                    Code = field("Unit Code")));
            FieldClass = FlowField;
        }
        field(9; "Unit Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Core,Elective,Required';
            OptionMembers = Core,Elective,Required;
        }
        field(10; "No of Units"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "User ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(12; Semester; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(13; Stage; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Unit Code", Programme, Semester, Stage)
        {
            Clustered = true;
        }
        key(Key2; "Unit Type") { }
    }

    fieldgroups { }
}

