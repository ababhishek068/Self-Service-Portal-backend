Page 51088 "Appraisal Evaluation Lines"
{
    PageType = List;
    SourceTable = "Appraisal Evaluation Lines";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Appraisal Code"; Rec."Appraisal Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Appraisal Code field.';
                }
                field(Objective; Rec.Objective)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Objective field.';
                }
                field(Target; Rec.Target)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Target field.';
                }
                field(Activity; Rec.Activity)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Activity field.';
                }
                field("Resources Required"; Rec."Resources Required")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Resources Required field.';
                }
                field("Expected Results"; Rec."Expected Results")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Expected Results field.';
                }
                field("Time Frame"; Rec."Time Frame")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Time Frame field.';
                }
                field("Performance Indicator"; Rec."Performance Indicator")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Performance Indicator field.';
                }
                field("Appraisee Score"; Rec."Appraisee Score")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Appraisee Score field.';
                }
                field("Supervisor Score"; Rec."Supervisor Score")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Supervisor Score field.';
                }
                field("Agreed Score"; Rec."Agreed Score")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Agreed Score field.';
                }
            }
        }
    }

    actions { }
}

