Page 51447 "HMS Physiotherapy Types"
{
    PageType = List;
    SourceTable = "HMS PhysioTypes";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(pfno; Rec.pfno)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the pfno field.';
                }
                field("code"; Rec.code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the code field.';
                }
                field(Amounttt; Rec.Amounttt)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Amounttt field.';
                }
            }
        }
    }

    actions { }
}

