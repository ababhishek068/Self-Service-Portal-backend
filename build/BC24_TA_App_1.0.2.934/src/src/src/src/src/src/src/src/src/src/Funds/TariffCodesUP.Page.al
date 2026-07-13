Page 50872 "Tariff Codes UP"
{
    DeleteAllowed = false;
    Editable = true;
    PageType = Card;
    SourceTable = "Tariff Codes";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102758000)
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
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field(Percentage; Rec.Percentage)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Percentage field.';
                }
                field(GLAccount; Rec."G/L Account")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the G/L Account field.';
                }
                field(AccountType; Rec."Account Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Account Type field.';
                }
                field(AccountNo; Rec."Account No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Account No. field.';
                }
                field("Not Reducing Net"; Rec."Not Reducing Net")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Not Reducing Net field.';
                }
            }
        }
    }

    actions { }
}

