page 51386 "FORECOURT ROLECENTRE"
{
    PageType = RoleCenter;
    Caption = 'Fore Court Role Center';
    ApplicationArea = All;

    layout
    {
        area(rolecenter)
        {
            part(Headline; "FC Headline")
            {
                ApplicationArea = Basic, Suite;
            }

            part(Tanks; "Tanks Cue")
            {
                Caption = 'FUEL AVAILLABILTY';
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
                caption = 'Fore Court Management';
                action(Cust)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Customers';
                    Image = Employee;
                    RunObject = Page "Customer List FC";
                    ToolTip = 'Executes the Customers action.';
                }
                action(AllReg)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Pump Reading';
                    Image = Employee;
                    RunObject = Page "Pump Reading List";
                    ToolTip = 'Executes the Pump Reading action.';
                }


                action(Recipts)
                {

                    ApplicationArea = Basic, Suite;
                    Caption = 'Pump Attendance Receipts';
                    Image = Employee;
                    RunObject = Page "Receipts List FC";
                    ToolTip = 'Executes the Pump Attendance Receipts action.';
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
                    RunObject = Page "Sales Invoice List FC";
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

                action(ShiftAlloc)
                {

                    ApplicationArea = Basic, Suite;
                    Caption = 'Shift Allocation';
                    Image = Employee;
                    RunObject = Page "Shift Allocation List";
                    ToolTip = 'Executes the Shift Allocation action.';
                }
                action(BankTrans)
                {

                    ApplicationArea = Basic, Suite;
                    Caption = 'Mpesa Transactions';
                    Image = Employee;
                    RunObject = Page "Bank Transactions Buffer";
                    ToolTip = 'Executes the Mpesa Transactions action.';

                }
                action(InterBankTrans)
                {

                    ApplicationArea = Basic, Suite;
                    Caption = 'Inter Bank Transfer';
                    Image = Employee;
                    RunObject = Page "Interbank Transfer";
                    ToolTip = 'Executes the Inter Bank Transfer action.';

                }
            }
            group(StockManager)
            {
                caption = 'Stock Management';
                action(DepRequisition)
                {

                    ApplicationArea = Basic, Suite;
                    Caption = 'Fuel Receiving';
                    Image = Employee;
                    RunObject = Page "Transfer Orders FC";
                    ToolTip = 'Executes the Fuel Receiving action.';
                }
                action(pumpOut)
                {

                    ApplicationArea = Basic, Suite;
                    Caption = 'Pump Outs';
                    Image = Employee;
                    RunObject = Page "Sales Credit Memos FC";
                    ToolTip = 'Executes the Pump Outs action.';
                }
                action(ReturntoTank)
                {

                    ApplicationArea = Basic, Suite;
                    Caption = 'Return To Tank';
                    Image = Employee;
                    RunObject = Page "Return To Tank List";
                    ToolTip = 'Executes the Return To Tank action.';
                }
                action(Dipping)
                {

                    ApplicationArea = Basic, Suite;
                    Caption = 'Dipping';
                    Image = Employee;
                    RunObject = Page "Dipping List";
                    ToolTip = 'Executes the Dipping action.';
                }

            }

        }

        area(processing) { }
        area(sections)
        {
            group(JobsManamentGroup)
            {
                Caption = 'Setups';
                Image = HumanResources;

                action(ForeCourtSet)
                {
                    ApplicationArea = Basic, Suite;
                    Image = Setup;
                    Caption = 'ForeCourt Setup';
                    RunObject = Page "ForeCourt setup";
                    ToolTip = 'Executes the ForeCourt Setup action.';
                }
                action(StationList)
                {
                    ApplicationArea = Basic, Suite;
                    Image = Setup;
                    Caption = 'Stations';
                    RunObject = Page "ForeCourt Stations";
                    ToolTip = 'Executes the Stations action.';
                }
                action(JobsList)
                {
                    ApplicationArea = Basic, Suite;
                    Image = Setup;
                    Caption = 'Tanks Setup';
                    RunObject = Page Tanks;
                    ToolTip = 'Executes the Tanks Setup action.';
                }
                action(JobsList2)
                {
                    ApplicationArea = Basic, Suite;
                    Image = Setup;
                    Caption = 'Pump Setup';
                    RunObject = Page Pumps;
                    ToolTip = 'Executes the Pump Setup action.';
                }
                action(JobsList4)
                {
                    ApplicationArea = Basic, Suite;
                    Image = Setup;
                    Caption = 'Pump Attendance';
                    RunObject = Page "Pump Attendance";
                    ToolTip = 'Executes the Pump Attendance action.';
                }
                action(Fuel)
                {
                    ApplicationArea = Basic, Suite;
                    Image = JobListSetup;
                    Caption = 'Fuel Type';
                    RunObject = Page "Fuel Type";
                    ToolTip = 'Executes the Fuel Type action.';
                }
                action(FuelPricing)
                {
                    ApplicationArea = Basic, Suite;
                    Image = JobListSetup;
                    Caption = 'Fuel Branch Price Setup';
                    RunObject = Page "Fuel Branch Pricing";
                    ToolTip = 'Executes the Fuel Branch Price Setup action.';
                }

            }
            group(Posted)
            {
                Caption = 'Posted Documents';
                action(PostedReading)
                {
                    ApplicationArea = Basic, Suite;
                    Image = JobListSetup;
                    Caption = 'Posted Pump Reading';
                    RunObject = Page "Pump Reading Posted List";
                    ToolTip = 'Executes the Posted Pump Reading action.';
                }
                action(PostedShift)
                {
                    ApplicationArea = Basic, Suite;
                    Image = JobListSetup;
                    Caption = 'Posted Shift';
                    RunObject = Page "Shift Allocation Posted List";
                    ToolTip = 'Executes the Posted Shift action.';
                }
                action(PostedDipp)
                {
                    ApplicationArea = Basic, Suite;
                    Image = JobListSetup;
                    Caption = 'Posted Dipping';
                    RunObject = Page "Dipping Posted List";
                    ToolTip = 'Executes the Posted Dipping action.';
                }
                action(PostedReturn)
                {
                    ApplicationArea = Basic, Suite;
                    Image = JobListSetup;
                    Caption = 'Posted Return to Tank';
                    RunObject = Page "Return To Tank Posted List";
                    ToolTip = 'Executes the Posted Return to Tank action.';
                }
                action(PostedReceipt)
                {
                    ApplicationArea = Basic, Suite;
                    Image = JobListSetup;
                    Caption = 'Posted Receipt';
                    RunObject = Page "Posted Receipts";
                    ToolTip = 'Executes the Posted Receipt action.';
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

        }

        area(Reporting)
        {

            Group(Reports)
            {
                Caption = 'Reports';

                action(PayrollCompanyPayslip)
                {
                    Caption = 'Tank Inventory Report';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "Tank Inventory";
                    ToolTip = 'Executes the Tank Inventory Report action.';
                }
                action(AttendanceSales)
                {
                    Caption = 'Attendance Sales Report';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "Attendance Sales Report";
                    ToolTip = 'Executes the Attendance Sales Report action.';
                }
                action(PumpAttendance)
                {
                    Caption = 'Pump Reading Template';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "Pump Reading Report";
                    ToolTip = 'Executes the Pump Reading Template action.';
                }
                action(PumpReading)
                {
                    Caption = 'Pump Reading Report';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "Pump Reading Complete Report";
                    ToolTip = 'Executes the Pump Reading Report action.';
                }

                action(ShiftReport)
                {
                    Caption = 'Shift Report';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "Shift Allocation Report";
                    ToolTip = 'Executes the Shift Report action.';
                }
                action(ShiftSales)
                {
                    Caption = 'Shift Sale Report';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "Staff Sales Report";
                    ToolTip = 'Executes the Shift Sale Report action.';
                }
                action(StationReport)
                {
                    Caption = 'Station Report';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "Station Summary";
                    ToolTip = 'Executes the Station Report action.';
                }
                action(ReadingAttendantReport)
                {
                    Caption = 'Pump Reading Attendant Report';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "Pump Reading Attendant Report";
                    ToolTip = 'Executes the Pump Reading Attendant Report action.';
                }

                action(DetailedSalesReport)
                {
                    Caption = 'Detailed Sales Report';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "Sales Details Report";
                    ToolTip = 'Executes the Detailed Sales Report action.';
                }
                action(CollectionsReport)
                {
                    Caption = 'Collections Report';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "Receipts Collections2";
                    ToolTip = 'Executes the Collections Report action.';
                }
                action(SalesByItem)
                {
                    Caption = 'Sales By Item Report';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "Sales Per Item Summary";
                    ToolTip = 'Executes the Sales By Item Report action.';
                }
                action(SalesByCustomer)
                {
                    Caption = 'Sales By Customer Report';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "Sales By Customer Details";
                    ToolTip = 'Executes the Sales By Customer Report action.';
                }
                action(SalesByStation)
                {
                    Caption = 'Sales By Station Report';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "Sales By Station Details";
                    ToolTip = 'Executes the Sales By Station Report action.';
                }



            }


        }
    }
}



