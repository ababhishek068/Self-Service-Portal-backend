Page 50824 "HMS Laboratory Request Line"
{
    PageType = ListPart;
    SourceTable = "HMS Laboratory Test Line";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
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
                field(AssignedUserID; Rec."Assigned User ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Assigned User ID field.';
                }
            }
        }
    }

    actions { }
}

