Page 50750 "Mail Register View"
{
    Editable = false;
    PageType = List;
    SourceTable = "Mail Register";
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
                field(FolioNumber; Rec."Folio Number")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Folio Number field.';
                }
                field(Received; Rec.Received)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Received field.';
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
                field(FileTab; Rec."File Tab")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the File Tab field.';
                }
                field(FolioNo; Rec."Folio No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Folio No field.';
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
                field(MailStatus; Rec."Mail Status")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Mail Status field.';
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(Disp)
            {
                ApplicationArea = Basic;
                Caption = 'Dispatch';
                Image = ReleaseShipment;
                Promoted = true;
                PromotedIsBig = true;
                ToolTip = 'Executes the Dispatch action.';

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

                    if (Confirm('Send mail to dispatch?', true) = true) then begin
                        Rec."Mail Status" := Rec."mail status"::Dispatch;
                        Rec.Modify;
                    end;
                    Message('Successfully send to dispatch.');
                end;
            }
        }
    }
}

