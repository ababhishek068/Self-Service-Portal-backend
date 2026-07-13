Page 50370 "Maintenance Plan Card"
{
    PageType = Card;
    SourceTable = "Maintenance Plan";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(PlanNo; Rec."Plan No.")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                    Style = Strong;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Plan No. field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(CreatedBy; Rec."Created By")
                {
                    ApplicationArea = Basic;
                    Style = Ambiguous;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Created By field.';
                }
                field(PlannedDate; Rec."Planned Date")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the value of the Planned Date field.';
                }
                field(Dimension1Code; Rec."Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Dimension 1 Code field.';
                }
                field(Dimension2Code; Rec."Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Dimension 2 Code field.';
                }
                field(TotalEstimatedCost; Rec."Total Estimated Cost")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the value of the Total Estimated Cost field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    Style = Attention;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field(Comments; Rec.Comments)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Comments field.';
                }
            }
            part(Control10; "Maintenance Plan Lines")
            {
                SubPageLink = "Plan No." = field("Plan No.");
                UpdatePropagation = Both;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(SendApprovalRequest)
            {
                ApplicationArea = Basic;
                Caption = 'Send Approval Request';
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = false;
                ToolTip = 'Executes the Send Approval Request action.';

                trigger OnAction()
                begin

                    if Confirm('Send this Maintenance Plan for Approval?', true) = false then exit;

                    //ApprovalMgt.SendAssetTransApprovalReq(Rec);
                end;
            }
            action(Approvals)
            {
                ApplicationArea = Basic;
                Caption = 'Approvals';
                Image = Approvals;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the Approvals action.';

                trigger OnAction()
                var
                    DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",Jobs,"Employee Req",Employees,Promotion,Confirmation,"Employee Transfer","Asset Transfer","Transport Req",Overtime,"Training App","Leave App";
                begin

                    DocumentType := Documenttype::"Asset Transfer";
                    //ApprovalEntries.SetRecordFilters(DATABASE::"HR Asset Transfer Header",DocumentType,"No.");
                    //ApprovalEntries.RUN;
                end;
            }
            action(CancelApprovalRequest)
            {
                ApplicationArea = Basic;
                Caption = 'Cancel Approval Request';
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = false;
                ToolTip = 'Executes the Cancel Approval Request action.';

                trigger OnAction()
                begin
                    if Confirm('Cancel Approval Request for this Maintenance Plan?', true) = false then exit;

                    //ApprovalMgt.CancelAssetTransAppRequest(Rec,TRUE,TRUE);
                end;
            }
        }
    }
}

