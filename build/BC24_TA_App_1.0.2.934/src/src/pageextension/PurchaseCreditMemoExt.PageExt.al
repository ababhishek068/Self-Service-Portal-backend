pageextension 50053 "Purchase CreditMemo Ext" extends "Purchase Credit Memo"
{
    layout
    {

        modify("Buy-from Contact No.")
        {
            Visible = false;
        }
        modify("Pay-to Contact")
        {
            Visible = false;
        }
        modify("Pay-to Contact No.")
        {
            Visible = false;
        }
        modify("Ship-to Contact")
        {
            Visible = false;
        }

        modify("Order Address Code")
        {
            Visible = false;
        }
        modify("Purchaser Code")
        {
            Visible = false;
        }
        modify("Assigned User ID")
        {
            Caption = 'User ID';
        }
        modify(Status)
        {
            Editable = true;
            trigger OnAfterValidate()
            var
                objPurchaseHeader: Record "Purchase Header";
                ApprovalEntry: Record "Approval Entry";
                RecID: RecordID;
                FromRecRef: RecordRef;
                msg: Text;
                HREmp: Record "HR-Employee";
                WebPortal: CodeUnit HRWebportal;
            begin
                if Rec.Status = Rec.Status::"Pending Approval" then begin
                    objPurchaseHeader.Reset;
                    objPurchaseHeader.SetRange(objPurchaseHeader."No.", Rec."No.");
                    if objPurchaseHeader.Find('-')
                    then begin
                        FromRecRef.GETTABLE(objPurchaseHeader);
                        RecID := FromRecRef.RecordId;
                        ApprovalEntry.Reset();
                        ApprovalEntry.SetRange("Record ID to Approve", RecID);
                        ApprovalEntry.SetFilter(Status, '=%1', ApprovalEntry.Status::Open);
                        if ApprovalEntry.FindSet(true, false) then begin
                            repeat
                                WebPortal.SendApprovalEmailAlert(Rec."No.", ApprovalEntry."Table ID", ApprovalEntry."Approver ID");
                            until ApprovalEntry.Next() = 0;
                        end;
                        HREmp.Reset();
                        HREmp.SetRange("User ID", objPurchaseHeader."Assigned User ID");
                        HREmp.SetFilter("Company E-Mail", '<>%1', '');
                        if HREmp.FindSet(true, false) then begin
                            msg := '';
                            msg := 'Dear Sir/Madam,<br /><br />';
                            msg := msg + 'Your purchase application has been submitted Successfully for approval.<br /><br />';

                            WebPortal.SendEmail(HREmp."Company E-Mail", 'Confirmation of Receipt: ' + Rec."No." + '(Purchase Number)', msg);
                        end;
                    end;
                end;
            end;
        }

        addafter("Currency Code")
        {
            field("Posting No. Series"; Rec."Posting No. Series")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Posting No. Series field.';
            }
            field("Receiving No. Series"; Rec."Receiving No. Series")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Receiving No. Series field.';
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

                LinesLocationExists;
                //Ensure No Items That should be committed that are not
                IF LinesCommitmentStatus THEN
                    ERROR('There are some lines that have not been committed');

                //Release the Imprest for Approval
                Rec.TESTFIELD(Status, Rec.Status::Open);

                //  if ApprovalsMgmt.CheckPurchaseApprovalPossible(Rec) then
                //      ApprovalsMgmt.OnSendPurchaseDocForApproval(Rec);
            end;
        }








    }

    var
        BCSetup: Record "Budgetary Control Setup";
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

    procedure ReversePRFCommittments()
    var
        PurchLines: Record "Purchase Line";
    begin

        PurchLines.Reset;
        PurchLines.SetRange(PurchLines."Document Type", Rec."Document Type");
        PurchLines.SetRange(PurchLines."Document No.", Rec."No.");

        if PurchLines.Find('-') then begin
            repeat
                Commitment.ReverseEntriesPerItem(PurchLines."Requisition No", PurchLines."No.", Rec."No.");
            until PurchLines.next = 0;
        end;
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

    procedure LinesLocationExists(): Boolean
    var
        PayLines: Record "Purchase Line";
        HasLines: Boolean;
    begin
        HasLines := false;
        PayLines.Reset;
        PayLines.SetRange(PayLines."Document No.", Rec."No.");
        PayLines.SetRange(PayLines.Type, PayLines.Type::Item);
        if PayLines.Find('-') then begin
            repeat
                PayLines.testfield("Location Code");
            until PayLines.next = 0;
        end;
    end;
}