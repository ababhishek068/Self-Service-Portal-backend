Page 50496 "New Outbound Mails Document"
{
    PageType = Document;
    SourceTable = "Mail Register";
    // SourceTableView = where("Direction Type" = filter("Outgoing Mail (Internal)" | "Outgoing Mail (External)"),
    //                         "Mail Status" = filter(New));
    UsageCategory = Documents;
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
                field("Subject of Doc."; Rec."Subject of Doc.")
                {
                    Caption = 'Subject';
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Subject field.';
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
                field(Comments; Rec.Comments)
                {

                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Comments field.';
                }
                field("Direction Type"; Rec."Direction Type")
                {

                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Direction Type field.';
                }

            }
        }
        area(factboxes)
        {
            part("Attached Documents"; "Document Attachments")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(70134919),
                              "No." = FIELD("No");
            }
            systempart(Control25; Notes) { }
            systempart(Control26; MyNotes) { }
            systempart(Control27; Links) { }
        }
    }

    actions
    {
        area(Processing)
        {

            action(Disp)
            {
                ApplicationArea = all;
                Caption = 'Request Dispatch';
                Image = ReleaseShipment;
                ToolTip = 'Executes the Request Dispatch action.';
                // Promoted = true;
                // PromotedIsBig = true;

                trigger OnAction()
                begin
                    Rec.TestField("Subject of Doc.");
                    Rec.TestField("Mail Date");
                    // TestField(Addressee);
                    // TestField("mail Time");
                    // TestField(Comments);


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
        Rec."Mail Status" := Rec."Mail Status"::New;
    end;
}

