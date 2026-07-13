
report 50365 "Exit Interview Form"
{
    Caption = 'Exit Form';
    DefaultLayout = Word;
    UsageCategory = ReportsAndAnalysis;
    WordLayout = './Layouts/HRExitInterviewForm.docx';
    //HR Employee Beneficiary

    ApplicationArea = All;

    dataset
    {
        dataitem("HR Employee Exit Interviews"; "HR Employee Exit Interviews")
        {
            RequestFilterFields = "Exit Clearance No";
            column(ReportForNavId_1; 1) { }
            column(clearanceno; "HR Employee Exit Interviews"."Exit Clearance No") { }
            column(clearancedate; format("HR Employee Exit Interviews"."Date Of Clearance", 0, '<Closing><Day,2>/<Month,2>/<Year,4>')) { }
            column(requester; "HR Employee Exit Interviews"."Clearance Requester") { }
            column(empinfuture; "HR Employee Exit Interviews"."Re Employ In Future") { }
            column(natureofsep; "HR Employee Exit Interviews"."Nature Of Separation") { }
            column(reason; "HR Employee Exit Interviews"."Reason For Leaving (Other)") { }
            column(dateofleaving; format("HR Employee Exit Interviews"."Date Of Leaving", 0, '<Closing><Day,2>/<Month,2>/<Year,4>')) { }
            //column(DirectorateCode_HREmployeeExitInterviews; "HR Employee Exit Interviews"."Directorate Code") { }
            column(department; "HR Employee Exit Interviews"."Department Code") { }
            column(comments; "HR Employee Exit Interviews".Comment) { }
            column(empno; "HR Employee Exit Interviews"."Employee No.") { }
            column(nseries; "HR Employee Exit Interviews"."No Series") { }
            column(formsubmitted; "HR Employee Exit Interviews"."Form Submitted") { }
            column(empname; "HR Employee Exit Interviews"."Employee Name") { }
            column(clearername; "HR Employee Exit Interviews"."Clearer Name") { }
            column(status; "HR Employee Exit Interviews".Status) { }
            column(Employee_Type; "HR Employee Exit Interviews"."Employee Type") { }
            column(interviewdate; format("HR Employee Exit Interviews"."Appointment Date", 0, '<Closing><Day,2>/<Month,2>/<Year,4>')) { }
            column(Title; Title) { }
            column(job_title; job_title) { }
            column(Sector; Sector) { }
            column(Process; Process) { }
            column(Department_Code; "Department Code") { }
            column(Branch_Code; "Branch Code") { }
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }
}