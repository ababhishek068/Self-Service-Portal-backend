Page 51054 "HMS Patient Immunization"
{
    PageType = ListPart;
    SourceTable = "HMS Patient Immunization";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field(ImmunizationCode; Rec."Immunization Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Immunization Code field.';
                }

                field(Yes; Rec.Yes)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Yes field.';
                }
                field(ImmunizationDate; Rec."Immunization Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Immunization Date field.';
                }
            }
        }
    }

    actions { }
}

