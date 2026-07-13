namespace ABH_UAT_LIVE.ABH_UAT_LIVE;
using Microsoft.Projects.Project.Job;

tableextension 50054 "Myjob Ext" extends "My Job"
{
    fields
    {
         field(50004; ChartType; Option)
        {
            Caption = 'ChartType';
            OptionMembers=Default,"Column",Bar,Pie,Line,Bubble,"Area";
        }
        field(50000; "Baseline Type"; Option)
        {
            Caption = 'Baseline Type';
            OptionMembers=NA,Percentage,Number;
        }
        field(50001; "Activity Type"; option)
        {
            Caption = 'Activity Type';
            OptionMembers="",Outcome,Output,Activity;
        }
        field(50002;Project;code[20]){
            TableRelation=Job."No.";
            trigger OnValidate()
            begin
                projects.Reset();
                projects.SetRange(projects."No.",rec.Project);
                if projects.FindFirst() then begin
                    "Project Title":=projects."Project Title";
                    if projects."Project Title"='' then begin
                        "Project Title":=projects.Description;

                    end;
                end;
            end;
        }
        field(50003;"Project Title";text[200]){
            Editable=false;
        }
        field(50005;"Show task line Graphs";Boolean)
        {
            
        }
        modify("Job No.")
        {
            trigger OnAfterValidate()
            begin
                projects.Reset();
                projects.SetRange(projects."No.",rec.Project);
                if projects.FindFirst() then begin
                    "Project Title":=projects."Project Title";
                    if projects."Project Title"='' then begin
                        "Project Title":=projects.Description;

                    end;
                end;
            end;
        }
    }

    var
    projects: Record Job;
}
