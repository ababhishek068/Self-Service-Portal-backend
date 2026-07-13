report 50110 "Leave Report"
{
    Caption = 'ReportName';
    UsageCategory = Administration;
    ApplicationArea = All;

    dataset
    {
        dataitem("HR Leave Application"; "HR Leave Application")
        {
            column(Application_Code; "Application Code") { }
            column(Application_Date; "Application Date") { }
            column(Current_Total_Leave_Taken; "Current Total Leave Taken") { }
            column(Date_Posted; "Date Posted") { }
            column(Days_Applied; "Days Applied") { }
            column(Department; Department) { }
            column(Department_Name; "Department Name") { }
            column(Employee_No_; "Employee No.") { }
            column(Empoyee_Name; "Empoyee Name") { }

            column(picture; compInfo.Picture) { }

            column(Address; CompInfo.Address) { }

            column(gmail; CompInfo."E-Mail") { }

            column(Name; compInfo.Name) { }

            column(PhoneNo; CompInfo."Phone No.") { }

            column(Postcode; CompInfo."Post Code") { }







        }
    }
    var
        compInfo: Record "Company Information";

    // requestpage
    // {
    //     layout
    //     {
    //         area(Content)
    //         {
    //             group(GroupName)
    //             {
    //                 field()
    //                 {
    //                     ApplicationArea = All;

    //                 }
    //             }
    //         }
    //     }
    // }
}