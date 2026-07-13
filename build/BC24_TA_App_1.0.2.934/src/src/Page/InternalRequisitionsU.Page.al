page 50788 "Internal Requisitions U"
{
    Caption = 'Purchase Requisition Card';
    DeleteAllowed = false;
    PageType = Document;
    PromotedActionCategories = 'New,Process,Reports,Approval,Budget';
    RefreshOnActivate = true;
    SourceTable = "Purchase Header";
    SourceTableView = where(DocApprovalType = const(Requisition));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                Editable = statuseditable;
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                    trigger OnValidate()
                    begin
                        Rec."Posting Description" := '';
                    end;
                }


                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date when the related document was created.';
                    trigger OnValidate()
                    begin
                        Rec."Posting Description" := '';
                    end;
                }
                field("Requested Receipt Date"; Rec."Requested Receipt Date")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the date that you want the vendor to deliver your order. The field is used to calculate the latest date you can order, as follows: requested receipt date - lead time calculation = order date. If you do not need delivery on a specific date, you can leave the field blank.';
                    trigger OnValidate()
                    begin
                        Rec."Posting Description" := '';
                    end;
                }
                field("Posting Description"; Rec."Posting Description")
                {
                    Caption = 'Request Summary';
                    ApplicationArea = All;
                    ToolTip = 'Specifies additional posting information for the document. After you post the document, the description can add detail to vendor and customer ledger entries.';
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code of the responsibility center, such as a distribution hub, that is associated with the involved user, company, customer, or vendor.';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 3 Code field.';
                }
                //field("Procurement Method Code"; "Procurement Method Code")
                // {
                //  ApplicationArea = All;
                //}
                field("Assigned Procurement Officer"; Rec."Assigned Procurement Officer")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Assigned Procurement Officer field.';
                }
                field("Requisition No."; Rec."Requisition No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Requisition No. field.';
                }
                field("Requestor Name"; Rec."Requestor Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Requestor ID field.';
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Employee No. field.';
                }
                field("Imprest Memo No"; Rec."Imprest Memo No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Imprest Memo No field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specifies whether the record is open, waiting to be approved, invoiced for prepayment, or released to the next stage of processing.';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the currency that is used on the entry.';
                }
                field("Currency Factor"; Rec."Currency Factor")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Currency Factor field.';
                }
                field("Prices Including VAT"; Rec."Prices Including VAT")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if the Unit Price and Line Amount fields on document lines should be shown with or without VAT.';
                }

            }
            part(PurchLines; "Purchase Requisition Subform")
            {
                Editable = statuseditable;
                SubPageLink = "Document No." = field("No.");
            }
            systempart(Control1900383207; Links)
            {
                Visible = true;
            }
            systempart(Control1905767507; Notes)
            {
                Visible = true;
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

        area(processing)
        {
            action(Print)
            {
                ApplicationArea = All;
                Caption = 'Material Purchase Requisition Form ';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Report;
                ToolTip = 'Executes the Print action.';

                trigger OnAction()
                begin
                    //checkqty(Rec);
                    Rec.RESET;
                    Rec.SETRANGE("No.", Rec."No.");
                    REPORT.RUN(REPORT::"Purchase Requisition Report", TRUE, TRUE, Rec);
                    Rec.RESET;
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
                    ApprovalEntry: Record "Approval Entry";
                begin
                    ApprovalEntry.Reset();
                    ApprovalEntry.SetRange("Document No.", Rec."No.");
                    if ApprovalEntry.Find('-') then begin
                        PAGE.RunModal(PAGE::"Approval Entries List", ApprovalEntry);
                    end;
                end;
                // var
                //     ApprovalEntries: Page "Approval Entries";
                //     ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                //     RecID: RecordID;
                //     FromRecRef: RecordRef;
                //     DocDetails: Record "Purchase Header";
                // begin
                //     DocDetails.Reset();
                //     DocDetails.SetRange("No.", "No.");
                //     if DocDetails.Find('-') then begin
                //         FromRecRef.GETTABLE(DocDetails);
                //         RecID := FromRecRef.RecordId;
                //         ApprovalsMgmt.OpenApprovalEntriesPage(RecID);
                //     end;
                // end;
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
                    checkqty(Rec);
                    if not LinesExists then
                        Error('There are no Lines created for this Document');
                    //check if items are in store before purchase
                    if PurchSetup.Get() then
                        if PurchSetup."Purch Req Validate Quatity" = true then begin
                            PurchLine.RESET;
                            PurchLine.SETRANGE(PurchLine."Document Type", Rec."Document Type");
                            PurchLine.SETRANGE(PurchLine."Document No.", Rec."No.");
                            IF PurchLine.FIND('-') THEN BEGIN
                                REPEAT
                                    IF PurchLine.Type = PurchLine.Type::Item THEN BEGIN
                                        PurchLine.TESTFIELD(Quantity);
                                        QtyStore.GET(PurchLine."No.");
                                        QtyStore.CALCFIELDS(QtyStore.Inventory);
                                        //"Quantity In Store":=QtyStore.Inventory;
                                        BCSetup.Get();
                                        IF BCSetup."Check Procurement Plan" = true then begin
                                            if PurchLine.Quantity > PurchLine."Qty In Proc. Plan" then
                                                error('The approved procurement plan quantity for this item is ' + Format(PurchLine."Qty In Proc. Plan"));

                                        end;

                                        IF QtyStore.Inventory >= PurchLine.Quantity THEN
                                            ERROR('Please note that there are ' + FORMAT(QtyStore.Inventory) + ' items in the store. Please request for ' + FORMAT(PurchLine.Quantity - QtyStore.Inventory));
                                    END;
                                UNTIL PurchLine.NEXT = 0;
                            END;
                        end;

                    BCSetup.Get;
                    if BCSetup.Mandatory then begin

                        DeleteCommitment.Reset;
                        DeleteCommitment.SetRange(DeleteCommitment."Document Type", DeleteCommitment."document type"::Requisition);
                        DeleteCommitment.SetRange(DeleteCommitment."Document No.", Rec."No.");
                        DeleteCommitment.DeleteAll;

                        Commitment.CheckPurchase(Rec);
                    end;

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
            action("Check Budget Availability")
            {
                ApplicationArea = all;
                image = Balance;
                promoted = true;
                PromotedCategory = Category5;
                ToolTip = 'Executes the Check Budget Availability action.';


                trigger OnAction()
                begin

                    fn_MandatoryRequestSummary();

                    BCSetup.Get;
                    if not BCSetup.Mandatory then begin
                        Error('Budgetary checking is not mandatory on %1', BCSetup.TableCaption());
                        EXIT;
                    end;

                    if Rec.Status <> Rec.Status::Open then
                        Error('This document has already been %1. This functionality is available for open documents only');

                    DeleteCommitment.Reset;
                    DeleteCommitment.SetRange(DeleteCommitment."Document Type", DeleteCommitment."document type"::Requisition);
                    DeleteCommitment.SetRange(DeleteCommitment."Document No.", Rec."No.");
                    DeleteCommitment.DeleteAll;

                    Commitment.CheckPurchase(Rec);

                    Message('Budget Availability Checking Complete');

                    StatusEditable := false;
                end;
            }
            action("Cancel Budget Commitment")
            {
                ApplicationArea = All;
                Image = CancelAllLines;
                Promoted = true;
                PromotedCategory = Category5;
                ToolTip = 'Executes the Cancel Budget Commitment action.';


                trigger OnAction()
                begin

                    if not Confirm('Are you sure you want to Cancel All Commitments Done for this document', false, Rec."Document Type") then
                        Error('Process aborted by user');

                    DeleteCommitment.Reset;
                    DeleteCommitment.SetRange(DeleteCommitment."Document Type", DeleteCommitment."document type"::Requisition);
                    DeleteCommitment.SetRange(DeleteCommitment."Document No.", Rec."No.");
                    DeleteCommitment.DeleteAll;

                    //Update Committed on purchase lines
                    PurchLine.Reset;
                    PurchLine.SetRange(PurchLine."Document No.", Rec."No.");
                    PurchLine.FindFirst();
                    begin
                        repeat
                            PurchLine.Committed := false;
                            PurchLine.Modify;
                        until PurchLine.Next = 0;
                    end;

                    Message('Commitments Cancelled Successfully for Doc. No %1', Rec."No.");
                    StatusEditable := true;
                end;
            }
        }
    }


    trigger OnAfterGetCurrRecord()
    begin
        UpdateControls;
    end;

    trigger OnOpenPage()
    var
        HREmp: Record "HR-Employee";
    begin
        if Rec."Request No" = '' then begin
            if Rec."Employee No." <> '' then begin
                if HREmp.Get(Rec."Employee No.") then begin
                    Rec."Request No" := HREmp."No.";//"Employee No.";
                    Rec."Employee No." := HREmp."Employee UserID";
                    Rec."Requestor Name" := HREmp."First Name" + ' ' + HREmp."Middle Name" + ' ' + HREmp."Last Name";
                end;
            end;
        end;
        if Rec."Request No" = '' then begin
            if Rec."Assigned User ID" <> '' then begin
                HREmp.Reset();
                HREmp.SetRange("User ID", Rec."Assigned User ID");
                if HREmp.find('-') then begin
                    Rec."Request No" := Rec."Employee No.";
                    Rec."Employee No." := HREmp."Employee UserID";
                    Rec."Requestor Name" := HREmp."First Name" + ' ' + HREmp."Middle Name" + ' ' + HREmp."Last Name";
                end;
            end;
        end;
    end;

    trigger OnAfterGetRecord()
    begin
        CurrPageUpdate;
        UpdateControls;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        CurrPage.SaveRecord;
        exit(Rec.ConfirmDeletion);
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        PurchaseHeader.Reset;
        PurchaseHeader.SetRange(PurchaseHeader."Document Type", PurchaseHeader.DocApprovalType::Requisition);
        PurchaseHeader.SetRange(PurchaseHeader."Assigned User ID", UserId);
        PurchaseHeader.SetRange(PurchaseHeader.Status, PurchaseHeader.Status::Open);
        if PurchaseHeader.FindFirst() then Error(Text001);
        Rec."Posting Description" := '';

        //Added Table Extension - No modify option allowed on Base Fields
        Rec.DocApprovalType := Rec.Docapprovaltype::Requisition;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        UserSetup: Record "User Setup";
        PurchSetup: Record "Purchases & Payables Setup";
        NoSeriesMgt: Codeunit "No. Series";
    begin
        CashOfficeSetup.get;
        PurchSetup.get;
        CashOfficeSetup.TestField("Requisition Default Vendor");
        PurchSetup.TestField("Requisition No");
        //NoSeriesMgt.GetNextNo(PurchSetup."Requisition No", xRec."No. Series", 0D, Rec."No.", Rec."No. Series");
        Rec."No." := NoSeriesMgt.GetNextNo(PurchSetup."Requisition No", today, true);
        Rec.DocApprovalType := Rec.Docapprovaltype::Requisition;
        Rec."Order Date" := Today();
        Rec."Document Date" := Today(); //Used in Budget Checking Functionality
        Rec."Buy-from Vendor No." := CashOfficeSetup."Requisition Default Vendor";
        Rec.Validate("Buy-from Vendor No.");
        Rec."Pay-to Vendor No." := CashOfficeSetup."Requisition Default Vendor";
        if UserSetup.get(Database.UserId) then
            Rec."Requestor Name" := UserSetup.UserName;
        UpdateControls;
        Rec."Posting Description" := '';

    end;

    trigger OnNextRecord(Steps: Integer): Integer
    begin
        UpdateControls;
    end;

    var

        Commitment: Codeunit "Budgetary Control";
        BCSetup: Record "Budgetary Control Setup";
        DeleteCommitment: Record "Committment";
        PurchLine: Record "Purchase Line";
        StatusEditable: Boolean;
        Pr0cumentMethodEditable: Boolean;
        PurchaseHeader: Record "Purchase Header";
        CashOfficeSetup: Record "Cash Office Setup";
        CustomApprovals: Codeunit "Custom Approvals Codeunit";
        VarVariant: Variant;
        Text001: label 'Kindly utilize the open document before creating a new one.';

        QtyStore: Record Item;

        PurchSetup: Record "Purchases & Payables Setup";




    procedure LinesExists(): Boolean
    var
        HasLines: Boolean;
    begin
        HasLines := false;
        PurchLine.Reset;
        PurchLine.SetRange(PurchLine."Document No.", Rec."No.");
        if PurchLine.FindFirst() then begin
            HasLines := true;
            exit(HasLines);
        end;
    end;


    procedure UpdateControls()
    begin
        if Rec.Status = Rec.Status::Open then
            StatusEditable := true
        else
            StatusEditable := false;

        if Rec.Status <> Rec.Status::Released then
            Pr0cumentMethodEditable := false
        else
            Pr0cumentMethodEditable := true
    end;


    procedure CurrPageUpdate()
    begin
        xRec := Rec;
        UpdateControls;
        CurrPage.Update;
    end;



    procedure AllFieldsEntered(): Boolean
    var
        AllKeyFieldsEntered: Boolean;
    begin
        AllKeyFieldsEntered := true;

        PurchLine.Reset;
        PurchLine.SetRange(PurchLine."Document No.", Rec."No.");
        if PurchLine.FindFirst() then begin
            repeat
                if (PurchLine.Type = PurchLine.Type::" ") or
                   (PurchLine."No." = '') or
                   (PurchLine.Quantity = 0) or
                   (PurchLine."Direct Unit Cost" = 0) or
                   (PurchLine."Shortcut Dimension 1 Code" = '') or
                   (PurchLine."Shortcut Dimension 2 Code" = '')
                   then
                    AllKeyFieldsEntered := false;
            until PurchLine.Next = 0;
            exit(AllKeyFieldsEntered);
        end;
    end;

    local procedure fn_MandatoryRequestSummary()
    begin
        /*  //Tag all the Purchase Line entries as Uncommitted
         PurchLine.Reset;
         PurchLine.SetRange(PurchLine."Document No.", "No.");
         if PurchLine.FindFirst() then begin
             repeat
                 if PurchLine."Request Summary" = '' then Error('Please enter the request summary on all line entries on the ');
             until PurchLine.Next = 0;
         end; */
    end;

    procedure checkqty(Rec: Record "Purchase Header")
    var
        purchlines: record "Purchase Line";
        isqtyblank: Boolean;
    begin
        purchlines.reset;
        purchlines.SetRange(purchlines."Document No.", Rec."No.");
        if purchlines.find('-') then begin
            if PurchLine.Quantity > 0 then begin

            end else if purchlines.Quantity < 1 then begin
                Error(purchlines.Description + ' ' + 'must have quantity greater than 0');
            end;
        end;
    end;
}

