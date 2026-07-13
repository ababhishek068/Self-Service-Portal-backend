page 50235 "Contract Milestones"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Contract Milestones";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Select; Rec.Select)
                {
                    ToolTip = 'Specifies the value of the Select field.';

                    trigger OnValidate()
                    begin
                        IF Rec."Milestone Status" = Rec."Milestone Status"::Pending THEN ERROR('Cannot select a Pending milestone');
                    end;
                }
                field("Contract No"; Rec."Contract No")
                {
                    ToolTip = 'Specifies the value of the Contract No field.';
                }
                field("GL Account"; Rec."GL Account")
                {
                    ToolTip = 'Specifies the value of the GL Account field.';
                }
                field(Milestone; Rec."Milestone Name")
                {
                    ToolTip = 'Specifies the value of the Milestone Name field.';
                }
                field(Duration; Rec.Duration)
                {
                    ToolTip = 'Specifies the value of the Duration field.';
                }
                field("Start Date"; Rec."Start Date")
                {
                    ToolTip = 'Specifies the value of the Start Date field.';
                }
                field("End Date"; Rec."End Date")
                {
                    ToolTip = 'Specifies the value of the End Date field.';
                }
                field("Amount Paybale"; Rec."Amount Paybale")
                {
                    ToolTip = 'Specifies the value of the Amount Paybale field.';
                }
                field("% Paid"; Rec."% Paid")
                {
                    ToolTip = 'Specifies the value of the % Paid field.';

                }
                field("Milestone Status"; Rec."Milestone Status")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Milestone Status field.';
                }
            }
        }
        area(Factboxes) { }
    }

    actions
    {
        area(processing)
        {
            action("Generate Invoice")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Generate Invoice action.';

                trigger OnAction()
                begin
                    Milestones.RESET;
                    Milestones.SETRANGE(Select, TRUE);
                    IF Milestones.FIND('-') THEN BEGIN
                        REPEAT
                            Milestones.TESTFIELD("Contract No");
                            Milestones.TESTFIELD("Milestone Name");
                            Milestones.TESTFIELD("Amount Paybale");
                            Milestones.TESTFIELD(Milestones.Duration);
                            Milestones.VALIDATE(Milestones.Duration);
                            Milestones.VALIDATE(Milestones."Amount Paybale");
                            Milestones.VALIDATE(Milestones."GL Account");
                            Milestones."Milestone Status" := Milestones."Milestone Status"::Completed;
                            Milestones.MODIFY;
                        UNTIL Milestones.NEXT = 0;
                        IF CONFIRM('Milestones Marked as Complete. Do you want to raise an invoice?') = FALSE THEN ERROR('Invoice not generated');
                        Milestones2.RESET;
                        Milestones2.SETRANGE(Select, TRUE);
                        IF Milestones2.FIND('-') THEN BEGIN
                            NextNo := '';
                            LineNo := 10000;
                            REPEAT
                                LineNo := LineNo + 10000;
                                IF Contracts.GET(Milestones2."Contract No") THEN
                                    IF NOT PurchaseHeader.GET(PurchaseHeader."Document Type"::Invoice, NextNo) THEN BEGIN
                                        //insert invoice
                                        PurchaseSetup.Get();
                                        PurchaseSetup.TestField("Invoice Nos.");
                                        PurchaseHeader.INIT;
                                        NextNo := NoSeriesMgt.GetNextNo(PurchaseSetup."Invoice Nos.", 0D, TRUE);
                                        PurchaseHeader."No." := NextNo;
                                        PurchaseHeader."Buy-from Vendor No." := Contracts."Contractor No.";
                                        PurchaseHeader.VALIDATE("Buy-from Vendor No.");
                                        PurchaseHeader."Pay-to Vendor No." := Contracts."Contractor No.";
                                        PurchaseHeader.VALIDATE("Pay-to Vendor No.");
                                        PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::Invoice;
                                        PurchaseHeader."Document Date" := TODAY;
                                        PurchaseHeader."Contract No." := Contracts."Contract No.";
                                        PurchaseHeader."Posting Description" := Milestones2."Milestone Name";
                                        PurchaseHeader.INSERT(TRUE);
                                    END;
                                IF NextNo <> '' THEN BEGIN
                                    //Insert Purchase Lines
                                    PurchLine.INIT;
                                    PurchLine."Document Type" := PurchLine."Document Type"::Invoice;
                                    PurchLine."Document No." := NextNo;
                                    PurchLine."Line No." := LineNo;
                                    PurchLine.Amount := Rec."Amount Paybale";
                                    PurchLine.Type := PurchLine.Type::"G/L Account";
                                    PurchLine."No." := Milestones2."GL Account";
                                    PurchLine."Buy-from Vendor No." := Contracts."Contractor No.";
                                    PurchLine."Amount Including VAT" := Rec."Amount Paybale";
                                    PurchLine.Quantity := 1;
                                    PurchLine."Direct Unit Cost" := Rec."Amount Paybale";
                                    PurchLine."Line Amount" := Rec."Amount Paybale";
                                    PurchLine.VALIDATE("No.");
                                    PurchLine.VALIDATE("Buy-from Vendor No.");
                                    PurchLine.VALIDATE(Description);
                                    PurchLine.VALIDATE("Document No.");
                                    PurchLine.VALIDATE("Document Type");
                                    PurchLine.VALIDATE(Amount);
                                    PurchLine.INSERT(TRUE);

                                END;
                                Milestones2.Select := FALSE;
                                Milestones2.MODIFY;
                            UNTIL Milestones2.NEXT = 0;
                            PurchaseHeader.GET(PurchaseHeader."Document Type"::Invoice, NextNo);
                            PAGE.RUN(51, PurchaseHeader);
                        END;
                    END ELSE
                        ERROR('Please select atleast one milestone');
                end;
            }

            action(CloseMilestone)
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Close;
                ToolTip = 'Executes the CloseMilestone action.';
                trigger OnAction()
                var
                    TenderCommittee: Record "Tender Committee";
                begin
                    Contracts.Reset();
                    Contracts.SetRange("Contract Reference No", Rec."Contract No");
                    if Contracts.Find('-') then begin
                        if Contracts."Has CIT" = true then begin
                            TenderCommittee.Reset();
                            TenderCommittee.SetRange("Tendor No", Rec."Contract No");
                            TenderCommittee.SetRange("Committee Type", TenderCommittee."Committee Type"::"Contract Implementation Team");
                            if TenderCommittee.Find('-') then
                                Page.Run(Page::"Tender Passwords Page", TenderCommittee);
                        end else begin
                            Rec."Milestone Status" := Rec."Milestone Status"::Completed;
                            Rec.Modify();
                        end;

                    end;
                end;
            }
            action(Attachments)
            {
                Image = Attachments;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page "Document Attachment Details";
                RunPageLink = "No." = field("Contract No");
                ToolTip = 'Executes the Attachments action.';
            }
        }
    }

    var
        Contracts: Record Contract;
        PurchaseHeader: Record "Purchase Header";
        Milestones: Record "Contract Milestones";
        Milestones2: Record "Contract Milestones";
        NextNo: Code[20];
        NoSeriesMgt: Codeunit "No. Series";
        PurchLine: Record "Purchase Line";
        LineNo: Integer;
        PurchaseSetup: Record "Purchases & Payables Setup";
}