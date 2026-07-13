Report 50231 "Employee Leaves"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/EmployeeLeaves.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("HR-Employee"; "HR-Employee")
        {
            RequestFilterFields = "No.", "On Leave";
            column(ReportForNavId_1; 1) { }
            column(No_HREmployeeC; "HR-Employee"."No.") { }
            column(FirstName_HREmployeeC; "HR-Employee"."First Name") { }
            column(MiddleName_HREmployeeC; "HR-Employee"."Middle Name") { }
            column(LastName_HREmployeeC; "HR-Employee"."Last Name") { }
            column(LeaveBalance_HREmployeeC; "HR-Employee"."Leave Balance") { }
            dataitem("HR Leave Requisition"; "HR Leave Requisition")
            {
                DataItemLink = "Employee No" = field("No."), "No." = field("Current Leave No");
                column(ReportForNavId_7; 7) { }
                column(AppliedDays_HRLeaveRequisition; "HR Leave Requisition"."Applied Days") { }
                column(Date_HRLeaveRequisition; "HR Leave Requisition".Date) { }
                column(StartingDate_HRLeaveRequisition; "HR Leave Requisition"."Starting Date") { }
                column(EndDate_HRLeaveRequisition; "HR Leave Requisition"."End Date") { }
                column(LeaveType_HRLeaveRequisition; "HR Leave Requisition"."Leave Type") { }
                column(Purpose_HRLeaveRequisition; "HR Leave Requisition".Purpose) { }
            }
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }
}

