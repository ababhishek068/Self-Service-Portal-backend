Table 50091 "Student Unit Basket"
{
    DrillDownPageID = "Student Units Basket";
    LookupPageID = "Student Units Basket";

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
            TableRelation = "Courses Master".Code where("Time Tabled" = filter(true));
            trigger OnValidate()
            var
                cMaster: Record "Courses Master";
            // CourseR: Record "Course Registration";
            begin
                if cMaster.get(unit) then begin
                    "Unit Name" := cmaster.Description;
                    "No Of Units" := cMaster.units;

                end;
                // CourseR.Reset();
                // CourseR.SetRange("Student No.", "Student No.");
                // CourseR.SetRange(Semester, Semester);
                // CourseR.SetRange(Reversed, false);
                // if CourseR.Find('-') then begin
                //     "Register for" := CourseR."Register for";
                //     "Reg. Transacton ID" := CourseR."Reg. Transacton ID";
                // end;
            end;

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
        field(17; "Register for"; Option)
        {
            Editable = false;
            NotBlank = false;
            OptionCaption = 'Stage,Unit/Subject,Supplementary,Retake';
            OptionMembers = Stage,"Unit/Subject",Supplementary,Retake;
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
        field(50091; "Class Code"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Course Classes".Code;
            trigger OnValidate()
            var
                TT: record "Time Table";
                StudentUnitBasket: Record "Student Unit Basket";
            begin
                TT.reset;
                TT.setrange(Unit, Unit);
                TT.setrange(Semester, Semester);
                TT.setrange("Campus Code", Campus);
                TT.setrange("Unit Class", "Class Code");
                TT.setrange("Day of Week", "Day Code");
                TT.setrange(Period, "Period Code");
                if TT.find('-') then begin
                    StudentUnitBasket.Reset;
                    StudentUnitBasket.SetRange(StudentUnitBasket.Semester, Semester);
                    StudentUnitBasket.SetRange(StudentUnitBasket."Student No.", "Student No.");
                    StudentUnitBasket.SetRange(StudentUnitBasket."Day Code", TT."Day of Week");
                    StudentUnitBasket.SetRange(StudentUnitBasket."Period Code", TT.Period);
                    if StudentUnitBasket.Find('-') then begin
                        error('Time table Conflict in Unit ' + unit + ' and ' + StudentUnitBasket.Unit);
                    end;
                end;
                TT.reset();
                TT.setrange(Unit, Unit);
                TT.setrange(Semester, Semester);
                TT.setrange("Campus Code", campus);
                TT.setrange("Unit Class", "Class Code");
                if TT.find('-') then begin
                    "Day Code" := TT."Day of Week";
                    "Period Code" := TT.Period;
                end;
            end;
        }
        field(50092; "Mode of Study"; code[20])
        {
            TableRelation = "Student Types";
        }
        field(50192; "Campus"; code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(50877; "Unit Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Core,Elective,Required,Free Elective,General Education';
            OptionMembers = Core,Elective,Required,"Free Elective","General Education";
        }
        field(50093; Attachment; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Units/Subjects".Attachment WHERE("Programme Code" = FIELD(Programme), Code = FIELD(Unit)));
        }
        field(50094; "Dissertation Unit"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Units/Subjects".Dissertation WHERE("Programme Code" = FIELD(Programme), Code = FIELD(Unit)));
        }
        field(50095; "CF Count"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Courses Master".Units WHERE(Code = FIELD(Unit)));

        }
        field(50096; "Charge CF"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Courses Master"."Charge Credits" WHERE(Code = FIELD(Unit)));

        }
        field(50097; "Audit"; Boolean) { }
        field(50098; "No Of Units"; Decimal) { }
        field(50099; "Day Code"; code[20]) { }
        field(50199; "Period Code"; code[20]) { }
    }

    keys
    {
        key(Key1; Programme, Stage, Unit, Semester, "Reg. Transacton ID", "Student No.", "Register for")
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
    trigger OnInsert()
    var

    begin

    end;

    procedure GetGrade(Marks: Decimal; UnitG: Code[20]; Studprog: Code[20]; StudStage: Code[20]) xGrade: Text[100]
    begin
    end;

    procedure GetGradeStatus(AvMarks: Decimal; ProgCode: Code[20]; Unit: Code[20]; StudStage: Code[20]) F: Boolean
    begin
    end;
}

