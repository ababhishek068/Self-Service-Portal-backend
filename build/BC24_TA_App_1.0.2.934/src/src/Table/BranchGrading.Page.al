page 51473 "Branch Grading"
{
    ApplicationArea = All;
    Caption = 'Branch Grading';
    PageType = List;
    SourceTable = "Branch Grading";
    UsageCategory = Administration;
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Branch Code"; Rec."Branch Code")
                {
                    ToolTip = 'Specifies the value of the Branch Code field.', Comment = '%';
                }
                field("Branch Grade"; Rec."Branch Grade")
                {
                    ToolTip = 'Specifies the value of the Branch Grade field.', Comment = '%';
                }
                field("Branch Name"; Rec."Branch Name")
                {
                    ToolTip = 'Specifies the value of the Branch Name field.', Comment = '%';
                }
                field(StartDate; Rec.StartDate)
                {
                    ToolTip = 'Specifies the value of the StartDate field.', Comment = '%';
                }
                field(EndDate; Rec.EndDate)
                {
                    ToolTip = 'Specifies the value of the EndDate field.', Comment = '%';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
                field("Created By"; Rec."Created By")
                {
                    ToolTip = 'Specifies the value of the Created By field.', Comment = '%';
                }
                field("Date Created"; Rec."Date Created")
                {
                    ToolTip = 'Specifies the value of the Date Created field.', Comment = '%';
                }
            }
        }
    }
}
