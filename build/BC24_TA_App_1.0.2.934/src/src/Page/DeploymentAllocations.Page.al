page 50261 "Deployment Allocations"
{
    Caption = 'S/M/W Allocation';
    PageType = card;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Deployment Request";
    Editable = false;
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
            part(Deployment; "Deployment Lines")
            {
                Caption = 'Allocation Lines';
                ApplicationArea = basic;
                Editable = true;
                SubPageLink = "Deployment No" = field(No);
            }
        }
        area(Factboxes) { }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = basic;
                Image = Allocate;
                Caption = 'Allocation Lines';
                RunObject = page "Deployment Lines";
                RunPageLink = "Deployment No" = field(No);
                ToolTip = 'Executes the Allocation Lines action.';
            }
            action("Approval Request")
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
                    AllLines: Record "Deployment Lines";
                begin
                    Rec.TestField(Status, Rec.Status::New);
                    AllLines.Reset();
                    AllLines.SetRange("Deployment No", Rec.No);
                    if AllLines.Find('-') then begin
                        VarVariant := Rec;
                        IF ApprovalsMgmt.CheckApprovalsWorkflowEnabled(VarVariant) THEN
                            ApprovalsMgmt.RunWorkflowOnSendApprovalRequest(VarVariant);
                    end else
                        Error('Add Allocation Lines before sending for approval');
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
