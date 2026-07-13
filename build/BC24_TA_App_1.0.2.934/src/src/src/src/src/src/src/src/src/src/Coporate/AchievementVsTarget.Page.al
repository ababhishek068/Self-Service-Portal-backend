namespace ABH_UAT_LIVE.ABH_UAT_LIVE;
using System.Integration;
using System.Visualization;
using Microsoft.Projects.Project.Job;

page 51590 "Achievement Vs Target"
{
    ApplicationArea = All;
    Caption = 'Achievement Vs Target Graph';
    PageType = CardPart;
    
    layout
    {
        area(Content)
        {
            usercontrol(chart;BusinessChart)
            {
                ApplicationArea=all;
                trigger DataPointClicked(Point: JsonObject)
                var
                JsonTxt:text;
                begin
                 Point.WriteTo(JsonTxt);
                 Message('%1',JsonTxt);

                end;
                trigger AddInReady()
                var
                Buffer: Record "Business Chart Buffer" temporary;
                project: Record Job;
                myselection: Record "My Job";
                i: Integer;
                charttype: Enum "Business Chart Type";
                charttype1:Option "default","Column",Bar,Pie,Line,Bubble,"Area";
                begin
                    charttype:=charttype::Column;
                    myselection.Reset();
                    myselection.SetRange(myselection."Exclude from Business Chart",false);
                    if myselection.FindFirst() then begin
                        charttype1:=myselection.ChartType;
                    end;
                    


                    Buffer.Initialize();
                    if charttype1=charttype1::default then begin
                     Buffer.AddMeasure('Target',1,Buffer."Data Type"::Decimal,charttype);
                     Buffer.AddMeasure('Achievement',1,Buffer."Data Type"::Decimal,charttype);
                     Buffer.AddMeasure('Variance',1,Buffer."Data Type"::Decimal,charttype);
                    end else begin
                        Buffer.AddMeasure('Target',1,Buffer."Data Type"::Decimal,charttype1);
                        Buffer.AddMeasure('Achievement',1,Buffer."Data Type"::Decimal,charttype1);
                        Buffer.AddMeasure('Variance',1,Buffer."Data Type"::Decimal,charttype1);
                    end;
                    
                    
                    Buffer.SetXAxis('Project',Buffer."Data Type"::String);
                    myselection.Reset();
                    myselection.SetRange(myselection."Exclude from Business Chart",false);
                    if myselection.Find('-') then begin                                 

                    repeat
                    project.Reset();
                    project.SetRange(project."No.",myselection."Job No.");
                    if project.FindFirst() then begin
                    if project.Target<>0 then begin
                        Buffer.AddColumn(project."Project Title");
                        Buffer.SetValueByIndex(0,i,project.Target);
                        Buffer.SetValueByIndex(1,i,project.Achievement);
                        Buffer.SetValueByIndex(2,i,(project.Target-project.Achievement));
                        i +=1;

                    end;
                    end;
                    Buffer.UpdateChart(CurrPage.chart);

                    until myselection.Next()=0;
                    Buffer.UpdateChart(CurrPage.chart);


                end;
                end;
            }
        }
        
    }
    actions
    {
        area(Processing)
        {
            action("actual chart setup")
            {
                Promoted=true;
                PromotedCategory=Process;
                ApplicationArea=all;
                Caption='Achievement Vs Target Filters';
                Image=CopyBudget;
                trigger OnAction()
                begin
                    page.RunModal((page::"My Jobs"));
                    //UpdateChart(chart);
                    //UpdateChart(CurrPage.chart);
                end;
            }
        }
    }
}
