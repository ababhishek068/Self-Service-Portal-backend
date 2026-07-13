namespace Microsoft.Projects.Project.Job;
using Microsoft.Foundation.Enums;
using Microsoft.Projects.Project.Planning;
using Microsoft.Service.Contract;
tableextension 50037 JobTaskExt extends "Job Task"
{
    fields
    {
        field(50000; "Status"; Option)
        {
            OptionMembers = "Pending","Completed";
        }
        field(50001;"Indicator";text[200]){}

        field(50002;"Expected Results";text[300]){}
        field(50003;"Disaggregation";text[200]){}
        field(50004;"Baseline";Decimal){
            trigger OnValidate()
            begin
                TestField(Baseline);
                if rec."Baseline Type"=rec."Baseline Type"::NA then begin
                    Error('Baseline is not applicable');
                end else if rec."Baseline Type"=rec."Baseline Type"::Number then begin
                    if rec.Baseline<0 then begin
                        Error('Baseline must be zero or more');
                    end;
                end else if rec."Baseline Type"=rec."Baseline Type"::Percentage then begin
                    if (rec.Baseline<0) or (rec.Baseline>100) then begin
                        Error('Baseline must be between 0 and 100');
                    end;
                end;
            end;
        }
        field(50005;"Notes on baselines";Text[250]){}
        field(50006;"Target";Decimal){
            // AutoFormatType = 1;
            // BlankZero = true;            
            // CalcFormula = sum("Job Planning Line"."Planned Final" where("Job No." = field("Job No."),
            //                                                                 "Job Task No." = field("Job Task No."),
            //                                                                 "Job Task No." = field(filter(Totaling)),
            //                                                                 "Schedule Line" = const(true),
            //                                                                 "Planning Date" = field("Planning Date Filter")));
            // Caption = 'Target';
            // Editable = false;
            // FieldClass = FlowField;
        }
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
        field(50013;"Achievement";Decimal){
            // AutoFormatType = 1;
            // BlankZero = true;            
            // CalcFormula = sum("Job Planning Line"."Actual Final" where("Job No." = field("Job No."),
            //                                                                 "Job Task No." = field("Job Task No."),
            //                                                                 "Job Task No." = field(filter(Totaling)),
            //                                                                 "Schedule Line" = const(true),
            //                                                                 "Planning Date" = field("Planning Date Filter")));
            // Caption = 'Achievemnet';
            // Editable = false;
            // FieldClass = FlowField;
        }
        field(50014;"Baseline Type";Option){
            OptionMembers=NA,Percentage,Number;
        }
        field(50015;"Target Description";text[250]){}
        field(50016;"Region Code";Code[20])
        {
            TableRelation=Region.Code;
        }
        field(50017;"Region Name";Text[100]){
            Editable=false;
        }
        
    }
}