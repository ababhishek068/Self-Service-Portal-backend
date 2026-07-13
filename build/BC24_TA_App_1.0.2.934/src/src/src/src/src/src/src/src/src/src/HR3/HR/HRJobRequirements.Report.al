report 50055 "HR Job Requirements"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("HR Jobs Requirements"; "HR Jobs Requirements")
        {
            column(Job_ID; "Job ID") { }
            column(Qualification_Description; "Qualification Description") { }
            column(Score_ID; "Score ID") { }
            column(Qualification_Category; "Qualification Category") { }
            column(Qualification_Code; "Qualification Code") { }

            column(Qualification_Type; "Qualification Type") { }
            column(Qualification_Rank; "Qualification Rank") { }
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