Page 50427 "Appraisal Periods"
{
    PageType = list;
    SourceTable = "Appraisal Periods";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field(Period; Rec.Period)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Period field.';
                }
                field(Comments; Rec.Comments)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Comments field.';
                }
            }
        }
    }

    actions { }
}

