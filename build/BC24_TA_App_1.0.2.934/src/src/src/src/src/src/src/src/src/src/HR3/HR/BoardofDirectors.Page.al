Page 50335 "Board of Directors"
{
    PageType = Worksheet;
    SourceTable = "Board Of Directors";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(SurName; Rec.SurName)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the SurName field.';
                }
                field(OtherNames; Rec."Other Names")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Other Names field.';
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

