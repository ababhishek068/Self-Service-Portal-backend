Page 50471 "Project Partners (InE)"
{
    Editable = false;
    PageType = Card;
    SourceTable = "Project Partners";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                field(GrantNo; Rec."Grant No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Grant No field.';
                }
                field(PartnerID; Rec.PartnerID)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the PartnerID field.';
                }
                field(PartnerName; Rec."Partner Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Partner Name field.';
                }
                field(PartnerBudget; Rec."Partner Budget")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Partner Budget field.';
                }
                field(DisbursedAmountLCY; Rec."Disbursed Amount (LCY)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Disbursed Amount (LCY) field.';
                }
            }
        }
    }

    actions { }
}

