namespace ABH_UAT_LIVE.ABH_UAT_LIVE;

using Microsoft.Sales.History;

report 50376 VATREPORTERCA
{
    ApplicationArea = All;
    Caption = 'VATREPORTERCA';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout=Excel;
        ExcelLayout='./Layouts/vaterca.xlsx';
    dataset
    {
        dataitem(SalesInvoiceHeader; "Sales Invoice Header")
        {
            column(AllowLineDisc; "Allow Line Disc.")
            {
            }
            column(Amount; Amount)
            {
            }
            column(AmountIncludingVAT; "Amount Including VAT")
            {
            }
            column(AppliedCreditMemoNo; "Applied Credit Memo No")
            {
            }
            column(AppliestoDocNo; "Applies-to Doc. No.")
            {
            }
            column(AppliestoDocType; "Applies-to Doc. Type")
            {
            }
            
            column(BalAccountNo; "Bal. Account No.")
            {
            }
            column(BalAccountType; "Bal. Account Type")
            {
            }
            column(BankAccountNo; "Bank Account No")
            {
            }
            column(BilltoAddress; "Bill-to Address")
            {
            }
            column(BilltoAddress2; "Bill-to Address 2")
            {
            }
            column(BilltoCity; "Bill-to City")
            {
            }
            column(BilltoContact; "Bill-to Contact")
            {
            }
            column(BilltoContactNo; "Bill-to Contact No.")
            {
            }
            column(BilltoCountryRegionCode; "Bill-to Country/Region Code")
            {
            }
            column(BilltoCounty; "Bill-to County")
            {
            }
            column(BilltoCustomerNo; "Bill-to Customer No.")
            {
            }
            column(BilltoName; "Bill-to Name")
            {
            }
            column(BilltoName2; "Bill-to Name 2")
            {
            }
            column(BilltoPostCode; "Bill-to Post Code")
            {
            }
            column(CFDICancellationID; "CFDI Cancellation ID")
            {
            }
            column(CFDICancellationReasonCode; "CFDI Cancellation Reason Code")
            {
            }
            column(CFDIExportCode; "CFDI Export Code")
            {
            }
            column(CFDIPeriod; "CFDI Period")
            {
            }
            column(CFDIPurpose; "CFDI Purpose")
            {
            }
            column(CFDIRelation; "CFDI Relation")
            {
            }
            column(CampaignNo; "Campaign No.")
            {
            }
            column(Cancelled; Cancelled)
            {
            }
            column(CashSale; "Cash Sale")
            {
            }
            column(CertificateSerialNo; "Certificate Serial No.")
            {
            }
            column(Closed; Closed)
            {
            }
            column(Comment; Comment)
            {
            }
            column(CompanyBankAccountCode; "Company Bank Account Code")
            {
            }
            column(Correction; Correction)
            {
            }
            column(Corrective; Corrective)
            {
            }
            column(CoupledtoCRM; "Coupled to CRM")
            {
            }
            column(CoupledtoDataverse; "Coupled to Dataverse")
            {
            }
            column(CurrencyCode; "Currency Code")
            {
            }
            column(CurrencyFactor; "Currency Factor")
            {
            }
            column(CustLedgerEntryNo; "Cust. Ledger Entry No.")
            {
            }
            column(CustomerDiscGroup; "Customer Disc. Group")
            {
            }
            column(CustomerPostingGroup; "Customer Posting Group")
            {
            }
            column(CustomerPriceGroup; "Customer Price Group")
            {
            }
            column(DateTimeCancelSent; "Date/Time Cancel Sent")
            {
            }
            column(DateTimeCanceled; "Date/Time Canceled")
            {
            }
            column(DateTimeFirstReqSent; "Date/Time First Req. Sent")
            {
            }
            column(DateTimeSent; "Date/Time Sent")
            {
            }
            column(DateTimeStampReceived; "Date/Time Stamp Received")
            {
            }
            column(DateTimeStamped; "Date/Time Stamped")
            {
            }
            column(DigitalStampPAC; "Digital Stamp PAC")
            {
            }
            column(DigitalStampSAT; "Digital Stamp SAT")
            {
            }
            column(DimensionSetID; "Dimension Set ID")
            {
            }
            column(DirectDebitMandateID; "Direct Debit Mandate ID")
            {
            }
            column(DisputeStatus; "Dispute Status")
            {
            }
            column(DisputeStatusId; "Dispute Status Id")
            {
            }
            column(DocExchOriginalIdentifier; "Doc. Exch. Original Identifier")
            {
            }
            column(DocumentDate; "Document Date")
            {
            }
            column(DocumentExchangeIdentifier; "Document Exchange Identifier")
            {
            }
            column(DocumentExchangeStatus; "Document Exchange Status")
            {
            }
            column(DraftInvoiceSystemId; "Draft Invoice SystemId")
            {
            }
            column(DueDate; "Due Date")
            {
            }
            column(EU3PartyTrade; "EU 3-Party Trade")
            {
            }
            column(ElectronicDocumentSent; "Electronic Document Sent")
            {
            }
            column(ElectronicDocumentStatus; "Electronic Document Status")
            {
            }
            column(ErrorCode; "Error Code")
            {
            }
            column(ErrorDescription; "Error Description")
            {
            }
            column(ExchangeRateUSD; "Exchange Rate USD")
            {
            }
            column(ExitPoint; "Exit Point")
            {
            }
            column(ExternalDocumentNo; "External Document No.")
            {
            }
            column(FiscalInvoiceNumberPAC; "Fiscal Invoice Number PAC")
            {
            }
            column(ForeignTrade; "Foreign Trade")
            {
            }
            column(FormatRegion; "Format Region")
            {
            }
            column(GenBusPostingGroup; "Gen. Bus. Posting Group")
            {
            }
            column(GetShipmentUsed; "Get Shipment Used")
            {
            }
            column(InvoiceCleared; "Invoice Cleared")
            {
            }
            column(InvoiceDiscCode; "Invoice Disc. Code")
            {
            }
            column(InvoiceDiscountAmount; "Invoice Discount Amount")
            {
            }
            column(InvoiceDiscountCalculation; "Invoice Discount Calculation")
            {
            }
            column(InvoiceDiscountValue; "Invoice Discount Value")
            {
            }
            column(LanguageCode; "Language Code")
            {
            }
            column(LocationCode; "Location Code")
            {
            }
            column(MarkedasCanceled; "Marked as Canceled")
            {
            }
            column(No; "No.")
            {
            }
            column(NoPrinted; "No. Printed")
            {
            }
            column(NoSeries; "No. Series")
            {
            }
            column(NoofEDocumentsSent; "No. of E-Documents Sent")
            {
            }
            column(OnHold; "On Hold")
            {
            }
            column(OpportunityNo; "Opportunity No.")
            {
            }
            column(OrderDate; "Order Date")
            {
            }
            column(OrderNo; "Order No.")
            {
            }
            column(OrderNoSeries; "Order No. Series")
            {
            }
            column(OriginalDocumentXML; "Original Document XML")
            {
            }
            column(OriginalString; "Original String")
            {
            }
            column(PACWebServiceName; "PAC Web Service Name")
            {
            }
            column(PackageTrackingNo; "Package Tracking No.")
            {
            }
            column(PayMode; "Pay Mode")
            {
            }
            column(PaymentDiscount; "Payment Discount %")
            {
            }
            column(PaymentMethodCode; "Payment Method Code")
            {
            }
            column(PaymentReference; "Payment Reference")
            {
            }
            column(PaymentServiceSetID; "Payment Service Set ID")
            {
            }
            column(PaymentTermsCode; "Payment Terms Code")
            {
            }
            column(PmtDiscountDate; "Pmt. Discount Date")
            {
            }
            column(PostingDate; "Posting Date")
            {
            }
            column(PostingDescription; "Posting Description")
            {
            }
            column(PreAssignedNo; "Pre-Assigned No.")
            {
            }
            column(PreAssignedNoSeries; "Pre-Assigned No. Series")
            {
            }
            column(PreparedBy; "Prepared By")
            {
            }
            column(PrepaymentInvoice; "Prepayment Invoice")
            {
            }
            column(PrepaymentNoSeries; "Prepayment No. Series")
            {
            }
            column(PrepaymentOrderNo; "Prepayment Order No.")
            {
            }
            column(PriceCalculationMethod; "Price Calculation Method")
            {
            }
            column(PricesIncludingVAT; "Prices Including VAT")
            {
            }
            column(PromisedPayDate; "Promised Pay Date")
            {
            }
            column(QRCode; "QR Code")
            {
            }
            column(QuoteNo; "Quote No.")
            {
            }
            column(ReasonCode; "Reason Code")
            {
            }
            column(RegistrationNumber; "Registration Number")
            {
            }
            column(RemainingAmount; "Remaining Amount")
            {
            }
            column(ResponsibilityCenter; "Responsibility Center")
            {
            }
            column(Reversed; Reversed)
            {
            }
            column(SATAddressID; "SAT Address ID")
            {
            }
            column(SATInternationalTradeTerm; "SAT International Trade Term")
            {
            }
            column(STETransactionID; "STE Transaction ID")
            {
            }
            column(SalesPerson; "Sales Person")
            {
            }
            column(SalespersonCode; "Salesperson Code")
            {
            }
            column(SelltoAddress; "Sell-to Address")
            {
            }
            column(SelltoAddress2; "Sell-to Address 2")
            {
            }
            column(SelltoCity; "Sell-to City")
            {
            }
            column(SelltoContact; "Sell-to Contact")
            {
            }
            column(SelltoContactNo; "Sell-to Contact No.")
            {
            }
            column(SelltoCountryRegionCode; "Sell-to Country/Region Code")
            {
            }
            column(SelltoCounty; "Sell-to County")
            {
            }
            column(SelltoCustomerName; "Sell-to Customer Name")
            {
            }
            column(SelltoCustomerName2; "Sell-to Customer Name 2")
            {
            }
            column(SelltoCustomerNo; "Sell-to Customer No.")
            {
            }
            column(SelltoEMail; "Sell-to E-Mail")
            {
            }
            column(SelltoPhoneNo; "Sell-to Phone No.")
            {
            }
            column(SelltoPostCode; "Sell-to Post Code")
            {
            }
            column(ShiftNo; "Shift No")
            {
            }
            column(ShiptoAddress; "Ship-to Address")
            {
            }
            column(ShiptoAddress2; "Ship-to Address 2")
            {
            }
            column(ShiptoCity; "Ship-to City")
            {
            }
            column(ShiptoCode; "Ship-to Code")
            {
            }
            column(ShiptoContact; "Ship-to Contact")
            {
            }
            column(ShiptoCountryRegionCode; "Ship-to Country/Region Code")
            {
            }
            column(ShiptoCounty; "Ship-to County")
            {
            }
            column(ShiptoName; "Ship-to Name")
            {
            }
            column(ShiptoName2; "Ship-to Name 2")
            {
            }
            column(ShiptoPostCode; "Ship-to Post Code")
            {
            }
            column(ShiptoUPSZone; "Ship-to UPS Zone")
            {
            }
            column(ShipmentDate; "Shipment Date")
            {
            }
            column(ShipmentMethodCode; "Shipment Method Code")
            {
            }
            column(ShippingAgentCode; "Shipping Agent Code")
            {
            }
            column(ShortcutDimension1Code; "Shortcut Dimension 1 Code")
            {
            }
            column(ShortcutDimension2Code; "Shortcut Dimension 2 Code")
            {
            }
            column(SignedDocumentXML; "Signed Document XML")
            {
            }
            column(SourceCode; "Source Code")
            {
            }
            column(SubstitutionDocumentNo; "Substitution Document No.")
            {
            }
            column(SystemCreatedAt; SystemCreatedAt)
            {
            }
            column(SystemCreatedBy; SystemCreatedBy)
            {
            }
            column(SystemId; SystemId)
            {
            }
            column(SystemModifiedAt; SystemModifiedAt)
            {
            }
            column(SystemModifiedBy; SystemModifiedBy)
            {
            }
            column(TaxAreaCode; "Tax Area Code")
            {
            }
            column(TaxExemptionNo; "Tax Exemption No.")
            {
            }
            column(TaxLiable; "Tax Liable")
            {
            }
            column(TotalAmount; "Total Amount")
            {
            }
            column(TransactionNo; "Transaction No")
            {
            }
            column(TransactionSpecification; "Transaction Specification")
            {
            }
            column(TransactionType; "Transaction Type")
            {
            }
            column(TransittoLocation; "Transit-to Location")
            {
            }
            column(TransportMethod; "Transport Method")
            {
            }
            column(UserID; "User ID")
            {
            }
            column(VATBaseDiscount; "VAT Base Discount %")
            {
            }
            column(VATBusPostingGroup; "VAT Bus. Posting Group")
            {
            }
            column(VATCountryRegionCode; "VAT Country/Region Code")
            {
            }
            column(VATRegistrationNo; "VAT Registration No.")
            {
            }
            column(VATReportingDate; "VAT Reporting Date")
            {
            }
            column(WorkDescription; "Work Description")
            {
            }
            column(YourReference; "Your Reference")
            {
            }
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
}
