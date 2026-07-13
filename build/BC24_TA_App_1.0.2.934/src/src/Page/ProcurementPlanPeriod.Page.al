Page 50733 "Procurement Plan Period"
{
    PageType = List;
    SourceTable = "Procurement Plan Period";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(PeriodName; Rec."Period Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Period Name field.';
                }
            }
        }
    }

    actions { }
}

