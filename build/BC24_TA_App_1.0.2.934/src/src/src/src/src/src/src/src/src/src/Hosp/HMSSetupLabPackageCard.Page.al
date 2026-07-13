Page 50797 "HMS Setup Lab Package Card"
{
    PageType = Card;
    SourceTable = "HMS Setup Lab Package";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Control1)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
            }
            part(Control1102760000; "HMS Setup Lab Pack Test SF")
            {
                SubPageLink = "Lab Package" = field(Code);
            }
        }
    }

    actions { }
}

