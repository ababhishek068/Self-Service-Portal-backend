Page 51331 "Appraisal Indicators"
{
    PageType = List;
    SourceTable = "HR Appraisal indicators";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(PerformanceIndicator; Rec."Performance Indicator")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Performance Indicator field.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
            }
        }
    }

    actions { }
}

