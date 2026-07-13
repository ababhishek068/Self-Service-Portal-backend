Page 50665 "Incidents Pending"
{
    CardPageID = "Incident Card";
    Editable = false;
    PageType = List;
    SourceTable = "Sec-Visitor Management";
    SourceTableView = where(Status = filter(Entered),
                            "Incident Reported" = filter(true),
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
                field("Visit No."; Rec."Visit No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Visit No. field.';
                }
                field(VisitorName; Rec."Person To See")
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
                field(Control12; Rec."Visitor Name")
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
                field(ClearedBy; Rec."Cleared By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cleared By field.';
                }
                field(ClearedByTime; Rec."Cleared By Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cleared By Time field.';
                }
                field(NoSeries; Rec."No. Series")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No. Series field.';
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
                    /*TESTFIELD("Visitor Name");
                    TESTFIELD("ID Number");
                    TESTFIELD("Phone Number");
                    TESTFIELD("Person To See");
                    TESTFIELD("Purpose of Visit");
                    TESTFIELD(Department);
                    TESTFIELD("Visitor Pass No.");
                    */
                    if Confirm('Execute Recommended Action?', true) = false then Error('Cancelled by user: ' + UserId);

                    Rec."Initiated By" := UserId;
                    Rec."Initiated By Time" := Time;
                    Rec."Initiated Date" := Today;
                    Rec."Action Taken" := true;
                    Rec.Modify;
                    Message('Action Executed!');

                end;
            }
        }
    }
}

