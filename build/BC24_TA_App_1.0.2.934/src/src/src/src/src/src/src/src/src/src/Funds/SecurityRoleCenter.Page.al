Page 50759 "Security Role Center"
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
                part(Control8; "Security Role Cue")
                {
                    Caption = 'Visitors Summary';
                }
            }
            group(Control18)
            {
                systempart(Control17; Outlook) { }
            }
            group(Control16)
            {
                part(Control15; "My Job Queue")
                {
                    Visible = false;
                }
                part(Control14; "Copy Profile")
                {
                    Visible = false;
                }
                systempart(Control13; MyNotes) { }
            }
        }
    }

    actions
    {
        area(processing) { }
        area(reporting)
        {
            action(VisitorsList)
            {
                ApplicationArea = Basic;
                Caption = 'Visitors List';
                Image = Status;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Report "Visitors Report";
                ToolTip = 'Executes the Visitors List action.';
            }
            action(VisitorsListByDepartment)
            {
                ApplicationArea = Basic;
                Caption = 'Visitors List By Department';
                Image = Allocations;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Report "Visitors Report";
                ToolTip = 'Executes the Visitors List By Department action.';
            }
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
                    Image = setup;
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
                action(IncidentsClearedDropped)
                {
                    ApplicationArea = Basic;
                    Caption = 'Incidents Cleared/Dropped';
                    RunObject = Page "Incidents Cleared";
                    ToolTip = 'Executes the Incidents Cleared/Dropped action.';
                }
            }
            group(hist)
            {
                Caption = 'History';
                Image = History;
                action(Action43)
                {
                    ApplicationArea = Basic;
                    Caption = 'Cleared Visitors';
                    RunObject = Page "Sec-Visitor Manager (Cleared)";
                    ToolTip = 'Executes the Cleared Visitors action.';
                }
                action(Action5)
                {
                    ApplicationArea = Basic;
                    Caption = 'Incidents Cleared/Dropped';
                    RunObject = Page "Incidents Cleared";
                    ToolTip = 'Executes the Incidents Cleared/Dropped action.';
                }
                action("<Institute Booking CL>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Intergration Institute Bookings Approved';
                    Image = History;
                    RunObject = Page "Corporate list (Approved)";
                    ToolTip = 'Executes the Intergration Institute Bookings Approved action.';
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
                action("<Institute Booking Form>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Intergration Institute Booking Request';
                    Image = History;
                    RunObject = Page "Corporate List";
                    ToolTip = 'Executes the Intergration Institute Booking Request action.';
                }
                action("<Student ID Replacement Re>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Student ID Replacement Request';
                    Image = History;
                    RunObject = Page "Student ID Replacement  List";
                    ToolTip = 'Executes the Student ID Replacement Request action.';
                }
            }
        }
    }
}

