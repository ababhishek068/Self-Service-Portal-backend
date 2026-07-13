Page 50830 "HMS ward Setup"
{
    PageType = Card;
    SourceTable = "HMS Ward Setup";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field(WardCode; Rec."Ward Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Ward Code field.';
                }
                field(WardName; Rec."Ward Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Ward Name field.';
                }
            }
        }
    }

    actions { }
}

