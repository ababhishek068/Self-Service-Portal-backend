Page 50700 "Tender Card"
{
    PageType = Card;
    SourceTable = "Tender";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(TenderID; Rec."Tender ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Tender ID field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Internal Requisition No."; "Internal Requisition No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Links to the purchase requisition no';
                    Editable = true;
                    Visible = true;
                }
                field(DateCreated; Rec."Date Created")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Date Created field.';
                }
                field(CreatedBy; Rec."Created By")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Created By field.';
                }
                field(TenderType; Rec."Tender Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Tender Type field.';
                }
                field(Open; Rec.Open)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Open field.';
                }
                field(Category; Rec.Category)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Category field.';
                }
                field(ValidFrom; Rec."Valid From")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Valid From field.';
                }
                field(ValidTo; Rec."Valid To")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Valid To field.';
                }
            }
            part(Control12; "Tender Product List")
            {
                Caption = 'Items';
                SubPageLink = "Tender No" = field("Tender ID");
            }
            part(Control13; "Tender Specifications List")
            {
                Caption = 'Specifications';
                SubPageLink = "Tender No" = field("Tender ID");
            }
        }
    }

    actions { }
}

