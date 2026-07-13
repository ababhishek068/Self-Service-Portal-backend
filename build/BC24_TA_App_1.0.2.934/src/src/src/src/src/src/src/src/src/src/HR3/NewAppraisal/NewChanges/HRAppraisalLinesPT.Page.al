Page 51120 "HR Appraisal Lines - PT"
{
    Caption = 'HR Appraisal Lines - Performance Targets';
    PageType = ListPart;
    SourceTable = "HR Appraisal Lines - PT";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Agreed Performance Targets"; Rec."Agreed Performance Targets")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Agreed Performance Targets field.';
                }
                field("Key Performance Indicator"; Rec."Key Performance Indicator")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Key Performance Indicator field.';
                }
                field("Key Result Areas (Output)"; Rec."Key Result Areas (Output)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Key Result Areas (Output) field.';
                }
                field(Weight; Rec.Weight)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Weight field.';
                }
                field(Unit; Rec.Unit)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Unit field.';
                }
                field("Self Assesment"; Rec."Self Assesment")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Self-Assessment (Results Achieved) field.';
                }
                field("Self-Score"; Rec."Self-Score")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Self-Score field.';
                }
                field("Supervisor-Assesment"; Rec."Supervisor-Assesment")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Supervisor''s Assessment (Results Achieved) field.';
                }
                field("Supervisors Score"; Rec."Supervisors Score")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Supervisors Score field.';
                }
                field("Agreed-Assesment Results"; Rec."Agreed-Assesment Results")
                {
                    ApplicationArea = Basic;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Agreed Assessment (Results Achieved) field.';
                }
                field("Agreed Score"; Rec."Agreed Score")
                {
                    ApplicationArea = Basic;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Agreed Score field.';
                }
                field("Appraisee Comments"; Rec."Appraisee Comments")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Appraisee Comments(Target Settings) field.';
                }
                field("Supervisor Comments"; Rec."Supervisor Comments")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Supervisor Comments field.';
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Line No. field.';
                }
            }
        }
    }

    actions { }
}

