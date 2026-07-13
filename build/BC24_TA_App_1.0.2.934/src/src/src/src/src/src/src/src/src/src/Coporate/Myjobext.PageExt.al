namespace ABH_UAT_LIVE.ABH_UAT_LIVE;

using Microsoft.Projects.Project.Job;

pageextension 50072 "My job ext" extends "My Jobs"
{
    layout
    {
        addbefore("Exclude from Business Chart")
        {
            field("Show task line Graphs";"Show task line Graphs")
            {
                ApplicationArea=basic;
            }
            
        }
        addafter(Status)
        {
            field("Baseline Type";"Baseline Type")
            {
                ApplicationArea=basic;
            }
            field("Activity Type";"Activity Type"){
                ApplicationArea=basic;
            }
            field(ChartType;ChartType)
            {
                ApplicationArea=basic;
                Caption='Chart type for Tasks';
            }
        }
        addafter("Job No.")
        {
            field("Project Title";"Project Title")
            {
                ApplicationArea=basic;
            }
        }
        modify(Description)
        {
            Visible=false;
        }
        modify("Percent Invoiced")
        {
            Visible=false;
        }
        modify("Bill-to Name")
        {
            Caption='Customer Name';
        }
    }
}
