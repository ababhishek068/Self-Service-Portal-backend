Page 51305 "HMS Admission Form Process"
{
    PageType = ListPart;
    SourceTable = "HMS Admission Form Process";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field(ProcessCode; Rec."Process Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Process Code field.';
                }
                field(Process; Rec.Process)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Process field.';
                }
                field(Mandatory; Rec.Mandatory)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Mandatory field.';
                }
                field(Performed; Rec.Performed)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Performed field.';
                }

                field(Time; Time)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Time field.';
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

