page 51412 "HR Job Interview"
{
    PageType = List;
    SourceTable = "HR Job Interview";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Interview Code"; Rec."Interview Code")
                {
                    Editable=false;
                    ToolTip = 'Specifies the value of the Interview Code field.';
                }
                field("Interview Description"; Rec."Interview Description")
                {
                    Editable=false;
                    ToolTip = 'Specifies the value of the Interview Description field.';
                }
                field(Score; Rec.Score)
                {
                    Visible=false;
                    ToolTip = 'Specifies the value of the Score field.';
                }
                field(Experience;Experience){}
                field("Exam/Perfomance";"Exam/Perfomance"){}
                field(Interview;Interview){}
                field("Total Score"; Rec."Total Score")
                {
                    ToolTip = 'Specifies the value of the Total Score field.';
                }
                field(comments; Rec.comments)
                {
                    ToolTip = 'Specifies the value of the Comments field.';
                }
                field(Interviewer; Rec.Interviewer)
                {
                    Visible=false;
                    ToolTip = 'Specifies the value of the Interviewer field.';
                }
                field("Interviewer Name"; Rec."Interviewer Name")
                {
                    Visible=false;
                    ToolTip = 'Specifies the value of the Interviewer Name field.';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Applicants)
            {
                Caption = 'Applicants';
                action("Hiring Criteria")
                {
                    Caption = 'Hiring Criteria';
                    Image = Agreement;
                    Promoted = true;
                    RunObject = Page "HR Hiring Criteria";
                    RunPageLink = "Application Code" = FIELD("Interview Code");
                    ToolTip = 'Executes the Hiring Criteria action.';
                }
            }
        }
    }
}

