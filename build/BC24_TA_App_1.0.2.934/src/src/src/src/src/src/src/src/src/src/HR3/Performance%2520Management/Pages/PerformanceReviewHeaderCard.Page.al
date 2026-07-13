namespace PTL.HRMIS;

page 51524 "Performance Review Header Card"
{
    ApplicationArea = All;
    Caption = 'Performance Review Header Card';
    PageType = Card;
    SourceTable = "Performance Review Header";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field(No; Rec.No)
                {
                    ToolTip = 'Specifies the value of the No field.', Comment = '%';
                    Visible = false;
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
                    Editable = false;
                }
                field("Action Taken"; Rec."Action Taken")
                {
                    ToolTip = 'Specifies the value of the Action Taken field.', Comment = '%';
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.', Comment = '%';
                }
            }
            group(Lines)
            {
                part(PerformanceLines; "Performance Review Lines")
                {
                    SubPageLink = "Period Code" = field("Performance Period Code"), "Employee No" = field("Employee No");
                }
            }
        }
    }
}
