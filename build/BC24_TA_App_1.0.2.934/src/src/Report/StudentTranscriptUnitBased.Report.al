Report 50302 "Student Transcript Unit Based"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/StudentResultsSlip.rdlc';
    ApplicationArea = All;

    dataset
    {

        dataitem("Student Units"; "Student Units")
        {

            DataItemTableView = where(Released = const(true));
            RequestFilterFields = "Student No.", Programme;
            column(ReportForNavId_1; 1) { }
            column(Stage_StudentUnits; "Student Units".Stage) { }
            column(StudentNo_StudentUnits; "Student Units"."Student No.") { }
            column(Unit_StudentUnits; "Student Units".Unit) { }
            column(UnitName_StudentUnits; UnitDesc) { }
            column(CATTotalMarks_StudentUnits; "Student Units"."CAT Total Marks") { }
            column(ExamMarks_StudentUnits; "Student Units"."Exam Marks") { }
            column(TotalScore_StudentUnits; "Student Units"."Total Score") { }
            column(Grade_StudentUnits; StudGrade) { }
            column(FinalScore_StudentUnits; "Student Units"."Final Score") { }
            column(Semester; Semester) { }
            column(No__Of_Units; "No. Of Units") { }
            column(CF_Lk; "CF Lk") { }
            column(Main_Programme; "Main Programme") { }
            column(Names; Names) { }
            column(CompName; CompInf.Name) { }
            column(Logo; CompInf.Picture) { }
            column(ProgName; ProgName) { }
            column(SchoolName; SchoolName) { }
            column(DateReg; DateReg) { }
            column(SemDesc; SemDesc) { }
            column(Allow_Online_Results_Semester; "Allow Online Results Semester") { }
            column(AverageGrade; AverageGrade) { }
            column(GPA; GPA) { }
            column(Supp_Taken; "Supp Taken") { }
            column(CF_GPA; "CF GPA") { }
            column(StudentStatus; StudentStatus) { }
            column(Intake; Intake) { }
            column(Left; Left) { }
            column(Final_Score; "Final Score") { }
            column(Grade_Prefix; "Grade Prefix") { }
            column(Re_Taken; "Re-Taken") { }
            column(AcademicYear; AcademicYear) { }
            column(SemCount; SemCount) { }
            column(Disable_Inc_Rule; "Disable Inc Rule") { }
            column(BacklogSemester; "Backlog Semester") { }
            column(GLabel1; GLabel[1]) { }
            column(GLabel2; GLabel[2]) { }
            column(GLabel3; GLabel[3]) { }
            column(GLabel4; GLabel[4]) { }
            column(GLabel5; GLabel[5]) { }
            column(GLabel6; GLabel[6]) { }
            column(GLabel7; GLabel[7]) { }
            column(GLabel8; GLabel[8]) { }
            column(GLabel9; GLabel[9]) { }
            column(GLabel10; GLabel[10]) { }
            column(GLabel11; GLabel[11]) { }
            column(GLabel12; GLabel[12]) { }
            column(GLabel13; GLabel[13]) { }
            column(GLabel14; GLabel[14]) { }
            column(GLabel15; GLabel[15]) { }

            trigger OnAfterGetRecord()
            var
                intakes: Record Intake;
                AcYr: Record "Academic Year";
            begin
                "Student Units".CalcFields("CAT Total Marks");
                "Student Units".CalcFields("Exam Marks");
                "Student Units".CalcFields("Unit Description");
                "Student Units".CalcFields("Main Programme");
                UnitDesc := "Student Units"."Unit Description";

                if "Grade Prefix" <> '' then
                    StudGrade := "Grade Prefix"
                else
                    StudGrade := "Grade";

                if "Student Units"."Unit Description" = '' then begin
                    UnitsRec.reset;
                    UnitsRec.setrange(Code, "Student Units".Unit);
                    if UnitsRec.find('-') then
                        UnitDesc := UnitsRec.Desription;
                end;

                if SemRec.get("Student Units".Semester) then begin
                    SemDesc := SemRec.Description;
                    SemCount := SemCount + 1;
                end;


                if Cust.Get("Student Units"."Student No.") then begin
                    Names := Cust.Name;
                    DateReg := cust."Date Registered";
                    StudentStatus := Format(Cust.Status);
                    StudProg := Cust."Current Programme";
                    // Left := Cust."Programme End Date";


                    if intakes.get(cust."Entry Intake") then begin
                        if intakes.Description = '' then
                            Intake := intakes.Code
                        else
                            Intake := intakes.Description;
                    end;
                end;
                StudProg := getfilter(Programme);
                if StudProg = '' then begin
                    if "Student Units"."Main Programme" <> '' then
                        StudProg := "Student Units"."Main Programme"
                    else
                        StudProg := "Student Units".Programme;
                end;
                if StudProg = '' then Error('Your current programme is not set');
                if Prog.Get(StudProg) then begin
                    ProgName := Prog.Description;
                    if Prog."School Code" <> '' then begin
                        DimRec.Reset();
                        dimrec.setrange(Code, prog."School Code");
                        dimrec.setrange("Dimension Code", 'SCHOOL');
                        if Dimrec.Find('-') then
                            SchoolName := Dimrec.Name;
                    end;
                end;
                ProcM.UpdateStudentUnits("Student Units"."Student No.", "Student Units".Programme, "Student Units".Semester, "Student Units".Stage, "Student Units".Unit);
                // if ("Student Units"."Final Score" > 0) then begin
                TotalMarks := TotalMarks + "Student Units"."Final Score";
                TotalUnits := TotalUnits + 1;
                if (TotalMarks > 0) and (TotalUnits > 0) then
                    AverageMarks := TotalMarks / TotalUnits;
                AverageGrade := ProcM.GetGrade(AverageMarks, '', "Student Units".Programme, '');
                //  end;
                GenerateGradeKey(StudProg);
                // end;
                AcYr.Reset();
                AcYr.SetRange(Current, true);
                if AcYr.Find('-') then
                    AcademicYear := AcYr.Code;

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
        Cust: Record Customer;
        Names: Text[100];
        ProcM: Codeunit "Exams Processing";
        CompInf: Record "Company Information";
        Prog: Record Programme;
        ProgName: text[100];
        DimRec: Record "Dimension Value";
        SchoolName: text[200];
        DateReg: date;
        Intake: Text;
        SemRec: Record Semesters;
        SemDesc: Text[200];
        SemCount: Integer;
        TotalUnits: Integer;
        TotalMarks: Decimal;
        AverageMarks: Decimal;
        AverageGrade: code[20];
        StudProg: code[20];
        StudentStatus: Text;
        UnitDesc: text[200];
        UnitsRec: record "Units/Subjects";
        Left: Date;
        StudGrade: code[20];
        AcademicYear: code[20];
        GLabel: array[100] of text[200];


    procedure GenerateGradeKey(Prog: code[20]);
    var
        Gradings: Record "Grading System Setup";
        ProgrammeRec: Record Programme;

        i: integer;
    begin
        ProgrammeRec.get(Prog);
        ProgrammeRec.TestField("Exam Category");
        gradings.reset;
        Gradings.setrange(Category, ProgrammeRec."Exam Category");
        Gradings.SetCurrentKey("Up to");
        Gradings.Ascending := false;
        if Gradings.find('-') then begin
            repeat
                i := i + 1;
                GLabel[i] := Gradings.Range + '   ' + Gradings.Grade + '  ' + Gradings.Description;
            until Gradings.next = 0;
        end;

    end;
}

