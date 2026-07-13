Page 50408 "Appraisal Part List"
{
    PageType = ListPart;
    SourceTable = "HR Appraisal Objectives";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(DocumentNo; Rec."Document No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Document No field.';
                }
                field(Objective; Rec.Objective)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Objective field.';
                }
                field(KeyPerformanceIndicator; Rec."Key Performance Indicator")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Key Performance Indicator field.';
                }
                field(Targets; Rec.Targets)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Targets field.';
                }
                field(MaxWeight; Rec."Max Weight")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Max Weight field.';
                }
                field(Achievements; Rec.Achievements)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Achievements field.';
                }
                field(Ratings; Rec.Ratings)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Ratings field.';
                }
                field(NotesByAppraisee; Rec."Notes By Appraisee")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Notes By Appraisee field.';
                }
                field(NotesByAppraiser; Rec."Notes By Appraiser")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Notes By Appraiser field.';
                }
                field(NotesByHOD; Rec."Notes By HOD")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Notes By HOD field.';
                }
                field(ApprovalCommentLine; Rec."Approval Comment Line")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Approval Comment Line field.';
                }
                field(SupervisorRating; Rec."Supervisor Rating")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Supervisor Rating field.';
                }
                field(HODRating; Rec."HOD Rating")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the HOD Rating field.';
                }
            }
        }
    }

    actions { }
}

