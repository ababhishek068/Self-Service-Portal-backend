namespace ABH_UAT.ABH_UAT;
using System.Automation;

page 51565 "Inventorytools handover"
{
    ApplicationArea = All;
    Caption = 'Inventorytools handover';
    PageType = card;
    SourceTable = "Inventory Spares Handover";
    UsageCategory = Documents;   
    
    
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'Inventory Handover Card';
                field("Issue No"; Rec."Issue No")
                {
                    ToolTip = 'Specifies the value of the Issue No field.', Comment = '%';
                }
                field("Vehicle No"; Rec."Vehicle No")
                {
                    ToolTip = 'Specifies the value of the Vehicle No field.', Comment = '%';
                }
                field("Plate No"; Rec."Plate No")
                {
                    ToolTip = 'Specifies the value of the Plate No field.', Comment = '%';
                }
                field("Chassis No";"Chassis No"){}
                field(Model; Rec.Model)
                {
                    ToolTip = 'Specifies the value of the Model field.', Comment = '%';
                }
                
                field(Colour;Colour){}
                field("Loading Capacity ";"Loading Capacity "){}
                field("Numbers of Cylinders ";"Numbers of Cylinders "){}
                field("Type of fuel"; Rec."Type of fuel")
                {
                    ToolTip = 'Specifies the value of the Type of fuel field.', Comment = '%';
                }
                field("Issued To"; Rec."Issued To")
                {
                    ToolTip = 'Specifies the value of the Issued To field.', Comment = '%';
                }
                field("Issue Date"; Rec."Issue Date")
                {
                    ToolTip = 'Specifies the value of the Issue Date field.', Comment = '%';
                }
                

            }
            part(accessories;"Spares and Tools List")
            {
                Caption='Spares and Tools and Accessories List';
                SubPageLink="Chassis No"=field("Chassis No"),"Plate No"=field("Plate No"),"Issue No"=field("Issue No");
            }
        }
         area(factboxes)
        {
            part("Attacheddocs"; "Document Attachments")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(Database::"Inventory Spares Handover"),
                              "No." = FIELD("Issue No");
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
                    blacklist: record "Inventory Spares Handover";
                    repVend: Report "inventory and Spares";
                begin
                    blacklist.SetRecFilter;                    
                    blacklist.SetFilter("Issue No", Rec."Issue No");
                    blacklist.SetRange(blacklist."Plate No",rec."Plate No");
                    repVend.SetTableView(blacklist);
                    repVend.Run;
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
                    ApprovalEntry: Record "Approval Entry";
                begin
                    ApprovalEntry.Reset();
                    ApprovalEntry.SetRange("Document No.", Rec."Issue No");
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

