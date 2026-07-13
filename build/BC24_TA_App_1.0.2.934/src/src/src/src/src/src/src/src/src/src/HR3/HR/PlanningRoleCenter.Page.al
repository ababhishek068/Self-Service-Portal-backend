Page 50667 "Planning Role Center"
{
    Caption = 'Internal Planning Role Center';
    PageType = RoleCenter;
    ApplicationArea = All;

    layout
    {
        area(rolecenter)
        {
            group(Control1900724808)
            {
                part(Control60; "Headline RC Business Manager")
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
            group(StrategicPLan)
            {
                Caption = 'Strategic Plan';
                action(Donors)
                {
                    ApplicationArea = Basic;
                    Caption = 'University Information';
                    RunObject = Page "PC Company Information";
                    ToolTip = 'Executes the University Information action.';
                }
                action(Action53)
                {
                    ApplicationArea = Basic;
                    Caption = 'Strategic Themes & Objective';
                    RunObject = Page "PC Strategic Objectives";
                    ToolTip = 'Executes the Strategic Themes & Objective action.';

                }
                action(Action54)
                {
                    ApplicationArea = Basic;
                    Caption = 'Strategic Activities';
                    RunObject = Page "PC Strategic Activities";
                    ToolTip = 'Executes the Strategic Activities action.';

                }
            }
            group(Strategis)
            {
                Caption = 'Strategies';
                action(Action33)
                {
                    ApplicationArea = Basic;
                    Caption = 'Strategies';
                    RunObject = Page "PC Strategies";
                    ToolTip = 'Executes the Strategies action.';

                }
            }
            group(StrategicPlanImp)
            {
                Caption = 'Strategic Plan Implementation';
                action(Action331)
                {
                    ApplicationArea = Basic;
                    Caption = 'Strategic Plan Implementation';
                    RunObject = Page "PC Strategic Plan Imp.";
                    ToolTip = 'Executes the Strategic Plan Implementation action.';
                }
                action(PCTargets)
                {
                    ApplicationArea = Basic;
                    Caption = 'Strategic Targets';
                    RunObject = Page "PC Targets";
                    ToolTip = 'Executes the Strategic Targets action.';
                }
            }
            group(PC)
            {
                Caption = 'Performance Contracting';
                action(Receipt)
                {
                    ApplicationArea = Basic;
                    Caption = 'Performance Contracting';
                    RunObject = Page "Performance Contracting List";
                    ToolTip = 'Executes the Performance Contracting action.';

                }
                action(MasterPlan)
                {
                    ApplicationArea = Basic;
                    Caption = 'Master Plan';
                    RunObject = Page "MasterPlan List";
                    ToolTip = 'Executes the Master Plan action.';
                }
                action(HRPolicy)
                {
                    ApplicationArea = Basic;
                    Caption = 'University Policies';
                    RunObject = Page "HR Policies";
                    ToolTip = 'Executes the University Policies action.';
                }

            }
            group(Setup)
            {
                Caption = 'Set Ups';
                action(Setups)
                {
                    ApplicationArea = Basic;
                    Caption = 'PC Setups';
                    RunObject = Page "Jobs-Setup";
                    ToolTip = 'Executes the PC Setups action.';

                }
            }
            group(QMS)
            {
                Caption = 'Quality Management System';
                action(Risk)
                {
                    ApplicationArea = Basic;
                    Caption = 'Risks';
                    RunObject = Page Risk;
                    ToolTip = 'Executes the Risks action.';
                }
                action(AuditNotif)
                {
                    ApplicationArea = Basic;
                    Caption = 'Audit Notification';
                    RunObject = Page "Audit Notifications";
                    ToolTip = 'Executes the Audit Notification action.';
                }
                action(Audit)
                {
                    ApplicationArea = Basic;
                    Caption = 'Audit';
                    RunObject = Page Audit;
                    ToolTip = 'Executes the Audit action.';
                }
                action(AuditMeeting)
                {
                    ApplicationArea = Basic;
                    Caption = 'Audit Meetings';
                    RunObject = Page "Audit Meetings";
                    ToolTip = 'Executes the Audit Meetings action.';
                }
            }
            group(Common_req)
            {
                Caption = 'Common Requisitions';
                Image = LotInfo;
                action(StoresRequisitions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Stores Requisitions';
                    RunObject = Page "Store Requisition";
                    ToolTip = 'Executes the Stores Requisitions action.';
                }
                action(StaffClaim)
                {
                    ApplicationArea = Basic;
                    Caption = 'Staff Claim';
                    RunObject = Page "Staff Claims";
                    ToolTip = 'Executes the Staff Claim action.';
                }
                action(PurchaseRequisition)
                {
                    ApplicationArea = Basic;
                    Caption = 'Purchase Requisition';
                    RunObject = Page "Purchase Requisition";
                    ToolTip = 'Executes the Purchase Requisition action.';
                }
                action(ImprestSurrender)
                {
                    ApplicationArea = Basic;
                    Caption = 'Imprest Surrender';
                    RunObject = Page "Imprest Accounting";
                    ToolTip = 'Executes the Imprest Surrender action.';
                }
                action(ImprestRequisitions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Imprest Requisitions';
                    RunObject = Page "Imprest List UP";
                    ToolTip = 'Executes the Imprest Requisitions action.';
                }
                action(LeaveApplications)
                {
                    ApplicationArea = Basic;
                    Caption = 'Leave Applications';
                    RunObject = Page "HR Leave Requisition List";
                    ToolTip = 'Executes the Leave Applications action.';
                }
                action(TransportRequisition)
                {
                    ApplicationArea = Basic;
                    Caption = 'Transport Requisition';
                    RunObject = Page "FLT Transport Requisition List";
                    ToolTip = 'Executes the Transport Requisition action.';
                }
                action(MyAudits)
                {
                    ApplicationArea = Basic;
                    Caption = 'My Audits';
                    RunObject = Page "Int. Audit Auditee Response";
                    ToolTip = 'Executes the My Audits action.';
                }

            }


        }
    }
}

