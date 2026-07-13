Page 50116 "Religions Card"
{
    PageType = Card;
    SourceTable = Religions;
    ApplicationArea = All;


    layout
    {
        area(content)
        {
            group(General)
            {
                field(Religion; Rec.Religion)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Religion field.';
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

