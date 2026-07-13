page 50264 "Deployment Header"
{
    PageType = card;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Deployment Request";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(No; Rec.No)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No field.';

                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';

                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date field.';

                }
                field("Requested Service M/W"; Rec."Requested Service M/W")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Requested Service M/W field.';

                }
                field("Availlable Accomodation"; Rec."Availlable Accomodation")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Availlable Accomodation field.';

                }
                field("Service Region"; Rec."Service Region")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Service Region field.';

                }
                field("Service Unit"; Rec."Service Unit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Service Unit field.';

                }
                field("Requested Start Date"; Rec."Requested Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Requested Start Date field.';

                }
                field("Project End Date"; Rec."Project End Date")
                {
                    ApplicationArea = All;
                    Caption = 'Project End Date';
                    ToolTip = 'Specifies the value of the Project End Date field.';
                }
                field("Project Status"; Rec."Project Status")
                {
                    ApplicationArea = All;
                    Caption = 'Project Status';
                    ToolTip = 'Specifies the value of the Project Status field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field.';

                }
            }
        }
        area(Factboxes) { }
    }

    actions
    {
        area(Processing)
        {
            group("Approval Request")
            {
                Caption = 'Approval Request';
                action(SendApprovalRequest)
                {
                    Caption = 'Send Approval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ApplicationArea = basic;
                    ToolTip = 'Executes the Send Approval Request action.';
                    trigger OnAction();
                    var
                        VarVariant: Variant;
                        ApprovalsMgmt: Codeunit "Custom Approvals CU";
                    begin
                        Rec.TestField(Status, Rec.Status::New);
                        VarVariant := Rec;
                        IF ApprovalsMgmt.CheckApprovalsWorkflowEnabled(VarVariant) THEN
                            ApprovalsMgmt.RunWorkflowOnSendApprovalRequest(VarVariant);
                    end;
                }
                action("Cancel Approval Request")
                {
                    Caption = 'Cancel Approval Request';
                    Image = CancelApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ApplicationArea = basic;
                    ToolTip = 'Executes the Cancel Approval Request action.';
                    trigger OnAction();
                    var
                        VarVariant: Variant;
                        ApprovalsMgmt: Codeunit "Custom Approvals CU";
                    begin

                        VarVariant := Rec; //Added
                        ApprovalsMgmt.OnCancelDocApprovalRequest(VarVariant);
                    end;
                }

                action(Approvals)
                {
                    Caption = 'Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ApplicationArea = basic;
                    ToolTip = 'Executes the Approvals action.';
                    trigger OnAction();
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.OpenApprovalEntriesPage(Rec.RECORDID)
                    end;
                }
            }
        }
    }
}