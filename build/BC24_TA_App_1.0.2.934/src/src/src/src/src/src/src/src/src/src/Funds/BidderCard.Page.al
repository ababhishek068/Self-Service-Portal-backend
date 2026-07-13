Page 51416 "Bidder Card"
{
    PageType = Card;
    SourceTable = "Bidder";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("TIN No"; Rec."PIN No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the PIN No field.';
                }
                field(DateCreated; Rec."Date Created")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Created field.';
                }
                field(CreatedBy; Rec."Created By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Created By field.';
                }
                field(Password; Rec.Password)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Password field.';
                }
                field(TendererName; Rec."Tenderer Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Tenderer Name field.';
                }
                field(ChangedPassword; Rec."Changed Password")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Changed Password field.';
                }
                field(ProcurementOfficer; Rec."Procurement Officer")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Procurement Officer field.';
                }
                field(PostedToPortal; Rec."Posted To Portal")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Posted To Portal field.';
                }
            }
            part(Control11; "Bidder Tender List")
            {
                SubPageLink = "TIN No." = field("PIN No");
            }
        }
    }

    actions { }
}

