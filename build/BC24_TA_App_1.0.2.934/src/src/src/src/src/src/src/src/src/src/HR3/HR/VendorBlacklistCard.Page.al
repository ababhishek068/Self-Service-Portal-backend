namespace ABH_UAT.ABH_UAT;
using System.Automation;
using Microsoft.Purchases.Vendor;

page 51563 "Vendor Blacklist Card"
{
    ApplicationArea = All;
    Caption = 'Vendor Blacklist Card';
    PageType = Card;
    SourceTable = BlacklistVendor;
    
    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                
                field("Blacklist Code"; Rec."Blacklist Code")
                {
                    ToolTip = 'Specifies the value of the Blacklist Code field.', Comment = '%';
                }
                field("Vendor Code"; Rec."Vendor Code")
                {
                    ToolTip = 'Specifies the value of the Vendor Code field.', Comment = '%';
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ToolTip = 'Specifies the value of the Vendor Name field.', Comment = '%';
                }
                field("Contract No"; Rec."Contract No")
                {
                    ToolTip = 'Specifies the value of the Contract No field.', Comment = '%';
                }
                field("Contract Name"; Rec."Contract Name")
                {
                    ToolTip = 'Specifies the value of the Contract Name field.', Comment = '%';
                }
                field("Contract Start Date"; Rec."Contract Start Date")
                {
                    ToolTip = 'Specifies the value of the Contract Start Date field.', Comment = '%';
                }
                field("Contract Period"; Rec."Contract Period")
                {
                    ToolTip = 'Specifies the value of the Contract Period field.', Comment = '%';
                }
                field("Contract End date"; Rec."Contract End date")
                {
                    ToolTip = 'Specifies the value of the Contract End date field.', Comment = '%';
                }
                field("Contract Value"; Rec."Contract Value")
                {
                    ToolTip = 'Specifies the value of the Contract Value field.', Comment = '%';
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    ToolTip = 'Specifies the value of the Reason Code field.', Comment = '%';
                }
                field("Summary Reason for Blaclist"; Rec."Summary Reason for Blaclist")
                {
                    ToolTip = 'Specifies the value of the Summary Reason for Blaclist field.', Comment = '%';
                }
                field("Blacklisting Start Date"; Rec."Blacklisting Start Date")
                {
                    ToolTip = 'Specifies the value of the Blacklisting Start Date field.', Comment = '%';
                }
                field("Blacklist Period"; Rec."Blacklist Period")
                {
                    ToolTip = 'Specifies the value of the Blacklist Period field.', Comment = '%';
                }
                field("Blacklisting End Date"; Rec."Blacklisting End Date")
                {
                    ToolTip = 'Specifies the value of the Blacklisting End Date field.', Comment = '%';
                }
                field("Vendor Response";"Vendor Response"){}
                field("Vendor Response Date";"Vendor Response Date"){}
                field("Vendor Response Ref No";"Vendor Response Ref No"){}
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
                field("Created By"; Rec."Created By")
                {
                    ToolTip = 'Specifies the value of the Created By field.', Comment = '%';
                }
                field("Date Created"; Rec."Date Created")
                {
                    ToolTip = 'Specifies the value of the Date Created field.', Comment = '%';
                }
                field("Time Created"; Rec."Time Created")
                {
                    ToolTip = 'Specifies the value of the Time Created field.', Comment = '%';
                }
                field("Date Approved"; Rec."Date Approved")
                {
                    ToolTip = 'Specifies the value of the Date Approved field.', Comment = '%';
                }
            }
        }
        area(factboxes)
        {
            part("Attacheddocs"; "Document Attachments")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(Database::BlacklistVendor),
                              "No." = FIELD("Blacklist Code");
            }
        }
    }
    actions{
        area(Processing){
            action(balckilst)
            {
                ApplicationArea=basic;
                Caption='Blacklist';
                Image=Report;
                Promoted=true;
                trigger OnAction()
                var 
                ven: Record Vendor;
                blaclist: Record BlacklistVendor;
                begin
                    TestField(Status,Status::Approved);
                    TestField("Reason Code");
                    TestField("Vendor Code");
                    TestField("Blacklist Code");
                    TestField("Blacklisting Start Date");
                    TestField("Blacklist Period");
                    TestField("Contract No");
                    ven.Reset();
                    ven.SetRange(ven."No.",rec."Vendor Code");
                    if ven.FindFirst() then begin
                        ven."Blacklisted?":=true;
                        ven."Blaclisting Start Date":=rec."Blacklisting Start Date";
                        ven."Blacklisting Period":=rec."Blacklist Period";
                        ven.Validate("Blacklisting Period");
                        ven.Modify();
                        Message('Successully blaclisted');

                    end;

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
                    blacklist: record BlacklistVendor;
                    repVend: Report "Vendor Blacklist";
                begin
                    blacklist.SetRecFilter;                    
                    blacklist.SetFilter("Blacklist Code", Rec."Blacklist Code");
                    blacklist.SetRange(blacklist."Vendor Code",rec."Vendor Code");
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
                    ApprovalEntry.SetRange("Document No.", Rec."Blacklist Code");
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
