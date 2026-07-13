query 50082 "Purchase Header 2"
{
    Caption = 'Purchase Header';
    QueryType = Normal;

    elements
    {
        dataitem(PurchaseHeader; "Purchase Header")
        {
            column(ActualExpenditure; "Actual Expenditure") { }
            column(AdminApprovedBy; "Admin Approved By") { }
            column(AdminApprovedDate; "Admin Approved Date") { }
            column(AdminStatus; "Admin Status") { }
            column(Allocation; Allocation) { }
            column(AppliestoDocNo; "Applies-to Doc. No.") { }
            column(AppliestoDocType; "Applies-to Doc. Type") { }
            column(AppliestoID; "Applies-to ID") { }
            column(ApprovalStatus; "Approval Status") { }
            column(ArchiveUnusedDoc; "Archive Unused Doc") { }
            column("Area"; "Area") { }
            column(AssignedProcurementOfficer; "Assigned Procurement Officer") { }
            column(AssignedUserID; "Assigned User ID") { }
            column(BalAccountNo; "Bal. Account No.") { }
            column(BalAccountType; "Bal. Account Type") { }
            column(BudgetBalance; "Budget Balance") { }
            column(BudgetName; "Budget Name") { }
            column(BudgetedAmount; "Budgeted Amount") { }
            column(BuyfromAddress; "Buy-from Address") { }
            column(BuyfromAddress2; "Buy-from Address 2") { }
            column(BuyfromCity; "Buy-from City") { }
            column(BuyfromContact; "Buy-from Contact") { }
            column(BuyfromContactNo; "Buy-from Contact No.") { }
            column(BuyfromCountryRegionCode; "Buy-from Country/Region Code") { }
            column(BuyfromRegion; "Buy-from county") { }
            column(BuyfromICPartnerCode; "Buy-from IC Partner Code") { }
            column(BuyfromPostCode; "Buy-from Post Code") { }
            column(BuyfromVendorName; "Buy-from Vendor Name") { }
            column(BuyfromVendorName2; "Buy-from Vendor Name 2") { }
            column(BuyfromVendorNo; "Buy-from Vendor No.") { }
            column(CampaignNo; "Campaign No.") { }
            column(Cancelled; Cancelled) { }
            column(CancelledBy; "Cancelled By") { }
            column(CancelledDate; "Cancelled Date") { }
            column(Commited; Commited) { }
            column(CommittedAmount; "Committed Amount") { }
            column(CompressPrepayment; "Compress Prepayment") { }
            column(Contract; Contract) { }
            column(ContractCompletionDate; "Contract Completion Date") { }
            column(ContractNo; "Contract No.") { }
            column(Copied; Copied) { }
            column(Correction; Correction) { }
            column(CreditorNo; "Creditor No.") { }
            column(CurrencyCode; "Currency Code") { }
            column(CurrencyFactor; "Currency Factor") { }
            column(DateofContract; "Date of Contract") { }
            column(DateofTermination; "Date of Termination") { }
            column(DebitNote; "Debit Note") { }
            column(DeliveryNo; "Delivery No") { }
            column(Department; Department) { }
            column(DimensionSetID; "Dimension Set ID") { }
            column(DocNoOccurrence; "Doc. No. Occurrence") { }
            column(DocApprovalType; DocApprovalType) { }
            column(DocumentDate; "Document Date") { }
            column(DocumentType; "Document Type") { }
            column(DocumentType2; "Document Type 2") { }
            column(DonorName; "Donor Name") { }
            column(DueDate; "Due Date") { }
            column(EmployeeNo; "Employee No.") { }
            column(EntryPoint; "Entry Point") { }
            column(EvaluationDate; "Evaluation Date") { }
            column(ExpectedClosingDate; "Expected Closing Date") { }
            column(ExpectedReceiptDate; "Expected Receipt Date") { }
            column(Expenditure; Expenditure) { }
            column(ExpiryDate; "Expiry Date") { }
            column(FinanceApprovalDate; "Finance Approval Date") { }
            column(FinanceApprovedBy; "Finance Approved By") { }
            column(FinanceStatus; "Finance Status") { }
            column(GenBusPostingGroup; "Gen. Bus. Posting Group") { }
            column(ICDirection; "IC Direction") { }
            column(ICStatus; "IC Status") { }
            column(Id; SystemId) { }
            column(ImprestMemoNo; "Imprest Memo No") { }
            column(ImprestPurchaseDocNo; "Imprest Purchase Doc No") { }
            column(InboundWhseHandlingTime; "Inbound Whse. Handling Time") { }
            column(IncomingDocumentEntryNo; "Incoming Document Entry No.") { }
            column(Invoice; Invoice) { }
            column(InvoiceBasis; "Invoice Basis") { }
            column(InvoiceDiscCode; "Invoice Disc. Code") { }
            column(InvoiceDiscountAmount; "Invoice Discount Amount") { }
            column(InvoiceDiscountCalculation; "Invoice Discount Calculation") { }
            column(InvoiceDiscountValue; "Invoice Discount Value") { }
            column(IsHOD; "Is HOD") { }
            column(JobQueueEntryID; "Job Queue Entry ID") { }
            column(JobQueueStatus; "Job Queue Status") { }
            column(JournalTemplName; "Journal Templ. Name") { }
            column(LPONo; "LPO No.") { }
            column(LPOType; "LPO Type") { }
            column(LadingDate; "Lading Date") { }
            column(LadingNo; "Lading No") { }
            column(LanguageCode; "Language Code") { }
            column(LastPostingNo; "Last Posting No.") { }
            column(LastPrepaymentNo; "Last Prepayment No.") { }
            column(LastPrepmtCrMemoNo; "Last Prepmt. Cr. Memo No.") { }
            column(LastReceivingNo; "Last Receiving No.") { }
            column(LastReturnShipmentNo; "Last Return Shipment No.") { }
            column(LeadTimeCalculation; "Lead Time Calculation") { }
            column(LedgerCardNo; "Ledger Card No") { }
            column(LocationCode; "Location Code") { }
            column(ManualLPONo; "Manual LPO No.") { }
            column(NatureofContract; "Nature of Contract") { }
            column(No; "No.") { }
            column(NoPrinted; "No. Printed") { }
            column(NoSeries; "No. Series") { }
            column(NoofArchivedVersions; "No. of Archived Versions") { }
            column(NotificationAwardDate; "Notification Award Date") { }
            column(OnHold; "On Hold") { }
            column(OpenningandClosingDate; "Openning and Closing Date") { }
            column(OpinionNo; "Opinion No") { }
            column(OrderAddressCode; "Order Address Code") { }
            column(OrderClass; "Order Class") { }
            column(OrderDate; "Order Date") { }
            column(POApprovalDate; "P.O Approval Date") { }
            column(POName; "P.O Name") { }
            column(POStatus; "PO Status") { }
            column(PRNNo; "PRN No") { }
            column(PaytoAddress; "Pay-to Address") { }
            column(PaytoAddress2; "Pay-to Address 2") { }
            column(PaytoCity; "Pay-to City") { }
            column(PaytoContact; "Pay-to Contact") { }
            column(PaytoContactNo; "Pay-to Contact No.") { }
            column(PaytoCountryRegionCode; "Pay-to Country/Region Code") { }
            column(PaytoRegion; "Pay-to county") { }
            column(PaytoICPartnerCode; "Pay-to IC Partner Code") { }
            column(PaytoName; "Pay-to Name") { }
            column(PaytoName2; "Pay-to Name 2") { }
            column(PaytoPostCode; "Pay-to Post Code") { }
            column(PaytoVendorNo; "Pay-to Vendor No.") { }
            column(PaymentDiscount; "Payment Discount %") { }
            column(PaymentMethodCode; "Payment Method Code") { }
            column(PaymentReference; "Payment Reference") { }
            column(PaymentTermsCode; "Payment Terms Code") { }
            column(PillarName; "Pillar Name") { }
            column(PmtDiscountDate; "Pmt. Discount Date") { }
            column(PostingDate; "Posting Date") { }
            column(PostingDescription; "Posting Description") { }
            column(PostingNo; "Posting No.") { }
            column(PostingNoSeries; "Posting No. Series") { }
            column(PostingfromWhseRef; "Posting from Whse. Ref.") { }
            column(Prepayment; "Prepayment %") { }
            column(PrepaymentDueDate; "Prepayment Due Date") { }
            column(PrepaymentNo; "Prepayment No.") { }
            column(PrepaymentNoSeries; "Prepayment No. Series") { }
            column(PrepmtCrMemoNo; "Prepmt. Cr. Memo No.") { }
            column(PrepmtCrMemoNoSeries; "Prepmt. Cr. Memo No. Series") { }
            column(PrepmtPaymentDiscount; "Prepmt. Payment Discount %") { }
            column(PrepmtPaymentTermsCode; "Prepmt. Payment Terms Code") { }
            column(PrepmtPmtDiscountDate; "Prepmt. Pmt. Discount Date") { }
            column(PrepmtPostingDescription; "Prepmt. Posting Description") { }
            column(PriceCalculationMethod; "Price Calculation Method") { }
            column(PricesIncludingVAT; "Prices Including VAT") { }
            column(PrintPostedDocuments; "Print Posted Documents") { }
            column(ProcurementMethod; "Procurement Method") { }
            column(ProcurementMethodCode; "Procurement Method Code") { }
            column(ProcurementOfficerUserID; "Procurement Officer UserID") { }
            column(ProcurementRequestNo; "Procurement Request No.") { }
            column(ProcurementTypeCode; "Procurement Type Code") { }
            column(ProjectCode; "Project Code") { }
            column(PromisedReceiptDate; "Promised Receipt Date") { }
            column(PurchaseRequisitionNo; "Purchase Requisition No.") { }
            column(PurchaseType; "Purchase Type") { }
            column(PurchaserCode; "Purchaser Code") { }
            column(QuotationNo; "Quotation No.") { }
            column(QuoteComments; "Quote Comments") { }
            column(QuoteComments2; "Quote Comments 2") { }
            column(QuoteNo; "Quote No.") { }
            column(RFQNo; "RFQ No.") { }
            column(ReasonCode; "Reason Code") { }
            column(ReasonForTermination; "Reason For Termination") { }
            column(RecalculateInvoiceDisc; "Recalculate Invoice Disc.") { }
            column(Receive; Receive) { }
            column(ReceivingNo; "Receiving No.") { }
            column(ReceivingNoSeries; "Receiving No. Series") { }
            column(Recommendation1; "Recommendation 1") { }
            column(Recommendation2; "Recommendation 2") { }
            column(ReferenceNo; "Reference No") { }
            column(RefrenceType; "Refrence Type") { }
            column(RemittoCode; "Remit-to Code") { }
            column(RepairNo; "Repair No") { }
            column(RequestDescription; "Request Description") { }
            column(RequestNo; "Request No") { }
            column(RequestforQuoteNo; "Request for Quote No.") { }
            column(RequestedReceiptDate; "Requested Receipt Date") { }
            column(RequestorName; "Requestor Name") { }
            column(RequisitionNo; "Requisition No.") { }
            column(ResponsibilityCenter; "Responsibility Center") { }
            column(ResponsibilityCenterName; "Responsibility Center Name") { }
            column(ResponsibleOfficer; "Responsible Officer") { }
            column(ReturnShipmentNo; "Return Shipment No.") { }
            column(ReturnShipmentNoSeries; "Return Shipment No. Series") { }
            column(SchemeApplied; "Scheme Applied") { }
            column(SelltoCustomerNo; "Sell-to Customer No.") { }
            column(SendICDocument; "Send IC Document") { }
            column(Ship; Ship) { }
            column(ShiptoAddress; "Ship-to Address") { }
            column(ShiptoAddress2; "Ship-to Address 2") { }
            column(ShiptoCity; "Ship-to City") { }
            column(ShiptoCode; "Ship-to Code") { }
            column(ShiptoContact; "Ship-to Contact") { }
            column(ShiptoCountryRegionCode; "Ship-to Country/Region Code") { }
            column(ShiptoRegion; "Ship-to county") { }
            column(ShiptoName; "Ship-to Name") { }
            column(ShiptoName2; "Ship-to Name 2") { }
            column(ShiptoPostCode; "Ship-to Post Code") { }
            column(ShipmentMethodCode; "Shipment Method Code") { }
            column(ShippingAgentCode; "Shipping Agent Code") { }
            column(ShortcutDimension1Code; "Shortcut Dimension 1 Code") { }
            column(ShortcutDimension2Code; "Shortcut Dimension 2 Code") { }
            column(ShortcutDimension3Code; "Shortcut Dimension 3 Code") { }
            column(SpecialRemark; "Special Remark") { }
            column(Status; Status) { }
            column(SystemCreatedAt; SystemCreatedAt) { }
            column(SystemCreatedBy; SystemCreatedBy) { }
            column(SystemId; SystemId) { }
            column(SystemModifiedAt; SystemModifiedAt) { }
            column(SystemModifiedBy; SystemModifiedBy) { }
            column(TaxAreaCode; "Tax Area Code") { }
            column(TaxLiable; "Tax Liable") { }
            column(TenderAwardDate; "Tender Award Date") { }
            column(TenderCategory; "Tender Category") { }
            column(TendorNumber; "Tendor Number") { }
            column(TerminatedBy; "Terminated By") { }
            column(TransactionSpecification; "Transaction Specification") { }
            column("TransactionType"; "Transaction Type") { }
            column(TransportMethod; "Transport Method") { }
            column("Type"; "Type") { }
            column(VATBaseDiscount; "VAT Base Discount %") { }
            column(VATBusPostingGroup; "VAT Bus. Posting Group") { }
            column(VATCountryRegionCode; "VAT Country/Region Code") { }
            column(VATMethod; "VAT Method") { }
            column(VATRegistrationNo; "VAT Registration No.") { }
            column(VATReportingDate; "VAT Reporting Date") { }
            column(VendorAuthorizationNo; "Vendor Authorization No.") { }
            column(VendorCrMemoNo; "Vendor Cr. Memo No.") { }
            column(VendorInvoiceNo; "Vendor Invoice No.") { }
            column(VendorOrderNo; "Vendor Order No.") { }
            column(VendorPostingGroup; "Vendor Posting Group") { }
            column(VendorShipmentNo; "Vendor Shipment No.") { }
            column(VesselNo; "Vessel No") { }
            column(YourReference; "Your Reference") { }
            column("text"; "text") { }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
