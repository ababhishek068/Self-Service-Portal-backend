Page 51075 "Exams Set Up"
{
    PageType = Card;
    SourceTable = "Exams Setup";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
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
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field(GLAccount; Rec."G/L Account")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the G/L Account field.';
                }
                field(Department; Rec.Department)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Department field.';
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

