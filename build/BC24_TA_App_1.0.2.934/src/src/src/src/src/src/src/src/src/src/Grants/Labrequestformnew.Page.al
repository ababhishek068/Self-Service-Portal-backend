Page 50455 "Lab request form new"
{
    PageType = Card;
    SourceTable = "Investigator Information";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group("Lab Requirements")
            {
                field(LTATestKnown; Rec."LTA Test  Known")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Lab testing algorithm known field.';
                }
                field(LTAProposalSubmission; Rec."LTA Proposal Submission")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Algorithm included with this proposal submission field.';
                }
                field(LTADescription; Rec."LTA Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Describe proposed testing schedule field.';
                }
                field(CoveredTests; Rec."Covered Tests")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Are all test lists covered by current test list? field.';
                }
                field(SPRstudy; Rec."SPR study")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Special processing requirements required? field.';
                }
                field(SPRDescription; Rec."SPR Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Describe special processing required field.';
                }
                field(SampleStorageRequirements; Rec."Sample Storage Requirements")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Special storage requirements for samples? field.';
                }
                field(SSRDestructionprot; Rec."SSR Destruction prot")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Special protocol required for sample destruction? field.';
                }
                field(SSRShipment; Rec."SSR Shipment?")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Do samples need to be shipped? field.';
                }
                field(SSRDescription; Rec."SSR Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Describe above special requirements field.';
                }
                field(DataStorageRequirements; Rec."Data Storage Requirements")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Special data storage requirements? field.';
                }
                field(DSRDescription; Rec."DSR Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Describe special data storage requirements field.';
                }
                field(SpecialRequirements; Rec."Special Requirements")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Special Requirements for laboratory staff? field.';
                }
                field(OddWorkingHours; Rec."Odd Working Hours")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Is there need for extended working hours field.';
                }
                field(Oddworkinghoursdescription; Rec."Odd working hours description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Describe above field.';
                }
            }
        }
    }

    actions { }
}

