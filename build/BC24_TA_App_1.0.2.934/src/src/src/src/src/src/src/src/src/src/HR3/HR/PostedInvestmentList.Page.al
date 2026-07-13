Page 50529 "Posted Investment List"
{
    CardPageID = "Posted Investment Card";
    Editable = false;
    PageType = List;
    SourceTable = "Investment Header";
    SourceTableView = where("Investment Rollover Status" = filter(Closed),
                            "Investment Category" = filter(FDR));
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
                field(InvestmentStartDate; Rec."Investment Start Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Investment Start Date field.';
                }
                field(InvestmentEndDate; Rec."Investment End Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Investment End Date field.';
                }
                field(DocumentDate; Rec."Document Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Document Date field.';
                }
                field(InvestmentCompanyCode; Rec."Investment Company Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Investment Company Code field.';
                }
                field(InvestmentCompanyName; Rec."Investment Company Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Investment Company Code field.';
                }
                field(InvestmentRate; Rec."Investment Rate")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Investment Rate field.';
                }
                field(InvestmentWithholdingTax; Rec."Investment Withholding Tax")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Investment Withholding Tax field.';
                }
                field(InvestmentType; Rec."Investment Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Investment Type field.';
                }
                field(InvestmentPrincipal; Rec."Investment Principal")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Investment Principal field.';
                }
                field(InvestmentDuration; Rec."Investment Duration")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Investment Duration field.';
                }
                field(InvestmentRolloverStatus; Rec."Investment Rollover Status")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Investment Rollover Status field.';
                }
                field(InterestEarned; Rec."Interest Earned")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Interest Earned field.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control18; MyNotes) { }
            systempart(Control19; Links) { }
        }
    }

    actions { }
}

