Page 51224 "Applicants List"
{
    CardPageID = "Applicants Card";
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Applicant,Functions,Print';
    SourceTable = "HR Job Applicants";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control15)
            {
                Editable = false;
                field("Job Application No."; Rec."Job Application No.")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Job Application No. field.';
                }
                field("Employee Requisition No"; Rec."Employee Requisition No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Employee Requisition No field.';
                }
                field(DateApplied; Rec."Date Applied")
                {
                    ApplicationArea = Basic;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Date Applied field.';
                }
                field(JobAppliedFor; Rec."Job Applied For")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Job Applied For field.';
                }
                field(FirstName; Rec."First Name")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the value of the First Name field.';
                }
                field(MiddleName; Rec."Middle Name")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the value of the Middle Name field.';
                }
                field(LastName; Rec."Last Name")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the value of the Last Name field.';
                }
                field(Qualified; Rec.Qualified)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Qualified field.';
                }
                field(InterviewInvitationSent; Rec."Interview Invitation Sent")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Interview Invitation Sent field.';
                }
                field("Account No"; Rec."Account No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Account No field.';
                }
                field(EMail; Rec."E-Mail")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the E-Mail field.';
                }
                field(JobAppliedforDescription; Rec."Job Applied for Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Job Applied for Description field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
        }
    }

    actions { }


}

