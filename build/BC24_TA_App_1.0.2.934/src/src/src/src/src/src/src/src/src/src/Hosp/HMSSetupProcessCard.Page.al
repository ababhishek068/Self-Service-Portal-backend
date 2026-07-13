Page 50523 "HMS Setup Process Card"
{
    PageType = Card;
    SourceTable = "HMS Setup Process";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Control1)
            {
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
                field(Mandatory; Rec.Mandatory)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Mandatory field.';
                }
                field(GLAccount; Rec."G/L Account")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the G/L Account field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
            }
        }
    }

    actions { }
}

