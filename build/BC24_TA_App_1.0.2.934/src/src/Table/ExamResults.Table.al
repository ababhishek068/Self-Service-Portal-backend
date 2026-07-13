Table 50043 "Exam Results"
{
    DrillDownPageID = "Exam Results List";
    LookupPageID = "Exam Results List";

    fields
    {
        field(1; Programme; Code[20])
        {

            TableRelation = Programme.Code;
        }
        field(2; Stage; Code[20])
        {

            TableRelation = "Programme Stages".Code where("Programme Code" = field(Programme));
        }
        field(3; Unit; Code[20])
        {
            NotBlank = true;
            TableRelation = "Units/Subjects".Code;
        }
        field(4; Semester; Code[20])
        {
            NotBlank = true;
            TableRelation = Semesters;
        }
        field(5; Score; Decimal)
        {
            Editable = false;
            NotBlank = true;

            trigger OnValidate()
            begin
                TestField(Programme);
                TestField("Student No.");
                TestField(Semester);
                // TestField(Stage);
                TestField(Unit);

                UnitsRec.Reset;
                UnitsRec.SetRange(UnitsRec."Programme Code", Programme);
                UnitsRec.SetRange(UnitsRec.Code, Unit);
                if UnitsRec.Find('-') then
                    ExamCat := UnitsRec."Default Exam Category";

                if ExamCat = '' then
                    if prog.Get(Programme) then
                        ExamCat := prog."Exam Category";

                if ExamCat = '' then Error('Please specify the Exam Category in the Programme Setup');
                Contribution := Score;
                Percentage := Score;

                /*
                SExams.RESET;
                SExams.SETRANGE(SExams.Category,ExamCat);
                SExams.SETRANGE(SExams.Code,ExamType);
                IF SExams.FIND('-') THEN BEGIN
                IF Score > SExams."Max. Score" THEN
                ERROR('Score can not be greater than the maximum score.');
                IF Score > 0 THEN BEGIN
                Percentage:=(Score/SExams."Max. Score")*100;
                Contribution:=Percentage*(SExams."% Contrib. Final Score"/100);
                END;
                END;
                */
                //ExamsProcessing.UpdateStudentUnits("Student No.",Programme,Semester,Stage,Unit);

            end;
        }
        field(6; Exam; Code[20]) { }
        field(7; "Reg. Transaction ID"; Code[20])
        {
            TableRelation = "Student Units"."Reg. Transacton ID" where("Reg. Transacton ID" = field("Reg. Transaction ID"),
                                                                        "Student No." = field("Student No."));
        }
        field(8; "Student No."; Code[30])
        {
            Editable = false;
            TableRelation = Customer."No.";
        }
        field(9; Grade; Code[20]) { }
        field(10; Percentage; Decimal) { }
        field(11; Contribution; Decimal)
        {
            Editable = false;
        }
        field(12; "No Registration"; Boolean) { }
        field(13; "System Created"; Boolean) { }
        field(15; "Re-Sit"; Boolean)
        {
            CalcFormula = lookup("Student Units"."Supp Taken" where("Student No." = field("Student No."),
                                                                     Programme = field(Programme),
                                                                     Semester = field(Semester),
                                                                     Stage = field(Stage),
                                                                     Unit = field(Unit),
                                                                     "Reg. Transacton ID" = field("Reg. Transaction ID")));
            Description = 'FlowField From Students Units';
            FieldClass = FlowField;
        }
        field(16; "Re-Sited"; Boolean)
        {
            Description = 'Updated By Re-Sit FlowField to be used as key';
        }
        field(17; "Repeated Score"; Decimal) { }
        field(18; "Exam Category"; Code[50]) { }
        field(19; ExamType; Code[20]) { }
        field(20; "Admission No"; Code[20]) { }
        field(21; SN; Boolean) { }
        field(22; Reported; Boolean) { }
        field(23; "Lecturer Names"; Text[250]) { }
        field(24; UserID; Code[50]) { }
        field(50001; "Original Score"; Decimal) { }
        field(50002; "Last Edited By"; Code[20]) { }
        field(50003; "Last Edited On"; Date) { }
        field(50004; Submitted; Boolean) { }
        field(50005; "Submitted On"; Date) { }
        field(50006; "Submitted By"; Code[20]) { }
        field(50007; Category; Code[80]) { }
        field(50008; Department; Code[20]) { }
        field(50009; "Original Contribution"; Decimal) { }
        field(50012; "Semester Total"; Decimal)
        {
            CalcFormula = sum("Exam Results".Contribution where("Student No." = field("Student No."),
                                                                 Semester = field(Semester),
                                                                 Unit = field(Unit),
                                                                 Programme = field(Programme)));
            FieldClass = FlowField;
        }
        field(50013; "Attachment Unit"; Boolean)
        {
            CalcFormula = lookup("Units/Subjects".Attachment where("Programme Code" = field(Programme),
                                                                    Code = field(Unit)));
            FieldClass = FlowField;
        }
        field(50014; "Re-Take"; Boolean)
        {
            CalcFormula = lookup("Student Units"."Re-Take" where("Reg. Transacton ID" = field("Reg. Transaction ID"),
                                                                  "Student No." = field("Student No."),
                                                                  Unit = field(Unit)));
            FieldClass = FlowField;
        }
        field(50015; Cancelled; Boolean) { }
        field(50016; "Cancelled By"; Code[20]) { }
        field(50017; "Cancelled Date"; Date) { }
        field(50018; "Academic Year"; Code[20])
        {
            TableRelation = "Academic Year".Code;
        }
        field(50019; "Entry No"; Integer) { }
        field(50020; "GPA Points"; Decimal) { }
        field(50021; "Credit Hours"; Decimal) { }
        field(50022; "Student Names"; Text[100]) { }
        field(50122; "Unit Description"; Text[100]) { }
        field(50023; CAT1; Decimal) { }
        field(50024; CAT2; Decimal) { }
        field(50025; ASN1; Decimal) { }
        field(50026; ASN2; Decimal) { }
        field(50027; "Creg Stage"; Code[20]) { }
        field(50028; "Entry Count"; Integer)
        {
            CalcFormula = count("Exam Results" where(Programme = field(Programme),
                                                      Unit = field(Unit),
                                                      Semester = field(Semester),
                                                      Exam = field(Exam),
                                                      "Student No." = field("Student No."),
                                                      Cancelled = field(Cancelled)));
            FieldClass = FlowField;
        }
        field(50029; "Settlement Type Lk"; Code[20])
        {
            CalcFormula = lookup("Course Registration"."Settlement Type" where("Student No." = field("Student No."),
                                                                                Reversed = const(false)));
            FieldClass = FlowField;
        }
        field(50030; "Settlement Tyoe"; Code[20]) { }
        field(50031; "Cancelled Remarks"; Text[150]) { }
        field(50032; Remarks; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50033; "Academic YearLk"; Code[20])
        {
            CalcFormula = lookup("Student Units"."Academic Year" where("Student No." = field("Student No."),
                                                                        Unit = field(Unit)));
            FieldClass = FlowField;
        }
        field(50034; "Stud Unit Count"; Integer)
        {
            CalcFormula = count("Student Units" where("Student No." = field("Student No."),
                                                       Unit = field(Unit),
                                                       Programme = field(Programme),
                                                       Stage = field(Stage)));
            FieldClass = FlowField;
        }
        field(50035; "Stud Programme"; Code[20])
        {
            CalcFormula = lookup("Course Registration".Programme where("Student No." = field("Student No."),
                                                                        Reversed = const(false)));
            FieldClass = FlowField;
        }
        field(50036; "Campus Code"; Code[20])
        {
            CalcFormula = lookup(Customer."Global Dimension 1 Code" where("No." = field("Student No.")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Student No.", Programme, Stage, Unit, Semester, ExamType, "Reg. Transaction ID", Exam, "Entry No")
        {
            Clustered = true;
            SumIndexFields = Score, Contribution;
        }
        key(Key2; "Reg. Transaction ID", "Student No.", Programme, Unit)
        {
            SumIndexFields = Score, Contribution;
        }
        key(Key3; "Student No.", Programme, Stage, Unit, Semester, Exam, "Reg. Transaction ID", "Re-Sited")
        {
            SumIndexFields = Score, Contribution;
        }
    }

    fieldgroups { }

    trigger OnDelete()
    begin
        Error('Please note that modification of results is not allowed');
    end;

    trigger OnModify()
    begin
        // ERROR('Please note that modification of results is not allowed');
    end;

    var
        prog: Record Programme;
        UnitsRec: Record "Units/Subjects";
        ExamCat: Code[20];

    procedure GetGrade(CAT1: Decimal; CAT2: Decimal; FinalM: Decimal; prog: Code[100]) xGrade: Text[100]
    var
        ProgrammeRec: Record Programme;
        LastGrade: Code[20];
        LastRemark: Code[20];
        ExitDo: Boolean;
        LastScore: Decimal;
        Gradings: Record "Grading System Setup";
        Grade: Code[20];
        GradeCategory: Code[50];
        Marks: Decimal;
    begin
        GradeCategory := '';
        Clear(Marks);
        ProgrammeRec.Reset;
        if ProgrammeRec.Get(prog) then
            GradeCategory := ProgrammeRec."Exam Category";
        if GradeCategory = '' then Error('Please note that you must specify Exam Category in Programme Setup');
        xGrade := '';
        if CAT1 + CAT2 + FinalM > 0 then begin
            Marks := CAT1 + CAT2 + FinalM;
            Gradings.Reset;
            Gradings.SetRange(Gradings.Category, GradeCategory);
            LastGrade := '';
            LastRemark := '';
            LastScore := 0;
            if Gradings.Find('-') then begin
                ExitDo := false;
                repeat
                    LastScore := Gradings."Up to";
                    if Marks < LastScore then begin
                        if ExitDo = false then begin
                            xGrade := Gradings.Grade;
                            if Gradings.Failed = false then
                                LastRemark := 'PASS'
                            else
                                LastRemark := 'FAIL';
                            ExitDo := true;
                        end;
                    end;

                until Gradings.Next = 0;


            end;

        end else begin
            Grade := '';
            //Remarks:='Not Done';
        end;

        if ((CAT1 = 0) and (CAT2 = 0) and (FinalM = 0)) then
            xGrade := '?' else
            if ((CAT1 = 0) or (CAT2 = 0) or (FinalM = 0)) then xGrade := '!'
    end;
}

