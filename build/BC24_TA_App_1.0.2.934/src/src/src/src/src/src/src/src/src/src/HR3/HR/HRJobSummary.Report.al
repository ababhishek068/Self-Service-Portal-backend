Report 50103 "HR Job Summary"
{
    DefaultLayout = RDLC;
    // RDLCLayout = './Layouts/HRJobOccupants.rdlc';
    Caption = 'HR Job Summary Report';
    ApplicationArea = All;

    dataset
    {
        dataitem("HR Jobs"; "HR Jobs")
        {
            RequestFilterFields = "Job ID", Status;
            column(ReportForNavId_1000000000; 1000000000) { }
            column(CI_Name; CI.Name)
            {
                IncludeCaption = true;
            }
            column(CI_Address; CI.Address)
            {
                IncludeCaption = true;
            }
            column(CI_Address2; CI."Address 2")
            {
                IncludeCaption = true;
            }
            column(CI_PhoneNo; CI."Phone No.") { }
            column(CI_Picture; CI.Picture) { }
            column(CI_City; CI.City)
            {
                IncludeCaption = true;
            }
            column(JobID_HRJobs; "HR Jobs"."Job ID")
            {
                IncludeCaption = true;
            }
            column(JobDescription_HRJobs; "HR Jobs"."Job Description")
            {
                IncludeCaption = true;
            }
            column(Jobs_Reporting_To; "Jobs Reporting To")
            {
                IncludeCaption = true;
            }
            column(Position_Reporting_to; "Position Reporting to")
            {
                IncludeCaption = true;
            }
            column(Position_Reporting_to2; "Position Reporting to2")
            {
                IncludeCaption = true;
            }
            column(Position_Report_to_Description; "Position Report to Description") { }
            column(Job_Cadre; "Job Cadre") { }
            column(Department_Code; "Department Code")
            {
                IncludeCaption = true;
            }
            column(Department_Name; "Department Name")
            {
                IncludeCaption = true;
            }
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }

    trigger OnPreReport()
    begin
        CI.Reset;
        CI.Get();
        CI.CalcFields(CI.Picture);
    end;

    var
        CI: Record "Company Information";
}

