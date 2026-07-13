namespace ABH_UAT_LIVE.ABH_UAT_LIVE;

using System.Visualization;
using System.Integration;
using Microsoft.Projects.Project.Job;

page 51589 "Target Vs Actual by Project"
{
    ApplicationArea = All;
    Caption = 'Target Vs Actual by Project';
    PageType = CardPart;
    SourceTable = "Business Chart Buffer";
    //SourceTable=Job;
    
    layout
    {
        area(Content)
        {

            usercontrol(chart;BusinessChart)
            {
                ApplicationArea=all;
                trigger AddInReady()
                begin
                  //chart.UpdateChart(chart);  
                  UpdateChart(CurrPage.chart);
                end;
                trigger Refresh()
                begin
                    //UpdateChart(Rec);
                    UpdateChart(CurrPage.chart);
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
                Caption='Actual Vs Budget Filters';
                Image=CopyBudget;
                trigger OnAction()
                begin
                    page.RunModal((page::"Actual Vs Budget Chart Setup"));
                    //UpdateChart(chart);
                    UpdateChart(CurrPage.chart);
                end;
            }
        }
    }
    var
    targetvsactualmgt: Codeunit "Actual Vs Budget Magt";
    local procedure updatechart()
    begin
        targetvsactualmgt.generateData(Rec);
        UpdateChart(CurrPage.chart);
    end;
}


