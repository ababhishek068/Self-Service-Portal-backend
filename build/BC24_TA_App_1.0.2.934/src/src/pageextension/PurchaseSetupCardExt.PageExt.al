pageextension 50008 "Purchase Setup Card Ext" extends "Purchases & Payables Setup"
{
    layout
    {
        addafter("Copy Line Descr. to G/L Entry")
        {
            field("Portal Path"; Rec."Portal Path")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Portal Path field.';
            }
            field("Portal URL"; Rec."Portal URL")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Portal URL field.';
            }
            field("Item GL Budget"; Rec."Item GL Budget")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Item GL Budget field.';
            }
            field("Enable Vendor Notifications"; Rec."Enable Vendor Notifications")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Enable Vendor Notifications field.';
            }
            field("Supplier Support Address"; Rec."Supplier Support Address")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Supplier Support Address field.';
            }
            field("RFQ Committee Members Limit"; Rec."RFQ Committee Members Limit")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the RFQ Committee Members Limit field.';
            }
            field("Auto Convert Quote to Order"; Rec."Auto Convert Quote to Order")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Auto Convert Quote to Order field.';
            }
            field("LPO Report No."; Rec."LPO Report No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the LPO Report No. field.';
            }
            field("Disable printing of open LPO"; Rec."Disable printing of open LPO")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Disable printing of open LPO field.';
            }
            field("Default Vendor Posting Group"; Rec."Default Vendor Posting Group")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Default Vendor Posting Group field.';
            }
        }

        addafter("Posted Credit Memo Nos.")
        {
            field("Requisition No"; Rec."Requisition No")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Requisition No field.';
            }
            field("Quotation Request No"; Rec."Quotation Request No")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Quotation Request No. field.';
            }
            field("Company Workplan Nos."; Rec."Company Workplan Nos.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Company Workplan Nos. field.';
            }

            field("Contract No."; Rec."Contract No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Contract No. field.';
            }
            field("Contract Addendum Nos"; Rec."Contract Addendum Nos")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Contract Addendum Nos field.';
            }

            field("Disposal No."; Rec."Disposal No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Disposal No. field.';
            }
            field("Requisition Default Vendor"; "Requisition Default Vendor")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Requisition Default Vendor field.';
            }
            field("Disposal Plan No."; Rec."Disposal Plan No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Disposal Plan No. field.';
            }
            field("Vendor Buffer No."; Rec."Vendor Buffer No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Vendor Buffer No. field.';
            }
            field("Tender Bid Nos"; Rec."Tender Bid Nos")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Tender Bid Nos field.';
            }
            field("Minutes Nos";"Minutes Nos"){}
            field("Inspection Nos.";"Inspection Nos."){}
            field("Appointment Nos.";"Appointment Nos."){}
            field("Shipment Notification Nos"; Rec."Shipment Notification Nos")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Shipment Notification Nos field.';
            }
            field("EOI Nos"; Rec."EOI Nos")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Expression of Intrest Nos field.';
            }

        }

        addafter("Report Output Type")
        {
            field("Low Value Proc Service"; Rec."Low Value Proc Service")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Low Value Proc Service field.';
            }
            field("Purch Req Validate Quatity"; Rec."Purch Req Validate Quatity")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Purch Req Validate Quatity field.';
            }

        }
    }
}



