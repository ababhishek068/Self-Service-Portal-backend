Page 50775 "Inbound Mails (Sorting) Card"
{
    DeleteAllowed = true;
    Editable = true;
    InsertAllowed = true;
    PageType = Card;
    SourceTable = "Mail Register";
    ApplicationArea = All;
    // SourceTableView = where("Direction Type" = filter("Incoming Mail (Internal)" | "Incoming Mail (External)"),
    //                        "Mail Status" = filter(New));

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
                field(Received; Rec.Received)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Received field.';
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
                Caption = 'Mark as Sorted Mail';
                Image = ClearLog;
                Promoted = true;
                PromotedIsBig = true;
                ToolTip = 'Executes the Mark as Sorted Mail action.';

                trigger OnAction()
                begin

                    if (Confirm('Mark mail as Sorted?', true) = true) then begin
                        Rec."Mail Status" := Rec."mail status"::Sorted;
                        Rec.Modify;
                    end;
                    Message('Successfully Sorted.');
                end;
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    var
        HRSetup: Record "Security Setups";
        NoSeriesMgt: Codeunit "No. Series";
    begin
        HRSetup.get;
        if Rec.No = '' then begin
            HRSetup.Get;
            HRSetup.TestField(HRSetup."Mail Nos");
            // NoSeriesMgt.GetNextNo(HRSetup."Mail Nos", xRec."No. Series", 0D, Rec.No, Rec."No. Series");
            Rec.No := NoSeriesMgt.GetNextNo(HRSetup."Mail Nos", 0D, true);
        end;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
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

