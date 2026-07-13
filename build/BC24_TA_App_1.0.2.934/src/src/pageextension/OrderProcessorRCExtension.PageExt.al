pageextension 50007 "Order Processor RC Extension" extends "Order Processor Role Center"
{
    actions
    {
        addfirst(sections)
        {
            group(Workplan)
            {
                Caption = 'Workplan';
                Image = Administration;

                action(SourceOfWPAFunds)
                {
                    Caption = 'Source of WP Funds';
                    Image = BankAccountLedger;
                    ApplicationArea = all;
                    RunObject = page "Source of WP Funds";
                    ToolTip = 'Executes the Source of WP Funds action.';
                }

                action(ProcurementMethodsAction)
                {
                    Caption = 'Procurment Methods';
                    Image = Customer;
                    ApplicationArea = all;
                    RunObject = page "Procurement Methods List";
                    RunPageMode = Edit;
                    ToolTip = 'Executes the Procurment Methods action.';
                }

                action(DepartmentalWorkplanAction)
                {
                    Caption = 'Departmental Workplans';
                    Image = Customer;
                    ApplicationArea = all;
                    RunObject = page "Workplan List";
                    ToolTip = 'Executes the Departmental Workplans action.';
                }



                action(ConsolidatedWorkplan)
                {
                    Caption = 'Consolidated WP Activities';
                    Image = Customer;
                    ApplicationArea = all;
                    RunObject = Page "Consolidated WP Activities";
                    ToolTip = 'Executes the Consolidated WP Activities action.';
                }

                action(GlobalWorkplan)
                {
                    ApplicationArea = All;
                    Caption = 'Company Workplan List';
                    Image = VendorPaymentJournal;
                    RunObject = page "Company Workplan List";
                    ToolTip = 'Executes the Company Workplan List action.';
                }

            }
        }
    }

    var
}