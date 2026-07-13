Page 50851 "Purchase Quote List"
{
    CardPageID = "Internal Requisitions Approved";
    PageType = List;
    SourceTable = "Purchase Header";
    SourceTableView = where("Document Type" = filter(Quote), DocApprovalType = filter(<> Requisition),
                            Status = filter(Released));
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                field(DocumentType; Rec."Document Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Document Type field.';
                }
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
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
                field(PostingDate; Rec."Posting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the posting of the purchase document will be recorded.';
                }
                field(ExpectedClosingDate; Rec."Expected Closing Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Expected Closing Date field.';
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
                field(QuoteNo; Rec."Quote No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quote number for the purchase order.';
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
                field(LocationFilter; Rec."Location Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Location Filter field.';
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

    actions { }
}

