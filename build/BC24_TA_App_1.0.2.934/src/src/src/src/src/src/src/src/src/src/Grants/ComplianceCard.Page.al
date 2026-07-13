Page 51166 "Compliance Card"
{
    PageType = Card;
    SourceTable = "Grants Compliance";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(GrantNo; Rec."Grant No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Grant No field.';
                }
                field(ComplianceCode; Rec."Compliance Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Compliance Code field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(Compliance; Rec.Compliance)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Compliance field.';
                }
                field(User; Rec.User)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the User field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field(Comments; Rec.Comments)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Comments field.';
                }
            }
        }
        area(factboxes)
        {

            part("Attached Documents"; "Document Attachments")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(50014),
                              "No." = FIELD("Grant No");
            }
            systempart(Control1905767507; Notes)
            {
                Caption = 'Notes';
                ApplicationArea = Notes;
            }

            systempart(Control11; MyNotes) { }
        }

    }

    actions
    {

        area(processing)
        {

            group(RequestApproval)
            {
                Caption = 'Request Approval';
                action(SendApprovalRequest)
                {
                    ApplicationArea = Basic;
                    Caption = 'Send A&pproval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Executes the Send A&pproval Request action.';

                    trigger OnAction()
                    var
                        CustomApprovals: Codeunit "Custom Approvals Codeunit";
                        VarVariant: Variant;
                    begin

                        VarVariant := Rec;
                        if CustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) then
                            CustomApprovals.OnSendDocForApproval(VarVariant);

                    end;
                }
                action(CancelApprovalRequest)
                {
                    ApplicationArea = Basic;
                    Caption = 'Cancel Approval Re&quest';
                    Enabled = true;
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Executes the Cancel Approval Re&quest action.';

                    trigger OnAction()
                    var
                        CustomApprovals: Codeunit "Custom Approvals Codeunit";
                        VarVariant: Variant;
                    begin
                        VarVariant := Rec;
                        CustomApprovals.OnCancelDocApprovalRequest(VarVariant);
                    end;
                }
            }
            group(Navigate)
            {
                Caption = 'Navigate';
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
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin

                        ApprovalsMgmt.OpenApprovalEntriesPage(Rec.RecordId);
                    end;
                }
            }
        }

    }
}