Page 50230 "Projects Role Center"
{
    Caption = 'Role Center';
    PageType = RoleCenter;
    ApplicationArea = All;

    layout
    {
        area(rolecenter)
        {
            group(Control1900724808)
            {
                part(Control99; "Projects List")
                {
                    Caption = 'Projects';
                    Visible = true;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Project Activity")
            {
                ApplicationArea = Basic;
                Caption = 'Project Activity';
                Image = List;
                Promoted = true;
                RunObject = Page "Projects Activity";
                ToolTip = 'Executes the Project Activity action.';
            }
            action(Charges)
            {
                ApplicationArea = Basic;
                Caption = 'Modules';
                RunObject = Page Modules;
                ToolTip = 'Executes the Modules action.';
            }
        }
        area(embedding)
        {
            action(Customers)
            {
                ApplicationArea = Basic;
                Caption = 'Customers';
                Image = Customer;
                Promoted = true;
                RunObject = Page "Customer List";
                ToolTip = 'Executes the Customers action.';
            }
            action(Projects)
            {
                ApplicationArea = Basic;
                Caption = 'Projects';
                Image = "Order";
                Promoted = true;
                RunObject = Page "Projects List";
                ToolTip = 'Executes the Projects action.';
            }
        }
        area(reporting)
        {
            group(Periodic)
            {
                Caption = 'Periodic Reports';
                Visible = false;
                group("Project Reports")
                {
                    Image = AnalysisView;
                    // action("Students Balances")
                    // {
                    //     ApplicationArea = Basic;
                    //     Image = PrintInstallment;
                    //     Promoted = true;
                    //     RunObject = Report UnknownReport50400;
                    // }
                    // action("Tuition Billing Report")
                    // {
                    //     ApplicationArea = Basic;
                    //     Image = PickLines;
                    //     Promoted = true;
                    //     RunObject = Report UnknownReport50558;
                    // }
                    // action("Per Programme Balances")
                    // {
                    //     ApplicationArea = Basic;
                    //     Image = PrintInstallment;
                    //     Promoted = true;
                    //     RunObject = Report UnknownReport50404;
                    // }
                    // action("Fee Structure Report")
                    // {
                    //     ApplicationArea = Basic;
                    //     Image = AddAction;
                    //     Promoted = true;
                    //     RunObject = Report UnknownReport50545;
                    // }
                }
            }
        }
        area(sections)
        {
            group(ActionGroup19)
            {
                Caption = 'Projects';
                action(Action6)
                {
                    ApplicationArea = Basic;
                    Caption = 'Projects';
                    Image = "Order";
                    Promoted = true;
                    RunObject = Page "Projects List";
                    ToolTip = 'Executes the Projects action.';
                }
                action(Customer)
                {
                    ApplicationArea = Basic;
                    Caption = 'Customers';
                    RunObject = Page "Customer List";
                    ToolTip = 'Executes the Customers action.';
                }
            }
            group(Approvals)
            {
                Caption = 'Approvals';
                Image = Alerts;
                action("Pending My Approval")
                {
                    ApplicationArea = Basic;
                    Caption = 'Pending My Approval';
                    RunObject = Page "Approval Entries";
                    ToolTip = 'Executes the Pending My Approval action.';
                }
                action("My Approval requests")
                {
                    ApplicationArea = Basic;
                    Caption = 'My Approval requests';
                    RunObject = Page "Approval Request Entries";
                    ToolTip = 'Executes the My Approval requests action.';
                }
                // action("Clearance Requests")
                // {
                //     ApplicationArea = Basic;
                //     Caption = 'Clearance Requests';
                //     RunObject = Page UnknownPage50948;
                // }
            }
            group(Common_req)
            {
                Caption = 'Common Requisitions';
                Image = LotInfo;
                action("Stores Requisitions")
                {
                    ApplicationArea = Basic;
                    Caption = 'Stores Requisitions';
                    RunObject = Page "Store Requisition";
                    ToolTip = 'Executes the Stores Requisitions action.';
                }
                action("Staff Claim")
                {
                    ApplicationArea = Basic;
                    Caption = 'Staff Claim';
                    RunObject = Page "Staff Claim List";
                    ToolTip = 'Executes the Staff Claim action.';
                }
                action("Purchase Requisition")
                {
                    ApplicationArea = Basic;
                    Caption = 'Purchase Requisition';
                    RunObject = Page "Purchase Requisition";
                    ToolTip = 'Executes the Purchase Requisition action.';
                }
                action("Imprest Requisitions")
                {
                    ApplicationArea = Basic;
                    Caption = 'Imprest Requisitions';
                    RunObject = Page "Imprest List UP";
                    ToolTip = 'Executes the Imprest Requisitions action.';
                }
                action("Leave Applications")
                {
                    ApplicationArea = Basic;
                    Caption = 'Leave Applications';
                    RunObject = Page "HR Leave Application List";
                    ToolTip = 'Executes the Leave Applications action.';
                }
                action("My Approved Leaves")
                {
                    ApplicationArea = Basic;
                    Caption = 'My Approved Leaves';
                    Image = History;
                    RunObject = Page "HR Leave Posted List";
                    ToolTip = 'Executes the My Approved Leaves action.';
                }
            }
        }
    }
}

