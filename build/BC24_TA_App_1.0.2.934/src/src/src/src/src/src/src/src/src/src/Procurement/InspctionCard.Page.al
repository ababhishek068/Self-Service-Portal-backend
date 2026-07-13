namespace ABH_UAT.ABH_UAT;
using System.Automation;

page 51542 "Inspction Card"
{
    ApplicationArea = All;
    Caption = 'Inspction Card';
    PageType = Card;
    SourceTable = "Inspection Header";
    
    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                
                field(No; Rec.No)
                {
                    Editable=false;
                    ToolTip = 'Specifies the value of the No field.', Comment = '%';
                }
                field("Supplier No.";"Supplier No.")
                {
                  
                }
                field("Supplier Name"; Rec."Supplier Name")
                {
                    Editable=false;
                    ToolTip = 'Specifies the value of the Supplier Name field.', Comment = '%';
                }
                field("D Note No."; Rec."D Note No.")
                {
                    ToolTip = 'Specifies the value of the D Note No. field.', Comment = '%';
                }
                field("LPO No"; Rec."LPO No")
                {
                    ToolTip = 'Specifies the value of the LPO No field.', Comment = '%';
                }
                field("Completion/Delivery Date"; Rec."Completion/Delivery Date")
                {
                    ToolTip = 'Specifies the value of the Completion/Delivery Date field.', Comment = '%';
                }
                field("Created By"; Rec."Created By")
                {
                    Editable=false;
                    ToolTip = 'Specifies the value of the Created By field.', Comment = '%';
                }
        
                field("Date"; Rec."Date")
                {
                    Editable=false;
                    ToolTip = 'Specifies the value of the Date field.', Comment = '%';
                }
                field("Date Inspected"; Rec."Date Inspected")
                {
                    Editable=false;
                    ToolTip = 'Specifies the value of the Date Inspected field.', Comment = '%';
                }
                field("Instructions for Inspection";"Instructions for Inspection"){}
                field(Description; Rec.Description)
                {
                    Caption='Findings/Recommendation';

                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field("Inspected By"; Rec."Inspected By")
                {
                    Editable=false;
                    ToolTip = 'Specifies the value of the Inspected By field.', Comment = '%';
                }
                field("Invoice No."; Rec."Invoice No.")
                {
                    ToolTip = 'Specifies the value of the Invoice No. field.', Comment = '%';
                }
                field("LPO Date"; Rec."LPO Date")
                {
                    Editable=false;
                    ToolTip = 'Specifies the value of the LPO Date field.', Comment = '%';
                }
                
                field("No. Series"; Rec."No. Series")
                {
                    Editable=false;
                    ToolTip = 'Specifies the value of the No. Series field.', Comment = '%';
                }
                field("RFQ Date"; Rec."RFQ Date")
                {
                    Editable=false;
                    ToolTip = 'Specifies the value of the RFQ Date field.', Comment = '%';
                }
                field("RFQ No."; Rec."RFQ No.")
                {
                    Editable=false;
                    ToolTip = 'Specifies the value of the RFQ No. field.', Comment = '%';
                }
                field("Reviewed By"; Rec."Reviewed By")
                {
                    Editable=false;
                    ToolTip = 'Specifies the value of the Reviewed By field.', Comment = '%';
                }
                
                
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.', Comment = '%';
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.', Comment = '%';
                }
                field(SystemId; Rec.SystemId)
                {
                    ToolTip = 'Specifies the value of the SystemId field.', Comment = '%';
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.', Comment = '%';
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedBy field.', Comment = '%';
                }
                field("Total Value"; Rec."Total Value")
                {
                    Editable=false;
                    ToolTip = 'Specifies the value of the Total Value field.', Comment = '%';
                }
                field(inspected; Rec.inspected)
                {
                    Editable=false;
                    ToolTip = 'Specifies the value of the inspected field.', Comment = '%';
                }
            }
            part (inspectionlines; "Inspection Lines")
            {
            SubPageLink="No."=field(No),LPO=field("LPO No"),Dnote=field("D Note No.");
            }

            
        }
        
    }
    actions{
        area(Processing)
        {
            
            action(incpectitems){
                Caption='Confirm inspection of items';
                Image=InventorySetup;
                Promoted=true;
                trigger OnAction()
                var 
                ask: Boolean;
                begin
                    ask:=Confirm('Are you sure to post the inspections, please not once inspected you cannot modiy the document');
                    if ask=true then begin
                        inspected:=true;
                        "Inspected By":=UserId;
                        "Date Inspected":=Today;

                    end else if ask=false then begin

                    end;
                    

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
                    ApprovalEntry.SetRange("Document No.", Rec.No);
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
    inspectionlines: Record "Inspection Lines";
      Commitment: Codeunit "Budgetary Control";
        BCSetup: Record "Budgetary Control Setup";
        DeleteCommitment: Record "Committment";
        
        StatusEditable: Boolean;
        Pr0cumentMethodEditable: Boolean;
        
        CashOfficeSetup: Record "Cash Office Setup";
        CustomApprovals: Codeunit "Custom Approvals Codeunit";
        VarVariant: Variant;
    
}
