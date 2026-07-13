Page 50833 "HMS Signs"
{
    PageType = List;
    SourceTable = "HMS Signs Setup";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field(SignCode; Rec."Sign Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Sign Code field.';
                }
                field(SignsName; Rec."Signs Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Signs Name field.';
                }
                field(System; Rec.System)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the System field.';
                }
            }
        }
    }

    actions { }
}

