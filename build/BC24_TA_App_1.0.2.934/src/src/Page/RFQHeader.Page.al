Page 51156 "RFQ Header"
{
    DeleteAllowed = false;
    PageType = Card;
    PromotedActionCategories = 'New,Process,Reports,Approval';
    SourceTable = "Purchase Quote Header";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("Requisition Date"; Rec."Requisition Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Requisition Date field.';
                }
                field("Floating date";"Floating date"){
                    ApplicationArea = Basic;
                }
                field("Expected Closing Date"; Rec."Expected Closing Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Expected Closing Date field.';
                }
                field("Expected Opening Date"; Rec."Expected Opening Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Expected Opening Date field.';
                }
                
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    Caption = 'Section';
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Section field.';
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Responsibility Center field.';
                }
                field("Internal Requisition No."; Rec."Internal Requisition No.")
                {
                    Caption = 'Purchase Requisition No.';
                    ApplicationArea = Basic;
                    LookupPageId = "Purchase Requisition-Approved";
                    DrillDownPageId = "Purchase Requisition-Approved";
                    ToolTip = 'Specifies the value of the Purchase Requisition No. field.';
                }
                field("Posting Description"; Rec."Posting Description")
                {
                    Caption = 'Request Description';
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Request Description field.';
                }
                field("Days to Deliver"; Rec."Days to Deliver")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Days to Deliver field.';
                }

                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the User ID field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    ToolTip = 'Specifies the value of the Status field.';

                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = Basic;
                    Enabled = false;
                    ToolTip = 'Specifies the value of the Document Type field.';
                }
                field("Supplier Category"; Rec."Supplier Category")
                {
                    ApplicationArea = basic;
                    Caption = 'Supplier Category';
                    ToolTip = 'Specifies the value of the Supplier Category field.';
                }
                field("Product Category"; Rec."Product Category")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Product Category field.';
                }
                field("Sub Product Category"; Rec."Sub Product Category")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Sub Product Category field.';
                }
                field("Quotation Vendor Limit"; Rec."Quotation Vendor Limit")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Quotation Vendor Limit field.';
                }

                field("Opening Committee"; Rec."Opening Committee")
                {
                    Caption = 'Has opening Committee';
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Has opening Committee field.';
                }
                field("Evaluation Committee"; Rec."Evaluation Committee")
                {
                    Caption = 'Has evaluation Committee';
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Has evaluation Committee field.';
                }
            }
            part(Control1102755015; "RFQ Subform")
            {
                SubPageLink = "Document No." = field("No.");
            }
            group(Termination)
            {
                Caption = 'Termination';
                field(Cancelled; Rec.Cancelled)
                {
                    ApplicationArea = Basic;
                    Caption = 'Terminated';
                    ToolTip = 'Specifies the value of the Terminated field.';
                }
                field("Cancelled By"; Rec."Cancelled By")
                {
                    ApplicationArea = Basic;
                    Caption = 'Terminated By';
                    ToolTip = 'Specifies the value of the Terminated By field.';
                }
                field("Cancelled Date"; Rec."Cancelled Date")
                {
                    ApplicationArea = Basic;
                    Caption = 'Terminated On';
                    ToolTip = 'Specifies the value of the Terminated On field.';
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
                              "No." = FIELD("Internal Requisition No.");
            }
        }


    }

    actions
    {
        area(Navigation)
        {
            action("Required Documents")
            {
                ApplicationArea = Basic;
                Caption = 'Required Documents';
                Image = Vendor;
                Promoted = true;
                RunObject = page "RFQ Required Documents";
                RunPageLink = "FRQ No" = field("No.");
                ToolTip = 'Executes the Required Documents action.';
            }
        }
        area(processing)
        {

            action("Assign Vendor(s)")
            {
                ApplicationArea = Basic;
                Caption = 'Assign Vendor(s)';
                Image = Vendor;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the Assign Vendor(s) action.';
                trigger OnAction()
                var
                    Vends: Record "Quotation Request Vendors";
                    Window: Dialog;
                    VendCats: Record "Vendor Product Categories";
                    k: Integer;
                    Vend: Record Vendor;
                    CountLimit: Integer;
                begin

                    Rec.TESTFIELD("Product Category");
                    //TESTFIELD("Supplier Category");
                    //TESTFIELD("Quotation Vendor Limit");
                    //TESTFIELD(Status, Status::Released);
                    if Confirm('Do you want to delete all vendors assigned to this document?') = true then begin
                        //delete all other allocated vendors
                        Vends.RESET;
                        Vends.SETRANGE("Requisition Document No.", Rec."No.");
                        IF Vends.FIND('-') THEN BEGIN
                            WHILE Vends.FIND('-') DO
                                Vends.DELETE;
                            //Vends.DELETEALL;
                        END;
                    end;

                    Window.OPEN('Assigning Vendors. Please Wait');
                    k := Rec."Quotation Vendor Limit";
                    CountLimit := 0;
                    VendCats.RESET;
                    if Rec."Product Category" <> '' then begin
                        VendCats.SETRANGE(VendCats.Category, Rec."Product Category");
                    end;
                    if Rec."Sub Product Category" <> '' then begin
                        VendCats.SETRANGE(VendCats."Sub Category", Rec."Sub Product Category");
                    end;

                    //if special group is selected, restrict to special groups
                    IF Rec."Supplier Category" <> '' THEN BEGIN
                        VendCats.SETRANGE("Supplier Category", Rec."Supplier Category");
                    END;
                    VendCats.SETCURRENTKEY("Last RFQ Assign Date");
                    VendCats.SETASCENDING("Last RFQ Assign Date", FALSE);
                    IF VendCats.FIND('-') THEN BEGIN
                        //if the vendor limit is not 0, limit to the selected few
                        if k <> 0 then begin
                            CountLimit := VendCats.Count - k;
                        end;
                        FOR k := 1 TO CountLimit DO BEGIN
                            //REPEAT
                            Vends.RESET;
                            Vends.SETRANGE("Requisition Document No.", Rec."No.");
                            Vends.SETRANGE("Vendor No.", VendCats."Vendor No");
                            IF NOT Vends.FIND('-') THEN BEGIN
                                Vends.INIT;
                                Vends."Document Type" := Vends."Document Type"::"Quotation Request";
                                Vends."Requisition Document No." := Rec."No.";
                                Vends."Vendor No." := VendCats."Vendor No";
                                Vends."Date Assigned" := TODAY;
                                // Vends."Supplier Category" := "Vendor Categories";
                                Vends."Supplier Category" := Rec."Supplier Category";
                                Vends."Product Category" := Rec."Product Category";
                                Vends."Sub Product Category" := Rec."Sub Product Category";
                                Vends."Request Summary" := Rec."Request Description";
                                Vend.GET(VendCats."Vendor No");
                                Vends."Vendor Name" := Vend.Name;
                                Vends.INSERT();
                                VendCats."Last RFQ Assign Date" := TODAY;
                                VendCats.MODIFY;
                            END;
                            //k:=k-1;
                            //UNTIL VendCats.NEXT = CountLimit;
                        END;

                        Window.CLOSE;
                        Vends.RESET;
                        Vends.SETRANGE(Vends."Document Type", Rec."Document Type");
                        Vends.SETRANGE(Vends."Requisition Document No.", Rec."No.");

                        PAGE.RUN(PAGE::"Quotation Request Vendors", Vends);
                    END ELSE BEGIN
                        Window.CLOSE;
                        Vends.RESET;
                        Vends.SETRANGE(Vends."Document Type", Rec."Document Type");
                        Vends.SETRANGE(Vends."Requisition Document No.", Rec."No.");

                        PAGE.RUN(PAGE::"Quotation Request Vendors", Vends);
                    END;
                end;
            }
            action("Print Preview")
            {
                ApplicationArea = Basic;
                Caption = 'Print Preview';
                Image = PrintReport;
                Promoted = true;
                PromotedCategory = Report;
                ToolTip = 'Executes the Print Preview action.';
                trigger OnAction()
                var
                    PurchaseQuoteHeader: record "Purchase Quote Header";
                    repVend: Report "Purchase Quote Request Report2";
                begin
                    PurchaseQuoteHeader.SetRecFilter;
                    PurchaseQuoteHeader.SetFilter(PurchaseQuoteHeader."Document Type", '%1', Rec."Document Type");
                    PurchaseQuoteHeader.SetFilter("No.", Rec."No.");
                    repVend.SetTableView(PurchaseQuoteHeader);
                    repVend.Run;

                    /* QuotationRequestVendors.reset;
                    QuotationRequestVendors.setrange(QuotationRequestVendors."Requisition Document No.", "No.");
                    if QuotationRequestVendors.find('-') then begin
                        repeat
                            PurchaseQuoteHeader.reset;
                            PurchaseQuoteHeader.SETFILTER("No.", "No.");
                            PurchaseQuoteHeader.setfilter("Vendor No. Filter", QuotationRequestVendors."Vendor No.");
                            if PurchaseQuoteHeader.find('-') then
                                REPORT.RUN(REPORT::"Request Quotation Analysis", true, true, PurchaseQuoteHeader);
                        until QuotationRequestVendors.Next = 0;
                    end; */

                end;
            }

            action("Tender Commitee")
            {
                Caption = 'Committee';
                Image = Group;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page "Tender Committee";
                RunPageLink = "Tendor No" = field("No.");
                ToolTip = 'Executes the Committee action.';

            }

            action("Opening Commitee")
            {
                Caption = 'Opening Commitee';
                Image = Users;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Opening Commitee action.';

                trigger OnAction()
                var
                    TenderCommittee: Record "Tender Committee";
                begin
                    if Rec."Opening Committee" = false then Rec.TestField("Opening Committee", true);
                    TenderCommittee.RESET;
                    TenderCommittee.SETFILTER("Tendor No", Rec."No.");
                    TenderCommittee.SETFILTER("Committee Type", 'RFQ Opening Committee');
                    //IF TenderCommittee.FIND('-') THEN BEGIN
                    PAGE.RUN(Page::"Tender Committee", TenderCommittee)
                    //END ELSE BEGIN
                    //    ERROR('The opening committee for this RFQ have not been set')
                    //END;
                end;
            }
            action("Evaluation Commitee")
            {
                Caption = 'Evaluation Commitee';
                Image = Users;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Evaluation Commitee action.';
                //RunObject = Page 70135264;
                //RunPageLink = "Tendor No"=FIELD("No.");

                trigger OnAction()
                var
                    TenderCommittee: Record "Tender Committee";
                begin
                    Rec.TESTFIELD(Status, Rec.Status::Closed);
                    TenderCommittee.RESET;
                    TenderCommittee.SETFILTER("Tendor No", Rec."No.");
                    TenderCommittee.SETFILTER("Committee Type", 'RFQ Evaluation Committee');
                    IF TenderCommittee.FIND('-') THEN BEGIN
                        PAGE.RUN(Page::"Tender Committee", TenderCommittee)
                    END;
                end;
            }
            action("Create Quote")
            {
                ApplicationArea = Basic;
                Caption = 'Create Quote';
                Image = PrintReport;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the Create Quote action.';
                trigger OnAction()
                var
                    PurchaseQuoteLine: Record "Purchase Quote Line";
                    QuotationRequestVendors: record "Quotation Request Vendors";
                    PurchaseHeader: record "Purchase Header";
                    PurchaseLines: Record "Purchase Line";
                begin
                    QuotationRequestVendors.RESET();
                    QuotationRequestVendors.SETRANGE(QuotationRequestVendors."Requisition Document No.", Rec."No.");
                    IF QuotationRequestVendors.FINDSET THEN BEGIN
                        REPEAT
                            //Create quote header
                            PurchaseHeader.INIT();

                            PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::Quote;
                            PurchaseHeader.DocApprovalType := PurchaseHeader.DocApprovalType::Quote;

                            PurchaseHeader."No." := '';

                            PurchaseHeader."Responsibility Center" := Rec."Responsibility Center";

                            PurchaseHeader."Shortcut Dimension 1 Code" := Rec."Shortcut Dimension 1 Code";
                            PurchaseHeader.VALIDATE("Shortcut Dimension 1 Code");

                            PurchaseHeader."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
                            PurchaseHeader.VALIDATE("Shortcut Dimension 2 Code");

                            PurchaseHeader.VALIDATE("Buy-from Vendor No.", QuotationRequestVendors."Vendor No.");

                            PurchaseHeader."Responsibility Center" := Rec."Responsibility Center";

                            PurchaseHeader.INSERT(TRUE);

                            //Create quote lines
                            PurchaseQuoteLine.SETRANGE(PurchaseQuoteLine."Document No.", Rec."No.");
                            IF PurchaseQuoteLine.FINDSET() THEN
                                REPEAT
                                    PurchaseLines.INIT();
                                    PurchaseLines.TRANSFERFIELDS(PurchaseQuoteLine);
                                    PurchaseLines."Document Type" := PurchaseLines."Document Type"::Quote;
                                    PurchaseLines."Document No." := Rec."No.";
                                    PurchaseLines.INSERT();

                                UNTIL PurchaseQuoteLine.NEXT() = 0;
                        UNTIL QuotationRequestVendors.NEXT() = 0;
                    END;

                end;
            }
            action(PlacedQuotes)
            {
                ApplicationArea = basic;
                Caption = 'Placed Quotes';
                Promoted = true;
                PromotedCategory = Process;
                Image = Allocate;
                ToolTip = 'Executes the Placed Quotes action.';
                trigger OnAction()
                var
                    TenderCommittee: Record "Tender Committee";

                begin
                    Rec.TESTFIELD(Status, Rec.Status::Open);
                    //Rec.TESTFIELD(Status, Rec.Status::Released);
                    //check if opening Committee have been set
                    IF Rec."Opening Committee" = TRUE THEN BEGIN
                        TenderCommittee.RESET;
                        TenderCommittee.SETRANGE("Tendor No", Rec."No.");
                        TenderCommittee.SETRANGE("Committee Type", TenderCommittee."Committee Type"::"RFQ Opening Committee");
                        IF TenderCommittee.FIND('-') THEN BEGIN
                            //run the authentication page
                            PAGE.RUN(page::"Tender Passwords Page", TenderCommittee);
                        END ELSE
                            ERROR('The Evaluation Committee for this RFQ has not been set');
                    END ELSE BEGIN
                        OpenBids();
                    END;
                end;
            }
            action(BidAnalysis)
            {
                ApplicationArea = basic;
                Caption = 'Bid Analysis';
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the Bid Analysis action.';
                trigger OnAction()


                var
                    TenderCommittee: Record "Tender Committee";

                begin
                    Rec.TESTFIELD(Status, Rec.Status::Open);
                    //check if Evaluation Committee have been set
                    IF Rec."Evaluation Committee" = TRUE THEN BEGIN
                        TenderCommittee.RESET;
                        TenderCommittee.SETRANGE("Tendor No", Rec."No.");
                        TenderCommittee.SETRANGE("Committee Type", TenderCommittee."Committee Type"::"RFQ Evaluation Committee");
                        IF TenderCommittee.FIND('-') THEN BEGIN
                            //run the authentication page
                            //PAGE.RUN(page::"Tender Passwords Page", TenderCommittee);//felix-add later
                            OpenBids();
                        END ELSE
                            ERROR('The Evaluation Committee for this RFQ has not been set');
                    END ELSE BEGIN
                        OpenBids();
                    END;
                end;
            }
            action("CancelDoc")
            {
                ApplicationArea = Basic;
                Caption = 'Cancel';
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Cancel action.';
                trigger OnAction()
                var
                begin
                    Rec.Status := Rec.Status::Cancelled;
                    Rec."Cancelled By" := UserId;
                    Rec."Cancelled Date" := Today;
                    Rec.Cancelled := true;
                    Rec.Modify();
                    Message('Successfully Cancelled');
                end;
            }
            action("Reopen")
            {
                ApplicationArea = Basic;
                Caption = 'ReOpen';
                Image = ReOpen;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the ReOpen action.';
                trigger OnAction()
                var
                    usersetup: Record "User Setup";
                begin
                    usersetup.Get(Database.UserId);
                    if usersetup."Is RFQ Administrator" = true then begin
                        Rec.Status := Rec.Status::Open;
                        Rec.Modify();
                        Message('Successfully reopened');
                    end else
                        Error('You have not been granted the rights to perform this activity');

                end;
            }
            action("Release")
            {
                ApplicationArea = Basic;
                Caption = 'Release';
                Image = PrintReport;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the Release action.';
                trigger OnAction()
                var
                    PurchaseQuoteLine: Record "Purchase Quote Line";
                    QuotationRequestVendors: record "Quotation Request Vendors";
                begin
                    IF CONFIRM('Release document?', FALSE) = FALSE THEN BEGIN EXIT END;

                    QuotationRequestVendors.RESET;
                    QuotationRequestVendors.SETRANGE(QuotationRequestVendors."Document Type", Rec."Document Type");
                    QuotationRequestVendors.SETRANGE(QuotationRequestVendors."Requisition Document No.", Rec."No.");
                    IF not QuotationRequestVendors.find('-') THEN ERROR('No vendors assigned for this RFQ');

                    //Check if the document has any lines
                    PurchaseQuoteLine.RESET;
                    PurchaseQuoteLine.SETRANGE(PurchaseQuoteLine."Document Type", Rec."Document Type");
                    PurchaseQuoteLine.SETRANGE(PurchaseQuoteLine."Document No.", Rec."No.");
                    IF PurchaseQuoteLine.FINDFIRST THEN BEGIN
                        REPEAT
                            PurchaseQuoteLine.TESTFIELD(PurchaseQuoteLine.Quantity);
                            //  PurchaseQuoteLine.TESTFIELD("Days to Deliver");

                            PurchaseQuoteLine.TESTFIELD("No.");
                        UNTIL PurchaseQuoteLine.NEXT = 0;
                    END
                    ELSE BEGIN
                        ERROR('Document has no lines');
                    END;



                    /* QuotationRequestVendors.RESET;
                    QuotationRequestVendors.SETRANGE(QuotationRequestVendors."Document Type", "Document Type");
                    QuotationRequestVendors.SETRANGE(QuotationRequestVendors."Requisition Document No.", "No.");
                    IF QuotationRequestVendors.FINDSET() THEN
                        QuotationRequestVendors.MODIFYALL(QuotationRequestVendors.Status, QuotationRequestVendors.Status::Released);
*/
                    Rec.Status := Rec.Status::Released;
                    Rec."Released By" := USERID;
                    Rec."Release Date" := TODAY;
                    Rec.MODIFY();

                end;
            }

            action(Approvals)
            {
                Caption = 'Approvals';
                Image = Approvals;
                Promoted = true;
                ApplicationArea = all;
                PromotedCategory = Category4;
                ToolTip = 'Executes the Approvals action.';
                trigger OnAction()
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    RecID: RecordID;
                    FromRecRef: RecordRef;
                    DocDetails: Record "Purchase Quote Header";
                begin
                    DocDetails.Reset();
                    DocDetails.SetRange("No.", Rec."No.");
                    if DocDetails.Find('-') then begin
                        FromRecRef.GETTABLE(DocDetails);
                        RecID := FromRecRef.RecordId;
                        ApprovalsMgmt.OpenApprovalEntriesPage(RecID);
                    end;
                end;
            }
            action(sendApproval)
            {
                Caption = 'Send A&pproval Request';
                Image = SendApprovalRequest;
                Promoted = true;

                ApplicationArea = all;
                PromotedCategory = Category4;
                ToolTip = 'Executes the Send A&pproval Request action.';
                trigger OnAction()

                begin
                    if not LinesExists then
                        Error('There are no Lines created for this Document');

                    VarVariant := Rec;
                    if CustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) then
                        CustomApprovals.OnSendDocForApproval(VarVariant);

                end;
            }
            action(cancellsApproval)
            {
                Caption = 'Cancel Approval Re&quest';
                Image = Cancel;
                Promoted = true;

                ApplicationArea = all;
                PromotedCategory = Category4;
                ToolTip = 'Executes the Cancel Approval Re&quest action.';
                trigger OnAction()

                begin
                    VarVariant := Rec;
                    CustomApprovals.OnCancelDocApprovalRequest(VarVariant);
                end;
            }

        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Assigned User ID" := Database.UserId;
    end;

    var
        VarVariant: Variant;
        CustomApprovals: Codeunit "Custom Approvals Codeunit";

        PurchaseQuoteLine: Record "Purchase Quote Line";

    procedure LinesExists(): Boolean
    var
        HasLines: Boolean;
    begin
        HasLines := false;
        PurchaseQuoteLine.Reset;
        PurchaseQuoteLine.SetRange(PurchaseQuoteLine."Document No.", Rec."No.");
        if PurchaseQuoteLine.FindFirst() then begin
            HasLines := true;
            exit(HasLines);
        end;
    end;

    local procedure OpenBids()
    var
        BidAnalysis: Record "Bid Analysis";
        PurchaseHeader: Record "Purchase Header";
        PurchaseLines: Record "Purchase Line";
        InsertCount: Integer;
    begin
        //deletebidanalysis for this rfq
        BidAnalysis.SETRANGE(BidAnalysis."RFQ No.", Rec."No.");
        BidAnalysis.DELETEALL;


        //insert the quotes from rfq
        PurchaseHeader.reset;
        PurchaseHeader.SETRANGE(PurchaseHeader."RFQ No.", Rec."No.");
        if PurchaseHeader.FIND('-') then begin
            REPEAT
                PurchaseLines.RESET;
                PurchaseLines.SETRANGE("Document No.", PurchaseHeader."No.");
                IF PurchaseLines.FINDSET THEN
                    REPEAT
                        BidAnalysis.INIT;
                        BidAnalysis."RFQ No." := Rec."No.";
                        BidAnalysis."RFQ Line No." := PurchaseLines."Line No.";
                        BidAnalysis."Quote No." := PurchaseLines."Document No.";
                        BidAnalysis."Vendor No." := PurchaseHeader."Buy-from Vendor No.";
                        BidAnalysis."Item No." := PurchaseLines."No.";
                        BidAnalysis.Description := PurchaseLines.Description;
                        BidAnalysis.Quantity := PurchaseLines.Quantity;
                        BidAnalysis."Unit Of Measure" := PurchaseLines."Unit of Measure";
                        BidAnalysis.Amount := PurchaseLines."Direct Unit Cost";
                        BidAnalysis."Line Amount" := BidAnalysis.Quantity * BidAnalysis.Amount;
                        BidAnalysis.INSERT(TRUE);
                        InsertCount += 1;
                    UNTIL PurchaseLines.NEXT = 0;
            UNTIL PurchaseHeader.NEXT = 0;
        end;
        BidAnalysis.reset;
        BidAnalysis.SETRANGE(BidAnalysis."RFQ No.", Rec."No.");
        if BidAnalysis.find('-') then
            PAGE.RUN(PAGE::"Bid Analysis", BidAnalysis);

    end;
}