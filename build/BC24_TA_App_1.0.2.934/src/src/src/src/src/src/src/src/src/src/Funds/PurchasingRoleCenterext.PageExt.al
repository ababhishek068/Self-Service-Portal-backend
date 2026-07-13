pageextension 50016 "Purchasing RoleCenter ext" extends "Purchasing Manager Role Center"
{

    layout
    {
        addfirst(RoleCenter)
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
                    ApplicationArea = All;
                }
            }

        }

    }

    actions
    {
        modify(Vendors)
        {
            Visible = false;
        }
        addafter(Vendors)
        {
            action(OtherVendors)
            {
                Caption = 'Main Vendors';
                Image = BankAccountLedger;
                ApplicationArea = all;
                RunObject = page "Vendor List Others";
                ToolTip = 'Executes the Main Vendors action.';
            }
            action(CouncilVendors)
            {
                Caption = 'Council Vendors';
                Image = BankAccountLedger;
                ApplicationArea = all;
                RunObject = page "Vendor List.";
                Visible = false;
                ToolTip = 'Executes the Council Vendors action.';
            }
            action(StaffVendors)
            {
                Caption = 'Staff Vendors';
                Image = BankAccountLedger;
                ApplicationArea = all;
                RunObject = page "Vendor List Staff";
                ToolTip = 'Executes the Staff Vendors action.';
            }
        }
        addafter("Orders2")
        {
            action(SalesOrder)
            {
                Caption = 'Pending Sales Invoice Adjustments';
                Image = BankAccountLedger;
                ApplicationArea = all;
                RunObject = page "Pending Invoice List";
                ToolTip = 'Executes the Pending Sales Invoice Adjustments action.';
            }
        }
        addfirst(Sections)
        {
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
                    RunObject = Page "Consolidated WP Activities";
                    RunPageView = where("Workplan Status" = filter('Approved'), "Ammended" = filter('No'));
                    ToolTip = 'Executes the Consolidated WP Activities action.';
                }
                action(ConsolidatedWorkplan2)
                {
                    Caption = 'Ammended Consolidated WP';
                    Image = Customer;
                    ApplicationArea = all;
                    RunObject = Page "Consolidated WP Activities";
                    RunPageView = where("Workplan Status" = filter('Approved'), "Ammended" = filter('Yes'));
                    ToolTip = 'Executes the Ammended Consolidated WP action.';
                }
                action(ConsolidatedWorkplan3)
                {
                    Caption = 'Consolidated WP Act. (All)';
                    Image = Customer;
                    ApplicationArea = all;
                    RunObject = Page "Cons. WP Activities(All)";
                    ToolTip = 'Executes the Consolidated WP Act. (All) action.';
                    // RunPageView = where("Workplan Status" = filter('Approved'), "Ammended" = filter('Yes'));
                }

                action(GlobalWorkplan)
                {
                    ApplicationArea = All;
                    Caption = 'Company Workplan List';
                    Image = VendorPaymentJournal;
                    RunObject = page "Company Workplan List";
                    ToolTip = 'Executes the Company Workplan List action.';
                }
                action(GlobalPWorkplan)
                {
                    ApplicationArea = All;
                    Caption = 'Procurement Plan list';
                    Image = VendorPaymentJournal;
                    RunObject = page "Procurement Plan list";
                    ToolTip = 'Executes the Procurement Plan list action.';
                }


            }
        }
        addafter(Workplan)
        {
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
                    RunObject = Page "RFQ List";
                    ToolTip = 'Executes the Request for Quote action.';

                }
                action("Request for Proposal")
                {
                    Caption = 'Request for Proposal';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "RFP List";
                    ToolTip = 'Executes the Request for Proposal action.';

                }
                action("Purchase Qoute")
                {
                    Caption = 'Purchase Quote';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Purchase Quotes";
                    RunPageView = where(Status = filter(Open));
                    ToolTip = 'Executes the Purchase Quote action.';
                }
                action("Purchase Order")
                {
                    Caption = 'Purchase Order';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Purchase Order List";
                    RunPageView = where(Status = filter(Open));
                    ToolTip = 'Executes the Purchase Order action.';
                }
                action("Purchase Invoice")


                {
                    Caption = 'Purchase Invoice';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Purchase Invoices";
                    RunPageView = where(Status = filter(Open));
                    ToolTip = 'Executes the Purchase Invoice action.';
                }
                action("Open Store Requisition")
                {
                    Caption = 'Store Requisition';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Store Requisition";
                    RunPageView = where(Status = filter(Open));
                    ToolTip = 'Executes the Store Requisition action.';
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
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Item/Cash List";
                    ToolTip = 'Executes the Low Value Procurement action.';
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
                action("OpenTendering")
                {
                    Caption = 'Open Tendering';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Open Tendering List";
                    ToolTip = 'Executes the Open Tendering action.';
                }
                action("RestrictedTendering")
                {
                    Caption = 'Restricted Tendering';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Restricted Tendering List";
                    ToolTip = 'Executes the Restricted Tendering action.';
                }
                action("VoteBookSum")
                {
                    Caption = 'VoteBook Summary';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = report "Vote Book Balance - Detail";
                    ToolTip = 'Executes the VoteBook Summary action.';
                }
            }
        }
        addlast(Sections)
        {
            Group(Tender)
            {
                action("TenderList")
                {
                    Caption = 'Tender List';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = New;
                    RunObject = page "Tender Plan List";
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
                    PromotedCategory = New;
                    RunObject = page "Questionaire List";
                    ToolTip = 'Executes the Questionaire List action.';
                }

                action("Food Supplies QuestionaireList")
                {
                    Caption = 'Food Supplies QuestionaireList';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = New;
                    RunObject = page "Food Supplies QuestionaireList";
                    ToolTip = 'Executes the Food Supplies QuestionaireList action.';
                }
                action("Online Feedback List")
                {
                    Caption = 'Online Feedback List';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = New;
                    RunObject = page "Online Feedback List";
                    ToolTip = 'Executes the Online Feedback List action.';
                }
                action("Online Audit Trail")
                {
                    Caption = 'Online Audit Trail';
                    ApplicationArea = all;
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
                    PromotedCategory = New;
                    RunObject = page "New Tender Items List";
                    ToolTip = 'Executes the New Tender Items List action.';
                }
                group(SetUp)
                {
                    action("Tender Setup Card")
                    {
                        Caption = 'Tender Setup Card';
                        ApplicationArea = all;
                        Promoted = true;
                        PromotedCategory = New;
                        RunObject = page "Tender Setup Card";
                        ToolTip = 'Executes the Tender Setup Card action.';
                    }
                    action("Food Supplies Setup Card")
                    {
                        Caption = 'Tender Setup Card';
                        ApplicationArea = all;
                        Promoted = true;
                        PromotedCategory = New;
                        RunObject = page "Food Supplies Setup Card";
                        ToolTip = 'Executes the Tender Setup Card action.';
                    }

                }

            }
            group(AssetMang)
            {
                caption = 'Asset Management';
                action("FixedAsset")
                {
                    Caption = 'Fixed List';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = New;
                    RunObject = page "Fixed Asset List";
                    ToolTip = 'Executes the Fixed List action.';
                }
                action("Reclass")
                {
                    Caption = 'FA Reclass. Journal Batches';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = New;
                    RunObject = page "FA Reclass. Journal Batches";
                    ToolTip = 'Executes the FA Reclass. Journal Batches action.';
                }
                action("DisposalList")
                {
                    Caption = 'Disposal List';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = New;
                    RunObject = page "Disposal List";
                    ToolTip = 'Executes the Disposal List action.';
                }

                action("DisposalsPendingApproval")
                {
                    Caption = 'Pending Approval Disposal Plan';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = New;
                    RunObject = page "Pending Approval Disposal Plan";
                    ToolTip = 'Executes the Pending Approval Disposal Plan action.';
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

                group("DisposalSetups")
                {
                    action("DisposalPeriods")
                    {
                        Caption = 'Disposal Periods';
                        ApplicationArea = all;
                        Promoted = true;
                        PromotedCategory = New;
                        RunObject = page "Disposal Period";
                        ToolTip = 'Executes the Disposal Periods action.';
                    }
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
                action(AssetInfo)
                {
                    ApplicationArea = Basic;
                    Caption = 'Asset Information Register';
                    Image = Aging;
                    Promoted = true;
                    RunObject = page "Asset Info Register List";
                    ToolTip = 'Executes the Asset Information Register action.';
                }
                action(AssetRep)
                {
                    ApplicationArea = Basic;
                    Caption = 'Asset Repair List - Vehicles';
                    Image = Aging;
                    Promoted = true;
                    RunObject = page "Asset Repair List  Vehicles";
                    ToolTip = 'Executes the Asset Repair List - Vehicles action.';
                }
                action(AssetRep2)
                {
                    ApplicationArea = Basic;
                    Caption = 'Asset Repair List - Others';
                    Image = Aging;
                    Promoted = true;
                    RunObject = page "Asset Repair List  Others";
                    ToolTip = 'Executes the Asset Repair List - Others action.';
                }
                action(MaintananceType)
                {
                    ApplicationArea = Basic;
                    Caption = 'Maintanance Type';
                    Image = Aging;
                    Promoted = true;
                    RunObject = page "Maintanance Type";
                    ToolTip = 'Executes the Maintanance Type action.';
                }
                action(AssetRep3)
                {
                    ApplicationArea = Basic;
                    Caption = 'Asset Transfer';
                    Image = Aging;
                    Promoted = true;
                    RunObject = page "Asset Transfer List";
                    ToolTip = 'Executes the Asset Transfer action.';
                }
                action(AssetRep4)
                {
                    ApplicationArea = Basic;
                    Caption = 'Minor Asset Requisition';
                    Image = Aging;
                    Promoted = true;
                    RunObject = page "Minor Asset Requisition List";
                    ToolTip = 'Executes the Minor Asset Requisition action.';
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
                action(ActiveContractList)
                {
                    ApplicationArea = All;
                    Caption = 'Active Contracts';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Image = Item;
                    RunObject = page "Contracts List - Active";
                    ToolTip = 'Executes the Active Contracts action.';
                }
                action(ExpiredContractList)
                {
                    ApplicationArea = All;
                    Caption = 'Expired Contracts';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Image = Item;
                    RunObject = page "Contracts List - Expired";
                    ToolTip = 'Executes the Expired Contracts action.';
                }
                action(CancelledContractList)
                {
                    ApplicationArea = All;
                    Caption = 'Terminated Contracts';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Image = Item;
                    RunObject = page "Contracts List - Cancelled";
                    ToolTip = 'Executes the Terminated Contracts action.';
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
                action("Staff Claim")
                {
                    Caption = 'Staff Claim';
                    ApplicationArea = all;
                    RunObject = Page "Staff Claim List";
                    ToolTip = 'Executes the Staff Claim action.';
                }
                action("Purchase Requisition1")
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
            group("Pending Approval Documents")
            {
                Caption = 'Pending Approval Documents';
                Image = Alerts;

                action("Pending RFQs")
                {
                    Caption = 'Pending RFQs';
                    ApplicationArea = all;
                    RunObject = Page "RFQ List";
                    RunPageView = where(Status = filter(Open | "Pending Approval"));
                    ToolTip = 'Executes the Pending RFQs action.';
                }
                action("Pending Purchase Orders")
                {
                    Caption = 'Pending Purchase Orders';
                    ApplicationArea = all;
                    RunObject = Page "Purchase Orders";
                    RunPageView = where(Status = filter(Open | "Pending Approval"));
                    ToolTip = 'Executes the Pending Purchase Orders action.';
                }
                action("Pending Purchase Requisitions")
                {
                    Caption = 'Pending Purchase Requisitions';
                    ApplicationArea = all;
                    RunObject = Page "Purchase Requisition List";
                    RunPageView = where(Status = filter(Open | "Pending Approval"));
                    ToolTip = 'Executes the Pending Purchase Requisitions action.';
                }

                action("Pending Store Requisition")
                {
                    Caption = 'Pending Store Requisition';
                    ApplicationArea = all;
                    RunObject = Page "Store Requisition";
                    RunPageView = where(Status = filter(Open | "Pending Approval"));
                    ToolTip = 'Executes the Pending Store Requisition action.';
                }
            }
            group("Supplier Portal")
            {
                action("Vendor Buffer")
                {
                    ApplicationArea = All;
                    Caption = 'Pre-qualified Suppliers';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Image = Users;
                    RunObject = page "Vendor User Buffer List";
                    ToolTip = 'Executes the Pre-qualified Suppliers action.';
                }
                action("Shipment Notificatons")
                {
                    ApplicationArea = All;
                    Caption = 'Shipment Notificatons';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Image = Users;
                    RunObject = page "Shipment Notifications";
                    ToolTip = 'Executes the Shipment Notificatons action.';
                }
                action("Tenders")
                {
                    ApplicationArea = All;
                    Caption = 'Tenders';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Image = Users;
                    RunObject = page "Tender List";
                    ToolTip = 'Executes the Tenders action.';
                }
                group(Setups)
                {
                    action("No. Series")
                    {
                        ApplicationArea = All;
                        Caption = 'No. Series';
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        Image = NumberSetup;
                        RunObject = page "Purchases & Payables Setup";
                        ToolTip = 'Executes the No. Series action.';
                    }
                    action("Central Setups")
                    {
                        ApplicationArea = All;
                        Caption = 'Supplier Portal Setups';
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        Image = Web;
                        RunObject = page "Central Setup List";
                        ToolTip = 'Executes the Supplier Portal Setups action.';
                    }
                    action("Vendor Product Categories")
                    {
                        ApplicationArea = All;
                        Caption = 'Vendor Product Categories';
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        Image = ProductDesign;
                        RunObject = page "Vendor Product List";
                        ToolTip = 'Executes the Vendor Product Categories action.';
                    }
                }
            }
        }


        addlast(Sections)
        {
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
                action("Approved Purchase Requisitions")
                {
                    Caption = 'Approved Purchase Requisition';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Report;
                    RunObject = Page "Purchase Requisition-Approved";
                    ToolTip = 'Executes the Approved Purchase Requisition action.';

                }
                action("Terminated RFQ")
                {
                    Caption = 'Terminated Request for Quote';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Report;
                    RunObject = Page "RFQ Header";
                    RunPageView = where(Cancelled = filter('Yes'));
                    ToolTip = 'Executes the Terminated Request for Quote action.';
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
        addbefore(History)
        {
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
                action("Approved Purchase qUOTE")
                {
                    Caption = 'Approved Purchase Quote';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Purchase Quote List";
                    ToolTip = 'Executes the Approved Purchase Quote action.';
                    // RunPageView = where(Status = filter(Released));
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
                action("Approved Store Requisition")
                {
                    Caption = 'Approved Store Requisition';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Store Requisition Approved";
                    ToolTip = 'Executes the Approved Store Requisition action.';
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
            }
        }
    }
}