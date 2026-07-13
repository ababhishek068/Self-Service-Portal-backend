Page 50799 "HMS Setup Lab Test Card"
{
    PageType = Card;
    SourceTable = "HMS Setup Lab Test";
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
            part(Control1102760000; "HMS Setup Lab Test Specimen SF")
            {
                SubPageLink = Test = field(Code);
            }
        }
    }

    actions { }
}

