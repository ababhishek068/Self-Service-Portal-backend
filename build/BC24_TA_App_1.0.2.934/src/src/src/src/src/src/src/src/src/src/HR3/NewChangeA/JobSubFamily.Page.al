page 51463 "Job Sub-Family"
{
    ApplicationArea = All;
    Caption = 'Job Sub-Family';
    PageType = List;
    SourceTable = "Job Sub Family";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Job Family Code"; Rec."Job Family Code")
                {
                    ToolTip = 'Specifies the value of the Job Family Code field.', Comment = '%';
                }
                field("Job Family Description"; Rec."Job Family Description")
                {
                    ToolTip = 'Specifies the value of the Job Family Description field.', Comment = '%';
                }
                field("Job Family Sub-Family"; Rec."Job Family Sub-Family")
                {
                    ToolTip = 'Specifies the value of the Job Family Sub-Family field.', Comment = '%';
                }
                field("Job Family Sub-Family Desc"; Rec."Job Family Sub-Family Desc")
                {
                    ToolTip = 'Specifies the value of the Job Family Sub-Family Description field.', Comment = '%';
                }
            }
        }
    }
}
