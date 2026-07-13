Report 50294 "Inspection Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/InspectionReport.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            DataItemTableView = where(Status = filter(Released));
            RequestFilterFields = "Document Type", "No.";
            column(ReportForNavId_1; 1) { }
            column(BuyfromVendorNo_PurchaseHeader; "Purchase Header"."Buy-from Vendor No.") { }
            column(OrderDate_PurchaseHeader; "Purchase Header"."Order Date") { }
            column(No_PurchaseHeader; "Purchase Header"."No.") { }
            column(BuyfromVendorName_PurchaseHeader; "Purchase Header"."Buy-from Vendor Name") { }
            column(OrderDate; PurchRcptHeader."Order Date") { }
            column(AmountIncludingVAT_PurchaseHeader; "Purchase Header"."Amount Including VAT") { }
            column(DeliveryDate; DeliveryDate) { }
            column(Amount_Including_VAT; "Amount Including VAT") { }
            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLink = "Document Type" = field("Document Type"), "Document No." = field("No.");
                DataItemTableView = sorting("Document Type", "Document No.", "Line No.");
                RequestFilterFields = "Document Type", "Document No.", "Line No.";
                column(ReportForNavId_2; 2) { }
                column(DocumentType_PurchaseLine; "Purchase Line"."Document Type") { }
                column(BuyfromVendorNo_PurchaseLine; "Purchase Line"."Buy-from Vendor No.") { }
                column(DocumentNo_PurchaseLine; "Purchase Line"."Document No.") { }
                column(LineNo_PurchaseLine; "Purchase Line"."Line No.") { }
                column(Type_PurchaseLine; "Purchase Line".Type) { }
                column(No_PurchaseLine; "Purchase Line"."No.") { }
                column(LocationCode_PurchaseLine; "Purchase Line"."Location Code") { }
                column(PostingGroup_PurchaseLine; "Purchase Line"."Posting Group") { }
                column(ExpectedReceiptDate_PurchaseLine; "Purchase Line"."Expected Receipt Date") { }
                column(Description_PurchaseLine; "Purchase Line".Description) { }
                column(Description2_PurchaseLine; "Purchase Line"."Description 2") { }
                column(UnitofMeasure_PurchaseLine; "Purchase Line"."Unit of Measure") { }
                column(Quantity_PurchaseLine; "Purchase Line".Quantity) { }
                column(OutstandingQuantity_PurchaseLine; "Purchase Line"."Outstanding Quantity") { }
                column(QtytoInvoice_PurchaseLine; "Purchase Line"."Qty. to Invoice") { }
                column(QtytoReceive_PurchaseLine; "Purchase Line"."Qty. to Receive") { }
                column(DirectUnitCost_PurchaseLine; "Purchase Line"."Direct Unit Cost") { }
                column(UnitCostLCY_PurchaseLine; "Purchase Line"."Unit Cost (LCY)") { }
                column(VAT_PurchaseLine; "Purchase Line"."VAT %") { }
                column(LineDiscount_PurchaseLine; "Purchase Line"."Line Discount %") { }
                column(LineDiscountAmount_PurchaseLine; "Purchase Line"."Line Discount Amount") { }
                column(Amount_PurchaseLine; "Purchase Line".Amount) { }
                column(AmountIncludingVAT_PurchaseLine; "Purchase Line"."Amount Including VAT") { }
                column(UnitPriceLCY_PurchaseLine; "Purchase Line"."Unit Price (LCY)") { }
                column(AllowInvoiceDisc_PurchaseLine; "Purchase Line"."Allow Invoice Disc.") { }
                column(GrossWeight_PurchaseLine; "Purchase Line"."Gross Weight") { }
                column(NetWeight_PurchaseLine; "Purchase Line"."Net Weight") { }
                column(UnitsperParcel_PurchaseLine; "Purchase Line"."Units per Parcel") { }
                column(UnitVolume_PurchaseLine; "Purchase Line"."Unit Volume") { }
                column(AppltoItemEntry_PurchaseLine; "Purchase Line"."Appl.-to Item Entry") { }
                column(ShortcutDimension1Code_PurchaseLine; "Purchase Line"."Shortcut Dimension 1 Code") { }
                column(ShortcutDimension2Code_PurchaseLine; "Purchase Line"."Shortcut Dimension 2 Code") { }
                column(JobNo_PurchaseLine; "Purchase Line"."Job No.") { }
                column(IndirectCost_PurchaseLine; "Purchase Line"."Indirect Cost %") { }
                column(RecalculateInvoiceDisc_PurchaseLine; "Purchase Line"."Recalculate Invoice Disc.") { }
                column(OutstandingAmount_PurchaseLine; "Purchase Line"."Outstanding Amount") { }
                column(QtyRcdNotInvoiced_PurchaseLine; "Purchase Line"."Qty. Rcd. Not Invoiced") { }
                column(AmtRcdNotInvoiced_PurchaseLine; "Purchase Line"."Amt. Rcd. Not Invoiced") { }
                column(QtyReceived_PurchaseLine; "Purchase Line"."Quantity Received") { }
                column(QuantityInvoiced_PurchaseLine; "Purchase Line"."Quantity Invoiced") { }
                column(ReceiptNo_PurchaseLine; "Purchase Line"."Receipt No.") { }
                column(ReceiptLineNo_PurchaseLine; "Purchase Line"."Receipt Line No.") { }
                column(Profit_PurchaseLine; "Purchase Line"."Profit %") { }
                column(PaytoVendorNo_PurchaseLine; "Purchase Line"."Pay-to Vendor No.") { }
                column(InvDiscountAmount_PurchaseLine; "Purchase Line"."Inv. Discount Amount") { }
                column(CompanyINfoName; Logos.Name) { }
                column(CompanyINfoAdd; Logos.Address) { }
                column(CompanyINfoPicture; Logos.Picture) { }
                column(RFQRemarks_PurchaseLine; "Purchase Line"."RFQ Remarks") { }
                column(ShortcutDimension1Code_PurchaseHeader; "Purchase Header"."Shortcut Dimension 1 Code") { }

                trigger OnAfterGetRecord()
                begin
                    Logos.Reset;
                    if Logos.Find('-') then begin
                        Logos.CalcFields(Logos.Picture);
                    end else begin
                        Logos.Reset;
                        Logos.CalcFields(Logos.Picture);
                    end;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if DeliveryDate = 0D then
                    DeliveryDate := Today;
            end;
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }

    var
        Logos: Record "Company Information";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        DeliveryDate: Date;
}

