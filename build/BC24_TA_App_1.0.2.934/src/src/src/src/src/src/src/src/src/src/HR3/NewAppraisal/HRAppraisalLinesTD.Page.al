Page 51112 "HR Appraisal Lines - TD"
{
    Caption = 'HR Appraisal Lines - Training and Development Plan';
    PageType = ListPart;
    SourceTable = "HR Appraisal Lines - Training";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Name of the Course"; Rec."Name of the Course")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Name of the Course field.';
                }
                field("Duration of Course"; Rec."Duration of Course")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Duration of Course field.';
                }
                field("Expected Start Date"; Rec."Expected Start Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Expected Start Date field.';
                }
                field("Expected End Date"; Rec."Expected End Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Expected End Date field.';
                }
                label("*")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ShowCaption = true;
                }
                field(Reaction; Rec.Reaction)
                {
                    ApplicationArea = Basic;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Reaction on the Training Attended field.';
                }
                field("Learning Obtained"; Rec."Learning Obtained")
                {
                    ApplicationArea = Basic;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Learning Obtained from the Training field.';
                }
                field("Behavior Changes Adopted"; Rec."Behavior Changes Adopted")
                {
                    ApplicationArea = Basic;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Behavior Changes Adopted field.';
                }
                field("Results Obtained"; Rec."Results Obtained")
                {
                    ApplicationArea = Basic;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Results Obtained field.';
                }
                field("Remarks Appraisee"; Rec."Remarks Appraisee")
                {
                    ApplicationArea = Basic;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Remarks Appraisee field.';
                }
                field("Remarks Supervisor"; Rec."Remarks Supervisor")
                {
                    ApplicationArea = Basic;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Remarks Supervisor field.';
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

