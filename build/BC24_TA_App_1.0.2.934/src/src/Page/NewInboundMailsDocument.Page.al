Page 50495 "New Inbound Mails Document"
{
    PageType = Document;
    SourceTable = "Mail Register";
    // SourceTableView = where("Direction Type" = filter("Incoming Mail (Internal)" | "Incoming Mail (External)"),
    //                        "Mail Status" = filter(New));
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

                field("Date Received"; Rec."Date Received")
                {
                    Caption = 'Date of Received';
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date of Received field.';
                }
                field("mail Time"; Rec."mail Time")
                {
                    Caption = 'Time Received';
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Time Received field.';
                }
                field("Mail Date"; Rec."Mail Date")
                {
                    Caption = 'Date of Correspondence';
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date of Correspondence field.';
                }
                field("Folio Number"; Rec."Folio Number")
                {
                    Caption = 'Refference Number';
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Refference Number field.';
                }
                field(Addressee; Rec.Addressee)
                {
                    Caption = 'From Whom the Letter was Received';
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the From Whom the Letter was Received field.';
                }

                field("Subject of Doc."; Rec."Subject of Doc.")
                {
                    Caption = 'Subject of the Letter';
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Subject of the Letter field.';
                }
                field("Folio No"; Rec."Folio No")
                {
                    Caption = 'File Reffrence Number';
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the File Reffrence Number field.';
                }
                field(Receiver; Rec.Receiver)
                {

                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Receiver field.';
                }
                field(Receiver2; Rec.Receiver2)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Receiver2 field.';
                }
                field(Receiver3; Rec.Receiver3)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Receiver3 field.';
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
            systempart(Control15; Notes) { }
            systempart(Control16; MyNotes) { }
            systempart(Control17; Links) { }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Sorting")
            {
                ApplicationArea = All;
                Caption = 'Send for Action';
                Image = ReleaseShipment;
                ToolTip = 'Executes the Send for Action action.';
                // Promoted = true;
                //  PromotedIsBig = true;

                trigger OnAction()
                var
                    smtp: Codeunit HRWebportal;
                    HrEmp: Record "HR-Employee";
                begin
                    Rec.TestField("Subject of Doc.");
                    Rec.TestField("Mail Date");
                    // TestField(Addressee);
                    // TestField("mail Time");
                    Rec.TestField(Receiver);
                    // TestField(Comments);
                    // TestField("Delivered By (Mail)");
                    // TestField("Delivered By (Phone)");
                    //  TestField("Delivered By (Name)");
                    //  TestField("Delivered By (ID)");
                    //  TestField("Delivered By (Town)");

                    if not (Confirm('Send mail to Sorting?', true) = true) then
                        Error('Cancelled!') else begin
                        Rec."Mail Status" := Rec."Mail Status"::Sorting;
                        Rec.Receiver := UserId;
                        Rec.Received := true;
                        Rec.Modify;
                        if HrEmp.Get(Rec.Receiver2) then
                            smtp.SendEmail(HrEmp."Company E-Mail", 'Inbound Mail Document No.' + Rec.No, 'Check on inbound mail document No.' + Rec.No + ' needs your action');
                    end;
                    Message('Successfully send for sorting.');
                end;
            }
        }
    }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        HRSetup: Record "Security Setups";
        NoSeriesMgt: Codeunit "No. Series";
    begin
        Rec."Direction Type" := Rec."Direction Type"::"Incoming Mail (Internal)";
        Rec."Mail Status" := Rec."Mail Status"::New;
        HRSetup.get;
        if Rec.No = '' then begin
            HRSetup.Get;
            HRSetup.TestField(HRSetup."Mail Nos");
            Rec.No:=NoSeriesMgt.GetNextNo(HRSetup."Mail Nos", 0D, true);
        end;

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
            Rec.No:=NoSeriesMgt.GetNextNo(HRSetup."Mail Nos",0D, true);
        end;
    end;
}

