Page 51042 "Bank List"
{
    PageType = ListPart;
    SourceTable = "CompanyInfo Banks";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(CompanyInfoQuestionaireNo; Rec."Company Info Questionaire No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Company Info Questionaire No field.';
                }
                field("TIN No"; Rec."TIN No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the PIN No. field.';
                }
                field(NameOfBank; Rec."Name Of Bank")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Name Of Bank field.';
                }
                field(AmountDepositedBank; Rec."Amount Deposited Bank")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Amount Deposited Bank field.';
                }
                field(AccountNameInBank; Rec."Account Name In Bank")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Account Name In Bank field.';
                }
            }
        }
    }

    actions { }
}

