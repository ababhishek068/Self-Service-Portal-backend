Page 50936 "Training Sources"
{
    PageType = ListPart;
    SourceTable = "Training Source";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field(Source; Rec.Source)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Source field.';
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

