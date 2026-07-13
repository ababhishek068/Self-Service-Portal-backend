query 50071 "User Setup"
{
    Caption = 'User Setup';
    QueryType = Normal;

    elements
    {
        dataitem(UserSetup; "User Setup")
        {
            column(UserID; "User ID") { }
            column(UserName; UserName) { }
            column(EmployeeNo; "Employee No.") { }
            column(SystemId; SystemId) { }
            column(ImprestAccount; "Imprest Account") { }
            column(ImprestAmountApprovalLimit; "Imprest Amount Approval Limit") { }
            column(ImprestSurrAmtApprovalLimit; "ImprestSurr Amt Approval Limit") { }
            column(UnlimitedImprestAmtApproval; "Unlimited Imprest Amt Approval") { }
            column(UnlimitedImprestSurrAmtAppr; "Unlimited ImprestSurr Amt Appr") { }
            column(CashAdvanceStaffAccount; "Cash Advance Staff Account") { }
            column(OtherAdvanceStaffAccount; "Other Advance Staff Account") { }
            column(StaffTravelAccount; "Staff Travel Account") { }
            column(ApproverID; "Approver ID") { }
            column(EMail; "E-Mail") { }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
