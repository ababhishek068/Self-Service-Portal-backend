page 51466 "Benefits SetUp"
{
    ApplicationArea = All;
    Caption = 'Benefits SetUp';
    PageType = List;
    SourceTable = "Benefits SetUp";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Job Id"; Rec."Job Id")
                {
                    ToolTip = 'Specifies the value of the Job Id field.', Comment = '%';
                    
                }
                field(Grade; Rec.Grade)
                {
                    ToolTip = 'Specifies the value of the Grade field.', Comment = '%';
                }
                field("Branch Code"; Rec."Branch Code")
                {
                    ToolTip = 'Specifies the value of the Branch Code field.', Comment = '%';
                }
                field("Basic Pay"; Rec."Basic Pay")
                {
                    ToolTip = 'Specifies the value of the Basic Pay field.', Comment = '%';
                }
                field("Hardship Allowance"; Rec."Hardship Allowance")
                {
                    ToolTip = 'Specifies the value of the Hardship Allowance field.', Comment = '%';
                }
            }
        }
    }
}
