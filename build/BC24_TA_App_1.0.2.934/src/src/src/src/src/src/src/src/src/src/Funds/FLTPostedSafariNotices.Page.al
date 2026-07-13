page 50627 "FLT Posted Safari Notices"
{
    PageType = Card;
    SourceTable = "FLT-Safari Notice";
    SourceTableView = WHERE(Status = FILTER(Submitted));
    Caption = 'FLT Posted Safari Memos';
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group("Employee Safari Notices")
            {
                field("Safari No."; Rec."Safari No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Safari No. field.';
                }
                field("Proposed By"; Rec."Proposed By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Proposed By field.';
                }
                field("Proposer Name"; Rec."Proposer Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Proposer Name field.';
                }
                field("Proposer Department"; Rec."Proposer Department")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Proposer Department field.';
                }
                field("Proposed Date"; Rec."Proposed Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Proposed Date field.';
                }
                field("Officer Going"; Rec."Officer Going")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Officer Going field.';
                }
                field("Officer Going Name"; Rec."Officer Going Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Officer Going Name field.';
                }
                field("Officer Designation"; Rec."Officer Designation")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Officer Designation field.';
                }
                field("Purpose Of Visit"; Rec."Purpose Of Visit")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Purpose Of Visit field.';
                }
                field("Place to Visit"; Rec."Place to Visit")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Place to Visit field.';
                }
                field("Departure Date"; Rec."Departure Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Departure Date field.';
                }
                field("Return Date"; Rec."Return Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Return Date field.';
                }
                field("Departure Mileage"; Rec."Departure Mileage")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Departure Mileage field.';
                }
                field("Reg. No"; Rec."Reg. No")
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
                field("Estimated Cost of Safari"; Rec."Estimated Cost of Safari")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Estimated Cost of Safari field.';
                }
                field(Dept; Rec.Dept)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Dept field.';
                }
                field("T.O. Name"; Rec."T.O. Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the T.O. Name field.';
                }
                field("T.O. Approval Date"; Rec."T.O. Approval Date")
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
                part("Officers Going on Safari"; "FLT Officers Going on Safari")
                {
                    ApplicationArea = Basic;
                    Caption = 'Officers Going on Safari';
                    SubPageLink = "Safari No." = FIELD("Safari No.");
                }
            }
        }
    }

    actions { }
}

