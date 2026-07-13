Page 51307 "HMS Admission Injection"
{
    PageType = ListPart;
    SourceTable = "HMS Admission Injection";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field(Time; Rec.Time)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Time field.';
                }
                field(InjectionCode; Rec."Injection Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Injection Code field.';
                }
                field(InjectionName; Rec."Injection Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Injection Name field.';
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

