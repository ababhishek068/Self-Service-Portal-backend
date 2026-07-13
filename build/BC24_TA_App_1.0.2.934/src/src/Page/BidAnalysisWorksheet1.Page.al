Page 50228 "Bid Analysis Worksheet1"
{
    DeleteAllowed = false;
    PageType = Worksheet;
    SourceTable = "Bid Analysis";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Control1102755012)
            {
                field(SalesCodeFilterCtrl; SalesCodeFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Vendor Code Filter';
                    ToolTip = 'Specifies the value of the Vendor Code Filter field.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        VendList: Page "Vendor List";
                    begin
                        begin
                            VendList.LookupMode := true;
                            if VendList.RunModal = Action::LookupOK then
                                Text := VendList.GetSelectionFilter
                            else
                                exit(false);
                        end;

                        exit(true);
                    end;

                    trigger OnValidate()
                    begin
                        SalesCodeFilterOnAfterValidate;
                    end;
                }
                field(ItemNoFilter; ItemNoFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Item No.';
                    ToolTip = 'Specifies the value of the Item No. field.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        ItemList: Page "Item List";
                    begin
                        ItemList.LookupMode := true;
                        if ItemList.RunModal = Action::LookupOK then
                            Text := ItemList.GetSelectionFilter
                        else
                            exit(false);

                        exit(true);
                    end;

                    trigger OnValidate()
                    begin
                        ItemNoFilterOnAfterValidate;
                    end;
                }
                field(Total; Rec.Total)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Total field.';
                }
            }
            repeater(Group)
            {
                Editable = false;
                field("RFQ No."; Rec."RFQ No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the RFQ No. field.';
                }
                field("RFQ Line No."; Rec."RFQ Line No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the RFQ Line No. field.';
                }
                field("Quote No."; Rec."Quote No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Quote No. field.';
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Vendor No. field.';
                }
                field(VendorName; VendorName)
                {
                    ApplicationArea = Basic;
                    Caption = 'Vendor Name';
                    ToolTip = 'Specifies the value of the Vendor Name field.';
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Item No. field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Quantity field.';
                }
                field("Unit Of Measure"; Rec."Unit Of Measure")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Unit Of Measure field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    ApplicationArea = Basic;
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
                ApplicationArea = Basic;
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
        }
    }

    trigger OnAfterGetRecord()
    begin
        Vendor.Get(Rec."Vendor No.");
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

    procedure SetRecFilters()
    begin
        if SalesCodeFilter <> '' then
            Rec.SetFilter("Vendor No.", SalesCodeFilter)
        else
            Rec.SetRange("Vendor No.");

        if ItemNoFilter <> '' then begin
            Rec.SetFilter("Item No.", ItemNoFilter);
        end else
            Rec.SetRange("Item No.");

        CalcTotals;

        CurrPage.Update(false);
    end;

    local procedure ItemNoFilterOnAfterValidate()
    begin
        CurrPage.SaveRecord;
        SetRecFilters;
    end;

    procedure GetVendorQuotes()
    begin
        //insert the quotes from vendors
        if RFQNoFilter = '' then Error('Specify the RFQ No.');

        PurchHeader.SetRange(PurchHeader."No.", RFQNoFilter);
        PurchHeader.FindSet;
        repeat
            PurchLines.Reset;
            PurchLines.SetRange("Document No.", PurchHeader."No.");
            if PurchLines.FindSet then
                repeat
                    Rec.Init;
                    Rec."RFQ No." := PurchHeader."No.";
                    Rec."RFQ Line No." := PurchLines."Line No.";
                    Rec."Quote No." := PurchLines."Document No.";
                    Rec."Vendor No." := PurchLines."Buy-from Vendor No.";
                    Rec."Item No." := PurchLines."No.";
                    Rec.Description := PurchLines.Description;
                    Rec.Quantity := PurchLines.Quantity;
                    Rec."Unit Of Measure" := PurchLines."Unit of Measure";
                    Rec.Amount := PurchLines."Direct Unit Cost";
                    Rec."Line Amount" := Rec.Quantity * Rec.Amount;
                    Rec.Insert(true);
                    InsertCount := +1;
                until PurchLines.Next = 0;
        until PurchHeader.Next = 0;
        Message('%1 records have been inserted to the bid analysis');
    end;

    local procedure SalesCodeFilterOnAfterValidate()
    begin
        CurrPage.SaveRecord;
        SetRecFilters;
    end;

    procedure CalcTotals()
    var
        BidAnalysisRec: Record "Bid Analysis";
    begin
        BidAnalysisRec.SetRange("RFQ No.", Rec."RFQ No.");
        if SalesCodeFilter <> '' then
            BidAnalysisRec.SetRange("Vendor No.", SalesCodeFilter);
        if ItemNoFilter <> '' then
            BidAnalysisRec.SetRange("Item No.", ItemNoFilter);
        BidAnalysisRec.FindSet;
        BidAnalysisRec.CalcSums("Line Amount");
        Rec.Total := BidAnalysisRec."Line Amount";
    end;
}

