Report 50051 "Student Results Slip"
{
    DefaultLayout = RDLC;
    ApplicationArea = All;


    dataset
    {

        dataitem("Student Units"; "Student Units")
        {

            DataItemTableView = sorting("Semester") order(ascending) where(Released = const(true));
            RequestFilterFields = "Student No.", Programme;
            column(ReportForNavId_1; 1) { }
            column(Stage_StudentUnits; "Student Units".Stage) { }
            column(StudentNo_StudentUnits; "Student Units"."Student No.") { }
            column(Unit_StudentUnits; "Student Units".Unit) { }
            column(UnitName_StudentUnits; UnitDesc) { }
            column(CATTotalMarks_StudentUnits; "Student Units"."CAT Total Marks") { }
            column(ExamMarks_StudentUnits; "Student Units"."Exam Marks") { }
            column(TotalScore_StudentUnits; "Student Units"."Total Score") { }
            column(Grade_StudentUnits; "Student Units".Grade) { }
            column(FinalScore_StudentUnits; "Student Units"."Final Score") { }
            column(Semester; Semester) { }
            column(No__Of_Units; "No. Of Units") { }
            column(Main_Programme; "Main Programme") { }
            column(CF_Lk; "CF Lk") { }
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
            column(Grade_Prefix; "Grade Prefix") { }
            column(DOB; DOB) { }
            column(Stat; Stat) { }
            column(MainprogDesc; MainprogDesc) { }
            column(Re_Taken; "Re-Taken") { }
            column(CumGPA; CumGPA) { }
            column(Earned_Credits; "Earned Credits") { }
            column(Attempted_Credits; "Attempted Credits") { }
            column(Retaken_Credits; "Retaken Credits") { }
            column(Unit_Re_Taken_Count; "Unit Re-Taken Count") { }
            column(E_Credits; "E Credits") { }
            column(E_QP; "E QP") { }
            column(Retaken_QP; "Retaken QP") { }
            column(Retaken_Prev_Semester; "Retaken Prev.Semester") { }
            column(RetakenQP; RetakenQP) { }
            column(StudMajor; StudMajor) { }
            column(StudMinor; StudMinor) { }
            trigger OnAfterGetRecord()
            begin

                "Student Units".Setfilter("Semester Filter", '%1..%2', '', Semester);
                "Student Units".Setfilter("Prev. Semester Filter", '<%1', Semester);
                "Student Units".CalcFields("Retaken Prev.Semester");
                "Student Units".CalcFields("CAT Total Marks");
                "Student Units".CalcFields("Exam Marks");
                "Student Units".CalcFields("Unit Description");
                "Student Units".CalcFields("Main Programme");
                "Student Units".CalcFields("Unit Re-Taken Count");
                "Student Units".CalcFields("Retaken QP");
                UnitDesc := "Student Units"."Unit Description";

                RetakenQP := 0;
                StudUnits.reset;
                StudUnits.setrange("Student No.", "Student No.");
                StudUnits.setrange(Unit, Unit);
                StudUnits.setrange(Semester, "Retaken Prev.Semester");
                if StudUnits.find('-') then begin
                    RetakenQP := StudUnits."CF GPA";
                end;
                "CumGPA" := 0;
                if "Student Units"."Unit Description" = '' then begin
                    UnitsRec.reset;
                    UnitsRec.setrange(Code, "Student Units".Unit);
                    if UnitsRec.find('-') then
                        UnitDesc := UnitsRec.Desription;
                end;


                StudProg := getfilter(Programme);
                if StudProg = '' then
                    StudProg := "Student Units".Programme;
                if SemRec.get("Student Units".Semester) then SemDesc := SemRec.Description;

                if Cust.Get("Student Units"."Student No.") then begin
                    Names := Cust.Name;
                    DateReg := cust."Date Registered";
                    DOB := cust."Date Of Birth";

                end;


                if Prog.Get(StudProg) then begin
                    ProgName := Prog.Description;

                    if Prog."School Code" <> '' then begin
                        DimRec.reset;
                        dimrec.setrange(Code, prog."School Code");
                        dimrec.setrange("Global Dimension No.", 3);
                        if Dimrec.Find('-') then
                            SchoolName := Dimrec.Name;
                    end;
                end;
                if Semrec."BackLog Marks" = false then
                    ProcM.UpdateStudentUnits("Student Units"."Student No.", "Student Units".Programme, "Student Units".Semester, "Student Units".Stage, "Student Units".Unit);
                if ("Student Units"."Final Score" > 0) then begin
                    TotalMarks := TotalMarks + "Student Units"."Final Score";
                    TotalUnits := TotalUnits + 1;
                    if (TotalMarks > 0) and (TotalUnits > 0) then
                        AverageMarks := TotalMarks / TotalUnits;
                    // AverageGrade := ProcM.GetGrade(AverageMarks, '', "Student Units".Programme, '');
                end;
            end;


            trigger OnPreDataItem()
            begin
                CompInf.Get;
                CompInf.CalcFields(Picture);

                GeneralSetup.get;
                if GeneralSetup."Results Release Type" = GeneralSetup."Results Release Type"::"Current Semester" then
                    "Student Units".setfilter("Allow Online Results Semester", '%1', true);

                if "Student Units".GetFilter(Programme) = '' then begin
                    if "Student Units".getfilter("Student No.") <> '' then
                        if Cust.get("Student Units".GetFilter("Student No.")) then
                            "Student Units".setfilter(Programme, Cust."Current Programme");
                end;
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
        ProgName: Code[100];
        DimRec: Record "Dimension Value";
        SchoolName: text[200];
        DateReg: date;
        CumGPA: decimal;
        DOB: date;
        SemRec: Record Semesters;
        SemDesc: Text[200];
        GeneralSetup: Record "General Set-Up";
        TotalUnits: Integer;
        TotalMarks: Decimal;
        AverageMarks: Decimal;
        AverageGrade: code[20];
        StudProg: code[20];
        UnitDesc: text[200];
        UnitsRec: record "Units/Subjects";

        Stat: text[100];
        MainprogDesc: Text[200];
        StudUnits: Record "Student Units";
        RetakenQP: Decimal;

        StudMajor: Text[100];
        StudMinor: Text[100];

}

