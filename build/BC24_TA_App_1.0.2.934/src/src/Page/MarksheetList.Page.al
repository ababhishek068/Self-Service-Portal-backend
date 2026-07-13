Page 50177 "Marksheet List"
{
    CardPageID = MarkSheetHeader;
    PageType = List;
    SourceTable = "Marksheet Header1";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(CampusFilter; Rec."Campus Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Campus Filter field.';
                }
                field(ProgrammeFilter; Rec."Programme Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Programme Filter field.';
                }
                field(SemesterFilter; Rec."Semester Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Semester Filter field.';
                }
                field(IntakeFilter; Rec."Intake Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Intake Filter field.';
                }
                field(StageFilter; Rec."Stage Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Stage Filter field.';
                }
                field(UnitFilter; Rec."Unit Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Unit Filter field.';
                }
                field(StudentFilter; Rec."Student Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Student Filter field.';
                }
                field(ApprovedBy; Rec."Approved By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Approved By field.';
                }
                field(ApprovalDate; Rec."Approval Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Approval Date field.';
                }
                field(Approved; Rec.Approved)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Approved field.';
                }
                field(NoSeries; Rec."No. Series")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No. Series field.';
                }
                field(VerifiedBy; Rec."Verified By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Verified By field.';
                }
                field(VerifiedDate; Rec."Verified Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Verified Date field.';
                }
                field(Verified; Rec.Verified)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Verified field.';
                }
                field(ModerationFactor; Rec."Moderation Factor")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Moderation Factor field.';
                }
                field(ModeratedBy; Rec."Moderated By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Moderated By field.';
                }
                field(ModeratedOn; Rec."Moderated On")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Moderated On field.';
                }
                field(PreparedBy; Rec."Prepared By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Prepared By field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(ModeofStudyFilter; Rec."Mode of Study Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Mode of Study Filter field.';
                }
                field(iCounter; Rec.iCounter)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the iCounter field.';
                }
                field(LecturerNo; Rec."Lecturer No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Lecturer No field.';
                }
            }
        }
    }

    actions { }
}

