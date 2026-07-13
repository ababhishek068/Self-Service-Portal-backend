namespace ABH_UAT.ABH_UAT;

page 51494 "Consolidated Budget"
{
    ApplicationArea = All;
    Caption = 'Consolidated Budget Summary';
    PageType = Card;
    SourceTable = "Consolidated Budget";
    
    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                
                field(Budget; Rec.Budget)
                {
                    ToolTip = 'Specifies the value of the Budget Number field.', Comment = '%';
                }
                field("Financial Year"; Rec."Financial Year")
                {
                    ToolTip = 'Specifies the value of the Financial Year field.', Comment = '%';
                }
            }
            part(BudgetLines; "Individualised Budget")
             //part(BudgetLines; "Purchase Requisition Subform")
            {
                Editable = true;
                SubPageLink = "Budget No" = field(Budget);
            }
        }
        area(FactBoxes)
        {
            part(docattachments;"Document Attachments")
            {
                ApplicationArea=all;
                Caption='Attachments';
                SubPageLink="Table ID"=const(Database::"Consolidated Budget"),"No."=field(Budget);
            }
        }
        
    }
    actions{
        area(Processing)
        {

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
                    blacklist: record "vehicle transfer";
                    //repVend: Report "inventory and Spares";
                begin
                    // blacklist.SetRecFilter;                    
                    // blacklist.SetFilter(transfer, Rec."Issue No");
                    // blacklist.SetRange(blacklist."Plate No",rec."Plate No");
                    // repVend.SetTableView(blacklist);
                    // repVend.Run;
                    //Error('Under implementation');
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
                    //ApprovalEntry: Record approval
                begin
                    // ApprovalEntry.Reset();
                    // ApprovalEntry.SetRange("Document No.", Rec."Issue No");
                    // if ApprovalEntry.Find('-') then begin
                    //     PAGE.RunModal(PAGE::"Approval Entries List", ApprovalEntry);
                    // end;
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
                
                Image = SendApprovalRequest;
                Promoted = true;

                ApplicationArea = all;
                PromotedCategory = Category4;
                Caption = 'Send A&pproval Request';
                ToolTip = 'Executes the Send A&pproval Request action.';
                trigger OnAction()

                begin
                    // checkqty(Rec);
                    // if not LinesExists then
                    //     Error('There are no Lines created for this Document');
                    
                        

                    

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
    var
    CustomApprovals: Codeunit "Custom Approvals Codeunit";
    VarVariant: Variant;
    BudgetLines: Record "Individualized Budgets";
    
}



    

 
   