Page 50628 "FLT Posted Safari Notices List"
{
    CardPageID = "FLT Posted Safari Notices";
    PageType = List;
    SourceTable = "FLT-Safari Notice";
    SourceTableView = where(Status = filter(Submitted));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater("Employee Safari Notices")
            {
                field(SafariNo; Rec."Safari No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Safari No. field.';
                }
                field(ProposedBy; Rec."Proposed By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Proposed By field.';
                }
                field(ProposerName; Rec."Proposer Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Proposer Name field.';
                }
                field(ProposerDepartment; Rec."Proposer Department")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Proposer Department field.';
                }
                field(ProposedDate; Rec."Proposed Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Proposed Date field.';
                }
                field(OfficerGoing; Rec."Officer Going")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Officer Going field.';
                }
                field(OfficerGoingName; Rec."Officer Going Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Officer Going Name field.';
                }
                field(OfficerDesignation; Rec."Officer Designation")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Officer Designation field.';
                }
                field(PurposeOfVisit; Rec."Purpose Of Visit")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Purpose Of Visit field.';
                }
                field(PlacetoVisit; Rec."Place to Visit")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Place to Visit field.';
                }
                field(DepartureDate; Rec."Departure Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Departure Date field.';
                }
                field(ReturnDate; Rec."Return Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Return Date field.';
                }
                field(DepartureMileage; Rec."Departure Mileage")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Departure Mileage field.';
                }
                field(RegNo; Rec."Reg. No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Reg. No field.';
                }
                field(Make; Rec.Make)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Make field.';
                }
                field("Trip Type"; Rec."Trip Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Trip Type field.';
                }
                field(EstimatedCostofSafari; Rec."Estimated Cost of Safari")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Estimated Cost of Safari field.';
                }
                field(Dept; Rec.Dept)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Dept field.';
                }
                field(TOName; Rec."T.O. Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the T.O. Name field.';
                }
                field(TOApprovalDate; Rec."T.O. Approval Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the T.O. Approval Date field.';
                }
                field(Makes; Rec.Makes)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Makes field.';
                }
                field(Model; Rec.Model)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Model field.';
                }
            }
        }
    }

    actions { }
}

