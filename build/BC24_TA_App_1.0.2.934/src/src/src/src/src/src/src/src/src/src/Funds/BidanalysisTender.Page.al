namespace Microsoft;

using Microsoft.Inventory.Item;
using Microsoft.Purchases.Document;

page 51490 "Bidanalysis Tender "

{
    PageType = Document;
    SourceTable = "BidAnalysis Tender";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("RFQ No."; Rec."Tender No.")
                {
                    ToolTip = 'Specifies the value of the RFQ No. field.';
                }
                field("Quote No."; Rec."Quote No.")
                {
                    Caption = 'Item No.';
                    ToolTip = 'Specifies the value of the Item No. field.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        ItemList: Page "Item List";
                    begin
                        ItemList.LOOKUPMODE := TRUE;
                        IF ItemList.RUNMODAL = ACTION::LookupOK THEN
                            Text := ItemList.GetSelectionFilter
                        ELSE
                            EXIT(FALSE);

                        EXIT(TRUE);
                    end;

                    trigger OnValidate()
                    begin
                        //ItemNoFilterOnAfterValidate;
                    end;
                }
                field("Market Survey Attached"; Rec."Market Survey Attached")
                {
                    ToolTip = 'Specifies the value of the Market Survey Attached field.';
                }
                field("TOR/Specifications Attached"; Rec."TOR/Specifications Attached")
                {
                    ToolTip = 'Specifies the value of the TOR/Specifications Attached field.';
                }
                field("Appointment report"; Rec."Appointment report")
                {
                    ToolTip = 'Specifies the value of the Appointment report field.';
                }
                field("Opening Minutes"; Rec."Opening Minutes")
                {
                    ToolTip = 'Specifies the value of the Opening Minutes field.';
                }
                field("Due Dilligence"; Rec."Due Dilligence")
                {
                    ToolTip = 'Specifies the value of the Evaluation Report field.';
                }
                field("Professional Opinion"; Rec."Professional Opinion")
                {
                    ToolTip = 'Specifies the value of the Professional Opinion field.';
                }
                field("Notify Vendors"; Rec."Notify Vendors")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Notify Vendors field.';
                }
            }
            part("Bid Analysis SubForm"; "Bidanalisis form")
            {
                SubPageLink = "Tender No." = FIELD("Tender No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Get Vendor Quotations")
            {
                Caption = 'Get Vendor Quotations';
                Image = GetSourceDoc;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the Get Vendor Quotations action.';

                trigger OnAction()
                var
                    BidAnalysisLines: Record "BidAnalysis Tender";
                    PurchHeader: Record "Purchase Header";
                    PurchLines: Record "Purchase Line";
                    InsertCount: Integer;
                begin
                    PurchHeader.SETRANGE(PurchHeader."Request for Quote No.", Rec."Tender No.");
                    PurchHeader.SETRANGE(PurchHeader."Document Type", PurchHeader."Document Type"::Quote);
                    PurchHeader.FINDSET;
                    REPEAT
                        PurchLines.RESET;
                        PurchLines.SETRANGE("Document No.", PurchHeader."No.");
                        IF PurchLines.FINDSET THEN
                            REPEAT
                                Rec.INIT;
                                BidAnalysisLines."Tender No." := PurchHeader."Request for Quote No.";
                                BidAnalysisLines."Tender Line No." := PurchLines."Line No.";
                                BidAnalysisLines."Quote No." := PurchLines."Document No.";
                                BidAnalysisLines."Vendor No." := PurchLines."Buy-from Vendor No.";
                                BidAnalysisLines."Item No." := PurchLines."No.";
                                BidAnalysisLines.Description := PurchLines.Description;
                                BidAnalysisLines.Quantity := PurchLines.Quantity;
                                BidAnalysisLines."Unit Of Measure" := PurchLines."Unit of Measure";
                                BidAnalysisLines.Amount := PurchLines."Direct Unit Cost";
                                BidAnalysisLines."Line Amount" := BidAnalysisLines.Quantity * BidAnalysisLines.Amount;
                                BidAnalysisLines.INSERT(TRUE);
                                InsertCount := +1;
                            UNTIL PurchLines.NEXT = 0;
                    UNTIL PurchHeader.NEXT = 0;
                end;
            }
            separator("<Control1>")
            {
                Caption = '<Control1>';
            }
            action(Worksheet)
            {
                Caption = 'Worksheet';
                Image = Worksheet;
                RunObject = Page "Bid Worksheeet Tender";
                RunPageLink = "Tender No." = FIELD("Tender No.");
                ToolTip = 'Executes the Worksheet action.';
            }
            action("Notify Vendors")
            {
                Image = Alerts;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Notify Vendors action.';

                trigger OnAction()
                begin
                    IF CONFIRM('Are you sure you want to notify vendors for financial opening?', FALSE) THEN
                        Rec."Notify Vendors" := TRUE
                    ELSE
                        ERROR('Process Aborted');
                end;
            }
        }

    }

}