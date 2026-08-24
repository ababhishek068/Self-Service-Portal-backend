enum 52101 "Portal Exit Request Status"
{
    Extensible = false;

    value(0; Open)
    {
        Caption = 'Open';
    }
    value(1; PendingApproval)
    {
        Caption = 'Pending Approval';
    }
    value(2; Approved)
    {
        Caption = 'Approved';
    }
    value(3; Rejected)
    {
        Caption = 'Rejected';
    }
    value(4; CancellationPending)
    {
        Caption = 'Cancellation Pending Approval';
    }
    value(5; Cancelled)
    {
        Caption = 'Cancelled';
    }
    value(6; Completed)
    {
        Caption = 'Completed';
    }
    // Second approval stage per the bank's SSP templates (17-07-2026): immediate supervisor
    // first, then HR. This caption is the contract with the portal — do not translate.
    value(7; PendingHRApproval)
    {
        Caption = 'Pending HR Approval';
    }
}
