page 50060 "Direct Voucher List GreenCom"
{
    ApplicationArea = All;
    Caption = 'Direct Voucher List GreenCom';
    PageType = List;
    SourceTable = "Payment Header GreenCom";
    UsageCategory = Lists;
    CardPageId = "Direct Voucher ";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("PV No"; Rec."PV No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the PV No field.';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document Type field.';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document Date field.';
                }
                field("Posting Description"; Rec."Posting Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posting Description field.';
                }
                field("Paying Bank"; Rec."Paying Bank")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Paying Bank field.';
                }
                field("Paying Bank Name"; Rec."Paying Bank Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Paying Bank Name field.';
                }
                field("Raised By"; Rec."Raised By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Raised By field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Payment Mode"; Rec."Payment Mode")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payment Mode field.';
                }
                field("Cheque No"; Rec."Cheque No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Cheque No field.';
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Vendor No. field.';
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Vendor Name field.';
                }
            }
        }
    }
}
