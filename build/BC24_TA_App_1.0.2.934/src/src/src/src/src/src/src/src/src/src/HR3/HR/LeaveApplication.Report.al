report 50362 "Leave Application"
{
    ApplicationArea = All;
    Caption = 'Leave Application';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = Word;
    WordLayout = './Layouts/Leaveapplications.docx';
    dataset
    {
        dataitem(HRLeaveApplication; "HR Leave Application")
        {
            column(ApplicationCode; "Application Code")
            {
            }
            column(ApplicationDate; format("Application Date", 0, '<Closing><Day,2>/<Month,2>/<Year,4>'))
            {
            }

            column(AllocatedDays; "Allocated Days")
            {
            }
            column(Current_Leave_Balance; "Current Leave Balance")
            {
            }
            column(DaysApplied; "Days Applied")
            {
            }
            column(Department; Department)
            {
            }
            column(DepartmentName; "Department Name")
            {
            }
            column(EmployeeNo; "Employee No.")
            {
            }
            column(EmpoyeeName; "Empoyee Name")
            {
            }
            column(EndDate;format("End Date", 0, '<Closing><Day,2>/<Month,2>/<Year,4>'))
            {
            }
            column(LeaveType; "Leave Type")
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
            column(StartDate; format("Start Date", 0, '<Closing><Day,2>/<Month,2>/<Year,4>'))
            {
            }
            column(ReturnDate; format("Return Date", 0, '<Closing><Day,2>/<Month,2>/<Year,4>'))
            {
            }
            column(idno;idno){}
            trigger OnAfterGetRecord()
                var
                hremployee: record  "HR-Employee";
                begin
                    hremployee.Reset;
                    hremployee.SetRange(hremployee."No.","Employee No.");
                    if hremployee.FindFirst() then begin
                        idno:=hremployee."ID Number";
                    end;

                end;
        }
        
    }
    var
    idno: code[30];
}

    
    
