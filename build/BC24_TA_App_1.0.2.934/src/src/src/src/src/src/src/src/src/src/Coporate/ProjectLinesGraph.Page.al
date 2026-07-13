namespace ABH_UAT_LIVE.ABH_UAT_LIVE;
using System.Integration;
using System.Visualization;
using Microsoft.Projects.Project.Analysis;
using Microsoft.Projects.Project.Job;

page 51591 "Project Lines Graph"
{
    ApplicationArea = All;
    Caption = 'Project Lines Graph-Outcome';
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
                joblines: Record "Job Task";
                i: Integer;
                MyJob: Record "Actual Target Chart Setup";
                chartype: Enum "Business Chart Type";
                myjob1: Record "My Job";
                begin
                    chartype:=chartype::Column;
                    Buffer.Initialize();
                    Buffer.AddMeasure('Target',1,Buffer."Data Type"::Decimal,chartype);
                    Buffer.AddMeasure('Achievement',1,Buffer."Data Type"::Decimal,chartype);
                    Buffer.AddMeasure('Variance',1,Buffer."Data Type"::Decimal,chartype);
                    Buffer.SetXAxis('Expected Result',Buffer."Data Type"::String);
                    MyJob.Reset();
                    MyJob.SetRange(MyJob."Exclude From Chart",false);
                    if MyJob.Find('-') then begin
                        repeat
                        joblines.Reset();
                        joblines.SetRange(joblines."Job Task No.",MyJob."Task No");
                        joblines.SetRange(joblines.Job_Type,joblines."Job Task Type"::Posting);
                        joblines.SetRange(joblines.Job_Type,MyJob."Activity Type");
                        if joblines.FindFirst() then begin
                        Buffer.AddColumn(joblines.Description);
                        Buffer.SetValueByIndex(0,i,joblines.Target);
                        Buffer.SetValueByIndex(1,i,joblines.Achievement);
                        Buffer.SetValueByIndex(2,i,(joblines.Target-joblines.Achievement));
                        i +=1;
                        end;

                        until MyJob.Next()=0;
                        Buffer.UpdateChart(CurrPage.chart);
                    end else if not MyJob.Find() then begin
                        MyJob1.Reset();
                        myjob1.SetRange(myjob1."Exclude from Business Chart",false);
                        if myjob1.FindFirst()then begin
                        joblines.Reset();
                        joblines.SetRange(joblines."Job No.",MyJob1."Job No.");
                        joblines.SetRange(joblines.Job_Type,joblines."Job Task Type"::Posting);
                        joblines.SetRange(joblines.Job_Type,joblines.Job_Type::Outcome);
                        if joblines.Find('-') then begin
                            repeat
                            Buffer.AddColumn(joblines.Description);
                            Buffer.SetValueByIndex(0,i,joblines.Target);
                            Buffer.SetValueByIndex(1,i,joblines.Achievement);
                            Buffer.SetValueByIndex(2,i,(joblines.Target-joblines.Achievement));
                            i +=1;                  


                            until joblines.Next()=0;
                            Buffer.UpdateChart(CurrPage.chart);
                        end;

                        end;

                    end
                    
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
                Caption='Achievement Vs Target Filters for Tasks';
                Image=CopyBudget;
                trigger OnAction()
                begin
                    page.RunModal((page::"Actual Vs Budget Chart Setup"));
                    //UpdateChart(chart);
                    //UpdateChart(CurrPage.chart);
                end;
            }
        }
    }
}
