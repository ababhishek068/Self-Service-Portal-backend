Page 50831 "HMS Setup Test Specimen List"
{
    PageType = ListPart;
    SourceTable = "HMS Setup Test Specimen";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field(Specimen; Rec.Specimen)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Specimen field.';
                }
                field(SpecimenName; Rec."Specimen Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Specimen Name field.';
                }
                field(MeasuringUnit; Rec."Measuring Unit")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Measuring Unit field.';
                }
                field(MinimumValue; Rec."Minimum Value")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Minimum Value field.';
                }
            }
        }
    }

    actions { }
}

