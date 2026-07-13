Report 50295 "Inspection Certificate1"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/InspectionCertificate1.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Purch. Rcpt. Header"; "Purch. Rcpt. Header")
        {
            column(ReportForNavId_1; 1) { }
            column(BuyfromVendorNo_PurchRcptHeader; "Purch. Rcpt. Header"."Buy-from Vendor No.") { }
            column(No_PurchRcptHeader; "Purch. Rcpt. Header"."No.") { }
            column(OrderDate_PurchRcptHeader; "Purch. Rcpt. Header"."Order Date") { }
            column(PostingDate_PurchRcptHeader; "Purch. Rcpt. Header"."Posting Date") { }
            column(ShortcutDimension1Code_PurchRcptHeader; "Purch. Rcpt. Header"."Shortcut Dimension 1 Code") { }
            column(ShortcutDimension2Code_PurchRcptHeader; "Purch. Rcpt. Header"."Shortcut Dimension 2 Code") { }
            column(OrderNo_PurchRcptHeader; "Purch. Rcpt. Header"."Order No.") { }
            column(BuyfromVendorName_PurchRcptHeader; "Purch. Rcpt. Header"."Buy-from Vendor Name") { }

            dataitem("Purch. Rcpt. Line"; "Purch. Rcpt. Line")
            {
                DataItemLink = "Document No." = field("No.");
                column(ReportForNavId_10; 10) { }
                column(BuyfromVendorNo_PurchRcptLine; "Purch. Rcpt. Line"."Buy-from Vendor No.") { }
                column(DocumentNo_PurchRcptLine; "Purch. Rcpt. Line"."Document No.") { }
                column(LineNo_PurchRcptLine; "Purch. Rcpt. Line"."Line No.") { }
                column(Type_PurchRcptLine; "Purch. Rcpt. Line".Type) { }
                column(No_PurchRcptLine; "Purch. Rcpt. Line"."No.") { }
                column(LocationCode_PurchRcptLine; "Purch. Rcpt. Line"."Location Code") { }
                column(PostingGroup_PurchRcptLine; "Purch. Rcpt. Line"."Posting Group") { }
                column(ExpectedReceiptDate_PurchRcptLine; "Purch. Rcpt. Line"."Expected Receipt Date") { }
                column(Description_PurchRcptLine; "Purch. Rcpt. Line".Description) { }
                column(Description2_PurchRcptLine; "Purch. Rcpt. Line"."Description 2") { }
                column(UnitofMeasure_PurchRcptLine; "Purch. Rcpt. Line"."Unit of Measure") { }
                column(Quantity_PurchRcptLine; "Purch. Rcpt. Line".Quantity) { }
                column(DirectUnitCost_PurchRcptLine; "Purch. Rcpt. Line"."Direct Unit Cost") { }
                column(UnitCostLCY_PurchRcptLine; "Purch. Rcpt. Line"."Unit Cost (LCY)") { }
                column(VAT_PurchRcptLine; "Purch. Rcpt. Line"."VAT %") { }
                column(LineDiscount_PurchRcptLine; "Purch. Rcpt. Line"."Line Discount %") { }
                column(UnitPriceLCY_PurchRcptLine; "Purch. Rcpt. Line"."Unit Price (LCY)") { }
                column(AllowInvoiceDisc_PurchRcptLine; "Purch. Rcpt. Line"."Allow Invoice Disc.") { }
                column(GrossWeight_PurchRcptLine; "Purch. Rcpt. Line"."Gross Weight") { }
                column(NetWeight_PurchRcptLine; "Purch. Rcpt. Line"."Net Weight") { }
                column(UnitsperParcel_PurchRcptLine; "Purch. Rcpt. Line"."Units per Parcel") { }
                column(UnitVolume_PurchRcptLine; "Purch. Rcpt. Line"."Unit Volume") { }
                column(AppltoItemEntry_PurchRcptLine; "Purch. Rcpt. Line"."Appl.-to Item Entry") { }
                column(ItemRcptEntryNo_PurchRcptLine; "Purch. Rcpt. Line"."Item Rcpt. Entry No.") { }
                column(ShortcutDimension1Code_PurchRcptLine; "Purch. Rcpt. Line"."Shortcut Dimension 1 Code") { }
                column(ShortcutDimension2Code_PurchRcptLine; "Purch. Rcpt. Line"."Shortcut Dimension 2 Code") { }
                column(JobNo_PurchRcptLine; "Purch. Rcpt. Line"."Job No.") { }
                column(IndirectCost_PurchRcptLine; "Purch. Rcpt. Line"."Indirect Cost %") { }
                column(QtyRcdNotInvoiced_PurchRcptLine; "Purch. Rcpt. Line"."Qty. Rcd. Not Invoiced") { }
                column(QuantityInvoiced_PurchRcptLine; "Purch. Rcpt. Line"."Quantity Invoiced") { }
                column(OrderNo_PurchRcptLine; "Purch. Rcpt. Line"."Order No.") { }
                column(OrderLineNo_PurchRcptLine; "Purch. Rcpt. Line"."Order Line No.") { }
                column(PaytoVendorNo_PurchRcptLine; "Purch. Rcpt. Line"."Pay-to Vendor No.") { }
                column(VendorItemNo_PurchRcptLine; "Purch. Rcpt. Line"."Vendor Item No.") { }
                column(SalesOrderNo_PurchRcptLine; "Purch. Rcpt. Line"."Sales Order No.") { }
                column(SalesOrderLineNo_PurchRcptLine; "Purch. Rcpt. Line"."Sales Order Line No.") { }
                column(GenBusPostingGroup_PurchRcptLine; "Purch. Rcpt. Line"."Gen. Bus. Posting Group") { }
                column(GenProdPostingGroup_PurchRcptLine; "Purch. Rcpt. Line"."Gen. Prod. Posting Group") { }
                column(VATCalculationType_PurchRcptLine; "Purch. Rcpt. Line"."VAT Calculation Type") { }
                column(TransactionType_PurchRcptLine; "Purch. Rcpt. Line"."Transaction Type") { }
                column(TransportMethod_PurchRcptLine; "Purch. Rcpt. Line"."Transport Method") { }
                column(AttachedtoLineNo_PurchRcptLine; "Purch. Rcpt. Line"."Attached to Line No.") { }
                column(EntryPoint_PurchRcptLine; "Purch. Rcpt. Line"."Entry Point") { }
                column(Area_PurchRcptLine; "Purch. Rcpt. Line".Area) { }
                column(TransactionSpecification_PurchRcptLine; "Purch. Rcpt. Line"."Transaction Specification") { }
                column(TaxAreaCode_PurchRcptLine; "Purch. Rcpt. Line"."Tax Area Code") { }
                column(TaxLiable_PurchRcptLine; "Purch. Rcpt. Line"."Tax Liable") { }
                column(TaxGroupCode_PurchRcptLine; "Purch. Rcpt. Line"."Tax Group Code") { }
                column(UseTax_PurchRcptLine; "Purch. Rcpt. Line"."Use Tax") { }
                column(VATBusPostingGroup_PurchRcptLine; "Purch. Rcpt. Line"."VAT Bus. Posting Group") { }
                column(VATProdPostingGroup_PurchRcptLine; "Purch. Rcpt. Line"."VAT Prod. Posting Group") { }
                column(CurrencyCode_PurchRcptLine; "Purch. Rcpt. Line"."Currency Code") { }
                column(BlanketOrderNo_PurchRcptLine; "Purch. Rcpt. Line"."Blanket Order No.") { }
                column(BlanketOrderLineNo_PurchRcptLine; "Purch. Rcpt. Line"."Blanket Order Line No.") { }
                column(VATBaseAmount_PurchRcptLine; "Purch. Rcpt. Line"."VAT Base Amount") { }
                column(UnitCost_PurchRcptLine; "Purch. Rcpt. Line"."Unit Cost") { }
                column(PostingDate_PurchRcptLine; "Purch. Rcpt. Line"."Posting Date") { }
                column(DimensionSetID_PurchRcptLine; "Purch. Rcpt. Line"."Dimension Set ID") { }
                column(JobTaskNo_PurchRcptLine; "Purch. Rcpt. Line"."Job Task No.") { }
                column(JobLineType_PurchRcptLine; "Purch. Rcpt. Line"."Job Line Type") { }
                column(JobUnitPrice_PurchRcptLine; "Purch. Rcpt. Line"."Job Unit Price") { }
                column(JobTotalPrice_PurchRcptLine; "Purch. Rcpt. Line"."Job Total Price") { }
                column(JobLineAmount_PurchRcptLine; "Purch. Rcpt. Line"."Job Line Amount") { }
                column(JobLineDiscountAmount_PurchRcptLine; "Purch. Rcpt. Line"."Job Line Discount Amount") { }
                column(JobLineDiscount_PurchRcptLine; "Purch. Rcpt. Line"."Job Line Discount %") { }
                column(JobUnitPriceLCY_PurchRcptLine; "Purch. Rcpt. Line"."Job Unit Price (LCY)") { }
                column(JobTotalPriceLCY_PurchRcptLine; "Purch. Rcpt. Line"."Job Total Price (LCY)") { }
                column(JobLineAmountLCY_PurchRcptLine; "Purch. Rcpt. Line"."Job Line Amount (LCY)") { }
                column(JobLineDiscAmountLCY_PurchRcptLine; "Purch. Rcpt. Line"."Job Line Disc. Amount (LCY)") { }
                column(JobCurrencyFactor_PurchRcptLine; "Purch. Rcpt. Line"."Job Currency Factor") { }
                column(JobCurrencyCode_PurchRcptLine; "Purch. Rcpt. Line"."Job Currency Code") { }
                column(ProdOrderNo_PurchRcptLine; "Purch. Rcpt. Line"."Prod. Order No.") { }
                column(VariantCode_PurchRcptLine; "Purch. Rcpt. Line"."Variant Code") { }
                column(BinCode_PurchRcptLine; "Purch. Rcpt. Line"."Bin Code") { }
                column(QtyperUnitofMeasure_PurchRcptLine; "Purch. Rcpt. Line"."Qty. per Unit of Measure") { }
                column(UnitofMeasureCode_PurchRcptLine; "Purch. Rcpt. Line"."Unit of Measure Code") { }
                column(QuantityBase_PurchRcptLine; "Purch. Rcpt. Line"."Quantity (Base)") { }
                column(QtyInvoicedBase_PurchRcptLine; "Purch. Rcpt. Line"."Qty. Invoiced (Base)") { }
                column(FAPostingDate_PurchRcptLine; "Purch. Rcpt. Line"."FA Posting Date") { }
                column(FAPostingType_PurchRcptLine; "Purch. Rcpt. Line"."FA Posting Type") { }
                column(DepreciationBookCode_PurchRcptLine; "Purch. Rcpt. Line"."Depreciation Book Code") { }
                column(SalvageValue_PurchRcptLine; "Purch. Rcpt. Line"."Salvage Value") { }
                column(DepruntilFAPostingDate_PurchRcptLine; "Purch. Rcpt. Line"."Depr. until FA Posting Date") { }
                column(DeprAcquisitionCost_PurchRcptLine; "Purch. Rcpt. Line"."Depr. Acquisition Cost") { }
                column(MaintenanceCode_PurchRcptLine; "Purch. Rcpt. Line"."Maintenance Code") { }
                column(InsuranceNo_PurchRcptLine; "Purch. Rcpt. Line"."Insurance No.") { }
                column(BudgetedFANo_PurchRcptLine; "Purch. Rcpt. Line"."Budgeted FA No.") { }
                column(DuplicateinDepreciationBook_PurchRcptLine; "Purch. Rcpt. Line"."Duplicate in Depreciation Book") { }
                column(UseDuplicationList_PurchRcptLine; "Purch. Rcpt. Line"."Use Duplication List") { }
                column(ResponsibilityCenter_PurchRcptLine; "Purch. Rcpt. Line"."Responsibility Center") { }
                column(CrossReferenceNo_PurchRcptLine; "Purch. Rcpt. Line"."Item Reference No.") { }
                column(UnitofMeasureCrossRef_PurchRcptLine; "Purch. Rcpt. Line"."Item Reference Unit of Measure") { }
                column(CrossReferenceType_PurchRcptLine; "Purch. Rcpt. Line"."Item Reference Type") { }
                column(CrossReferenceTypeNo_PurchRcptLine; "Purch. Rcpt. Line"."Item Reference Type No.") { }
                column(ItemCategoryCode_PurchRcptLine; "Purch. Rcpt. Line"."Item Category Code") { }
                column(Nonstock_PurchRcptLine; "Purch. Rcpt. Line".Nonstock) { }
                column(PurchasingCode_PurchRcptLine; "Purch. Rcpt. Line"."Purchasing Code") { }

                column(SpecialOrderSalesNo_PurchRcptLine; "Purch. Rcpt. Line"."Special Order Sales No.") { }
                column(SpecialOrderSalesLineNo_PurchRcptLine; "Purch. Rcpt. Line"."Special Order Sales Line No.") { }
                column(RequestedReceiptDate_PurchRcptLine; "Purch. Rcpt. Line"."Requested Receipt Date") { }
                column(PromisedReceiptDate_PurchRcptLine; "Purch. Rcpt. Line"."Promised Receipt Date") { }
                column(LeadTimeCalculation_PurchRcptLine; "Purch. Rcpt. Line"."Lead Time Calculation") { }
                column(InboundWhseHandlingTime_PurchRcptLine; "Purch. Rcpt. Line"."Inbound Whse. Handling Time") { }
                column(PlannedReceiptDate_PurchRcptLine; "Purch. Rcpt. Line"."Planned Receipt Date") { }
                column(OrderDate_PurchRcptLine; "Purch. Rcpt. Line"."Order Date") { }
                column(ItemChargeBaseAmount_PurchRcptLine; "Purch. Rcpt. Line"."Item Charge Base Amount") { }
                column(Correction_PurchRcptLine; "Purch. Rcpt. Line".Correction) { }
                column(Description_2; "Description 2") { }
                column(ReturnReasonCode_PurchRcptLine; "Purch. Rcpt. Line"."Return Reason Code") { }
                column(Desc2_PurchRcptLine; "Purch. Rcpt. Line"."Description 2") { }
                column(RoutingNo_PurchRcptLine; "Purch. Rcpt. Line"."Routing No.") { }
                column(OperationNo_PurchRcptLine; "Purch. Rcpt. Line"."Operation No.") { }
                column(WorkCenterNo_PurchRcptLine; "Purch. Rcpt. Line"."Work Center No.") { }
                column(ProdOrderLineNo_PurchRcptLine; "Purch. Rcpt. Line"."Prod. Order Line No.") { }
                column(OverheadRate_PurchRcptLine; "Purch. Rcpt. Line"."Overhead Rate") { }
                column(RoutingReferenceNo_PurchRcptLine; "Purch. Rcpt. Line"."Routing Reference No.") { }
                column(Order_Amount; LPOAmount) { }

                column(CompanyINfoName; Logos.Name) { }
                column(CompanyINfoAdd; Logos.Address) { }
                column(CompanyINfoPicture; Logos.Picture) { }
                column(Order_Amount_Including_VAT; "Line Amount Including VAT") { }
                trigger OnPostDataItem()
                begin
                    Logos.get;
                    Logos.CalcFields(Picture);
                end;

                trigger OnAfterGetRecord()
                begin
                    "Purch. Rcpt. Line".CalcFields("Order Amount");
                    "Purch. Rcpt. Line".CalcFields("Line Amount Including VAT");
                    LPOAmount := "Purch. Rcpt. Line"."Order Amount" + "Purch. Rcpt. Line"."Order Archive Amount";

                end;
            }
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
        LPOAmount: Decimal;
}

