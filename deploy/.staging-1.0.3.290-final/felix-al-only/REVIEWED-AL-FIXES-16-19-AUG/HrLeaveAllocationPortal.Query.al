namespace Hijra.Hijra;

/// <summary>
/// OData fallback for portal leave-balance when CuPortalEmployeeData is unavailable.
/// Publish as web service QyHrLeaveAllocationPortal.
/// </summary>
query 52133 "Hr Leave Allocation Portal"
{
    Caption = 'Hr Leave Allocation Portal';
    QueryType = Normal;

    elements
    {
        dataitem(HRLeaveAllocation; "HR Leave Allocation")
        {
            column(EmployeeNo; "No.")
            {
            }
            column(CalendarCode; "Calendar Code")
            {
            }
            column(LeaveType; "Leave Type")
            {
            }
            column(EntryType; "Entry Type")
            {
            }
            column(PostingType; "Posting Type")
            {
            }
            column(NoOfDays; "No. Of days")
            {
            }
            column(Closed; Closed)
            {
            }
            column(Posted; Posted)
            {
            }
            column(SystemId; SystemId)
            {
            }
        }
    }
}
