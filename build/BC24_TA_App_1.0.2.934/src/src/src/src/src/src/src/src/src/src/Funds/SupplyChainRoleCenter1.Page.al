page 50585 "Supply Chain Role Center1"
{
    PageType = RoleCenter;
    Caption = 'Supply Chain Management Role Center';
    ApplicationArea = All;

    layout
    {
        area(rolecenter)
        {
            part(Headline; "Supply Chain Headline")
            {
                ApplicationArea = Basic, Suite;
            }


            part("Supply Chain Activities Cue"; "Supply Chain Activities Cue")
            {
                Caption = 'Supply Chain Activities';
                ApplicationArea = Basic, Suite;
            }
        }
    }

    actions
    {
        area(Sections)
        {
            group(Planning)
            {
                action(Items)
                {
                    ApplicationArea = All;
                    Caption = 'Items';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Image = Item;
                    RunObject = page "Item List";
                    ToolTip = 'Executes the Items action.';
                }

                action(Vendors)
                {
                    ApplicationArea = All;
                    Caption = 'Vendors';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Image = Item;
                    RunObject = page "Vendor List";
                    ToolTip = 'Executes the Vendors action.';
                }
                action(VendorsBuffer)
                {
                    ApplicationArea = All;
                    Caption = 'Vendor Buffer List';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Image = Item;
                    RunObject = page "Vendor User Buffer List";
                    ToolTip = 'Executes the Vendor Buffer List action.';
                }
                action(Customers)
                {
                    ApplicationArea = All;
                    Caption = 'Customers';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Image = Item;
                    RunObject = page "Customer List";
                    ToolTip = 'Executes the Customers action.';
                }
                action(VendorRating)
                {
                    ApplicationArea = All;
                    Caption = 'Vendor Rating Codes';
                    Image = Ranges;
                    ToolTip = 'Executes the Vendor Rating Codes action.';
                    // RunObject = page "Vendor Rating Codes";
                }
                action(RFQRequirements)
                {
                    ApplicationArea = All;
                    Caption = 'RFQ Required Documents Codes';
                    Image = Ranges;
                    ToolTip = 'Executes the RFQ Required Documents Codes action.';
                    //  RunObject = page "RFQ Required Docs Codes";
                }
            }

            group(Workplan)
            {
                Caption = 'Workplan';
                Image = Administration;

                action(SourceOfWPAFunds)
                {
                    Caption = 'Source of WP Funds';
                    Image = BankAccountLedger;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Source of WP Funds action.';
                    //  RunObject = page "Source of WP Funds";
                }

                action(ProcurementMethodsAction)
                {
                    Caption = 'Procurement Methods';
                    Image = Customer;
                    ApplicationArea = all;
                    RunObject = page "Procurement Methods List";
                    RunPageMode = Edit;
                    ToolTip = 'Executes the Procurement Methods action.';
                }

                action(DepartmentalWorkplanAction)
                {
                    Caption = 'Departmental Workplans';
                    Image = Customer;
                    ApplicationArea = all;
                    RunObject = page "Workplan List";
                    ToolTip = 'Executes the Departmental Workplans action.';
                }

                action(ConsolidatedWorkplan)
                {
                    Caption = 'Consolidated WP Activities';
                    Image = Customer;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Consolidated WP Activities action.';
                    //  RunObject = Page "Consolidated WP Activities";
                }

                action(GlobalWorkplan)
                {
                    Visible = false;
                    ApplicationArea = All;
                    Caption = 'Company Workplan List';
                    Image = VendorPaymentJournal;
                    ToolTip = 'Executes the Company Workplan List action.';
                    //  RunObject = page "Company Workplan List";
                }


            }


            group(OpenDocuments)
            {
                caption = 'Open Documents';


                action("Purchase Requisition")
                {
                    Caption = 'Purchase Requisition';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Purchase Requisition";
                    ToolTip = 'Executes the Purchase Requisition action.';
                }
                action("Request for Quote")
                {
                    Caption = 'Request for Quote';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Purchase Quote List";
                    ToolTip = 'Executes the Request for Quote action.';

                }
                action("Purchase Qoute")
                {
                    Caption = 'Purchase Quote';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Purchase Quotes";
                    ToolTip = 'Executes the Purchase Quote action.';
                }
                action("Purchase Order")
                {
                    Caption = 'Purchase Order';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Purchase Order";
                    ToolTip = 'Executes the Purchase Order action.';
                }
                action("Direct Procurement")
                {
                    Caption = 'Direct procurement';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Executes the Direct procurement action.';
                    // RunObject = Page "Direct Procurement";
                }

                action("Low Value Procurement")
                {
                    Caption = 'Low Value Procurement';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Executes the Low Value Procurement action.';
                    // RunObject = Page "Low Value Procurement List";
                }
                action("OpenTendering")
                {
                    Caption = 'Open Tendering';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Executes the Open Tendering action.';
                    // RunObject = Page "Open Tendering List";
                }
                action("RestrictedTendering")
                {
                    Caption = 'Restricted Tendering';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Executes the Restricted Tendering action.';
                    //  RunObject = Page "Restricted Tendering List";
                }
                action("PurchaseReturn")
                {
                    Caption = 'Purchase Return Orders';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Purchase Return Orders";
                    ToolTip = 'Executes the Purchase Return Orders action.';
                }
            }


            Group(Tender)
            {
                action("TenderList")
                {
                    Caption = 'Tender List';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = New;
                    ToolTip = 'Executes the Tender List action.';
                    // RunObject = page "Tender List";
                }
                action("BidderList")
                {
                    Caption = 'Bidder List';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = New;
                    ToolTip = 'Executes the Bidder List action.';
                    // RunObject = page "Bidder List";
                }
                action("QuestionaireList")
                {
                    Caption = 'Questionaire List';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = New;
                    ToolTip = 'Executes the Questionaire List action.';
                    //  RunObject = page "Questionaire List";
                }

                action("Food Supplies QuestionaireList")
                {
                    Caption = 'Food Supplies QuestionaireList';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = New;
                    ToolTip = 'Executes the Food Supplies QuestionaireList action.';
                    //   RunObject = page "Food Supplies QuestionaireList";
                }
                action("Online Feedback List")
                {
                    Caption = 'Online Feedback List';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = New;
                    ToolTip = 'Executes the Online Feedback List action.';
                    // RunObject = page "Online Feedback List";
                }
                action("Online Audit Trail")
                {
                    Caption = 'Online Audit Trail';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = New;
                    ToolTip = 'Executes the Online Audit Trail action.';
                    //  RunObject = page "Online Audit Trail";
                }
                action("New Tender Items List")
                {
                    Caption = 'New Tender Items List';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = New;
                    ToolTip = 'Executes the New Tender Items List action.';
                    //  RunObject = page "New Tender Items List";
                }
                group(SetUp)
                {
                    action("Tender Setup Card")
                    {
                        Caption = 'Tender Setup Card';
                        ApplicationArea = all;
                        Promoted = true;
                        PromotedCategory = New;
                        ToolTip = 'Executes the Tender Setup Card action.';
                        //  RunObject = page "Tender Setup Card";
                    }
                    action("Food Supplies Setup Card")
                    {
                        Caption = 'Tender Setup Card';
                        ApplicationArea = all;
                        Promoted = true;
                        PromotedCategory = New;
                        ToolTip = 'Executes the Tender Setup Card action.';
                        //  RunObject = page "Food Supplies Setup Card";
                    }

                }

            }
            group("Asset Disposal")
            {
                action("DisposalList")
                {
                    Caption = 'Disposal Plan';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = New;
                    RunObject = page "Disposal Plan List";
                    ToolTip = 'Executes the Disposal Plan action.';
                }
                action("DisposalPlanList")
                {
                    Caption = 'Disposal Consolidation';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = New;
                    RunObject = page "Disposals";
                    ToolTip = 'Executes the Disposal Consolidation action.';
                }
                action("Disposal")
                {
                    Caption = 'Disposal';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = New;
                    RunObject = page "Approved Disposals";
                    ToolTip = 'Executes the Disposal action.';
                }

                group("Reports")
                {
                    action("Disposal Report")
                    {
                        Caption = 'Disposal Report';
                        ApplicationArea = all;
                        Promoted = true;
                        PromotedCategory = New;
                        RunObject = report "Disposal Report";
                        ToolTip = 'Executes the Disposal Report action.';
                    }
                    action("Disposal Plan Reports")
                    {
                        Caption = 'Disposal Plan Reports';
                        ApplicationArea = all;
                        Promoted = true;
                        PromotedCategory = New;
                        RunObject = report "Disposal Plan Reports";
                        ToolTip = 'Executes the Disposal Plan Reports action.';
                    }
                }
            }
            group(ContractManagement)
            {
                Caption = 'Contract Management';
                action(ContractList)
                {
                    ApplicationArea = All;
                    Caption = 'Contract List';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Image = Item;
                    RunObject = page "Contracts List";
                    ToolTip = 'Executes the Contract List action.';
                }
                action(ApprovedContractList)
                {
                    ApplicationArea = All;
                    Caption = 'Approved Contract List';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Image = Item;
                    RunObject = page "Contracts List";
                    RunPageView = where(Status = filter(Approved));
                    ToolTip = 'Executes the Approved Contract List action.';
                }
                action(CancelledContractList)
                {
                    ApplicationArea = All;
                    Caption = 'Cancelled Contract List';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Image = Item;
                    RunObject = page "Contracts List";
                    RunPageView = where(Status = filter(Cancelled));
                    ToolTip = 'Executes the Cancelled Contract List action.';
                }
                action(RejectedContractList)
                {
                    ApplicationArea = All;
                    Caption = 'Rejected Contract List';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Image = Item;
                    RunObject = page "Contracts List";
                    RunPageView = where(Status = filter(Rejected));
                    ToolTip = 'Executes the Rejected Contract List action.';
                }
            }
            group(StoreReq)
            {
                Caption = 'Store Requisition';
                action("Store Requisition")
                {
                    Caption = 'Store Requisition';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Store Requisition";
                    RunPageView = where(status = filter("Pending Approval" | Open));
                    ToolTip = 'Executes the Store Requisition action.';
                }
                action("Approved Store Requisition1")
                {
                    Caption = 'Approved Store Requisition';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Executes the Approved Store Requisition action.';
                    // RunObject = Page "Store Requisition Approved";
                    // RunPageView = where(Status = filter(Released));
                }

            }




            group(History)
            {
                Caption = 'Documents History';
                action("Posted Store Requisition")
                {
                    Caption = 'Posted Store Requisition';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Report;
                    RunObject = Page "Posted Store Requisitions";
                    ToolTip = 'Executes the Posted Store Requisition action.';
                }
                action("Posted Purchase Receipt")
                {
                    Caption = 'Posted Purchase Receipts';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Report;
                    RunObject = Page "Posted Purchase Receipts";
                    ToolTip = 'Executes the Posted Purchase Receipts action.';
                }
                action("Posted Purchase Invoice")
                {
                    Caption = 'Posted Purchase Invoice';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Report;
                    RunObject = Page "Posted Purchase Invoices";
                    ToolTip = 'Executes the Posted Purchase Invoice action.';
                }
                action("Posted Purchase Credit Memo")
                {
                    Caption = 'Posted Purchase Credit Memo';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Report;
                    RunObject = Page "Posted Purchase Credit Memo";
                    ToolTip = 'Executes the Posted Purchase Credit Memo action.';
                }
                action("External Transfers")
                {
                    Caption = 'External Transfers';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Report;
                    RunObject = Page "External Transfers";
                    ToolTip = 'Executes the External Transfers action.';
                }

            }


            group(ApprovedReq)
            {
                Caption = 'Approved Documents';
                action("Approved Purchase Requisition")
                {
                    Caption = 'Approved Purchase Requisition';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Purchase Requisition-Approved";
                    ToolTip = 'Executes the Approved Purchase Requisition action.';
                }
                action("Approved Request for Quote")
                {
                    Caption = 'Approved Request for Quote';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Purchase Quote List";
                    ToolTip = 'Executes the Approved Request for Quote action.';

                }
                action("Approved Purchase Order")
                {
                    Caption = 'Approved Purchase Order';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Purchase Order List";
                    RunPageView = where(Status = filter(Released));
                    ToolTip = 'Executes the Approved Purchase Order action.';
                }
                action("Partialy Serviced Purchase Order")
                {
                    Caption = 'Serviced Purchase Order';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Purchase Order List";
                    RunPageView = where("Serviced Orders" = filter(true));
                    ToolTip = 'Executes the Serviced Purchase Order action.';
                }
                action("Approved Purchase Invoice")
                {
                    Caption = 'Approved Purchase Invoice';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Purchase Invoices";
                    RunPageView = where(Status = filter(Released));
                    ToolTip = 'Executes the Approved Purchase Invoice action.';
                }
                action("Approved Purchase Credit Memo")
                {
                    Caption = 'Approved Purchase Credit Memo';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Purchase Credit Memos";
                    RunPageView = where(Status = filter(Released));
                    ToolTip = 'Executes the Approved Purchase Credit Memo action.';
                }

                action("Approved Store Requisition")
                {
                    Caption = 'Approved Store Requisition';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Store Requisition";
                    RunPageView = where(Status = filter(Released));
                    ToolTip = 'Executes the Approved Store Requisition action.';
                }
            }
        }
    }


}