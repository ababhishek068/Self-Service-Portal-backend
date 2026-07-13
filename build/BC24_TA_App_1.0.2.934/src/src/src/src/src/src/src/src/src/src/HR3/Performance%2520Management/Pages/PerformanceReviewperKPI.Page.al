namespace PTL.HRMIS;

page 51527 "Performance Review (per KPI)"
{
    ApplicationArea = All;
    Caption = 'Performance Review (per KPI)';
    PageType = List;
    SourceTable = "Performance Review Lines";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Period Code"; Rec."Period Code")
                {
                    ToolTip = 'Specifies the value of the Period Code field.', Comment = '%';
                }
                field("Employee No"; Rec."Employee No")
                {
                    ToolTip = 'Specifies the value of the Employee No field.', Comment = '%';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.', Comment = '%';
                }
                field("Key Performance Indicator"; Rec."Key Performance Indicator")
                {
                    ToolTip = 'Specifies the value of the Key Performance Indicator field.', Comment = '%';
                }
                field("Agreed Performance Target"; Rec."Agreed Performance Target")
                {
                    ToolTip = 'Specifies the value of the Agreed Performance Target field.', Comment = '%';
                }
                field("Weighted Target"; Rec."Weighted Target")
                {
                    ToolTip = 'Specifies the value of the Weighted Target field.', Comment = '%';
                }
                field(Score; Rec.Score)
                {
                    ToolTip = 'Specifies the value of the Score field.', Comment = '%';
                }
                field("Weighted Score"; Rec."Weighted Score")
                {
                    ToolTip = 'Specifies the value of the Weighted Score field.', Comment = '%';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.', Comment = '%';
                }
            }
        }
    }
}
