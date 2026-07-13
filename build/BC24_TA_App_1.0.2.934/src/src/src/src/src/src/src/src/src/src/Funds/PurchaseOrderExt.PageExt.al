pageextension 50021 "Purchase Order Ext" extends "Purchase Order"
{
    layout
    {
        modify("Order Date")
        {
            Visible = false;
        }
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
        modify("Vendor Order No.")
        {
            Visible = false;
        }
        modify("Vendor Shipment No.")
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
            // trigger OnAfterValidate()
            // var
            //     objPurchaseHeader: Record "Purchase Header";
            //     ApprovalEntry: Record "Approval Entry";
            //     RecID: RecordID;
            //     FromRecRef: RecordRef;
            //     msg: Text;
            //     HREmp: Record "HR-Employee";
            //     WebPortal: CodeUnit HRWebportal;
            // begin
            //     if Status = Status::"Pending Approval" then begin
            //         objPurchaseHeader.Reset;
            //         objPurchaseHeader.SetRange(objPurchaseHeader."No.", "No.");
            //         if objPurchaseHeader.Find('-') then begin
            //             FromRecRef.GETTABLE(objPurchaseHeader);
            //             RecID := FromRecRef.RecordId;
            //             ApprovalEntry.Reset();
            //             ApprovalEntry.SetRange("Record ID to Approve", RecID);
            //             ApprovalEntry.SetFilter(Status, '=%1', ApprovalEntry.Status::Open);
            //             if ApprovalEntry.FindSet(true, false) then begin
            //                 repeat
            //                     WebPortal.SendApprovalEmailAlert("No.", ApprovalEntry."Table ID", ApprovalEntry."Approver ID");
            //                 until ApprovalEntry.Next() = 0;
            //             end;
            //             HREmp.Reset();
            //             HREmp.SetRange("User ID", objPurchaseHeader."Assigned User ID");
            //             HREmp.SetFilter("Company E-Mail", '<>%1', '');
            //             if HREmp.FindSet(true, false) then begin
            //                 msg := '';
            //                 msg := 'Dear Sir/Madam,<br /><br />';
            //                 msg := msg + 'Your purchase application has been submitted Successfully for approval.<br /><br />';

            //                 WebPortal.SendEmail(HREmp."Company E-Mail", 'Confirmation of Receipt: ' + "No." + '(Purchase Number)', msg);
            //             end;
            //         end;
            //     end;
            // end;
        }
        addafter("Order Date")
        {
            field("Purchase Requisition No."; Rec."Purchase Requisition No.")
            {
                ApplicationArea = basic;
                Editable = true;
                Visible = true;
                ToolTip = 'Specifies the value of the Purchase Requisition No. field.';
            }

            field("RFQ No."; Rec."RFQ No.")
            {
                Caption = 'RFQ No.';
                ApplicationArea = basic;
                Visible = true;
                ToolTip = 'Specifies the value of the Request for Quotation No. field.';
                //Editable = false;
            }
            field("Contract No."; Rec."Contract No.")
            {
                Caption = 'Contract No.';
                ApplicationArea = basic;
                Visible = false;
                ToolTip = 'Specifies the value of the Contract No. field.';

            }
            field("Tendor Number"; Rec."Tendor Number")
            {
                Caption = 'Tender Number';
                ApplicationArea = basic;
                Visible = false;
                ToolTip = 'Specifies the value of the Tender Number field.';
            }
            field(Type; Rec.Type)
            {
                Caption = 'Order Type';
                ApplicationArea = basic;
                Visible = false;
                ToolTip = 'Specifies the value of the Order Type field.';

            }
            field("Repair No"; Rec."Repair No")
            {
                ApplicationArea = basic;
                Visible = false;
                ToolTip = 'Specifies the value of the Repair No field.';
            }
            field("Posting Description1"; Rec."Posting Description")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies additional posting information for the document. After you post the document, the description can add detail to vendor and customer ledger entries.';

            }
            field("Vessel No"; Rec."Vessel No")
            {
                ApplicationArea = basic;
                Visible = false;
                ToolTip = 'Specifies the value of the Vessel No field.';

            }
            field("Lading Date"; Rec."Lading Date")
            {
                Caption = 'LD Date';
                ApplicationArea = basic;
                Visible = false;
                ToolTip = 'Specifies the value of the LD Date field.';

            }
            field("Procurement Method Code"; Rec."Procurement Method Code")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the value of the Procurement Method Code field.';
            }
            field("Assigned Procurement Officer"; Rec."Assigned Procurement Officer")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the value of the Assigned Procurement Officer field.';
            }
            field("Requisition No."; Rec."Requisition No.")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the value of the Requisition No. field.';
            }
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
        addafter("Responsibility Center")
        {
            field("Reason For Termination"; Rec."Reason For Termination")
            {
                ApplicationArea = basic;
                Visible = false;
                ToolTip = 'Specifies the value of the Reason For Termination field.';
            }
            field("Date of Termination"; Rec."Date of Termination")
            {
                ApplicationArea = basic;
                Visible = false;
                Enabled = false;
                ToolTip = 'Specifies the value of the Date of Termination field.';
            }
            field("Terminated By"; Rec."Terminated By")
            {
                ApplicationArea = basic;
                Enabled = false;
                Visible = false;
                ToolTip = 'Specifies the value of the Terminated By field.';
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
        modify(Approvals)
        {

            Promoted = true;
            PromotedCategory = Category4;
            PromotedIsBig = true;
            ApplicationArea = Basic;
            trigger OnAfterAction()
            var
                AppEntry: Record "Approval Entry";
                AppEntryPage: page "Approval Entries2";
            begin
                AppEntry.reset;
                AppEntry.setrange("Document No.", Rec."No.");
                if AppEntry.find('-') then begin
                    AppEntryPage.SetTableView(AppEntry);
                    AppEntryPage.Run();
                end;
            end;

        }

        modify(Print)
        {
            Visible = false;
        }
        /*  modify(Release)
         {
             trigger OnBeforeAction()
             var
                 UserSetup: Record "User Setup";
             begin
                 UserSetup.Reset();
                 UserSetup.SetRange("User ID", Database.UserId);
                 UserSetup.SetRange("Can Release Open PO", true);
                 if not UserSetup.Find('-') then Error('You have no rights to release an open document');
             end ELSE 
             BEGIN

             END;
         } */
         modify(Post){
            trigger OnBeforeAction()
            var
            postrecipts: Record "Purch. Rcpt. Header";
            begin
                //TestField("Vendor Shipment No.");
                //checifanylines to post
                //check if dnote used before
                    

                PurchLine.Reset();
                PurchLine.SetRange(PurchLine."Document No.",Rec."No.");
                if PurchLine.find('-') then begin
                    repeat
                    if (PurchLine.Type=PurchLine.Type::"Fixed Asset") or (PurchLine.Type=PurchLine.Type::Item) then begin
                      if PurchLine."Qty. to Receive"<>0 then begin
                        TestField(Rec."Vendor Shipment No."); 
                        //Message("Vendor Shipment No.");    
                                 //test if inspected.
                                  postrecipts.Reset();
                     postrecipts.SetRange(postrecipts."Buy-from Vendor No.",rec."Buy-from Vendor No.");
                     postrecipts.SetRange(postrecipts."Vendor Shipment No.",rec."Vendor Shipment No.");
                     if postrecipts.FindFirst() then begin
                        Error('You cannot use the vendor shipment no twice');
                     end;
                       
                    //check if inspected
                    inspectionheader.Reset();
                    inspectionheader.SetRange(inspectionheader."Supplier No.",rec."Pay-to Vendor No.");
                    inspectionheader.SetRange(inspectionheader."LPO No",rec."No.");
                    inspectionheader.SetRange(inspectionheader."D Note No.","Vendor Shipment No.");
                    inspectionheader.SetRange(inspectionheader.inspected,true);
                    if inspectionheader.Find('-') then begin
                        //Message("Vendor Shipment No.");
                        inspectionlines.Reset();
                        inspectionlines.SetRange(inspectionlines."No.",inspectionheader.No);
                        inspectionlines.SetRange(inspectionlines."Item No.",PurchLine."No.");
                        inspectionlines.SetRange(inspectionlines.Dnote,Rec."Vendor Shipment No.");
                        inspectionlines.SetRange(inspectionlines.LPO,"No.");
                        if inspectionlines.FindFirst() then begin

                            if inspectionlines."Quantity Passed Inspection"<>0 then begin
                               if inspectionlines."Quantity Passed Inspection"<PurchLine."Qty. to Receive" then begin
                                //Message(PurchLine.Description+ 'Inspected is less than Qty ro receive, qty to receive will be modified');
                                PurchLine."Qty. to Receive":=inspectionlines."Quantity Passed Inspection";
                                PurchLine.Validate("Qty. to Receive");
                                PurchLine.Modify;

                               end else begin

                               end;


                            end else if inspectionlines."Quantity Passed Inspection"=0 then begin
                             //Message(PurchLine.Description+ 'did not pass inspection and quantity to receive will be reset to zero');
                             PurchLine."Qty. to Receive":=0;
                             purchline.Validate("Qty. to Receive");
                             PurchLine.Modify;


                            end
                        end;


                    end else begin
                        Error('Items have not passed inspection yet');

                    end;
                    
                      end;

                    end


                    until PurchLine.Next=0;
                end;



            end;
            
         }
        addafter(Print)
        {
            action(Print2)
            {
                Caption = 'Print LPO';
                ApplicationArea = basic;
                Image = Print;
                ToolTip = 'Executes the Print LPO action.';
                trigger OnAction()
                var
                    Purch: Record "Purchase Header";
                    LPO: report "LPO Report";
                    PurchSetup: Record "Purchases & Payables Setup";
                begin
                    PurchSetup.Get();
                    if PurchSetup."Disable printing of open LPO" then begin
                        Rec.TestField(Status, Rec.Status::Released);
                    end;
                    Purch.reset;
                    purch.setfilter(Purch."No.", Rec."No.");
                    if Purch.find('-') then begin
                        LPO.SetTableView(Purch);
                        LPO.Run();
                    end;


                end;
            }
            action(Print3)
            {
                Caption = 'Print LSO';
                ApplicationArea = basic;
                Image = Print;
                ToolTip = 'Executes the Print LSO action.';
                trigger OnAction()
                var
                    Purch: Record "Purchase Header";
                    LPO: report "LSO Report";
                    PurchSetup: Record "Purchases & Payables Setup";
                begin
                    PurchSetup.Get();
                    if PurchSetup."Disable printing of open LPO" then begin
                        Rec.TestField(Status, Rec.Status::Released);
                    end;
                    Purch.reset;
                    purch.setfilter(Purch."No.", Rec."No.");
                    if Purch.find('-') then begin
                        LPO.SetTableView(Purch);
                        LPO.Run();
                    end;


                end;
            }
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

            action(IAC)
            {
                Caption = 'Select IAC Members';
                ApplicationArea = basic;
                Image = Print;
                RunObject = page "IAC List";
                RunPageLink = "LPO Number" = FIELD("No.");
                ToolTip = 'Executes the Select IAC Members action.';
            }


            action(Print14)
            {
                Caption = 'Print Inspection Certificate';
                ApplicationArea = basic;
                Image = Print;
                ToolTip = 'Executes the Print Inspection Certificate action.';
                trigger OnAction()
                var
                    Purch: Record "Purchase Header";
                    LPO: report "IAC Form";
                begin
                    Purch.reset;
                    purch.setfilter(Purch."No.", Rec."No.");
                    if Purch.find('-') then begin
                        LPO.SetTableView(Purch);
                        LPO.Run();
                    end;


                end;
            }
        }
        addafter(AttachAsPDF)
        {
            action(PrintIAC)
            {
                Caption = 'Print Inspection & Acceptance';
                ApplicationArea = basic;
                Image = Print;
                ToolTip = 'Executes the Print Inspection & Acceptance action.';

                trigger OnAction()
                var
                    Purch: Record "Purchase Header";
                    Inspect: report "Inspection Report";
                begin
                    Purch.reset;
                    purch.setfilter(Purch."No.", Rec."No.");
                    if Purch.find('-') then begin
                        Inspect.SetTableView(Purch);
                        Inspect.Run();
                    end
                end;

            }
        }
        addafter("Request Approval")
        {
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
                            //  if not Confirm('Some or All the Lines Are already Committed do you want to continue', true, "Document Type") then
                            //    Error('Budget Availability Check and Commitment Aborted');
                            DeleteCommitment.Reset;
                            //  DeleteCommitment.SetRange(DeleteCommitment."Document Type", DeleteCommitment."Document Type"::LPO);
                            DeleteCommitment.SetRange(DeleteCommitment."Document No.", Rec."No.");
                            if DeleteCommitment.Find('-') then
                                DeleteCommitment.DeleteAll;
                        end;
                        Commitment.ReverseEntries(0, Rec."No.");
                        ReversePRFCommittments();
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
                        if not Confirm('Are syou sure you want to Cancel All Commitments Done for this document', true, Rec."Document Type") then
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
        inspectionheader: Record "Inspection Header";
        inspectionlines: Record "Inspection Lines";

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