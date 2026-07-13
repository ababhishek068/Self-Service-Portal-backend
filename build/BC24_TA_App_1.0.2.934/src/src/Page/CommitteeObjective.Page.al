page 50952 "Committee Objective"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Committee Objectives";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Code field.';

                }
                field(Objective; Rec.Objective)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Objective field.';

                }
            }
        }
        area(Factboxes) { }
    }

    actions { }
}