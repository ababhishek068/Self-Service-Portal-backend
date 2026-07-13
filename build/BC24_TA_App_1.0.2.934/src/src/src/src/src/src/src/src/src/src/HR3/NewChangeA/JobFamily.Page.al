page 51462 "Job Family"
{
    ApplicationArea = All;
    Caption = 'Job Family';
    PageType = List;
    SourceTable = "Job Family";
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
            }
        }
    }
}
