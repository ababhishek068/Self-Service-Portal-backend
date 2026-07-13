Page 50696 "HMS Setup Injection Card"
{
    PageType = Card;
    SourceTable = "HMS Setup Injection";
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
                field(ItemNo; Rec."Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Item No. field.';
                }
            }
        }
    }

    actions { }
}

