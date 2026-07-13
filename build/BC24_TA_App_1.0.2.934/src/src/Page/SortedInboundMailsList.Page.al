Page 50528 "Sorted Inbound Mails List"
{
    CardPageID = "New Inbound Mails Document";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Mail Register";
    SourceTableView = where("Mail Status" = filter(Sorted));
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

    actions { }
}

