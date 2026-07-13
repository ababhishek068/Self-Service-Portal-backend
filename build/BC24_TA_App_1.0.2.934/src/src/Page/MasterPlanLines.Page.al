page 51140 "MasterPlan Lines"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "PC MasterPlan Lines";


    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("Five Year Target"; Rec."Five Year Target")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Five Year Target field.';
                }
                field(Achievements; Rec.Achievements)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Achievements field.';
                }
                field(Shortfalls; Rec.Shortfalls)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Shortfalls field.';
                }
                field(Variance; Rec.Variance)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Variance field.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
                field("Risk Mitigation Factors"; Rec."Risk Mitigation Factors")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Risk Mitigation Factors field.';
                }
                field(Alterations; Rec.Alterations)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Alterations field.';
                }



            }
        }
    }
}

