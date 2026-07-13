Page 50664 "Incident Card"
{
    PageType = Card;
    SourceTable = "Sec-Visitor Management";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(No; Rec.No)
                {
                    Caption = 'Incident Number';
                    ApplicationArea = Basic;
                    Enabled = false;
                    ToolTip = 'Specifies the value of the Incident Number field.';
                }
                field(IncidentCategory; Rec."Incident Category")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Incident Category field.';
                }
                field("Incident Description"; Rec."Incident Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Incident Description field.';
                }
                field("Visit No."; Rec."Visit No.")
                {
                    ApplicationArea = Basic;
                    Enabled = SetEnabled;
                    ToolTip = 'Specifies the value of the Visit No. field.';
                }
                field(VisitorCategory; Rec."Visitor Category")
                {
                    ApplicationArea = Basic;
                    Enabled = SetEnabled;
                    ToolTip = 'Specifies the value of the Visitor Category field.';
                }
                field("Visitor Name"; Rec."Visitor Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Visitors Name';
                    Enabled = SetEnabled;
                    ToolTip = 'Specifies the value of the Visitors Name field.';
                }
                field(PurposeofVisit; Rec."Purpose of Visit")
                {
                    ApplicationArea = Basic;
                    Enabled = SetEnabled;
                    ToolTip = 'Specifies the value of the Purpose of Visit field.';
                }
                field(Station; Rec.Station)
                {
                    ApplicationArea = Basic;
                    Caption = 'Concerned Department';
                    Enabled = SetEnabled;
                    ToolTip = 'Specifies the value of the Concerned Department field.';
                }
                field(Department; Rec.Department)
                {
                    ApplicationArea = Basic;
                    Caption = 'Concerned Department';
                    Enabled = SetEnabled;
                    ToolTip = 'Specifies the value of the Concerned Department field.';
                }
                field(IDNumber; Rec."ID Number")
                {
                    ApplicationArea = Basic;
                    Enabled = SetEnabled;
                    ToolTip = 'Specifies the value of the ID Number field.';
                }
                field(PhoneNumber; Rec."Phone Number")
                {
                    ApplicationArea = Basic;
                    Enabled = SetEnabled;
                    ToolTip = 'Specifies the value of the Phone Number field.';
                }
                field("Person To See"; Rec."Person To See")
                {
                    ApplicationArea = Basic;
                    Caption = 'Person To Visit No.';
                    Enabled = SetEnabled;
                    ToolTip = 'Specifies the value of the Person To Visit No. field.';
                }
                field("Person To See Name"; Rec."Person To See Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Person To Visit Name';
                    Enabled = SetEnabled;
                    ToolTip = 'Specifies the value of the Person To Visit Name field.';
                }
                field(VisitorPassNo; Rec."Visitor Pass No.")
                {
                    ApplicationArea = Basic;
                    Enabled = SetEnabled;
                    ToolTip = 'Specifies the value of the Visitor Pass No. field.';
                }
                field(VisitorCarRegNumber; Rec."Visitor Car Reg Number")
                {
                    ApplicationArea = Basic;
                    Enabled = SetEnabled;
                    ToolTip = 'Specifies the value of the Visitor Car Reg Number field.';
                }
                field("Vessel Reg. No"; Rec."Vessel Reg. No")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    Enabled = SetEnabled;
                    ToolTip = 'Specifies the value of the Vessel Reg. No field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = SetEnabled;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field(IncidentReported; Rec."Incident Reported")
                {
                    ApplicationArea = Basic;
                    Enabled = SetEnabled;
                    ToolTip = 'Specifies the value of the Incident Reported field.';
                }
                field(ReportedBy; Rec."Initiated By")
                {
                    ApplicationArea = Basic;
                    Caption = 'Reported By';
                    Editable = false;
                    Enabled = SetEnabled;
                    ToolTip = 'Specifies the value of the Reported By field.';
                }
                field(ReportedDate; Rec."Initiated Date")
                {
                    ApplicationArea = Basic;
                    Caption = 'Reported Date';
                    Editable = false;
                    Enabled = SetEnabled;
                    ToolTip = 'Specifies the value of the Reported Date field.';
                }
                field(ReportedByTime; Rec."Initiated By Time")
                {
                    ApplicationArea = Basic;
                    Caption = 'Reported By Time';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Reported By Time field.';
                }
            }
            group(IncidentReport)
            {
                Caption = 'Incident Report';
                field(IncidentDetails; Rec."Incident Details")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Incident Details field.';
                }
                field(IncidentWitness; Rec."Incident Witness")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Incident Witness field.';
                }
                field(WitnessContacts; Rec."Witness Contacts")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Witness Contacts field.';
                }
                field(WitnessID; Rec."Witness ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Witness ID field.';
                }
                field(ActionRecommended; Rec."Action Recommended")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Action Recommended field.';
                }
                field(ActionTaken; Rec."Action Taken")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Action Taken field.';
                }
            }
        }
        area(factboxes)
        {
            part("Attached Documents"; "Document Attachments")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(70134915),
                              "No." = FIELD(No);
            }
        }
    }
    actions
    {
        area(creation)
        {
            action("Action Taken")
            {
                ApplicationArea = Basic;
                Caption = 'Action Taken';
                Image = AddContacts;
                Promoted = true;
                PromotedIsBig = true;
                ToolTip = 'Executes the Action Taken action.';

                trigger OnAction()
                begin
                    if Confirm('Execute Recommended Action?', true) = false then Error('Cancelled by user: ' + UserId);

                    Rec."Action Taken" := true;
                    Rec.Modify;
                    Message('Action Executed!');
                end;
            }
        }
    }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        GenSetu: Record "Security Setups";
        NoSeriesMgt: Codeunit "No. Series";
    begin
        if Rec.No = '' then begin
            GenSetu.Get;
            GenSetu.TestField(GenSetu."Incident Nos");
            Rec.No:=NoSeriesMgt.GetNextNo(GenSetu."Incident Nos",  0D, true);
        end;
        Rec."Incident Reported" := true;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        SetEnabled := false;
        if Rec."Visit No." <> '' then begin
            SetEnabled := false;
        end;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Validate("Visit No.");
    end;

    var
        SetEnabled: Boolean;
}

