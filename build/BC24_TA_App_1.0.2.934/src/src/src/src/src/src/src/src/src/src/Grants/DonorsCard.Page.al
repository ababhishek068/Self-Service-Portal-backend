Page 50046 "Donors Card"
{
    Caption = 'Donors Card';
    DeleteAllowed = false;
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = Customer;
    SourceTableView = where("Account Type" = filter(Donor));
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
                field(AccountType; Rec."Account Type")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Account Type field.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the customer''s name. This name will appear on all sales documents for the customer.';
                }
                field(Name2; Rec."Name 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies an additional part of the name.';
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the customer''s address. This address will appear on all sales documents for the customer.';
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
                field(City; Rec.City)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the customer''s city.';
                }
                field(CountryRegionCode; Rec."Country/Region Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the country/region of the address.';
                }
                field(PhoneNo; Rec."Phone No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the customer''s telephone number.';
                }
                field(Control16; Rec.Contact)
                {
                    ApplicationArea = Basic;
                    Editable = ContactEditable;
                    Importance = Promoted;
                    ToolTip = 'Specifies the name of the person you regularly contact when you do business with this customer.';

                    trigger OnValidate()
                    begin
                        ContactOnAfterValidate;
                    end;
                }
                field(SearchName; Rec."Search Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies an alternate name that you can use to search for the record in question when you cannot remember the value in the Name field.';
                }
                field(BalanceLCY; Rec."Balance (LCY)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the payment amount that the customer owes for completed sales. This value is also known as the customer''s balance.';

                    trigger OnDrillDown()
                    var
                        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
                        CustLedgEntry: Record "Cust. Ledger Entry";
                    begin
                        DtldCustLedgEntry.SetRange("Customer No.", Rec."No.");
                        Rec.Copyfilter("Global Dimension 1 Filter", DtldCustLedgEntry."Initial Entry Global Dim. 1");
                        Rec.Copyfilter("Global Dimension 2 Filter", DtldCustLedgEntry."Initial Entry Global Dim. 2");
                        Rec.Copyfilter("Currency Filter", DtldCustLedgEntry."Currency Code");
                        CustLedgEntry.DrillDownOnEntries(DtldCustLedgEntry);
                    end;
                }
                field(CreditLimitLCY; Rec."Credit Limit (LCY)")
                {
                    ApplicationArea = Basic;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the maximum amount you allow the customer to exceed the payment balance before warnings are issued.';

                    trigger OnValidate()
                    begin
                        StyleTxt := Rec.SetStyle;
                    end;
                }
                field(DonorCategory; Rec."Donor Category")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Donor Category field.';
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that the related record is blocked from being posted in transactions, for example a customer that is declared insolvent or an item that is placed in quarantine.';
                }
                field(LastDateModified; Rec."Last Date Modified")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies when the customer card was last modified.';
                }
                field("Phone No.2"; Rec."Phone No.")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the customer''s telephone number.';
                }
                field(FaxNo; Rec."Fax No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the customer''s fax number.';
                }
                field(EMail; Rec."E-Mail")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the customer''s email address.';
                }
                field(HomePage; Rec."Home Page")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the customer''s home page address.';
                }
                field(CopySelltoAddrtoQteFrom; Rec."Copy Sell-to Addr. to Qte From")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies which customer address is inserted on sales quotes that you create for the customer.';
                }
                field(GenBusPostingGroup; Rec."Gen. Bus. Posting Group")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the customer''s trade type to link transactions made for this customer with the appropriate general ledger account according to the general posting setup.';
                }
                field(VATBusPostingGroup; Rec."VAT Bus. Posting Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the VAT specification of the involved customer or vendor to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.';
                }
                field(DonorPostingGroup; Rec."Customer Posting Group")
                {
                    ApplicationArea = Basic;
                    Caption = 'Donor Posting Group';
                    Importance = Promoted;
                    ToolTip = 'Specifies the customer''s market type to link business transactions to.';
                }
                field(AllowIndirectCost; Rec."Allow Indirect Cost")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Allow Indirect Cost field.';
                }
                field(PricesIncludingVAT; Rec."Prices Including VAT")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if the Unit Price and Line Amount fields on document lines should be shown with or without VAT.';
                }
                field(CurrencyCode; Rec."Currency Code")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the default currency for the customer.';
                }
                field(VATRegistrationNo; Rec."VAT Registration No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the customer''s VAT registration number for customers in EU countries/regions.';
                }
            }
        }
        area(factboxes)
        {
            part(Control1907234507; "Sales Hist. Bill-to FactBox")
            {
                Caption = 'Donor Hist. Bill-to FactBox>';
                SubPageLink = "No." = field("No."),
                              "Currency Filter" = field("Currency Filter"),
                              "Date Filter" = field("Date Filter"),
                              "Global Dimension 1 Filter" = field("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter" = field("Global Dimension 2 Filter");
                Visible = false;
            }
            part(Control1902018507; "Customer Statistics FactBox")
            {
                Caption = 'Donor Statistics FactBox>';
                SubPageLink = "No." = field("No."),
                              "Currency Filter" = field("Currency Filter"),
                              "Date Filter" = field("Date Filter"),
                              "Global Dimension 1 Filter" = field("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter" = field("Global Dimension 2 Filter");
                Visible = true;
            }
            part(Control1905532107; "Dimensions FactBox")
            {
                SubPageLink = "Table ID" = const(18),
                              "No." = field("No.");
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
            group(Customer)
            {
                Caption = '&Customer';
                Image = Customer;
                action(Dimensions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID" = const(18),
                                  "No." = field("No.");
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'Executes the Dimensions action.';
                }
                action(BankAccounts)
                {
                    ApplicationArea = Basic;
                    Caption = 'Bank Accounts';
                    Image = BankAccount;
                    RunObject = Page "Customer Bank Account List";
                    RunPageLink = "Customer No." = field("No.");
                    ToolTip = 'Executes the Bank Accounts action.';
                }
                action(DirectDebitMandates)
                {
                    ApplicationArea = Basic;
                    Caption = 'Direct Debit Mandates';
                    Image = MakeAgreement;
                    RunObject = Page "SEPA Direct Debit Mandates";
                    RunPageLink = "Customer No." = field("No.");
                    ToolTip = 'Executes the Direct Debit Mandates action.';
                }
                action(ShiptoAddresses)
                {
                    ApplicationArea = Basic;
                    Caption = 'Ship-&to Addresses';
                    Image = ShipAddress;
                    RunObject = Page "Ship-to Address List";
                    RunPageLink = "Customer No." = field("No.");
                    ToolTip = 'Executes the Ship-&to Addresses action.';
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
                action(DonorContacts)
                {
                    ApplicationArea = Basic;
                    Caption = 'Donor Contacts';
                    Image = ContactReference;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Category4;
                    RunObject = Page "Donor Contacts List";
                    RunPageLink = "Donor Code" = field("No.");
                    ToolTip = 'Executes the Donor Contacts action.';
                }
                action(CrossReferences)
                {
                    ApplicationArea = Basic;
                    Caption = 'Cross Re&ferences';
                    Image = Change;
                    ToolTip = 'Executes the Cross Re&ferences action.';
                    //RunObject = Page "Cross References";
                    // RunPageLink = "Item Reference Type" = const(Customer),
                    //               "Item Reference Type No." = field("No.");
                    // RunPageView = sorting("Item Reference Type", "Item Reference Type No.");
                }
                action(Comments)
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name" = const(Customer),
                                  "No." = field("No.");
                    ToolTip = 'Executes the Co&mments action.';
                }
                action(OnlineMap)
                {
                    ApplicationArea = Basic;
                    Caption = 'Online Map';
                    Image = Map;
                    ToolTip = 'Executes the Online Map action.';

                    trigger OnAction()
                    begin
                        Rec.DisplayMap;
                    end;
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
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Customer Ledger Entries";
                    RunPageLink = "Customer No." = field("No.");
                    RunPageView = sorting("Customer No.");
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
                    RunObject = Page "Customer Statistics";
                    RunPageLink = "No." = field("No."),
                                  "Date Filter" = field("Date Filter"),
                                  "Global Dimension 1 Filter" = field("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter" = field("Global Dimension 2 Filter");
                    ShortCutKey = 'F7';
                    ToolTip = 'Executes the Statistics action.';
                }
                action(Sales)
                {
                    ApplicationArea = Basic;
                    Caption = 'S&ales';
                    Image = Sales;
                    RunObject = Page "Customer Sales";
                    RunPageLink = "No." = field("No."),
                                  "Global Dimension 1 Filter" = field("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter" = field("Global Dimension 2 Filter");
                    ToolTip = 'Executes the S&ales action.';
                }
                action(EntryStatistics)
                {
                    ApplicationArea = Basic;
                    Caption = 'Entry Statistics';
                    Image = EntryStatistics;
                    RunObject = Page "Customer Entry Statistics";
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
                    RunObject = Page "Cust. Stats. by Curr. Lines";
                    RunPageLink = "Customer Filter" = field("No."),
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
                        //ItemTrackingMgt.CallItemTrackingEntryForm(1,"No.",'','','','','');
                    end;
                }
                separator(Action140) { }
            }
            group(ActionGroup82)
            {
                Caption = 'S&ales';
                Image = Sales;
                action(InvoiceDiscounts)
                {
                    ApplicationArea = Basic;
                    Caption = 'Invoice &Discounts';
                    Image = CalculateInvoiceDiscount;
                    RunObject = Page "Cust. Invoice Discounts";
                    RunPageLink = Code = field("Invoice Disc. Code");
                    ToolTip = 'Executes the Invoice &Discounts action.';
                }
                action(Prices)
                {
                    ApplicationArea = Basic;
                    Caption = 'Prices';
                    Image = Price;
                    RunObject = Page "Sales Prices";
                    RunPageLink = "Sales Type" = const(Customer),
                                  "Sales Code" = field("No.");
                    RunPageView = sorting("Sales Type", "Sales Code");
                    ToolTip = 'Executes the Prices action.';
                }
                action(LineDiscounts)
                {
                    ApplicationArea = Basic;
                    Caption = 'Line Discounts';
                    Image = LineDiscount;
                    RunObject = Page "Sales Line Discounts";
                    RunPageLink = "Sales Type" = const(Customer),
                                  "Sales Code" = field("No.");
                    RunPageView = sorting("Sales Type", "Sales Code");
                    ToolTip = 'Executes the Line Discounts action.';
                }
                action(PrepaymentPercentages)
                {
                    ApplicationArea = Basic;
                    Caption = 'Prepa&yment Percentages';
                    Image = PrepaymentPercentages;
                    RunObject = Page "Sales Prepayment Percentages";
                    RunPageLink = "Sales Type" = const(Customer),
                                  "Sales Code" = field("No.");
                    RunPageView = sorting("Sales Type", "Sales Code");
                    ToolTip = 'Executes the Prepa&yment Percentages action.';
                }
                action(StdCustSalesCodes)
                {
                    ApplicationArea = Basic;
                    Caption = 'S&td. Cust. Sales Codes';
                    Image = CodesList;
                    RunObject = Page "Standard Customer Sales Codes";
                    RunPageLink = "Customer No." = field("No.");
                    ToolTip = 'Executes the S&td. Cust. Sales Codes action.';
                }
            }
            group(Documents)
            {
                Caption = 'Documents';
                Image = Documents;
                action(Quotes)
                {
                    ApplicationArea = Basic;
                    Caption = 'Quotes';
                    Image = Quote;
                    RunObject = Page "Sales Quotes";
                    RunPageLink = "Sell-to Customer No." = field("No.");
                    RunPageView = sorting("Document Type", "Sell-to Customer No.");
                    ToolTip = 'Executes the Quotes action.';
                }
                action(Orders)
                {
                    ApplicationArea = Basic;
                    Caption = 'Orders';
                    Image = Document;
                    RunObject = Page "Sales Order List";
                    RunPageLink = "Sell-to Customer No." = field("No.");
                    RunPageView = sorting("Document Type", "Sell-to Customer No.");
                    ToolTip = 'Executes the Orders action.';
                }
                action(ReturnOrders)
                {
                    ApplicationArea = Basic;
                    Caption = 'Return Orders';
                    Image = ReturnOrder;
                    RunObject = Page "Sales Return Order List";
                    RunPageLink = "Sell-to Customer No." = field("No.");
                    RunPageView = sorting("Document Type", "Sell-to Customer No.");
                    ToolTip = 'Executes the Return Orders action.';
                }
                group(IssuedDocuments)
                {
                    Caption = 'Issued Documents';
                    Image = Documents;
                    action(IssuedReminders)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Issued &Reminders';
                        Image = OrderReminder;
                        RunObject = Page "Issued Reminder List";
                        RunPageLink = "Customer No." = field("No.");
                        RunPageView = sorting("Customer No.", "Posting Date");
                        ToolTip = 'Executes the Issued &Reminders action.';
                    }
                    action(IssuedFinanceChargeMemos)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Issued &Finance Charge Memos';
                        Image = FinChargeMemo;
                        RunObject = Page "Issued Fin. Charge Memo List";
                        RunPageLink = "Customer No." = field("No.");
                        RunPageView = sorting("Customer No.", "Posting Date");
                        ToolTip = 'Executes the Issued &Finance Charge Memos action.';
                    }
                }
                action(BlanketOrders)
                {
                    ApplicationArea = Basic;
                    Caption = 'Blanket Orders';
                    Image = BlanketOrder;
                    RunObject = Page "Blanket Sales Orders";
                    RunPageLink = "Sell-to Customer No." = field("No.");
                    RunPageView = sorting("Document Type", "Sell-to Customer No.");
                    ToolTip = 'Executes the Blanket Orders action.';
                }
                action(Jobs)
                {
                    ApplicationArea = Basic;
                    Caption = '&Jobs';
                    Image = Job;
                    RunObject = Page "Job List";
                    RunPageLink = "Bill-to Customer No." = field("No.");
                    RunPageView = sorting("Bill-to Customer No.");
                    ToolTip = 'Executes the &Jobs action.';
                }
            }
            group(CreditCard)
            {
                Caption = 'Credit Card';
                Image = CreditCard;
                group(CreditCards)
                {
                    Caption = 'Credit Cards';
                    Image = CreditCard;
                }
            }
            group(Service)
            {
                Caption = 'Service';
                Image = ServiceItem;
                action(ServiceOrders)
                {
                    ApplicationArea = Basic;
                    Caption = 'Service Orders';
                    Image = Document;
                    RunObject = Page "Service Orders";
                    RunPageLink = "Customer No." = field("No.");
                    RunPageView = sorting("Document Type", "Customer No.");
                    ToolTip = 'Executes the Service Orders action.';
                }
                action(ServiceContracts)
                {
                    ApplicationArea = Basic;
                    Caption = 'Ser&vice Contracts';
                    Image = ServiceAgreement;
                    RunObject = Page "Customer Service Contracts";
                    RunPageLink = "Customer No." = field("No.");
                    RunPageView = sorting("Customer No.", "Ship-to Code");
                    ToolTip = 'Executes the Ser&vice Contracts action.';
                }
                action(ServiceItems)
                {
                    ApplicationArea = Basic;
                    Caption = 'Service &Items';
                    Image = ServiceItem;
                    RunObject = Page "Service Items";
                    RunPageLink = "Customer No." = field("No.");
                    RunPageView = sorting("Customer No.", "Ship-to Code", "Item No.", "Serial No.");
                    ToolTip = 'Executes the Service &Items action.';
                }
            }
        }
        area(creation)
        {
            action(BlanketSalesOrder)
            {
                ApplicationArea = Basic;
                Caption = 'Blanket Sales Order';
                Image = BlanketOrder;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = New;
                RunObject = Page "Blanket Sales Order";
                RunPageLink = "Sell-to Customer No." = field("No.");
                RunPageMode = Create;
                ToolTip = 'Executes the Blanket Sales Order action.';
            }
            action(SalesQuote)
            {
                ApplicationArea = Basic;
                Caption = 'Sales Quote';
                Image = Quote;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = New;
                RunObject = Page "Sales Quote";
                RunPageLink = "Sell-to Customer No." = field("No.");
                RunPageMode = Create;
                ToolTip = 'Executes the Sales Quote action.';
            }
            action(SalesInvoice)
            {
                ApplicationArea = Basic;
                Caption = 'Sales Invoice';
                Image = Invoice;
                Promoted = true;
                PromotedCategory = New;
                RunObject = Page "Sales Invoice";
                RunPageLink = "Sell-to Customer No." = field("No.");
                RunPageMode = Create;
                ToolTip = 'Executes the Sales Invoice action.';
            }
            action(SalesOrder)
            {
                ApplicationArea = Basic;
                Caption = 'Sales Order';
                Image = Document;
                Promoted = true;
                PromotedCategory = New;
                RunObject = Page "Sales Order";
                RunPageLink = "Sell-to Customer No." = field("No.");
                RunPageMode = Create;
                ToolTip = 'Executes the Sales Order action.';
            }
            action(SalesCreditMemo)
            {
                ApplicationArea = Basic;
                Caption = 'Sales Credit Memo';
                Image = CreditMemo;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = New;
                RunObject = Page "Sales Credit Memo";
                RunPageLink = "Sell-to Customer No." = field("No.");
                RunPageMode = Create;
                ToolTip = 'Executes the Sales Credit Memo action.';
            }
            action(SalesReturnOrder)
            {
                ApplicationArea = Basic;
                Caption = 'Sales Return Order';
                Image = ReturnOrder;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = New;
                RunObject = Page "Sales Return Order";
                RunPageLink = "Sell-to Customer No." = field("No.");
                RunPageMode = Create;
                ToolTip = 'Executes the Sales Return Order action.';
            }
            action(ServiceQuote)
            {
                ApplicationArea = Basic;
                Caption = 'Service Quote';
                Image = Quote;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = New;
                RunObject = Page "Service Quote";
                RunPageLink = "Customer No." = field("No.");
                RunPageMode = Create;
                ToolTip = 'Executes the Service Quote action.';
            }
            action(ServiceInvoice)
            {
                ApplicationArea = Basic;
                Caption = 'Service Invoice';
                Image = Invoice;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = New;
                RunObject = Page "Service Invoice";
                RunPageLink = "Customer No." = field("No.");
                RunPageMode = Create;
                ToolTip = 'Executes the Service Invoice action.';
            }
            action(ServiceOrder)
            {
                ApplicationArea = Basic;
                Caption = 'Service Order';
                Image = Document;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = New;
                RunObject = Page "Service Order";
                RunPageLink = "Customer No." = field("No.");
                RunPageMode = Create;
                ToolTip = 'Executes the Service Order action.';
            }
            action(ServiceCreditMemo)
            {
                ApplicationArea = Basic;
                Caption = 'Service Credit Memo';
                Image = CreditMemo;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = New;
                RunObject = Page "Service Credit Memo";
                RunPageLink = "Customer No." = field("No.");
                RunPageMode = Create;
                ToolTip = 'Executes the Service Credit Memo action.';
            }
            action(Reminder)
            {
                ApplicationArea = Basic;
                Caption = 'Reminder';
                Image = Reminder;
                Promoted = true;
                PromotedCategory = New;
                RunObject = Page Reminder;
                RunPageLink = "Customer No." = field("No.");
                RunPageMode = Create;
                ToolTip = 'Executes the Reminder action.';
            }
            action(FinanceChargeMemo)
            {
                ApplicationArea = Basic;
                Caption = 'Finance Charge Memo';
                Image = FinChargeMemo;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = New;
                RunObject = Page "Finance Charge Memo";
                RunPageLink = "Customer No." = field("No.");
                RunPageMode = Create;
                ToolTip = 'Executes the Finance Charge Memo action.';
            }
        }
        area(processing)
        {
            group(Functions)
            {
                Caption = 'F&unctions';
                Image = "Action";
                action(ApplyTemplate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Apply Template';
                    Ellipsis = true;
                    Image = ApplyTemplate;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Executes the Apply Template action.';

                    trigger OnAction()
                    var
                        ConfigTemplateMgt: Codeunit "Config. Template Management";
                        RecRef: RecordRef;
                    begin
                        RecRef.GetTable(Rec);
                        ConfigTemplateMgt.UpdateFromTemplateSelection(RecRef);
                    end;
                }
            }
            action(CashReceiptJournal)
            {
                ApplicationArea = Basic;
                Caption = 'Cash Receipt Journal';
                Image = CashReceiptJournal;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Cash Receipt Journal";
                ToolTip = 'Executes the Cash Receipt Journal action.';
            }
            action(SalesJournal)
            {
                ApplicationArea = Basic;
                Caption = 'Sales Journal';
                Image = Journals;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Sales Journal";
                ToolTip = 'Executes the Sales Journal action.';
            }
        }
        area(reporting)
        {
            action(CustomerDetailedAging)
            {
                ApplicationArea = Basic;
                Caption = 'Customer Detailed Aging';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Customer Detailed Aging";
                ToolTip = 'Executes the Customer Detailed Aging action.';
            }
            action(CustomerLabels)
            {
                ApplicationArea = Basic;
                Caption = 'Customer - Labels';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Customer - Labels";
                ToolTip = 'Executes the Customer - Labels action.';
            }
            action(CustomerBalancetoDate)
            {
                ApplicationArea = Basic;
                Caption = 'Customer - Balance to Date';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Customer - Balance to Date";
                ToolTip = 'Executes the Customer - Balance to Date action.';
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        ActivateFields;
        StyleTxt := Rec.SetStyle;
    end;

    trigger OnAfterGetRecord()
    begin
        ActivateFields;
        StyleTxt := Rec.SetStyle;
    end;

    trigger OnInit()
    begin
        ContactEditable := true;
        MapPointVisible := true;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."Account Type" := Rec."account type"::Donor;
    end;

    trigger OnOpenPage()
    var
        MapMgt: Codeunit "Online Map Management";
    begin
        ActivateFields;
        if not MapMgt.TestSetup then
            MapPointVisible := false;
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin

        if Rec."Customer Posting Group" = '' then Error('Error Donor group is not specified');
        if Rec."VAT Bus. Posting Group" = '' then Error('Error VAT group is not specified');
        if Rec."Gen. Bus. Posting Group" = '' then Error('Error General posting group is not specified');
    end;

    var
        StyleTxt: Text;
        [InDataSet]
        MapPointVisible: Boolean;
        [InDataSet]
        ContactEditable: Boolean;

    procedure ActivateFields()
    begin
        ContactEditable := Rec."Primary Contact No." = '';
    end;

    local procedure ContactOnAfterValidate()
    begin
        ActivateFields;
    end;
}

