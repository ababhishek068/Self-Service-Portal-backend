Page 50248 "Investment Setup"
{
    PageType = Card;
    SourceTable = "Investment Setup";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Investment Template"; Rec."Investment Template")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Investment Template field.';
                }
                field("Investment Batch"; Rec."Investment Batch")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Investment Batch field.';
                }
                field("Investment G/L Account"; Rec."Investment G/L Account")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Investment G/L Account field.';
                }
                field("Interest G/L Account"; Rec."Interest G/L Account")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Interest G/L Account field.';
                }
                field("Treasury Bill Investment A/C"; Rec."Treasury Bill Investment A/C")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Treasury Bill Investment A/C field.';
                }
                field("Treasury Bill Interest Account"; Rec."Treasury Bill Interest Account")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Treasury Bill Interest Account field.';
                }
                field("Withholding Tax G/L Account"; Rec."Withholding Tax G/L Account")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Withholding Tax G/L Account field.';
                }
            }
            group(Numbering)
            {
                field("Investment Nos"; Rec."Investment Nos")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Investment Nos field.';
                }
                field("Treasury Bill Nos"; Rec."Treasury Bill Nos")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Treasury Bill Nos field.';
                }
            }
        }
    }

    actions { }
}

