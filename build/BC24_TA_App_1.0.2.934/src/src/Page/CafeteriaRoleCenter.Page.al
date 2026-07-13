Page 50911 "Cafeteria Role Center"
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
                part(Control60; "Headline RC General Mgt.")
                {
                    ApplicationArea = RelationshipMgmt;
                }
                // part(Control8; "Food Menu List")
                // {
                //     Caption = 'Food Menu List';
                //     Visible = true;
                // }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("General Setups")
            {
                Caption = 'Setups';
                action(Meals)
                {
                    ApplicationArea = Basic;
                    Caption = 'Meals Setup';
                    Image = FixedAssets;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Meals Setup List";
                    ToolTip = 'Executes the Meals Setup action.';
                }
                action(GenSet)
                {
                    ApplicationArea = Basic;
                    Caption = 'Catering Setups';
                    Image = FixedAssetLedger;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Menu Sales SetUp";
                    ToolTip = 'Executes the Catering Setups action.';
                }
                action("Meals Inventory")
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales Points';
                    Image = Calendar;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Sales Point List";
                    ToolTip = 'Executes the Sales Points action.';
                }

                action("Daily Menu")
                {
                    ApplicationArea = Basic;
                    Image = GeneralPostingSetup;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Page "Daily Menu";
                    ToolTip = 'Executes the Daily Menu action.';
                }
                action("Food Menu Card")
                {
                    ApplicationArea = Basic;
                    Image = Category;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Page "Food Menu Card";
                    ToolTip = 'Executes the Food Menu Card action.';
                }
            }
        }
        area(embedding)
        {
            action("Student Food Menu")
            {
                ApplicationArea = Basic;
                RunObject = Page "HTL-Food Menu List";
                ToolTip = 'Executes the Student Food Menu action.';
            }
            action(FoodSales)
            {
                ApplicationArea = Basic;
                Caption = 'Food Sales';
                Image = Sales;
                RunObject = Page "Menu Sales List";
                ToolTip = 'Executes the Food Sales action.';
            }
            action(PostedFoodSales)
            {
                ApplicationArea = Basic;
                Caption = 'Posted Food Sales';
                Image = History;
                RunObject = Page "Menu Sales List-Posted";
                ToolTip = 'Executes the Posted Food Sales action.';
            }
        }
        area(sections)
        {
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
                action(MyApprovedLeaves)
                {
                    ApplicationArea = Basic;
                    Caption = 'My Approved Leaves';
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
        }
        area(reporting)
        {
            group(Periodic)
            {
                Caption = 'Periodic Reports';
                action("Report Catering Daily Summary S")
                {
                    ApplicationArea = Basic;
                    Caption = 'Catering Daily SUmmary Sales';
                    Image = Report2;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = true;
                    RunObject = Report "Catering Daily Summary Sales";
                    ToolTip = 'Executes the Catering Daily SUmmary Sales action.';
                }
                action("Catering Sales Per Items")
                {
                    ApplicationArea = Basic;
                    Image = Report2;
                    Promoted = false;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = false;
                    RunObject = Report "Catering Sales Per Items";
                    ToolTip = 'Executes the Catering Sales Per Items action.';
                }
                action("Report Catering Sales Summary")
                {
                    ApplicationArea = Basic;
                    Caption = 'Summary Sales Report';
                    Image = PrintReport;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = true;
                    RunObject = Report "Catering Sales Summary";
                    ToolTip = 'Executes the Summary Sales Report action.';
                }
                action("Daily Sales Summary (All)")
                {
                    ApplicationArea = Basic;
                    Image = Report2;
                    RunObject = Report "Daily Sales Summary (All)";
                    ToolTip = 'Executes the Daily Sales Summary (All) action.';
                }


                action("CASHIER DAILY REPORT")
                {
                    ApplicationArea = Basic;
                    Caption = 'CASHIER DAILY REPORT';
                    Image = "Report";
                    RunObject = Report "CASHIER DAILY REPORT";
                    ToolTip = 'Executes the CASHIER DAILY REPORT action.';
                }
            }
        }
    }
}

