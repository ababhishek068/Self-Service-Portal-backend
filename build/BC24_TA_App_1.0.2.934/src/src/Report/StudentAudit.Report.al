Report 50050 "Student Audit"
{
    DefaultLayout = RDLC;
    ApplicationArea = All;
    //RDLCLayout = './Layouts/StudentResultsSlip.rdlc';

    dataset
    {

        dataitem("Student Units"; "Student Units audit")
        {


            RequestFilterFields = "Student No.", Programme;
            column(ReportForNavId_1; 1) { }
            column(Stage_StudentUnits; "Student Units".Stage) { }
            column(Progress_Status; "Progress Status") { }
            column(Final_Score; "Final Score") { }
            column(Grade; Grade) { }
            column(CompUnits; CompUnits) { }
            column(StudentNo_StudentUnits; "Student Units"."Student No.") { }
            column(Unit_StudentUnits; "Student Units".Unit) { }
            column(UnitName_StudentUnits; UnitDesc) { }
            column(CATTotalMarks_StudentUnits; "Student Units"."CAT Total Marks") { }
            column(ExamMarks_StudentUnits; "Student Units"."Exam Marks") { }
            column(TotalScore_StudentUnits; "Student Units"."Total Score") { }
            column(Grade_StudentUnits; "Student Units".Grade) { }
            column(FinalScore_StudentUnits; "Student Units"."Final Score") { }
            column(Semester; "Semester Registered") { }
            column(No__Of_Units; "No. Of Units") { }
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
            column(ReqUnits; ReqUnits) { }
            column(CF_GPA; "CF GPA") { }
            column(CumGPA; CumGPA) { }
            column(CumGPAPoints; CumGPAPoints) { }
            column(Unit_Type; "Unit Type") { }
            column(Concentration; Concentration) { }
            column(Type; Type) { }
            column(ConcDesc; ConcDesc) { }
            column(Unit_Category_Name; "Unit Category Name") { }
            column(Description; Description) { }
            column(Unit_Category_Order; "Unit Category Order") { }
            column(Earned_Credits; "Earned Credits") { }
            trigger OnAfterGetRecord()
            begin
                "Student Units".CalcFields("CAT Total Marks");
                "Student Units".CalcFields("Exam Marks");
                "Student Units".CalcFields("Unit Description");
                UnitDesc := "Student Units"."Unit Description";

                if "Student Units"."Unit Description" = '' then begin
                    UnitsRec.reset;
                    UnitsRec.setrange(Code, "Student Units".Unit);
                    if UnitsRec.find('-') then
                        UnitDesc := UnitsRec.Desription;
                end;

                if SemRec.get("Student Units".Semester) then SemDesc := SemRec.Description;
                // if Conc.get(Concentration) then ConcDesc := Conc.Description;
                if Cust.Get("Student Units"."Student No.") then begin
                    if Cust."Enrolled Programmes" <> Cust."Current Programme" then begin
                        Cust."Enrolled Programmes" := Cust."Current Programme";
                        Cust.modify;
                    end;
                    cust.CalcFields("Completed Units");
                    cust.CalcFields("Required Units");
                    Names := Cust.Name;
                    DateReg := cust."Date Registered";
                    CompUnits := Cust."Completed Units";
                    ReqUnits := Cust."Required Units";

                end;
                if "Student Units".Programme <> '' then
                    StudProg := "Student Units".Programme;

                if Prog.Get("Student Units".Programme) then begin
                    ProgName := Prog.Description;
                    if Prog."School Code" <> '' then begin
                        DimRec.reset;
                        dimrec.setrange(Code, prog."School Code");
                        if Dimrec.Find('-') then
                            SchoolName := Dimrec.Name;
                    end;
                end;

            end;


            trigger OnPreDataItem()
            var
                StudCU: Codeunit "Student Billing";
            begin
                CompInf.Get;
                CompInf.CalcFields(Picture);
                if Getfilter("Student No.") <> '' then begin
                    StudCU.GenerateStudentAuditUnits(Getfilter("Student No."));
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
        CompInf: Record "Company Information";
        Prog: Record Programme;
        ProgName: Code[100];
        DimRec: Record "Dimension Value";
        SchoolName: text[200];
        DateReg: date;
        CompUnits: Decimal;
        ReqUnits: Decimal;
        CumGPA: Decimal;
        CumGPAPoints: Decimal;
        SemRec: Record Semesters;
        SemDesc: Text[200];
        ConcDesc: text[200];
        AverageGrade: code[20];
        StudProg: code[20];
        UnitDesc: text[200];
        UnitsRec: record "Units/Subjects";

}

