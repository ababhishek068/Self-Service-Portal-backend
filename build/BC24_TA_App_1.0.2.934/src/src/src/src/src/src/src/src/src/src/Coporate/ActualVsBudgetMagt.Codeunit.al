namespace ABH_UAT_LIVE.ABH_UAT_LIVE;
using System.Visualization;
using Microsoft.Projects.Project.Job;

codeunit 50051 "Actual Vs Budget Magt"
{
    //TableNo = "Actual Target Chart Setup";
    
    trigger OnRun()
    begin
    
    end;
    var
    actualbudgetsetup: Record "Actual Target Chart Setup";

    procedure generateData(var businessChartBuffer: Record "Business Chart Buffer")
    var
    project: Record Job;
    projecttasks: Record "Job Task";
    index: Integer;
    begin

        actualbudgetsetup.SetRange("User ID",UserId);
        actualbudgetsetup.SetRange("Exclude From Chart",false);
        if not actualbudgetsetup.FindFirst() then
        page.RunModal(page::"Actual Vs Budget Chart Setup");

        with businessChartBuffer do begin
             Initialize();
             if actualbudgetsetup."Baseline Type"=actualbudgetsetup."Baseline Type"::Number then begin
                AddMeasure('Target',1,"Data Type"::Decimal,actualbudgetsetup.ChartType);
                AddMeasure('Actual',1,"Data Type"::Decimal,actualbudgetsetup.ChartType);

             end else if actualbudgetsetup."Baseline Type"=actualbudgetsetup."Baseline Type"::Percentage then begin
                AddMeasure('Target',1,"Data Type"::Decimal,actualbudgetsetup.ChartType);
                AddMeasure('Actual',1,"Data Type"::Decimal,actualbudgetsetup.ChartType);

             end else begin

             end;

             SetXAxis('Project',"Data Type"::String);
             if project.FindSet() then begin
                repeat
                if project.Target<>0 then begin
                    AddColumn(project."Project Title");
                    SetValueByIndex(0,index,project.Target);
                    SetValueByIndex(1,index,project.Achievement);

                    index +=1;

                end;               
                

                until project.Next()=0;
             end;
             //UpdateChart();
             



        end;

    end;
    
}
