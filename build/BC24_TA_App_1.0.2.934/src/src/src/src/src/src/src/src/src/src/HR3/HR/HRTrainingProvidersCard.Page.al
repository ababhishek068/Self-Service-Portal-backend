Page 50838 "HR Training Providers Card"
{
    Caption = 'Vendor Card';
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = Vendor;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the vendor''s name. You can enter a maximum of 30 characters, both numbers and letters.';
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the vendor''s address.';
                }
                field(Address2; Rec."Address 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies additional address information.';
                }
                field(PostCode; Rec."Post Code")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the postal code.';
                }
                field(CountryRegionCode; Rec."Country/Region Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the country/region of the address.';
                }
                field(PhoneNo; Rec."Phone No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the vendor''s telephone number.';
                }
                field(PrimaryContactNo; Rec."Primary Contact No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the primary contact number for the vendor.';


                }
                field(Control16; Rec.Contact)
                {
                    ApplicationArea = Basic;

                    Importance = Promoted;
                    ToolTip = 'Specifies the name of the person you regularly contact when you do business with this vendor.';


                }
                field(City; Rec.City)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the vendor''s city.';
                }
                field(SearchName; Rec."Search Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies an alternate name that you can use to search for the record in question when you cannot remember the value in the Name field.';
                }
                field(BalanceLCY; Rec."Balance (LCY)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the total value of your completed purchases from the vendor in the current fiscal year. It is calculated from amounts excluding VAT on all completed purchase invoices and credit memos.';

                    trigger OnDrillDown()
                    var
                        VendLedgEntry: Record "Vendor Ledger Entry";
                        DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
                    begin
                        DtldVendLedgEntry.SetRange("Vendor No.", Rec."No.");
                        Rec.Copyfilter("Global Dimension 1 Filter", DtldVendLedgEntry."Initial Entry Global Dim. 1");
                        Rec.Copyfilter("Global Dimension 2 Filter", DtldVendLedgEntry."Initial Entry Global Dim. 2");
                        Rec.Copyfilter("Currency Filter", DtldVendLedgEntry."Currency Code");
                        VendLedgEntry.DrillDownOnEntries(DtldVendLedgEntry);
                    end;
                }
                field(PurchaserCode; Rec."Purchaser Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies which purchaser is assigned to the vendor.';
                }
                field(ResponsibilityCenter; Rec."Responsibility Center")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the responsibility center, such as a distribution hub, that is associated with the involved user, company, customer, or vendor.';
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that the related record is blocked from being posted in transactions, for example a vendor that is declared insolvent or an item that is placed in quarantine.';
                }
                field(LastDateModified; Rec."Last Date Modified")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies when the vendor card was last modified.';
                }
            }
            group(Communication)
            {
                Caption = 'Communication';
                field("Phone No.2"; Rec."Phone No.")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the vendor''s telephone number.';
                }
                field(FaxNo; Rec."Fax No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the vendor''s fax number.';
                }
                field(EMail; Rec."E-Mail")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the vendor''s email address.';
                }
                field(HomePage; Rec."Home Page")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the vendor''s web site.';
                }
                field(ICPartnerCode; Rec."IC Partner Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the vendor''s intercompany partner code.';
                }
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field(PaytoVendorNo; Rec."Pay-to Vendor No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of a different vendor whom you pay for products delivered by the vendor on the vendor card.';
                }
                field(GenBusPostingGroup; Rec."Gen. Bus. Posting Group")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the vendor''s trade type to link transactions made for this vendor with the appropriate general ledger account according to the general posting setup.';
                }
                field(VATBusPostingGroup; Rec."VAT Bus. Posting Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the VAT specification of the involved customer or vendor to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.';
                }
                field(VendorPostingGroup; Rec."Vendor Posting Group")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the vendor''s market type to link business transactions made for the vendor with the appropriate account in the general ledger.';
                }
                field(InvoiceDiscCode; Rec."Invoice Disc. Code")
                {
                    ApplicationArea = Basic;
                    NotBlank = true;
                    ToolTip = 'Specifies the vendor''s invoice discount code. When you set up a new vendor card, the number you have entered in the No. field is automatically inserted.';
                }
                field(PricesIncludingVAT; Rec."Prices Including VAT")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if the Unit Price and Line Amount fields on document lines should be shown with or without VAT.';
                }
                field(Prepayment; Rec."Prepayment %")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a prepayment percentage that applies to all orders for this vendor, regardless of the items or services on the order lines.';
                }
            }
            group(Payments)
            {
                Caption = 'Payments';
                field(ApplicationMethod; Rec."Application Method")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how to apply payments to entries for this vendor.';
                }
                field(PartnerType; Rec."Partner Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if the vendor is a person or a company.';
                }
                field(PaymentTermsCode; Rec."Payment Terms Code")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies a formula that calculates the payment due date, payment discount date, and payment discount amount.';
                }
                field(PaymentMethodCode; Rec."Payment Method Code")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies how to make payment, such as with bank transfer, cash, or check.';
                }
                field(Priority; Rec.Priority)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the importance of the vendor when suggesting payments using the Suggest Vendor Payments function.';
                }
                field(CashFlowPaymentTermsCode; Rec."Cash Flow Payment Terms Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a payment term that will be used for calculating cash flow.';
                }
                field(OurAccountNo; Rec."Our Account No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies your account number with the vendor, if you have one.';
                }
                field(BlockPaymentTolerance; Rec."Block Payment Tolerance")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if the vendor allows payment tolerance.';


                }
                field(CreditorNo; Rec."Creditor No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the vendor.';
                }
            }
            group(Receiving)
            {
                Caption = 'Receiving';
                field(LocationCode; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the warehouse location where items from the vendor must be received by default.';
                }
                field(ShipmentMethodCode; Rec."Shipment Method Code")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the delivery conditions of the related shipment, such as free on board (FOB).';
                }
                field(LeadTimeCalculation; Rec."Lead Time Calculation")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies a date formula for the amount of time it takes to replenish the item.';
                }
                field(BaseCalendarCode; Rec."Base Calendar Code")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    ToolTip = 'Specifies a customizable calendar for delivery planning that holds the vendor''s working days and holidays.';
                }
                label("Customized Calendar")
                {
                    ApplicationArea = Basic;
                    Caption = 'Customized Calendar';
                    Editable = false;


                }
            }
            group(ForeignTrade)
            {
                Caption = 'Foreign Trade';
                field(CurrencyCode; Rec."Currency Code")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the currency code that is inserted by default when you create purchase documents or journal lines for the vendor.';
                }
                field(LanguageCode; Rec."Language Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the language that is used when translating specified text on documents to foreign business partner, such as an item description on an order confirmation.';
                }
                field(VATRegistrationNo; Rec."VAT Registration No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the vendor''s VAT registration number.';
                }
            }
        }
        area(factboxes)
        {
            part(Control1904651607; "Vendor Statistics FactBox")
            {
                SubPageLink = "No." = FIELD("No."),
                              "Currency Filter" = FIELD("Currency Filter"),
                              "Date Filter" = FIELD("Date Filter"),
                              "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                Visible = true;
            }
            part(Control1903435607; "Vendor Hist. Buy-from FactBox")
            {
                SubPageLink = "No." = FIELD("No."),
                              "Currency Filter" = FIELD("Currency Filter"),
                              "Date Filter" = FIELD("Date Filter"),
                              "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                Visible = true;
            }
            part(Control1906949207; "Vendor Hist. Pay-to FactBox")
            {
                SubPageLink = "No." = FIELD("No."),
                              "Currency Filter" = FIELD("Currency Filter"),
                              "Date Filter" = FIELD("Date Filter"),
                              "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                Visible = false;
            }
            systempart(Control1900383207; Links)
            {
                Visible = true;
            }
            systempart(Control1905767507; Notes)
            {
                Visible = true;
            }
        }
    }
}


