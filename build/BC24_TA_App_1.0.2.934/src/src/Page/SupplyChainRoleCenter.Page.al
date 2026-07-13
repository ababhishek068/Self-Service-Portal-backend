page 50212 "Supply Chain Role Center"
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
            group(Control1900724708)
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
                action(Itemscategory)
                {
                    ApplicationArea = All;
                    Caption = 'Item Category';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Image = Item;
                    RunObject = page "Item Categories";
                    ToolTip = 'Executes the Items subcategory action.';
                }
                action(Itemssubcategory)
                {
                    ApplicationArea = All;
                    Caption = 'Item Sub Category';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Image = Item;
                    RunObject = page "Item Sub Category";
                    ToolTip = 'Executes the Items subcategory action.';
                }
                action(Cancelreasons)
                {
                    ApplicationArea = All;
                    Caption = 'Tender Cancellation Reasons';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Image = Item;
                    RunObject = page "Tender Cancellation Reasons";
                    ToolTip = 'Executes the tender cancellation action.';
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
                action(Vendorsrating)
                {
                    ApplicationArea = All;
                    Caption = 'Vendor Rating List';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Image = Item;
                    RunObject = page "Vendor Evaluation List";
                    ToolTip = 'Executes the Vendor evaluation List action.';
                }
                  action(blacklisting)
                {
                    ApplicationArea = All;
                    Caption = 'Vendor Black List';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Image = Item;
                    RunObject = page "Vendor Blacklist List";
                    ToolTip = 'Executes the Vendor Blacklist action.';
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
                    Caption = 'Vendor Evaluation Factor';
                    Image = Ranges;
                    RunObject = page "Vendor Evaluation Checklist";
                    ToolTip = 'Executes the Vendor evaluation factors action.';
                }
                action(RFQRequirements)
                {
                    ApplicationArea = All;
                    Caption = 'RFQ Required Documents Codes';
                    Image = Ranges;
                    RunObject = page "RFQ Required Docs Codes";
                    ToolTip = 'Executes the RFQ Required Documents Codes action.';
                }
            }
            //assets
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
            //end of assets

            group(Workplan)
            {
                Caption = 'Workplan';
                Image = Administration;

                action(SourceOfWPAFunds)
                {
                    Caption = 'Source of WP Funds';
                    Image = BankAccountLedger;
                    ApplicationArea = all;
                    RunObject = page "Source of WP Funds";
                    ToolTip = 'Executes the Source of WP Funds action.';
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
                action(ProcurementMethodstages)
                {
                    Caption = 'Procurement Method Stages';
                    Image = Vendor;
                    ApplicationArea = all;
                    RunObject = page "Procurement Method Stages";
                    RunPageMode = Edit;
                    ToolTip = 'Executes the Procurement Method Stages action.';
                }

                action(DepartmentalWorkplanAction)
                {
                    Caption = 'Departmental Workplans';
                    Image = Customer;
                    ApplicationArea = all;
                    RunObject = page "Workplan List";
                    ToolTip = 'Executes the Departmental Workplans action.';
                }
                action(individualizedbudget)
                {
                    Caption = 'Individualized Budget';
                    Image = LedgerBudget;
                    ApplicationArea = all;
                    RunObject = page "Individualized Budget";
                    ToolTip = 'Executes the Departmental budget action.';
                }
                action(indiconst)
                {
                    Caption = 'Consolidated Individual Budget';
                    Image = LedgerBudget;
                    ApplicationArea = all;
                    RunObject = page "Consolidated individual budget";
                    ToolTip = 'Executes the Consolidated individual budget action.';
                }

                action(Consbudget)
                {
                    Caption = 'Consolidated Budget Summary';
                    Image = LedgerBudget;
                    ApplicationArea = all;
                    RunObject = page "Consolidated Budget";
                    ToolTip = 'Executes the Consolidated budget action.';
                }


                action(ConsolidatedWorkplan)
                {
                    Caption = 'Consolidated WP Activities';
                    Image = Customer;
                    ApplicationArea = all;
                    RunObject = Page "Consolidated WP Activities";
                    ToolTip = 'Executes the Consolidated WP Activities action.';
                }
                action(GlobalWorkplan)
                {
                    Visible = false;
                    ApplicationArea = All;
                    Caption = 'Company Workplan List';
                    Image = VendorPaymentJournal;
                    RunObject = page "Company Workplan List";
                    ToolTip = 'Executes the Company Workplan List action.';
                }


            }
            group(ApplicationSetups)
            {

                Caption = 'Application Setups ';

                action(ConfigPackages)
                {
                    Caption = 'Configuration Packages';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Config. Packages";
                    ToolTip = 'Executes the Configuration Packages action.';

                }

                action(CompanyInfo)
                {
                    Caption = 'Company Information';
                    ApplicationArea = basic, suite;
                    RunObject = page "Company Information";
                    ToolTip = 'Executes the Company Information action.';
                }

                action(Workflow)
                {
                    Caption = 'Workflow';
                    ApplicationArea = basic, suite;
                    RunObject = page Workflow;
                    ToolTip = 'Executes the Workflow action.';
                }

                action(WorkflowTableRelations)
                {
                    Caption = 'Workflow - Table Relations';
                    ApplicationArea = basic, suite;
                    RunObject = page "Workflow - Table Relations";
                    ToolTip = 'Executes the Workflow - Table Relations action.';
                }
                action(WorkflowEventCombinations)
                {
                    Caption = 'Workflow Event Combinations';
                    ApplicationArea = basic, suite;
                    RunObject = page "WF Event/Response Combinations";
                    ToolTip = 'Executes the Workflow Event Combinations action.';
                }
                action(ReportLayouts)
                {
                    Caption = 'Report Layouts';
                    ApplicationArea = basic, suite;
                    RunObject = page "Report Layout Selection";
                    ToolTip = 'Executes the Report Layouts action.';
                }
                action(Extensions)
                {
                    Caption = 'Extensions';
                    ApplicationArea = basic, suite;
                    RunObject = page "Extension Management";
                    ToolTip = 'Executes the Extensions action.';
                }

                action(Users)
                {
                    Caption = 'Users';
                    ApplicationArea = basic, suite;
                    RunObject = page Users;
                    ToolTip = 'Executes the Users action.';
                }

            }

            group(OpenDocuments)
            {
                caption = 'Open Documents';


                action("Purchase Requisitions")
                {
                    Caption = 'Purchase Requisition';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Purchase Requisition";
                    ToolTip = 'Executes the Purchase Requisition action.';
                }
                action(ItemCash)
                {
                    Caption = 'Item Cash';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Item/Cash List";
                    ToolTip = 'Executes the Item Cash action.';
                }

                action("Request for Quote")
                {
                    Caption = 'Request for Quotation';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "RFQ List";
                    ToolTip = 'Executes the Request for Quote action.';

                }
                action("Request for proposal")
                {
                    Caption = 'Request for Proposal';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "RFP List";
                    ToolTip = 'Executes the Request for Proposal action.';

                }
                action("EOI")
                {
                    Caption = 'Expression of Interest';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "EOI Submissions";
                    ToolTip = 'Executes the Expression of Interest action.';

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
                    RunObject = Page "Purchase Order List";
                    ToolTip = 'Executes the Purchase Order action.';
                }
                action("Goods Reveived Note")
                {
                    Caption = 'Goods Reveived Note';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Posted Purchase Receipts";
                    ToolTip = 'Executes the GRN action.';
                }
                action("inspect")
                {
                    Caption = 'Inspection';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Inspections - Open";
                    ToolTip = 'Executes the inspection action.';
                }

                action("Item Cash Surrender")
                {
                    Caption = 'Item Cash Surrender';
                    Image = Reconcile;
                    Promoted = false;
                    ApplicationArea = all;
                    RunObject = Page "Item/Cash Accounting";
                    RunPageMode = Create;
                    ToolTip = 'Executes the Item Cash Surrender action.';
                }
                action("Direct Procurement")
                {
                    Caption = 'Direct procurement';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Direct Procurement List";
                    ToolTip = 'Executes the Direct procurement action.';
                }

                action("Low Value Procurement")
                {
                    Caption = 'Low Value Procurement';
                    ApplicationArea = all;
                    Visible=false;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Low Value Procurement List";
                    ToolTip = 'Executes the Low Value Procurement action.';
                }
                action("OpenTendering")
                {
                    Caption = 'Open Tendering';
                    ApplicationArea = all;
                    Promoted = true;
                    Visible=false;
                    PromotedCategory = Process;
                    RunObject = Page "Open Tendering List";
                    ToolTip = 'Executes the Open Tendering action.';
                }
                action("RestrictedTendering")
                {
                    Caption = 'Restricted Tendering';
                    ApplicationArea = all;
                    Visible=false;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Restricted Tendering List";
                    ToolTip = 'Executes the Restricted Tendering action.';
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
                    RunObject = Page "RFQ List Released";
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
                    RunObject = Page "Store Requisition Approved";
                    RunPageView = where(Status = filter(Released));
                    ToolTip = 'Executes the Approved Store Requisition action.';
                }
            }


            Group(Tender)
            {

                action("opentender")
                {
                    Caption = 'Open Tender';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = New;
                    RunObject = page "Tenders-List";
                    ToolTip = 'Executes the Tender List action.';

                }
                action("limitedtender")
                {
                    Caption = 'Limited Tender';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = New;
                    RunObject = page "Limited Tender List";
                    ToolTip = 'Executes the Tender List action.';

                }
                action(com)
                {
                    Caption = 'Procurement Committee';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = New;
                    RunObject = page "Procurement Committee";
                    ToolTip = 'Executes the minutes List action.';

                }
                action(appoint)
                {   Caption = 'Appointment List';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = New;
                    RunObject= page "Appointment List";
                }
                action(sig)
                {
                    Caption = 'Signatories';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = New;
                    RunObject = page signatories;
                    ToolTip = 'Executes the minutes List action.';

                }
                action(min)
                {
                    Caption = 'Minutes';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = New;
                    RunObject = page "Minutes Setup";
                    ToolTip = 'Executes the minutes List action.';

                }
                action("ExtensionReq")
                {
                    Caption = 'Tender Extension Request List';
                    ApplicationArea = all;
                    Promoted = true;
                    Visible=true;
                    PromotedCategory = New;
                    RunObject = page "Tender extension List";
                    ToolTip = 'Executes the Tender extension List action.';
                }

                action("Extensioncancellation")
                {
                    Caption = 'Tender Cancellation Request List';
                    ApplicationArea = all;
                    Promoted = true;
                    Visible=true;
                    PromotedCategory = New;
                    RunObject = page "Tender Cancellation list";
                    ToolTip = 'Executes the Tender cancellation List action.';
                }
                action("TenderList")
                {
                    Caption = 'Tender List';
                    ApplicationArea = all;
                    Promoted = true;
                    Visible=false;
                    PromotedCategory = New;
                    RunObject = page "Tender List";
                    ToolTip = 'Executes the Tender List action.';
                }
                action("BidderList")
                {
                    Caption = 'Bidder List';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = New;
                    RunObject = page "Bidder List";
                    ToolTip = 'Executes the Bidder List action.';
                }
                action("QuestionaireList")
                {
                    Caption = 'Questionaire List';
                    ApplicationArea = all;
                    Promoted = true;
                    visible=false;
                    PromotedCategory = New;
                    RunObject = page "Questionaire List";
                    ToolTip = 'Executes the Questionaire List action.';
                }

                action("Food Supplies QuestionaireList")
                {
                    Caption = 'Food Supplies QuestionaireList';
                    ApplicationArea = all;
                    Promoted = true;
                    Visible=false;
                    PromotedCategory = New;
                    RunObject = page "Food Supplies QuestionaireList";
                    ToolTip = 'Executes the Food Supplies QuestionaireList action.';
                }
                action("Online Feedback List")
                {
                    Caption = 'Online Feedback List';
                    ApplicationArea = all;
                    Promoted = true;
                    Visible=false;
                    PromotedCategory = New;
                    RunObject = page "Online Feedback List";
                    ToolTip = 'Executes the Online Feedback List action.';
                }
                action("Online Audit Trail")
                {
                    Caption = 'Online Audit Trail';
                    ApplicationArea = all;
                    Visible=false;
                    Promoted = true;
                    PromotedCategory = New;
                    RunObject = page "Online Audit Trail";
                    ToolTip = 'Executes the Online Audit Trail action.';
                }
                action("New Tender Items List")
                {
                    Caption = 'New Tender Items List';
                    ApplicationArea = all;
                    Promoted = true;
                    Visible=false;
                    PromotedCategory = New;
                    RunObject = page "New Tender Items List";
                    ToolTip = 'Executes the New Tender Items List action.';
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
                    Caption = 'Consolidated Disposal Plan';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = New;
                    RunObject = page "Cons. Disposal Plan List";
                    ToolTip = 'Executes the Consolidated Disposal Plan action.';
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
                    Caption = 'Supplier Contract List';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Image = Item;
                    RunObject = page "Contracts List";
                    ToolTip = 'Executes the Contract List action.';
                }
                action(ContractListserv)
                {
                    ApplicationArea = All;
                    Caption = 'Customer Contract List';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Image = Item;
                    RunObject = page "Service Contract List";
                    ToolTip = 'Executes the customer Contract List action.';
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
                    RunObject = Page "Store Requisition Approved";
                    RunPageView = where(Status = filter(Released));
                    ToolTip = 'Executes the Approved Store Requisition action.';
                }
                 action("transorder")
                {
                    Caption = 'Transfer Orders';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Transfer Orders";
                    //RunPageView = where(Status = filter(Released));
                    //ToolTip = 'Executes the Approved Store Requisition action.';
                }

                 action("assettrans")
                {
                    Caption = 'Asset Transfer';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Asset Transfer List";
                    //RunPageView = where(Status = filter(Released));
                    //ToolTip = 'Executes the Approved Store Requisition action.';
                }
                 action("assincident")
                {
                    Caption = 'Asset Incident';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Asset Incident List";
                    //RunPageView = where(Status = filter(Released));
                    //ToolTip = 'Executes the Approved Store Requisition action.';
                }

                  action("Assetrepair")
                {
                    Caption = 'Asset Repair';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Asset Repair List";
                    //RunPageView = where(Status = filter(Released));
                    //ToolTip = 'Executes the Approved Store Requisition action.';
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
                action("Payment Requisitions")
                {
                    Caption = 'Payment Requisitions';
                    ApplicationArea = all;
                    RunObject = Page "Payment Requistions";
                    ToolTip = 'Executes the payments Requisitions action.';
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
                    ToolTip = 'Executes the Purchase Requisition action';
                }
                
                action("Imprest Requisitions")
                {
                    Caption = 'Imprest Requisitions';
                    ApplicationArea = all;
                    RunObject = Page "Imprest List UP";
                    ToolTip = 'Executes the Imprest Requisitions action.';
                }
                action("Imprest Surrender")
                {
                    Caption = 'Imprest Surrender';
                    ApplicationArea = all;
                    RunObject = Page "Imprest Accounting";
                    ToolTip = 'Executes the Imprest Surrender action.';
                }
                action("Leave Applications")
                {
                    Caption = 'Leave Applications';
                    ApplicationArea = all;
                    RunObject = Page "HR Leave Requisition List";
                    ToolTip = 'Executes the Leave Applications action.';
                    //FLT Transport Requisition
                }
                // action("Transport Requisitions")
                // {
                //     Caption = 'Transport Requisitions';
                //     ApplicationArea = all;
                //     RunObject = Page "FLT Transport Requisition List";
                //     ToolTip = 'Executes the Leave Applications action.';
                //     //FLT Transport Requisition
                // }
                // action(TransportRequisition)
                // {
                //     ApplicationArea = Basic;
                //     Caption = 'Transport Requisition';
                //     RunObject = Page "FLT Transport Requisition List";
                //     ToolTip = 'Executes the Transport Requisition action.';
                // }
                // action(SubmittedTransportRequisition)
                // {
                //     ApplicationArea = Basic;
                //     Caption = 'Submitted Transport Requisition';
                //     RunObject = Page "FLT Submitted Transport List";
                //     ToolTip = 'Executes the Submitted Transport Requisition action.';
                // }
                // action(ApprovedTransportRequisition)
                // {
                //     ApplicationArea = Basic;
                //     Caption = 'Approved Transport Requisition';
                //     RunObject = Page "FLT Approved transport Req";
                //     ToolTip = 'Executes the Approved Transport Requisition action.';
                // }
                // action(ClosedTransportRequisition)
                // {
                //     ApplicationArea = Basic;
                //     Caption = 'Closed Transport Requisition';
                //     RunObject = Page "FLT Transport - Closed List";
                //     ToolTip = 'Executes the Closed Transport Requisition action.';
                // }
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
            group(Transport_re)
            {
                Caption = 'Transport Requisitions';
                Image = Travel;

                group(FleetSetups)
                {
                    Caption='Fleet setups';
                    action(fltsetups)
                    {
                    ApplicationArea = Basic;
                    Caption = 'Fleet management setup List';
                    RunObject = Page "FLT Fleet Mgt Setup";
                    ToolTip = 'Executes the Transport Requisition action.';
                     }

                     action(drivers)
                    {
                    ApplicationArea = Basic;
                    Caption = 'Drivers';
                    RunObject = Page "Flt Driver List";
                    ToolTip = 'Executes the driver.';
                     }
                      action(make)
                    {
                    ApplicationArea = Basic;
                    Caption = 'Make List';
                    RunObject = Page "Flt Make List";
                    ToolTip = 'Executes the driver.';
                     }
                       action(model)
                    {
                    ApplicationArea = Basic;
                    Caption = 'Model List';
                    RunObject = Page "Flt Model List";
                    
                     }

                      action(fltapproval)
                    {
                    ApplicationArea = Basic;
                    Caption = 'Approval setup';
                    RunObject = Page "FLT Mgt Approval Setup";
                    
                     }
                     action(fltlist)
                    {
                    ApplicationArea = Basic;
                    Caption = 'Vehicles';
                    RunObject = Page "Flt Vehicle Card List";
                    
                     }
                     
                }
                action(TransportRequisition)
                {
                    ApplicationArea = Basic;
                    Caption = 'Transport Requisition';
                    RunObject = Page "FLT Transport Requisition List";
                    ToolTip = 'Executes the Transport Requisition action.';
                }
                action(SubmittedTransportRequisition)
                {
                    ApplicationArea = Basic;
                    Caption = 'Submitted Transport Requisition';
                    RunObject = Page "FLT Submitted Transport List";
                    ToolTip = 'Executes the Submitted Transport Requisition action.';
                }
                action(ApprovedTransportRequisition)
                {
                    ApplicationArea = Basic;
                    Caption = 'Approved Transport Requisition';
                    RunObject = Page "FLT Approved transport Req";
                    ToolTip = 'Executes the Approved Transport Requisition action.';
                }
                action(ClosedTransportRequisition)
                {
                    ApplicationArea = Basic;
                    Caption = 'Closed Transport Requisition';
                    RunObject = Page "FLT Transport - Closed List";
                    ToolTip = 'Executes the Closed Transport Requisition action.';
                }

                action(Maintenancereq)
                {
                    ApplicationArea = Basic;
                    Caption = 'Maintenance Requisition';
                    RunObject = Page "FLT Maintenance Request";
                    
                }
                action(Fuelreq)
                {
                    ApplicationArea = Basic;
                    Caption = 'Fuel Requisition';
                    RunObject = Page "FLT Fuel Requestion";
                    
                }
                action(Fuelreq1)
                {
                    ApplicationArea = Basic;
                    Caption = 'Fuel types';
                    RunObject = Page "Fuel Type";
                    
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
                action("Used Purchase Requisition")
                {
                    Caption = 'Used Purchase Requisition';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Purchase Requisition-Used";
                    ToolTip = 'Executes the Used Purchase Requisition action.';
                }
                action("Posted Item Cash")
                {
                    Caption = 'Posted Item Cash';
                    Image = CashFlow;
                    Promoted = false;
                    ApplicationArea = all;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Item/Cash Posted List";
                    RunPageMode = Create;
                    ToolTip = 'Executes the Posted Item Cash action.';
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
                    ToolTip = 'Executes the Posted Item Cash Accounting action.';
                }
            }



        }
    }


}