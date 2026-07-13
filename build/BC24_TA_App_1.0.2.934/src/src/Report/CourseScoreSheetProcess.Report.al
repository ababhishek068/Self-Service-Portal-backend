Report 50301 "Course Score Sheet Process"
{
    ProcessingOnly = true;
    ApplicationArea = All;

    dataset
    {
        dataitem("Student Units"; "Student Units")
        {
            DataItemTableView = sorting("Semester") order(ascending) where("Exam Category" = filter(<> ''));
            RequestFilterFields = Programme, Stage, Semester, Unit, "Student No.";
            column(ReportForNavId_1; 1) { }
            column(StudentNo_StudentUnits; "Student Units"."Student No.") { }
            column(StudentName_StudentUnits; "Student Units"."Student Name") { }
            column(ExamMarks_StudentUnits; ExamScore) { }
            column(CATTotalMarks_StudentUnits; "Student Units"."CAT Total Marks") { }
            column(TotalScore_StudentUnits; "Student Units"."Total Score") { }
            column(GradePrefix_StudentUnits; "Student Units"."Grade Prefix") { }
            column(Grade_StudentUnits; "Student Units".Grade) { }
            column(CompName; CompInf.Name) { }
            column(Logo; CompInf.Picture) { }
            column(UnitName; UnitName) { }
            column(ProgName; Prog.Description) { }
            column(Unit_StudentUnits; "Student Units".Unit) { }
            column(ExamScore; ExamScore) { }

            trigger OnAfterGetRecord()
            begin
                /*
                UnitsRec.RESET;
                UnitsRec.SETRANGE(Code,"Student Units".Unit);
                UnitsRec.SETRANGE("Programme Code","Student Units".Programme);
                IF UnitsRec.FIND('-') THEN BEGIN
                    UnitName:=UnitsRec.Desription;
                END;
                IF Prog.GET("Student Units".Programme) THEN;
                
                "Student Units".CALCFIELDS("CAT Total Marks");
                "Student Units".CALCFIELDS("Exam Marks");
                ExamScore:="Student Units"."Exam Marks";
                IF ("Student Units"."CAT Total Marks"=0) AND ("Student Units"."Grade Prefix"='') THEN
                  ExamScore:=0;
                */
                "Student Units".CalcFields("Total Score");
                //IF "Student Units"."Total Score"<>"Student Units"."Final Score" THEN
                ProcM.UpdateStudentUnits("Student Units"."Student No.", "Student Units".Programme, "Student Units".Semester, "Student Units".Stage, "Student Units".Unit);

            end;

            trigger OnPostDataItem()
            begin
                Message('Success')
            end;

            trigger OnPreDataItem()
            begin
                //C//ompInf.GET;
                ///CompInf.CALCFIELDS(Picture);
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
        Prog: Record Programme;
        UnitName: Text[100];
        ExamScore: Decimal;
        ProcM: Codeunit "Exams Processing";
}

