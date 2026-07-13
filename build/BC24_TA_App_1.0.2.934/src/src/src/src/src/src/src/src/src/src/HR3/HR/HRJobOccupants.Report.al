Report 50227 "HR Job Occupants"
{
    DefaultLayout = RDLC;
    // RDLCLayout = './Layouts/HRJobOccupants.rdlc';
    Caption = 'HR Job Occupants Report';
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
            column(CI_Picture; CI.Picture) { }
            column(No_of_Posts; "No of Posts") { }
            column(Vacant_Positions; "Vacant Positions") { }
            column(Occupied_Positions; "Occupied Positions") { }
            dataitem("HR-Employee"; "HR-Employee")
            {
                DataItemLink = "Job Title" = field("Job ID");
                DataItemTableView = sorting("No.") order(ascending);
                column(ReportForNavId_1000000001; 1000000001) { }
                column(No_HREmployees; "HR-Employee"."No.")
                {
                    IncludeCaption = true;
                }
                column(FirstName_HREmployees; "HR-Employee"."First Name")
                {
                    IncludeCaption = true;
                }
                column(MiddleName_HREmployees; "HR-Employee"."Middle Name")
                {
                    IncludeCaption = true;
                }
                column(LastName_HREmployees; "HR-Employee"."Last Name")
                {
                    IncludeCaption = true;
                }
                column(JobTitle_HREmployees; "HR-Employee"."Job Title")
                {
                    IncludeCaption = true;
                }

                trigger OnAfterGetRecord()
                begin
                    HRJob.Reset;
                    HRJob.SetRange(HRJob."Job id", "Job Title");
                    // if HRJob.Find('-') then
                    //    CurrReport.SHOWOUTPUT := true;
                end;
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
        HRJob: Record "HR Jobs";
}

