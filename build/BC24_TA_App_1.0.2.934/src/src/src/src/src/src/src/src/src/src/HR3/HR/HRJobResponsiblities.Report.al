report 50054 "HR Job Responsiblities"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("HRJobResponsiblities"; "Employee Responsibility")
        {
            column(Job_ID; "Job ID") { }
            column(Responsibility_Description; "Responsibility Description") { }
            column(Start_Date; "Start Date") { }
            column(Remarks; Remarks) { }
            column("JobDescription"; JobsRec."Job Description") { }
            trigger OnAfterGetRecord()
            begin
                if JobsRec.get("Job ID") then;
            end;
        }
    }


    var
        JobsRec: record "HR Jobs";
}