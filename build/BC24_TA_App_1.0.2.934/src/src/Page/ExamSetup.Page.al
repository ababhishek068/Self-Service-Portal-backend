Page 51397 "Exam Setup"
{
    PageType = List;
    SourceTable = "Exams Setup";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field(Category; Rec.Category)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Category field.';
                }
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Desription; Rec.Desription)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Desription field.';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field(MaxScore; Rec."Max. Score")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Max. Score field.';
                }
                field(ContribFinalScore; Rec."% Contrib. Final Score")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the % Contrib. Final Score field.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
            }
        }
    }

    actions { }
}

