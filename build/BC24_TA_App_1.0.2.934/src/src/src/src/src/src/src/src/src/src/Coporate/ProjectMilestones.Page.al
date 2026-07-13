page 50676 "Project Milestones"
{
    PageType = List;
    SourceTable = "Project Milestones";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Select; Rec.Select)
                {
                    ToolTip = 'Specifies the value of the Select field.';

                    trigger OnValidate()
                    begin
                        IF Rec.Status = Rec.Status::Pending THEN ERROR('Cannot select a Pending milestone');
                    end;
                }
                field("Project Code"; Rec."Project Code")
                {
                    ToolTip = 'Specifies the value of the Project Code field.';
                }
                field("GL Account"; Rec."GL Account")
                {
                    ToolTip = 'Specifies the value of the GL Account field.';
                }
                field(Milestone; Rec.Milestone)
                {
                    ToolTip = 'Specifies the value of the Milestone field.';
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
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
        }
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
                            Milestones.TESTFIELD("Project Code");
                            Milestones.TESTFIELD(Milestone);
                            Milestones.TESTFIELD("Amount Paybale");
                            Milestones.TESTFIELD(Milestones.Duration);
                            Milestones.VALIDATE(Milestones.Duration);
                            Milestones.VALIDATE(Milestones."Amount Paybale");
                            Milestones.VALIDATE(Milestones."GL Account");
                            Milestones.Status := Milestones.Status::Complete;
                            Milestones.MODIFY;
                        UNTIL Milestones.NEXT = 0;
                        MESSAGE('Milestones successfully marked as completed');
                        //IF CONFIRM('Milestones Marked as Complete. Do you want to raise an invoice?') = FALSE THEN ERROR('Invoice not generated');
                        // Milestones2.RESET;
                        // Milestones2.SETRANGE(Select, TRUE);
                        // IF Milestones2.FIND('-') THEN BEGIN
                        //     NextNo := '';
                        //     LineNo := 10000;
                        //     REPEAT
                        //         LineNo := LineNo + 10000;
                        //         IF Projects.GET(Milestones2."Contract No.") THEN
                        //             IF NOT PurchaseHeader.GET(PurchaseHeader."Document Type"::Invoice, NextNo) THEN BEGIN
                        //                 //insert invoice
                        //                 PurchaseHeader.INIT;
                        //                 NextNo := NoSeriesMgt.GetNextNo('P-INV', 0D, TRUE);
                        //                 PurchaseHeader."No." := NextNo;
                        //                 PurchaseHeader."Buy-from Vendor No." := Contracts."Contractor No.";
                        //                 PurchaseHeader.VALIDATE("Buy-from Vendor No.");
                        //                 PurchaseHeader."Pay-to Vendor No." := Contracts."Contractor No.";
                        //                 PurchaseHeader.VALIDATE("Pay-to Vendor No.");
                        //                 PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::Invoice;
                        //                 PurchaseHeader."Document Date" := TODAY;
                        //                 PurchaseHeader."Contract No." := Contracts."Contract No.";
                        //                 PurchaseHeader."Posting Description" := Milestones2.Milestone;
                        //                 PurchaseHeader.INSERT(TRUE);
                        //             END;
                        //         IF NextNo <> '' THEN BEGIN
                        //             //Insert Purchase Lines
                        //             PurchLine.INIT;
                        //             PurchLine."Document Type" := PurchLine."Document Type"::Invoice;
                        //             PurchLine."Document No." := NextNo;
                        //             PurchLine."Line No." := LineNo;
                        //             PurchLine.Amount := "Amount Paybale";
                        //             PurchLine.Type := PurchLine.Type::"G/L Account";
                        //             PurchLine."No." := Milestones2."GL Account";
                        //             PurchLine."Buy-from Vendor No." := Contracts."Contractor No.";
                        //             PurchLine."Amount Including VAT" := "Amount Paybale";
                        //             PurchLine.Quantity := 1;
                        //             PurchLine."Direct Unit Cost" := "Amount Paybale";
                        //             PurchLine."Line Amount" := "Amount Paybale";
                        //             PurchLine.VALIDATE("No.");
                        //             PurchLine.VALIDATE("Buy-from Vendor No.");
                        //             PurchLine.VALIDATE(Description);
                        //             PurchLine.VALIDATE("Document No.");
                        //             PurchLine.VALIDATE("Document Type");
                        //             PurchLine.VALIDATE(Amount);
                        //             PurchLine.INSERT(TRUE);

                        //         END;
                        //         Milestones2.Select := FALSE;
                        //         Milestones2.MODIFY;
                        //     UNTIL Milestones2.NEXT = 0;
                        //     PurchaseHeader.GET(PurchaseHeader."Document Type"::Invoice, NextNo);
                        //     PAGE.RUN(51, PurchaseHeader);
                        // END;
                    END ELSE
                        ERROR('Please select atleast one milestone');
                end;
            }
        }
    }

    var
        Milestones: Record "Project Milestones";
}

