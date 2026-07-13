Page 51353 "Quotation Request Vendors"
{
    PageType = Card;
    SourceTable = "Quotation Request Vendors";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102756000)
            {
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Document Type field.';
                }
                field("Supplier Category"; Rec."Supplier Category")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Supplier Category field.';
                }
                field(VendorNo; Rec."Vendor No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Vendor No. field.';
                }
                field(VendorName; Rec."Vendor Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Vendor Name field.';
                }
            }
        }
    }

    actions { }
}

