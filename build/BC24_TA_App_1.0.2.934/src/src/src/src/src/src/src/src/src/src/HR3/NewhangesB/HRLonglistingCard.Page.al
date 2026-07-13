page 51110 "HR Long listing Card"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PromotedActionCategories = 'New,Process,Reports,Shortlist';
    SourceTable = "HR Employee Requisitions";
    SourceTableView = WHERE(Status = CONST(Approved), Closed = const(false));
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
                    ToolTip = 'Specifies the value of the Job ID field.';
                }
                field("Job Description"; Rec."Job Description")
                {
                    Enabled = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the value of the Job Description field.';
                }

                field("Required Positions"; Rec."Required Positions")
                {
                    Importance = Promoted;
                    ToolTip = 'Specifies the value of the Required Positions field.';
                }
                field(Status; Rec.Status)
                {
                    Enabled = false;
                    Importance = Promoted;
                    Style = StrongAccent;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
            part(Longlisted; "HR Shortlisting Lines")
            {
                Editable = false;
                SubPageLink = "Employee Requisition No" = FIELD("Requisition No.");
            }
        }
        area(factboxes)
        {
            systempart(Outlook; Outlook) { }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Applicants)
            {
                Caption = 'Applicants';
                action("Shortlist Applicants")
                {
                    Caption = 'Shortlist Applicants';
                    Image = SelectField;
                    Promoted = true;
                    PromotedCategory = Category4;
                    Visible = true;
                    ToolTip = 'Executes the Shortlist Applicants action.';

                    trigger OnAction();
                    begin
                        IF CONFIRM('Long List Applicants for Employee Requisition %1 - %2', FALSE, Rec."Requisition No.", Rec."Job Description") = FALSE THEN EXIT;



                        HRJobRequirements.RESET;
                        HRJobRequirements.SETRANGE(HRJobRequirements."Job ID", Rec."Job ID");
                        IF HRJobRequirements.COUNT = 0 THEN BEGIN
                            MESSAGE('Job Requirements for the job ' + Rec."Job ID" + ' have not been setup');
                            EXIT;
                        END ELSE BEGIN

                            //GET JOB REQUIREMENTS
                            HRJobRequirements.RESET;
                            HRJobRequirements.SETRANGE(HRJobRequirements."Job ID", Rec."Job ID");


                            //DELETE ALL RECORDS FROM THE SHORTLISTED APPLICANTS TABLE
                            HRShortlistedApplicants.RESET;
                            HRShortlistedApplicants.SETRANGE(HRShortlistedApplicants."Employee Requisition No", Rec."Requisition No.");
                            HRShortlistedApplicants.DELETEALL;

                            //GET JOB APPLICANTS
                            HRJobApplications.RESET;
                            HRJobApplications.SETRANGE(HRJobApplications."Employee Requisition No", Rec."Requisition No.");
                            IF NOT HRJobApplications.FIND('-') THEN BEGIN
                                ERROR('No Applicants have applied for this Job');
                            END;
                            HRJobApplications.FINDFIRST;
                            REPEAT
                                HRJobApplications.Qualified := FALSE;
                                HRJobApplications.MODIFY;
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

                        //SORT DESCENDING
                        //HRShortlistedApplicants.SETCURRENTKEY(HRShortlistedApplicants."Stage Score");
                        //HRShortlistedApplicants.ASCENDING;
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
                        MESSAGE('Longlisting Competed Successfully for %1', Rec."Job ID");

                        //END ELSE
                        //MESSAGE('%1','You must select the stage you would like to shortlist.');

                    end;
                }
                action("&Related ShortList Applicants")
                {
                    Caption = '&Related ShortList Applicants';
                    Image = SelectField;
                    Promoted = true;
                    PromotedCategory = Category4;
                    Visible = false;
                    ToolTip = 'Executes the &Related ShortList Applicants action.';

                    trigger OnAction();
                    begin
                        //TESTFIELD("Completion Status","Completion Status"::Open);

                        IF CONFIRM('Shortlist Applicants for Employee Requisition %1 - %2', FALSE, Rec."Requisition No.", Rec."Job Description") = FALSE THEN EXIT;

                        HRJobRequirements.RESET;
                        HRJobRequirements.SETRANGE(HRJobRequirements."Job ID", Rec."Job ID");
                        IF HRJobRequirements.COUNT = 0 THEN BEGIN
                            ERROR('Job Requirements for the job ' + Rec."Job ID" + ' have not been setup');
                        END;

                        //DELETE ALL RECORDS FROM THE SHORTLISTED APPLICANTS TABLE
                        HRShortlistedApplicants.RESET;
                        HRShortlistedApplicants.SETRANGE(HRShortlistedApplicants."Employee Requisition No", Rec."Requisition No.");
                        HRShortlistedApplicants.DELETEALL;

                        //GET JOB APPLICANTS
                        HRJobApplications.RESET;
                        HRJobApplications.SETRANGE(HRJobApplications."Employee Requisition No", Rec."Requisition No.");
                        IF NOT HRJobApplications.FIND('-') THEN BEGIN
                            ERROR('No Applicants have applied for this Job');
                        END;
                        HRJobApplications.FINDFIRST;
                        REPEAT
                            HRJobApplications.Qualified := FALSE;
                            HRJobApplications.MODIFY;
                        UNTIL HRJobApplications.NEXT = 0;

                        MESSAGE('Shortlisting Competed Successfully for %1', Rec."Job ID");

                    end;
                }
                action(Requirements)
                {
                    Caption = 'Requirements';
                    Image = JobListSetup;
                    Promoted = true;
                    PromotedCategory = Category5;
                    RunObject = Page "HR Job Requirement Lines";
                    RunPageLink = "Job ID" = FIELD("Job ID");
                    ToolTip = 'Executes the Requirements action.';
                }
            }
        }
    }

    var
        HRJobRequirements: Record "HR Job Requirements";
        HRJobApplications: Record "HR Job Applications";
        HRShortlistedApplicants: Record "HR Shortlisted Applicants";
}

