report 50340 "HR Applicants Shortlisting"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;
    dataset
    {
        dataitem("HR Job Applications"; "HR Job Applicants")
        {
            RequestFilterFields = Gender, Region, Age, "Stage Filter", "Employee Requisition No";
            column(Job_Application_No_; "Job Application No.") { }
            column(First_Name; "First Name") { }
            column(Last_Name; "Last Name") { }
            column(ID_Number; "ID Number") { }

            trigger OnAfterGetRecord()
            var

                AcademicScore: Decimal;
                GradeScore: Decimal;
                Score: Decimal;
                StageScore: Decimal;
                ExperienceScore: Decimal;
                "Experience?": Boolean;
                HRJobRequirements: Record "HR Jobs Requirements";
                HRShortlistedApplicants: Record "HR Shortlisting Entry";
                AppQualifications: Record "HR Applicant Qualifications";
                "HRJobShortList Criteria": Record "HR Stage Requirements";
            begin
                // message('step 2');
                Qualified := false;

                HRJobRequirements.RESET;
                HRJobRequirements.SETRANGE(HRJobRequirements."Job Id", "Job Applied For");
                //HRJobRequirements.SETRANGE(HRJobRequirements."Need code","Requisition No.");
                IF HRJobRequirements.find('-') THEN BEGIN
                    AcademicScore := 0;
                    "Experience?" := TRUE;
                    GradeScore := 0;
                    ExperienceScore := 0;
                    //message('step 3');
                    //GET JOB REQUIREMENTS
                    HRJobRequirements.RESET;
                    HRJobRequirements.SETRANGE(HRJobRequirements."Job Id", "Job Applied For");
                    //HRJobRequirements.SETRANGE(HRJobRequirements."Need code","Requisition No.");
                    HRJobRequirements.SETRANGE(HRJobRequirements.Mandatory, TRUE);
                    IF HRJobRequirements.FIND('-') THEN BEGIN//HR Job Requirements 2 BEGIN
                        REPEAT //***************//HR Job Requirements REPEAT
                            //message('step 4');
                            AppQualifications.RESET;
                            AppQualifications.SETRANGE(AppQualifications."Account No", "Account No");
                            AppQualifications.SETRANGE(AppQualifications."Qualification Type", HRJobRequirements."Qualification Type");
                            AppQualifications.SETRANGE(AppQualifications."Qualification Code", HRJobRequirements."Qualification Code");
                            IF AppQualifications.FIND('-') THEN BEGIN

                                AcademicScore := AcademicScore + 1;
                                //  Score := AppQualifications."Score ID";
                                IF AppQualifications."Score ID" >= HRJobRequirements."Minimum Score" THEN//check Grade
                                    GradeScore := GradeScore + 1;
                                //message(Format(GradeScore));
                            END; //***************//HR App Qualifications END

                        UNTIL HRJobRequirements.NEXT = 0;
                        //message('step 5');
                        IF (GradeScore >= AcademicScore) and (GradeScore > 0) THEN BEGIN//check Grade
                            Qualified := TRUE;//by academic
                            //message('step 6');
                        END ELSE
                            Qualified := FALSE;
                    END;//***************//HR Job Requirements 2 END


                END;
                Message('Job ' + format(Qualified));
                //Stage Requirements

                if Qualified = true then begin
                    "HRJobShortList Criteria".RESET;
                    "HRJobShortList Criteria".SETfilter("HRJobShortList Criteria"."Stage Code", getfilter("Stage Filter"));
                    "HRJobShortList Criteria".setrange(Interview, false);
                    if "HRJobShortList Criteria".find('-') then begin
                        REPEAT
                            StageScore := 0;
                            Score := 0;
                            //GET THE APPLICANTS QUALIFICATIONS AND COMPARE THEM WITH THE JOB REQUIREMENTS
                            AppQualifications.RESET;
                            AppQualifications.SETRANGE(AppQualifications."Account No", "Account No");
                            AppQualifications.SETRANGE(AppQualifications."Qualification Code", "HRJobShortList Criteria"."Qualification Code");
                            AppQualifications.SETRANGE(AppQualifications."Qualification Type", "HRJobShortList Criteria"."Qualification Type");
                            IF AppQualifications.FIND('-') THEN BEGIN
                                Score := Score + AppQualifications."Score ID";
                                IF AppQualifications."Score ID" < "HRJobShortList Criteria"."Desired Score" THEN
                                    Qualified := FALSE
                                ELSE
                                    Qualified := true;
                            end;

                        UNTIL "HRJobShortList Criteria".NEXT = 0;

                    END;
                    Message('Stage ' + format(Qualified));
                    if Qualified = true then begin // Interview
                        "HRJobShortList Criteria".RESET;
                        "HRJobShortList Criteria".SETfilter("HRJobShortList Criteria"."Stage Code", getfilter("Stage Filter"));
                        "HRJobShortList Criteria".setrange(Interview, true);
                        if "HRJobShortList Criteria".find('-') then begin
                            CalcFields("Total Score After Interview");
                            Qualified := false;
                            if "Total Score After Interview" >= "HRJobShortList Criteria"."Desired Score" then
                                Qualified := true;
                        end;
                    end;
                    IF Qualified THEN BEGIN
                        HRShortlistedApplicants.init;
                        HRShortlistedApplicants."Applicant No" := "Job Application No.";
                        HRShortlistedApplicants."Requisition No" := "Employee Requisition No";
                        HRShortlistedApplicants."Stage Code" := getfilter("Stage Filter");
                        HRShortlistedApplicants.insert;
                    END;
                    Qualified := false;
                    GradeScore := 0;
                    AcademicScore := 0;

                end;

            END;



            trigger OnPreDataItem()
            var
                HRShortlistedApplicants: Record "HR Shortlisting Entry";
            begin
                if getfilter("Stage Filter") = '' then
                    error('Please select the Shortlisting Stage');

                //DELETE ALL RECORDS FROM THE SHORTLISTED APPLICANTS TABLE
                HRShortlistedApplicants.RESET;
                HRShortlistedApplicants.SETfilter(HRShortlistedApplicants."Requisition No", Getfilter("Employee Requisition No"));
                HRShortlistedApplicants.SETFILTER(HRShortlistedApplicants."Stage Code", Getfilter("Stage Filter"));
                if HRShortlistedApplicants.find('-') then
                    HRShortlistedApplicants.DELETEALL;
            end;


        }

    }

    requestpage
    {
        layout
        {
            area(Content) { }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;
                    ToolTip = 'Executes the ActionName action.';

                }
            }
        }
    }
    procedure getExperience(email: Code[30]) reslt: Decimal
    var
        ApplicantsEmploymentHistory: Record "Applicants Employment History";
        CurrentEmploymentDetails: Record "Current Employment Details";
    begin
        ApplicantsEmploymentHistory.RESET;
        ApplicantsEmploymentHistory.SETRANGE(email, email);
        IF ApplicantsEmploymentHistory.FIND('-') THEN BEGIN
            REPEAT
            // IF (ApplicantsEmploymentHistory.From <> 0D) AND (ApplicantsEmploymentHistory."To" <> 0D) THEN BEGIN
            // reslt := reslt + ((ApplicantsEmploymentHistory."To" - ApplicantsEmploymentHistory.From) / 365);
            // END;
            UNTIL ApplicantsEmploymentHistory.NEXT = 0;
        END;
        CurrentEmploymentDetails.RESET;
        CurrentEmploymentDetails.SETRANGE("Email Address", email);
        IF CurrentEmploymentDetails.FIND('-') THEN BEGIN
            IF (CurrentEmploymentDetails."From Date" <> 0D) AND (CurrentEmploymentDetails."To Date" <> 0D) THEN BEGIN
                reslt := reslt + ((CurrentEmploymentDetails."To Date" - CurrentEmploymentDetails."From Date") / 365);
            END;
        END;
        EXIT(reslt);
    end;
}