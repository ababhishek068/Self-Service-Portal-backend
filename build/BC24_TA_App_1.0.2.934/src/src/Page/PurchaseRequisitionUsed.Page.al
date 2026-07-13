Page 50460 "Purchase Requisition-Used"
{
    CardPageID = "Internal Requisitions Approved";
    DeleteAllowed = false;
    PageType = List;
    SourceTable = "Purchase Header";
    SourceTableView = where(DocApprovalType = filter(Requisition),
                            Status = filter(Released), "Used in RFQ" = filter(true));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(DocumentType; Rec."Document Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Document Type field.';
                }
                field(BuyfromVendorNo; Rec."Buy-from Vendor No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the vendor who delivers the products.';
                }
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field(PaytoVendorNo; Rec."Pay-to Vendor No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the vendor that you received the invoice from.';
                }
                field(PaytoName; Rec."Pay-to Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the vendor sending the invoice.';
                }
                field(PaytoName2; Rec."Pay-to Name 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Pay-to Name 2 field.';
                }
                field(PaytoAddress; Rec."Pay-to Address")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the address of the vendor sending the invoice.';
                }
                field(PaytoAddress2; Rec."Pay-to Address 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies additional address information.';
                }
                field(PaytoCity; Rec."Pay-to City")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the city of the vendor sending the invoice.';
                }
                field(PaytoContact; Rec."Pay-to Contact")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the person to contact about an invoice from this vendor.';
                }
                field(YourReference; Rec."Your Reference")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the vendor''s reference.';
                }
                field(ShiptoCode; Rec."Ship-to Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a code for an alternate shipment address if you want to ship to another address than the one that has been entered automatically. This field is also used in case of drop shipment.';
                }
                field(ShiptoName; Rec."Ship-to Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the company at the address to which you want the items in the purchase order to be shipped.';
                }
                field(ShiptoName2; Rec."Ship-to Name 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Ship-to Name 2 field.';
                }
                field(ShiptoAddress; Rec."Ship-to Address")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the address that you want the items in the purchase order to be shipped to.';
                }
                field(ShiptoAddress2; Rec."Ship-to Address 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies additional address information.';
                }
                field(ShiptoCity; Rec."Ship-to City")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the city the items in the purchase order will be shipped to.';
                }
                field(ShiptoContact; Rec."Ship-to Contact")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of a contact person for the address where the items in the purchase order should be shipped.';
                }
                field(OrderDate; Rec."Order Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the order was created.';
                }
                field(PostingDate; Rec."Posting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the posting of the purchase document will be recorded.';
                }
                field(ExpectedReceiptDate; Rec."Expected Receipt Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date you expect the items to be available in your warehouse. If you leave the field blank, it will be calculated as follows: Planned Receipt Date + Safety Lead Time + Inbound Warehouse Handling Time = Expected Receipt Date.';
                }
                field(PostingDescription; Rec."Posting Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies additional posting information for the document. After you post the document, the description can add detail to vendor and customer ledger entries.';
                }
                field(PaymentTermsCode; Rec."Payment Terms Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a formula that calculates the payment due date, payment discount date, and payment discount amount.';
                }
                field(DueDate; Rec."Due Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies when the related sales invoice must be paid.';
                }
                field(PaymentDiscount; Rec."Payment Discount %")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the payment discount percentage that is granted if you pay on or before the date entered in the Pmt. Discount Date field. The discount percentage is specified in the Payment Terms Code field.';
                }
                field(PmtDiscountDate; Rec."Pmt. Discount Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date on which the amount in the entry must be paid for a payment discount to be granted.';
                }
                field(ShipmentMethodCode; Rec."Shipment Method Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the delivery conditions of the related shipment, such as free on board (FOB).';
                }
                field(LocationCode; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a code for the location where you want the items to be placed when they are received.';
                }
                field(ShortcutDimension1Code; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                }
                field(ShortcutDimension2Code; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                }
                field(VendorPostingGroup; Rec."Vendor Posting Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the vendor''s market type to link business transactions to.';
                }
                field(CurrencyCode; Rec."Currency Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the currency that is used on the entry.';
                }
                field(CurrencyFactor; Rec."Currency Factor")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Currency Factor field.';
                }
                field(PricesIncludingVAT; Rec."Prices Including VAT")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if the Unit Price and Line Amount fields on document lines should be shown with or without VAT.';
                }
                field(InvoiceDiscCode; Rec."Invoice Disc. Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Invoice Disc. Code field.';
                }
                field(LanguageCode; Rec."Language Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the language to be used on printouts for this document.';
                }
                field(PurchaserCode; Rec."Purchaser Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies which purchaser is assigned to the vendor.';
                }
                field(OrderClass; Rec."Order Class")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Order Class field.';
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Comment field.';
                }
                field(NoPrinted; Rec."No. Printed")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No. Printed field.';
                }
                field(OnHold; Rec."On Hold")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that the related entry represents an unpaid invoice for which either a payment suggestion, a reminder, or a finance charge memo exists.';
                }
                field(AppliestoDocType; Rec."Applies-to Doc. Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of the posted document that this document or journal line will be applied to when you post, for example to register payment.';
                }
                field(AppliestoDocNo; Rec."Applies-to Doc. No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the posted document that this document or journal line will be applied to when you post, for example to register payment.';
                }
                field(BalAccountNo; Rec."Bal. Account No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Bal. Account No. field.';
                }
                field(Receive; Rec.Receive)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Receive field.';
                }
                field(Invoice; Rec.Invoice)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Invoice field.';
                }
                field(PrintPostedDocuments; Rec."Print Posted Documents")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Print Posted Documents field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the sum of amounts on all the lines in the document. This will include invoice discounts.';
                }
                field(AmountIncludingVAT; Rec."Amount Including VAT")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the sum of amounts, including VAT, on all the lines in the document. This will include invoice discounts.';
                }
                field(ReceivingNo; Rec."Receiving No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Receiving No. field.';
                }
                field(PostingNo; Rec."Posting No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Posting No. field.';
                }
                field(LastReceivingNo; Rec."Last Receiving No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Last Receiving No. field.';
                }
                field(LastPostingNo; Rec."Last Posting No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Last Posting No. field.';
                }
                field(VendorOrderNo; Rec."Vendor Order No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the vendor''s order number.';
                }
                field(VendorShipmentNo; Rec."Vendor Shipment No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the vendor''s shipment number. It is inserted in the corresponding field on the source document during posting.';
                }
                field(VendorInvoiceNo; Rec."Vendor Invoice No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the document number of the original document you received from the vendor. You can require the document number for posting, or let it be optional. By default, it''s required, so that this document references the original. Making document numbers optional removes a step from the posting process. For example, if you attach the original invoice as a PDF, you might not need to enter the document number. To specify whether document numbers are required, in the Purchases & Payables Setup window, select or clear the Ext. Doc. No. Mandatory field.';
                }
                field(VendorCrMemoNo; Rec."Vendor Cr. Memo No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the document number of the original document you received from the vendor. You can require the document number for posting, or let it be optional. By default, it''s required, so that this document references the original. Making document numbers optional removes a step from the posting process. For example, if you attach the original invoice as a PDF, you might not need to enter the document number. To specify whether document numbers are required, in the Purchases & Payables Setup window, select or clear the Ext. Doc. No. Mandatory field.';
                }
                field(VATRegistrationNo; Rec."VAT Registration No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the VAT Registration No. field.';
                }
                field(SelltoCustomerNo; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the customer that the items are shipped to directly from your vendor, as a drop shipment.';
                }
                field(ReasonCode; Rec."Reason Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the reason code, a supplementary source code that enables you to trace the document.';
                }
                field(GenBusPostingGroup; Rec."Gen. Bus. Posting Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Gen. Bus. Posting Group field.';
                }
                field(TransactionType; Rec."Transaction Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of transaction that the document represents, for the purpose of reporting to INTRASTAT.';
                }
                field(TransportMethod; Rec."Transport Method")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the transport method, for the purpose of reporting to INTRASTAT.';
                }
                field(VATCountryRegionCode; Rec."VAT Country/Region Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the VAT Country/Region Code field.';
                }
                field(BuyfromVendorName; Rec."Buy-from Vendor Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the vendor who delivers the products.';
                }
                field(BuyfromVendorName2; Rec."Buy-from Vendor Name 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Buy-from Vendor Name 2 field.';
                }
                field(BuyfromAddress; Rec."Buy-from Address")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the address of the vendor who ships the items.';
                }
                field(BuyfromAddress2; Rec."Buy-from Address 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies additional address information.';
                }
                field(BuyfromCity; Rec."Buy-from City")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the city of the vendor who ships the items.';
                }
                field(BuyfromContact; Rec."Buy-from Contact")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the person to contact about shipment of the item from this vendor.';
                }
                field(PaytoPostCode; Rec."Pay-to Post Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the postal code.';
                }
                field(PaytoRegion; Rec."Pay-to county")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the state where the vendor sending the invoice is located.';
                }
                field(PaytoCountryRegionCode; Rec."Pay-to Country/Region Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the country/region code of the address.';
                }
                field(BuyfromPostCode; Rec."Buy-from Post Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the postal code.';
                }
                field(BuyfromRegion; Rec."Buy-from county")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the state where the vendor sending the invoice is located.';
                }
                field(BuyfromCountryRegionCode; Rec."Buy-from Country/Region Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the city of the vendor who delivered the items.';
                }
                field(ShiptoPostCode; Rec."Ship-to Post Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the postal code.';
                }
                field(ShiptoRegion; Rec."Ship-to county")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the state where the vendor sending the invoice is located.';
                }
                field(ShiptoCountryRegionCode; Rec."Ship-to Country/Region Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the country/region code of the address that the items are shipped to.';
                }
                field(BalAccountType; Rec."Bal. Account Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Bal. Account Type field.';
                }
                field(OrderAddressCode; Rec."Order Address Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the order address code linked to the relevant vendor''s order address.';
                }
                field(EntryPoint; Rec."Entry Point")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the port of entry where the items pass into your country/region, for reporting to Intrastat.';
                }
                field(Correction; Rec.Correction)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the entry as a corrective entry. You can use the field if you need to post a corrective entry to a vendor account. If you place a check mark in this field when posting a corrective entry, the system will post a negative debit instead of a credit or a negative credit instead of a debit. Correction flag does not affect how inventory reconciled with general ledger.';
                }
                field(DocumentDate; Rec."Document Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the related document was created.';
                }
                field("Area"; Rec.Area)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the destination country or region for the purpose of Intrastat reporting.';
                }
                field(TransactionSpecification; Rec."Transaction Specification")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a specification of the document''s transaction, for the purpose of reporting to INTRASTAT.';
                }
                field(PaymentMethodCode; Rec."Payment Method Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how to make payment, such as with bank transfer, cash, or check.';
                }
                field(NoSeries; Rec."No. Series")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No. Series field.';
                }
                field(PostingNoSeries; Rec."Posting No. Series")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Posting No. Series field.';
                }
                field(ReceivingNoSeries; Rec."Receiving No. Series")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Receiving No. Series field.';
                }
                field(TaxAreaCode; Rec."Tax Area Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the tax area code used for this purchase to calculate and post sales tax.';
                }
                field(TaxLiable; Rec."Tax Liable")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if this vendor charges you sales tax for purchases.';
                }
                field(VATBusPostingGroup; Rec."VAT Bus. Posting Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the VAT specification of the involved customer or vendor to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.';
                }
                field(AppliestoID; Rec."Applies-to ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ID of entries that will be applied to when you choose the Apply Entries action.';
                }
                field(VATBaseDiscount; Rec."VAT Base Discount %")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the VAT Base Discount % field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether the record is open, waiting to be approved, invoiced for prepayment, or released to the next stage of processing.';
                }
                field(InvoiceDiscountCalculation; Rec."Invoice Discount Calculation")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Invoice Discount Calculation field.';
                }
                field(InvoiceDiscountValue; Rec."Invoice Discount Value")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Invoice Discount Value field.';
                }
                field(SendICDocument; Rec."Send IC Document")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Send IC Document field.';
                }
                field(ICStatus; Rec."IC Status")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the IC Status field.';
                }
                field(BuyfromICPartnerCode; Rec."Buy-from IC Partner Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Buy-from IC Partner Code field.';
                }
                field(PaytoICPartnerCode; Rec."Pay-to IC Partner Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Pay-to IC Partner Code field.';
                }
                field(ICDirection; Rec."IC Direction")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the IC Direction field.';
                }
                field(PrepaymentNo; Rec."Prepayment No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Prepayment No. field.';
                }
                field(LastPrepaymentNo; Rec."Last Prepayment No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Last Prepayment No. field.';
                }
                field(PrepmtCrMemoNo; Rec."Prepmt. Cr. Memo No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Prepmt. Cr. Memo No. field.';
                }
                field(LastPrepmtCrMemoNo; Rec."Last Prepmt. Cr. Memo No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Last Prepmt. Cr. Memo No. field.';
                }
                field(Prepayment; Rec."Prepayment %")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the prepayment percentage to use to calculate the prepayment for purchase.';
                }
                field(PrepaymentNoSeries; Rec."Prepayment No. Series")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Prepayment No. Series field.';
                }
                field(CompressPrepayment; Rec."Compress Prepayment")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that prepayments on the purchase order are combined if they have the same general ledger account for prepayments or the same dimensions.';
                }
                field(PrepaymentDueDate; Rec."Prepayment Due Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies when the prepayment invoice for this purchase order is due.';
                }
                field(PrepmtCrMemoNoSeries; Rec."Prepmt. Cr. Memo No. Series")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Prepmt. Cr. Memo No. Series field.';
                }
                field(PrepmtPostingDescription; Rec."Prepmt. Posting Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Prepmt. Posting Description field.';
                }
                field(PrepmtPmtDiscountDate; Rec."Prepmt. Pmt. Discount Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the last date the vendor can pay the prepayment invoice and still receive a payment discount on the prepayment amount.';
                }
                field(PrepmtPaymentTermsCode; Rec."Prepmt. Payment Terms Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code that represents the payment terms for prepayment invoices related to the purchase document.';
                }
                field(PrepmtPaymentDiscount; Rec."Prepmt. Payment Discount %")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the payment discount percent granted on the prepayment if the vendor pays on or before the date entered in the Prepmt. Pmt. Discount Date field.';
                }
                field(QuoteNo; Rec."Quote No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quote number for the purchase order.';
                }
                field(JobQueueStatus; Rec."Job Queue Status")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the status of a job queue entry that handles the posting of purchase credit memos.';
                }
                field(JobQueueEntryID; Rec."Job Queue Entry ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Job Queue Entry ID field.';
                }
                field(DimensionSetID; Rec."Dimension Set ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Dimension Set ID field.';
                }
                field(NoofArchivedVersions; Rec."No. of Archived Versions")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of archived versions for this document.';
                }
                field(DocNoOccurrence; Rec."Doc. No. Occurrence")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Doc. No. Occurrence field.';
                }
                field(CampaignNo; Rec."Campaign No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the campaign number the document is linked to.';
                }
                field(BuyfromContactNo; Rec."Buy-from Contact No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of your contact at the vendor.';
                }
                field(PaytoContactNo; Rec."Pay-to Contact No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the contact who sends the invoice.';
                }
                field(ResponsibilityCenter; Rec."Responsibility Center")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the responsibility center, such as a distribution hub, that is associated with the involved user, company, customer, or vendor.';
                }
                field(CompletelyReceived; Rec."Completely Received")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if all the items on the order have been shipped or, in the case of inbound items, completely received.';
                }
                field(PostingfromWhseRef; Rec."Posting from Whse. Ref.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Posting from Whse. Ref. field.';
                }

                field(RequestedReceiptDate; Rec."Requested Receipt Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date that you want the vendor to deliver your order. The field is used to calculate the latest date you can order, as follows: requested receipt date - lead time calculation = order date. If you do not need delivery on a specific date, you can leave the field blank.';
                }
                field(PromisedReceiptDate; Rec."Promised Receipt Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date that the vendor has promised to deliver the order.';
                }
                field(LeadTimeCalculation; Rec."Lead Time Calculation")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a date formula for the amount of time it takes to replenish the item.';
                }
                field(InboundWhseHandlingTime; Rec."Inbound Whse. Handling Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the time it takes to make items part of available inventory, after the items have been posted as received.';
                }
                field(DateFilter; Rec."Date Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Filter field.';
                }
                field(VendorAuthorizationNo; Rec."Vendor Authorization No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the compensation agreement identification number, sometimes referred to as the RMA No. (Returns Materials Authorization).';
                }
                field(ReturnShipmentNo; Rec."Return Shipment No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Return Shipment No. field.';
                }
                field(ReturnShipmentNoSeries; Rec."Return Shipment No. Series")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Return Shipment No. Series field.';
                }
                field(Ship; Rec.Ship)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Ship field.';
                }
                field(LastReturnShipmentNo; Rec."Last Return Shipment No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Last Return Shipment No. field.';
                }
                field(AssignedUserID; Rec."Assigned User ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ID of the user who is responsible for the document.';
                }
                field(Copied; Rec.Copied)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Copied field.';
                }
                field(DebitNote; Rec."Debit Note")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Debit Note field.';
                }
                field(ProcurementRequestNo; Rec."Procurement Request No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Procurement Request No. field.';
                }
                field(InvoiceAmount; Rec."Invoice Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Invoice Amount field.';
                }
                field(RequestNo; Rec."Request No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Request No field.';
                }
                field(Commited; Rec.Commited)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Commited field.';
                }
                field(Department; Rec.Department)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Department field.';
                }
                field(DeliveryNo; Rec."Delivery No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Delivery No field.';
                }
                field(LedgerCardNo; Rec."Ledger Card No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Ledger Card No field.';
                }
                field(PRNNo; Rec."PRN No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the PRN No field.';
                }
                field(ApprovalStatus; Rec."Approval Status")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Approval Status field.';
                }
                field(POStatus; Rec."PO Status")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the PO Status field.';
                }
                field(FinanceStatus; Rec."Finance Status")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Finance Status field.';
                }
                field(AdminStatus; Rec."Admin Status")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Admin Status field.';
                }
                field(POName; Rec."P.O Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the P.O Name field.';
                }
                field(POApprovalDate; Rec."P.O Approval Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the P.O Approval Date field.';
                }
                field(FinanceApprovedBy; Rec."Finance Approved By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Finance Approved By field.';
                }
                field(FinanceApprovalDate; Rec."Finance Approval Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Finance Approval Date field.';
                }
                field(AdminApprovedBy; Rec."Admin Approved By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Admin Approved By field.';
                }
                field(AdminApprovedDate; Rec."Admin Approved Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Admin Approved Date field.';
                }
                field(ContractNo; Rec."Contract No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Contract No. field.';
                }
                field(QuotationNo; Rec."Quotation No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Quotation No. field.';
                }
                field(RequestforQuoteNo; Rec."Request for Quote No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Request for Quote No. field.';
                }
                field(DocumentType2; Rec."Document Type 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Document Type 2 field.';
                }
                field(TendorNumber; Rec."Tendor Number")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Tendor Number field.';
                }
                field(Cancelled; Rec.Cancelled)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cancelled field.';
                }
                field(CancelledBy; Rec."Cancelled By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cancelled By field.';
                }
                field(CancelledDate; Rec."Cancelled Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cancelled Date field.';
                }
                field(DocApprovalType; Rec.DocApprovalType)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the DocApprovalType field.';
                }
                field(ProcurementTypeCode; Rec."Procurement Type Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Procurement Type Code field.';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Quote)
            {
                Caption = '&Quote';
                action(Statistics)
                {
                    ApplicationArea = Basic;
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'F7';
                    ToolTip = 'Executes the Statistics action.';

                    trigger OnAction()
                    begin
                        Rec.CalcInvDiscForHeader;
                        Commit;
                        Page.RunModal(Page::"Purchase Statistics", Rec);
                    end;
                }
                action(Card)
                {
                    ApplicationArea = Basic;
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page "Vendor Card";
                    RunPageLink = "No." = field("Buy-from Vendor No.");
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'Executes the Card action.';
                }
                action(Comments)
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Purch. Comment Sheet";
                    RunPageLink = "Document Type" = field("Document Type"),
                                  "No." = field("No."),
                                  "Document Line No." = const(0);
                    ToolTip = 'Executes the Co&mments action.';
                }
                action(Dimensions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ToolTip = 'Executes the Dimensions action.';

                    trigger OnAction()
                    begin
                        Rec.ShowDocDim;
                    end;
                }
                action(Approvals)
                {
                    ApplicationArea = Basic;
                    Caption = 'Approvals';
                    Image = Approvals;
                    ToolTip = 'Executes the Approvals action.';

                    trigger OnAction()
                    var
                        ApprovalEntries: Page "Approval Entries";
                    begin
                        ApprovalEntries.SetRecordFilters(Database::"Purchase Header", Rec."Document Type", Rec."No.");
                        ApprovalEntries.Run;
                    end;
                }
            }
            group(Line)
            {
                Caption = '&Line';
                group(ItemAvailabilityby)
                {
                    Caption = 'Item Availability by';
                    action(Period)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Period';
                        ToolTip = 'Executes the Period action.';

                        trigger OnAction()
                        begin
                            //CurrPage.PurchLines.PAGE.ItemAvailability(0);
                        end;
                    }
                    action(Variant)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Variant';
                        ToolTip = 'Executes the Variant action.';

                        trigger OnAction()
                        begin
                            //CurrPage.PurchLines.PAGE.ItemAvailability(1);
                        end;
                    }
                    action(Location)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Location';
                        ToolTip = 'Executes the Location action.';

                        trigger OnAction()
                        begin
                            //CurrPage.PurchLines.PAGE.ItemAvailability(2);
                        end;
                    }
                }
                action(Action31)
                {
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'Executes the Dimensions action.';

                    trigger OnAction()
                    begin
                        //CurrPage.PurchLines.PAGE.ShowDimensions;
                    end;
                }
                action(ItemChargeAssignment)
                {
                    ApplicationArea = Basic;
                    Caption = 'Item Charge &Assignment';
                    ToolTip = 'Executes the Item Charge &Assignment action.';

                    trigger OnAction()
                    begin
                        //CurrPage.PurchLines.PAGE.ItemChargeAssgnt;
                    end;
                }
                action(ItemTrackingLines)
                {
                    ApplicationArea = Basic;
                    Caption = 'Item &Tracking Lines';
                    Image = ItemTrackingLines;
                    ShortCutKey = 'Shift+Ctrl+I';
                    ToolTip = 'Executes the Item &Tracking Lines action.';

                    trigger OnAction()
                    begin
                        //CurrPage.PurchLines.PAGE.OpenItemTrackingLines;
                    end;
                }
            }
        }
        area(processing)
        {

            group(Functions)
            {
                Caption = 'F&unctions';
                action(CalculateInvoiceDiscount)
                {
                    ApplicationArea = Basic;
                    Caption = 'Calculate &Invoice Discount';
                    Image = CalculateInvoiceDiscount;
                    ToolTip = 'Executes the Calculate &Invoice Discount action.';

                    trigger OnAction()
                    begin
                        ApproveCalcInvDisc;
                    end;
                }
                separator(Action24) { }
                action(ExplodeBOM)
                {
                    ApplicationArea = Basic;
                    Caption = 'E&xplode BOM';
                    Image = ExplodeBOM;
                    ToolTip = 'Executes the E&xplode BOM action.';

                    trigger OnAction()
                    begin
                        //CurrPage.PurchLines.PAGE.ExplodeBOM;
                    end;
                }
                action(InsertExtTexts)
                {
                    ApplicationArea = Basic;
                    Caption = 'Insert &Ext. Texts';
                    ToolTip = 'Executes the Insert &Ext. Texts action.';

                    trigger OnAction()
                    begin
                        //CurrPage.PurchLines.PAGE.InsertExtendedText(TRUE);
                    end;
                }
                separator(Action21) { }
                action(GetStdVendPurchaseCodes)
                {
                    ApplicationArea = Basic;
                    Caption = 'Get St&d. Vend. Purchase Codes';
                    Ellipsis = true;
                    ToolTip = 'Executes the Get St&d. Vend. Purchase Codes action.';

                    trigger OnAction()
                    var
                        StdVendPurchCode: Record "Standard Vendor Purchase Code";
                    begin
                        StdVendPurchCode.InsertPurchLines(Rec);
                    end;
                }
                separator(Action19) { }
                action(CopyDocument)
                {
                    ApplicationArea = Basic;
                    Caption = 'Copy Document';
                    Ellipsis = true;
                    Image = CopyDocument;
                    ToolTip = 'Executes the Copy Document action.';

                    trigger OnAction()
                    begin
                        CopyPurchDoc.SetPurchHeader(Rec);
                        CopyPurchDoc.RunModal;
                        Clear(CopyPurchDoc);
                    end;
                }
                action(ArchiveDocument)
                {
                    ApplicationArea = Basic;
                    Caption = 'Archi&ve Document';
                    ToolTip = 'Executes the Archi&ve Document action.';

                    trigger OnAction()
                    begin
                        ArchiveManagement.ArchivePurchDocument(Rec);
                        CurrPage.Update(false);
                    end;
                }
                separator(Action16) { }


                separator(Action13) { }


                separator(Action10) { }
                action(Release)
                {
                    ApplicationArea = Basic;
                    Caption = 'Re&lease';
                    Image = ReleaseDoc;
                    ShortCutKey = 'Ctrl+F9';
                    Visible = false;
                    ToolTip = 'Executes the Re&lease action.';

                    trigger OnAction()
                    var
                        ReleasePurchDoc: Codeunit "Release Purchase Document";
                    begin


                        ReleasePurchDoc.PerformManualRelease(Rec);
                    end;
                }
                action(Reopen)
                {
                    ApplicationArea = Basic;
                    Caption = 'Re&open';
                    Image = ReOpen;
                    Visible = false;
                    ToolTip = 'Executes the Re&open action.';

                    trigger OnAction()
                    var
                        ReleasePurchDoc: Codeunit "Release Purchase Document";
                    begin


                        ReleasePurchDoc.PerformManualReopen(Rec);
                    end;
                }
                separator(Action7) { }

            }
            action(Print)
            {
                ApplicationArea = Basic;
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the &Print action.';

                trigger OnAction()
                begin


                    Rec.Reset;
                    Rec.SetRange("No.", Rec."No.");
                    Report.Run(70134835, true, true, Rec);
                    Rec.Reset;
                    //DocPrint.PrintPurchHeader(Rec);
                end;
            }
            action(PurchHistoryBtn)
            {
                ApplicationArea = Basic;
                Caption = 'Purchase H&istory';
                Promoted = true;
                PromotedCategory = Process;
                Visible = PurchHistoryBtnVisible;
                ToolTip = 'Executes the Purchase H&istory action.';

                trigger OnAction()
                begin
                    //PurchInfoPaneMgmt.LookupVendPurchaseHistory(Rec,"Pay-to Vendor No.",TRUE);
                end;
            }
            action(PurchHistoryBtn1)
            {
                ApplicationArea = Basic;
                Caption = 'Purchase Histor&y';
                Promoted = true;
                PromotedCategory = Process;
                Visible = PurchHistoryBtn1Visible;
                ToolTip = 'Executes the Purchase Histor&y action.';

                trigger OnAction()
                begin
                    //PurchInfoPaneMgmt.LookupVendPurchaseHistory(Rec,"Buy-from Vendor No.",FALSE);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        //SETFILTER("Assigned User ID",'=%1',USERID);
        //SETFILTER("User ID",USERID);
    end;

    var
        CopyPurchDoc: Report "Copy Purchase Document";

        ArchiveManagement: Codeunit ArchiveManagement;
        [InDataSet]
        PurchHistoryBtnVisible: Boolean;
        [InDataSet]
        PurchHistoryBtn1Visible: Boolean;
        [InDataSet]
        PurchLinesEditable: Boolean;

    local procedure ApproveCalcInvDisc()
    begin
        //CurrPage.PurchLines.PAGE.ApproveCalcInvDisc;
    end;

    local procedure UpdateInfoPanel()
    begin
        /*
        DifferBuyFromPayTo := "Buy-from Vendor No." <> "Pay-to Vendor No.";
        PurchHistoryBtnVisible := DifferBuyFromPayTo;
        PayToCommentPictVisible := DifferBuyFromPayTo;
        PayToCommentBtnVisible := DifferBuyFromPayTo;
        PurchHistoryBtn1Visible := PurchInfoPaneMgmt.DocExist(Rec,"Buy-from Vendor No.");
        IF DifferBuyFromPayTo THEN
          PurchHistoryBtnVisible := PurchInfoPaneMgmt.DocExist(Rec,"Pay-to Vendor No.")
        */

    end;





    procedure UpdateControls()
    begin
        if Rec.Status <> Rec.Status::Open then begin
            PurchLinesEditable := false;
        end else
            PurchLinesEditable := true;
    end;

    local procedure ShortcutDimension1CodeOnAfterV()
    begin
        //CurrPage.PurchLines.PAGE.UpdateForm(TRUE);
    end;

    local procedure ShortcutDimension2CodeOnAfterV()
    begin
        //CurrPage.PurchLines.PAGE.UpdateForm(TRUE);
    end;

    local procedure CurrencyCodeOnAfterValidate()
    begin
        //CurrPage.PurchLines.PAGE.UpdateForm(TRUE);
    end;

    trigger OnAfterGetCurrRecord()
    begin
        xRec := Rec;

        UpdateControls;
    end;
}

