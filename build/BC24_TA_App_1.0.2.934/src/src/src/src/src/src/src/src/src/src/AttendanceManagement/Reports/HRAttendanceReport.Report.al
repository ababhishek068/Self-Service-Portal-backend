namespace PTL.HRMIS;

using Microsoft.Foundation.Company;
using Microsoft.Finance.Dimension;

report 52202540 "HR Attendance Report"
{
    ApplicationArea = All;
    Caption = 'HR Attendance Report';
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HrAttendanceSummary.rdl';
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem(HREmployee; "HR-Employee")
        {
            DataItemTableView = where(Status = filter("Active"));
            RequestFilterFields = "Global Dimension 1 Code", "Global Dimension 2 Code", "Date Filter";

            column(No; "No.") { }
            
            column(FullName; "Full Name") { }
            //column(Project_Market; "Project Market") { }
            column(Cell_Phone_Number; "Cell Phone Number") { }
            column(E_Mail; "E-Mail") { }
            column(Gender; Gender) { }
            column(Tribe; Tribe) { }
            column(Region; Region) { }
            column(Grade; Grade) { }
            column(Contract_Type; "Contract Type") { }
            column(Contract_End_Date; "Contract End Date") { }
           // column(AUUID_No_;"AUUID No."){}
            column(Citizenship;Citizenship){}
            column(Responsibility_Center;"Responsibility Center"){}
            column(Job_Title;"Job Title"){}
            //column(Line_Manger_Names;"Line Manger Names"){}
            column(Date_Of_Joining_the_Company; "Date Of Joining the Company") { }
            column(ID_Number; "ID Number") { }
            column(Work_Phone_Number; "Work Phone Number") { }
            column(Company_E_Mail; "Company E-Mail") { }
            column(GlobalDimension1Code; "Global Dimension 1 Code") { }
            column(DimDesciption; DimDesciption) { }
            column(GlobalDimension2Code; "Global Dimension 2 Code") { }
            column(Date_Of_Birth; "Date Of Birth") { }
            column(CompInfo_Name; CompInfo.Name) { }
            column(CompInfo_Email; CompInfo."E-Mail") { }
            column(CompInfo_Address; CompInfo.Address) { }
            column(CompInfo_Picture; CompInfo.Picture) { }
            column(onleaveLbl; onleaveLbl)
            {
            }
            column(LeaveType; LeaveType)
            {
            }
            column(DateFil; DateFil)
            {
            }
            column(LocationName; SigninLocationName)
            {
            }
            column(SignOutLocationName; SignOutLocationName)
            {
            }
            column(timeIn; format(timeIn))
            {
            }
            column(timeOut; Format(timeOut))
            {
            }
            column(StaffNo; StaffNo)
            {
            }
            column(hoursWorked; hoursWorked)
            {
            }
            column(LoggedOutTxt; LoggedOutTxt)
            {
            }
            column(loginDatetime; loginDatetime)
            {
            }
            trigger OnPreDataItem()
            begin
                if DateFil = 0D then
                    Error('please select Attendance Date');
            end;

            trigger OnAfterGetRecord()
            begin

                onLeave := false;
                onleaveLbl := 'Absent';
                LeaveType := 'Absent';
                LoggedOutTxt := 'Absent';
                Att_Date := 0D;
                SigninLocationName := '-';
                SignOutLocationName := '-';
                timeIn := 0T;
                timeOut := 0T;
                hoursWorked := 0;
                loginDatetime := 0DT;

                // DateFil := HREmployee.GetFilter("Date Filter");

                HrAttendanceLedger.Reset();
                HrAttendanceLedger.SetRange("Staff No.", HREmployee."No.");
                HrAttendanceLedger.SetRange(Date, DateFil);
                if HrAttendanceLedger.FindFirst() then begin
                    // Attendance Details
                    Att_Date := HrAttendanceLedger.Date;
                    SigninLocationName := HrAttendanceLedger."Signin Location";
                    SignOutLocationName := HrAttendanceLedger."Signout Location";
                    timeIn := HrAttendanceLedger."Time In";
                    timeOut := HrAttendanceLedger."Time out";
                    hoursWorked := HrAttendanceLedger."Hours Worked";
                    onLeave := false;


                    case HrAttendanceLedger."Entry Type" of
                        HrAttendanceLedger."Entry Type"::Absence:
                            begin
                                onLeave := false;
                                onleaveLbl := 'Absent';
                                LeaveType := 'Absent';
                                LoggedOutTxt := 'Absent';
                                Att_Date := 0D;
                                SigninLocationName := '-';
                                SignOutLocationName := '-';
                                timeIn := 0T;
                                timeOut := 0T;
                                hoursWorked := 0;

                            end;
                        HrAttendanceLedger."Entry Type"::Present:
                            begin
                                onleaveLbl := 'Present';

                                LeaveType := 'None';
                                loginDatetime := HrAttendanceLedger."login date time";

                                if not HrAttendanceLedger."Checked Out" then
                                    LoggedOutTxt := 'Pending'
                                else
                                    LoggedOutTxt := 'Checked Out';

                            end;
                        HrAttendanceLedger."Entry Type"::"On Leave":
                            begin
                                hrLeaveAllocation.Reset();
                                hrLeaveAllocation.SetRange("No.", "No.");
                                hrLeaveAllocation.SetRange("Entry Type", hrLeaveAllocation."Entry type"::"Negative Adjustment");
                                hrLeaveAllocation.SetRange("Posting Type", hrLeaveAllocation."posting type"::Normal);
                                hrLeaveAllocation.SetRange(Posted, true);
                                hrLeaveAllocation.SetFilter(hrLeaveAllocation."Application End Date", '>=%1', HrAttendanceLedger.Date);
                                hrLeaveAllocation.SetFilter(hrLeaveAllocation."Application start Date", '<=%1', HrAttendanceLedger.Date);
                                if hrLeaveAllocation.FindFirst() then begin
                                    onLeave := true;
                                    onleaveLbl := 'On Leave';
                                    LoggedOutTxt := 'On Leave';
                                    LeaveType := hrLeaveAllocation."Leave Type";
                                end;
                            end;

                    end;

                end else begin
                    //Check if employee is on Leave and get details
                    hrLeaveAllocation.Reset();
                    // hrLeaveAllocation.SetLoadFields("No.", "Posting Date", "Entry Type", "Posting Type");
                    hrLeaveAllocation.SetRange("No.", "No.");
                    hrLeaveAllocation.SetFilter(hrLeaveAllocation."Application End Date", '>=%1', DateFil);
                    hrLeaveAllocation.SetFilter(hrLeaveAllocation."Application start Date", '<=%1', DateFil);
                    hrLeaveAllocation.SetRange("Entry Type", hrLeaveAllocation."Entry type"::"Negative Adjustment");
                    hrLeaveAllocation.SetRange("Posting Type", hrLeaveAllocation."posting type"::Normal);
                    if hrLeaveAllocation.Find('-') then begin
                        onLeave := true;
                        onleaveLbl := 'On Leave';
                        LeaveType := hrLeaveAllocation."Leave Type";
                    end else begin
                        //Employee is not on leave and has not checked in. So he is Absent
                        onLeave := false;
                        onleaveLbl := 'Absent';
                        LeaveType := 'Absent';
                        LoggedOutTxt := 'Absent';
                        Att_Date := 0D;
                        SigninLocationName := '-';
                        SignOutLocationName := '-';
                        timeIn := 0T;
                        timeOut := 0T;
                        hoursWorked := 0;
                    end;
                end;

                /* Show Auuid for Airtel Employees */
                // if HREmployee."AUUID No." <> 0 then
                //     StaffNo := Format(HREmployee."AUUID No.")
                // else
                    StaffNo := HREmployee."No.";

                /* Get Dimension Description */
                DimensionValue.Reset();
                DimensionValue.SetRange(Code, "Global Dimension 1 Code");
                if DimensionValue.FindFirst() then
                    DimDesciption := DimensionValue.Name;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;
        layout
        {
            area(content)
            {
                field(DateFil; DateFil)
                {
                    Caption = 'Date Filter';
                    ToolTip = 'Specifies the value of the Date Filter field.';
                }
            }
        }
        actions
        {
            area(processing)
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
        DimensionValue: Record "Dimension Value";
        HrAttendanceLedger: Record "HR Attendance Ledger";
        hrLeaveAllocation: Record "HR Leave Allocation";
        onLeave: Boolean;
        StaffNo: Code[30];
        Att_Date: Date;
        DateFil: Date;
        loginDatetime: DateTime;
        hoursWorked: Decimal;
        LeaveType: Text;
        LoggedOutTxt: Text;
        onleaveLbl: Text;
        SigninLocationName: Text;
        SignOutLocationName: Text;
        DimDesciption: text[50];
        timeIn: Time;
        timeOut: Time;
}
