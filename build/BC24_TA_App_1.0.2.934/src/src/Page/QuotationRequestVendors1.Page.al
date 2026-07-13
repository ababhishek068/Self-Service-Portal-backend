Page 50227 "Quotation Request Vendors1"
{
    PageType = List;
    SourceTable = "Quotation Request Vendors";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Requisition Document No."; Rec."Requisition Document No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Requisition Document No. field.';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Document Type field.';
                }
                field("Request Summary"; Rec."Request Summary")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Request Summary field.';
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Vendor No. field.';
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Vendor Name field.';
                }

            }
        }
    }

    actions { }
}

