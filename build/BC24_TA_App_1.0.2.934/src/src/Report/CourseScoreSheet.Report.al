Report 50097 "Course Score Sheet"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/CourseScoreSheet.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Student Units"; "Student Units")
        {
            RequestFilterFields = Programme, Stage, Semester, Unit, "Campus Code", "Student No.";
            column(ReportForNavId_1; 1) { }
            column(StudentNo_StudentUnits; "Student Units"."Student No.") { }
            column(StudentName_StudentUnits; "Student Units"."Student Name") { }
            column(ExamMarks_StudentUnits; ExamScore) { }
            column(CATTotalMarks_StudentUnits; "Student Units"."CAT Total Marks") { }
            column(CAT_1; "CAT-1") { }
            column(CAT_2; "CAT-2") { }
            column(TotalScore_StudentUnits; "Student Units"."Total Score") { }
            column(GradePrefix_StudentUnits; "Student Units"."Grade Prefix") { }
            column(Grade_StudentUnits; "Student Units".Grade) { }
            column(Result_Status; "Result Status") { }
            column(Campus_Code; "Campus Code") { }
            column(CompName; CompInf.Name) { }
            column(Logo; CompInf.Picture) { }
            column(UnitName; UnitName) { }
            column(ProgName; Prog.Description) { }
            column(Unit_StudentUnits; "Student Units".Unit) { }
            column(ExamScore; ExamScore) { }
            column(Semester; Semester) { }

            trigger OnAfterGetRecord()
            begin
                UnitsRec.Reset;
                UnitsRec.SetRange(Code, "Student Units".Unit);
                UnitsRec.SetRange("Programme Code", "Student Units".Programme);
                if UnitsRec.Find('-') then begin
                    UnitName := UnitsRec.Desription;
                end;
                if Prog.Get("Student Units".Programme) then;

                "Student Units".CalcFields("CAT Total Marks");
                "Student Units".CalcFields("Exam Marks");
                ExamScore := "Student Units"."Exam Marks";
                if ("Student Units"."CAT Total Marks" = 0) and ("Student Units"."Grade Prefix" = '') then
                    ExamScore := 0;

                ProcM.UpdateStudentUnits("Student Units"."Student No.", "Student Units".Programme, "Student Units".Semester, "Student Units".Stage, "Student Units".Unit);
            end;

            trigger OnPreDataItem()
            begin
                CompInf.Get;
                CompInf.CalcFields(Picture);
            end;
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }

    var
        CompInf: Record "Company Information";
        UnitsRec: Record "Units/Subjects";
        Prog: Record Programme;
        UnitName: Text[100];
        ExamScore: Decimal;
        ProcM: Codeunit "Exams Processing";
}

