Page 50930 "HR Job Occupants"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    PromotedActionCategories = 'New,Process,Report';
    SourceTable = "HR Jobs";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(JobDetails)
            {
                Caption = 'Job Details';
                Editable = false;
                field(JobID; Rec."Job ID")
                {
                    ApplicationArea = Basic;
                    Enabled = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the value of the Job ID field.';
                }
                field(JobDescription; Rec."Job Description")
                {
                    ApplicationArea = Basic;
                    Enabled = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the value of the Job Description field.';
                }
            }
            part(Control1102755000; "HR Employee List")
            {
                Caption = 'Job Occupants';
                Editable = false;
                SubPageLink = "Job Title" = field("Job ID");
            }
        }
        area(factboxes)
        {
            part(Control1102755005; "HR Employee List")
            {
                SubPageLink = "Job Title" = field("Job ID");
            }
            systempart(Control1102755003; Outlook) { }
        }
    }

    actions
    {
        area(processing)
        {
            action("Print HR Job Occupants")
            {
                ApplicationArea = Basic;
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "HR Job Occupants";
                ToolTip = 'Executes the Print HR Job Occupants action.';

                trigger OnAction()
                begin
                    //Display report
                    HrJob.SetRange(HrJob."Job id", Rec."Job ID");
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        if Rec.IsEmpty then
            Error('No jobs have been setup');
    end;

    var
        HrJob: Record "HR Jobs";
}

