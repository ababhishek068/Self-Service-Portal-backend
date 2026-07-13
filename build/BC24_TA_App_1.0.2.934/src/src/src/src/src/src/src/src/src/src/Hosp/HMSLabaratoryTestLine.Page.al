Page 50825 "HMS Labaratory Test Line"
{
    PageType = ListPart;
    SourceTable = "HMS Laboratory Test Line";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(LaboratoryTestCode; Rec."Laboratory Test Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Laboratory Test Code field.';
                }
                field(LaboratoryTestName; Rec."Laboratory Test Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Laboratory Test Name field.';
                }
                field(SpecimenCode; Rec."Specimen Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Specimen Code field.';
                }
                field(SpecimenName; Rec."Specimen Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Specimen Name field.';
                }
                field(CollectionDate; Rec."Collection Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Collection Date field.';
                }
                field(CollectionTime; Rec."Collection Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Collection Time field.';
                }
                field(MeasuringUnitCode; Rec."Measuring Unit Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Measuring Unit Code field.';
                }
                field(MeasuringUnitName; Rec."Measuring Unit Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Measuring Unit Name field.';
                }
                field(CountValue; Rec."Count Value")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Count Value field.';
                }
                field(Positive; Rec.Positive)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Positive field.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
                field(Completed; Rec.Completed)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Completed field.';
                }
            }
        }
    }

    actions { }
}

