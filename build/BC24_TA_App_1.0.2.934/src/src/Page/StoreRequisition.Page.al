page 50887 "Store Requisition"
{
    CardPageID = "Store Requisition Header UP";
    PageType = List;
    SourceTable = "Store Requistion Header";
    UsageCategory = Lists;
    ApplicationArea = all;
    Editable = false;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("Request date"; Rec."Request date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Request date field.';
                }
                field("Required Date"; Rec."Required Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Required Date field.';
                }
                field("Requester ID"; Rec."Requester ID")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Requester ID field.';
                }
                field("Request Description"; Rec."Request Description")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Request Description field.';
                }

                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field(Supplier; Rec.Supplier)
                {
                    ApplicationArea = all;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Supplier field.';
                }
                field("Action Type"; Rec."Action Type")
                {
                    ApplicationArea = all;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Action Type field.';
                }
                field(Justification; Rec.Justification)
                {
                    ApplicationArea = all;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Justification field.';
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the User ID field.';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                }
                field("Function Name"; Rec."Function Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Function Name field.';
                }
                field("Budget Center Name"; Rec."Budget Center Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Budget Center Name field.';
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 3 Code field.';
                }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 4 Code field.';
                }
                field(Dim3; Rec.Dim3)
                {
                    ApplicationArea = all;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Dim3 field.';
                }
                field(Dim4; Rec.Dim4)
                {
                    ApplicationArea = all;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Dim4 field.';
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Responsibility Center field.';
                }
                field(TotalAmount; Rec.TotalAmount)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the TotalAmount field.';
                }
                field("Issuing Store"; Rec."Issuing Store")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Issuing Store field.';
                }
                field("Store Requisition Type"; Rec."Store Requisition Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Store Requisition Type field.';
                }
                field("Issue Date"; Rec."Issue Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Issue Date field.';
                }
                field(Committed; Rec.Committed)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Committed field.';
                }
                field("Employee No"; Rec."Employee No")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Employee No field.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Functions")
            {
                Caption = '&Functions';
                action("Post Store Requisition")
                {
                    Caption = 'Post Store Requisition';
                    Image = Post;
                    Promoted = true;
                    ToolTip = 'Executes the Post Store Requisition action.';

                    trigger OnAction()
                    begin

                        if not LinesExists then
                            Error('There are no Lines created for this Document');

                        if Rec.Status = Rec.Status::Posted then
                            Error('The Document Has Already been Posted');

                        if Rec.Status <> Rec.Status::"Pending Approval" then
                            Error('The Document Has not yet been Approved');



                        Rec.TestField("Issuing Store");
                        ReqLine.Reset;
                        ReqLine.SetRange(ReqLine."Requistion No", Rec."No.");
                        ReqLine.SetFilter(ReqLine."Quantity To Issue", '>%1', 0);
                        Rec.TestField("Issuing Store");
                        if ReqLine.Find('-') then begin
                            if InventorySetup.Get then begin
                                //  ERROR('1');
                                InventorySetup.TestField(InventorySetup."Items issue Template");
                                InventorySetup.TestField(InventorySetup."Items Issue Batch");
                                GenJnline.Reset;
                                GenJnline.SetRange(GenJnline."Journal Template Name", InventorySetup."Items issue Template");
                                GenJnline.SetRange(GenJnline."Journal Batch Name", InventorySetup."Items Issue Batch");
                                if GenJnline.Find('-') then GenJnline.DeleteAll;
                            end;
                            repeat
                            begin
                                //Issue
                                LineNo := LineNo + 1000;

                                GenJnline.Init;
                                GenJnline."Journal Template Name" := InventorySetup."Items issue Template";
                                GenJnline."Journal Batch Name" := InventorySetup."Items Issue Batch";
                                GenJnline."Line No." := LineNo;
                                GenJnline."Entry Type" := GenJnline."Entry Type"::"Negative Adjmt.";
                                GenJnline."Document No." := Rec."No.";
                                GenJnline."Item No." := ReqLine."No.";
                                GenJnline.Validate("Item No.");
                                GenJnline."Location Code" := Rec."Issuing Store";
                                GenJnline.Validate("Location Code");
                                GenJnline."Posting Date" := Rec."Request date";
                                GenJnline.Description := ReqLine.Description;
                                //GenJnline.Quantity:=ReqLine.Quantity;
                                GenJnline.Quantity := ReqLine."Quantity To Issue";
                                GenJnline."Shortcut Dimension 1 Code" := Rec."Global Dimension 1 Code";
                                GenJnline.Validate("Shortcut Dimension 1 Code");
                                GenJnline."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
                                GenJnline.Validate("Shortcut Dimension 2 Code");
                                GenJnline.ValidateShortcutDimCode(3, Rec."Shortcut Dimension 3 Code");
                                GenJnline.ValidateShortcutDimCode(4, Rec."Shortcut Dimension 4 Code");
                                GenJnline.Validate(Quantity);
                                GenJnline.Validate("Unit Amount");
                                GenJnline."Reason Code" := '221';
                                GenJnline.Validate("Reason Code");
                                GenJnline.Insert(true);

                                ReqLine."Quantity Issued" := ReqLine."Quantity Issued" + ReqLine."Quantity To Issue";
                                ReqLine."Quantity To Issue" := 0;

                                if ReqLine."Quantity Issued" = ReqLine."Quantity Requested" then
                                    ReqLine."Request Status" := ReqLine."Request Status"::Closed;
                                ReqLine.Modify;
                            end;
                            until ReqLine.Next = 0;
                            //Post Entries
                            GenJnline.Reset;
                            GenJnline.SetRange(GenJnline."Journal Template Name", InventorySetup."Items issue Template");
                            //
                            GenJnline.SetRange(GenJnline."Journal Batch Name", InventorySetup."Items Issue Batch");
                            CODEUNIT.Run(CODEUNIT::"Item Jnl.-Post", GenJnline);
                            //End Post entries

                            //Modify All

                            Post := JournlPosted.PostedSuccessfully(Rec."No.");
                            if Post then
                                ReqLine.ModifyAll(ReqLine."Request Status", ReqLine."Request Status"::Closed);

                        end;

                        Post := true;
                        ReqLine.Reset;
                        ReqLine.SetRange(ReqLine."Requistion No", Rec."No.");
                        if ReqLine.Find('-') then begin
                            repeat
                            begin
                                if ReqLine."Quantity Issued" <> ReqLine."Quantity Requested" then
                                    if (Post = true) then
                                        Post := false;
                            end;
                            until ReqLine.Next = 0;
                        end;
                        if Post = true then begin
                            Rec.Status := Rec.Status::Posted;
                            Rec.Modify;
                        end;
                        CurrPage.Update;
                    end;
                }
                separator(Separator11) { }
                action(Approvals)
                {
                    Caption = 'Approvals';
                    Image = Approvals;
                    Promoted = true;
                    ToolTip = 'Executes the Approvals action.';

                    trigger OnAction()
                    begin
                        DocumentType := DocumentType::Requisition;
                        ApprovalEntries.SetRecordFilters(DATABASE::"Store Requistion Header", DocumentType, Rec."No.");
                        ApprovalEntries.Run;
                    end;
                }
                action(sendApproval)
                {
                    Caption = 'Send A&pproval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Send A&pproval Request action.';

                    trigger OnAction()
                    var
                        State: Option Open,"Pending Approval",Cancelled,Approved;
                        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application","Staff Advance","Staff Advance Accounting";
                        tableNo: Integer;
                    begin
                        if not LinesExists then
                            Error('There are no Lines created for this Document');

                        State := State::Open;
                        if Rec.Status <> Rec.Status::Released then State := State::"Pending Approval";
                        DocType := DocType::Requisition;
                        Clear(tableNo);
                        tableNo := DATABASE::"Store Requistion Header";
                        // if ApprovalMgt.SendApproval(tableNo, Rec."No.", DocType, State, '', "Responsibility Center") then;
                    end;
                }
                action(cancellsApproval)
                {
                    Caption = 'Cancel Approval Re&quest';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Cancel Approval Re&quest action.';

                    trigger OnAction()
                    var
                        // ApprovalMgt: Codeunit "Approvals Management";
                        showmessage: Boolean;
                        ManualCancel: Boolean;
                        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application","Staff Advance","Staff Advance Accounting";
                        tableNo: Integer;
                    begin
                        DocType := DocType::Requisition;
                        showmessage := true;
                        ManualCancel := true;
                        Clear(tableNo);
                        tableNo := DATABASE::"Store Requistion Header";
                        // if ApprovalMgt.CancelApproval(tableNo, DocType, Rec."No.", showmessage, ManualCancel) then;
                    end;
                }
                separator(Separator7) { }
                action("Check Budget Availlabilty")
                {
                    Caption = 'Check Budget Availlabilty';
                    Image = Check;
                    Promoted = true;
                    ToolTip = 'Executes the Check Budget Availlabilty action.';

                    trigger OnAction()
                    begin
                        BCSetup.Get;
                        if not BCSetup.Mandatory then
                            exit;
                        if (Rec."Issuing Store" <> 'CENTRAL') and (Rec."Issuing Store" <> 'GENERAL') then
                            Error('This function is only applicable to Central Stores')
;
                        //IF Status=Status::Released THEN
                        //  ERROR('This document has already been released. This functionality is available for open documents only');
                        //IF NOT SomeLinesCommitted THEN BEGIN
                        //   IF NOT CONFIRM( 'Some or All the Lines Are already Committed do you want to continue',TRUE, "Document Type") THEN
                        //        ERROR('Budget Availability Check and Commitment Aborted');
                        DeleteCommitment.Reset;
                        DeleteCommitment.SetRange(DeleteCommitment."Document Type", DeleteCommitment."Document Type"::Requisition);
                        DeleteCommitment.SetRange(DeleteCommitment."Document No.", Rec."No.");
                        DeleteCommitment.DeleteAll;
                        //END;

                        //IF "Requisition Type"="Requisition Type"::Stationery THEN

                        // Commitment.CheckStaffClaim(Rec)
                        //ELSE
                        // ERROR('Please note that only Stationery Items are voted');

                        Rec.Committed := true;
                        Rec.Modify;
                        Message('Budget Availability Checking Complete');
                    end;
                }
                separator(Separator5) { }
                action("Cancel Budget Commitments")
                {
                    Caption = 'Cancel Budget Commitments';
                    Image = CancelLine;
                    Promoted = true;
                    ToolTip = 'Executes the Cancel Budget Commitments action.';

                    trigger OnAction()
                    begin
                        Rec.TestField(Committed);
                        if not Confirm('Are you sure you want to Cancel All Commitments Done for this document', true) then
                            Error('Budget Availability Check and Commitment Aborted');

                        DeleteCommitment.Reset;
                        DeleteCommitment.SetRange(DeleteCommitment."Document Type", DeleteCommitment."Document Type"::Requisition);
                        DeleteCommitment.SetRange(DeleteCommitment."Document No.", Rec."No.");
                        DeleteCommitment.DeleteAll;
                        //Tag all the SRN entries as Uncommitted
                        Rec.Committed := false;
                        Rec.Modify;
                        Message('Commitments Cancelled Successfully for Doc. No %1', Rec."No.");
                    end;
                }
                separator(Separator3) { }
                action("Print/Preview")
                {
                    Caption = 'Print/Preview';
                    Image = PreviewChecks;
                    Promoted = true;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Print/Preview action.';

                    trigger OnAction()
                    var
                        SRN: report "Store Requisition";
                        SRNRec: Record "Store Requistion Header";
                    begin
                        SRNRec.Reset;
                        SRNRec.SetFilter(SRNRec."No.", Rec."No.");
                        if SRNRec.Find('-') then begin
                            SRN.SetTableView(SRNRec);
                            SRN.run();
                        end;
                        // REPORT.Run(70135450, true, true, SRNRec);
                    end;
                }
                separator(Separator1) { }
            }
        }
    }

    trigger OnOpenPage()
    begin
        //SETFILTER("User ID",USERID);
    end;

    var
        //  ApprovalMgt: Codeunit "Approvals Management";
        ReqLine: Record "Store Requistion Lines";
        InventorySetup: Record "Cash Office Setup";
        GenJnline: Record "Item Journal Line";
        LineNo: Integer;
        Post: Boolean;
        JournlPosted: Codeunit "Journal Post Successful";
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition;
        HasLines: Boolean;
        BCSetup: Record "Budgetary Control Setup";
        DeleteCommitment: Record Committment;
        ApprovalEntries: Page "Approval Entries";

    procedure LinesExists(): Boolean
    var
        PayLines: Record "Store Requistion Lines";
    begin
        HasLines := false;
        PayLines.Reset;
        PayLines.SetRange(PayLines."Requistion No", Rec."No.");
        if PayLines.Find('-') then begin
            HasLines := true;
            exit(HasLines);
        end;
    end;

    procedure UpdateControls()
    begin

        /* IF Status<>Status::Released THEN BEGIN
         CurrForm."Issue Date".EDITABLE:=FALSE;
         CurrForm.UPDATECONTROLS();
             END ELSE BEGIN
         CurrForm."Issue Date".EDITABLE:=TRUE;
         CurrForm.UPDATECONTROLS();
         END;
            IF Status=Status::Open THEN BEGIN
         CurrForm."Global Dimension 1 Code".EDITABLE:=TRUE;
         CurrForm."Request date" .EDITABLE:=TRUE;
         CurrForm."Responsibility Center" .EDITABLE:=TRUE;
         CurrForm."Issuing Store" .EDITABLE:=TRUE;
         CurrForm."Request Description".EDITABLE:=TRUE;
         CurrForm."Shortcut Dimension 2 Code".EDITABLE:=TRUE;
         CurrForm."Request Description".EDITABLE:=TRUE;
         CurrForm."Shortcut Dimension 3 Code".EDITABLE:=TRUE;
         CurrForm."Shortcut Dimension 4 Code".EDITABLE:=TRUE;
         CurrForm."Required Date".EDITABLE:=TRUE;
         CurrForm.UPDATECONTROLS();
         END ELSE BEGIN
         CurrForm."Responsibility Center".EDITABLE:=FALSE;
         CurrForm."Global Dimension 1 Code".EDITABLE:=FALSE;
         CurrForm."Request Description".EDITABLE:=FALSE;
         CurrForm."Shortcut Dimension 2 Code".EDITABLE:=FALSE;
         CurrForm."Required Date".EDITABLE:=FALSE;
         CurrForm."Shortcut Dimension 3 Code".EDITABLE:=FALSE;
         CurrForm."Shortcut Dimension 4 Code".EDITABLE:=FALSE;
         CurrForm."Required Date".EDITABLE:=FALSE;
          CurrForm."Request date".EDITABLE:=FALSE;
         CurrForm.UPDATECONTROLS();
         END
         */

    end;

    trigger OnAfterGetCurrRecord()

    begin
        xRec := Rec;
        UpdateControls();
    end;
}

