Page 50339 "Reporing Period"
{
    PageType = Card;
    SourceTable = "Reporting Date";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                field("code"; Rec.code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the code field.';
                }
                field(FinancialReportingDate; Rec."Financial Reporting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Financial Reporting Date field.';
                }
                field(TechnicalReportingDate; Rec."Technical Reporting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Technical Reporting Date field.';
                }
            }
        }
    }

    actions { }
}

