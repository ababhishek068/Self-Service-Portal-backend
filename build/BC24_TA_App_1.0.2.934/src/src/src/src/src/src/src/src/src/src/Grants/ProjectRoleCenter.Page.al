Page 51070 "Project Role Center"
{
    Caption = 'Project Planning Role Center';
    PageType = RoleCenter;
    ApplicationArea = All;

    layout
    {
        area(rolecenter)
        {
            group(Control1900724808)
            {
                part(Control60; "Headline RC General Mgt.")
                {
                    ApplicationArea = RelationshipMgmt;
                }
                part(Control1904661108; "Grants Manager Activities") { }
            }
            group(Control1900724708)
            {
                part(Control1907692008; "My Customers") { }
                part(Control21; "My Job Queue")
                {
                    Visible = false;
                }
                part(Control1903012608; "Copy Profile") { }
                systempart(Control1901377608; MyNotes) { }
            }
        }
    }

    actions
    {
        area(reporting)
        {
            action(JobAnalysis)
            {
                ApplicationArea = Basic;
                Caption = 'Job &Analysis';
                Image = "Report";
                RunObject = Report "Project Analysis";
                ToolTip = 'Executes the Job &Analysis action.';
            }
            action(JobActualToBudget)
            {
                ApplicationArea = Basic;
                Caption = 'Job Actual To &Budget';
                Image = "Report";
                RunObject = Report "Job Actual To Budget";
                ToolTip = 'Executes the Job Actual To &Budget action.';
            }
            action(JobPlanningLine)
            {
                ApplicationArea = Basic;
                Caption = 'Job - Pla&nning Line';
                Image = "Report";
                RunObject = Report "Job - Planning Lines";
                ToolTip = 'Executes the Job - Pla&nning Line action.';
            }
            separator(Action29) { }
            action(JobSuggestedBilling)
            {
                ApplicationArea = Basic;
                Caption = 'Job Su&ggested Billing';
                Image = "Report";
                RunObject = Report "Job Suggested Billing";
                ToolTip = 'Executes the Job Su&ggested Billing action.';
            }
            action(JobsperCustomer)
            {
                ApplicationArea = Basic;
                Caption = 'Jobs per &Customer';
                Image = "Report";
                RunObject = Report "Jobs per Customer";
                ToolTip = 'Executes the Jobs per &Customer action.';
            }
            action(ItemsperJob)
            {
                ApplicationArea = Basic;
                Caption = 'Items per &Job';
                Image = "Report";
                RunObject = Report "Items per Job";
                ToolTip = 'Executes the Items per &Job action.';
            }
            action(JobsperItem)
            {
                ApplicationArea = Basic;
                Caption = 'Jobs per &Item';
                Image = "Report";
                RunObject = Report "Jobs per Item";
                ToolTip = 'Executes the Jobs per &Item action.';
            }
            separator(Action43) { }

        }
        area(embedding) { }
        area(sections)
        {
            group(Concept)
            {
                Caption = 'Concept';
                action(Action331)
                {
                    ApplicationArea = Basic;
                    Caption = 'Concept';
                    RunObject = Page "Concept List";
                    ToolTip = 'Executes the Concept action.';
                }
                action(ApprovedConcept)
                {
                    ApplicationArea = Basic;
                    Caption = 'Approved Concept';
                    RunObject = Page "Approved Concepts List";
                    ToolTip = 'Executes the Approved Concept action.';
                }
            }

            group(Proposals)
            {
                Caption = 'Proposals';
                action(Donors)
                {
                    ApplicationArea = Basic;
                    Caption = 'Donors';
                    RunObject = Page "Donors List";
                    ToolTip = 'Executes the Donors action.';
                }
                action(Action53)
                {
                    ApplicationArea = Basic;
                    Caption = 'Proposals';
                    RunObject = Page "Proposal List";
                    RunPageView = where(Status = const(Proposal),
                                        "Approval Status" = filter(Open | "Pending Approval"));
                    ToolTip = 'Executes the Proposals action.';
                }
                action(ApprovedProposals)
                {
                    ApplicationArea = Basic;
                    Caption = 'Approved Proposals';
                    RunObject = Page "Approved Proposal List";
                    ToolTip = 'Executes the Approved Proposals action.';
                    // RunPageView = where(Status = const(Proposal),
                    //                    "Approval Status" = filter(Approved));
                }
            }
            group(Projects)
            {
                Caption = 'Projects';
                action(Action33)
                {
                    ApplicationArea = Basic;
                    Caption = 'Projects';
                    RunObject = Page "Project List";
                    RunPageView = where(Status = filter(Project));
                    ToolTip = 'Executes the Projects action.';
                }
                action(ApprovedProject)
                {
                    ApplicationArea = Basic;
                    Caption = 'Approved Project';
                    RunObject = Page "Approved Grant List";
                    ToolTip = 'Executes the Approved Project action.';
                }
            }

            group(Compliance)
            {
                action(Complianc)
                {
                    ApplicationArea = Basic;
                    Caption = 'Compliance';
                    RunObject = Page "Compliance List";
                    ToolTip = 'Executes the Compliance action.';

                }
                action(CompliancJ)
                {
                    ApplicationArea = Basic;
                    Caption = 'Compliance Journal';
                    RunObject = Page "Compliance journal Lists";
                    ToolTip = 'Executes the Compliance Journal action.';
                }
                action(ApprovedCompliancJ)
                {
                    ApplicationArea = Basic;
                    Caption = 'Approved Compliance Journal';
                    RunObject = Page "Approver Compliance journal Li";
                    ToolTip = 'Executes the Approved Compliance Journal action.';
                }

            }

            group(Journals)
            {
                Caption = 'Journals';
                Image = Journals;
                action(JobJournals)
                {
                    ApplicationArea = Basic;
                    Caption = 'Job Journals';
                    RunObject = Page "Job Journal Batches";
                    RunPageView = where(Recurring = const(false));
                    ToolTip = 'Executes the Job Journals action.';
                }
                action(JobGLJournals)
                {
                    ApplicationArea = Basic;
                    Caption = 'Job G/L Journals';
                    RunObject = Page "General Journal Batches";
                    RunPageView = where("Template Type" = const(Jobs),
                                        Recurring = const(false));
                    ToolTip = 'Executes the Job G/L Journals action.';
                }
                action(ResourceJournals)
                {
                    ApplicationArea = Basic;
                    Caption = 'Resource Journals';
                    RunObject = Page "Resource Jnl. Batches";
                    RunPageView = where(Recurring = const(false));
                    ToolTip = 'Executes the Resource Journals action.';
                }
                action(ItemJournals)
                {
                    ApplicationArea = Basic;
                    Caption = 'Item Journals';
                    RunObject = Page "Item Journal Batches";
                    RunPageView = where("Template Type" = const(Item),
                                        Recurring = const(false));
                    ToolTip = 'Executes the Item Journals action.';
                }
                action(RecurringJobJournals)
                {
                    ApplicationArea = Basic;
                    Caption = 'Recurring Job Journals';
                    RunObject = Page "Job Journal Batches";
                    RunPageView = where(Recurring = const(true));
                    ToolTip = 'Executes the Recurring Job Journals action.';
                }
                action(RecurringResourceJournals)
                {
                    ApplicationArea = Basic;
                    Caption = 'Recurring Resource Journals';
                    RunObject = Page "Resource Jnl. Batches";
                    RunPageView = where(Recurring = const(true));
                    ToolTip = 'Executes the Recurring Resource Journals action.';
                }
                action(RecurringItemJournals)
                {
                    ApplicationArea = Basic;
                    Caption = 'Recurring Item Journals';
                    RunObject = Page "Item Journal Batches";
                    RunPageView = where("Template Type" = const(Item),
                                        Recurring = const(true));
                    ToolTip = 'Executes the Recurring Item Journals action.';
                }
            }
            group("Risk Managment")
            {
                action(Risk)
                {
                    ApplicationArea = Basic;
                    Caption = 'Risk Register';
                    RunObject = Page "Risk Register List";
                    ToolTip = 'Executes the Risk Register action.';
                }
            }
            group(Setup)
            {
                Caption = 'Set Ups';
                action(Setups)
                {
                    ApplicationArea = Basic;
                    Caption = 'Grant Setups';
                    RunObject = Page "Jobs-Setup";
                    ToolTip = 'Executes the Grant Setups action.';

                }
            }
            group(PostedDocuments)
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;
                action(PostedShipments)
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Shipments';
                    RunObject = Page "Posted Sales Shipments";
                    ToolTip = 'Executes the Posted Shipments action.';
                }
                action(PostedSalesInvoices)
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Sales Invoices';
                    Image = PostedOrder;
                    RunObject = Page "Posted Sales Invoices";
                    ToolTip = 'Executes the Posted Sales Invoices action.';
                }
                action(PostedSalesCreditMemos)
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Sales Credit Memos';
                    Image = PostedOrder;
                    RunObject = Page "Posted Sales Credit Memos";
                    ToolTip = 'Executes the Posted Sales Credit Memos action.';
                }
                action(PostedPurchaseReceipts)
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Purchase Receipts';
                    RunObject = Page "Posted Purchase Receipts";
                    ToolTip = 'Executes the Posted Purchase Receipts action.';
                }
                action(PostedPurchaseInvoices)
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Purchase Invoices';
                    RunObject = Page "Posted Purchase Invoices";
                    ToolTip = 'Executes the Posted Purchase Invoices action.';
                }
                action(PostedPurchaseCreditMemos)
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Purchase Credit Memos';
                    RunObject = Page "Posted Purchase Credit Memos";
                    ToolTip = 'Executes the Posted Purchase Credit Memos action.';
                }
                action(GLRegisters)
                {
                    ApplicationArea = Basic;
                    Caption = 'G/L Registers';
                    Image = GLRegisters;
                    RunObject = Page "G/L Registers";
                    ToolTip = 'Executes the G/L Registers action.';
                }
                action(JobRegisters)
                {
                    ApplicationArea = Basic;
                    Caption = 'Job Registers';
                    Image = JobRegisters;
                    RunObject = Page "Job Registers";
                    ToolTip = 'Executes the Job Registers action.';
                }
                action(ItemRegisters)
                {
                    ApplicationArea = Basic;
                    Caption = 'Item Registers';
                    Image = ItemRegisters;
                    RunObject = Page "Item Registers";
                    ToolTip = 'Executes the Item Registers action.';
                }
                action(ResourceRegisters)
                {
                    ApplicationArea = Basic;
                    Caption = 'Resource Registers';
                    Image = ResourceRegisters;
                    RunObject = Page "Resource Registers";
                    ToolTip = 'Executes the Resource Registers action.';
                }
            }
        }
        area(processing)
        {
            separator(Action17)
            {
                Caption = 'Tasks';
                IsHeader = true;
            }


            action(ProjectList)
            {
                ApplicationArea = Basic;
                Caption = 'Project List';
                Image = "report";
                RunObject = Report "Project  list";
                ToolTip = 'Executes the Project List action.';
            }
            action(JobJournal)
            {
                ApplicationArea = Basic;
                Caption = 'Job J&ournal';
                Image = JobJournal;
                RunObject = Page "Job Journal";
                ToolTip = 'Executes the Job J&ournal action.';
            }
            action(JobGLJournal)
            {
                ApplicationArea = Basic;
                Caption = 'Job G/L &Journal';
                Image = GLJournal;
                RunObject = Page "Job G/L Journal";
                ToolTip = 'Executes the Job G/L &Journal action.';
            }
            action(ResourceJournal)
            {
                ApplicationArea = Basic;
                Caption = 'R&esource Journal';
                Image = ResourceJournal;
                RunObject = Page "Resource Journal";
                ToolTip = 'Executes the R&esource Journal action.';
            }
            action(ChangeJobPlanningLineDate)
            {
                ApplicationArea = Basic;
                Caption = 'C&hange Job Planning Line Date';
                Image = "Report";
                RunObject = Report "Change Job Dates";
                ToolTip = 'Executes the C&hange Job Planning Line Date action.';
            }
            action(SplitPlanningLines)
            {
                ApplicationArea = Basic;
                Caption = 'Split Pla&nning Lines';
                Image = Splitlines;
                RunObject = Report "Job Split Planning Line";
                ToolTip = 'Executes the Split Pla&nning Lines action.';
            }
            action(ManagerTimeSheetbyJob)
            {
                ApplicationArea = Basic;
                Caption = 'Manager Time Sheet by Job';
                Image = JobTimeSheet;
                RunObject = Page "Manager Time Sheet by Job";
                ToolTip = 'Executes the Manager Time Sheet by Job action.';
            }
            separator(Action5) { }
            action(JobCreateSalesInvoice)
            {
                ApplicationArea = Basic;
                Caption = 'Job &Create Sales Invoice';
                Image = CreateJobSalesInvoice;
                RunObject = Report "Job Create Sales Invoice";
                ToolTip = 'Executes the Job &Create Sales Invoice action.';
            }
            separator(Action7) { }
            action(UpdateJobItemCost)
            {
                ApplicationArea = Basic;
                Caption = 'Update Job I&tem Cost';
                Image = "Report";
                RunObject = Report "Update Job Item Cost";
                ToolTip = 'Executes the Update Job I&tem Cost action.';
            }
            action(JobCalculateWIP)
            {
                ApplicationArea = Basic;
                Caption = 'Job Calculate &WIP';
                Image = "Report";
                RunObject = Report "Job Calculate WIP";
                ToolTip = 'Executes the Job Calculate &WIP action.';
            }
            action(JobPostWIPtoGL)
            {
                ApplicationArea = Basic;
                Caption = 'Jo&b Post WIP to G/L';
                Image = "Report";
                RunObject = Report "Job Post WIP to G/L";
                ToolTip = 'Executes the Jo&b Post WIP to G/L action.';
            }
            separator(Action11)
            {
                Caption = 'History';
                IsHeader = true;
            }
            action(Navigate)
            {
                ApplicationArea = Basic;
                Caption = 'Navi&gate';
                Image = Navigate;
                RunObject = Page Navigate;
                ToolTip = 'Executes the Navi&gate action.';
            }
        }
    }
}

