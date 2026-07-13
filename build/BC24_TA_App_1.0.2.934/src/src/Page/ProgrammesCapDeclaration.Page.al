page 50974 "Programmes Cap. Declaration"
{
    PageType = Card;
    SourceTable = "Programmes Cap. Declaration";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field("Academic Year"; Rec."Academic Year")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Academic Year field.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
            group(Programmes)
            {
                Caption = 'Programmes';
                part(Control8; "Prog. Capacity Declaratio List")
                {
                    ApplicationArea = basic;
                    SubPageLink = Code = FIELD(Code);
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
                Caption = 'Approvals';
                Image = Approvals;
                Promoted = true;
                PromotedCategory = Category4;
                ToolTip = 'Executes the Approvals action.';

                trigger OnAction()
                begin
                    ApprovalsMgmt.OpenApprovalEntriesPage(Rec.RecordId)
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
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ToolTip = 'Executes the Cancel Approval Re&quest action.';

                trigger OnAction()
                begin

                    VarVariant := Rec;
                    CustomApprovals.OnCancelDocApprovalRequest(VarVariant);
                    Rec.Status := Rec.Status::"Pending Approval";
                    Rec.Modify;
                end;
            }
        }
    }

    var
        VarVariant: Variant;
        CustomApprovals: Codeunit "Custom Approvals Codeunit";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
}

