Page 51033 "Project Partners"
{
    PageType = list;
    SourceTable = "Project Partners";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
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
                field(ContractorType; Rec."Contractor Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Contractor Type field.';
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
                field(Balance; Rec.Balance)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Balance field.';
                }
                field(AccountedAmount; Rec."Accounted Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Accounted Amount field.';
                }
            }
        }
    }

    actions { }

    trigger OnAfterGetRecord()
    begin
        Rec.Balance := Rec."Partner Budget" - Rec."Disbursed Amount (LCY)";
    end;
}

