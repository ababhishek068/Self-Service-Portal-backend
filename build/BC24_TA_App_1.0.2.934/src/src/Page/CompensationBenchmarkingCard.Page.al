page 51454 "Compensation Benchmarking Card"
{
    ApplicationArea = All;
    Caption = 'Compensation Benchmarking Card';
    PageType = Card;
    SourceTable = "Compensation Benchmarking";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

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
                field("Current Basic"; "Current Basic")
                {
                    ToolTip = 'Specifies the value of the Current Basic field.', Comment = '%';
                }
                field("Current Gross"; "Current Gross")
                {
                    ToolTip = 'Specifies the value of the Current Gross field.', Comment = '%';
                }
                field("Market Average"; Rec."Market Average")
                {
                    ToolTip = 'Specifies the value of the Market Average field.', Comment = '%';
                }
                field("Competitive Gap Basic"; "Competitive Gap Basic")
                {
                    ToolTip = 'Specifies the value of the Competitive Gap Basic field.', Comment = '%';
                }
                field("Market Source"; Rec."Market Source")
                {
                    ToolTip = 'Specifies the value of the Market Source field.', Comment = '%';
                }
                field("Created By"; Rec."Created By")
                {
                    ToolTip = 'Specifies the value of the Created By field.', Comment = '%';
                }
                field("Date Created"; Rec."Date Created")
                {
                    ToolTip = 'Specifies the value of the Date Created field.', Comment = '%';
                }
                field("Time Created"; Rec."Time Created")
                {
                    ToolTip = 'Specifies the value of the Time Created field.', Comment = '%';
                }
                field("Last Modified"; Rec."Last Modified")
                {
                    ToolTip = 'Specifies the value of the Last Modified field.', Comment = '%';
                }
                field("Last modified By"; Rec."Last modified By")
                {
                    ToolTip = 'Specifies the value of the Last modified By field.', Comment = '%';
                }
            }
        }
    }
}
