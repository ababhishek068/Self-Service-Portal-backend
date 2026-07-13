report 50338 "Generate Mass Invoices"
{
    UsageCategory = Administration;
    ApplicationArea = All;

    dataset
    {
        dataitem(Customer; Customer)
        {
            RequestFilterFields = "No.", "Customer Posting Group", "Charge Filter", "Date Filter";
            trigger OnAfterGetRecord()
            var
                GBill: Codeunit "Gen. Jnl.-Post B";
                Charge: Record Charge;
                PDate: date;
            begin
                if Customer.getfilter("Charge Filter") = '' then
                    error('Please select the Charge Filter');
                if Customer.getfilter("Date Filter") = '' then
                    error('Please select the Date Filter');
                Evaluate(Pdate, Customer.getfilter("Date Filter"));
                if Charge.get(Customer.getfilter("Charge Filter")) then
                    GBill.GenerateMassInvoice(Customer."No.", Customer.getfilter("Charge Filter"), Charge.Amount, pdate);
            end;
        }
    }
}