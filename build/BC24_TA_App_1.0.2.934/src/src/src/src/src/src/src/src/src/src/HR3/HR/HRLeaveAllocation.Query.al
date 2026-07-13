query 50032 "HR Leave Allocation"
{
    QueryType = Normal;

    elements
    {
        dataitem(HRLeaveAllocation; "HR Leave Allocation")
        {
            column(ApplicationEndDate; "Application End Date") { }
            column(ApplicationReturnDate; "Application Return Date") { }
            column(ApplicationStartDate; "Application Start Date") { }
            column(CalendarCode; "Calendar Code") { }
            column(CalendarEndDate; "Calendar End Date") { }
            column(CalendarStartDate; "Calendar Start Date") { }
            column(GlobalDimension1Code; "Global Dimension 1 Code") { }
            column(GlobalDimension2Code; "Global Dimension 2 Code") { }
            column(LeaveType; "Leave Type") { }
            column(NoOfdays; "No. Of days") { }
            column(PostingDate; "Posting Date") { }
            column(StaffName; "Staff Name") { }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
