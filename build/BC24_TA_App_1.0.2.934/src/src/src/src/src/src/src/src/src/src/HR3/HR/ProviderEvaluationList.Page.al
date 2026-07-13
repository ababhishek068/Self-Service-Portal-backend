namespace ABH_UAT.ABH_UAT;

page 51530 "Provider Evaluation List"
{
    ApplicationArea = All;
    Caption = 'Provider Evaluation List';
    PageType = List;
    SourceTable = "Trainer Evaluation Header";
    UsageCategory = Lists;
    CardPageId="Trainer Evaluation Card";
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Course Code"; Rec."Course Code")
                {
                    ToolTip = 'Specifies the value of the Course Code field.', Comment = '%';
                }
                field("Course Name"; Rec."Course Name")
                {
                    ToolTip = 'Specifies the value of the Course Name field.', Comment = '%';
                }
                field("Employee Code"; Rec."Employee Code")
                {
                    ToolTip = 'Specifies the value of the Employee Code field.', Comment = '%';
                }
                field("Employee name"; Rec."Employee name")
                {
                    ToolTip = 'Specifies the value of the Employee name field.', Comment = '%';
                }
                field("Evaluation Code"; Rec."Evaluation Code")
                {
                    ToolTip = 'Specifies the value of the Evaluation Code field.', Comment = '%';
                }
                field(Trainer; Rec.Trainer)
                {
                    ToolTip = 'Specifies the value of the Trainer field.', Comment = '%';
                }
                field("Trainer Name"; Rec."Trainer Name")
                {
                    ToolTip = 'Specifies the value of the Trainer Name field.', Comment = '%';
                }
                field("Training Need"; Rec."Training Need")
                {
                    ToolTip = 'Specifies the value of the Training Code field.', Comment = '%';
                }
            }
        }
    }
}
