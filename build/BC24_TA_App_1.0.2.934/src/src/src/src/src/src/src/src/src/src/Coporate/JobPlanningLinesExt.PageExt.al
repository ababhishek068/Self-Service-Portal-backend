namespace ABH_UAT_LIVE.ABH_UAT_LIVE;

using Microsoft.Projects.Project.Planning;

pageextension 50071 "Job Planning Lines Ext" extends "Job Planning Lines"
{
    layout
    {
        addbefore(Type)
        {
            field(Indicator;Rec.Indicator){
                ApplicationArea=basic;
            }
            field(Target;rec.Target){
                ApplicationArea=basic;
            }
            field("Q1 Planned";rec."Q1 Planned"){
                ApplicationArea=basic;
            }
            field("Q1 Actual";rec."Q1 Actual"){
                ApplicationArea=basic;
            }
            field("Q2 Planned";rec."Q2 Planned"){
                ApplicationArea=basic;
            }
            field("Q2 Actual";rec."Q2 Actual"){
                ApplicationArea=basic;
            }
            field("Q3 Planned";rec."Q3 Planned"){
                ApplicationArea=basic;
            }
            field("Q3 Actual";rec."Q3 Actual"){
                ApplicationArea=basic;
            }
            field("Q4 Planned";rec."Q4 Planned"){
                ApplicationArea=basic;
            }
            field("Q4 Actual";rec."Q4 Actual"){
                ApplicationArea=basic;
            }
            field("Planned Final";rec."Planned Final"){
                ApplicationArea=basic;
            }
            field("Actual Final";rec."Actual Final"){
                ApplicationArea=basic;
            }
        }
    }
}
