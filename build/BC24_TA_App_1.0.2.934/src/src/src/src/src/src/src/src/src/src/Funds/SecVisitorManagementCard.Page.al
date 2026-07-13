Page 50755 "Sec-Visitor Management Card"
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
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the No field.';
                }
                field(VisitorCategory; Rec."Visitor Category")
                {
                    ApplicationArea = Basic;
                    Caption = 'Visitor Category';
                    ToolTip = 'Specifies the value of the Visitor Category field.';
                }
                field("Visitor Name"; Rec."Visitor Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Visitor Name field.';
                }
                field("Person To See"; Rec."Person To See")
                {
                    ApplicationArea = Basic;
                    Caption = 'Person To Visit No.';
                    ToolTip = 'Specifies the value of the Person To Visit No. field.';
                }
                field("Person To See Name"; Rec."Person To See Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Person To Visit Name';
                    ToolTip = 'Specifies the value of the Person To Visit Name field.';
                }
                field(PurposeofVisit; Rec."Purpose of Visit")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Purpose of Visit field.';
                }
                field(IDNumber; Rec."ID Number")
                {
                    ApplicationArea = Basic;
                    Caption = 'ID Number';
                    ToolTip = 'Specifies the value of the ID Number field.';
                }
                field(PhoneNumber; Rec."Phone Number")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Phone Number field.';
                }
                field(VisitorCarRegNumber; Rec."Visitor Car Reg Number")
                {
                    ApplicationArea = Basic;
                    Visible = true;
                    ToolTip = 'Specifies the value of the Visitor Car Reg Number field.';
                }
                field(Station; Rec.Station)
                {
                    ApplicationArea = Basic;
                    Enabled = false;
                    ToolTip = 'Specifies the value of the Station field.';
                }
                field(Department; Rec.Department)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Department field.';
                }
                field(VisitorPassNo; Rec."Visitor Pass No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Visitor Pass No. field.';
                }
                field(CarRegNumber; Rec."Car Reg. Number")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Car Reg. Number field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field(InitiatedBy; Rec."Initiated By")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Initiated By field.';
                }
                field(InitiatedDate; Rec."Initiated Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Initiated Date field.';
                }
                field(InitiatedByTime; Rec."Initiated By Time")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Initiated By Time field.';
                }
                field(ClearedBy; Rec."Cleared By")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Cleared By field.';
                }
                field(ClearedDate; Rec."Cleared Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Cleared Date field.';
                }
                field(ClearedByTime; Rec."Cleared By Time")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Cleared By Time field.';
                }
            }
            part(Items; "Visitor Items")
            {
                Caption = 'Visitor Items';
                ApplicationArea = basic;
                SubPageLink = No = field(No);
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
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        GenSetu: Record "Security Setups";
        NoSeriesMgt: Codeunit "No. Series";
    begin
        if Rec.No = '' then begin
            GenSetu.Get;
            GenSetu.TestField(GenSetu."Incident Nos");
            Rec.No:=NoSeriesMgt.GetNextNo(GenSetu."Visitors Nos",  0D,true);
        end;
        Rec."Incident Reported" := false;
    end;
}

