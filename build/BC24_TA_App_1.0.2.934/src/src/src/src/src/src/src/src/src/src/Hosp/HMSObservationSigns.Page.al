Page 51055 "HMS Observation Signs"
{
    PageType = ListPart;
    SourceTable = "HMS Observation Signs";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field(System; Rec.System)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the System field.';
                }
                field(SignCode; Rec."Sign Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Sign Code field.';
                }
                field(SignDescription; Rec."Sign Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Sign Description field.';
                }
            }
        }
    }

    actions { }
}

