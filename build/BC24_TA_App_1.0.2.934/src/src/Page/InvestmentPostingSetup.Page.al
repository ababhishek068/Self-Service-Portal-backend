Page 50171 "Investment Posting Setup"
{
    PageType = List;
    SourceTable = "Investment Posting Setup";
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
                field("Investment Account"; Rec."Investment Account")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Investment Account field.';
                }
                field("Interest Account"; Rec."Interest Account")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Interest Account field.';
                }
                field("Accrual Account"; Rec."Accrual Account")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Accrual Account field.';
                }
                field("Withholding Tax Account"; Rec."Withholding Tax Account")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Withholding Tax Account field.';
                }
            }
        }
    }

    actions { }
}

