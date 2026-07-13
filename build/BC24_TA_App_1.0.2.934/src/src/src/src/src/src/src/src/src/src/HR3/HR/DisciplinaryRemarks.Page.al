Page 51212 "Disciplinary Remarks"
{
    PageType = ListPart;
    SourceTable = "Disciplinary Remarks";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field(Remark; Rec.Remark)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Remark field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
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

