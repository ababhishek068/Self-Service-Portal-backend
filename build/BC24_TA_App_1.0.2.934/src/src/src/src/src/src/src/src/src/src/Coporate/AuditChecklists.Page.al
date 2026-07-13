Page 50544 "Audit Checklists"
{
    PageType = List;
    SourceTable = "Audit Checklists";
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
                field(AuditCode; Rec."Audit Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Audit Code field.';
                }
                field(CheckpointDesc1; Rec."Checkpoint Desc 1")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Checkpoint Desc 1 field.';
                }
                field(CheckpointDesc2; Rec."Checkpoint Desc 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Checkpoint Desc 2 field.';
                }
                field(ClauseofCriteriaDocument; Rec."Clause of Criteria Document")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Clause of Criteria Document field.';
                }
                field(CheckpointDesc3; Rec."Checkpoint Desc 3")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Checkpoint Desc 3 field.';
                }
                field(CheckpointDesc4; Rec."Checkpoint Desc 4")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Checkpoint Desc 4 field.';
                }
                field(DateCreated; Rec."Date Created")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Created field.';
                }
                field(CreatedBy; Rec."Created By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Created By field.';
                }
                field(FindingDesc1; Rec."Finding Desc 1")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Finding Desc 1 field.';
                }
                field(FindingDesc2; Rec."Finding Desc 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Finding Desc 2 field.';
                }
                field(FindingDesc3; Rec."Finding Desc 3")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Finding Desc 3 field.';
                }
                field(FindingCitation1; Rec."Finding Citation 1")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Finding Citation 1 field.';
                }
                field(FindingCitation2; Rec."Finding Citation 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Finding Citation 2 field.';
                }
                field(FindingDesc4; Rec."Finding Desc 4")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Finding Desc 4 field.';
                }
                field(FindingStatus; Rec."Finding Status")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Finding Status field.';
                }
                field(RejectedCount; Rec."Rejected Count")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Rejected Count field.';
                }
                field(Department; Rec.Department)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Department field.';
                }
                field(Classification; Rec.Classification)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Classification field.';
                }
                field(ApprovalComments; Rec."Approval Comments")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Approval Comments field.';
                }
                field(AuditProgramme; Rec."Audit Programme")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Audit Programme field.';
                }
                field(AuditNo; Rec."Audit No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Audit No field.';
                }
            }
        }
    }

    actions { }
}

