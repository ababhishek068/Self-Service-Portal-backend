Page 50663 "Incident Details"
{
    CardPageID = "Incident Card";
    Editable = false;
    PageType = List;
    SourceTable = "Sec-Visitor Management";
    SourceTableView = where("Incident Reported" = filter(true),
                            "Action Taken" = filter(false));
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No; Rec.No)
                {
                    Caption = 'Incident Number';
                    ApplicationArea = Basic;
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
                    ToolTip = 'Specifies the value of the Visit No. field.';
                }
                field("Visitor Name"; Rec."Visitor Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Visitor Name';
                    ToolTip = 'Specifies the value of the Visitor Name field.';
                }
                field(PurposeofVisit; Rec."Purpose of Visit")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Purpose of Visit field.';
                }
                field(Station; Rec.Station)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Station field.';
                }
                field(Department; Rec.Department)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Department field.';
                }
                field(IDNumber; Rec."ID Number")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the ID Number field.';
                }
                field(PhoneNumber; Rec."Phone Number")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Phone Number field.';
                }
                field("Person To See Name"; Rec."Person To See Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Person To See';
                    ToolTip = 'Specifies the value of the Person To See field.';
                }
                field(CarRegNumber; Rec."Car Reg. Number")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Car Reg. Number field.';
                }
                field("Vessel Reg. No"; Rec."Vessel Reg. No")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Vessel Reg. No field.';
                }
                field(VisitorPassNo; Rec."Visitor Pass No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Visitor Pass No. field.';
                }
                field(VisitorCarRegNumber; Rec."Visitor Car Reg Number")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Visitor Car Reg Number field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field(InitiatedBy; Rec."Initiated By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Initiated By field.';
                }
                field(InitiatedByTime; Rec."Initiated By Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Initiated By Time field.';
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
                label(Control21)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(admin)
            {
                ApplicationArea = Basic;
                Caption = 'Admit';
                Image = AddContacts;
                Promoted = true;
                PromotedIsBig = true;
                Visible = false;
                ToolTip = 'Executes the Admit action.';

                trigger OnAction()
                begin
                    Rec.TestField("Visitor Name");
                    Rec.TestField("ID Number");
                    Rec.TestField("Phone Number");
                    Rec.TestField("Person To See");
                    Rec.TestField("Purpose of Visit");
                    Rec.TestField(Department);
                    Rec.TestField("Visitor Pass No.");

                    if Confirm('Mark visitor as admitted?', true) = false then Error('Cancelled by user: ' + UserId);

                    Rec."Initiated By" := UserId;
                    Rec."Initiated By Time" := Time;
                    Rec."Initiated Date" := Today;
                    Rec.Status := Rec.Status::Entered;
                    Rec.Modify;
                    Message('Admitted!');
                end;
            }
        }
    }
}

