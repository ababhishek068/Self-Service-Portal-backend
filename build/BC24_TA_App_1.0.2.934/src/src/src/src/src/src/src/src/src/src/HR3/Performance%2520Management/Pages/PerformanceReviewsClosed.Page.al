namespace PTL.HRMIS;

page 51528 "Performance Reviews Closed"
{
    ApplicationArea = All;
    Caption = 'Performance Reviews Closed';
    PageType = List;
    SourceTable = "Performance Review Header";
    UsageCategory = ReportsAndAnalysis;
    InsertAllowed = false;
    Editable = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(No; Rec.No)
                {
                    ToolTip = 'Specifies the value of the No field.', Comment = '%';
                }
                field("Employee No"; Rec."Employee No")
                {
                    ToolTip = 'Specifies the value of the Employee No field.', Comment = '%';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.', Comment = '%';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.', Comment = '%';
                }
                field("Project Manager"; Rec."Project Manager")
                {
                    ToolTip = 'Specifies the value of the Project Manager field.', Comment = '%';
                }
                field("Period Code"; Rec."Performance Period Code")
                {
                    ToolTip = 'Specifies the value of the Period Code field.', Comment = '%';
                }
                field("Overall Performance Target"; Rec."Overall Performance Target")
                {
                    ToolTip = 'Specifies the value of the Overall Performance Target field.', Comment = '%';
                }
                field("Total Score"; Rec."Total Score")
                {
                    ToolTip = 'Specifies the value of the Total Score field.', Comment = '%';
                }
                field("Action Taken"; Rec."Action Taken")
                {
                    ToolTip = 'Specifies the value of the Action Taken field.', Comment = '%';
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.', Comment = '%';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
            }
        }
    }
}
