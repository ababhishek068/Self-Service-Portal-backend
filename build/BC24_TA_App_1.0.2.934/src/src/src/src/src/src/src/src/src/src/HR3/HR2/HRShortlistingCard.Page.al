page 51089 "HR Shortlisting Card"
{


    PageType = Card;
    PromotedActionCategories = 'New,Process,Reports,Shortlist';
    SourceTable = "HR Employee Requisitions";
    SourceTableView = WHERE(Status = CONST(Approved), Closed = CONST(false));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group("Job Details")
            {
                Caption = 'Job Details';
                Editable = true;
                field("Job ID"; Rec."Job ID")
                {
                    Editable = false;
                    Enabled = false;
                    Importance = Promoted;
                    Style = StrongAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Job ID field.';
                }
                field("Job Description"; Rec."Job Description")
                {
                    Enabled = false;
                    Importance = Promoted;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Job Description field.';
                }
                field("Requisition Date"; Rec."Requisition Date")
                {
                    Editable = "Requisition DateEditable";
                    Enabled = false;
                    Importance = Promoted;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Requisition Date field.';
                }
                field(Priority; Rec.Priority)
                {
                    Editable = PriorityEditable;
                    Enabled = false;
                    Importance = Promoted;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Priority field.';
                }
                field("Vacant Positions"; Rec."Vacant Positions")
                {
                    Enabled = false;
                    Importance = Promoted;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Vacant Positions field.';
                }
                field("Required Positions"; Rec."Required Positions")
                {
                    Editable = "Required PositionsEditable";
                    Enabled = false;
                    Importance = Promoted;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Required Positions field.';
                }
                field(Status; Rec.Status)
                {
                    Enabled = false;
                    Importance = Promoted;
                    Style = StrongAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Stage Code"; Rec."Stage Code")
                {

                    Importance = Promoted;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Stage Code field.';
                }
            }
            group(ShortlistingStages)
            {
                caption = 'Short Listing Stages';
                part(Shortlisting; "Recruitment stages")
                {
                    ApplicationArea = basic;

                    SubPageLink = "Employee Requisition Filter" = FIELD("Requisition No.");
                }
            }
            group(QulifiedApplicants)
            {
                caption = 'Qualified Applicants';
                part(Shortlisted; "HR Applicants List")
                {
                    ApplicationArea = basic;
                    Editable = false;
                    SubPageLink = "Employee Requisition No" = FIELD("Requisition No."), "Qualified Stages Count" = filter(> 0), "Shortlisting Stage Filter" = field("Stage Code");
                }
            }
        }

        area(factboxes)
        {
            part(Control1102755003; "HR Jobs Factbox")
            {
                SubPageLink = "Job ID" = FIELD("Job ID");
            }
            systempart(Control1102755001; Outlook) { }
        }
    }

    actions
    {
        area(navigation)
        {
            action(StageShortlisting)
            {
                Caption = 'Shortlist By Stage';
                ApplicationArea = basic;
                Image = SelectField;
                ToolTip = 'Executes the Shortlist By Stage action.';
                trigger OnAction()
                var
                   
                    jApp: Record "HR Job Applicants";
                    Shortlisting: report "HR Applicants Shortlisting";
                begin
                    
                    jApp.reset;
                    jApp.SetFilter(jApp."Stage Filter", Rec."Stage Code");
                    jApp.SetFilter(jApp."Employee Requisition No", Rec."Requisition No.");
                    Shortlisting.SetTableView(jApp);
                    Shortlisting.Run;
                end;

            }
            action(MarkAsQualified)
            {
                Caption = 'Mark Shortlist Applicants As Qualified';
                ApplicationArea = basic;
                Image = SelectField;
                ToolTip = 'Executes the Mark Shortlist Applicants As Qualified action.';
                trigger OnAction()
                begin
                    Rec.TestField("Stage Code");
                    if Confirm('Do you really want to mark the applicant qualified at ' + Rec."Stage Code" + ' as qualified?', false) then begin
                        HRJobApplications.reset;
                        HRJobApplications.setrange(HRJobApplications."Employee Requisition No", Rec."Requisition No.");
                        HRJobApplications.SetFilter(HRJobApplications."Shortlisting Stage Filter", '%1', Rec."Stage Code");
                        HRJobApplications.SetFilter(HRJobApplications."Qualified Stages Count", '>%1', 0);
                        if HRJobApplications.find('-') then begin
                            repeat
                                HRJobApplications.Qualified := true;
                                HRJobApplications.modify;
                            until HRJobApplications.next = 0;
                        end;

                        HRJobApplications.reset;
                        HRJobApplications.setrange(HRJobApplications."Employee Requisition No", Rec."Requisition No.");
                        HRJobApplications.SetFilter(HRJobApplications."Shortlisting Stage Filter", '%1', Rec."Stage Code");
                        HRJobApplications.SetFilter(HRJobApplications."Qualified Stages Count", '%1', 0);
                        if HRJobApplications.find('-') then begin
                            repeat
                                HRJobApplications.Qualified := false;
                                HRJobApplications.modify;
                            until HRJobApplications.next = 0;
                        end;
                    end;
                end;
            }

            group(Applicants)
            {
                Caption = 'Applicants';
                action("&ShortList Applicants By Job Requirements")
                {
                    Caption = '&ShortList Applicants By Job Requirements';
                    Image = SelectField;
                    Promoted = true;
                    PromotedCategory = Category4;
                    Visible = false;
                    ApplicationArea = basic;
                    ToolTip = 'Executes the &ShortList Applicants By Job Requirements action.';
                    trigger OnAction()
                    var
                        AcademicScore: Decimal;
                        GradeScore: Decimal;
                        ExperienceScore: Decimal;
                        "Experience?": Boolean;
                    begin
                        HRJobRequirements.RESET;
                        HRJobRequirements.SETRANGE(HRJobRequirements."Job Id", Rec."Job ID");
                        //HRJobRequirements.SETRANGE(HRJobRequirements."Need code","Requisition No.");
                        IF HRJobRequirements.COUNT = 0 THEN BEGIN
                            MESSAGE('Job Requirements for the job ' + Rec."Job ID" + ' have not been setup');
                            EXIT;
                        END ELSE BEGIN //***************//HR Job Requirements 1 BEGIN



                            //DELETE ALL RECORDS FROM THE SHORTLISTED APPLICANTS TABLE
                            HRShortlistedApplicants.RESET;

                            //HRShortlistedApplicants.SETRANGE(HRShortlistedApplicants."Employee Requisition No","Requisition No.");
                            HRShortlistedApplicants.SETRANGE(HRShortlistedApplicants."Job Id", Rec."Job ID");
                            //HRShortlistedApplicants.SETRANGE(HRShortlistedApplicants.Mandatory,TRUE);
                            HRShortlistedApplicants.DELETEALL;

                            //GET JOB APPLICANTS
                            HRJobApplications.RESET;
                            HRJobApplications.SETRANGE(HRJobApplications."Job Applied For", Rec."Job ID");
                            //HRJobApplications.SETRANGE(HRJobApplications."No.","Requisition No.");
                            IF HRJobApplications.FIND('-') THEN BEGIN//Job Applications BEGIN
                                REPEAT//***************//Job Applications REPEAT
                                    AcademicScore := 0;
                                    Rec.Score := 0;
                                    GradeScore := 0;
                                    ExperienceScore := 0;
                                    //GET JOB REQUIREMENTS
                                    HRJobRequirements.RESET;
                                    HRJobRequirements.SETRANGE(HRJobRequirements."Job Id", Rec."Job ID");
                                    //HRJobRequirements.SETRANGE(HRJobRequirements."Need code","Requisition No.");
                                    HRJobRequirements.SETRANGE(HRJobRequirements.Mandatory, TRUE);
                                    IF HRJobRequirements.FIND('-') THEN BEGIN//HR Job Requirements 2 BEGIN
                                        REPEAT //***************//HR Job Requirements REPEAT
                                            AppQualifications.RESET;
                                            AppQualifications.SETRANGE(AppQualifications.Email, UPPERCASE(HRJobApplications."E-Mail"));
                                            AppQualifications.SETRANGE(AppQualifications."Qualification Type", HRJobRequirements."Qualification Type");
                                            AppQualifications.SETRANGE(AppQualifications."Qualification Code", HRJobRequirements."Qualification Code");
                                            IF AppQualifications.FIND('-') THEN BEGIN //***************//HR App Qualifications BEGIN
                                                                                      // AppQualifications.VALIDATE(Classification);
                                                AcademicScore := AcademicScore + 1;
                                                Rec.Score := AppQualifications."Score ID";
                                                IF AppQualifications."Score ID" >= HRJobRequirements."Desired Score" THEN//check Grade
                                                    GradeScore := GradeScore + 1;
                                            END; //***************//HR App Qualifications END

                                            //Check Experience
                                            IF HRJobRequirements."Qualification Type" = 'EXPERIENCE' THEN BEGIN
                                                GradeScore := GradeScore + 1;
                                                AcademicScore := AcademicScore + 1;
                                                ExperienceScore := ROUND(getExperience(HRJobApplications."E-Mail"), 0.1, '=');
                                                IF ExperienceScore >= HRJobRequirements."Desired Score" THEN
                                                    "Experience?" := TRUE;
                                            END;
                                        UNTIL HRJobRequirements.NEXT = 0;
                                        IF (AcademicScore = GradeScore) AND (GradeScore = HRJobRequirements.COUNT) AND "Experience?" THEN BEGIN//check Grade
                                            Rec.Qualified := TRUE;//by academic
                                        END ELSE
                                            Rec.Qualified := FALSE;
                                    END;//***************//HR Job Requirements 2 END

                                    IF Rec.Qualified THEN BEGIN
                                        HRShortlistedApplicants."Job Id" := Rec."Job ID";
                                        HRShortlistedApplicants."Employee Requisition No" := Rec."Requisition No.";
                                        HRShortlistedApplicants."Job Application No" := HRJobApplications."Job Application No.";
                                        HRShortlistedApplicants."Stage Score" := Rec.Score;
                                        HRShortlistedApplicants."Experience Score" := ExperienceScore;
                                        HRShortlistedApplicants.Qualified := Rec.Qualified;
                                        HRShortlistedApplicants."First Name" := HRJobApplications."First Name";
                                        HRShortlistedApplicants."Middle Name" := HRJobApplications."Middle Name";
                                        HRShortlistedApplicants."E-Mail" := HRJobApplications."E-Mail";
                                        HRShortlistedApplicants."Last Name" := HRJobApplications."Last Name";
                                        HRShortlistedApplicants."ID No" := HRJobApplications."ID Number";
                                        HRShortlistedApplicants.Gender := HRJobApplications.Gender;
                                        HRShortlistedApplicants.Mandatory := TRUE;
                                        HRShortlistedApplicants."Marital Status" := HRJobApplications."Marital Status";
                                        HRShortlistedApplicants.INSERT;
                                        HRJobApplications.GET(HRShortlistedApplicants."Job Application No");
                                        HRJobApplications.Qualified := TRUE;
                                        //HRJobApplications.fa
                                        HRJobApplications.MODIFY;
                                    END ELSE BEGIN
                                        HRShortlistedApplicants."Job Id" := Rec."Job ID";
                                        HRShortlistedApplicants."Employee Requisition No" := Rec."Requisition No.";
                                        HRShortlistedApplicants."Job Application No" := HRJobApplications."Job Application No.";
                                        HRShortlistedApplicants."Stage Score" := Rec.Score;
                                        HRShortlistedApplicants."Experience Score" := ExperienceScore;
                                        HRShortlistedApplicants.Qualified := FALSE;
                                        HRShortlistedApplicants."First Name" := HRJobApplications."First Name";
                                        HRShortlistedApplicants."Middle Name" := HRJobApplications."Middle Name";
                                        HRShortlistedApplicants."E-Mail" := HRJobApplications."E-Mail";
                                        HRShortlistedApplicants."Last Name" := HRJobApplications."Last Name";
                                        HRShortlistedApplicants."ID No" := HRJobApplications."ID Number";
                                        HRShortlistedApplicants.Gender := HRJobApplications.Gender;
                                        HRShortlistedApplicants.Mandatory := TRUE;
                                        HRShortlistedApplicants."Marital Status" := HRJobApplications."Marital Status";
                                        HRShortlistedApplicants.INSERT;
                                        HRJobApplications.GET(HRShortlistedApplicants."Job Application No");
                                        HRJobApplications.Qualified := FALSE;
                                        //HRJobApplications.fa
                                        HRJobApplications.MODIFY;
                                    END;

                                UNTIL HRJobApplications.NEXT = 0;
                            END; //***************//Job Applications END
                                 //MARK QUALIFIED APPLICANTS AS QUALIFIED
                            HRShortlistedApplicants.SETRANGE(HRShortlistedApplicants.Qualified, TRUE);
                            IF HRShortlistedApplicants.FIND('-') THEN
                                REPEAT //***************//HRShortlistedApplicants REPEAT

                                UNTIL HRShortlistedApplicants.NEXT = 0;
                            /*
                                                        RecruitmentStages.RESET;
                                                        RecruitmentStages.SETFILTER("Recruitement Stage", '<>%', '');
                                                        IF RecruitmentStages.FINDFIRST THEN BEGIN
                                                            Stage := RecruitmentStages."Recruitement Stage";
                                                            //HRJobRequirements.Complete:=TRUE;
                                                            MODIFY(TRUE);
                                                        END;
                            */
                            MESSAGE('%1', 'Shortlisting Competed Successfully.');

                        END; //***************//HR Job Requirements 1 END;
                             // END ELSE
                             // MESSAGE('%1','You must select the stage you would like to shortlist.');  

                    end;
                }
                action("&Print")
                {
                    Caption = '&Print';
                    Image = PrintReport;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Category4;
                    ApplicationArea = basic;
                    ToolTip = 'Executes the &Print action.';
                    trigger OnAction()
                    begin
                        HREmpReq.RESET;
                        HREmpReq.SETRANGE(HREmpReq."Requisition No.", Rec."Requisition No.");
                        IF HREmpReq.FIND('-') THEN
                            REPORT.RUN(70135261, TRUE, TRUE, HREmpReq);
                    end;
                }
                action("&ShortList Applicants By Criteria")
                {
                    Caption = '&ShortList Applicants By Criteria';
                    Image = SelectField;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ApplicationArea = basic;
                    Visible = false;
                    ToolTip = 'Executes the &ShortList Applicants By Criteria action.';
                    trigger OnAction()
                    begin
                        "HRJobShortList Criteria".RESET;
                        "HRJobShortList Criteria".SETRANGE("HRJobShortList Criteria"."Job Id", Rec."Job ID");
                        IF "HRJobShortList Criteria".COUNT = 0 THEN BEGIN
                            MESSAGE('Job Requirements for the job ' + Rec."Job ID" + ' have not been setup');
                            EXIT;
                        END ELSE BEGIN

                            //GET JOB REQUIREMENTS
                            "HRJobShortList Criteria".RESET;
                            "HRJobShortList Criteria".SETRANGE("HRJobShortList Criteria"."Job Id", Rec."Job ID");

                            //DELETE ALL RECORDS FROM THE SHORTLISTED APPLICANTS TABLE
                            HRShortlistedApplicants.RESET;
                            HRShortlistedApplicants.SETRANGE(HRShortlistedApplicants."Employee Requisition No", Rec."Requisition No.");
                            HRShortlistedApplicants.DELETEALL;

                            //GET JOB APPLICANTS
                            HRJobApplications.RESET;
                            HRJobApplications.SETRANGE(HRJobApplications."Employee Requisition No", Rec."Requisition No.");
                            IF HRJobApplications.FIND('-') THEN BEGIN
                                REPEAT
                                    Rec.Qualified := TRUE;
                                    IF HRJobRequirements.FIND('-') THEN BEGIN
                                        StageScore := 0;
                                        Rec.Score := 0;
                                        REPEAT
                                            //GET THE APPLICANTS QUALIFICATIONS AND COMPARE THEM WITH THE JOB REQUIREMENTS
                                            AppQualifications.RESET;
                                            AppQualifications.SETRANGE(AppQualifications.Email, HRJobApplications."E-Mail");
                                            AppQualifications.SETRANGE(AppQualifications."Qualification Code", "HRJobShortList Criteria"."ShortList Code");
                                            IF AppQualifications.FIND('-') THEN BEGIN
                                                Rec.Score := Rec.Score + AppQualifications."Score ID";
                                                IF AppQualifications."Score ID" < "HRJobShortList Criteria"."Desired Score" THEN
                                                    Rec.Qualified := FALSE;
                                            END ELSE BEGIN
                                                Rec.Qualified := FALSE;
                                            END;

                                        UNTIL "HRJobShortList Criteria".NEXT = 0;
                                    END;
                                    HRShortlistedApplicants.init;
                                    HRShortlistedApplicants."Employee Requisition No" := Rec."Requisition No.";
                                    HRShortlistedApplicants."Job Application No" := HRJobApplications."Job Application No.";
                                    HRShortlistedApplicants."Stage Score" := Rec.Score;
                                    HRShortlistedApplicants.Qualified := Rec.Qualified;
                                    HRShortlistedApplicants."First Name" := HRJobApplications."First Name";
                                    HRShortlistedApplicants."Middle Name" := HRJobApplications."Middle Name";
                                    HRShortlistedApplicants."Last Name" := HRJobApplications."Last Name";
                                    HRShortlistedApplicants."ID No" := HRJobApplications."ID Number";
                                    HRShortlistedApplicants.Gender := HRJobApplications.Gender;
                                    HRShortlistedApplicants."Marital Status" := HRJobApplications."Marital Status";
                                    HRShortlistedApplicants.INSERT;

                                UNTIL HRJobApplications.NEXT = 0;
                            END;
                            //MARK QUALIFIED APPLICANTS AS QUALIFIED
                            HRShortlistedApplicants.SETRANGE(HRShortlistedApplicants.Qualified, TRUE);
                            IF HRShortlistedApplicants.FIND('-') THEN
                                REPEAT
                                    HRJobApplications.GET(HRShortlistedApplicants."Job Application No");
                                    HRJobApplications.Qualified := TRUE;
                                    HRJobApplications.MODIFY;
                                UNTIL HRShortlistedApplicants.NEXT = 0;
                            /*
                            RecCount:= 0;
                            MyCount:=0;
                            StageShortlist.RESET;
                            StageShortlist.SETRANGE(StageShortlist."Need Code","Need Code");
                            StageShortlist.SETRANGE(StageShortlist."Stage Code","Stage Code");

                            IF StageShortlist.FIND('-') THEN BEGIN
                            RecCount:=StageShortlist.COUNT ;
                            StageShortlist.SETCURRENTKEY(StageShortlist."Stage Score");
                            StageShortlist.ASCENDING;
                            REPEAT
                            MyCount:=MyCount + 1;
                            StageShortlist.Position:=RecCount - MyCount;
                            StageShortlist.MODIFY;
                            UNTIL StageShortlist.NEXT = 0;
                            END;
                            */
                            MESSAGE('%1', 'Shortlisting Competed Successfully.');

                        END;
                        //END ELSE
                        //MESSAGE('%1','You must select the stage you would like to shortlist.');

                    end;
                }
                action(Requirements)
                {
                    Caption = 'Requirements';
                    ApplicationArea = basic;
                    RunObject = page "HR Job Requirement Lines";
                    RunPageLink = "Job Id" = field("Job ID");
                    ToolTip = 'Executes the Requirements action.';
                }
            }
        }
    }


    trigger OnInit()
    begin
        "Required PositionsEditable" := TRUE;
        PriorityEditable := TRUE;
        ShortlistedEditable := TRUE;
        "Requisition DateEditable" := TRUE;
        "Job IDEditable" := TRUE;
    end;



    var
        HRJobRequirements: Record "HR Stage Requirements";
        AppQualifications: Record "HR Applicant Qualifications";
        HRJobApplications: Record "HR Job Applicants";
        StageScore: Decimal;
        HRShortlistedApplicants: Record "HR Shortlisted Applicants";
        HREmpReq: Record "HR Employee Requisitions";
        [InDataSet]
        "Job IDEditable": Boolean;
        [InDataSet]
        "Requisition DateEditable": Boolean;
        [InDataSet]
        ShortlistedEditable: Boolean;
        [InDataSet]
        PriorityEditable: Boolean;
        [InDataSet]
        "Required PositionsEditable": Boolean;
        "HRJobShortList Criteria": Record "HR shortList Requirements";

    procedure getExperience(email: Code[30]) reslt: Decimal
    var
        ApplicantsEmploymentHistory: Record "Applicants Employment History";
        CurrentEmploymentDetails: Record "Current Employment Details";
    begin
        ApplicantsEmploymentHistory.RESET;
        //   ApplicantsEmploymentHistory.SETRANGE("Email Address", email);
        IF ApplicantsEmploymentHistory.FIND('-') THEN BEGIN
            REPEAT
            //  IF (ApplicantsEmploymentHistory.From <> 0D) AND (ApplicantsEmploymentHistory."To" <> 0D) THEN BEGIN
            //      reslt := reslt + ((ApplicantsEmploymentHistory."To" - ApplicantsEmploymentHistory.From) / 365);
            //  END;
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

    procedure UpdateControls()
    begin

        IF Rec.Status = Rec.Status::New THEN BEGIN
            "Job IDEditable" := TRUE;
            "Requisition DateEditable" := TRUE;
            ShortlistedEditable := TRUE;
            PriorityEditable := TRUE;
            "Required PositionsEditable" := TRUE;
        END ELSE BEGIN
            "Job IDEditable" := FALSE;
            "Requisition DateEditable" := FALSE;
            ShortlistedEditable := FALSE;
            PriorityEditable := FALSE;
            "Required PositionsEditable" := FALSE;
        END;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        xRec := Rec;

        UpdateControls;
    end;
}



