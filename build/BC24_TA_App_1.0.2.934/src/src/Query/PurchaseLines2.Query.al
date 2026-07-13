query 50083 "Purchase Lines 2"
{
    Caption = 'Purchase Lines';
    QueryType = Normal;

    elements
    {
        dataitem(PurchaseLine; "Purchase Line")
        {
            column(ARcdNotInvExVATLCY; "A. Rcd. Not Inv. Ex. VAT (LCY)") { }
            column(AllowInvoiceDisc; "Allow Invoice Disc.") { }
            column(AllowItemChargeAssignment; "Allow Item Charge Assignment") { }
            column(Amount; Amount) { }
            column(AmountIncludingVAT; "Amount Including VAT") { }
            column(AmtRcdNotInvoiced; "Amt. Rcd. Not Invoiced") { }
            column(AmtRcdNotInvoicedLCY; "Amt. Rcd. Not Invoiced (LCY)") { }
            column(AppltoItemEntry; "Appl.-to Item Entry") { }
            column("Area"; "Area") { }
            column(AssetNo; "Asset No.") { }
            column(AttachedtoLineNo; "Attached to Line No.") { }
            column(BinCode; "Bin Code") { }
            column(BlanketOrderLineNo; "Blanket Order Line No.") { }
            column(BlanketOrderNo; "Blanket Order No.") { }
            column(BoardMemberNo; "Board Member No") { }
            column(BudgetBalance; "Budget Balance") { }
            column(BudgetName; "Budget Name") { }
            column(BudgetedAmount; "Budgeted Amount") { }
            column(BudgetedFANo; "Budgeted FA No.") { }
            column(BuyfromVendorNo; "Buy-from Vendor No.") { }
            column(Cancelled; Cancelled) { }
            column(Committed; Committed) { }
            column(CommittedAmount; "Committed Amount") { }
            column(CompletelyReceived; "Completely Received") { }
            column(CopiedFromPostedDoc; "Copied From Posted Doc.") { }
            column(CrossReferenceNo; "Item Reference No.") { }
            column(CrossReferenceType; "Item Reference Type") { }
            column(CrossReferenceTypeNo; "Item Reference Type No.") { }
            column(CurrencyCode; "Currency Code") { }
            column(DeferralCode; "Deferral Code") { }
            column(DeprAcquisitionCost; "Depr. Acquisition Cost") { }
            column(DepruntilFAPostingDate; "Depr. until FA Posting Date") { }
            column(DepreciationBookCode; "Depreciation Book Code") { }
            column(Description; Description) { }
            column(Description2; "Description 2") { }
            column(DimensionSetID; "Dimension Set ID") { }
            column(DirectUnitCost; "Direct Unit Cost") { }
            column(DocumentNo; "Document No.") { }
            column(DocumentType; "Document Type") { }
            column(DocumentType2; "Document Type 2") { }
            column(DropShipment; "Drop Shipment") { }
            column(DuplicateinDepreciationBook; "Duplicate in Depreciation Book") { }
            column(EntryPoint; "Entry Point") { }
            column(ExpectedReceiptDate; "Expected Receipt Date") { }
            column(ExpenseCode; "Expense Code") { }
            column(ExpiryDate; "Expiry Date") { }
            column(FAPostingDate; "FA Posting Date") { }
            column(FAPostingType; "FA Posting Type") { }
            column(Finished; Finished) { }
            column(GLAccount; "G/L Account") { }
            column(GenBusPostingGroup; "Gen. Bus. Posting Group") { }
            column(GenProdPostingGroup; "Gen. Prod. Posting Group") { }
            column(GrossWeight; "Gross Weight") { }
            column(ICItemReferenceNo; "IC Item Reference No.") { }
            column(ICPartnerCode; "IC Partner Code") { }
            column(ICPartnerRefType; "IC Partner Ref. Type") { }
            column(ICPartnerReference; "IC Partner Reference") { }
            column(InboundWhseHandlingTime; "Inbound Whse. Handling Time") { }
            column(IndirectCost; "Indirect Cost %") { }
            column(InsuranceNo; "Insurance No.") { }
            column(InvDiscAmounttoInvoice; "Inv. Disc. Amount to Invoice") { }
            column(InvDiscountAmount; "Inv. Discount Amount") { }
            column(ItemCategoryCode; "Item Category Code") { }
            column(ItemGLBudgetAccount; "Item G/L Budget Account") { }
            column(ItemReferenceNo; "Item Reference No.") { }
            column(ItemReferenceType; "Item Reference Type") { }
            column(ItemReferenceTypeNo; "Item Reference Type No.") { }
            column(ItemReferenceUnitofMeasure; "Item Reference Unit of Measure") { }
            column(JobCurrencyCode; "Job Currency Code") { }
            column(JobCurrencyFactor; "Job Currency Factor") { }
            column(JobLineAmount; "Job Line Amount") { }
            column(JobLineAmountLCY; "Job Line Amount (LCY)") { }
            column(JobLineDiscAmountLCY; "Job Line Disc. Amount (LCY)") { }
            column(JobLineDiscount; "Job Line Discount %") { }
            column(JobLineDiscountAmount; "Job Line Discount Amount") { }
            column(JobLineType; "Job Line Type") { }
            column(JobNo; "Job No.") { }
            column(JobPlanningLineNo; "Job Planning Line No.") { }
            column(JobRemainingQty; "Job Remaining Qty.") { }
            column(JobRemainingQtyBase; "Job Remaining Qty. (Base)") { }
            column(JobTaskNo; "Job Task No.") { }
            column(JobTotalPrice; "Job Total Price") { }
            column(JobTotalPriceLCY; "Job Total Price (LCY)") { }
            column(JobUnitPrice; "Job Unit Price") { }
            column(JobUnitPriceLCY; "Job Unit Price (LCY)") { }
            column(LeadTimeCalculation; "Lead Time Calculation") { }
            column(LineAmount; "Line Amount") { }
            column(LineCreated; "Line Created") { }
            column(LineDiscount; "Line Discount %") { }
            column(LineDiscountAmount; "Line Discount Amount") { }
            column(LineNo; "Line No.") { }
            column(LocationCode; "Location Code") { }
            column(MPSOrder; "MPS Order") { }
            column(MaintenanceCode; "Maintenance Code") { }
            column(ManualRequisitionNo; "Manual Requisition No") { }
            column(ManuallyAdded; "Manually Added") { }
            column(NetWeight; "Net Weight") { }
            column(No; "No.") { }
            column(Nonstock; Nonstock) { }
            column(OperationNo; "Operation No.") { }
            column(OrderDate; "Order Date") { }
            column(OrderLineNo; "Order Line No.") { }
            column(OrderNo; "Order No.") { }
            column(OutstandingAmount; "Outstanding Amount") { }
            column(OutstandingAmountLCY; "Outstanding Amount (LCY)") { }
            column(OutstandingAmtExVATLCY; "Outstanding Amt. Ex. VAT (LCY)") { }
            column(OutstandingQtyBase; "Outstanding Qty. (Base)") { }
            column(OutstandingQuantity; "Outstanding Quantity") { }
            column(OverReceiptApprovalStatus; "Over-Receipt Approval Status") { }
            column(OverReceiptCode; "Over-Receipt Code") { }
            column(OverReceiptQuantity; "Over-Receipt Quantity") { }
            column(OverheadRate; "Overhead Rate") { }
            column(PONumberTrack; "PO Number Track") { }
            column(PaytoVendorNo; "Pay-to Vendor No.") { }
            column(PlannedReceiptDate; "Planned Receipt Date") { }
            column(PlanningFlexibility; "Planning Flexibility") { }
            column(PmtDiscountAmount; "Pmt. Discount Amount") { }
            column(PostingGroup; "Posting Group") { }
            column(Prepayment; "Prepayment %") { }
            column(PrepaymentAmount; "Prepayment Amount") { }
            column(PrepaymentLine; "Prepayment Line") { }
            column(PrepaymentTaxAreaCode; "Prepayment Tax Area Code") { }
            column(PrepaymentTaxGroupCode; "Prepayment Tax Group Code") { }
            column(PrepaymentTaxLiable; "Prepayment Tax Liable") { }
            column(PrepaymentVAT; "Prepayment VAT %") { }
            column(PrepaymentVATDifference; "Prepayment VAT Difference") { }
            column(PrepaymentVATIdentifier; "Prepayment VAT Identifier") { }
            column(PrepmtAmtDeducted; "Prepmt Amt Deducted") { }
            column(PrepmtAmttoDeduct; "Prepmt Amt to Deduct") { }
            column(PrepmtVATDiffDeducted; "Prepmt VAT Diff. Deducted") { }
            column(PrepmtVATDifftoDeduct; "Prepmt VAT Diff. to Deduct") { }
            column(PrepmtAmountInvLCY; "Prepmt. Amount Inv. (LCY)") { }
            column(PrepmtAmountInvInclVAT; "Prepmt. Amount Inv. Incl. VAT") { }
            column(PrepmtAmtInclVAT; "Prepmt. Amt. Incl. VAT") { }
            column(PrepmtAmtInv; "Prepmt. Amt. Inv.") { }
            column(PrepmtLineAmount; "Prepmt. Line Amount") { }
            column(PrepmtPmtDiscountAmount; "Prepmt. Pmt. Discount Amount") { }
            column(PrepmtVATAmountInvLCY; "Prepmt. VAT Amount Inv. (LCY)") { }
            column(PrepmtVATBaseAmt; "Prepmt. VAT Base Amt.") { }
            column(PrepmtVATCalcType; "Prepmt. VAT Calc. Type") { }
            column(PriceCalculationMethod; "Price Calculation Method") { }
            column(ProcurementPlanItemNo; "Procurement Plan Item No") { }
            column(ProcurementTypeCode; "Procurement Type Code") { }
            column(ProdOrderLineNo; "Prod. Order Line No.") { }
            column(ProdOrderNo; "Prod. Order No.") { }
            column(Profit; "Profit %") { }
            column(PromisedReceiptDate; "Promised Receipt Date") { }
            column(PurchasingCode; "Purchasing Code") { }
            column(QtyInProcPlan; "Qty In Proc. Plan") { }
            column(QtyInStore; "Qty In Store") { }
            column(QtyInvoicedBase; "Qty. Invoiced (Base)") { }
            column(QtyRcdNotInvoiced; "Qty. Rcd. Not Invoiced") { }
            column(QtyRcdNotInvoicedBase; "Qty. Rcd. Not Invoiced (Base)") { }
            column(QtyReceivedBase; "Qty. Received (Base)") { }
            column(QtyRoundingPrecision; "Qty. Rounding Precision") { }
            column(QtyRoundingPrecisionBase; "Qty. Rounding Precision (Base)") { }
            column(QtyperUnitofMeasure; "Qty. per Unit of Measure") { }
            column(QtytoInvoice; "Qty. to Invoice") { }
            column(QtytoInvoiceBase; "Qty. to Invoice (Base)") { }
            column(QtytoReceive; "Qty. to Receive") { }
            column(QtytoReceiveBase; "Qty. to Receive (Base)") { }
            column(Quantity; Quantity) { }
            column(QuantityBase; "Quantity (Base)") { }
            column(QuantityInvoiced; "Quantity Invoiced") { }
            column(QuantityReceived; "Quantity Received") { }
            column(RFQCreated; "RFQ Created") { }
            column(RFQLineNo; "RFQ Line No.") { }
            column(RFQNo; "RFQ No.") { }
            column(RFQRemarks; "RFQ Remarks") { }
            column(RecalculateInvoiceDisc; "Recalculate Invoice Disc.") { }
            column(ReceiptLineNo; "Receipt Line No.") { }
            column(ReceiptNo; "Receipt No.") { }
            column(RequestSummary; "Request Summary") { }
            column(RequestedReceiptDate; "Requested Receipt Date") { }
            column(RequisitionNo; "Requisition No") { }
            column(ReservedQuantity; "Reserved Quantity") { }
            column(ResponsibilityCenter; "Responsibility Center") { }
            column(RetQtyShpdNotInvdBase; "Ret. Qty. Shpd Not Invd.(Base)") { }
            column(ReturnQtyShipped; "Return Qty. Shipped") { }
            column(ReturnQtyShippedBase; "Return Qty. Shipped (Base)") { }
            column(ReturnQtyShippedNotInvd; "Return Qty. Shipped Not Invd.") { }
            column(ReturnQtytoShip; "Return Qty. to Ship") { }
            column(ReturnQtytoShipBase; "Return Qty. to Ship (Base)") { }
            column(ReturnReasonCode; "Return Reason Code") { }
            column(ReturnShipmentLineNo; "Return Shipment Line No.") { }
            column(ReturnShipmentNo; "Return Shipment No.") { }
            column(ReturnShpdNotInvd; "Return Shpd. Not Invd.") { }
            column(ReturnShpdNotInvdLCY; "Return Shpd. Not Invd. (LCY)") { }
            column(ReturnsDeferralStartDate; "Returns Deferral Start Date") { }
            column(RoutingNo; "Routing No.") { }
            column(RoutingReferenceNo; "Routing Reference No.") { }
            column(SafetyLeadTime; "Safety Lead Time") { }
            column(SalesOrderLineNo; "Sales Order Line No.") { }
            column(SalesOrderNo; "Sales Order No.") { }
            column(SalvageValue; "Salvage Value") { }
            column(Select; Select) { }
            column(ShippingAgentCode; "Shipping Agent Code") { }
            column(ShippingAgentServiceCode; "Shipping Agent Service Code") { }
            column(ShortcutDimension1Code; "Shortcut Dimension 1 Code") { }
            column(ShortcutDimension2Code; "Shortcut Dimension 2 Code") { }
            column(SpecialOrder; "Special Order") { }
            column(SpecialOrderSalesLineNo; "Special Order Sales Line No.") { }
            column(SpecialOrderSalesNo; "Special Order Sales No.") { }
            column(Status; Status) { }
            column(Subtype; Subtype) { }
            column(SystemCreatedEntry; "System-Created Entry") { }
            column(SystemCreatedAt; SystemCreatedAt) { }
            column(SystemCreatedBy; SystemCreatedBy) { }
            column(SystemId; SystemId) { }
            column(SystemModifiedAt; SystemModifiedAt) { }
            column(SystemModifiedBy; SystemModifiedBy) { }
            column(TaxAreaCode; "Tax Area Code") { }
            column(TaxGroupCode; "Tax Group Code") { }
            column(TaxLiable; "Tax Liable") { }
            column(TransactionSpecification; "Transaction Specification") { }
            column("TransactionType"; "Transaction Type") { }
            column(TransportMethod; "Transport Method") { }
            column("Type"; "Type") { }
            column(UnitCost; "Unit Cost") { }
            column(UnitCostLCY; "Unit Cost (LCY)") { }
            column(UnitPriceLCY; "Unit Price (LCY)") { }
            column(UnitVolume; "Unit Volume") { }
            column(UnitofMeasure; "Unit of Measure") { }
            column(UnitofMeasureCrossRef; "Item Reference Unit of Measure") { }
            column(UnitofMeasureCode; "Unit of Measure Code") { }
            column(UnitsperParcel; "Units per Parcel") { }
            column(UseDuplicationList; "Use Duplication List") { }
            column(UseTax; "Use Tax") { }
            column(VAT; "VAT %") { }
            column(VATBaseAmount; "VAT Base Amount") { }
            column(VATBusPostingGroup; "VAT Bus. Posting Group") { }
            column(VATCalculationType; "VAT Calculation Type") { }
            column(VATDifference; "VAT Difference") { }
            column(VATIdentifier; "VAT Identifier") { }
            column(VATProdPostingGroup; "VAT Prod. Posting Group") { }
            column(VariantCode; "Variant Code") { }
            column(VendorItemNo; "Vendor Item No.") { }
            column(VoteBook; "Vote Book") { }
            column(WhseOutstandingQtyBase; "Whse. Outstanding Qty. (Base)") { }
            column(WorkCenterNo; "Work Center No.") { }
            column(WorkPlanNo; "WorkPlan No.") { }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
