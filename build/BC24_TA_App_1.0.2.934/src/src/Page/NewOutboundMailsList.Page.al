Page 50770 "New Outbound Mails List"
{
    CardPageID = "New Outbound Mails Document";
    PageType = List;
    SourceTable = "Mail Register";
    SourceTableView = where("Direction Type" = filter("Outgoing Mail (Internal)" | "Outgoing Mail (External)"),
                            "Mail Status" = filter(New));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(No; Rec.No)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No field.';
                }

                field(MailDate; Rec."Mail Date")
                {
                    Caption = 'Date of Dispatch';
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date of Dispatch field.';
                }
                field(Addressee; Rec.Addressee)
                {
                    Caption = 'Mail Address';
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Mail Address field.';
                }
                field(Receiver; Rec.Receiver)
                {
                    Caption = 'Name of Receiving Officer';
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Name of Receiving Officer field.';
                }
                field("Receiving Officer Signature"; Rec."Receiving Officer Signature")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Receiving Officer Signature field.';
                }
                field(mailTime; Rec."mail Time")
                {
                    Caption = 'Time Letter Received';
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Time Letter Received field.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control25; Notes) { }
            systempart(Control26; MyNotes) { }
            systempart(Control27; Links) { }

        }

    }

    actions
    {
        area(creation)
        {
            action(Disp)
            {

                ApplicationArea = Basic;
                Caption = 'Request Dispatch';
                Image = ReleaseShipment;
                Promoted = true;
                PromotedIsBig = true;
                ToolTip = 'Executes the Request Dispatch action.';

                trigger OnAction()
                begin
                    Rec.TestField("Subject of Doc.");
                    Rec.TestField("Mail Date");
                    Rec.TestField(Addressee);
                    Rec.TestField("mail Time");
                    Rec.TestField(Comments);


                    if not (Confirm('Send mail to dispatch?', true) = true) then
                        Error('Cancelled!') else begin
                        Rec."Mail Status" := Rec."mail status"::Dispatch;
                        Rec.Dispatched := true;
                        Rec."Dispatched by" := UserId;
                        Rec.Modify;
                    end;
                    Message('Successfully send to dispatch.');
                end;
            }
        }
    }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."Direction Type" := Rec."Direction Type"::"Outgoing Mail (Internal)";

    end;
}

