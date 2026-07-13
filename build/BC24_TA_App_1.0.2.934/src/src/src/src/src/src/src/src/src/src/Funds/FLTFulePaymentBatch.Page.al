page 50630 "FLT Fule Payment Batch"
{
    PageType = Card;
    SourceTable = "FLT-Fuel Payment Batch";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Batch No"; Rec."Batch No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Batch No field.';
                }
                field("Date Created"; Rec."Date Created")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Created field.';
                }
                field("Created by"; Rec."Created by")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Created by field.';
                }
                field("Vendor No"; Rec."Vendor No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Vendor No field.';
                }
                field("Date Closed"; Rec."Date Closed")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Closed field.';
                }
                field("Closed By"; Rec."Closed By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Closed By field.';
                }
                field("Total Payable"; Rec."Total Payable")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Total Payable field.';
                }
                field("No. Series"; Rec."No. Series")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No. Series field.';
                }
                field(Closed; Rec.Closed)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Closed field.';
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Vendor Name field.';
                }
                field(From; Rec.From)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the From field.';
                }
                field(DTo; Rec.DTo)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the To field.';
                }
                field(Invoiced; Rec.Invoiced)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Invoiced field.';
                }
                field("Invoice No."; Rec."Invoice No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Invoice No. field.';
                }
                field("Invoiced By"; Rec."Invoiced By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Invoiced By field.';
                }
            }
            part(Line; "FLT Fuel Lines")
            {
                ApplicationArea = Basic;
                Caption = 'Line';
                Editable = false;
                SubPageLink = "Payment Batch No" = FIELD("Batch No");
            }
        }
    }

    actions { }
}

