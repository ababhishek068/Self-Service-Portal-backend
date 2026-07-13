Page 50769 "New Inbound Mails List"
{
    CardPageID = "New Inbound Mails Document";
    PageType = List;
    SourceTable = "Mail Register";
    SourceTableView = where("Direction Type" = filter("Incoming Mail (Internal)" | "Incoming Mail (External)"),
                            "Mail Status" = filter(New));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No; Rec.No)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No field.';
                }
                field(SubjectofDoc; Rec."Subject of Doc.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Subject of Doc. field.';
                }
                field(MailDate; Rec."Mail Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Mail Date field.';
                }
                field(Receiver; Rec.Receiver)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Receiver field.';
                }
                field(Comments; Rec.Comments)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Comments field.';
                }
                field(Doctype; Rec."Doc type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Doc type field.';
                }
                field(ChequeAmount; Rec."Cheque Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cheque Amount field.';
                }
                field(DirectionType; Rec."Direction Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Direction Type field.';
                }
                field(Email; Rec.Email)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Email field.';
                }
                field(DocRefNo; Rec."Doc Ref No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Doc Ref No. field.';
                }
                field(PersonRecording; Rec."Person Recording")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Person Recording field.';
                }
                field(DeliveredByMail; Rec."Delivered By (Mail)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Delivered By (Mail) field.';
                }
                field(DeliveredByPhone; Rec."Delivered By (Phone)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Delivered By (Phone) field.';
                }
                field(DeliveredByName; Rec."Delivered By (Name)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Delivered By (Name) field.';
                }
                field(DeliveredByID; Rec."Delivered By (ID)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Delivered By (ID) field.';
                }
                field(DeliveredByTown; Rec."Delivered By (Town)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Delivered By (Town) field.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control15; Notes) { }
            systempart(Control16; MyNotes) { }
            systempart(Control17; Links) { }
        }
    }

    actions
    {
        area(creation)
        {
            action(Sort)
            {
                ApplicationArea = Basic;
                Caption = 'Send for Action';
                Image = ReleaseShipment;
                Promoted = true;
                PromotedIsBig = true;
                ToolTip = 'Executes the Send for Action action.';

                trigger OnAction()
                begin
                    Rec.TestField("Subject of Doc.");
                    Rec.TestField("Mail Date");
                    Rec.TestField(Addressee);
                    Rec.TestField("mail Time");
                    Rec.TestField(Receiver);
                    Rec.TestField(Comments);
                    Rec.TestField("Delivered By (Mail)");
                    Rec.TestField("Delivered By (Phone)");
                    Rec.TestField("Delivered By (Name)");
                    Rec.TestField("Delivered By (ID)");
                    Rec.TestField("Delivered By (Town)");

                    if not (Confirm('Send mail to Sorting?', true) = true) then
                        Error('Cancelled!') else begin
                        Rec."Mail Status" := Rec."mail status"::Sorting;
                        Rec.Receiver := UserId;
                        Rec.Received := true;
                        Rec.Modify;
                    end;
                    Message('Successfully sent for sorting.');
                end;
            }
        }
    }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        /*  "Direction Type" := "Direction Type"::"Incoming Mail (Internal)";
         HRSetup.get;
         if No = '' then begin
             HRSetup.Get;
             HRSetup.TestField(HRSetup."Mail Nos");
             NoSeriesMgt.GetNextNo(HRSetup."Mail Nos", xRec."No. Series", 0D, No, "No. Series");
         end; */
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        HRSetup: Record "Security Setups";
        NoSeriesMgt: Codeunit "No. Series";
    begin
        HRSetup.get;
        if Rec.No = '' then begin
            HRSetup.Get;
            HRSetup.TestField(HRSetup."Mail Nos");
            Rec.No := NoSeriesMgt.GetNextNo(HRSetup."Mail Nos", 0D, true);
        end;
    end;
}

