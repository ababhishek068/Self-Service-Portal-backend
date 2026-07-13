Page 51315 "HMS Beds"
{
    PageType = Card;
    SourceTable = "HMS Beds";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field(WardNo; Rec."Ward No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Ward No field.';
                }
                field(BedNo; Rec."Bed No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Bed No field.';
                }
                field(BedName; Rec."Bed Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Bed Name field.';
                }
            }
        }
    }

    actions { }
}

