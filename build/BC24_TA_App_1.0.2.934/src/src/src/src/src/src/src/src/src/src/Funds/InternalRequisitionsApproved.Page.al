Page 51025 "Internal Requisitions Approved"
{
    Caption = 'Internal Requisition';
    DeleteAllowed = false;
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "Purchase Header";
    // SourceTableView = where("Document Type" = filter(Quote),
    //                         DocApprovalType = filter(Requisition),
    //                         Status = filter(Released));
    SourceTableView = where(Status = filter(Released));
    ApplicationArea = All;


    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
                }
                field(RequestedReceiptDate; Rec."Requested Receipt Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the date that you want the vendor to deliver your order. The field is used to calculate the latest date you can order, as follows: requested receipt date - lead time calculation = order date. If you do not need delivery on a specific date, you can leave the field blank.';
                }
                field(ResponsibilityCenter; Rec."Responsibility Center")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the code of the responsibility center, such as a distribution hub, that is associated with the involved user, company, customer, or vendor.';
                }
                field(ShortcutDimension1Code; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';

                }
                field(ShortcutDimension2Code; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';

                }
                field(PostingDescription; Rec."Posting Description")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies additional posting information for the document. After you post the document, the description can add detail to vendor and customer ledger entries.';
                }
                field(NoofArchivedVersions; Rec."No. of Archived Versions")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the number of archived versions for this document.';
                }
                field(ProcurementTypeCode; Rec."Procurement Type Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Procurement Type Code field.';
                }
                field("Procurement Method Code"; Rec."Procurement Method Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Procurement Method Code field.';
                    //  Editable = false;
                }
                field("Assigned Procurement Officer"; Rec."Assigned Procurement Officer")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Assigned Procurement Officer field.';
                }
                field(OrderDate; Rec."Order Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the date when the order was created.';
                }
                field(DocumentDate; Rec."Document Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the date when the related document was created.';
                }
                field("Requestor Name"; Rec."Requestor Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Requestor Name';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Requestor Name field.';
                }
                field("Assigned User ID"; Rec."Assigned User ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ID of the user who is responsible for the document.';

                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies whether the record is open, waiting to be approved, invoiced for prepayment, or released to the next stage of processing.';
                }
                field(PricesIncludingVAT; Rec."Prices Including VAT")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies if the Unit Price and Line Amount fields on document lines should be shown with or without VAT.';
                }
            }
            part(PurchLines; "Purchase Requisition Subform")
            {
                ApplicationArea = basic;
                Editable = PurchLinesEditable;
                SubPageLink = "Document No." = field("No.");
            }
            group(VendInfoPanel)
            {
                Caption = 'Vendor Information';
                label(Control165)
                {
                    ApplicationArea = Basic;
                    CaptionClass = Text19023272;
                }
                label(Control166)
                {
                    ApplicationArea = Basic;
                    CaptionClass = Text19005663;
                }
            }
            group(ForeignTrade)
            {
                Caption = 'Foreign Trade';
                field(CurrencyCode; Rec."Currency Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the currency that is used on the entry.';

                    trigger OnAssistEdit()
                    begin
                        /*CLEAR(ChangeExchangeRate);
                        ChangeExchangeRate.SetParameter("Currency Code","Currency Factor",WORKDATE);
                        IF ChangeExchangeRate.RUNMODAL = ACTION::OK THEN BEGIN
                          VALIDATE("Currency Factor",ChangeExchangeRate.GetParameter);
                          CurrPage.UPDATE;
                        END;
                        CLEAR(ChangeExchangeRate);
                         */

                    end;


                }
                field(TransactionType; Rec."Transaction Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of transaction that the document represents, for the purpose of reporting to INTRASTAT.';
                }
                field(TransactionSpecification; Rec."Transaction Specification")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a specification of the document''s transaction, for the purpose of reporting to INTRASTAT.';
                }
                field(TransportMethod; Rec."Transport Method")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the transport method, for the purpose of reporting to INTRASTAT.';
                }
                field(EntryPoint; Rec."Entry Point")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the port of entry where the items pass into your country/region, for reporting to Intrastat.';
                }
                field("Area"; Rec.Area)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the destination country or region for the purpose of Intrastat reporting.';
                }
            }
        }
        area(factboxes)
        {
            part("Attached Documents"; "Document Attachments")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(38),
                              "No." = FIELD("No.");
            }

        }
    }

    actions
    {
        area(navigation)
        {
            group(Quote)
            {
                Caption = '&Quote';
                action(Statistics)
                {
                    ApplicationArea = Basic;
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'F7';
                    ToolTip = 'Executes the Statistics action.';

                    trigger OnAction()
                    begin
                        Rec.CalcInvDiscForHeader;
                        Commit;
                        Page.RunModal(Page::"Purchase Statistics", Rec);
                    end;
                }
                action(Card)
                {
                    ApplicationArea = Basic;
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page "Vendor Card";
                    RunPageLink = "No." = field("Buy-from Vendor No.");
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'Executes the Card action.';
                }
                action(Comments)
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Purch. Comment Sheet";
                    RunPageLink = "Document Type" = field("Document Type"),
                                  "No." = field("No."),
                                  "Document Line No." = const(0);
                    ToolTip = 'Executes the Co&mments action.';
                }
                action(Dimensions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ToolTip = 'Executes the Dimensions action.';

                    trigger OnAction()
                    begin
                        Rec.ShowDocDim;
                    end;
                }
                action(Approvals)
                {
                    ApplicationArea = Basic;
                    Caption = 'Approvals';
                    Image = Approvals;
                    ToolTip = 'Executes the Approvals action.';

                    trigger OnAction()
                    var
                        ApprovalEntries: Page "Approval Entries";
                    begin
                        ApprovalEntries.SetRecordFilters(Database::"Purchase Header", Rec."Document Type", Rec."No.");
                        ApprovalEntries.Run;
                    end;
                }
            }
            group(Line)
            {
                Caption = '&Line';
                group(ItemAvailabilityby)
                {
                    Caption = 'Item Availability by';
                    action(Period)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Period';
                        ToolTip = 'Executes the Period action.';

                        trigger OnAction()
                        begin
                            //CurrPage.PurchLines.PAGE.ItemAvailability(0);
                        end;
                    }
                    action(Variant)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Variant';
                        ToolTip = 'Executes the Variant action.';

                        trigger OnAction()
                        begin
                            //CurrPage.PurchLines.PAGE.ItemAvailability(1);
                        end;
                    }
                    action(Location)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Location';
                        ToolTip = 'Executes the Location action.';

                        trigger OnAction()
                        begin
                            //CurrPage.PurchLines.PAGE.ItemAvailability(2);
                        end;
                    }
                }
                action(Action112)
                {
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'Executes the Dimensions action.';

                    trigger OnAction()
                    begin
                        //CurrPage.PurchLines.PAGE.ShowDimensions;
                    end;
                }
            }
        }
        area(processing)
        {
            action(MakeOrder)
            {
                ApplicationArea = Basic;
                Caption = 'Make &Order';
                Image = MakeOrder;
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;
                ToolTip = 'Executes the Make &Order action.';

                trigger OnAction()

                begin
                    if LinesCommitted then
                        Error('All Lines should be committed');

                    // if ApprovalMgt.PrePostApprovalCheck(SalesHeader,Rec) then
                    Codeunit.Run(Codeunit::"Purch.-Quote to Order (Yes/No)", Rec);
                end;
            }
            group(Functions)
            {
                Caption = 'F&unctions';
                action(CalculateInvoiceDiscount)
                {
                    ApplicationArea = Basic;
                    Caption = 'Calculate &Invoice Discount';
                    Image = CalculateInvoiceDiscount;
                    ToolTip = 'Executes the Calculate &Invoice Discount action.';


                }
                separator(Action144) { }
                separator(Action145) { }
                action(GetStdVendPurchaseCodes)
                {
                    ApplicationArea = Basic;
                    Caption = 'Get St&d. Vend. Purchase Codes';
                    Ellipsis = true;
                    ToolTip = 'Executes the Get St&d. Vend. Purchase Codes action.';

                    trigger OnAction()
                    var
                        StdVendPurchCode: Record "Standard Vendor Purchase Code";
                    begin
                        StdVendPurchCode.InsertPurchLines(Rec);
                    end;
                }
                separator(Action146) { }
                action(CopyDocument)
                {
                    ApplicationArea = Basic;
                    Caption = 'Copy Document';
                    Ellipsis = true;
                    Image = CopyDocument;
                    ToolTip = 'Executes the Copy Document action.';

                    trigger OnAction()
                    begin
                        CopyPurchDoc.SetPurchHeader(Rec);
                        CopyPurchDoc.RunModal;
                        Clear(CopyPurchDoc);
                    end;
                }
                action(ArchiveDocument)
                {
                    ApplicationArea = Basic;
                    Caption = 'Archi&ve Document';
                    ToolTip = 'Executes the Archi&ve Document action.';

                    trigger OnAction()
                    begin
                        ArchiveManagement.ArchivePurchDocument(Rec);
                        CurrPage.Update(false);
                    end;
                }
                separator(Action147) { }


                separator(Action148) { }


                separator(Action1102755004) { }
                action(Release)
                {
                    ApplicationArea = Basic;
                    Caption = 'Re&lease';
                    Image = ReleaseDoc;
                    ShortCutKey = 'Ctrl+F9';
                    ToolTip = 'Executes the Re&lease action.';

                    trigger OnAction()
                    var
                        ReleasePurchDoc: Codeunit "Release Purchase Document";
                    begin
                        if LinesCommitted then
                            Error('All Lines should be committed');

                        ReleasePurchDoc.PerformManualRelease(Rec);
                    end;
                }
                action(Reopen)
                {
                    ApplicationArea = Basic;
                    Caption = 'Re&open';
                    Image = ReOpen;
                    ToolTip = 'Executes the Re&open action.';

                    trigger OnAction()
                    var
                        ReleasePurchDoc: Codeunit "Release Purchase Document";
                    begin
                        if LinesCommitted then
                            Error('All Lines should be committed');

                        ReleasePurchDoc.PerformManualReopen(Rec);
                    end;
                }
                separator(Action610) { }
                action(SendBizTalkRqstforPurchQuote)
                {
                    ApplicationArea = Basic;
                    Caption = '&Send BizTalk Rqst. for Purch. Quote';
                    ToolTip = 'Executes the &Send BizTalk Rqst. for Purch. Quote action.';

                    trigger OnAction()

                    begin
                        //IF ApprovalMgt.PrePostApprovalCheck(SalesHeader,Rec) THEN
                        //  BizTalkManagement.SendReqforPurchQuote(Rec);
                    end;
                }
            }
            action(Print)
            {
                ApplicationArea = Basic;
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the &Print action.';

                trigger OnAction()
                begin
                    BCSetup.Get;
                    if BCSetup.Mandatory then
                        if LinesCommitted then
                            Error('All Lines should be committed');

                    Rec.RESET;
                    Rec.SETRANGE("No.", Rec."No.");
                    REPORT.RUN(REPORT::"Purchase Requisition Report", TRUE, TRUE, Rec);
                    Rec.RESET;
                    //DocPrint.PrintPurchHeader(Rec);
                end;
            }
            action(PrintIAC)
            {
                ApplicationArea = Basic;
                Caption = '&Print IAC FORM';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the &Print IAC FORM action.';

                trigger OnAction()
                begin

                    Rec.RESET;
                    Rec.SETRANGE("No.", Rec."No.");
                    REPORT.RUN(REPORT::"IAC Form", TRUE, TRUE, Rec);
                    Rec.RESET;
                    //DocPrint.PrintPurchHeader(Rec);
                end;
            }
            action(PurchHistoryBtn)
            {
                ApplicationArea = Basic;
                Caption = 'Purchase H&istory';
                Promoted = true;
                PromotedCategory = Process;
                Visible = PurchHistoryBtnVisible;
                ToolTip = 'Executes the Purchase H&istory action.';

                trigger OnAction()
                begin
                    //PurchInfoPaneMgmt.LookupVendPurchaseHistory(Rec,"Pay-to Vendor No.",TRUE);
                end;
            }
            action(PurchHistoryBtn1)
            {
                ApplicationArea = Basic;
                Caption = 'Purchase Histor&y';
                Promoted = true;
                PromotedCategory = Process;
                Visible = PurchHistoryBtn1Visible;
                ToolTip = 'Executes the Purchase Histor&y action.';

                trigger OnAction()
                begin
                    //PurchInfoPaneMgmt.LookupVendPurchaseHistory(Rec,"Buy-from Vendor No.",FALSE);
                end;
            }
            group("Import Items")
            {

                action("Process Imported Lines")
                {
                    ApplicationArea = Basic;
                    Image = PickWorksheet;
                    ToolTip = 'Executes the Process Imported Lines action.';

                    trigger OnAction()
                    begin
                        ReqLinesTemp.Reset;
                        if ReqLinesTemp.Find('-') then begin
                            repeat
                                PurchLine.Init;
                                PurchLine."Document Type" := Rec."Document Type";
                                PurchLine."Document No." := Rec."No.";
                                PurchLine."Line No." := ReqLinesTemp."Line No.";
                                PurchLine."Buy-from Vendor No." := Rec."Buy-from Vendor No.";
                                PurchLine.Type := PurchLine.Type::Item;
                                PurchLine."No." := ReqLinesTemp."No.";
                                PurchLine.Validate("No.");
                                PurchLine.Description := ReqLinesTemp.Description;
                                PurchLine."Unit of Measure" := ReqLinesTemp."Unit of Measure";
                                PurchLine.Quantity := ReqLinesTemp.Quantity;
                                PurchLine."Direct Unit Cost" := ReqLinesTemp."Unit Cost";
                                PurchLine.Validate("Direct Unit Cost");
                                PurchLine.Insert;
                            until ReqLinesTemp.Next = 0;
                        end;
                        ReqLinesTemp.DeleteAll;
                    end;
                }
                action("Clear Buffer")
                {
                    ApplicationArea = Basic;
                    Image = Cancel;
                    ToolTip = 'Executes the Clear Buffer action.';

                    trigger OnAction()
                    begin
                        ReqLinesTemp.DeleteAll;
                    end;
                }
            }
        }
    }



    trigger OnDeleteRecord(): Boolean
    begin
        CurrPage.SaveRecord;
        exit(Rec.ConfirmDeletion);
    end;

    trigger OnInit()
    begin
        PurchLinesEditable := true;
        PurchHistoryBtn1Visible := true;
        PayToCommentBtnVisible := true;
        PayToCommentPictVisible := true;
        PurchHistoryBtnVisible := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Responsibility Center" := UserMgt.GetPurchasesFilter();
        /*//Add dimensions if set by default here
        "Shortcut Dimension 1 Code":=UserMgt.GetSetDimensions(USERID,1);
        VALIDATE("Shortcut Dimension 1 Code");
        "Shortcut Dimension 2 Code":=UserMgt.GetSetDimensions(USERID,2);
        VALIDATE("Shortcut Dimension 2 Code");*/


        Rec.DocApprovalType := Rec.Docapprovaltype::Requisition;
        Rec."Assigned User ID" := UserId;

        UpdateControls;


    end;

    trigger OnOpenPage()
    begin
        if UserMgt.GetPurchasesFilter() <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Responsibility Center", UserMgt.GetPurchasesFilter());
            Rec.FilterGroup(0);
        end;
    end;

    var
        CopyPurchDoc: Report "Copy Purchase Document";
        UserMgt: Codeunit "User Setup Management BR";
        ArchiveManagement: Codeunit ArchiveManagement;
        BCSetup: Record "Budgetary Control Setup";
        PurchLine: Record "Purchase Line";
        [InDataSet]
        PurchHistoryBtnVisible: Boolean;
        [InDataSet]
        PayToCommentPictVisible: Boolean;
        [InDataSet]
        PayToCommentBtnVisible: Boolean;
        [InDataSet]
        PurchHistoryBtn1Visible: Boolean;
        [InDataSet]
        PurchLinesEditable: Boolean;
        Text19023272: label 'Buy-from Vendor';
        Text19005663: label 'Pay-to Vendor';
        ReqLinesTemp: Record "Store Requistion Lines Temp";



    local procedure UpdateInfoPanel()
    begin
        /*
        DifferBuyFromPayTo := "Buy-from Vendor No." <> "Pay-to Vendor No.";
        PurchHistoryBtnVisible := DifferBuyFromPayTo;
        PayToCommentPictVisible := DifferBuyFromPayTo;
        PayToCommentBtnVisible := DifferBuyFromPayTo;
        //PurchHistoryBtn1Visible := PurchInfoPaneMgmt.DocExist(Rec,"Buy-from Vendor No.");
        IF DifferBuyFromPayTo THEN
          PurchHistoryBtnVisible := PurchInfoPaneMgmt.DocExist(Rec,"Pay-to Vendor No.")
        */

    end;

    procedure LinesCommitted() Exists: Boolean
    var
        PurchLines: Record "Purchase Line";
    begin
        if BCSetup.Get() then begin
            if not BCSetup.Mandatory then begin
                Exists := false;
                exit;
            end;
        end else begin
            Exists := false;
            exit;
        end;
        if BCSetup.Get then begin
            Exists := false;
            PurchLines.Reset;
            PurchLines.SetRange(PurchLines."Document Type", Rec."Document Type");
            PurchLines.SetRange(PurchLines."Document No.", Rec."No.");
            PurchLines.SetRange(PurchLines.Committed, false);
            if PurchLines.Find('-') then
                Exists := true;
        end else
            Exists := false;
    end;

    procedure SomeLinesCommitted() Exists: Boolean
    var
        PurchLines: Record "Purchase Line";
    begin
        if BCSetup.Get then begin
            Exists := false;
            PurchLines.Reset;
            PurchLines.SetRange(PurchLines."Document Type", Rec."Document Type");
            PurchLines.SetRange(PurchLines."Document No.", Rec."No.");
            PurchLines.SetRange(PurchLines.Committed, true);
            if PurchLines.Find('-') then
                Exists := true;
        end else
            Exists := false;
    end;

    procedure UpdateControls()
    begin
        if Rec.Status <> Rec.Status::Open then begin
            PurchLinesEditable := false;
        end else
            PurchLinesEditable := true;
    end;





    trigger OnAfterGetCurrRecord()
    begin
        xRec := Rec;

        UpdateControls;
    end;
}

