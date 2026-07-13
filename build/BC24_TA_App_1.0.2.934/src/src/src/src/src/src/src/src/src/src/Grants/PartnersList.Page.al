Page 50069 "Partners List"
{
    Caption = 'Partners List';
    CardPageID = "Partner Card";
    DeleteAllowed = false;
    Editable = false;
    PageType = List;
    SourceTable = Vendor;
    SourceTableView = where("Vendor Type" = filter("Implementing Partner"));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the vendor''s name. You can enter a maximum of 30 characters, both numbers and letters.';
                }
                field(ResponsibilityCenter; Rec."Responsibility Center")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the responsibility center, such as a distribution hub, that is associated with the involved user, company, customer, or vendor.';
                }
                field(LocationCode; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the warehouse location where items from the vendor must be received by default.';
                }
                field(PostCode; Rec."Post Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the postal code.';
                }
                field(CountryRegionCode; Rec."Country/Region Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the country/region of the address.';
                }
                field(PhoneNo; Rec."Phone No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the vendor''s telephone number.';
                }
                field(FaxNo; Rec."Fax No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the vendor''s fax number.';
                }
                field(Control35; Rec.Contact)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the person you regularly contact when you do business with this vendor.';
                }
                field(PurchaserCode; Rec."Purchaser Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies which purchaser is assigned to the vendor.';
                }
                field(SubPostingGroup; Rec."Vendor Posting Group")
                {
                    ApplicationArea = Basic;
                    Caption = 'Sub Posting Group';
                    Visible = false;
                    ToolTip = 'Specifies the vendor''s market type to link business transactions made for the vendor with the appropriate account in the general ledger.';
                }
                field(GenBusPostingGroup; Rec."Gen. Bus. Posting Group")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the vendor''s trade type to link transactions made for this vendor with the appropriate general ledger account according to the general posting setup.';
                }
                field(VATBusPostingGroup; Rec."VAT Bus. Posting Group")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the VAT specification of the involved customer or vendor to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.';
                }
                field(PaymentTermsCode; Rec."Payment Terms Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies a formula that calculates the payment due date, payment discount date, and payment discount amount.';
                }
                field(CurrencyCode; Rec."Currency Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the currency code that is inserted by default when you create purchase documents or journal lines for the vendor.';
                }
                field(SearchName; Rec."Search Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies an alternate name that you can use to search for the record in question when you cannot remember the value in the Name field.';
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies that the related record is blocked from being posted in transactions, for example a vendor that is declared insolvent or an item that is placed in quarantine.';
                }
                field(LastDateModified; Rec."Last Date Modified")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies when the vendor card was last modified.';
                }
                field(ApplicationMethod; Rec."Application Method")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies how to apply payments to entries for this vendor.';
                }
                field("Location Code2"; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the warehouse location where items from the vendor must be received by default.';
                }
            }
        }
        area(factboxes)
        {
            part(Control1901138007; "Vendor Details FactBox")
            {
                Caption = 'Subs Details FactBox';
                SubPageLink = "No." = field("No."),
                              "Currency Filter" = field("Currency Filter"),
                              "Date Filter" = field("Date Filter"),
                              "Global Dimension 1 Filter" = field("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter" = field("Global Dimension 2 Filter");
                Visible = false;
            }
            part(Control1904651607; "Vendor Statistics FactBox")
            {
                Caption = 'Subs Statistics FactBox';
                SubPageLink = "No." = field("No."),
                              "Currency Filter" = field("Currency Filter"),
                              "Date Filter" = field("Date Filter"),
                              "Global Dimension 1 Filter" = field("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter" = field("Global Dimension 2 Filter");
                Visible = true;
            }
            part(Control1903435607; "Vendor Hist. Buy-from FactBox")
            {
                Caption = 'Subs Hist. Buy-from FactBox';
                SubPageLink = "No." = field("No."),
                              "Currency Filter" = field("Currency Filter"),
                              "Date Filter" = field("Date Filter"),
                              "Global Dimension 1 Filter" = field("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter" = field("Global Dimension 2 Filter");
                Visible = true;
            }
            part(Control1906949207; "Vendor Hist. Pay-to FactBox")
            {
                Caption = 'Subs Hist. Pay-to FactBox';
                SubPageLink = "No." = field("No."),
                              "Currency Filter" = field("Currency Filter"),
                              "Date Filter" = field("Date Filter"),
                              "Global Dimension 1 Filter" = field("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter" = field("Global Dimension 2 Filter");
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

    actions
    {
        area(navigation)
        {
            group(Vendor)
            {
                Caption = 'Ven&dor';
                Image = Vendor;
                group(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    action(DimensionsSingle)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Dimensions-Single';
                        Image = Dimensions;
                        RunObject = Page "Default Dimensions";
                        RunPageLink = "Table ID" = const(23),
                                      "No." = field("No.");
                        ShortCutKey = 'Shift+Ctrl+D';
                        ToolTip = 'Executes the Dimensions-Single action.';
                    }
                    action(DimensionsMultiple)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Dimensions-&Multiple';
                        Image = DimensionSets;
                        ToolTip = 'Executes the Dimensions-&Multiple action.';

                        trigger OnAction()
                        var
                            Vend: Record Vendor;
                            DefaultDimMultiple: Page "Default Dimensions-Multiple";
                        begin
                            CurrPage.SetSelectionFilter(Vend);
                            //  DefaultDimMultiple.SetMultiVendor(Vend);
                            DefaultDimMultiple.RunModal;
                        end;
                    }
                }
                action(BankAccounts)
                {
                    ApplicationArea = Basic;
                    Caption = 'Bank Accounts';
                    Image = BankAccount;
                    RunObject = Page "Vendor Bank Account List";
                    RunPageLink = "Vendor No." = field("No.");
                    ToolTip = 'Executes the Bank Accounts action.';
                }
                action(Contact)
                {
                    ApplicationArea = Basic;
                    Caption = 'C&ontact';
                    Image = ContactPerson;
                    ToolTip = 'Executes the C&ontact action.';

                    trigger OnAction()
                    begin
                        Rec.ShowContact;
                    end;
                }
                separator(Action55) { }
                action(OrderAddresses)
                {
                    ApplicationArea = Basic;
                    Caption = 'Order &Addresses';
                    Image = Addresses;
                    RunObject = Page "Order Address List";
                    RunPageLink = "Vendor No." = field("No.");
                    ToolTip = 'Executes the Order &Addresses action.';
                }
                action(Comments)
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name" = const(Vendor),
                                  "No." = field("No.");
                    ToolTip = 'Executes the Co&mments action.';
                }
                action(CrossReferences)
                {
                    ApplicationArea = Basic;
                    Caption = 'Cross Re&ferences';
                    Image = Change;
                    ToolTip = 'Executes the Cross Re&ferences action.';
                    // RunObject = Page "Cross References";
                    // RunPageLink = "Item Reference Type" = const(Vendor),
                    //               "Item Reference Type No." = field("No.");
                    // RunPageView = sorting("Item Reference Type", "Item Reference Type No.");
                }
                separator(Action61) { }
            }
            group(Purchases)
            {
                Caption = '&Purchases';
                Image = Purchasing;
                action(Items)
                {
                    ApplicationArea = Basic;
                    Caption = 'Items';
                    Image = Item;
                    RunObject = Page "Vendor Item Catalog";
                    RunPageLink = "Vendor No." = field("No.");
                    RunPageView = sorting("Vendor No.");
                    ToolTip = 'Executes the Items action.';
                }
                action(InvoiceDiscounts)
                {
                    ApplicationArea = Basic;
                    Caption = 'Invoice &Discounts';
                    Image = CalculateInvoiceDiscount;
                    RunObject = Page "Vend. Invoice Discounts";
                    RunPageLink = Code = field("Invoice Disc. Code");
                    ToolTip = 'Executes the Invoice &Discounts action.';
                }
                action(Prices)
                {
                    ApplicationArea = Basic;
                    Caption = 'Prices';
                    Image = Price;
                    RunObject = Page "Purchase Prices";
                    RunPageLink = "Vendor No." = field("No.");
                    RunPageView = sorting("Vendor No.");
                    ToolTip = 'Executes the Prices action.';
                }
                action(LineDiscounts)
                {
                    ApplicationArea = Basic;
                    Caption = 'Line Discounts';
                    Image = LineDiscount;
                    RunObject = Page "Purchase Line Discounts";
                    RunPageLink = "Vendor No." = field("No.");
                    RunPageView = sorting("Vendor No.");
                    ToolTip = 'Executes the Line Discounts action.';
                }
                action(PrepaymentPercentages)
                {
                    ApplicationArea = Basic;
                    Caption = 'Prepa&yment Percentages';
                    Image = PrepaymentPercentages;
                    RunObject = Page "Purchase Prepmt. Percentages";
                    RunPageLink = "Vendor No." = field("No.");
                    RunPageView = sorting("Vendor No.");
                    ToolTip = 'Executes the Prepa&yment Percentages action.';
                }
                action(StdVendPurchaseCodes)
                {
                    ApplicationArea = Basic;
                    Caption = 'S&td. Vend. Purchase Codes';
                    Image = CodesList;
                    RunObject = Page "Standard Vendor Purchase Codes";
                    RunPageLink = "Vendor No." = field("No.");
                    ToolTip = 'Executes the S&td. Vend. Purchase Codes action.';
                }
            }
            group(Documents)
            {
                Caption = 'Documents';
                Image = Administration;
                action(Quotes)
                {
                    ApplicationArea = Basic;
                    Caption = 'Quotes';
                    Image = Quote;
                    RunObject = Page "Purchase Quotes";
                    RunPageLink = "Buy-from Vendor No." = field("No.");
                    RunPageView = sorting("Document Type", "Buy-from Vendor No.");
                    ToolTip = 'Executes the Quotes action.';
                }
                action(Orders)
                {
                    ApplicationArea = Basic;
                    Caption = 'Orders';
                    Image = Document;
                    RunObject = Page "Purchase Order List";
                    RunPageLink = "Buy-from Vendor No." = field("No.");
                    RunPageView = sorting("Document Type", "Buy-from Vendor No.");
                    ToolTip = 'Executes the Orders action.';
                }
                action(ReturnOrders)
                {
                    ApplicationArea = Basic;
                    Caption = 'Return Orders';
                    Image = ReturnOrder;
                    RunObject = Page "Purchase Return Order List";
                    RunPageLink = "Buy-from Vendor No." = field("No.");
                    RunPageView = sorting("Document Type", "Buy-from Vendor No.");
                    ToolTip = 'Executes the Return Orders action.';
                }
                action(BlanketOrders)
                {
                    ApplicationArea = Basic;
                    Caption = 'Blanket Orders';
                    Image = BlanketOrder;
                    RunObject = Page "Blanket Purchase Orders";
                    RunPageLink = "Buy-from Vendor No." = field("No.");
                    RunPageView = sorting("Document Type", "Buy-from Vendor No.");
                    ToolTip = 'Executes the Blanket Orders action.';
                }
            }
            group(History)
            {
                Caption = 'History';
                Image = History;
                action(LedgerEntries)
                {
                    ApplicationArea = Basic;
                    Caption = 'Ledger E&ntries';
                    Image = CustomerLedger;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Vendor Ledger Entries";
                    RunPageLink = "Vendor No." = field("No.");
                    RunPageView = sorting("Vendor No.");
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'Executes the Ledger E&ntries action.';
                }
                action(Statistics)
                {
                    ApplicationArea = Basic;
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Vendor Statistics";
                    RunPageLink = "No." = field("No."),
                                  "Date Filter" = field("Date Filter"),
                                  "Global Dimension 1 Filter" = field("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter" = field("Global Dimension 2 Filter");
                    ShortCutKey = 'F7';
                    ToolTip = 'Executes the Statistics action.';
                }
                action(Action21)
                {
                    ApplicationArea = Basic;
                    Caption = 'Purchases';
                    Image = Purchase;
                    RunObject = Page "Vendor Purchases";
                    RunPageLink = "No." = field("No."),
                                  "Global Dimension 1 Filter" = field("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter" = field("Global Dimension 2 Filter");
                    ToolTip = 'Executes the Purchases action.';
                }
                action(EntryStatistics)
                {
                    ApplicationArea = Basic;
                    Caption = 'Entry Statistics';
                    Image = EntryStatistics;
                    RunObject = Page "Vendor Entry Statistics";
                    RunPageLink = "No." = field("No."),
                                  "Date Filter" = field("Date Filter"),
                                  "Global Dimension 1 Filter" = field("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter" = field("Global Dimension 2 Filter");
                    ToolTip = 'Executes the Entry Statistics action.';
                }
                action(StatisticsbyCurrencies)
                {
                    ApplicationArea = Basic;
                    Caption = 'Statistics by C&urrencies';
                    Image = Currencies;
                    RunObject = Page "Vend. Stats. by Curr. Lines";
                    RunPageLink = "Vendor Filter" = field("No."),
                                  "Global Dimension 1 Filter" = field("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter" = field("Global Dimension 2 Filter"),
                                  "Date Filter" = field("Date Filter");
                    ToolTip = 'Executes the Statistics by C&urrencies action.';
                }
                action(ItemTrackingEntries)
                {
                    ApplicationArea = Basic;
                    Caption = 'Item &Tracking Entries';
                    Image = ItemTrackingLedger;
                    ToolTip = 'Executes the Item &Tracking Entries action.';

                    trigger OnAction()
                    begin
                        //ItemTrackingMgt.CallItemTrackingEntryForm(2,"No.",'','','','','');
                    end;
                }
            }
        }
        area(creation)
        {
            action(BlanketPurchaseOrder)
            {
                ApplicationArea = Basic;
                Caption = 'Blanket Purchase Order';
                Image = BlanketOrder;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = New;
                RunObject = Page "Blanket Purchase Order";
                RunPageLink = "Buy-from Vendor No." = field("No.");
                RunPageMode = Create;
                ToolTip = 'Executes the Blanket Purchase Order action.';
            }
            action(PurchaseQuote)
            {
                ApplicationArea = Basic;
                Caption = 'Purchase Quote';
                Image = Quote;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = New;
                RunObject = Page "Purchase Quote";
                RunPageLink = "Buy-from Vendor No." = field("No.");
                RunPageMode = Create;
                ToolTip = 'Executes the Purchase Quote action.';
            }
            action(PurchaseInvoice)
            {
                ApplicationArea = Basic;
                Caption = 'Purchase Invoice';
                Image = Invoice;
                Promoted = true;
                PromotedCategory = New;
                RunObject = Page "Purchase Invoice";
                RunPageLink = "Buy-from Vendor No." = field("No.");
                RunPageMode = Create;
                ToolTip = 'Executes the Purchase Invoice action.';
            }
            action(PurchaseOrder)
            {
                ApplicationArea = Basic;
                Caption = 'Purchase Order';
                Image = Document;
                Promoted = true;
                PromotedCategory = New;
                RunObject = Page "Purchase Order";
                RunPageLink = "Buy-from Vendor No." = field("No.");
                RunPageMode = Create;
                ToolTip = 'Executes the Purchase Order action.';
            }
            action(PurchaseCreditMemo)
            {
                ApplicationArea = Basic;
                Caption = 'Purchase Credit Memo';
                Image = CreditMemo;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = New;
                RunObject = Page "Purchase Credit Memo";
                RunPageLink = "Buy-from Vendor No." = field("No.");
                RunPageMode = Create;
                ToolTip = 'Executes the Purchase Credit Memo action.';
            }
            action(PurchaseReturnOrder)
            {
                ApplicationArea = Basic;
                Caption = 'Purchase Return Order';
                Image = ReturnOrder;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = New;
                RunObject = Page "Purchase Return Order";
                RunPageLink = "Buy-from Vendor No." = field("No.");
                RunPageMode = Create;
                ToolTip = 'Executes the Purchase Return Order action.';
            }
        }
        area(processing)
        {
            action(PaymentJournal)
            {
                ApplicationArea = Basic;
                Caption = 'Payment Journal';
                Image = PaymentJournal;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Payment Journal";
                ToolTip = 'Executes the Payment Journal action.';
            }
            action(PurchaseJournal)
            {
                ApplicationArea = Basic;
                Caption = 'Purchase Journal';
                Image = Journals;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Purchase Journal";
                ToolTip = 'Executes the Purchase Journal action.';
            }
        }
        area(reporting)
        {
            group(General)
            {
                Caption = 'General';
                action(VendorList)
                {
                    ApplicationArea = Basic;
                    Caption = 'Vendor - List';
                    Image = "Report";
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = "Report";
                    RunObject = Report "Vendor - List";
                    ToolTip = 'Executes the Vendor - List action.';
                }
                action(VendorRegister)
                {
                    ApplicationArea = Basic;
                    Caption = 'Vendor Register';
                    Image = "Report";
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = "Report";
                    RunObject = Report "Vendor Register";
                    ToolTip = 'Executes the Vendor Register action.';
                }
                action(VendorItemCatalog)
                {
                    ApplicationArea = Basic;
                    Caption = 'Vendor Item Catalog';
                    Image = "Report";
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = "Report";
                    RunObject = Report "Vendor Item Catalog";
                    ToolTip = 'Executes the Vendor Item Catalog action.';
                }
                action(VendorLabels)
                {
                    ApplicationArea = Basic;
                    Caption = 'Vendor - Labels';
                    Image = "Report";
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = "Report";
                    RunObject = Report "Vendor - Labels";
                    ToolTip = 'Executes the Vendor - Labels action.';
                }
                action(VendorTop10List)
                {
                    ApplicationArea = Basic;
                    Caption = 'Vendor - Top 10 List';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    RunObject = Report "Vendor - Top 10 List";
                    ToolTip = 'Executes the Vendor - Top 10 List action.';
                }
            }
            group(ActionGroup5)
            {
                Caption = 'Orders';
                Image = "Report";
                action(VendorOrderSummary)
                {
                    ApplicationArea = Basic;
                    Caption = 'Vendor - Order Summary';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    RunObject = Report "Vendor - Order Summary";
                    ToolTip = 'Executes the Vendor - Order Summary action.';
                }
                action(VendorOrderDetail)
                {
                    ApplicationArea = Basic;
                    Caption = 'Vendor - Order Detail';
                    Image = "Report";
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = "Report";
                    RunObject = Report "Vendor - Order Detail";
                    ToolTip = 'Executes the Vendor - Order Detail action.';
                }
            }
            group(Purchase)
            {
                Caption = 'Purchase';
                Image = Purchase;
                action(VendorPurchaseList)
                {
                    ApplicationArea = Basic;
                    Caption = 'Vendor - Purchase List';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    RunObject = Report "Vendor - Purchase List";
                    ToolTip = 'Executes the Vendor - Purchase List action.';
                }
                action(VendorItemPurchases)
                {
                    ApplicationArea = Basic;
                    Caption = 'Vendor/Item Purchases';
                    Image = "Report";
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = "Report";
                    RunObject = Report "Vendor/Item Purchases";
                    ToolTip = 'Executes the Vendor/Item Purchases action.';
                }
                action(PurchaseStatistics)
                {
                    ApplicationArea = Basic;
                    Caption = 'Purchase Statistics';
                    Image = "Report";
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = "Report";
                    RunObject = Report "Purchase Statistics";
                    ToolTip = 'Executes the Purchase Statistics action.';
                }
            }
            group(FinancialManagement)
            {
                Caption = 'Financial Management';
                Image = "Report";
                action(PaymentsonHold)
                {
                    ApplicationArea = Basic;
                    Caption = 'Payments on Hold';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    RunObject = Report "Payments on Hold";
                    ToolTip = 'Executes the Payments on Hold action.';
                }
                action(VendorSummaryAging)
                {
                    ApplicationArea = Basic;
                    Caption = 'Vendor - Summary Aging';
                    Image = "Report";
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = "Report";
                    RunObject = Report "Vendor - Summary Aging";
                    ToolTip = 'Executes the Vendor - Summary Aging action.';
                }
                action(AgedAccountsPayable)
                {
                    ApplicationArea = Basic;
                    Caption = 'Aged Accounts Payable';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    RunObject = Report "Aged Accounts Payable";
                    ToolTip = 'Executes the Aged Accounts Payable action.';
                }
                action(VendorBalancetoDate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Vendor - Balance to Date';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    RunObject = Report "Vendor - Balance to Date";
                    ToolTip = 'Executes the Vendor - Balance to Date action.';
                }
                action(VendorTrialBalance)
                {
                    ApplicationArea = Basic;
                    Caption = 'Vendor - Trial Balance';
                    Image = "Report";
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = "Report";
                    RunObject = Report "Vendor - Trial Balance";
                    ToolTip = 'Executes the Vendor - Trial Balance action.';
                }
                action(VendorDetailTrialBalance)
                {
                    ApplicationArea = Basic;
                    Caption = 'Vendor - Detail Trial Balance';
                    Image = "Report";
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = "Report";
                    RunObject = Report "Vendor - Detail Trial Balance";
                    ToolTip = 'Executes the Vendor - Detail Trial Balance action.';
                }
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."Vendor Type" := Rec."vendor type"::"Implementing Partner";
    end;

    procedure GetSelectionFilter(): Text
    var
        Vend: Record Vendor;
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
    begin
        CurrPage.SetSelectionFilter(Vend);
        exit(SelectionFilterManagement.GetSelectionFilterForVendor(Vend));
    end;

    procedure SetSelection(var Vend: Record Vendor)
    begin
        CurrPage.SetSelectionFilter(Vend);
    end;
}

