Page 50550 "Audit Findings Actions"
{
    PageType = List;
    SourceTable = "Audit Findings Actions";
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
                field(FindingCode; Rec."Finding Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Finding Code field.';
                }
                field(ActionClassification; Rec."Action Classification")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Action Classification field.';
                }
                field(ReviewArea; Rec."Review Area")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Review Area field.';
                }
                field(RequirementDesc1; Rec."Requirement Desc 1")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Requirement Desc 1 field.';
                }
                field(RequirementDesc2; Rec."Requirement Desc 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Requirement Desc 2 field.';
                }
                field(EvidenceDesc1; Rec."Evidence Desc 1")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Evidence Desc 1 field.';
                }
                field(EvidenceDesc2; Rec."Evidence Desc 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Evidence Desc 2 field.';
                }
                field(EvidenceDesc3; Rec."Evidence Desc 3")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Evidence Desc 3 field.';
                }
                field(RootCause; Rec."Root Cause")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Root Cause field.';
                }
                field(CorrectionDesc1; Rec."Correction Desc 1")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Correction Desc 1 field.';
                }
                field(CorrectionDesc2; Rec."Correction Desc 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Correction Desc 2 field.';
                }
                field(CorrectionDesc3; Rec."Correction Desc 3")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Correction Desc 3 field.';
                }
                field(CorrectionDesc4; Rec."Correction Desc 4")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Correction Desc 4 field.';
                }
                field(Recurrenceaction1; Rec."Recurrence action 1")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Recurrence action 1 field.';
                }
                field(Recurrenceaction2; Rec."Recurrence action 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Recurrence action 2 field.';
                }
                field(CompletionDate; Rec."Completion Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Completion Date field.';
                }
                field(ActionAppropriate; Rec."Action Appropriate?")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Action Appropriate? field.';
                }
                field(FollowUpAction; Rec."Follow Up Action")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Follow Up Action field.';
                }
                field(FollowUpStatus; Rec."Follow Up Status")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Follow Up Status field.';
                }
                field(ActionEffective; Rec."Action Effective?")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Action Effective? field.';
                }
                field(EffectivenessDesc; Rec."Effectiveness Desc")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Effectiveness Desc field.';
                }
                field(EffectivenessStatus; Rec."Effectiveness Status")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Effectiveness Status field.';
                }
                field(FindingClassification; Rec."Finding Classification")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Finding Classification field.';
                }
            }
        }
        area(factboxes)
        {


            part("Attached Documents"; "Document Attachments")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(51585),
                              "No." = FIELD("Code");
            }

            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
                Visible = true;
            }
        }

    }


    actions { }
}

