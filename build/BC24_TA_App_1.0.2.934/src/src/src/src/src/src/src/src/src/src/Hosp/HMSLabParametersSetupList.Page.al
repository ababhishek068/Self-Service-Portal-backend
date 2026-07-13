Page 51057 "HMS Lab Parameters Setup List"
{
    PageType = List;
    SourceTable = "HMS Lab Parameters setup";
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
                field(TestNormalRanges; Rec."Test Normal Ranges")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Test Normal Ranges field.';
                }
                field(MinRange; Rec."Min Range")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Min Range field.';
                }
                field(MaxRange; Rec."Max Range")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Max Range field.';
                }
                field(TestNormalRanges2; Rec."Test Normal Ranges2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Test Normal Ranges2 field.';
                }
                field(Arrangement; Rec.Arrangement)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Arrangement field.';
                }
                field(Branch; Rec.Branch)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Branch field.';
                }
            }
        }
    }

    actions { }
}

