page 50864 "Funds Management Role Center"
{
    Caption = 'Role Center- Funds Management';
    PageType = RoleCenter;
    ApplicationArea = All;

    layout
    {
        area(rolecenter)
        {
            group(Control1900724808)
            {
                ShowCaption = false;
                part(Control60; "Headline RC General Mgt.")
                {
                    ApplicationArea = RelationshipMgmt;
                }
                part("My Approval Entries"; "Requests to Approve")
                {
                    ApplicationArea = basic;
                    Caption = 'My Approval Entries';
                }

                part(Control1902304208; "Funds Management Activities")
                {
                    ApplicationArea = all;
                }
                /* part(Control99; "Finance Performance")
                {
                    ApplicationArea = all;
                    // Visible = false;
                }
                systempart(Control1901420308; Outlook)
                {
                } */
            }
            /* group(Control1900724708)
            {
                ShowCaption = false;

                part("My Approval Entries"; "Requests to Approve")
                {
                    ApplicationArea = basic;
                    Caption = 'My Approval Entries';
                }
                part(Control106; "My Job Queue")
                {
                    Visible = false;
                }
            } */
        }
    }

    actions
    {
        area(reporting)
        {
            group(Reports)
            {
                Caption = 'Reports';

                action("ImprestRegister")
                {
                    Caption = 'Imprest Register';
                    Image = "Report";
                    RunObject = Report "Imprest Register";
                    ApplicationArea = all;
                    ToolTip = 'Executes the Imprest Register action.';
                }

                action("ReceiptsRep")
                {
                    Caption = 'Receipts Report';
                    Image = "Report";
                    RunObject = Report "Receipts Details";
                    ApplicationArea = all;
                    ToolTip = 'Executes the Receipts Report action.';
                }
                action("&G/L Trial Balance")
                {
                    Caption = '&G/L Trial Balance';
                    Image = "Report";
                    RunObject = Report "Trial Balance";
                    ApplicationArea = all;
                    ToolTip = 'Executes the &G/L Trial Balance action.';
                }
                action("&G/L Trial Balance2")
                {
                    Caption = 'Summary Trial Balance';
                    Image = "Report";
                    RunObject = Report "Trial BalanceX";
                    ApplicationArea = all;
                    ToolTip = 'Executes the Summary Trial Balance action.';
                }

                action("&Bank Detail Trial Balance")
                {
                    Caption = '&Bank Detail Trial Balance';
                    Image = "Report";
                    RunObject = Report "Bank Acc. - Detail Trial Bal.";
                    ApplicationArea = all;
                    ToolTip = 'Executes the &Bank Detail Trial Balance action.';
                }
                action("Vote Book Balance")
                {
                    Caption = 'Vote Book Balance';
                    RunObject = Report "Vote Book Balance - Detail";
                    ApplicationArea = all;
                    ToolTip = 'Executes the Vote Book Balance action.';
                }
                action("&Account Schedule")
                {
                    Caption = '&Account Schedule';
                    Image = "Report";
                    RunObject = Report "Account Schedule";
                    ApplicationArea = all;
                    ToolTip = 'Executes the &Account Schedule action.';
                }
                action("Bu&dget")
                {
                    Caption = 'Bu&dget';
                    Image = "Report";
                    RunObject = Report Budget;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Bu&dget action.';
                }
                action("Trial Bala&nce/Budget")
                {
                    Caption = 'Trial Bala&nce/Budget';
                    Image = "Report";
                    RunObject = Report "Trial Balance/Budget";
                    ApplicationArea = all;
                    ToolTip = 'Executes the Trial Bala&nce/Budget action.';
                }
                action("Trial Balance by &Period")
                {
                    Caption = 'Trial Balance by &Period';
                    Image = "Report";
                    RunObject = Report "Trial Balance by Period";
                    ApplicationArea = all;
                    ToolTip = 'Executes the Trial Balance by &Period action.';
                }
                action("&Fiscal Year Balance")
                {
                    Caption = '&Fiscal Year Balance';
                    Image = "Report";
                    RunObject = Report "Fiscal Year Balance";
                    ApplicationArea = all;
                    ToolTip = 'Executes the &Fiscal Year Balance action.';
                }
                action("Balance Comp. - Prev. Y&ear")
                {
                    Caption = 'Balance Comp. - Prev. Y&ear';
                    Image = "Report";
                    RunObject = Report "Balance Comp. - Prev. Year";
                    ApplicationArea = all;
                    ToolTip = 'Executes the Balance Comp. - Prev. Y&ear action.';
                }
                action(Action2)
                {
                    Caption = 'Vote Book Balance - Detail';
                    RunObject = Report "Vote Book Balance - Detail";
                    ApplicationArea = all;
                    ToolTip = 'Executes the Vote Book Balance - Detail action.';
                }
                action(Action12)
                {
                    Caption = 'Commitment Report';
                    RunObject = Report "Commitments Report";
                    ApplicationArea = all;
                    ToolTip = 'Executes the Commitment Report action.';
                }
                action("&Closing Trial Balance")
                {
                    Caption = '&Closing Trial Balance';
                    Image = "Report";
                    RunObject = Report "Closing Trial Balance";
                    ApplicationArea = all;
                    ToolTip = 'Executes the &Closing Trial Balance action.';
                }
                separator(Separator49) { }
                /* action("Cash Flow Date List")
                {
                    Caption = 'Cash Flow Date List';
                    Image = "Report";
                    RunObject = Report "Cash Flow Date List";
                } */
                separator(Separator115) { }
                action("Aged Accounts &Receivable")
                {
                    Caption = 'Aged Accounts &Receivable';
                    Image = "Report";
                    RunObject = Report "Aged Accounts Receivable";
                    ApplicationArea = all;
                    ToolTip = 'Executes the Aged Accounts &Receivable action.';
                }
                action("Aged Accounts Pa&yable")
                {
                    Caption = 'Aged Accounts Pa&yable';
                    Image = "Report";
                    RunObject = Report "Aged Accounts Payable";
                    ApplicationArea = all;
                    ToolTip = 'Executes the Aged Accounts Pa&yable action.';
                }
                action("Reconcile Cus&t. and Vend. Accs")
                {
                    Caption = 'Reconcile Cus&t. and Vend. Accs';
                    Image = "Report";
                    RunObject = Report "Reconcile Cust. and Vend. Accs";
                    ToolTip = 'Executes the Reconcile Cus&t. and Vend. Accs action.';
                }
                separator(Separator53) { }
                action("&Shipment Qty Variance")
                {
                    Caption = '&Shipment Qty Variance';
                    Image = "Report";
                    RunObject = Report "Sales Shipment Variance";
                    ToolTip = 'Executes the &Shipment Qty Variance action.';
                }
                action("VAT E&xceptions")
                {
                    Caption = 'VAT E&xceptions';
                    Image = "Report";
                    RunObject = Report "VAT Exceptions";
                    ToolTip = 'Executes the VAT E&xceptions action.';
                }
                action("VAT &Statement")
                {
                    Caption = 'VAT &Statement';
                    Image = "Report";
                    RunObject = Report "VAT Statement";
                    ToolTip = 'Executes the VAT &Statement action.';
                }
                /* action("VAT - VIES Declaration Tax Aut&h")
                {
                    Caption = 'VAT - VIES Declaration Tax Aut&h';
                    Image = "Report";
                    RunObject = Report "VAT- VIES Declaration Tax Auth";
                }
                action("VAT - VIES Declaration Dis&k")
                {
                    Caption = 'VAT - VIES Declaration Dis&k';
                    Image = "Report";
                    RunObject = Report "VAT- VIES Declaration Disk";
                }
                action("EC Sales &List")
                {
                    Caption = 'EC Sales &List';
                    Image = "Report";
                    RunObject = Report "EC Sales List";
                } */
                /* separator(Separator60)
                {
                }
                action("&Intrastat - Checklist")
                {
                    Caption = '&Intrastat - Checklist';
                    Image = "Report";
                    RunObject = Report "Intrastat - Checklist";
                }
                action("Intrastat - For&m")
                {
                    Caption = 'Intrastat - For&m';
                    Image = "Report";
                    RunObject = Report "Intrastat - Form";
                }
                separator(Separator4)
                {
                }
                action("Cost Accounting P/L Statement")
                {
                    Caption = 'Cost Accounting P/L Statement';
                    Image = "Report";
                    RunObject = Report "Cost Acctg. Statement";
                }
                action("CA P/L Statement per Period")
                {
                    Caption = 'CA P/L Statement per Period';
                    Image = "Report";
                    RunObject = Report "Cost Acctg. Stmt. per Period";
                }
                action("CA P/L Statement with Budget")
                {
                    Caption = 'CA P/L Statement with Budget';
                    Image = "Report";
                    RunObject = Report "Cost Acctg. Statement/Budget";
                }
                action("Cost Accounting Analysis")
                {
                    Caption = 'Cost Accounting Analysis';
                    Image = "Report";
                    RunObject = Report "Cost Acctg. Analysis";
                } */
                action(PurchaseByItem)
                {
                    Caption = 'Purchase By Item Report';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "Purchase Per Item";
                    ToolTip = 'Executes the Purchase By Item Report action.';
                }
                action(PurchaseByVendor)
                {
                    Caption = 'Purchase Details Report';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "Purchase Details Report";
                    ToolTip = 'Executes the Purchase Details Report action.';
                }
                action(PurchaseByVendor2)
                {
                    Caption = 'Purchase Details Report2';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "Purchase Per Item";
                    ToolTip = 'Executes the Purchase Details Report2 action.';
                }
                /* action(SalesByItem)
                {
                    Caption = 'Sales By Item Report';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "Sales Per Item Summary";
                }
                action(SalesByCustomer)
                {
                    Caption = 'Sales By Customer Report';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "Sales By Customer Details";
                } */
                action(VendorStatement)
                {
                    Caption = 'Vendor Statement Report';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "vendor statement1";
                    ToolTip = 'Executes the Vendor Statement Report action.';
                }
                /* action(CollectionsReport)
                {
                    Caption = 'Collections Report';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "Receipts Collections2";
                }
                action(ShiftReport)
                {
                    Caption = 'Shift Report';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "Shift Allocation Report";
                }
                action(ShiftSales)
                {
                    Caption = 'Shift Sale Report';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "Staff Sales Report";
                }
                action(StationReport)
                {
                    Caption = 'Station Report';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "Station Summary";
                }
                action(WetStock)
                {
                    Caption = 'Wetstock Report';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "WetStock Report";
                }
                action(Dippings)
                {
                    Caption = 'Dippings Report';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "Dipping Report";
                }
                action(StockTrasfers)
                {
                    Caption = 'Stock Transfers Report';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "Stock Transfers";
                }
                action(Transfers)
                {
                    Caption = 'Stock Receipts Report';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "Stock Receipts";
                } */

                action(CheckRegister)
                {
                    Caption = 'Check Register Report';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "Check Register";
                    ToolTip = 'Executes the Check Register Report action.';
                }
            }
        }
        area(sections)
        {
            group(Journals)
            {
                Caption = 'Journals';
                Image = Journals;

                action("Purchase Journals")
                {
                    Caption = 'Purchase Journals';
                    ApplicationArea = all;
                    RunObject = Page "General Journal Batches";
                    RunPageView = WHERE("Template Type" = CONST(Purchases),
                                        Recurring = CONST(false));
                    ToolTip = 'Executes the Purchase Journals action.';
                }
                /* action("Sales Journals")
                {
                    Caption = 'Sales Journals';
                    RunObject = Page "General Journal Batches";
                    RunPageView = WHERE("Template Type" = CONST(Sales),
                                        Recurring = CONST(false));
                    ApplicationArea = all;
                } */
                action("Cash Receipt Journals")
                {
                    Caption = 'Cash Receipt Journals';
                    ApplicationArea = all;
                    Image = Journals;
                    RunObject = Page "General Journal Batches";
                    RunPageView = WHERE("Template Type" = CONST("Cash Receipts"),
                                        Recurring = CONST(false));
                    ToolTip = 'Executes the Cash Receipt Journals action.';
                }
                action("Payment Journals")
                {
                    Caption = 'Payment Journals';
                    ApplicationArea = all;
                    Image = Journals;
                    RunObject = Page "General Journal Batches";
                    RunPageView = WHERE("Template Type" = CONST(Payments),
                                        Recurring = CONST(false));
                    ToolTip = 'Executes the Payment Journals action.';
                }
                /* ction("IC General Journals")
                {
                    Caption = 'IC General Journals';
                    RunObject = Page "General Journal Batches";
                    RunPageView = WHERE("Template Type" = CONST(Intercompany),
                                        Recurring = CONST(false));
                } */
                action("General Journals")
                {
                    Caption = 'General Journals';
                    ApplicationArea = all;
                    Image = Journal;
                    RunObject = Page "General Journal Batches";
                    RunPageView = WHERE("Template Type" = CONST(General),
                                        Recurring = CONST(false));
                    ToolTip = 'Executes the General Journals action.';
                }
                /* action("Intrastat Journals")
                {
                    Caption = 'Sales Invoice Adjustments';
                    Image = "Report";
                    RunObject = Page "Pending Invoice List";
                } */
            }
            group("Fixed Assets")
            {
                Caption = 'Fixed Assets';
                Image = FixedAssets;

                action(Action17)
                {
                    Caption = 'Fixed Assets';
                    ApplicationArea = all;
                    RunObject = Page "Fixed Asset List";
                    ToolTip = 'Executes the Fixed Assets action.';
                }
                action(Insurance)
                {
                    Caption = 'Insurance';
                    ApplicationArea = all;
                    RunObject = Page "Insurance List";
                    ToolTip = 'Executes the Insurance action.';
                }
                action("Fixed Assets G/L Journals")
                {
                    Caption = 'Fixed Assets G/L Journals';
                    ApplicationArea = all;
                    RunObject = Page "General Journal Batches";
                    RunPageView = WHERE("Template Type" = CONST(Assets),
                                        Recurring = CONST(false));
                    ToolTip = 'Executes the Fixed Assets G/L Journals action.';
                }
                action("Fixed Assets Journals")
                {
                    Caption = 'Fixed Assets Journals';
                    RunObject = Page "FA Journal Batches";
                    RunPageView = WHERE(Recurring = CONST(false));
                    ToolTip = 'Executes the Fixed Assets Journals action.';
                }
                action("Fixed Assets Reclass. Journals")
                {
                    Caption = 'Fixed Assets Reclass. Journals';
                    RunObject = Page "FA Reclass. Journal Batches";
                    ApplicationArea = all;
                    ToolTip = 'Executes the Fixed Assets Reclass. Journals action.';
                }
                action("Insurance Journals")
                {
                    Caption = 'Insurance Journals';
                    RunObject = Page "Insurance Journal Batches";
                    ApplicationArea = all;
                    ToolTip = 'Executes the Insurance Journals action.';
                }
                action("<Action3>")
                {
                    Caption = 'Recurring General Journals';
                    ApplicationArea = all;
                    RunObject = Page "General Journal Batches";
                    RunPageView = WHERE("Template Type" = CONST(General),
                                        Recurring = CONST(true));
                    ToolTip = 'Executes the Recurring General Journals action.';
                }
                /* ction("Recurring Fixed Asset Journals")
                {
                    Caption = 'Recurring Fixed Asset Journals';
                    ApplicationArea = all;
                    RunObject = Page "FA Journal Batches";
                    RunPageView = WHERE(Recurring = CONST(true));
                } */
                action("FA Register")
                {
                    Caption = 'Fixed Assets Register';
                    ApplicationArea = all;
                    RunObject = report "Asset Register";
                    ToolTip = 'Executes the Fixed Assets Register action.';

                }
            }
            /*  group("Sales")


             {
                 action(salesQuote)
                 {
                     Caption = 'Sales Quote';
                     ApplicationArea = all;
                     RunObject = Page "sales quotes";


                 }
                 action(salesOrder)
                 {
                     Caption = 'Sales Order';
                     ApplicationArea = all;
                     RunObject = Page "sales Orders";


                 }
                 action(salesInvoice)
                 {
                     Caption = 'Sales Invoice';
                     ApplicationArea = all;
                     RunObject = Page "Sales Invoice List";


                 }
                 action(salesCrdit)
                 {
                     Caption = 'Sales Credit Memo';
                     ApplicationArea = all;
                     RunObject = Page "sales Credit Memos";


                 }
             } */
            group(Payables)
            {
                action(PurchOrder)
                {
                    Caption = 'Purchase Order';
                    ApplicationArea = all;
                    RunObject = Page "Purchase Order List";
                    ToolTip = 'Executes the Purchase Order action.';

                }
                action(PurchInvoice)
                {
                    Caption = 'Purchase Invoice';
                    ApplicationArea = all;
                    RunObject = Page "Purchase Invoices";
                    ToolTip = 'Executes the Purchase Invoice action.';

                }
                action(PurchCredit)
                {
                    Caption = 'Purchase Credit Memo';
                    ApplicationArea = all;
                    RunObject = Page "Purchase Credit Memos";
                    ToolTip = 'Executes the Purchase Credit Memo action.';

                }
            }

            group(FinanceOperation)

            {
                Caption = 'Finance Operations';
                action("InterBank Transfer")
                {
                    Caption = 'InterBank Transfer';
                    ApplicationArea = all;
                    RunObject = Page "Interbank Transfer";
                    ToolTip = 'Executes the InterBank Transfer action.';
                }
                action("Vote Transfer")
                {
                    Caption = 'Vote Transfer';
                    ApplicationArea = all;
                    RunObject = Page "Vote Transfer List";
                    ToolTip = 'Executes the Vote Transfer action.';
                }
                action("Payment Voucher")
                {
                    Caption = 'Payment Voucher';
                    ApplicationArea = all;
                    Image = VendorPayment;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Payment Vouchers";
                    RunPageMode = Create;
                    ToolTip = 'Executes the Payment Voucher action.';
                }

                action("Payment Requisition")
                {
                    Caption = 'Payment Requisition';
                    ApplicationArea = all;
                    RunObject = page "Payment Requistions";
                    RunPageMode = Create;
                    ToolTip = 'Executes the Payment Requisition action.';
                }


                /*  action("Payment Schedule")


                 {
                     Caption = 'Payment Schedule';
                     ApplicationArea = all;
                     Image = VendorPayment;
                     //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                     //PromotedCategory = Process;
                     RunObject = Page "Payment Schedule List";
                     RunPageMode = Create;
                 } */
                action(Receipts)
                {
                    Caption = 'Receipts';
                    Image = ReceivableBill;
                    ApplicationArea = all;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Receipts List";
                    RunPageMode = Edit;
                    ToolTip = 'Executes the Receipts action.';
                }
                action("Petty Cash Payment")
                {
                    Caption = 'Petty Cash Payment';
                    Image = Payment;
                    Promoted = false;
                    ApplicationArea = all;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Petty Cash";
                    RunPageMode = Create;
                    ToolTip = 'Executes the Petty Cash Payment action.';
                }
                action("OutstandingImp Payment")
                {
                    Caption = 'Outstanding Imprest Payment';
                    Image = Payment;
                    Promoted = false;
                    ApplicationArea = all;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Outstanding Imprest Payments";
                    RunPageMode = Create;
                    ToolTip = 'Executes the Outstanding Imprest Payment action.';
                }
                action("ImprestMemo")
                {
                    Caption = 'Imprest Memo';
                    Image = Travel;
                    Promoted = false;
                    ApplicationArea = all;
                    RunObject = Page "Imprest Memo Lists";
                    RunPageMode = Create;
                    ToolTip = 'Executes the Imprest Memo action.';
                }
                action("Travel Advance")
                {
                    Caption = 'Imprest Requisition';
                    Image = Travel;
                    Promoted = false;
                    ApplicationArea = all;
                    RunObject = Page "Travel Advance Vouchers List";
                    RunPageMode = Create;
                    ToolTip = 'Executes the Imprest Requisition action.';
                }
                action("Petty Cash Request")
                {
                    Caption = 'Petty Cash Requisition';
                    Image = Travel;
                    Promoted = false;
                    ApplicationArea = all;
                    RunObject = Page "Petty Cash Vouchers";
                    RunPageMode = Create;
                    ToolTip = 'Executes the Petty Cash Requisition action.';
                }
                action("Travel Advance Accounting")
                {
                    Caption = 'Imprest Surrender';
                    Image = Reconcile;
                    Promoted = false;
                    ApplicationArea = all;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Travel Advances Acct. List";
                    RunPageMode = Create;
                    ToolTip = 'Executes the Imprest Surrender action.';
                }
                action("OutstandingImprest")
                {
                    Caption = 'Outstanding Imprest Requisition';
                    Image = Travel;
                    Promoted = false;
                    ApplicationArea = all;
                    RunObject = Page "OutStanding imprest Req List";
                    RunPageMode = Create;
                    ToolTip = 'Executes the Outstanding Imprest Requisition action.';
                }
                action("Staff Claims")
                {
                    Caption = 'Staff Claims';
                    Image = InsertTravelFee;
                    Promoted = false;
                    ApplicationArea = all;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Staff Claim List";
                    RunPageMode = Create;
                    RunPageView = WHERE(Status = FILTER(Pending | "Pending Approval" | Approved));
                    ToolTip = 'Executes the Staff Claims action.';
                }
                action("Other Advance Requests")
                {
                    Caption = 'Salary Advance Requests';
                    Image = VendorBill;
                    Promoted = false;
                    ApplicationArea = all;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Staff Advance Request List";
                    RunPageMode = Create;
                    ToolTip = 'Executes the Salary Advance Requests action.';
                }
                action("Salary Advance Accounting")
                {
                    Caption = 'Salary Advance Accounting';
                    Image = Reconcile;
                    Promoted = false;
                    ApplicationArea = all;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Staff Advance Surrender List";
                    RunPageMode = Create;
                    ToolTip = 'Executes the Other Advance Accounting action.';
                }
                action("Sales Invoice")
                {
                    Caption = 'Sales Invoice';
                    Image = SalesInvoice;
                    ApplicationArea = All;
                    RunObject = page "Sales Invoice List";
                    RunPageMode = View;
                    ToolTip = 'Executes the Sales Invoice action.';
                }
                /* action("Item Cash")
                {
                    Caption = 'Item Cash';
                    Image = Reconcile;
                    Promoted = false;
                    ApplicationArea = all;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Item/Cash List";
                    RunPageMode = Create;
                }
                action("Item Cash Surrender")
                {
                    Caption = 'Item Cash Surrender';
                    Image = Reconcile;
                    Promoted = false;
                    ApplicationArea = all;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Item/Cash Accounting";
                    RunPageMode = Create;
                } */
                group("Pending Approval")
                {
                    action("Staff Advance Requisitions")
                    {
                        Caption = 'Staff Advance Requisitions';
                        ApplicationArea = all;
                        Image = Currency;
                        RunObject = Page "Staff Advance-Pending Approval";
                        ToolTip = 'Executes the Purchase Requisitions action.';
                    }
                }
                group("Approved Documents")
                {
                    action("Purchase Requisitions")
                    {
                        Caption = 'Purchase Requisitions';
                        ApplicationArea = all;
                        Image = Currency;
                        RunObject = Page "Purchase Requisition-Approved";
                        ToolTip = 'Executes the Purchase Requisitions action.';
                    }
                    action("Approved InterBank Transfer")
                    {
                        Caption = 'Approved InterBank Transfer';
                        ApplicationArea = all;
                        RunObject = Page "Interbank Transfer";
                        RunPageView = where(Status = filter(Approved), Posted = filter(false));
                        ToolTip = 'Executes the Approved InterBank Transfer action.';
                    }
                    action("Approved Vote Transfer")
                    {
                        Caption = 'Approved Vote Transfer';
                        ApplicationArea = all;
                        RunObject = Page "Vote Transfer List";
                        RunPageView = where(Status = filter(Approved), Posted = filter(false));
                        ToolTip = 'Executes the Approved Vote Transfer action.';
                    }
                    action("Approved Payment Voucher")
                    {
                        Caption = 'Approved Payment Voucher';
                        ApplicationArea = all;
                        Image = VendorPayment;
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = Process;
                        RunObject = Page "Payment Vouchers";
                        RunPageView = where(Status = filter(Approved), Posted = filter(false));
                        RunPageMode = Edit;
                        ToolTip = 'Executes the Approved Payment Voucher action.';
                    }
                    action("Approved Payment Schedule")
                    {
                        Caption = 'Approved Payment Schedule';
                        ApplicationArea = all;
                        Image = VendorPayment;
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = Process;
                        RunObject = Page "Payment Schedule List";
                        RunPageView = where(Status = filter(Approved), Posted = filter(false));
                        RunPageMode = Edit;
                        ToolTip = 'Executes the Approved Payment Schedule action.';
                    }

                    action("Approved Petty Cash Payment")
                    {
                        Caption = 'Approved Petty Cash Payment';
                        Image = Payment;
                        Promoted = false;
                        ApplicationArea = all;
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = Process;
                        RunObject = Page "Petty Cash";
                        RunPageView = where(Status = filter(Approved), Posted = filter(false));
                        RunPageMode = Edit;
                        ToolTip = 'Executes the Approved Petty Cash Payment action.';
                    }
                    action("Approved Travel Advance")
                    {
                        Caption = 'Approved Staff Imprest';
                        Image = Travel;
                        Promoted = false;
                        ApplicationArea = all;
                        RunObject = page "Imprest Lists";
                        RunPageView = where(Status = filter(Approved), Posted = filter(false));
                        RunPageMode = Edit;
                        ToolTip = 'Executes the Approved Staff Imprest action.';
                    }
                    action("Approved Travel Advance Accounting")
                    {
                        Caption = 'Approved Staff Imprest Surrender';
                        Image = Reconcile;
                        Promoted = false;
                        ApplicationArea = all;
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = Process;
                        RunObject = Page "Travel Advances Acct. List";
                        RunPageView = where(Status = filter(Approved), Posted = filter(false));
                        RunPageMode = Edit;
                        ToolTip = 'Executes the Approved Staff Imprest Surrender action.';
                    }
                    action("Approved Staff Claims")
                    {
                        Caption = 'Staff Claims';
                        Image = InsertTravelFee;
                        Promoted = false;
                        ApplicationArea = all;
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = Process;
                        RunObject = Page "Staff Claim List";
                        RunPageView = where(Status = filter(Approved), Posted = filter(false));
                        RunPageMode = Edit;
                        ToolTip = 'Executes the Staff Claims action.';
                    }
                    action("Approved Other Advance Requests")
                    {
                        Caption = 'Approved Other Advance Requests';
                        Image = VendorBill;
                        Promoted = false;
                        ApplicationArea = all;
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = Process;
                        RunObject = Page "Staff Advance Request List";
                        RunPageView = where(Status = filter(Approved), Posted = filter(false));
                        RunPageMode = Edit;
                        ToolTip = 'Executes the Approved Other Advance Requests action.';
                    }
                    action("Approved Other Advance Accounting")
                    {
                        Caption = 'Approved Other Advance Surrender';
                        Image = Reconcile;
                        Promoted = false;
                        ApplicationArea = all;
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = Process;
                        RunObject = Page "Staff Advance Surrender List";
                        RunPageView = where(Status = filter(Approved), Posted = filter(false));
                        RunPageMode = Edit;
                        ToolTip = 'Executes the Approved Other Advance Surrender action.';
                    }
                    /* action("Approved Item Cash")
                    {
                        Caption = 'Approved Item Cash';
                        Image = Reconcile;
                        Promoted = false;
                        ApplicationArea = all;
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = Process;
                        RunObject = Page "Item/Cash List";
                        RunPageView = where(Status = filter(Approved), Posted = filter(false));
                        RunPageMode = Edit;
                    }
                    action("Approved Item Cash Surrender")
                    {
                        Caption = 'Approved Item Cash Surrender';
                        Image = Reconcile;
                        Promoted = false;
                        ApplicationArea = all;
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = Process;
                        RunObject = Page "Item/Cash Accounting";
                        RunPageView = where(Status = filter(Approved), Posted = filter(false));
                        RunPageMode = Edit;
                    } */
                }
                group("Cancelled Documents")
                {
                    action("Cancelled InterBank Transfer")
                    {
                        Caption = 'Cancelled InterBank Transfer';
                        ApplicationArea = all;
                        RunObject = Page "Interbank Transfer";
                        RunPageView = where(Status = filter(Cancelled), Posted = filter(false));
                        ToolTip = 'Executes the Cancelled InterBank Transfer action.';
                    }

                    action("Cancelled Payment Voucher")
                    {
                        Caption = 'Cancelled Payment Voucher';
                        ApplicationArea = all;
                        Image = VendorPayment;
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = Process;
                        RunObject = Page "Payment Vouchers Cancelled";
                        RunPageView = where(Status = filter(Cancelled), Posted = filter(false));
                        RunPageMode = View;
                        ToolTip = 'Executes the Cancelled Payment Voucher action.';
                    }


                    action("Cancelled Petty Cash Payment")
                    {
                        Caption = 'Cancelled Petty Cash Payment';
                        Image = Payment;
                        Promoted = false;
                        ApplicationArea = all;
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = Process;
                        RunObject = Page "Petty Cash";
                        RunPageView = where(Status = filter(Cancelled), Posted = filter(false));
                        RunPageMode = View;
                        ToolTip = 'Executes the Cancelled Petty Cash Payment action.';
                    }
                    action("Cancelled Travel Advance")
                    {
                        Caption = 'Cancelled Staff Imprest';
                        Image = Travel;
                        Promoted = false;
                        ApplicationArea = all;
                        RunObject = page "Imprest Lists";
                        RunPageView = where(Status = filter(Cancelled), Posted = filter(false));
                        RunPageMode = View;
                        ToolTip = 'Executes the Cancelled Staff Imprest action.';
                    }
                    action("Cancelled Travel Advance Accounting")
                    {
                        Caption = 'Cancelled Staff Imprest Surrender';
                        Image = Reconcile;
                        Promoted = false;
                        ApplicationArea = all;
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = Process;
                        RunObject = Page "Travel Advances Acct. List";
                        RunPageView = where(Status = filter(Cancelled), Posted = filter(false));
                        RunPageMode = View;
                        ToolTip = 'Executes the Cancelled Staff Imprest Surrender action.';
                    }
                    action("Cancelled Staff Claims")
                    {
                        Caption = 'Cancelled Staff Claims';
                        Image = InsertTravelFee;
                        Promoted = false;
                        ApplicationArea = all;
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = Process;
                        RunObject = Page "Staff Claim List";
                        RunPageView = where(Status = filter(Cancelled), Posted = filter(false));
                        RunPageMode = View;
                        ToolTip = 'Executes the Cancelled Staff Claims action.';
                    }
                    action("Cancelled Other Advance Requests")
                    {
                        Caption = 'Cancelled Other Advance Requests';
                        Image = VendorBill;
                        Promoted = false;
                        ApplicationArea = all;
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = Process;
                        RunObject = Page "Staff Advance Request List";
                        RunPageView = where(Status = filter(Cancelled), Posted = filter(false));
                        RunPageMode = View;
                        ToolTip = 'Executes the Cancelled Other Advance Requests action.';
                    }
                    action("Cancelled Other Advance Accounting")
                    {
                        Caption = 'Cancelled Other Advance Accounting';
                        Image = Reconcile;
                        Promoted = false;
                        ApplicationArea = all;
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = Process;
                        RunObject = Page "Staff Advance Surrender List";
                        RunPageView = where(Status = filter(Cancelled), Posted = filter(false));
                        RunPageMode = View;
                        ToolTip = 'Executes the Cancelled Other Advance Accounting action.';
                    }
                    /* action("Cancelled Item Cash")
                    {
                        Caption = 'Cancelled Item Cash';
                        Image = Reconcile;
                        Promoted = false;
                        ApplicationArea = all;
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = Process;
                        RunObject = Page "Item/Cash List";
                        RunPageView = where(Status = filter(Cancelled), Posted = filter(false));
                        RunPageMode = View;
                    }
                    action("Cancelled Item Cash Surrender")
                    {
                        Caption = 'Cancelled Item Cash Surrender';
                        Image = Reconcile;
                        Promoted = false;
                        ApplicationArea = all;
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = Process;
                        RunObject = Page "Item/Cash Accounting";
                        RunPageView = where(Status = filter(Cancelled), Posted = filter(false));
                        RunPageMode = View;
                    } */
                }
            }
              group("Cash Flow")
             {
                 Caption = 'Cash Flow';

                  action("Cash Flow Setup")
                 {
                     Caption = 'Cash Flow Setup';
                     ApplicationArea = all;
                     RunObject = Page "Cash Flow Setup";
                 }
                 

                 action("Cash Flow Forecasts")
                 {
                     Caption = 'Cash Flow Forecasts';
                     ApplicationArea = all;
                     RunObject = Page "Cash Flow Forecast List";
                 }
                 action("Chart of Cash Flow Accounts")
                 {
                     Caption = 'Chart of Cash Flow Accounts';
                     ApplicationArea = all;
                     RunObject = Page "Chart of Cash Flow Accounts";
                 }
                 action("Cash Flow Manual Revenues")
                 {
                     Caption = 'Cash Flow Manual Revenues';
                     ApplicationArea = all;
                     RunObject = Page "Cash Flow Manual Revenues";
                 }
                 action("Cash Flow Manual Expenses")
                 {
                     Caption = 'Cash Flow Manual Expenses';
                     ApplicationArea = all;
                     RunObject = Page "Cash Flow Manual Expenses";
                 }
                  action(cahsflowstatistics)
                 {
                     Caption = 'Cash Flow Forecast Statistics';
                     ApplicationArea = all;
                     RunObject = Page "Cash Flow Forecast Statistics";
                 }
                 action(cashflowforecastworksheet)
                  {                 
                     Caption = 'Cash Flow Forecast Worksheet';
                     ApplicationArea = all;
                     RunObject = Page "Cash Flow Worksheet";
                 }
                  
             } 
              group("Cost Accounting")
              {
                  Caption = 'Cost Accounting';
                  action("Cost Types")
                  {
                      Caption = 'Cost Types';
                      ApplicationArea = all;
                      RunObject = Page "Chart of Cost Types";
                  }
                  action("Cost Centers")
                  {
                      Caption = 'Cost Centers';
                      ApplicationArea = all;
                      RunObject = Page "Chart of Cost Centers";
                  }
                  action("Cost Objects")
                  {
                      Caption = 'Cost Objects';
                      RunObject = Page "Chart of Cost Objects";
                  }
                  action("Cost Allocations")
                  {
                      Caption = 'Cost Allocations';
                      RunObject = Page "Cost Allocation Sources";
                  }
                  action("Cost Budgets")
                  {
                      ApplicationArea = all;
                      Caption = 'Cost Budgets';
                      RunObject = Page "Cost Budget Names";
                  }
              } 

            group("Posted Documents")
            {
                Caption = 'Posted Documents';

                Image = FiledPosted;
                /*   action("Posted Sales Invoices Cash")
                  {
                      Caption = 'Posted Cash Sales';
                      ApplicationArea = all;
                      Image = PostedOrder;
                      RunObject = Page "Posted Sales Invoices Cash";

                  }
                  action("Posted Sales Invoices")
                  {
                      Caption = 'Posted Sales Invoices';
                      ApplicationArea = all;
                      Image = PostedOrder;
                      RunObject = Page "Posted Sales Invoices";
                  }
                  action("Posted Sales Credit Memos")
                  {
                      Caption = 'Posted Sales Credit Memos';
                      ApplicationArea = all;
                      Image = PostedOrder;
                      RunObject = Page "Posted Sales Credit Memos";
                  }
                  */
                action("Posted Purchase Invoices")
                {
                    Caption = 'Posted Purchase Invoices';
                    ApplicationArea = all;
                    RunObject = Page "Posted Purchase Invoices";
                    ToolTip = 'Executes the Posted Purchase Invoices action.';
                }
                action("Posted InterBank Transfer")
                {
                    Caption = 'Posted InterBank Transfer';
                    ApplicationArea = all;
                    RunObject = Page "Posted Interbank Transfer List";
                    ToolTip = 'Executes the Posted InterBank Transfer action.';
                }
                action("Posted Payment Voucher")
                {
                    Caption = 'Posted Payment Voucher';
                    ApplicationArea = all;
                    Image = VendorPayment;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Posted Payment Vouchers";
                    RunPageMode = Create;
                    RunPageView = WHERE(Status = FILTER(Posted),
                                        Posted = FILTER(true),
                                        "Payment Type" = CONST(Normal));
                    ToolTip = 'Executes the Posted Payment Voucher action.';
                }
                action("Posted Receipts")
                {
                    Caption = 'Posted Receipts';
                    Image = ReceivableBill;
                    Promoted = false;
                    ApplicationArea = all;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Posted Receipts";
                    RunPageMode = Edit;
                    ToolTip = 'Executes the Posted Receipts action.';

                }
                action("Posted Petty Cash")
                {
                    Caption = 'Posted Petty Cash';
                    Image = Payment;
                    Promoted = false;
                    ApplicationArea = all;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'

                    RunPageMode = Create;
                    RunObject = Page "Petty Cash";
                    RunPageView = where(Status = filter(Posted));
                    ToolTip = 'Executes the Posted Petty Cash action.';
                }
                action("Posted Staff Travel Advance")
                {
                    Caption = 'Posted Staff Imprest';
                    Image = Travel;
                    Promoted = false;
                    ApplicationArea = all;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Posted imprest list";
                    RunPageMode = Create;
                    ToolTip = 'Executes the Posted Staff Imprest action.';
                }
                /* action("Posted Item Cash")
                {
                    Caption = 'Posted Item Cash';
                    Image = CashFlow;
                    Promoted = false;
                    ApplicationArea = all;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Item/Cash Posted List";
                    RunPageMode = Create;
                }
                action("Posted Item Cash Surr")
                {
                    Caption = 'Posted Item Cash Accounting';
                    Image = CashFlow;
                    Promoted = false;
                    ApplicationArea = all;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Posted Item/Cash Accounting";
                    RunPageMode = Create;
                }
 */
                action("Posted Staff Travel Advance Accounting")
                {
                    Caption = 'Posted Staff Imprest Accounting';
                    Image = Reconcile;
                    Promoted = false;
                    ApplicationArea = all;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Posted Travel Advs. Accounting";
                    RunPageMode = Create;
                    ToolTip = 'Executes the Posted Staff Imprest Accounting action.';
                }
                /* action("Posted item Cash Surrender")
                {
                    Caption = 'Posted Item Cash Surrender';
                    Image = Reconcile;
                    Promoted = false;
                    ApplicationArea = all;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Posted Travel Advs. Accounting";
                    RunPageView = WHERE(Status = FILTER(Posted), "Imprest Type" = filter("Item Cash"));
                    RunPageMode = Create;
                } */
                action("Posted Staff Claim")
                {
                    Caption = 'Posted Staff Claim';
                    Image = VendorBill;
                    Promoted = false;
                    ApplicationArea = all;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Posted Staff Claim List";
                    RunPageMode = Create;
                    ToolTip = 'Executes the Posted Staff Claim action.';
                }
                action("Posted Other Advance Accounting")
                {
                    Caption = 'Posted Other Advance Accounting';
                    Image = Reconcile;
                    Promoted = false;
                    ApplicationArea = all;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Posted staf Advance Surrenders";
                    RunPageMode = Create;
                    ToolTip = 'Executes the Posted Other Advance Accounting action.';
                }
                action("Posted Purchase Credit Memos")
                {
                    Caption = 'Posted Purchase Credit Memos';
                    ApplicationArea = all;
                    RunObject = Page "Posted Purchase Credit Memos";
                    ToolTip = 'Executes the Posted Purchase Credit Memos action.';
                }
                action("Issued Reminders")
                {
                    Caption = 'Issued Reminders';
                    Image = OrderReminder;
                    ApplicationArea = all;
                    RunObject = Page "Issued Reminder List";
                    ToolTip = 'Executes the Issued Reminders action.';
                }
                action("Issued Fin. Charge Memos")
                {
                    Caption = 'Issued Fin. Charge Memos';
                    ApplicationArea = all;
                    Image = PostedMemo;
                    RunObject = Page "Issued Fin. Charge Memo List";
                    ToolTip = 'Executes the Issued Fin. Charge Memos action.';
                }
                action("G/L Registers")
                {
                    Caption = 'G/L Registers';
                    ApplicationArea = all;
                    Image = GLRegisters;
                    RunObject = Page "G/L Registers";
                    ToolTip = 'Executes the G/L Registers action.';
                }
                action("Posted Sales Invoice")
                {
                    Caption = 'Posted Sales Invoice';
                    ApplicationArea = All;
                    Image = SalesInvoice;
                    RunObject = page "Posted Sales Invoices";
                    ToolTip = 'Executes the Posted Sales Invoice action.';
                }
                /* action("Cost Accounting Registers")
                {
                    Caption = 'Cost Accounting Registers';
                    ApplicationArea = all;
                    RunObject = Page "Cost Registers";
                }
                action("Cost Accounting Budget Registers")
                {
                    Caption = 'Cost Accounting Budget Registers';
                    ApplicationArea = all;
                    RunObject = Page "Cost Budget Registers";
                } */
            }
            group(Administration)
            {
                Caption = 'Administration';
                Image = Administration;

                action(Currencies)
                {
                    Caption = 'Currencies';
                    ApplicationArea = all;
                    Image = Currency;
                    RunObject = Page Currencies;
                    ToolTip = 'Executes the Currencies action.';
                }
                action("Accounting Periods")
                {
                    Caption = 'Accounting Periods';
                    ApplicationArea = all;
                    Image = AccountingPeriods;
                    RunObject = Page "Accounting Periods";
                    ToolTip = 'Executes the Accounting Periods action.';
                }
                action("Number Series")
                {
                    Caption = 'Number Series';
                    ApplicationArea = all;
                    RunObject = Page "No. Series";
                    ToolTip = 'Executes the Number Series action.';
                }
                action("Analysis Views")
                {
                    Caption = 'Analysis Views';
                    ApplicationArea = all;
                    RunObject = Page "Analysis View List";
                    ToolTip = 'Executes the Analysis Views action.';
                }
                action("Account Schedules")
                {
                    Caption = 'Account Schedules';
                    ApplicationArea = all;
                    RunObject = Page "Account Schedule Names";
                    ToolTip = 'Executes the Account Schedules action.';
                }
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    ApplicationArea = all;
                    Image = Dimensions;
                    RunObject = Page Dimensions;
                    ToolTip = 'Executes the Dimensions action.';
                }
                action("Bank Account Posting Groups")
                {
                    Caption = 'Bank Account Posting Groups';
                    ApplicationArea = all;
                    RunObject = Page "Bank Account Posting Groups";
                    ToolTip = 'Executes the Bank Account Posting Groups action.';
                }
                action(CashOfficeSetup)
                {
                    Caption = 'Cash Office Setup';
                    ApplicationArea = all;
                    RunObject = Page "Cash Office Setup UP";
                    ToolTip = 'Executes the Cash Office Setup action.';
                }
                action("Cash Office User Template")
                {
                    Caption = 'Cash Office User Template';
                    ApplicationArea = all;
                    RunObject = Page "Cash Office User Template UP";
                    ToolTip = 'Executes the Cash Office User Template action.';
                }
                action("Travel Destinations")
                {
                    Caption = 'Travel Destinations';
                    ApplicationArea = all;
                    RunObject = Page "Destination Code List";
                    ToolTip = 'Executes the Travel Destinations action.';
                }
                action("Budgetary Control Setup")
                {
                    Caption = 'Budgetary Control Setup';
                    ApplicationArea = all;
                    RunObject = Page "Budgetary Control Setup";
                    ToolTip = 'Executes the Budgetary Control Setup action.';
                }

                action("Receipt Types")
                {
                    Caption = 'Receipt Types';
                    ApplicationArea = all;
                    RunObject = Page "Receipt Types";
                    ToolTip = 'Executes the Receipt Types action.';
                }
                action("Payment Types")
                {
                    Caption = 'Payment Types';
                    ApplicationArea = all;
                    RunObject = Page "Payment Types";
                    ToolTip = 'Executes the Payment Types action.';
                }
                action("Imprest Types")
                {
                    Caption = 'Imprest Types';
                    ApplicationArea = all;
                    RunObject = Page "Imprest Types";
                    ToolTip = 'Executes the Imprest Types action.';
                }
                action("Claim Types")
                {
                    Caption = 'Claim Types';
                    ApplicationArea = all;
                    RunObject = Page "Claim Types";
                    ToolTip = 'Executes the Claim Types action.';
                }
                action("Tarriff Codes List")
                {
                    Caption = 'Tarriff Codes';
                    ApplicationArea = all;
                    RunObject = Page "Tariff Codes UP";
                    ToolTip = 'Executes the Tarriff Codes action.';
                }
                action("Expense Code UP")
                {
                    Caption = 'Expense Code UP';
                    ApplicationArea = all;
                    RunObject = Page "Expense Code UP";
                    ToolTip = 'Executes the Expense Code UP action.';
                }
                action("GL UP")
                {
                    Caption = 'GL List';
                    ApplicationArea = all;
                    RunObject = Page "GL List";
                    ToolTip = 'Executes the GL List action.';
                }
                action("Charge")
                {
                    Caption = 'Charges';
                    ApplicationArea = all;
                    RunObject = Page charge;
                    ToolTip = 'Executes the Charges action.';
                }

                /* action("MassCustInvoice")
                {
                    Caption = 'Mass Customers Invoicing';
                    ApplicationArea = all;
                    RunObject = report "Generate Mass Invoices";
                }
                action("AnnualLevy")
                {
                    Caption = 'Annual Levy';
                    ApplicationArea = all;
                    RunObject = page "Annual Levy";
                }
                action("LevyNotice")
                {
                    Caption = 'Levy Notice';
                    ApplicationArea = all;
                    RunObject = report "Levy Notice";
                }
 */

            }
            group(PeriodicValidations)
            {
                caption = 'Periodic Activities';
                /* action("Exaternal Buffer")
                {
                    Caption = 'External Transactions';
                    ApplicationArea = all;
                    RunObject = Page "External Buffer";
                }
                action("Exaternal Transfers")
                {
                    Caption = 'External Transfers';
                    ApplicationArea = all;
                    RunObject = Page "External Transfers";
                }
                action("Generate Due Imprest Surrender")
                {
                    Caption = 'Generate Due Imprest Surrender';
                    ApplicationArea = all;
                    RunObject = report "Generate Due Imprest Surrender";
                } */
                action("ImportBudget")
                {
                    Caption = 'Import Budget Entries';
                    ApplicationArea = all;
                    RunObject = xmlport "G/L Budget Entry";
                    ToolTip = 'Executes the Import Budget Entries action.';
                }
                action("ImportJournal")
                {
                    Caption = 'Import Journal';
                    ApplicationArea = all;
                    RunObject = xmlport "Journal Import";
                    ToolTip = 'Executes the Import Journal action.';
                }

                action(VoteBook)
                {
                    Caption = 'Vote Book Balance - Detail';
                    ApplicationArea = all;
                    RunObject = report "Vote Book Balance - Detail";
                    ToolTip = 'Executes the Vote Book Balance - Detail action.';
                }

            }
            group(Approvals)
            {
                Caption = 'Approvals';
                Image = Alerts;

                action("Pending My Approval")
                {
                    Caption = 'Pending My Approval';
                    ApplicationArea = all;
                    RunObject = Page "Requests to Approve";
                    ToolTip = 'Executes the Pending My Approval action.';
                }
                action("My Approval requests")
                {
                    Caption = 'My Approval requests';
                    ApplicationArea = all;
                    RunObject = Page "Approval Request Entries";
                    ToolTip = 'Executes the My Approval requests action.';
                }
            }
            group(Common_req)
            {
                Caption = 'Common Requisitions';
                Image = LotInfo;
                action("Stores Requisitions")
                {
                    Caption = 'Stores Requisitions';
                    ApplicationArea = all;
                    RunObject = Page "Store Requisition";
                    ToolTip = 'Executes the Stores Requisitions action.';
                }
                action(Vendorpayment)
                {
                    Caption='Vendor Payment requisition';
                    ApplicationArea=all;
                    RunObject=page "Payment Requistions";
                    ToolTip='Executes vendor payments';
                }
                action("Staff Claim")
                {
                    Caption = 'Staff Claim';
                    ApplicationArea = all;
                    RunObject = Page "Staff Claim List";
                    ToolTip = 'Executes the Staff Claim action.';
                }
                action("Purchase Requisition")
                {
                    Caption = 'Purchase Requisition';
                    ApplicationArea = all;
                    RunObject = Page "Purchase Requisition";
                    ToolTip = 'Executes the Purchase Requisition action.';
                }
                action("Imprest Surrender")
                {
                    Caption = 'Imprest Surrender';
                    ApplicationArea = all;
                    RunObject = Page "Imprest Accounting";
                    ToolTip = 'Executes the Imprest Surrender action.';
                }
                action("Imprest Requisitions")
                {
                    Caption = 'Imprest Requisitions';
                    ApplicationArea = all;
                    RunObject = Page "Imprest List UP";
                    ToolTip = 'Executes the Imprest Requisitions action.';
                }
                action("Leave Applications")
                {
                    Caption = 'Leave Applications';
                    ApplicationArea = all;
                    RunObject = Page "HR Leave Requisition List";
                    ToolTip = 'Executes the Leave Applications action.';
                }
                action("My Approved Leaves")
                {
                    Caption = 'My Approved Leaves';
                    ApplicationArea = all;
                    Image = History;
                    RunObject = Page "Hr My Approved Leaves List";
                    ToolTip = 'Executes the My Approved Leaves action.';
                }
                action(MyAudits)
                {
                    ApplicationArea = Basic;
                    Caption = 'My Audits';
                    RunObject = Page "Int. Audit Auditee Response";
                    ToolTip = 'Executes the My Audits action.';
                }
            }

            /* group("Levy Computations")
            {

                action(ImportLevy)
                {
                    ApplicationArea = Basic;
                    Caption = 'Import Levy Transactions';
                    RunObject = report "Import Levy Transactions";
                }
                action(AutoInvocing2)
                {
                    ApplicationArea = Basic;
                    Caption = 'Levy Computations';
                    RunObject = Page "Temp Levy Computations";
                }
            } */
        }
        area(embedding)
        {
            action("Chart of Accounts")
            {
                Caption = 'Chart of Accounts';
                ApplicationArea = all;
                RunObject = Page "Chart of Accounts";
                ToolTip = 'Executes the Chart of Accounts action.';
            }
            action(Vendors)
            {
                Caption = 'Vendors';
                ApplicationArea = all;
                Image = Vendor;
                RunObject = Page "Vendor List";
                ToolTip = 'Executes the Vendors action.';
            }


            action(Budgets)
            {
                Caption = 'Budgets';
                ApplicationArea = all;
                RunObject = Page "G/L Budget Names";
                ToolTip = 'Executes the Budgets action.';
            }
            action("Bank Accounts")
            {
                Caption = 'Bank Accounts';
                ApplicationArea = all;
                Image = BankAccount;
                RunObject = Page "Bank Account List";
                ToolTip = 'Executes the Bank Accounts action.';
            }
            action("Bank Accounts Rec")
            {
                Caption = 'Bank Account Reconcilliation';
                ApplicationArea = all;
                Image = BankAccount;
                RunObject = Page "Bank Acc. Reconciliation List";
                ToolTip = 'Executes the Bank Account Reconcilliation action.';
            }

            action(Items)
            {
                Caption = 'Items';
                ApplicationArea = all;
                Image = Item;
                RunObject = Page "Item List";
                ToolTip = 'Executes the Items action.';
            }
            action(Customers)
            {
                Caption = 'Customers';
                ApplicationArea = all;
                Image = Customer;
                RunObject = Page "Customer List";
                ToolTip = 'Executes the Customers action.';
            }


        }
        area(processing)
        {

            group(Tasks)
            {
                Caption = 'Tasks';


                action("Cas&h Receipt Journal")
                {
                    Caption = 'Cas&h Receipt Journal';
                    ApplicationArea = all;
                    Image = CashReceiptJournal;
                    RunObject = Page "Cash Receipt Journal";
                    ToolTip = 'Executes the Cas&h Receipt Journal action.';
                }
                action("Pa&yment Journal")
                {
                    Caption = 'Pa&yment Journal';
                    ApplicationArea = all;
                    Image = PaymentJournal;
                    RunObject = Page "Payment Journal";
                    ToolTip = 'Executes the Pa&yment Journal action.';
                }
                separator(Separator67) { }
                action("Analysis &View")
                {
                    Caption = 'Analysis &View';
                    ApplicationArea = all;
                    Image = AnalysisView;
                    RunObject = Page "Analysis View Card";
                    ToolTip = 'Executes the Analysis &View action.';
                }
                action("Analysis by &Dimensions")
                {
                    Caption = 'Analysis by &Dimensions';
                    ApplicationArea = all;
                    Image = AnalysisViewDimension;
                    RunObject = Page "Analysis by Dimensions";
                    ToolTip = 'Executes the Analysis by &Dimensions action.';
                }
                action("Bank Account R&econciliation")
                {
                    Caption = 'Bank Account R&econciliation';
                    ApplicationArea = all;
                    Image = BankAccountRec;
                    RunObject = Page "Bank Acc. Reconciliation";
                    ToolTip = 'Executes the Bank Account R&econciliation action.';
                }
                action("Adjust E&xchange Rates")
                {
                    Caption = 'Adjust E&xchange Rates';
                    ApplicationArea = all;
                    Ellipsis = true;
                    Image = AdjustExchangeRates;
                    RunObject = Report "Adjust Exchange Rates";
                    ToolTip = 'Executes the Adjust E&xchange Rates action.';
                }
                action("Station Summaries")
                {
                    Caption = 'Station Summaries';
                    ApplicationArea = all;
                    Ellipsis = true;
                    Image = AdjustExchangeRates;
                    RunObject = page "Station Summaries";
                    ToolTip = 'Executes the Station Summaries action.';
                }
            }
            group(Admininistration)
            {
                Caption = 'Administration';
                //IsHeader = true;

                action("General &Ledger Setup")
                {
                    Caption = 'General &Ledger Setup';
                    ApplicationArea = all;
                    Image = Setup;
                    RunObject = Page "General Ledger Setup";
                    ToolTip = 'Executes the General &Ledger Setup action.';
                }
                action("&Sales && Receivables Setup")
                {
                    Caption = '&Sales && Receivables Setup';
                    ApplicationArea = all;
                    Image = Setup;
                    RunObject = Page "Sales & Receivables Setup";
                    ToolTip = 'Executes the &Sales && Receivables Setup action.';
                }
                action("&Purchases && Payables Setup")
                {
                    Caption = '&Purchases && Payables Setup';
                    ApplicationArea = all;
                    Image = Setup;
                    RunObject = Page "Purchases & Payables Setup";
                    ToolTip = 'Executes the &Purchases && Payables Setup action.';
                }
                action("Cash Office Setup")
                {
                    Caption = 'Cash Office Setup';
                    ApplicationArea = all;
                    Image = Setup;
                    RunObject = Page "Cash Office Setup UP";
                    ToolTip = 'Executes the Cash Office Setup action.';
                }
                action("Cash Office Templates")
                {
                    Caption = 'Cash Office Templates';
                    ApplicationArea = all;
                    Image = Setup;
                    RunObject = Page "Cash Office User Template UP";
                    ToolTip = 'Executes the Cash Office Templates action.';
                }
            }
            group(History)
            {
                Caption = 'History';
                //  IsHeader = true;

                action("Navi&gate")
                {
                    Caption = 'Navi&gate';
                    ApplicationArea = all;
                    Image = Navigate;
                    RunObject = Page Navigate;
                    ToolTip = 'Executes the Navi&gate action.';
                }
            }
        }
    }
}

