pageextension 50022 "Purchase Invoice Ext" extends "Purchase Invoice"
{

    layout
    {
        // Add changes to page layout here
        modify(Status)
        {
            Editable = true;
        }
        addafter("Vendor Invoice No.")
        {
            field("Purchase Requisition No."; Rec."Purchase Requisition No.")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Purchase Requisition No. field.';
            }
            field("Shortcut Dimension 1 Code1"; Rec."Shortcut Dimension 1 Code")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
            }
            field("Shortcut Dimension 2 Code1"; Rec."Shortcut Dimension 2 Code")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';

            }
            field("Posting Description2"; Rec."Posting Description")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies additional posting information for the document. After you post the document, the description can add detail to vendor and customer ledger entries.';

            }
            field("Vessel No"; Rec."Vessel No")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Vessel No field.';

            }
            field("Lading Date"; Rec."Lading Date")
            {
                Caption = 'LD Date';
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the LD Date field.';
            }
            field("Shipping Agent Code"; Rec."Shipping Agent Code")
            {
                caption = 'Truck No';
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Truck No field.';
            }
            field("Ship-to Address1"; Rec."Ship-to Address")
            {
                caption = 'Driver Name';
                ApplicationArea = All;
                ToolTip = 'Specifies the address that you want the items in the purchase order to be shipped to.';
            }
        }
    }

    actions
    {
        modify(SendApprovalRequest)
        {

            Caption = 'Send A&pproval Request';

            ApplicationArea = all;
            Promoted = true;
            PromotedCategory = Category4;
            ToolTip = 'Request approval of the document.';
            trigger OnBeforeAction()
            begin

                IF NOT LinesExists THEN
                    ERROR('There are no Lines created for this Document');

                //Ensure No Items That should be committed that are not
                IF LinesCommitmentStatus THEN
                    ERROR('There are some lines that have not been committed');

                //Release the Imprest for Approval
                Rec.TESTFIELD(Status, Rec.Status::Open);
                Rec.TESTFIELD("Vendor Invoice No.");
                //  if ApprovalsMgmt.CheckPurchaseApprovalPossible(Rec) then
                //      ApprovalsMgmt.OnSendPurchaseDocForApproval(Rec);
            end;
        }
        addafter("Request Approval")
        {
            group("Document Actions")
            {
                action(Release_Order)
                {
                    Caption = 'Realease';
                    ApplicationArea = basic;
                    Image = ReleaseDoc;
                    Visible = true;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Realease action.';

                    trigger OnAction()

                    begin
                        Rec.Status := Rec.Status::Released;
                        Rec.Modify();
                    end;
                }

                action(Reopen_Order)
                {
                    Caption = 'Reopen';
                    ApplicationArea = basic;
                    Image = ReleaseDoc;
                    Visible = true;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Reopen action.';

                    trigger OnAction()

                    begin
                        Rec.Status := Rec.Status::Open;
                        Rec.Modify();
                    end;
                }
            }
            group("Check Budget")
            {

                action("Check Budget Availability")
                {
                    Caption = 'Check Budget Availability';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Category5;
                    ToolTip = 'Executes the Check Budget Availability action.';
                    trigger OnAction()
                    var
                        BCSetup: Record "Budgetary Control Setup";
                    begin

                        BCSetup.Get;
                        if not BCSetup.Mandatory then
                            exit;

                        if Rec.Status = Rec.Status::Released then
                            Error('This document has already been released. This functionality is available for open documents only');
                        if not SomeLinesCommitted then begin
                            // if not Confirm('Some or All the Lines Are already Committed do you want to continue', true, "Document Type") then
                            //     Error('Budget Availability Check and Commitment Aborted');
                            DeleteCommitment.Reset;
                            //  DeleteCommitment.SetRange(DeleteCommitment."Document Type", DeleteCommitment."Document Type"::LPO);
                            DeleteCommitment.SetRange(DeleteCommitment."Document No.", Rec."No.");
                            DeleteCommitment.DeleteAll;
                        end;
                        Commitment.CheckPurchase(Rec);
                        Message('Budget Availability Checking Complete');
                    end;
                }
                action("Cancel Budget Commitment")
                {
                    Caption = 'Cancel Budget Commitment';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Category5;
                    ToolTip = 'Executes the Cancel Budget Commitment action.';
                    trigger OnAction()
                    begin
                        if not Confirm('Are you sure you want to Cancel All Commitments Done for this document', true, Rec."Document Type") then
                            Error('Budget Availability Check and Commitment Aborted');

                        DeleteCommitment.Reset;
                        DeleteCommitment.SetRange(DeleteCommitment."Document Type", DeleteCommitment."Document Type"::LPO);
                        DeleteCommitment.SetRange(DeleteCommitment."Document No.", Rec."No.");
                        DeleteCommitment.DeleteAll;
                        //Tag all the Purchase Line entries as Uncommitted
                        PurchLine.Reset;
                        PurchLine.SetRange(PurchLine."Document Type", Rec."Document Type");
                        PurchLine.SetRange(PurchLine."Document No.", Rec."No.");
                        if PurchLine.Find('-') then begin
                            repeat
                                PurchLine.Committed := false;
                                PurchLine.Modify;
                            until PurchLine.Next = 0;
                        end;

                        Message('Commitments Cancelled Successfully for Doc. No %1', Rec."No.");
                    end;
                }
            }
        }
    }

    var
        BCSetup: Record "Budgetary Control Setup";
        DeleteCommitment: Record Committment;
        PurchLine: Record "Purchase Line";
        Commitment: Codeunit "Budgetary Control";

    procedure LinesCommitmentStatus() Exists: Boolean
    var
        BCsetup: Record "Budgetary Control Setup";
        ImprestLine: Record "Purchase Line";
    begin
        if BCsetup.Get() then begin
            if not BCsetup.Mandatory then begin
                Exists := false;
                exit;
            end;
        end else begin
            Exists := false;
            exit;
        end;
        Exists := false;
        ImprestLine.Reset;
        ImprestLine.SetRange(ImprestLine."Document No.", Rec."No.");
        ImprestLine.SetRange(ImprestLine.Committed, false);
        //ImprestLineSetRange(ImprestLine."Budgetary Control A/C", true);
        if ImprestLine.Find('-') then
            Exists := true;
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

    procedure LinesExists(): Boolean
    var
        PayLines: Record "Purchase Line";
        HasLines: Boolean;
    begin
        HasLines := false;
        PayLines.Reset;
        PayLines.SetRange(PayLines."Document No.", Rec."No.");
        if PayLines.Find('-') then begin
            HasLines := true;
            exit(HasLines);
        end;
    end;
}