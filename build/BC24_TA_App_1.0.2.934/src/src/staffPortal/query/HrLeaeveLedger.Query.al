namespace Hijra.Hijra;

query 50093 HrLeaveLedger
{
    Caption = 'HrLeaveLedger';
    QueryType = Normal;
    
    elements
    {
        dataitem(HRLeaveLedger; "HR Leave Ledger")
        {
            column(EmployeeNo; "Employee No")
            {
            }
            column(EntryNo; "Entry No.")
            {
            }
            column(DocumentNo; "Document No")
            {
            }
            column(LeaveType; "Leave Type")
            {
            }
            column(TransactionDate; "Transaction Date")
            {
            }
            column("TransactionType"; "Transaction Type")
            {
            }
            column(NoofDays; "No. of Days")
            {
            }
            column(TransactionDescription; "Transaction Description")
            {
            }
            column(LeavePeriod; "Leave Period")
            {
            }
            column(EntryType; "Entry Type")
            {
            }
            column(CreatedBy; "Created By")
            {
            }
            column(ReversedBy; "Reversed By")
            {
            }
            column(Closed; Closed)
            {
            }
            column(LeavePostingType; "Leave Posting Type")
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
