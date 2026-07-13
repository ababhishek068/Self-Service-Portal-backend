Page 50044 "Donor I/C Account List"
{
    PageType = List;
    SourceTable = "Donor IC G/L Account";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field(AccountType; Rec."Account Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Account Type field.';
                }
                field(IncomeBalance; Rec."Income/Balance")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Income/Balance field.';
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Blocked field.';
                }
                field(MaptoGLAccNo; Rec."Map-to G/L Acc. No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Map-to G/L Acc. No. field.';
                }
                field(Indentation; Rec.Indentation)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Indentation field.';
                }
                field(Donor; Rec.Donor)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Donor field.';
                }
            }
        }
    }

    actions { }
}

