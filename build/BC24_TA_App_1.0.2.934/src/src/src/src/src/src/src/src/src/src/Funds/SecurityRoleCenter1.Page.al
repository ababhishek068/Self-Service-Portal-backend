Page 50754 "Security Role Center1"
{
    Caption = 'Role Center';
    PageType = RoleCenter;
    ApplicationArea = All;

    layout
    {
        area(rolecenter)
        {
            group(Control10)
            {
                part(Control8; "Sec-Visitor Manager (Active)")
                {
                    Caption = 'Visitors';
                    Visible = false;
                }
            }
            group(Control39)
            {
                part(Control35; "Security Role Cue")
                {
                    Caption = 'Visitors Summary';
                }
            }
            group(Control25)
            {
                systempart(Control24; Outlook) { }
            }
            group(Control23)
            {
                part(Control22; "My Job Queue")
                {
                    Visible = false;
                }
                part(Control21; "Copy Profile")
                {
                    Visible = false;
                }
                systempart(Control20; MyNotes) { }
            }
        }
    }

    actions
    {
        area(reporting)
        {


            action(VisitorsByIndividual)
            {
                ApplicationArea = Basic;
                Caption = 'Visitors By Individual';
                Image = AllocatedCapacity;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Report "Visitors Report";
                ToolTip = 'Executes the Visitors By Individual action.';
            }
            group(Setup)
            {
                Caption = 'Setup';
                Image = LotInfo;
                action("<Page Security Setups>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Security Setup';
                    RunObject = Page "Security Setups";
                    ToolTip = 'Executes the Security Setup action.';
                }
            }
        }
        area(sections)
        {
            group(VisitorsManagement)
            {
                Caption = 'Visitors Management';
                Image = FixedAssets;

                action(Allocations)
                {
                    ApplicationArea = Basic;
                    Caption = 'New Visitors';
                    Image = Registered;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Sec-Visitor Management (New)";
                    ToolTip = 'Executes the New Visitors action.';
                }
                action(ActiveVisitors)
                {
                    ApplicationArea = Basic;
                    Caption = 'Active Visitors';
                    RunObject = Page "Sec-Visitor Manager (Active)";
                    ToolTip = 'Executes the Active Visitors action.';
                }
                action(ClearedVisitors)
                {
                    ApplicationArea = Basic;
                    Caption = 'Cleared Visitors';
                    Image = Aging;
                    Promoted = true;
                    RunObject = Page "Sec-Visitor Manager (Cleared)";
                    ToolTip = 'Executes the Cleared Visitors action.';
                }
            }
            group("Guards Management")
            {
                action(DailyShift)
                {
                    ApplicationArea = Basic;
                    Caption = 'Guards Shift Register';
                    RunObject = Page "Security Daily Shift List";
                    ToolTip = 'Executes the Guards Shift Register action.';
                }
                action(SecComp)
                {
                    ApplicationArea = Basic;
                    Caption = 'Security Company';
                    RunObject = Page "Security Company";
                    ToolTip = 'Executes the Security Company action.';
                }
                action(SecShift)
                {
                    ApplicationArea = Basic;
                    Caption = 'Security Shift';
                    RunObject = Page "Security Shift";
                    ToolTip = 'Executes the Security Shift action.';
                }
                action(SecSection)
                {
                    ApplicationArea = Basic;
                    Caption = 'Security Sections';
                    RunObject = Page "Security Sections";
                    ToolTip = 'Executes the Security Sections action.';
                }
            }
            group(hist)
            {
                Caption = 'History';
                Image = History;
                action(Action28)
                {
                    ApplicationArea = Basic;
                    Caption = 'Cleared Visitors';
                    RunObject = Page "Sec-Visitor Manager (Cleared)";
                    ToolTip = 'Executes the Cleared Visitors action.';
                }


            }
            group("Incident Management")
            {
                Caption = 'Incident Management';
                action("<Page Incident Details>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Incidents Details';
                    RunObject = Page "Incident Details";
                    ToolTip = 'Executes the Incidents Details action.';
                }
                action("<Page Incident pending>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Incidents Pending';
                    RunObject = Page "Incidents Pending";
                    ToolTip = 'Executes the Incidents Pending action.';
                }
            }
            group(Approvals)
            {
                Caption = 'Approvals';
                Image = Alerts;
                action(PendingMyApproval)
                {
                    ApplicationArea = Basic;
                    Caption = 'Pending My Approval';
                    RunObject = Page "Approval Entries";
                    ToolTip = 'Executes the Pending My Approval action.';
                }
                action(MyApprovalrequests)
                {
                    ApplicationArea = Basic;
                    Caption = 'My Approval requests';
                    RunObject = Page "Approval Request Entries";
                    ToolTip = 'Executes the My Approval requests action.';
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
                    RunObject = Page "Staff Claim List";
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
                action("<Page My Approved Leaves>")
                {
                    ApplicationArea = Basic;
                    Caption = 'My Approved Leaves';
                    Image = History;
                    RunObject = Page "Hr My Approved Leaves List";
                    ToolTip = 'Executes the My Approved Leaves action.';
                }
            }
        }
    }
}

