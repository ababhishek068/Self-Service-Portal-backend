namespace microsoft;

using Microsoft.Purchases.Vendor;
using Microsoft.Inventory.Item;
using Microsoft.Purchases.Document;

page 51492 "Bid Worksheeet Tender"

{
    DeleteAllowed = false;
    PageType = Worksheet;
    SourceTable = "BidAnalysis Tender";
    SourceTableView = SORTING("Tender No.", "Amount");
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(SalesCodeFilterCtrl; SalesCodeFilter)
                {
                    Caption = 'Vendor Code Filter';
                    ToolTip = 'Specifies the value of the Vendor Code Filter field.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        VendList: Page "Vendor List";
                    begin
                        BEGIN
                            VendList.LOOKUPMODE := TRUE;
                            IF VendList.RUNMODAL = ACTION::LookupOK THEN
                                Text := VendList.GetSelectionFilter
                            ELSE
                                EXIT(FALSE);
                        END;

                        EXIT(TRUE);
                    end;

                    trigger OnValidate()
                    begin
                        SalesCodeFilterOnAfterValidate;
                    end;
                }
                field(ItemNoFilter; ItemNoFilter)
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
                        ItemNoFilterOnAfterValidate;
                    end;
                }
                field(Total; Rec.Total)
                {
                    ToolTip = 'Specifies the value of the Total field.';
                }
                field(RFQNoFilter; RFQNoFilter)
                {
                    ToolTip = 'Specifies the value of the RFQNoFilter field.';
                }
            }
            repeater(Group)
            {
                Editable = false;
                field("Tender No"; Rec."Tender No.")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the RFQ No. field.';
                }
                field("Tender Line No."; Rec."Tender Line No.")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the RFQ Line No. field.';
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
                    Caption = 'Vendor Name';
                    ToolTip = 'Specifies the value of the Vendor Name field.';
                }
                field(VendorName; VendorName)
                {
                    Caption = 'VendorName';
                    ToolTip = 'Specifies the value of the VendorName field.';
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
                Visible = false;
                ToolTip = 'Executes the Get Vendor Quotations action.';

                trigger OnAction()
                begin
                    GetVendorQuotes;
                end;
            }
            separator(Sep) { }
            action(BidPrint)
            {
                Caption = 'Print';
                Image = PrintReport;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                ToolTip = 'Executes the Print action.';

                trigger OnAction()
                begin
                    Rec.RESET;
                    Rec.SETRANGE("Tender No.", Rec."Tender No.");
                    REPORT.RUN(59666, TRUE, TRUE, Rec);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Vendor.GET(Rec."Vendor No.");
        VendorName := Vendor.Name;
        CalcTotals;
    end;

    var
        PurchHeader: Record "Purchase Header";
        PurchLines: Record "Purchase Line";
        ItemNoFilter: Text[250];
        RFQNoFilter: Text[250];
        InsertCount: Integer;
        SalesCodeFilter: Text[250];
        VendorName: Text;
        Vendor: Record Vendor;

    [Scope('OnPrem')]
    procedure SetRecFilters()
    begin
        IF SalesCodeFilter <> '' THEN
            Rec.SETFILTER("Vendor No.", SalesCodeFilter)
        ELSE
            Rec.SETRANGE("Vendor No.");

        IF ItemNoFilter <> '' THEN BEGIN
            Rec.SETFILTER("Item No.", ItemNoFilter);
        END ELSE
            Rec.SETRANGE("Item No.");

        CalcTotals;

        CurrPage.UPDATE(FALSE);
    end;

    local procedure ItemNoFilterOnAfterValidate()
    begin
        CurrPage.SAVERECORD;
        SetRecFilters;
    end;

    [Scope('OnPrem')]
    procedure GetVendorQuotes()
    begin
        //insert the quotes from vendors
        IF RFQNoFilter = '' THEN ERROR('Specify the RFQ No.');

        PurchHeader.SETRANGE(PurchHeader."No.", RFQNoFilter);
        PurchHeader.FINDSET;
        REPEAT
            PurchLines.RESET;
            PurchLines.SETRANGE("Document No.", PurchHeader."No.");
            IF PurchLines.FINDSET THEN
                REPEAT
                    Rec.INIT;
                    Rec."Tender No." := PurchHeader."No.";
                    Rec."Tender Line No.":= PurchLines."Line No.";
                    Rec."Quote No." := PurchLines."Document No.";
                    Rec."Vendor No." := PurchLines."Buy-from Vendor No.";
                    Rec."Item No." := PurchLines."No.";
                    Rec.Description := PurchLines.Description;
                    Rec.Quantity := PurchLines.Quantity;
                    Rec."Unit Of Measure" := PurchLines."Unit of Measure";
                    Rec.Amount := PurchLines."Direct Unit Cost";
                    Rec."Line Amount" := Rec.Quantity * Rec.Amount;
                    Rec.INSERT(TRUE);
                    InsertCount := +1;
                UNTIL PurchLines.NEXT = 0;
        UNTIL PurchHeader.NEXT = 0;
        MESSAGE('%1 records have been inserted to the bid analysis');
    end;

    local procedure SalesCodeFilterOnAfterValidate()
    begin
        CurrPage.SAVERECORD;
        SetRecFilters;
    end;

    [Scope('OnPrem')]
    procedure CalcTotals()
    var
        BidAnalysisRec: Record "BidAnalysis Tender";
    begin
        BidAnalysisRec.SETRANGE("Tender No.", Rec."Tender No.");
        IF SalesCodeFilter <> '' THEN
            BidAnalysisRec.SETRANGE("Vendor No.", SalesCodeFilter);
        IF ItemNoFilter <> '' THEN
            BidAnalysisRec.SETRANGE("Item No.", ItemNoFilter);
        BidAnalysisRec.FINDSET;
        BidAnalysisRec.CALCSUMS("Line Amount");
        Rec.Total := BidAnalysisRec."Line Amount";
    end;
}

