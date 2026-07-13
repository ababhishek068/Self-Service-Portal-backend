Page 50816 "HMS Treatment Form Processes"
{
    PageType = ListPart;
    SourceTable = "HMS Treatment Form Process";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {

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

            }
        }
    }

    actions { }
}

