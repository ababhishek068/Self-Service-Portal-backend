Page 50686 "Corporate  Role Center"
{
    Caption = 'Corporate  Role Center';
    PageType = RoleCenter;
    ApplicationArea = All;

    layout
    {
        area(rolecenter)
        {
            group(Control10)
            {
                part(Control8; "Risk Card")
                {
                    Caption = 'Corporate Affairs Summary';
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
        area(processing)
        {
            action(Setup)
            {
                ApplicationArea = Basic;
                Caption = 'Setup';
                Image = setup;
                RunObject = Page "Legal Setups";
                ToolTip = 'Executes the Setup action.';
            }
        }
        area(reporting) { }
        area(sections)
        {
            group("Corporate Affairs Management")
            {
                Caption = 'Corporate Affairs Management';
                Image = LotInfo;
                action("<Institute Booking Form>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Intergration Institute Booking Request';
                    Image = History;
                    RunObject = Page "Corporate List";
                    ToolTip = 'Executes the Intergration Institute Booking Request action.';
                }
                action("<Institute Booking C1L>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Intergration Institute Bookings Approved';
                    Image = History;
                    RunObject = Page "Corporate list (Approved)";
                    ToolTip = 'Executes the Intergration Institute Bookings Approved action.';
                }
                action("Compliments/Complaints List")
                {
                    ApplicationArea = Basic;
                    Caption = 'Compliments/Complaints List';
                    RunObject = Page "Compliments/Complaints List";
                    ToolTip = 'Executes the Compliments/Complaints List action.';
                }
                action("Pending Complaints")
                {
                    ApplicationArea = Basic;
                    Caption = 'Pending Complaints ';
                    Image = History;
                    RunObject = Page "Pending Complaints";
                    ToolTip = 'Executes the Pending Complaints  action.';
                }
                action("Resolved Complaints/Compliment")
                {
                    ApplicationArea = Basic;
                    Caption = 'Resolved Complaints/Compliment';
                    Image = History;
                    RunObject = Page "Resolved Complaints/Compliment";
                    ToolTip = 'Executes the Resolved Complaints/Compliment action.';
                }
            }
            group("Student Affairs Management")
            {
                Caption = 'Student Affairs Management';
                Image = RegisteredDocs;
                action("<Student ID Replacement Re>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Student ID Replacement Request';
                    Image = History;
                    RunObject = Page "Student ID Replacement  List";
                    ToolTip = 'Executes the Student ID Replacement Request action.';
                }
                action("<Student ID Replacement e>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Student ID Replacement Request Pending';
                    Image = History;
                    RunObject = Page "Food Menu List";
                    ToolTip = 'Executes the Student ID Replacement Request Pending action.';
                }
                action("<Student ID Replacement APP>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Student ID Replacement Approved';
                    Image = History;
                    RunObject = Page "Student ID Replacement Apprd";
                    ToolTip = 'Executes the Student ID Replacement Approved action.';
                }
                action("<Student Identification List>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Student Identification Requests';
                    Image = History;
                    RunObject = Page "Audit Card";
                    ToolTip = 'Executes the Student Identification Requests action.';
                }
                action("<Confirmed Student Identificn>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Confirmed Student Identification Requests';
                    Image = History;
                    RunObject = Page "Cofirmed Stud Identification";
                    ToolTip = 'Executes the Confirmed Student Identification Requests action.';
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
            group(hist)
            {
                Caption = 'History';
                Image = History;
                action("<Page Legal cleared>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Legal Requests Cleared';
                    RunObject = Page "Legal Posted (Posted)";
                    ToolTip = 'Executes the Legal Requests Cleared action.';
                }
                action("<Page Litigation Cleared>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Litigation Cleared';
                    Image = Invoice;
                    Promoted = true;
                    RunObject = Page "Litigation List (Cleared)";
                    ToolTip = 'Executes the Litigation Cleared action.';
                }
                action("<Student ID Replacement AP1P>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Student ID Replacement Approved';
                    Image = History;
                    RunObject = Page "Student ID Replacement Apprd";
                    ToolTip = 'Executes the Student ID Replacement Approved action.';
                }
                action("<Confirmed Student Identific1n>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Confirmed Student Identification Requests';
                    Image = History;
                    RunObject = Page "Cofirmed Stud Identification";
                    ToolTip = 'Executes the Confirmed Student Identification Requests action.';
                }
                action(IncidentsClearedDropped)
                {
                    ApplicationArea = Basic;
                    Caption = 'Incidents Cleared/Dropped';
                    ToolTip = 'Executes the Incidents Cleared/Dropped action.';
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

