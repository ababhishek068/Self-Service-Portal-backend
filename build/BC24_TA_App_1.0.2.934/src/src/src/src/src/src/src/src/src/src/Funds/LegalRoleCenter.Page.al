Page 50650 "Legal  Role Center"
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
                part(Control8; "Legal  Role Cue")
                {
                    Caption = 'Legal & Litigation Summary';
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
        area(reporting)
        {
            group("Legal Reports")
            {
                action(LegalRep)
                {
                    ApplicationArea = Basic;
                    Caption = 'Legal Report';
                    Image = setup;
                    RunObject = report "Legal Management";
                    ToolTip = 'Executes the Legal Report action.';
                }
            }
            group("Case Reports")
            {
                action(ComplaintsRep)
                {
                    ApplicationArea = Basic;
                    Caption = 'Complaints Report';
                    Image = Report;
                    RunObject = report "Case Complaint Report";
                    ToolTip = 'Executes the Complaints Report action.';
                }
                action(GeneralCases)
                {
                    ApplicationArea = Basic;
                    Caption = 'General Case Report ';
                    Image = Report;
                    RunObject = report "General Case Report";
                    ToolTip = 'Executes the General Case Report  action.';
                }
                action("Property Report")
                {
                    ApplicationArea = Basic;
                    Caption = 'Property Report';
                    Image = Report;
                    RunObject = report "Case Property Report";
                    ToolTip = 'Executes the Property Report action.';
                }
                action("Case Card Report")
                {
                    ApplicationArea = Basic;
                    Caption = 'Case Card Report';
                    Image = Report;
                    RunObject = report "Case Report";
                    ToolTip = 'Executes the Case Card Report action.';
                }

            }

        }
        area(sections)
        {
            group("Legal Management")
            {
                Caption = 'Legal Management';
                Image = LotInfo;
                action("<Page  NewLegal Requests>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Legal Advisory and compliance Request';
                    RunObject = Page "Legal List (New)";
                    ToolTip = 'Executes the Legal Advisory and compliance Request action.';
                }
                action("<Page Legal Requests Approved>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Legal Request Approved';
                    RunObject = Page "Legal Approved (Approved)";
                    ToolTip = 'Executes the Legal Request Approved action.';
                }
                action("<Page Legal Request Posted>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Legal Request under Litigation';
                    RunObject = Page "Legal Under Letigation";
                    ToolTip = 'Executes the Legal Request under Litigation action.';
                }
                action("Page Legal Request Posted")
                {
                    ApplicationArea = Basic;
                    Caption = 'Closed Legal Request';
                    RunObject = Page "Legal Posted (Posted)";
                    ToolTip = 'Executes the Closed Legal Request action.';
                }
                action("OutofCoart")
                {
                    ApplicationArea = Basic;
                    Caption = 'Out of Court Settlment ';
                    RunObject = Page "Legal List (OutofCourt)";
                    ToolTip = 'Executes the Out of Court Settlment  action.';
                }
            }
            group("Litigation Management")
            {
                Caption = 'Litigation Management';
                Image = RegisteredDocs;
                action("<Page litigation list>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Letigation Request';
                    Image = History;
                    RunObject = Page "Litigation List";
                    ToolTip = 'Executes the Letigation Request action.';
                }
                action("Page litigation ADR")
                {
                    ApplicationArea = Basic;
                    Caption = 'Legal ADR List';
                    Image = History;
                    RunObject = Page "Legal ADR List";
                    ToolTip = 'Executes the Legal ADR List action.';
                }
                action("Page litigation Pending")
                {
                    ApplicationArea = Basic;
                    Caption = 'Ongoing Litigations';
                    Image = History;
                    RunObject = Page "Litigation Pending List";
                    ToolTip = 'Executes the Ongoing Litigations action.';
                    // RunPageView = where("Litigation Cleared" = filter(false));
                }
                action("Page litigation cleared")
                {
                    ApplicationArea = Basic;
                    Caption = 'Closed Litigation';
                    Image = History;
                    RunObject = Page "Litigation List (Cleared)";
                    ToolTip = 'Executes the Closed Litigation action.';
                }
                action("Send Request")
                {
                    ApplicationArea = Basic;
                    Caption = 'Send Request';
                    Visible = false;
                    ToolTip = 'Executes the Send Request action.';
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
                    RunObject = page "Contracts Approved List";
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
                    RunObject = page "Contracts Cancelled List";
                    ToolTip = 'Executes the Cancelled Contract List action.';
                    //  RunPageView = where(Status = filter(Cancelled));
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
                    RunPageView = where(Status = const(Rejected));
                    ToolTip = 'Executes the Rejected Contract List action.';
                }
            }
            group("Case Management")
            {
                action(CaseList)
                {
                    ApplicationArea = All;
                    Caption = 'Cases List';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Image = Item;
                    RunObject = page "Case List";
                    ToolTip = 'Executes the Cases List action.';

                }
                action(CaseInvestList)
                {
                    ApplicationArea = All;
                    Caption = 'Cases Investigation List';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Image = Item;
                    RunObject = page "Case Investigation List";
                    RunPageView = where(Status = filter(Investigation));
                    ToolTip = 'Executes the Cases Investigation List action.';
                }
                action(CaseODPPList)
                {
                    ApplicationArea = All;
                    Caption = 'Cases ODPP List';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Image = Item;
                    RunObject = page "Case Investigation List";
                    RunPageView = where(Status = filter(ODPP));
                    ToolTip = 'Executes the Cases ODPP List action.';
                }
                action(CaseArrestList)
                {
                    ApplicationArea = All;
                    Caption = 'Cases Pending Arrest List';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Image = Item;
                    RunObject = page "Case Investigation List";
                    RunPageView = where(Status = filter("Pending Arrest"));
                    ToolTip = 'Executes the Cases Pending Arrest List action.';
                }
                action(CaseCourtList)
                {
                    ApplicationArea = All;
                    Caption = 'Cases Pending Before Court List';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Image = Item;
                    RunObject = page "Case Investigation List";
                    RunPageView = where(Status = filter("Pending Before Court"));
                    ToolTip = 'Executes the Cases Pending Before Court List action.';
                }
                action(CaseConvictedList)
                {
                    ApplicationArea = All;
                    Caption = 'Cases Convicted List';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Image = Item;
                    RunObject = page "Case Investigation List";
                    RunPageView = where(Status = filter(Convicted | Acquittal));
                    ToolTip = 'Executes the Cases Convicted List action.';
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
                action("<Institute Booking CL>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Intergration Institute Bookings Approved';
                    Image = History;
                    RunObject = Page "Corporate list (Approved)";
                    ToolTip = 'Executes the Intergration Institute Bookings Approved action.';
                }
                action("<Student ID Replacement APP>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Student ID Replacement Approved';
                    Image = History;
                    RunObject = Page "Student ID Replacement Apprd";
                    ToolTip = 'Executes the Student ID Replacement Approved action.';
                }
                action(IncidentsClearedDropped)
                {
                    ApplicationArea = Basic;
                    Caption = 'Incidents Cleared/Dropped';
                    RunObject = Page "Registry Files Card";
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
                action("<Student ID Replacement e>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Student ID Replacement Request Pending';
                    Image = History;
                    RunObject = Page "Food Menu List";
                    ToolTip = 'Executes the Student ID Replacement Request Pending action.';
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

