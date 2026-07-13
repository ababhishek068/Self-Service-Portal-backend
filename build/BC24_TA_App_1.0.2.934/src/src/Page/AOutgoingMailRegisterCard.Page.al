Page 50764 "A-Outgoing Mail Register Card"
{
    PageType = Card;
    SourceTable = "Mail Register";
    SourceTableView = where("Direction Type" = filter(= "Outgoing Mail (External)"));
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
                    OptionCaption = 'Outgoing Mail (Internal),Outgoing Mail (External)';
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
            }
        }
    }

    actions { }
}

