Table 50041 "Class Setups"
{

    fields
    {
        field(1; "Class Code"; Code[100])
        {
            TableRelation = "Course Classes".code;
            DataClassification = ToBeClassified;
        }
        field(2; "Unit Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Entry No"; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(4; "Used Count"; Integer)
        {
            CalcFormula = count("Time Table" where(Unit = field("Unit Code"),
                                                    Programme = field("Programme Code"),
                                                    "Mode of Study" = field("Mode of Study"),
                                                    "Campus Code" = field(Campus)));
            FieldClass = FlowField;
        }
        field(5; "Class Size"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(6; Lecturer; Code[25])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR-Employee"."No." where(Lecturer = filter(true));
        }
        field(7; "Day Count"; Integer)
        {
            CalcFormula = count("Time Table" where(Unit = field("Unit Code"),
                                                    "Day of Week" = field("Day Filter"),
                                                    "Campus Code" = field(Campus),
                                                    "Mode of Study" = field("Mode of Study")));
            FieldClass = FlowField;
        }
        field(8; "Lesson Count"; Integer)
        {
            CalcFormula = count("Time Table" where(Unit = field("Unit Code"),
                                                    "Day of Week" = field("Day Filter"),
                                                    Period = field("Lesson Filter"),
                                                    "Campus Code" = field(Campus),
                                                    "Mode of Study" = field("Mode of Study")));
            FieldClass = FlowField;
        }
        field(9; "Day Filter"; Code[20])
        {
            FieldClass = FlowFilter;
        }
        field(10; "Lesson Filter"; Code[20])
        {
            FieldClass = FlowFilter;
        }
        field(11; "Unit Programme"; Code[20])
        {
            CalcFormula = lookup("Units/Subjects"."Programme Code" where(Code = field("Unit Code")));
            FieldClass = FlowField;
        }
        field(12; "Unit Stage"; Code[20])
        {
            CalcFormula = lookup("Units/Subjects"."Stage Code" where(Code = field("Unit Code")));
            FieldClass = FlowField;
        }
        field(13; Campus; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('1'));
        }
        field(14; LecturerCode; Code[25])
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Unit Name"; Text[100])
        {
            CalcFormula = lookup("Units/Subjects".Desription where(Code = field("Unit Code"),
                                                                    "Stage Code" = field("Unit Stage")));
            FieldClass = FlowField;
        }
        field(16; "Programme Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Unit TT Code Programme"; Code[20])
        {
            CalcFormula = lookup("Units/Subjects"."Programme Code" where("Time Table Code" = field("Unit Code")));
            FieldClass = FlowField;
        }
        field(18; "Actual Unit Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Unit Class Count"; Integer)
        {
            CalcFormula = count("Class Setups" where("Unit Code" = field("Unit Code"),
                                                      "Mode of Study" = field("Mode of Study"),
                                                      Campus = field(Campus)));
            FieldClass = FlowField;
        }
        field(20; "Class Count"; Integer)
        {
            CalcFormula = count("Time Table" where("Unit Class" = field("Class Code"),
                                                    Programme = field("Programme Code"),
                                                    "Campus Code" = field(Campus),
                                                    "Mode of Study" = field("Mode of Study")));
            FieldClass = FlowField;
        }
        field(21; "Reserved Room"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(22; "Used in TT"; Integer)
        {
            CalcFormula = count("Time Table" where(Programme = field("Programme Code"),
                                                    Unit = field("Unit Code")));
            FieldClass = FlowField;
        }
        field(23; "Stage Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(24; "Mode of Study"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Student Types".Code;
        }
    }

    keys
    {
        key(Key1; "Class Code", "Stage Code", Campus, "Mode of Study", "Unit Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

