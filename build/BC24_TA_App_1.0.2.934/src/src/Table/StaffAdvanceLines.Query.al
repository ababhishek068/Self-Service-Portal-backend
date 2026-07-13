namespace Hijra.Hijra;

query 50111 "Staff Advance Lines"
{
    Caption = 'Staff Advance Lines';
    QueryType = Normal;
    
    elements
    {
        dataitem(StaffAdvanceLines; "Staff Advance Lines")
        {
            column(No; No)
            {
            }
            column(AccountNo; "Account No:")
            {
            }
            column(AccountName; "Account Name")
            {
            }
            column(Amount; Amount)
            {
            }
            column(DueDate; "Due Date")
            {
            }
            column(AdvanceHolder; "Advance Holder")
            {
            }
            column(PercentageofSalary; "Percentage of Salary")
            {
            }
            column(SurrenderDate; "Surrender Date")
            {
            }
            column(Surrendered; Surrendered)
            {
            }
            column(DateIssued; "Date Issued")
            {
            }
            column(SurrenderDocNo; "Surrender Doc No.")
            {
            }
            column(DateTaken; "Date Taken")
            {
            }
            column(Purpose; Purpose)
            {
            }
            column(AdvanceType; "Advance Type")
            {
            }
            column(LineNo; "Line No.")
            {
            }
            column(ClaimReceiptNo; "Claim Receipt No")
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
