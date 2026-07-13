page 50336 "Appraisal Types"
{
    PageType = List;
    SourceTable = "Appraisal Types";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Code"; Rec.Code)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Max. Weighting"; Rec."Max. Weighting")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Max. Weighting field.';
                }
                field("Max. Score"; Rec."Max. Score")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Max. Score field.';
                }
                field("Use Template"; Rec."Use Template")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Use Template field.';
                }
                field("Template Link"; Rec."Template Link")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Template Link field.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Appraisal)
            {
                Caption = 'Appraisal';
                action("Appraisal Format")
                {
                    Caption = 'Appraisal Format';
                    RunObject = Page "Appraisal Criteria";
                    RunPageLink = Criteria = FIELD(Code);
                    ToolTip = 'Executes the Appraisal Format action.';
                }
            }
        }
    }
}

