Page 50783 "File Requisition"
{
    PageType = Card;
    SourceTable = "File Requisition";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(No; Rec.No)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No field.';
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field(RequestingOfficer; Rec."Requesting Officer")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Requesting Officer field.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field(Designation; Rec.Designation)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Designation field.';
                }
                field(CollectingOfficer; Rec."Collecting Officer")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Collecting Officer field.';
                }
                field(Purpose; Rec.Purpose)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Purpose field.';
                }
                field(FileNo; Rec."File No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the File No field.';
                }
                field(FileName; Rec."File Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the File Name field.';
                }
                field(AuthorizedBy; Rec."Authorized By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Authorized By field.';
                }
                field(ServedBy; Rec."Served By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Served By field.';
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(Approvals)
            {
                ApplicationArea = Basic;
                Caption = 'Approvals';
                Image = Approvals;
                Promoted = true;
                PromotedCategory = Category4;
                ToolTip = 'Executes the Approvals action.';

                trigger OnAction()
                begin
                    /*
                   DocumentType:=DocumentType::"Payment Voucher";
                   Approvalentries.SetRecordFilters(DATABASE::"Payments Header",DocumentType,"No.");
                   Approvalentries.RUN;
                    */

                end;
            }
            action(sendApproval)
            {
                Caption = 'Send A&pproval Request';
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedIsBig = true;
                ApplicationArea = all;

                PromotedCategory = Category4;
                ToolTip = 'Executes the Send A&pproval Request action.';

                trigger OnAction()
                var
                    //  ApprovalMgt: Codeunit "Approvals Management";

                    CustomApprovals: Codeunit "Custom Approvals Codeunit";
                    varVariant: Variant;
                begin

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

                PromotedIsBig = true;
                ApplicationArea = all;
                PromotedCategory = Category4;
                ToolTip = 'Executes the Cancel Approval Re&quest action.';

                trigger OnAction()
                var
                    CustomApprovals: Codeunit "Custom Approvals Codeunit";
                    VarVariant: Variant;
                begin

                    VarVariant := Rec;
                    if CustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) then
                        CustomApprovals.OnCancelDocApprovalRequest(VarVariant);
                end;
            }
        }
    }
}

