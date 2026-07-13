Report 50239 "HR Exit Interviews"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HRExitInterviews.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("HR Employee Exit Interviews"; "HR Employee Exit Interviews")
        {
            RequestFilterFields = "Exit Clearance No";
            column(ReportForNavId_1; 1) { }
            column(ExitClearanceNo_HREmployeeExitInterviews; "HR Employee Exit Interviews"."Exit Clearance No") { }
            column(DateOfClearance_HREmployeeExitInterviews; "HR Employee Exit Interviews"."Date Of Clearance") { }
            column(ClearanceRequester_HREmployeeExitInterviews; "HR Employee Exit Interviews"."Clearance Requester") { }
            column(ReEmployInFuture_HREmployeeExitInterviews; "HR Employee Exit Interviews"."Re Employ In Future") { }
            column(NatureOfSeparation_HREmployeeExitInterviews; "HR Employee Exit Interviews"."Nature Of Separation") { }
            column(ReasonForLeavingOther_HREmployeeExitInterviews; "HR Employee Exit Interviews"."Reason For Leaving (Other)") { }
            column(DateOfLeaving_HREmployeeExitInterviews; "HR Employee Exit Interviews"."Date Of Leaving") { }
            //column(DirectorateCode_HREmployeeExitInterviews; "HR Employee Exit Interviews"."Directorate Code") { }
            column(DepartmentCode_HREmployeeExitInterviews; "HR Employee Exit Interviews"."Department Code") { }
            column(Comment_HREmployeeExitInterviews; "HR Employee Exit Interviews".Comment) { }
            column(EmployeeNo_HREmployeeExitInterviews; "HR Employee Exit Interviews"."Employee No.") { }
            column(NoSeries_HREmployeeExitInterviews; "HR Employee Exit Interviews"."No Series") { }
            column(FormSubmitted_HREmployeeExitInterviews; "HR Employee Exit Interviews"."Form Submitted") { }
            column(EmployeeName_HREmployeeExitInterviews; "HR Employee Exit Interviews"."Employee Name") { }
            column(ClearerName_HREmployeeExitInterviews; "HR Employee Exit Interviews"."Clearer Name") { }
            column(Status_HREmployeeExitInterviews; "HR Employee Exit Interviews".Status) { }
           // column(ResponsibilityCenter_HREmployeeExitInterviews; "HR Employee Exit Interviews"."Responsibility Center") { }
           // column(StationCode_HREmployeeExitInterviews; "HR Employee Exit Interviews"."Station Code") { }
            column(StationName_HREmployeeExitInterviews; "HR Employee Exit Interviews"."Station Name") { }
            column(DirectorateName_HREmployeeExitInterviews; "HR Employee Exit Interviews"."Directorate Name") { }
            column(DepartmentName_HREmployeeExitInterviews; "HR Employee Exit Interviews"."Department Name") { }
            column(DepartmentFilter_HREmployeeExitInterviews; "HR Employee Exit Interviews"."Department Filter") { }
            column(StationFilter_HREmployeeExitInterviews; "HR Employee Exit Interviews"."Station Filter") { }
            column(DirectorateFilter_HREmployeeExitInterviews; "HR Employee Exit Interviews"."Directorate Filter") { }
            column(EmployeeType_HREmployeeExitInterviews; "HR Employee Exit Interviews"."Employee Type") { }
            column(AppointmentDate_HREmployeeExitInterviews; "HR Employee Exit Interviews"."Appointment Date") { }
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }
}

