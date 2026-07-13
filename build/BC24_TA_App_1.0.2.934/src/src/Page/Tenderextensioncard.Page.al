namespace ABH_UAT.ABH_UAT;
using System.Automation;

page 51549 "Tender extension card"
{
    ApplicationArea = All;
    Caption = 'Tender extension card';
    PageType = Card;
    SourceTable = "Tender Extension";
    
    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                
                field("Req No"; Rec."Req No")
                {
                    ToolTip = 'Specifies the value of the Req No field.', Comment = '%';
                }
                field("Tender Type";"Tender Type"){}
                field("Tender No"; Rec."Tender No")
                {
                    ToolTip = 'Specifies the value of the Tender No field.', Comment = '%';
                }
                field("Tender Name"; Rec."Tender Name")
                {
                    ToolTip = 'Specifies the value of the Tender Name field.', Comment = '%';
                }
                field("Original Closing Date";"Original Closing Date"){}
                field("Original Opening date"; Rec."Original Opening date")
                {
                    ToolTip = 'Specifies the value of the Original Opening date field.', Comment = '%';
                }
                field("Proposed Closing Date";"Proposed Closing Date"){}
                field("Proposed Opening Date"; Rec."Proposed Opening Date")
                {
                    ToolTip = 'Specifies the value of the Proposed Opening Date field.', Comment = '%';
                }
                field(Reason; Rec.Reason)
                {
                    ToolTip = 'Specifies the value of the Reason field.', Comment = '%';
                }
                field(Justification; Rec.Justification)
                {
                    ToolTip = 'Specifies the value of the Justification field.', Comment = '%';
                }
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
                field("Approved By"; Rec."Approved By")
                {
                    ToolTip = 'Specifies the value of the Approved By field.', Comment = '%';
                }
                field("Date Approved"; Rec."Date Approved")
                {
                    ToolTip = 'Specifies the value of the Date Approved field.', Comment = '%';
                }
                
            }
            
        }
        area(FactBoxes)
        {
            
        
            part("Attached Documents"; "Document Attachments")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(38),
                              "No." = FIELD("Req No");
            }
        
        }
        
    }
    actions
    {
        area(Processing){
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
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    RecID: RecordID;
                    FromRecRef: RecordRef;
                    DocDetails: Record "Purchase Quote Header";
                begin
                    DocDetails.Reset();
                    DocDetails.SetRange("No.", Rec."Req No");
                    if DocDetails.Find('-') then begin
                        FromRecRef.GETTABLE(DocDetails);
                        RecID := FromRecRef.RecordId;
                        ApprovalsMgmt.OpenApprovalEntriesPage(RecID);
                    end;
                end;
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
                    if not LinesExists then
                        Error('There are no Lines created for this Document');

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
        VarVariant: Variant;
        CustomApprovals: Codeunit "Custom Approvals Codeunit";

        PurchaseQuoteLine: Record "Purchase Quote Line";

    procedure LinesExists(): Boolean
    var
        HasLines: Boolean;
    begin
        HasLines := false;
        PurchaseQuoteLine.Reset;
        PurchaseQuoteLine.SetRange(PurchaseQuoteLine."Document No.", Rec."Req No");
        if PurchaseQuoteLine.FindFirst() then begin
            HasLines := true;
            exit(HasLines);
        end;
    end;
    
    
}


