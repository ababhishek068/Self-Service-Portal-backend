namespace Hijra.Hijra;

query 50098 "Payroll periods"
{
    Caption = 'Payroll periods';
    QueryType = Normal;
    
    elements
    {
        dataitem(PRPayrollPeriods; "PR Payroll Periods")
        {
            column(PeriodMonth; "Period Month")
            {
            }
            column(PeriodYear; "Period Year")
            {
            }
            column(PeriodName; "Period Name")
            {
            }
            column(DateOpened; "Date Opened")
            {
            }
            column(DateClosed; "Date Closed")
            {
            }
            column(Closed; Closed)
            {
            }
            column(ClosedBy; "Closed By")
            {
            }
            column(OpenedBy; "Opened By")
            {
            }
            column(AllowViewPayslip; "Allow View Payslip?")
            {
            }
            column(ProrationDone; "Proration Done")
            {
            }
            column(ApprovalStatus; "Approval Status")
            {
            }
            column(DateApproved; "Date Approved")
            {
            }
            column(SystemId; SystemId)
            {
            }
        }
    }
    
    trigger OnBeforeOpen()
    begin
    
    end;
}
