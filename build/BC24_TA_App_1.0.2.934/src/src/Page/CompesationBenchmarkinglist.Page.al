page 51453 "Compensation Benchmarking list"
{
    ApplicationArea = All;
    Caption = 'Compensation Benchmarking list';
    PageType = List;
    SourceTable = "Compensation Benchmarking";
    CardPageId = "Compensation Benchmarking Card";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Job ID"; Rec."Job ID")
                {
                    ToolTip = 'Specifies the value of the Job ID field.', Comment = '%';
                }
                field("Job Description"; Rec."Job Description")
                {
                    ToolTip = 'Specifies the value of the Job Description field.', Comment = '%';
                }
                field("Job Grade"; Rec."Job Grade")
                {
                    ToolTip = 'Specifies the value of the Job Grade field.', Comment = '%';
                }
                field("Salary Grade"; Rec."Salary Grade")
                {
                    ToolTip = 'Specifies the value of the Salary Grade field.', Comment = '%';
                }
                field("Market Average"; Rec."Market Average")
                {
                    ToolTip = 'Specifies the value of the Market Average field.', Comment = '%';
                }
                field("Date Created"; Rec."Date Created")
                {
                    ToolTip = 'Specifies the value of the Date Created field.', Comment = '%';
                }
                field("Created By"; Rec."Created By")
                {
                    ToolTip = 'Specifies the value of the Created By field.', Comment = '%';
                }
            }
        }
    }
}
