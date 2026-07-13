namespace Microsoft;

using Microsoft.Purchases.Document;

page 51491 "Bidanalisis form"

{
    PageType = ListPart;
    SourceTable = "BidAnalysis Tender";
    SourceTableView = sorting("Tender No.", "Item No.", Amount) order(ascending);
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

                }
                field("Quote No."; Rec."Quote No.")
                {
                    ToolTip = 'Specifies the value of the Quote No. field.';
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ToolTip = 'Specifies the value of the Vendor No. field.';
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ToolTip = 'Specifies the value of the Vendor Name field.';
                }
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the Item No. field.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantity field.';
                }
                field("Unit Of Measure"; Rec."Unit Of Measure")
                {
                    ToolTip = 'Specifies the value of the Unit Of Measure field.';
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    ToolTip = 'Specifies the value of the Line Amount field.';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Expiry Date"; Rec."Expiry Date")
                {
                    ToolTip = 'Specifies the value of the Expiry Date field.';

                }
                field(Acknowledgement; Rec.Acknowledgement)
                {
                    ToolTip = 'Specifies the value of the Acknowledgement field.';

                }
                field("Date of Acknowledgement"; Rec."Date of Acknowledgement")
                {
                    ToolTip = 'Specifies the value of the Date of Acknowledgement field.';

                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Suggest)
            {
                Caption = 'Suggest';
                ApplicationArea = All;
                Image = Certificate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    BidAnalysis: Record "BidAnalysis Tender";
                    QuoteAnalysisTA: Report "Quote Analysis-TA";
                begin
                    BidAnalysis.Reset();
                    BidAnalysis.SetRange("Tender No.", Rec."Tender No.");
                    if BidAnalysis.FindFirst() then begin
                        QuoteAnalysisTA.SetTableView(BidAnalysis);
                        QuoteAnalysisTA.RunModal();
                    end;
                end;
            }
            action(Award)
            {
                Image = Certificate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Award action.';

                trigger OnAction()
                var
                    Awards: Record "RFQ Awards";
                    BidAnalysis: Record "Bid Analysis";
                    RFQ: Record "Purchase Quote Header";
                    PurchaseLines: Record "Purchase Line";
                    PurchaseHeader: Record "Purchase Header";
                begin
                    RFQ.RESET;
                    RFQ.SETRANGE("No.", Rec."Tender No.");
                    IF RFQ.FIND('-') THEN
                        IF RFQ."Is request for proposal" = TRUE THEN BEGIN
                            BidAnalysis.RESET;
                            BidAnalysis.SETRANGE("RFQ No.", Rec."Tender No.");
                            BidAnalysis.SETRANGE("Quote No.", Rec."Quote No.");
                            BidAnalysis.SETRANGE("RFQ Line No.", Rec."Tender Line No.");
                            BidAnalysis.SETRANGE(Awarded, FALSE);
                            BidAnalysis.SETRANGE("Notify Vendors", FALSE);
                            IF BidAnalysis.FIND('-') THEN ERROR('Please notify vendors on the opening of the financials before any awarding');
                        END;

                    Rec.CALCFIELDS("Selected Count");
                    IF Rec."Selected Count" > 1 THEN ERROR('Please note that you can only select one item per vendor to award');
                    IF CONFIRM('Are you sure you want to award ' + Rec."Tender No." + ' to Vendor ' + Rec."Vendor No." + '(' + Rec."Vendor Name" + ') for Item ' + Rec."Item No." + ' - ' + Rec.Description + '?') = TRUE THEN BEGIN
                        Rec.TESTFIELD("Expiry Date");
                        BidAnalysis.RESET;
                        BidAnalysis.SETRANGE(BidAnalysis."RFQ No.", Rec."Tender No.");
                        BidAnalysis.SETRANGE(BidAnalysis."Item No.", Rec."Item No.");
                        IF BidAnalysis.FIND('-') THEN BEGIN
                            REPEAT
                                IF BidAnalysis.Awarded = TRUE THEN ERROR('This item has already been awarded to vendor ' + Rec."Vendor Name");
                            UNTIL BidAnalysis.NEXT = 0;
                        END;
                        IF Rec.Awarded = TRUE THEN ERROR('This vendor has already been awarded');
                        //Award selected vendor
                        BidAnalysis.RESET;
                        BidAnalysis.SETRANGE(BidAnalysis."RFQ No.", Rec."Tender No.");
                        //BidAnalysis.SETRANGE(BidAnalysis."Item No.", "Item No.");
                        BidAnalysis.SETRANGE(BidAnalysis.Select, TRUE);
                        IF BidAnalysis.FIND('-') THEN BEGIN
                            REPEAT
                                Awards.INIT;
                                Awards."Vendor No" := BidAnalysis."Vendor No.";
                                Awards."RFQ No" := BidAnalysis."RFQ No.";
                                Awards.Type := Awards.Type::Award;
                                Awards."Awarded By" := USERID;
                                Awards."Date of Award" := TODAY;
                                Awards."Expiry Date" := BidAnalysis."Expiry Date";
                                Awards."Item No." := BidAnalysis."Item No.";
                                Awards.Description := BidAnalysis.Description;
                                Awards.Quantity := BidAnalysis.Quantity;
                                Awards."Unit Of Measure" := BidAnalysis."Unit Of Measure";
                                Awards.Amount := BidAnalysis.Amount;
                                Awards."Line Amount" := BidAnalysis."Line Amount";
                                Awards.Total := BidAnalysis.Total;
                                Awards."Quote No" := BidAnalysis."Quote No.";
                                Awards.INSERT;
                                BidAnalysis.Awarded := TRUE;
                                BidAnalysis.MODIFY(TRUE);
                                //approve purchase quote for vendor
                                PurchaseHeader.RESET;
                                PurchaseHeader.SETRANGE(PurchaseHeader."No.", Rec."Quote No.");
                                PurchaseHeader.SETRANGE(PurchaseHeader."Document Type", PurchaseHeader."Document Type"::Quote);
                                IF PurchaseHeader.FIND('-') THEN BEGIN
                                    PurchaseHeader.Status := PurchaseHeader.Status::Released;
                                    PurchaseHeader.MODIFY;
                                END;
                            UNTIL BidAnalysis.NEXT = 0;

                        END;


                        //regret all the other vendors
                        BidAnalysis.RESET;
                        BidAnalysis.SETRANGE(BidAnalysis."RFQ No.", Rec."Tender No.");
                        //BidAnalysis.SETRANGE("Quote No.", "Quote No.");
                        //BidAnalysis.SETRANGE("RFQ Line No.", "RFQ Line No.");
                        BidAnalysis.SETRANGE(BidAnalysis.Select, FALSE);
                        BidAnalysis.SETRANGE(BidAnalysis."Item No.", Rec."Item No.");
                        IF BidAnalysis.FIND('-') THEN BEGIN
                            REPEAT
                                Awards.INIT;
                                Awards."Vendor No" := BidAnalysis."Vendor No.";
                                Awards."RFQ No" := BidAnalysis."RFQ No.";
                                Awards.Type := Awards.Type::Regret;
                                Awards."Awarded By" := USERID;
                                Awards."Date of Award" := TODAY;
                                Awards."Expiry Date" := Rec."Expiry Date";
                                Awards."Quote No" := BidAnalysis."Quote No.";
                                Awards.INSERT;
                                //cancel purchase quotes
                                PurchaseLines.RESET;
                                PurchaseLines.SETRANGE(PurchaseLines."Document No.", Rec."Quote No.");
                                //PurchaseLines.SETRANGE(PurchaseLines."Buy-from Vendor No.", "Vendor No.");
                                PurchaseLines.SETRANGE(PurchaseLines."No.", Rec."Item No.");
                                PurchaseLines.SETRANGE(PurchaseLines."Document Type", PurchaseLines."Document Type"::Quote);
                                IF PurchaseLines.FIND('-') THEN BEGIN
                                    PurchaseLines.Cancelled := TRUE;
                                    PurchaseLines.MODIFY;
                                END;
                            UNTIL BidAnalysis.NEXT = 0;
                        END;
                        // oBJvEND.RESET;
                        // oBJvEND.GET("Vendor No.");
                        // MessageP := 'Hello ' + "Vendor Name" + ', The Status for RFQ ' + "RFQ No." + ' has changed. Kindly login to the portal for more.' +
                        // '<hr>';
                        // SMTPMailSetup.GET;
                        // SMTPMail.CreateMessage(CompanyName, SMTPMailSetup."Send As", oBJvEND."E-Mail", 'Supplier Portal', MessageP, TRUE);
                        // SMTPMail.AppendBody('This is a systems generated email. Do not reply to this email. If you have any queries, write to procurement@must.ac.ke');
                        // SMTPMail.Send;
                        Rec.Select := FALSE;
                        MESSAGE('Success');

                    END ELSE
                        ERROR('You have aborted the award process');
                end;

            }
        }
    }


}

