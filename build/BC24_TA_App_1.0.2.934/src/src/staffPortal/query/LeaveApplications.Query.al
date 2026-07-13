namespace Hijra.Hijra;

query 50095 LeaveApplications
{
    Caption = 'LeaveApplications';
    QueryType = Normal;
    
    elements
    {
        dataitem(HRLeaveApplication; "HR Leave Application")
        {
            column(ApplicationCode; "Application Code")
            {
            }
            column(LeaveType; "Leave Type")
            {
            }
            column(DaysApplied; "Days Applied")
            {
            }
            column(StartDate; "Start Date")
            {
            }
            column(ReturnDate; "Return Date")
            {
            }
            column(ApplicationDate; "Application Date")
            {
            }
            column(Status; Status)
            {
            }
            column(NoSeries; "No Series")
            {
            }
            column(Posted; Posted)
            {
            }
            column(PostedBy; "Posted By")
            {
            }
            column(DatePosted; "Date Posted")
            {
            }
            column(TimePosted; "Time Posted")
            {
            }
            column(RequestLeaveAllowance; "Request Leave Allowance")
            {
            }
            column(UserID; "User ID")
            {
            }
            column(EmployeeNo; "Employee No.")
            {
            }
            column(SupervisorID; "Supervisor ID")
            {
            }
            column(ResponsibilityCenter; "Responsibility Center")
            {
            }
            column(Gender; Gender)
            {
            }
            column(AllocatedDays; "Allocated Days")
            {
            }
            column(ReimbursedDays; "Reimbursed Days")
            {
            }
            column(CurrentTotalLeaveTaken; "Current Total Leave Taken")
            {
            }
            column(CurrentLeaveBalance; "Current Leave Balance")
            {
            }
            column(EndDate; "End Date")
            {
            }
            column(Supervisor; Supervisor)
            {
            }
            column(SupervisorEMail; "Supervisor E-Mail")
            {
            }
            column(EmpoyeeName; "Empoyee Name")
            {
            }
            column(EarnedLeaveDays; "Earned Leave Days")
            {
            }
            column(HRUserID; "HR User ID")
            {
            }
            column(ApproverID; "Approver ID")
            {
            }
            column(Reasonforleave; "Reason for leave")
            {
            }
            column(Reliever; Reliever)
            {
            }
            column(RelieverName; "Reliever Name")
            {
            }
            column(Reversed; Reversed)
            {
            }
            column(ReversedBy; "Reversed By")
            {
            }
            column(ReversedDate; "Reversed Date")
            {
            }
            column(Department; Department)
            {
            }
            column(DepartmentName; "Department Name")
            {
            }
            column(IgnoreRespCenter; "Ignore Resp. Center")
            {
            }
            column(IsHOD; "Is HOD")
            {
            }
            column(GlobalDimension1Code; "Global Dimension 1 Code")
            {
            }
            column(ShortcutDimension2Code; "Shortcut Dimension 2 Code")
            {
            }
            column(ShortcutDimension3Code; "Shortcut Dimension 3 Code")
            {
            }
            column(ShortcutDimension4Code; "Shortcut Dimension 4 Code")
            {
            }
            column(Dim1; Dim1)
            {
            }
            column(Dim2; Dim2)
            {
            }
            column(Dim3; Dim3)
            {
            }
            column(Dim4; Dim4)
            {
            }
            column(ApprovalStatus; "Approval Status")
            {
            }
            column(FinalApproverStatus; "Final Approver Status")
            {
            }
            column(OpenApproverCount; "Open Approver Count")
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
