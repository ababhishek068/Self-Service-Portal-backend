page 50063 "Direct Voucher Role Center"
{
    Caption = 'Direct Voucher Module Role Center';
    PageType = RoleCenter;
    ApplicationArea = All;

    layout
    {
        area(rolecenter)
        {
            group(Control1900724808)
            {
                ShowCaption = false;
                part(Control60; "Headline RC General Mgt.")
                {
                    ApplicationArea = RelationshipMgmt;
                }

                part(Control1902304208; "Funds Management Activities")
                {
                    ApplicationArea = all;
                }
                part(Control99; "Finance Performance")
                {
                    ApplicationArea = all;
                    // Visible = false;
                }
                systempart(Control1901420308; Outlook) { }
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
        area(reporting)
        {
            group(Reports)
            {
                Caption = 'Reports';

                action("ImprestRegister")
                {
                    Caption = 'Direct Voucher List';
                    Image = "Report";
                    RunObject = Report "Direct Voucher List";
                    ApplicationArea = all;
                    ToolTip = 'Executes the Direct Voucher List action.';
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
                action("Purchase Requisition")
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


            }




            group(Admininistration)
            {
                Caption = 'Administration';
                //IsHeader = true;

                action("General &Ledger Setup")
                {
                    Caption = 'General &Ledger Setup';
                    ApplicationArea = all;
                    Image = Setup;
                    RunObject = Page "General Ledger Setup";
                    ToolTip = 'Executes the General &Ledger Setup action.';
                }
                action("&Sales && Receivables Setup")
                {
                    Caption = '&Sales && Receivables Setup';
                    ApplicationArea = all;
                    Image = Setup;
                    RunObject = Page "Sales & Receivables Setup";
                    ToolTip = 'Executes the &Sales && Receivables Setup action.';
                }
                action("&Purchases && Payables Setup")
                {
                    Caption = '&Purchases && Payables Setup';
                    ApplicationArea = all;
                    Image = Setup;
                    RunObject = Page "Purchases & Payables Setup";
                    ToolTip = 'Executes the &Purchases && Payables Setup action.';
                }
                action("Cash Office Setup")
                {
                    Caption = 'Cash Office Setup';
                    ApplicationArea = all;
                    Image = Setup;
                    RunObject = Page "Cash Office Setup UP";
                    ToolTip = 'Executes the Cash Office Setup action.';
                }
                action("Cash Office Templates")
                {
                    Caption = 'Cash Office Templates';
                    ApplicationArea = all;
                    Image = Setup;
                    RunObject = Page "Cash Office User Template UP";
                    ToolTip = 'Executes the Cash Office Templates action.';
                }
            }
            group(History)
            {
                Caption = 'History';
                //  IsHeader = true;

                action("Navi&gate")
                {
                    Caption = 'Navi&gate';
                    ApplicationArea = all;
                    Image = Navigate;
                    RunObject = Page Navigate;
                    ToolTip = 'Executes the Navi&gate action.';
                }
            }

            group(Payables)
            {
                action(PurchOrder)
                {
                    Caption = 'Purchase Order';
                    ApplicationArea = all;
                    RunObject = Page "Purchase Order List";
                    ToolTip = 'Executes the Purchase Order action.';

                }
                action(PurchInvoice)
                {
                    Caption = 'Purchase Invoice';
                    ApplicationArea = all;
                    RunObject = Page "Purchase Invoices";
                    ToolTip = 'Executes the Purchase Invoice action.';

                }
                action(PurchCredit)
                {
                    Caption = 'Purchase Credit Memo';
                    ApplicationArea = all;
                    RunObject = Page "Purchase Credit Memos";
                    ToolTip = 'Executes the Purchase Credit Memo action.';

                }
            }
            group(FinanceOperation)

            {
                Caption = 'Finance Operations';

                action("InterBank Transfer")
                {
                    Caption = 'Direct Voucher List';
                    ApplicationArea = all;
                    RunObject = Page "Direct Voucher List GreenCom";
                    ToolTip = 'Executes the Direct Voucher List action.';
                }
                action("Vote Transfer")
                {
                    Caption = 'Posted Direct Voucher List';
                    ApplicationArea = all;
                    RunObject = Page "Direct Voucher List GreenCom";
                    RunPageView = where(Posted = Const(true));
                    ToolTip = 'Executes the Posted Direct Voucher List action.';
                }
            }
        }
    }
}


