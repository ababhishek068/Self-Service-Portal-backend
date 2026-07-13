namespace PTL.HRMIS;
using Microsoft.Foundation.Company;

report 52202550 "HR Daily Attendance Summary"
{
    ApplicationArea = All;
    Caption = 'Attendance Daily Attendance Summary';
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Attendance/AttendanceSummary2.rdl';
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem("HR Attendance Ledger"; "HR Attendance Ledger")
        {
            RequestFilterFields = "Staff No.", "Date", "Global Dimension 1 Code";
            CalcFields = isHQItem;
            DataItemTableView = where(isHQItem = filter(false));

            column(CompInfo_Name; CompInfo.Name) { }
            column(CompInfo_Email; CompInfo."E-Mail") { }
            column(CompInfo_Address; CompInfo.Address) { }
            column(CompInfo_Picture; CompInfo.Picture) { }
            column(Staff_No_; "Staff No.")
            {
            }
            column(HoursWorked_HRAttendanceLedger; Round("Hours Worked", 1, '='))
            {
            }
            column(No_HRAttendanceLedger; "No.")
            {
            }
            column(GlobalDimension1Code_HRAttendanceLedger; "Global Dimension 1 Code")
            {
            }
            column(GlobalDimension2Code_HRAttendanceLedger; "Global Dimension 2 Code")
            {
            }
            // column(Market_HRAttendanceLedger; Market)
            // {
            // }
            column(PhoneNo_HRAttendanceLedger; "Phone No.")
            {
            }
            column(StaffName_HRAttendanceLedger; "Staff Name")
            {
            }
            column(LocationName_HRAttendanceLedger; "Location Name")
            {
            }
            column(SigninLocation_HRAttendanceLedger; "Signin Location")
            {
            }
            column(SignoutLocation_HRAttendanceLedger; "Signout Location")
            {
            }
            column(Date_HRAttendanceLedger; "Date")
            {
            }
            column(logindatetime_HRAttendanceLedger; "login date time")
            {
            }
            column(TimeIn_HRAttendanceLedger; Format("Time In"))
            {
            }
            column(Timeout_HRAttendanceLedger; Format("Time out"))
            {
            }
            column(SigninComments_HRAttendanceLedger; "Sign in Comments")
            {
            }
            column(SignoutComments_HRAttendanceLedger; "Sign out Comments")
            {
            }
            column(onleaveLbl; onleaveLbl)
            {
            }
            column(onLeave; onLeave)
            {
            }
            column(LeaveType; LeaveType)
            {
            }
            dataitem("HR-Employee"; "HR-Employee")
            {
                DataItemLink = "No." = field("Staff No.");
                //RequestFilterFields = "IsWaitingExit", "Status";
                
                column(No_HREmployee; "No.") { }
                column(FullName_HREmployee; "Full Name") { }
                //column(Project_Market_HREmployee; "Project Market") { }
                column(Cell_Phone_Number_HREmployee; "Cell Phone Number") { }
                column(E_Mail_HREmployee; "E-Mail") { }
                column(Gender; Gender) { }
                column(Tribe; Tribe) { }
                column(Date_Of_Joining_the_Company_HREmployee; "Date Of Joining the Company") { }
                column(ID_Number_HREmployee; "ID Number") { }
                column(Work_Phone_Number_HREmployee; "Work Phone Number") { }
                column(Company_E_Mail_HREmployee; "Company E-Mail") { }
                column(GlobalDimension1Code_HREmployee; "Global Dimension 1 Code") { }
                trigger OnPreDataItem()
                begin
                    //"HR-Employee".SetFilter(IsWaitingExit, '=%1', false);
                    "HR-Employee".SetFilter(Status, '=%1', "HR-Employee".Status::Active);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                // LoggedOutTxt := '';
                onLeave := 'Present';
                LoggedOutTxt := 'Absent';
                onleaveLbl := 'Reported';
                LeaveType := 'None';
                if not "HR Attendance Ledger"."Checked Out" then
                    LoggedOutTxt := 'Pending'
                else
                    LoggedOutTxt := 'Checked Out';

                if "HR Attendance Ledger"."Time In" = 0T then begin

                    onLeave := 'None';
                    onLeave := 'None';
                    onleaveLbl := 'Absent';
                    LeaveType := 'Absent';
                    LoggedOutTxt := 'Absent';

                    hrLeaveAllocation.Reset();
                    hrLeaveAllocation.SetRange("No.", "No.");
                    // hrLeaveAllocation.SetFilter(hrLeaveAllocation."Application End Date", '>%1', "HR Attendance Ledger".Date);
                    // hrLeaveAllocation.SetFilter(hrLeaveAllocation."Application start Date", '<%1', "HR Attendance Ledger".Date);
                    hrLeaveAllocation.SetRange("Entry Type", hrLeaveAllocation."Entry type"::"Negative Adjustment");
                    hrLeaveAllocation.SetRange("Posting Type", hrLeaveAllocation."posting type"::Normal);
                    if hrLeaveAllocation.Find('-') then begin
                        if (hrLeaveAllocation."Application End Date" >= "HR Attendance Ledger".Date) and (hrLeaveAllocation."Application Start Date" <= "HR Attendance Ledger".Date) then begin
                            onLeave := 'On Leave';
                            onleaveLbl := 'On Leave';
                            LeaveType := hrLeaveAllocation."Leave Type";
                        end;
                    end;
                end;
            end;
        }
    }
    requestpage
    {
        SaveValues = true;
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
    trigger OnPreReport()
    begin
        CompInfo.Get();
        CompInfo.CalcFields(CompInfo.Picture);
    end;

    var
        CompInfo: Record "Company Information";

        hrLeaveAllocation: Record "HR Leave Allocation";
        LoggedOutTxt: Code[20];
        LeaveType: Code[50];
        onLeave: Text[20];
        onleaveLbl: Text[20];
}
