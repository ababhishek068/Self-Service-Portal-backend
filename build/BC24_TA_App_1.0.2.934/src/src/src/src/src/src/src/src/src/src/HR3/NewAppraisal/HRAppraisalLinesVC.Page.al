Page 51113 "HR Appraisal Lines - VC"
{
    PageType = ListPart;
    SourceTable = "HR Appraisal Lines - Values-UP";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Appraisal No."; Rec."Appraisal No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Appraisal No. field.';
                }
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(Category; Rec.Category)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Category field.';
                }
                field("Appraisal Assesment"; Rec."Appraisal Assesment")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Appraisal Assesment field.';
                }
                field(Score; Rec.Score)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Score field.';
                }
                field("Score Descriptors"; Rec."Score Descriptors")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Score Descriptors field.';
                }
                field("Supervisor Score"; Rec."Supervisor Score")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Supervisor Score field.';
                }
                field("Supervisor Score Descriptors"; Rec."Supervisor Score Descriptors")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Supervisor Score Descriptors field.';
                }
                field("Agreed Score"; Rec."Agreed Score")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Agreed Score field.';
                }
                field("Agreed Score Descriptors"; Rec."Agreed Score Descriptors")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Agreed Score Descriptors field.';
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

