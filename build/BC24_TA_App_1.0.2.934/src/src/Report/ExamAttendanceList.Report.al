Report 50089 "Exam Attendance List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/ExamAttendanceList.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Student Units"; "Student Units")
        {
            DataItemTableView = sorting("Student No.", Unit) order(ascending) where("Cust Exist" = filter(> 0));
            RequestFilterFields = "Campus Code", Programme, Stage, Unit, Semester;
            column(ReportForNavId_1; 1) { }
            column(RegTransactonID_StudentUnits; "Student Units"."Reg. Transacton ID") { }
            column(StudentNo_StudentUnits; "Student Units"."Student No.") { }
            column(Semester_StudentUnits; "Student Units".Semester) { }
            column(Programme_StudentUnits; "Student Units".Programme) { }
            column(Registerfor_StudentUnits; "Student Units"."Register for") { }
            column(Stage_StudentUnits; "Student Units".Stage) { }
            column(Unit_StudentUnits; "Student Units".Unit) { }
            column(ProgrammeFilter_StudentUnits; "Student Units"."Programme Filter") { }
            column(StageFilter_StudentUnits; "Student Units"."Stage Filter") { }
            column(UnitFilter_StudentUnits; "Student Units"."Unit Filter") { }
            column(SemesterFilter_StudentUnits; "Student Units"."Semester Filter") { }
            column(UnitType_StudentUnits; "Student Units"."Unit Type") { }
            column(Taken_StudentUnits; "Student Units".Taken) { }
            column(StudentTypeFilter_StudentUnits; "Student Units"."Student Type Filter") { }
            column(CategoryFilter_StudentUnits; "Student Units"."Category Filter") { }
            column(UnitCount_StudentUnits; "Student Units".UnitCount) { }
            column(TotalScore_StudentUnits; "Student Units"."Total Score") { }
            column(Exempted_StudentUnits; "Student Units".Exempted) { }
            column(Attendance_StudentUnits; "Student Units".Attendance) { }
            column(AllowSupplementary_StudentUnits; "Student Units"."Allow Supplementary") { }
            column(SatSupplementary_StudentUnits; "Student Units"."Sat Supplementary") { }
            column(RepeatUnit_StudentUnits; "Student Units"."Repeat Unit") { }
            column(Remarks_StudentUnits; "Student Units".Remarks) { }
            column(UnitStage_StudentUnits; "Student Units"."Unit Stage") { }
            column(Failed_StudentUnits; "Student Units".Failed) { }
            column(CourseType_StudentUnits; "Student Units"."Course Type") { }
            column(Audit_StudentUnits; "Student Units".Audit) { }
            column(Status_StudentUnits; "Student Units".Status) { }
            column(DetailsCount_StudentUnits; "Student Units"."Details Count") { }
            column(NoOfUnits_StudentUnits; "Student Units"."No. Of Units") { }
            column(ProjectStatus_StudentUnits; "Student Units"."Project Status") { }
            column(FinalScore_StudentUnits; "Student Units"."Final Score") { }
            column(Createdby_StudentUnits; "Student Units"."Created by") { }
            column(EditedBy_StudentUnits; "Student Units"."Edited By") { }
            column(Datecreated_StudentUnits; "Student Units"."Date created") { }
            column(DateEdited_StudentUnits; "Student Units"."Date Edited") { }
            column(CummulativeYearFilter_StudentUnits; "Student Units"."Cummulative Year Filter") { }
            column(TotalMarks_StudentUnits; "Student Units"."Total Marks") { }
            column(ExternalUnit_StudentUnits; "Student Units"."External Unit") { }
            column(ExternalUnits_StudentUnits; "Student Units"."External Units") { }
            column(SystemCreated_StudentUnits; "Student Units"."System Created") { }
            column(Multiple_StudentUnits; "Student Units".Multiple) { }
            column(EntryNo_StudentUnits; "Student Units"."Entry No.") { }
            column(StudentClass_StudentUnits; "Student Units"."Student Class") { }
            column(ENo_StudentUnits; "Student Units".ENo) { }
            column(SystemTaken_StudentUnits; "Student Units"."System Taken") { }
            column(RepeatMarks_StudentUnits; "Student Units"."Repeat Marks") { }
            column(ReTake_StudentUnits; "Student Units"."Re-Take") { }
            column(ProposalStatus_StudentUnits; "Student Units"."Proposal Status") { }
            column(ProposalDate_StudentUnits; "Student Units"."Proposal Date") { }
            column(SenateProposal_StudentUnits; "Student Units"."Senate-Proposal") { }
            column(Research_StudentUnits; "Student Units".Research) { }
            column(SenateResearch_StudentUnits; "Student Units"."Senate-Research") { }
            column(Examiners_StudentUnits; "Student Units".Examiners) { }
            column(Defense_StudentUnits; "Student Units".Defense) { }
            column(CategoryCode_StudentUnits; "Student Units"."Category Code") { }
            column(ProgressReport_StudentUnits; "Student Units"."Progress Report") { }
            column(ProgressDate_StudentUnits; "Student Units"."Progress Date") { }
            column(DefenceOutCome_StudentUnits; "Student Units"."Defence OutCome") { }
            column(Description_StudentUnits; "Student Units".Description) { }
            column(StudentType_StudentUnits; "Student Units"."Student Type") { }
            column(MainProgramme_StudentUnits; "Student Units"."Main Programme") { }
            column(RegisteredPrograme_StudentUnits; "Student Units"."Registered Programe") { }
            column(SemesterRegistered_StudentUnits; "Student Units"."Semester Registered") { }
            column(MarksStatus_StudentUnits; "Student Units"."Marks Status") { }
            column(StudentName_StudentUnits; "Student Units"."Student Name") { }
            column(CAT1_StudentUnits; "Student Units"."CAT-1") { }
            column(CAT2_StudentUnits; "Student Units"."CAT-2") { }
            column(ResultStatus_StudentUnits; "Student Units"."Result Status") { }
            column(RegistrationStatus_StudentUnits; "Student Units"."Registration Status") { }
            column(AssTotalMarks_StudentUnits; "Student Units"."Ass Total Marks") { }
            column(CATTotalMarks_StudentUnits; "Student Units"."CAT Total Marks") { }
            column(ExamMarks_StudentUnits; "Student Units"."Exam Marks") { }
            column(Category_StudentUnits; "Student Units".Category) { }
            column(ExamType_StudentUnits; "Student Units"."Exam Type") { }
            column(ExamPeriod_StudentUnits; "Student Units"."Exam Period") { }
            column(ExamStatus_StudentUnits; "Student Units"."Exam Status") { }
            column(StaffFilter_StudentUnits; "Student Units"."Staff Filter") { }
            column(Lecturer_StudentUnits; "Student Units".Lecturer) { }
            column(Grade_StudentUnits; "Student Units".Grade) { }
            column(SuppTaken_StudentUnits; "Student Units"."Supp Taken") { }
            column(FailedUnitsCount_StudentUnits; "Student Units"."Failed Units Count") { }
            column(UnitRegCount_StudentUnits; "Student Units"."Unit Reg Count") { }
            column(ExamPeriodFilter_StudentUnits; "Student Units"."Exam Period Filter") { }
            column(UnitFees_StudentUnits; "Student Units"."Unit Fees") { }
            column(ActualFees_StudentUnits; "Student Units"."Actual Fees") { }
            column(RegReversed_StudentUnits; "Student Units"."Reg Reversed") { }
            column(UnitsRegStatus_StudentUnits; "Student Units"."Units Reg. Status") { }
            column(ASS1_StudentUnits; "Student Units"."ASS-1") { }
            column(ASS2_StudentUnits; "Student Units"."ASS-2") { }
            column(Reversed_StudentUnits; "Student Units".Reversed) { }
            column(UnitName_StudentUnits; "Student Units"."Unit Name") { }
            column(SessionFilter_StudentUnits; "Student Units"."Session Filter") { }
            column(LecturerFilter_StudentUnits; "Student Units"."Lecturer Filter") { }
            column(IntakeCode_StudentUnits; "Student Units"."Intake Code") { }
            column(UnitDescription_StudentUnits; "Student Units"."Unit Description") { }
            column(Blocked_StudentUnits; "Student Units".Blocked) { }
            column(SessionCode_StudentUnits; "Student Units"."Session Code") { }
            column(CustExist_StudentUnits; "Student Units"."Cust Exist") { }
            column(Registered_StudentUnits; "Student Units".Registered) { }
            column(CFScore_StudentUnits; "Student Units"."CF Score") { }
            column(IgnoreinFinalAverage_StudentUnits; "Student Units"."Ignore in Final Average") { }
            column(IgnoreinCummAverage_StudentUnits; "Student Units"."Ignore in Cumm  Average") { }
            column(AttachmentUnit_StudentUnits; "Student Units"."Attachment Unit") { }
            column(RegResultsStatus_StudentUnits; "Student Units"."Reg. Results Status") { }
            column(AcademicYear_StudentUnits; "Student Units"."Academic Year") { }
            column(StudentCode_StudentUnits; "Student Units"."Student Code") { }
            column(CampusCode_StudentUnits; "Student Units".GetFilter("Campus Code")) { }
            column(CampusFilter_StudentUnits; "Student Units"."Campus Filter") { }
            column(RegOption_StudentUnits; "Student Units"."Reg Option") { }
            column(Examiner1_StudentUnits; "Student Units".Examiner1) { }
            column(Examiner2_StudentUnits; "Student Units".Examiner2) { }
            column(Examiner3_StudentUnits; "Student Units".Examiner3) { }
            column(Examiner4_StudentUnits; "Student Units".Examiner4) { }
            column(Show_StudentUnits; "Student Units".Show) { }
            column(SettlementType_StudentUnits; "Student Units"."Settlement Type") { }
            column(CreditedHours_StudentUnits; "Student Units"."Credited Hours") { }
            column(UnitPoints_StudentUnits; "Student Units"."Unit Points") { }
            column(CreditHours_StudentUnits; "Student Units"."Credit Hours") { }
            column(CancelledScore_StudentUnits; "Student Units"."Cancelled Score") { }
            column(Supervisor_StudentUnits; "Student Units".Supervisor) { }
            column(ReleasedResults_StudentUnits; "Student Units"."Released Results") { }
            column(GradeAcquired_StudentUnits; "Student Units"."Grade Acquired") { }
            column(CATsMarks_StudentUnits; "Student Units"."CATs Marks") { }
            column(EXAMsMarks_StudentUnits; "Student Units"."EXAMs Marks") { }
            column(GradeFin_StudentUnits; "Student Units"."Grade Fin") { }
            column(OldUnit_StudentUnits; "Student Units"."Old Unit") { }
            column(OldUnitLk_StudentUnits; "Student Units"."Old Unit Lk") { }
            column(CregRegisterfor_StudentUnits; "Student Units"."Creg Register for") { }
            column(CregExists_StudentUnits; "Student Units"."Creg Exists") { }
            column(ProgOnlineReleased_StudentUnits; "Student Units"."Prog Online Released") { }
            column(CFLk_StudentUnits; "Student Units"."CF Lk") { }
            column(StageUnitLK_StudentUnits; "Student Units"."Stage Unit LK") { }
            column(SettlementTypeCode_StudentUnits; "Student Units"."Settlement Type Code") { }
            column(RegistrationType_StudentUnits; "Student Units"."Registration Type") { }
            column(UnitExamCategory_StudentUnits; "Student Units"."Unit Exam Category") { }
            column(ProgrammeExamCategory_StudentUnits; "Student Units"."Programme Exam Category") { }
            column(CregStage_StudentUnits; "Student Units"."Creg Stage") { }
            column(CregStage1_StudentUnits; "Student Units"."Creg Stage1") { }
            column(Balance_StudentUnits; "Student Units".Balance) { }
            column(AllowExamAttendance_StudentUnits; "Student Units"."Allow Exam Attendance") { }
            column(ProjectUnit_StudentUnits; "Student Units"."Project Unit") { }
            column(GradePrefix_StudentUnits; "Student Units"."Grade Prefix") { }
            column(UnitResultsCount_StudentUnits; "Student Units"."Unit Results Count") { }
            column(ModerationTempScore_StudentUnits; "Student Units"."Moderation Temp Score") { }
            column(ModerationFactor_StudentUnits; "Student Units"."Moderation Factor") { }
            column(Moderated_StudentUnits; "Student Units".Moderated) { }
            column(ModerationDate_StudentUnits; "Student Units"."Moderation Date") { }
            column(ModeratedBy_StudentUnits; "Student Units"."Moderated By") { }
            column(Released_StudentUnits; "Student Units".Released) { }
            column(ModeofStudy_StudentUnits; "Student Units"."Mode of Study") { }

            column(CompName; CompInf.Name) { }
            column(CompAddr; CompInf.Address) { }
            column(CompLogo; CompInf.Picture) { }
            column(SchoolName; SchoolName) { }
            column(ProgName; ProgName) { }
            column(DeptName; DeptName) { }
            column(ClassCode; "Student Units".getfilter("Unit Class Code")) { }
            column(Lecturer; Lecturer) { }
            column(LecturerName; LecturerName) { }
            column(Student_Congregation; CongName) { }
            trigger OnAfterGetRecord()
            begin
                "Student Units".calcfields(Balance);
                //"Student Units".calcfields("Student Congregation");
                // CongName := '';
                // if CongRec.get("Student Congregation") then
                //     CongName := CongRec.Intials;

                "Student Units".calcfields("Allow Exam Attendance");
                if ("Student Units".Balance > 0) and ("Student Units"."Allow Exam Attendance" = false) then
                    CurrReport.Skip();

                "Student Units".CalcFields("Student Class Code");
                "Student Units".CalcFields(Lecturer);
                LecturerName := '';
                if HREmp.get(Lecturer) then LecturerName := HREmp."First Name" + ' ' + HREmp."Last Name";

                if "Student Units"."Student Class Code" <> '' then
                    ClassCode := "Student Units"."Student Class Code"
                else
                    ClassCode := "Student Units"."Unit Class Code";

                if Prog.Get("Student Units".Programme) then begin
                    ProgName := Prog.Description;
                    DimRec.Reset;
                    DimRec.SetRange(DimRec.Code, Prog."School Code");
                    if DimRec.Find('-') then
                        SchoolName := DimRec.Name;
                    DimRec.Reset;
                    DimRec.SetRange(DimRec.Code, Prog."Department Code");
                    if DimRec.Find('-') then
                        DeptName := DimRec.Name;
                end;
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
        Prog: Record Programme;
        DimRec: Record "Dimension Value";
        SchoolName: Text[100];
        ProgName: Text[100];
        DeptName: Text[100];
        ClassCode: code[20];
        LecturerName: Text[200];
        HREmp: Record "HR-Employee";
        //CongRec: Record Congregation;
        CongName: Text[100];


}