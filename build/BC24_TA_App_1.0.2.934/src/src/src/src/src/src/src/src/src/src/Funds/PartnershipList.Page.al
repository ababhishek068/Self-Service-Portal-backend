Page 50707 "Partnership List"
{
    PageType = ListPart;
    SourceTable = "CompanyInfo Partnership";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(CompanyInfoQuestionaireNo; Rec."CompanyInfo Questionaire No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the CompanyInfo Questionaire No field.';
                }
                field("TIN No"; Rec."TIN No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the PIN No. field.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field(Nationality; Rec.Nationality)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Nationality field.';
                }
                field(SharesHeld; Rec."Shares Held")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Shares Held field.';
                }
            }
        }
    }

    actions { }
}

