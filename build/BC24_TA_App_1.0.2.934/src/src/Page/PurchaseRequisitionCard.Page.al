Page 50168 "Purchase Requisition Card"
{
    Caption = 'Purchase Requisition Card';
    DeleteAllowed = false;
    PageType = Document;
    PromotedActionCategories = 'New,Process,Reports,Functions,Budget';
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
                }
                field("Requested Receipt Date"; Rec."Requested Receipt Date")
                {
                    ApplicationArea = All;
                    Visible = true;
                    ToolTip = 'Specifies the date that you want the vendor to deliver your order. The field is used to calculate the latest date you can order, as follows: requested receipt date - lead time calculation = order date. If you do not need delivery on a specific date, you can leave the field blank.';
                }
                field("Order Date"; Rec."Order Date")
                {
                    ApplicationArea = All;
                    Caption = 'Requisition Date';
                    ToolTip = 'Specifies the date when the order was created.';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date when the related document was created.';
                }
                field("Request Description"; Rec."Request Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Request Description field.';
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
                field("Procurement Method Code"; Rec."Procurement Method Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Procurement Method Code field.';
                }
                field("Assigned User ID"; Rec."Assigned User ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the ID of the user who is responsible for the document.';
                }
                field("Requestor Name"; Rec."Requestor Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Requestor ID field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specifies whether the record is open, waiting to be approved, invoiced for prepayment, or released to the next stage of processing.';
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
    }

    actions
    {

        area(processing)
        {
            action(Print)
            {
                ApplicationArea = All;
                Caption = 'Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Report;
                ToolTip = 'Executes the Print action.';

                trigger OnAction()
                begin
                    Message('Implement print purchase requisition here');
                end;
            }
            action("Check Budget Availability")
            {
                ApplicationArea = all;
                image = Balance;
                promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
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
                PromotedIsBig = true;
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


        //Added Table Extension - No modify option allowed on Base Fields
        Rec.DocApprovalType := Rec.Docapprovaltype::Requisition;
        Rec."Requestor Name" := Database.UserId;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.DocApprovalType := Rec.Docapprovaltype::Requisition;
        Rec."Order Date" := Today();
        Rec."Document Date" := Today(); //Used in Budget Checking Functionality

        UpdateControls;
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
        Text001: label 'Kindly utilize the open document before creating a new one.';

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
        //Tag all the Purchase Line entries as Uncommitted
        PurchLine.Reset;
        PurchLine.SetRange(PurchLine."Document No.", Rec."No.");
        if PurchLine.FindFirst() then begin
            repeat
                if PurchLine."Request Summary" = '' then Error('Please enter the request summary on all line entries on the ');
            until PurchLine.Next = 0;
        end;
    end;
}

