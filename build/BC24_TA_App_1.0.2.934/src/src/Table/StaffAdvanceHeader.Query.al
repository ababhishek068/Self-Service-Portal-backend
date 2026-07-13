namespace Hijra.Hijra;

query 50110 "Staff Advance Header"
{
    Caption = 'Staff Advance Header';
    QueryType = Normal;
    
    elements
    {
        dataitem(StaffAdvanceHeader; "Staff Advance Header")
        {
            column(No; "No.")
            {
            }
            column("Date"; "Date")
            {
            }
            column(Status; Status)
            {
            }
            column(StaffID; "Staff ID")
            {
            }
            column(CustomerNo; "Customer No")
            {
            }
            column(AccountNo; "Account No.")
            {
            }
            column(SystemId; SystemId)
            {
            }
            column(Purpose; Purpose)
            {
            }
        }
    }
    
    trigger OnBeforeOpen()
    begin
    
    end;
}
