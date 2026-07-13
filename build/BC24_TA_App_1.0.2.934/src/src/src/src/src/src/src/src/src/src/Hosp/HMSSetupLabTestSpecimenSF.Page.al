Page 50941 "HMS Setup Lab Test Specimen SF"
{
    PageType = List;
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
                field(MaximumValue; Rec."Maximum Value")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Maximum Value field.';
                }
            }
        }
    }

    actions { }
}

