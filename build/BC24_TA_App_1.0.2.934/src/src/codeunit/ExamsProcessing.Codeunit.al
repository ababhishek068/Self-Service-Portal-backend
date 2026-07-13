Codeunit 50003 "Exams Processing"
{

    trigger OnRun()
    begin
    end;

    procedure UpdateStudentUnits(StudNo: Code[20]; Prog: Code[20]; Sem: Code[20]; Stag: Code[20]; Unt: Code[20])
    var
        ProgrammeRec: Record Programme;
        StudUnits: Record "Student Units";
        StudUnits1: Record "Student Units";
        StudAudit: Record "Student Units Audit";
        StudUnits2: Record "Student Units";
        EResults: Record "Exam Results";
        "Units/Subj": Record "Units/Subjects";
        Generalsetup: Record "General Set-Up";
        SemRec: Record Semesters;
        AllowedGrades: Record "Allowed Grades";
    begin
        Generalsetup.get;
        ProgrammeRec.get(Prog);
        SemRec.get(sem);
        if SemRec."BackLog Marks" = false then begin
            StudUnits.Reset;
            StudUnits.SetRange(StudUnits."Student No.", StudNo);
            StudUnits.SetRange(StudUnits.Programme, Prog);
            StudUnits.SetRange(StudUnits.Stage, Stag);
            // StudUnits.SETRANGE(StudUnits.Semester,Sem);
            if Unt <> '' then
                StudUnits.SetRange(StudUnits.Unit, Unt);
            if StudUnits.Find('-') then begin
                repeat
                    "Units/Subj".Reset;
                    "Units/Subj".SetRange("Units/Subj"."Programme Code", StudUnits.Programme);
                    "Units/Subj".SetRange("Units/Subj".Code, StudUnits.Unit);
                    // "Units/Subj".SETRANGE("Units/Subj"."Stage Code",StudUnits.Stage);
                    if "Units/Subj".Find('-') then begin
                        StudUnits.Description := "Units/Subj".Desription;
                        StudUnits."No. Of Units" := "Units/Subj"."No. Units";
                        // StudUnits."No. Of Units":=3;
                    end;
                    StudUnits.CalcFields(StudUnits."Total Score");
                    StudUnits.CalcFields(StudUnits."Ignore in Final Average");
                    StudUnits."Final Score" := StudUnits."Total Score";
                    StudUnits."Ignore in Cumm  Average" := StudUnits."Ignore in Final Average";
                    if StudUnits."Total Score" > 100 then Error('Invalid marks detected for unit ' + Unt + ' ' + Format(StudUnits."Total Score") + ' for Student No. ' + StudUnits."Student No.");
                    StudUnits."Final Score" := StudUnits."Total Score";
                    StudUnits."CF Score" := StudUnits."Total Score" * StudUnits."No. Of Units";
                    StudUnits.Grade := GetGrade(StudUnits."Total Score", StudUnits.Unit, StudUnits.Programme, StudUnits.Stage);
                    StudUnits.GPA := GetGPA(StudUnits."Total Score", StudUnits.Unit, StudUnits.Programme, StudUnits.Stage);
                    StudUnits."CF GPA" := StudUnits.GPA * StudUnits."No. Of Units";
                    if (GetGradeStatus(StudUnits."Total Score", StudUnits.Programme, StudUnits.Unit, StudUnits.Stage) = true) or (StudUnits."Grade Prefix" <> '') then begin
                        StudUnits."Result Status" := 'FAIL';
                        StudUnits.Failed := true;
                        StudUnits."Exam Remarks" := 'Failing Grade';
                    end else begin
                        StudUnits."Result Status" := 'PASS';
                        StudUnits.Failed := false;
                        StudUnits."Exam Remarks" := 'Pass';
                    end;
                    if StudUnits."Total Score" = 0 then StudUnits."Result Status" := 'FAIL';

                    if Generalsetup."Class Attendance Mandatory" = true then begin
                        StudUnits.calcfields("Attendance Present Count");
                        StudUnits.calcfields("Attendance Total Count");
                        if (StudUnits."Attendance Present Count" > 0) and (StudUnits."Attendance Total Count" > 0) then begin
                            if (StudUnits."Attendance Present Count" / StudUnits."Attendance Total Count") * 100 < ProgrammeRec."Minimum Class Attendance %" then begin
                                StudUnits."Result Status" := 'FAIL';
                                StudUnits.Failed := true;
                                StudUnits.Grade := 'E';
                                StudUnits."Exam Remarks" := 'Low Class Attendance';
                            end;
                        end;
                        if (StudUnits."Attendance Present Count" = 0) then begin
                            StudUnits."Result Status" := 'FAIL';
                            StudUnits.Failed := true;
                            StudUnits.Grade := 'Z';
                            StudUnits."Exam Remarks" := 'Zero Class Attendance';
                        end;
                    end;
                    StudUnits.Modify;

                    // Update Supplimentary
                    if StudUnits."Register for" = StudUnits."register for"::Supplementary then begin
                        StudUnits2.Reset;
                        StudUnits2.SetRange(StudUnits2."Student No.", StudUnits."Student No.");
                        StudUnits2.SetRange(StudUnits2.Unit, StudUnits.Unit);
                        StudUnits2.SetRange(StudUnits2."Re-Take", true);
                        StudUnits2.SetRange(StudUnits2."Supp Taken", false);
                        if Unt <> '' then
                            StudUnits2.SetRange(StudUnits2.Unit, Unt);
                        if StudUnits2.Find('-') then begin
                            repeat
                                StudUnits2."Supp Taken" := true;
                                StudUnits2.Modify;
                            until StudUnits2.Next = 0;
                        end;
                    end;

                    EResults.Reset;
                    EResults.SetRange(EResults."Student No.", StudUnits."Student No.");
                    EResults.SetRange(EResults.Unit, StudUnits.Unit);
                    EResults.SetRange(EResults.Programme, StudUnits.Programme);
                    EResults.SetRange(EResults.Stage, StudUnits.Stage);
                    EResults.SetRange(EResults.Semester, StudUnits.Semester);
                    EResults.SetRange(EResults."Re-Take", true);
                    if Unt <> '' then EResults.SetRange(EResults.Unit, Unt);

                    if EResults.Find('-') then begin
                        repeat
                            EResults.CalcFields(EResults."Re-Sit");
                            EResults."Re-Sited" := EResults."Re-Sit";
                            EResults.Modify;
                        until EResults.Next = 0;
                    end;

                    StudAudit.Reset;
                    StudAudit.SetRange(StudAudit."Student No.", StudNo);
                    StudAudit.SetRange(StudAudit.unit, unt);
                    if StudAudit.find('-') then begin
                        StudAudit."Semester Completed" := StudUnits.Semester;
                        StudAudit.Grade := StudUnits.Grade;
                        StudAudit."Final Score" := StudUnits."Final Score";
                        StudAudit.GPA := StudUnits.GPA;
                        StudAudit."Exam Remarks" := StudUnits."Exam Remarks";
                        if StudUnits."Result Status" = 'FAIL' then
                            StudAudit."Progress Status" := StudAudit."Progress Status"::Unfulfilled
                        else
                            StudAudit."Progress Status" := StudAudit."Progress Status"::Completed;

                        StudAudit.modify;
                    end;
                    Commit();

                    StudUnits1.Reset;
                    StudUnits1.SetRange(StudUnits1."Student No.", StudNo);
                    StudUnits1.SetRange(StudUnits1.Programme, Prog);
                    StudUnits1.SetRange(StudUnits1.Stage, Stag);
                    StudUnits1.SetRange(StudUnits1.Unit, Unt);
                    StudUnits1.SetFilter(StudUnits1.Grade, '=%1', '');
                    StudUnits1.SetFilter(StudUnits1."Grade Prefix", '<>%1', '');
                    if StudUnits1.Find('-') then begin
                        StudUnits1.Grade := StudUnits1."Grade Prefix";
                        AllowedGrades.Reset();
                        AllowedGrades.SetRange(Code, StudUnits1."Grade Prefix");
                        AllowedGrades.SetRange(Fail, false);
                        if AllowedGrades.Find('-') then
                            StudUnits1.Failed := false;
                        StudUnits1.Modify();
                    end
                until StudUnits.Next = 0;
            end;
        end;
    end;

    procedure UpdateCourseReg(StudNo: Code[20]; Prog: Code[20]; Stag: Code[20]; Sem: Code[20])
    var
        Creg: Record "Course Registration";
        XC: Code[20];
    begin
        Creg.Reset;
        Creg.SetRange(Creg."Student No.", StudNo);
        Creg.SetRange(Creg.Programme, Prog);
        Creg.SetRange(Creg.Semester, Sem);
        Creg.SetRange(Creg.Stage, Stag);
        Creg.SetFilter(Creg."Stage Filter", Stag);
        Creg.SetFilter(Creg."Semester Filter", Sem);
        if Creg.Find('-') then begin
            repeat
                Creg.CalcFields(Creg."CF Count");
                Creg.CalcFields(Creg."CF Total Score");
                if (Creg."CF Count" <> 0) and (Creg."CF Total Score" <> 0) then begin
                    Creg."Cumm Score" := Creg."CF Total Score" / Creg."CF Count";
                    Creg."Cumm Grade" := GetGrade((Creg."CF Total Score" / Creg."CF Count"), XC, Prog, XC);
                end;
                Creg.Modify;
            until Creg.Next = 0;
        end;


        Creg.Reset;
        Creg.SetRange(Creg."Student No.", StudNo);
        Creg.SetRange(Creg.Programme, Prog);
        Creg.SetFilter(Creg."Stage Filter", Stag);
        Creg.SetFilter(Creg."Semester Filter", Sem);
        if Creg.Find('-') then begin
            repeat
                Creg.CalcFields(Creg."CF Count");
                Creg.CalcFields(Creg."CF Total Score");
                Creg.CalcFields(Creg."Cum Units Done");
                Creg.CalcFields(Creg."Cum Units Passed");
                Creg.CalcFields(Creg."Cum Units Failed");
                Creg."Exam Status" := 'FAIL';
                if (Creg."CF Total Score" > 0) and (Creg."CF Count" > 0) then begin
                    Creg."Current Cumm Score" := Creg."CF Total Score" / Creg."CF Count";
                    Creg."Current Cumm Grade" := GetGrade((Creg."CF Total Score" / Creg."CF Count"), XC, Prog, XC);
                end;
                if GetGradeStatus(Creg."Current Cumm Score", Prog, XC, XC) = true then begin
                    Creg."Exam Status" := 'FAIL'
                end else begin
                    if (Creg."Cum Units Done" = Creg."Cum Units Passed") and (Creg."Cum Units Failed" = 0) then
                        Creg."Exam Status" := 'PASS';
                end;
                Creg.Modify;
            until Creg.Next = 0;
        end;
    end;

    procedure GetGrade(Marks: Decimal; UnitG: Code[20]; Studprog: Code[20]; StudStage: Code[20]) xGrade: Text[100]
    var
        UnitsRR: Record "Units/Subjects";
        ProgrammeRec: Record Programme;
        LastGrade: Code[20];
        LastRemark: Code[20];
        ExitDo: Boolean;
        LastScore: Decimal;
        Gradings: Record "Grading System Setup";
        GradeCategory: Code[20];
        Grade: Code[20];
    begin
        GradeCategory := '';
        UnitsRR.Reset;
        UnitsRR.SetRange(UnitsRR."Programme Code", Studprog);
        UnitsRR.SetRange(UnitsRR.Code, UnitG);
        UnitsRR.SetRange(UnitsRR."Stage Code", StudStage);
        if UnitsRR.Find('-') then begin
            if UnitsRR."Default Exam Category" <> '' then begin
                GradeCategory := UnitsRR."Default Exam Category";
            end;
        end;
        if GradeCategory = '' then begin
            ProgrammeRec.Reset;
            if ProgrammeRec.Get(Studprog) then
                GradeCategory := ProgrammeRec."Exam Category";
            if GradeCategory = '' then Error('Please note that you must specify Exam Category in Programme Setup');
        end;
        xGrade := '';
        if Marks > 0 then begin
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
    end;

    procedure GetGPA(Marks: Decimal; UnitG: Code[20]; Studprog: Code[20]; StudStage: Code[20]) xGPA: Decimal
    var
        UnitsRR: Record "Units/Subjects";
        ProgrammeRec: Record Programme;
        LastGrade: Code[20];
        LastRemark: Code[20];
        ExitDo: Boolean;
        LastScore: Decimal;
        Gradings: Record "Grading System Setup";
        GradeCategory: Code[20];
        Grade: Code[20];
    begin
        GradeCategory := '';
        UnitsRR.Reset;
        UnitsRR.SetRange(UnitsRR."Programme Code", Studprog);
        UnitsRR.SetRange(UnitsRR.Code, UnitG);
        UnitsRR.SetRange(UnitsRR."Stage Code", StudStage);
        if UnitsRR.Find('-') then begin
            if UnitsRR."Default Exam Category" <> '' then begin
                GradeCategory := UnitsRR."Default Exam Category";
            end;
        end;
        if GradeCategory = '' then begin
            ProgrammeRec.Reset;
            if ProgrammeRec.Get(Studprog) then
                GradeCategory := ProgrammeRec."Exam Category";
            if GradeCategory = '' then Error('Please note that you must specify Exam Category in Programme Setup');
        end;
        xGPA := 0;
        if Marks > 0 then begin
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
                            xGPA := Gradings."GPA Points";
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
    end;

    procedure GetGradeStatus(var AvMarks: Decimal; var ProgCode: Code[20]; var Unit: Code[20]; StudStage: Code[20]) F: Boolean
    var
        LastGrade: Code[20];
        LastRemark: Code[20];
        ExitDo: Boolean;
        LastScore: Decimal;
        Gradings: Record "Grading System Setup";
        ProgrammeRec: Record Programme;
        Grd: Code[80];
        GradeCategory: Code[20];
        UnitsRR: Record "Units/Subjects";
    begin
        F := false;

        GradeCategory := '';
        UnitsRR.Reset;
        UnitsRR.SetRange(UnitsRR."Programme Code", ProgCode);
        UnitsRR.SetRange(UnitsRR.Code, Unit);
        UnitsRR.SetRange(UnitsRR."Stage Code", StudStage);
        if UnitsRR.Find('-') then begin
            if UnitsRR."Default Exam Category" <> '' then begin
                GradeCategory := UnitsRR."Default Exam Category";
            end else begin
                ProgrammeRec.Reset;
                if ProgrammeRec.Get(ProgCode) then
                    GradeCategory := ProgrammeRec."Exam Category";
                if GradeCategory = '' then Error('Please note that you must specify Exam Category in Programme Setup');
            end;
        end;

        if AvMarks > 0 then begin
            Gradings.Reset;
            Gradings.SetRange(Gradings.Category, GradeCategory);
            LastGrade := '';
            LastRemark := '';
            LastScore := 0;
            if Gradings.Find('-') then begin
                ExitDo := false;
                repeat
                    LastScore := Gradings."Up to";
                    if AvMarks < LastScore then begin
                        if ExitDo = false then begin
                            Grd := Gradings.Grade;
                            F := Gradings.Failed;
                            ExitDo := true;
                        end;
                    end;

                until Gradings.Next = 0;


            end;

        end else begin


        end;
    end;

    procedure UpdateStudentUnits_Buffer(StudNo: Code[20]; Prog: Code[20]; Sem: Code[20]; Stag: Code[20]; Unt: Code[20])
    var
        StudUnits: Record "Student Units Buffer";
        StudUnits2: Record "Student Units Buffer";
        EResults: Record "Exam Results";
        "Units/Subj": Record "Units/Subjects";
    begin
        StudUnits.Reset;
        StudUnits.SetRange(StudUnits."Student No.", StudNo);
        StudUnits.SetRange(StudUnits.Programme, Prog);
        StudUnits.SetRange(StudUnits.Stage, Stag);
        // StudUnits.SETRANGE(StudUnits.Semester,Sem);
        if Unt <> '' then
            StudUnits.SetRange(StudUnits.Unit, Unt);
        if StudUnits.Find('-') then begin
            repeat
                "Units/Subj".Reset;
                "Units/Subj".SetRange("Units/Subj"."Programme Code", StudUnits.Programme);
                "Units/Subj".SetRange("Units/Subj".Code, StudUnits.Unit);
                // "Units/Subj".SETRANGE("Units/Subj"."Stage Code",StudUnits.Stage);
                if "Units/Subj".Find('-') then begin
                    StudUnits.Description := "Units/Subj".Desription;
                    StudUnits."No. Of Units" := "Units/Subj"."No. Units";
                    // StudUnits."No. Of Units":=3;
                end;
                StudUnits.CalcFields(StudUnits."Total Score");
                StudUnits.CalcFields(StudUnits."Ignore in Final Average");
                StudUnits."Final Score" := StudUnits."Total Score";
                StudUnits."Ignore in Cumm  Average" := StudUnits."Ignore in Final Average";
                if StudUnits."Total Score" > 100 then Error('Invalid marks detected for unit ' + Unt + ' ' + Format(StudUnits."Total Score"));
                StudUnits."Final Score" := StudUnits."Total Score";
                StudUnits."CF Score" := StudUnits."Total Score" * StudUnits."No. Of Units";
                StudUnits.Grade := GetGrade(StudUnits."Total Score", StudUnits.Unit, StudUnits.Programme, StudUnits.Stage);

                if (GetGradeStatus(StudUnits."Total Score", StudUnits.Programme, StudUnits.Unit, StudUnits.Stage) = true) or (StudUnits."Grade Prefix" <> '') then begin
                    StudUnits."Result Status" := 'FAIL';
                    StudUnits.Failed := true;
                end else begin
                    StudUnits."Result Status" := 'PASS';
                    StudUnits.Failed := false;
                end;
                if StudUnits."Total Score" = 0 then StudUnits."Result Status" := 'FAIL';
                StudUnits.Modify;

                // Update Supplimentary
                if StudUnits."Register for" = StudUnits."register for"::Supplementary then begin
                    StudUnits2.Reset;
                    StudUnits2.SetRange(StudUnits2."Student No.", StudUnits."Student No.");
                    StudUnits2.SetRange(StudUnits2.Unit, StudUnits.Unit);
                    StudUnits2.SetRange(StudUnits2."Re-Take", true);
                    StudUnits2.SetRange(StudUnits2."Supp Taken", false);
                    if Unt <> '' then
                        StudUnits2.SetRange(StudUnits2.Unit, Unt);
                    if StudUnits2.Find('-') then begin
                        repeat
                            StudUnits2."Supp Taken" := true;
                            StudUnits2.Modify;
                        until StudUnits2.Next = 0;
                    end;
                end;

                EResults.Reset;
                EResults.SetRange(EResults."Student No.", StudUnits."Student No.");
                EResults.SetRange(EResults.Unit, StudUnits.Unit);
                EResults.SetRange(EResults.Programme, StudUnits.Programme);
                EResults.SetRange(EResults.Stage, StudUnits.Stage);
                EResults.SetRange(EResults.Semester, StudUnits.Semester);
                EResults.SetRange(EResults."Re-Take", true);
                if Unt <> '' then EResults.SetRange(EResults.Unit, Unt);

                if EResults.Find('-') then begin
                    repeat
                        EResults.CalcFields(EResults."Re-Sit");
                        EResults."Re-Sited" := EResults."Re-Sit";
                        EResults.Modify;
                    until EResults.Next = 0;
                end;

            until StudUnits.Next = 0;
        end;
    end;
}

