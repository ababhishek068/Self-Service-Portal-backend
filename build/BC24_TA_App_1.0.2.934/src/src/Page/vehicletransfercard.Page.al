namespace ABH_UAT.ABH_UAT;

page 51569 "vehicle transfer card."
{
    ApplicationArea = All;
    Caption = 'vehicle transfer card';
    PageType = Card;
    SourceTable = "Vehicle Transfer";
    
    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("Transfer No"; Rec."Transfer No")
                {
                    ToolTip = 'Specifies the value of the Transfer No field.', Comment = '%';
                }
                
                field("Vehicle No";"Vehicle No"){}
                field("Asset Value"; Rec."Asset Value")
                {
                    ToolTip = 'Specifies the value of the Asset Value field.', Comment = '%';
                }
                field("Chassis No"; Rec."Chassis No")
                {
                    ToolTip = 'Specifies the value of the Chassis No field.', Comment = '%';
                }
                field(Colour; Rec.Colour)
                {
                    ToolTip = 'Specifies the value of the Colour field.', Comment = '%';
                }
                field(Condition; Rec.Condition)
                {
                    ToolTip = 'Specifies the value of the Condition field.', Comment = '%';
                }
                field("Engine No"; Rec."Engine No")
                {
                    ToolTip = 'Specifies the value of the Engine No field.', Comment = '%';
                }                
                field("Loading Capacity "; Rec."Loading Capacity ")
                {
                    ToolTip = 'Specifies the value of the Loading Capacity field.', Comment = '%';
                }
                field(Model; Rec.Model)
                {
                    ToolTip = 'Specifies the value of the Model field.', Comment = '%';
                }
                field("Numbers of Cylinders "; Rec."Numbers of Cylinders ")
                {
                    ToolTip = 'Specifies the value of the Numbers of Cylinders field.', Comment = '%';
                }
                field("Plate No"; Rec."Plate No")
                {
                    ToolTip = 'Specifies the value of the Plate No field.', Comment = '%';
                }
                field("Type of fuel"; Rec."Type of fuel")
                {
                    ToolTip = 'Specifies the value of the Type of fuel field.', Comment = '%';
                }
                
                field("Year of Manufacture"; Rec."Year of Manufacture")
                {
                    ToolTip = 'Specifies the value of the Year of Manufacture field.', Comment = '%';
                }
                field("Reason for Transfer"; Rec."Reason for Transfer")
                {
                    ToolTip = 'Specifies the value of the Reason for Transfer field.', Comment = '%';
                }
                
                
                field("Transfer Date"; Rec."Transfer Date")
                {
                    ToolTip = 'Specifies the value of the Transfer Date field.', Comment = '%';
                }
                
                field("Transfered To"; Rec."Transfered To")
                {
                    ToolTip = 'Specifies the value of the Transfered To field.', Comment = '%';
                }
                field("Transfered To Location"; Rec."Transfered To Location")
                {
                    ToolTip = 'Specifies the value of the Transfered To Location field.', Comment = '%';
                }
                field("Transfered by"; Rec."Transfered by")
                {
                    ToolTip = 'Specifies the value of the Transfered by field.', Comment = '%';
                }
                field("Transfred From Location"; Rec."Transfred From Location")
                {
                    ToolTip = 'Specifies the value of the Transfred From Location field.', Comment = '%';
                }
                
            
        }
        part(accessorylist;"Asset Accessory List")
        {
            SubPageLink="Asset No"=field("Vehicle No"),"Tag No"=field("Plate No");
        }

        }
        area(FactBoxes)
        {
            part(docattachments;"Document Attachments")
            {
                ApplicationArea=all;
                Caption='Attachments';
                SubPageLink="Table ID"=const(Database::"Vehicle Transfer"),"No."=field("Transfer No");
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
    
}


