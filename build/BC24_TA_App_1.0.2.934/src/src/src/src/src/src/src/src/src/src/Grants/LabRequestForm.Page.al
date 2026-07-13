Page 50448 "Lab Request Form"
{
    PageType = CardPart;
    SourceTable = "Lab request";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(ProposalNo; Rec."Proposal No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Proposal No. field.';
                }
                field(StudyPurposeUse; Rec."Study Purpose/Use")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Study Purpose/Use field.';
                }
                field(StudySynopsisAttached; Rec."Study Synopsis Attached")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Study Synopsis Attached field.';
                }
                field(LabTestingAlgorithmKnown; Rec."Lab Testing Algorithm Known")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Lab Testing Algorithm Known field.';
                }
                field(TestscheduleVolRepertoire; Rec."Test schedule/Vol./Repertoire")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Test schedule/Vol./Repertoire field.';
                }
                field(AllTestCoveredbyTestList; Rec."All Test Covered by Test List")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the All Test Covered by Test List field.';
                }
                field(TestListDescription; Rec."Test List Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Test List Description field.';
                }
                field(SpecimenIsolatesProcessing; Rec."Specimen/Isolates Processing")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Specimen/Isolates Processing field.';
                }
                field(SpecimenIsolatesProcessDesc; Rec."Specimen/Isolates Process Desc")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Specimen/Isolates Process Desc field.';
                }
                field(SpecialStorageRequired; Rec."Special Storage Required")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Special Storage Required field.';
                }
                field(DestroySamplesPerProtocol; Rec."Destroy Samples Per Protocol")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Destroy Samples Per Protocol field.';
                }
                field(SamplesneedtobeShipped; Rec."Samples need to be Shipped")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Samples need to be Shipped field.';
                }
                field(SamplesShippedDesc; Rec."Samples Shipped Desc")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Samples Shipped Desc field.';
                }
                field(SpecialDataHcopyStorage; Rec."Special Data/H.copy Storage")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Special Data/H.copy Storage field.';
                }
                field(SpecialDataHcopyDesc; Rec."Special Data/H.copy Desc.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Special Data/H.copy Desc. field.';
                }
                field(SpecialStaffworkinghrsReq; Rec."Special Staff/working hrs Req.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Special Staff/working hrs Req. field.';
                }
                field(SpecialStaffworkinghrsDesc; Rec."Special Staff/working hrs Desc")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Special Staff/working hrs Desc field.';
                }
                field(ExpImpPermitsRequired; Rec."Exp/Imp Permits Required")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Exp/Imp Permits Required field.';
                }
                field(IRECApproval; Rec."IREC Approval")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the IREC Approval field.';
                }
            }
        }
    }

    actions { }
}

