Page 50587 "Outbound Mails Card"
{

    PageType = Document;
    SourceTable = "Mail Register";
    SourceTableView = where("Direction Type" = filter("Outgoing Mail (Internal)" | "Outgoing Mail (External)"),
                            "Mail Status" = filter(Dispatch));
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
                field(Addressee; Rec.Addressee)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Addressee field.';
                }
                field(mailTime; Rec."mail Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the mail Time field.';
                }
                field(Receiver; Rec.Receiver)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Receiver field.';
                }
                field(AddreseeType; Rec."Addresee Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Addresee Type field.';
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
                field(Dispatched; Rec.Dispatched)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Dispatched field.';
                }
                field(Dispatchedby; Rec."Dispatched by")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Dispatched by field.';
                }
                field(stampcost; Rec."stamp cost")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the stamp cost field.';
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
        area(creation)
        {
            action(Release)
            {
                ApplicationArea = Basic;
                Caption = 'Release Mail';
                Image = ClearLog;
                Promoted = true;
                PromotedIsBig = true;
                ToolTip = 'Executes the Release Mail action.';

                trigger OnAction()
                begin

                    if (Confirm('Mark mail as Released?', true) = true) then begin
                        Rec."Mail Status" := Rec."mail status"::Dispatched;
                        Rec.Modify;
                    end;
                    Message('Successfully Released.');
                end;
            }
        }
    }
}

