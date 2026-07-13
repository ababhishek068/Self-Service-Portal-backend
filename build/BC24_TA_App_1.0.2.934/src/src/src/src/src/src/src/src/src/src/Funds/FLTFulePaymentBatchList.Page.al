Page 50631 "FLT Fule Payment Batch List"
{
    CardPageID = "FLT Fule Payment Batch";
    PageType = List;
    SourceTable = "FLT-Fuel Payment Batch";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(BatchNo; Rec."Batch No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Batch No field.';
                }
                field(DateCreated; Rec."Date Created")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Created field.';
                }
                field(Createdby; Rec."Created by")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Created by field.';
                }
                field(VendorNo; Rec."Vendor No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Vendor No field.';
                }
                field(DateClosed; Rec."Date Closed")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Closed field.';
                }
                field(ClosedBy; Rec."Closed By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Closed By field.';
                }
                field(TotalPayable; Rec."Total Payable")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Total Payable field.';
                }
                field(NoSeries; Rec."No. Series")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No. Series field.';
                }
                field(Closed; Rec.Closed)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Closed field.';
                }
                field(VendorName; Rec."Vendor Name")
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
                field(InvoiceNo; Rec."Invoice No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Invoice No. field.';
                }
                field(InvoicedBy; Rec."Invoiced By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Invoiced By field.';
                }
            }
        }
    }

    actions { }
}

