pageextension 50047 "Job Tasks Subform Ext" extends "Job Task Lines Subform"
{
    Caption = 'Project Tasks';
    layout
    {
        addafter(Description)
        {
            field("Region Code";"Region Code"){
                ApplicationArea=basic;
            }
            field(Status; Rec.Status)
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Status field.';
            }
        }
        addbefore("Start Date")
        {
            field(Job_Type;rec.Job_Type){
                ApplicationArea=basic;
            }
            field("Expected Results";rec."Expected Results"){
                ApplicationArea=basic;
            }
            field(Indicator;rec.Indicator){
                ApplicationArea=basic;
            }
            field(Disaggregation;rec.Disaggregation){
                ApplicationArea=basic;

            }
            field("Baseline Type";"Baseline Type"){}
            field(Baseline;rec.Baseline){
                ApplicationArea=basic;
            }
            field("Notes on baselines";rec."Notes on baselines"){
                ApplicationArea=basic;
            }
            field(Target;rec.Target){
                ApplicationArea=basic;
            }
            field(Achievement;rec.Achievement)
            {
                ApplicationArea=basic;
            }

            field("Data Sources";rec."Data Sources"){
                ApplicationArea=basic;
            }
            field(Frequency;rec.Frequency){
                ApplicationArea=basic;
                Caption='Frequency';
            }
            field("Responsible Party";rec."Responsible Party"){
                ApplicationArea=basic;
            }
            field("Title of Responsible pary";rec."Title of Responsible pary"){
                ApplicationArea=basic;
            }
            field("Data Collection Method";rec."Data Collection Method"){
                ApplicationArea=basic;
            }

        }
    }
}