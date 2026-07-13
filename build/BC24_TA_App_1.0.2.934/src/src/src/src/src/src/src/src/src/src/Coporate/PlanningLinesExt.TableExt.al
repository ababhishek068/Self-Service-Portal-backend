namespace ABH_UAT_LIVE.ABH_UAT_LIVE;
using Microsoft.Service.Contract;
using Microsoft.Projects.Project.Planning;

tableextension 50053 "Planning Lines Ext" extends "Job Planning Line"
{
    fields
    {
        field(50001;"Indicator";text[200]){}

        field(50002;"Expected Results";text[300]){}
        field(50003;"Disaggregation";text[200]){}
        field(50004;"Baseline";Decimal){}
        field(50005;"Notes on baselines";Text[250]){}
        field(50006;"Target";Text[250]){}
        field(50007;"Data Sources";Text[250]){}
        field(50008;"Job_Type";Option){
            OptionMembers="",Outcome,Output,Activity;
        }
        field(50009;"Responsible Party";Code[20]){
            TableRelation="HR Jobs"."Job ID";
            
        }
        field(50010;"Title of Responsible pary";Text[100]){}
        field(50011;"Data Collection Method";text[100]){}
        field(50012; "Frequency"; Enum "Service Contract Header Invoice Period")
        {
            Caption = 'Frequency';
            trigger OnValidate()
            begin
                
            end;
            

        
        }
        field(50013;"Q1 Planned";Decimal){}
        field(50014;"Q2 Planned";Decimal){}
        field(50015;"Q3 Planned";Decimal){}
        field(50016;"Q4 Planned";Decimal){}
        field(50017;"Q1 Actual";Decimal){}
        field(50018;"Q2 Actual";Decimal){}
        field(50019;"Q3 Actual";Decimal){}
        field(50020;"Q4 Actual";Decimal){}
        field(50021;"Planned Final";Decimal){}
        field(50022;"Actual Final";Decimal){}
        
    }
    
}
