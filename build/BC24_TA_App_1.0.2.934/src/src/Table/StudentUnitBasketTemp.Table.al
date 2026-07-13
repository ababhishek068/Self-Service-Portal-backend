Table 50092 "Student Unit Basket Temp"
{
    DrillDownPageID = "Student Units - List";
    LookupPageID = "Student Units - List";

    fields
    {
        field(1; "Reg. Transacton ID"; Code[20])
        {
            Editable = true;
        }
        field(2; "Student No."; Code[30])
        {
            Editable = true;
            NotBlank = true;
            TableRelation = Customer."No.";
        }
        field(3; Semester; Code[20])
        {
            Editable = true;
            NotBlank = false;
            TableRelation = Semesters.Code;
        }
        field(4; Programme; Code[20])
        {
            Editable = true;
            NotBlank = false;
            TableRelation = Programme.Code;
        }
        field(6; Stage; Code[20])
        {
            Editable = true;
            NotBlank = false;
        }
        field(7; Unit; Code[20])
        {
            Editable = true;
            NotBlank = false;
            TableRelation = "Units/Subjects".Code where("Programme Code" = field(Programme));
        }
        field(8; "Unit Name"; Text[100]) { }
        field(13; Taken; Boolean) { }
        field(16; UnitCount; Integer)
        {
            CalcFormula = count("Student Unit Basket" where(Programme = field(Programme),
                                                             Stage = field(Stage),
                                                             Semester = field(Semester),
                                                             Unit = field(Unit)));
            FieldClass = FlowField;
        }
        field(51; "Unit Stage"; Code[20])
        {
            TableRelation = "Programme Stages".Code where("Programme Code" = field(Programme));
        }
        field(52; "Date Submitted"; Date) { }
        field(50088; "Registration Type"; Option)
        {
            OptionCaption = 'Normal,Supplementary,Special,Retake';
            OptionMembers = Normal,Supplementary,Special,Retake;
        }
        field(50089; Submitted; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50090; "Exist in Stud Units"; Integer)
        {
            CalcFormula = count("Student Units" where("Student No." = field("Student No."),
                                                       Unit = field(Unit)));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; Programme, Stage, Unit, Semester, "Reg. Transacton ID", "Student No.")
        {
            Clustered = true;
        }
        key(Key2; "Student No.", Unit) { }
        key(Key3; "Student No.", Programme, Stage, Unit, Semester, "Reg. Transacton ID") { }
        key(Key4; Stage) { }
        key(Key5; Unit, Stage) { }
        key(Key6; Unit) { }
    }

    fieldgroups { }

    procedure GetGrade(Marks: Decimal; UnitG: Code[20]; Studprog: Code[20]; StudStage: Code[20]) xGrade: Text[100]
    begin
    end;

    procedure GetGradeStatus(AvMarks: Decimal; ProgCode: Code[20]; Unit: Code[20]; StudStage: Code[20]) F: Boolean
    begin
    end;
}

