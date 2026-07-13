page 50959 "Sales RoleCenter"
{
    PageType = RoleCenter;
    Caption = 'Sales Role Center';
    ApplicationArea = All;

    layout
    {
        area(rolecenter)
        {
            part(Headline; "FC Headline")
            {
                ApplicationArea = Basic, Suite;
            }


            group(Control1900724808)
            {
                ShowCaption = false;
                part("My Approval Entries"; "Requests to Approve")
                {
                    ApplicationArea = basic;
                    Caption = 'My Approval Entries';
                }

                part(Control46; "Team Member Activities No Msgs")
                {
                    ApplicationArea = Suite;
                }
            }

        }
    }

    actions
    {
        area(embedding)
        {
            group(Recruit)
            {
                caption = 'Sales Management';
                action(Cust)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Customers';
                    Image = Employee;
                    RunObject = Page "Customer List FC";
                    ToolTip = 'Executes the Customers action.';
                }





                action(Recipts2)
                {

                    ApplicationArea = Basic, Suite;
                    Caption = 'Customer Receipts';
                    Image = Employee;
                    RunObject = Page "Receipts List";
                    ToolTip = 'Executes the Customer Receipts action.';
                }
                action(Invoice)
                {

                    ApplicationArea = Basic, Suite;
                    Caption = 'Invoice';
                    Image = Employee;
                    RunObject = Page "Sales Invoice List";
                    ToolTip = 'Executes the Invoice action.';
                }

                action(PettCash)
                {

                    ApplicationArea = Basic, Suite;
                    Caption = 'Petty Cash';
                    Image = Employee;
                    RunObject = Page "Petty Cash";
                    ToolTip = 'Executes the Petty Cash action.';
                }



                action(InterBankTrans)
                {

                    ApplicationArea = Basic, Suite;
                    Caption = 'Inter Bank Transfer';
                    Image = Employee;
                    RunObject = Page "Interbank Transfer";
                    ToolTip = 'Executes the Inter Bank Transfer action.';

                }
                action(TransferOrder)
                {

                    ApplicationArea = Basic, Suite;
                    Caption = 'Transfer Order';
                    Image = Employee;
                    RunObject = Page "Transfer Orders";
                    ToolTip = 'Executes the Transfer Order action.';

                }
            }

            group(Posted)
            {
                Caption = 'Posted Documents';



                action(PostedReceipt)
                {
                    ApplicationArea = Basic, Suite;
                    Image = JobListSetup;
                    Caption = 'Posted Receipt';
                    RunObject = Page "Posted Receipts";
                    ToolTip = 'Executes the Posted Receipt action.';
                }
                action("Posted Sales Invoices Cash")
                {
                    Caption = 'Posted Cash Sales';
                    ApplicationArea = all;
                    Image = PostedOrder;
                    RunObject = Page "Posted Sales Invoices Cash";
                    ToolTip = 'Executes the Posted Cash Sales action.';

                }
                action(PostedInterbank)
                {
                    ApplicationArea = Basic, Suite;
                    Image = JobListSetup;
                    Caption = 'Posted Interbank';
                    RunObject = Page "Posted Interbank Transfer List";
                    ToolTip = 'Executes the Posted Interbank action.';
                }
                action(PostedPettyCash)
                {
                    ApplicationArea = Basic, Suite;
                    Image = JobListSetup;
                    Caption = 'Posted Petty Cash';
                    RunObject = Page "Posted Payment Vouchers";
                    ToolTip = 'Executes the Posted Petty Cash action.';
                }
                action(PostedSalesInv)
                {
                    ApplicationArea = Basic, Suite;
                    Image = JobListSetup;
                    Caption = 'Posted Sales Invoice';
                    RunObject = Page "Posted Sales Invoices";
                    ToolTip = 'Executes the Posted Sales Invoice action.';
                }
            }

            Group(Reports)
            {
                Caption = 'Reports';


                action(DetailedSalesReport)
                {
                    Caption = 'Customer Sales Report';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "Sales Details Report";
                    ToolTip = 'Executes the Customer Sales Report action.';
                }
                action(DetailedSalesReport1)
                {
                    Caption = 'Weekly Lube Sales Report';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "Sales Details Report1";
                    ToolTip = 'Executes the Weekly Lube Sales Report action.';
                }

                action(CollectionsReport)
                {
                    Caption = 'Collections Report';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "Receipts Collections2";
                    ToolTip = 'Executes the Collections Report action.';
                }



            }

        }


    }
}



