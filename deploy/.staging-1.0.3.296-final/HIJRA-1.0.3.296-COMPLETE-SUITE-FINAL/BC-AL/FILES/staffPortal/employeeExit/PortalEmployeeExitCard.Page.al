page 52100 "Portal Employee Exit Card"
{
    Caption = 'Employee Exit Request';
    PageType = Card;
    SourceTable = "Portal Employee Exit Request";
    ApplicationArea = All;
    UsageCategory = Tasks;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Request Type"; Rec."Request Type")
                {
                    ApplicationArea = All;
                    Editable = RequestIsOpen;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                    Editable = RequestIsOpen;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                }
                field("Job Title"; Rec."Job Title")
                {
                    ApplicationArea = All;
                }
                field("Current Department"; Rec."Current Department")
                {
                    ApplicationArea = All;
                }
                field("Current Branch"; Rec."Current Branch")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    StyleExpr = StatusStyle;
                }
                field("Created On"; Rec."Created On")
                {
                    ApplicationArea = All;
                }
                field("Submitted On"; Rec."Submitted On")
                {
                    ApplicationArea = All;
                }
                field("Requester User ID"; Rec."Requester User ID")
                {
                    ApplicationArea = All;
                }
                field("Supervisor User ID"; Rec."Supervisor User ID")
                {
                    ApplicationArea = All;
                }
                field("HR Approver User ID"; Rec."HR Approver User ID")
                {
                    ApplicationArea = All;
                }
                field("Supervisor Decision On"; Rec."Supervisor Decision On")
                {
                    ApplicationArea = All;
                }
                field("Supervisor Decision By"; Rec."Supervisor Decision By")
                {
                    ApplicationArea = All;
                }
                field("HR Decision On"; Rec."HR Decision On")
                {
                    ApplicationArea = All;
                }
                field("HR Decision By"; Rec."HR Decision By")
                {
                    ApplicationArea = All;
                }
            }
            group(Transfer)
            {
                Caption = 'Transfer Request';
                Visible = IsTransfer;

                field("Desired Department"; Rec."Desired Department")
                {
                    ApplicationArea = All;
                    Editable = RequestIsOpen;
                    Caption = 'Requested Department';
                }
                field("Desired Location"; Rec."Desired Location")
                {
                    ApplicationArea = All;
                    Editable = RequestIsOpen;
                    Caption = 'Requested Branch / Duty Station';
                }
                field("Transfer Type"; Rec."Transfer Type")
                {
                    ApplicationArea = All;
                    Editable = RequestIsOpen;
                    ToolTip = 'Enter Permanent or Temporary.';
                }
                field("Requested Effective Date"; Rec."Requested Effective Date")
                {
                    ApplicationArea = All;
                    Editable = RequestIsOpen;
                }
                field("Transfer Reason"; Rec."Transfer Reason")
                {
                    ApplicationArea = All;
                    Editable = RequestIsOpen;
                    MultiLine = true;
                }
                field("Transfer Handover Plan"; Rec."Transfer Handover Plan")
                {
                    ApplicationArea = All;
                    Editable = RequestIsOpen;
                    MultiLine = true;
                }
                field("Transfer Supporting Info"; Rec."Transfer Supporting Info")
                {
                    ApplicationArea = All;
                    Editable = RequestIsOpen;
                    MultiLine = true;
                }
            }
            group(Resignation)
            {
                Caption = 'Resignation Application';
                Visible = IsResignation;

                field("Proposed Last Working Date"; Rec."Proposed Last Working Date")
                {
                    ApplicationArea = All;
                    Editable = RequestIsOpen;
                }
                field("Resignation Reason"; Rec."Resignation Reason")
                {
                    ApplicationArea = All;
                    Editable = RequestIsOpen;
                    MultiLine = true;
                }
                field("Notice Acknowledged"; Rec."Notice Acknowledged")
                {
                    ApplicationArea = All;
                    Editable = RequestIsOpen;
                }
                field("Resignation Handover Plan"; Rec."Resignation Handover Plan")
                {
                    ApplicationArea = All;
                    Editable = RequestIsOpen;
                    MultiLine = true;
                }
                field("Personal Email"; Rec."Personal Email")
                {
                    ApplicationArea = All;
                    Editable = RequestIsOpen;
                }
                field("Personal Phone"; Rec."Personal Phone")
                {
                    ApplicationArea = All;
                    Editable = RequestIsOpen;
                }
                field("Forwarding Address"; Rec."Forwarding Address")
                {
                    ApplicationArea = All;
                    Editable = RequestIsOpen;
                }
                field("Company Property Notes"; Rec."Company Property Notes")
                {
                    ApplicationArea = All;
                    Editable = RequestIsOpen;
                    MultiLine = true;
                }
            }
            group("Employee Exit")
            {
                Caption = 'Employee Exit Form';
                Visible = IsExitInterview;

                field("Supervisor Name"; Rec."Supervisor Name")
                {
                    ApplicationArea = All;
                    Editable = RequestIsOpen;
                }
                field("Contract Termination Date"; Rec."Contract Termination Date")
                {
                    ApplicationArea = All;
                    Editable = RequestIsOpen;
                }
                field("Exit Transfer Type"; Rec."Transfer Type")
                {
                    ApplicationArea = All;
                    Caption = 'Transfer Type';
                    Editable = RequestIsOpen;
                    ToolTip = 'Specifies Permanent or Temporary as required by the Employee Exit SSP template.';
                }
                field("Leaving Reasons"; Rec."Leaving Reasons")
                {
                    ApplicationArea = All;
                    Editable = RequestIsOpen;
                    MultiLine = true;
                }
                field("Joining Another Company"; Rec."Joining Another Company")
                {
                    ApplicationArea = All;
                    Editable = RequestIsOpen;
                }
                field("Starting Own Business"; Rec."Starting Own Business")
                {
                    ApplicationArea = All;
                    Editable = RequestIsOpen;
                }
                field("Other Plans"; Rec."Other Plans")
                {
                    ApplicationArea = All;
                    Editable = RequestIsOpen;
                    MultiLine = true;
                }
                field("Would Return"; Rec."Would Return")
                {
                    ApplicationArea = All;
                    Editable = RequestIsOpen;
                }
                field("Most Satisfying"; Rec."Most Satisfying")
                {
                    ApplicationArea = All;
                    Editable = RequestIsOpen;
                    MultiLine = true;
                }
                field("Most Frustrating"; Rec."Most Frustrating")
                {
                    ApplicationArea = All;
                    Editable = RequestIsOpen;
                    MultiLine = true;
                }
                field("Exit Comments"; Rec."Exit Comments")
                {
                    ApplicationArea = All;
                    Editable = RequestIsOpen;
                    MultiLine = true;
                }
                field("Confidentiality Acknowledged"; Rec."Confidentiality Acknowledged")
                {
                    ApplicationArea = All;
                    Editable = RequestIsOpen;
                }
            }
            group(Cancellation)
            {
                Caption = 'Cancellation';
                Visible = CancellationVisible;

                field("Cancellation Requested"; Rec."Cancellation Requested")
                {
                    ApplicationArea = All;
                }
                field("Cancellation Reason"; Rec."Cancellation Reason")
                {
                    ApplicationArea = All;
                    Editable = CanRequestCancellation;
                    MultiLine = true;
                }
                field("Cancelled On"; Rec."Cancelled On")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(SendApprovalRequest)
            {
                ApplicationArea = All;
                Caption = 'Send Approval Request';
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                Enabled = RequestIsOpen;

                trigger OnAction()
                begin
                    CurrPage.SaveRecord();
                    ExitWorkflow.SendApprovalRequest(Rec);
                    CurrPage.Update(false);
                end;
            }
            action(CancelApprovalRequest)
            {
                ApplicationArea = All;
                Caption = 'Cancel Approval Request';
                Image = CancelApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                Enabled = ApprovalIsPending;

                trigger OnAction()
                begin
                    ExitWorkflow.CancelApprovalRequest(Rec);
                    CurrPage.Update(false);
                end;
            }
            action(RequestCancellation)
            {
                ApplicationArea = All;
                Caption = 'Request Cancellation';
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Process;
                Enabled = CanRequestCancellation;

                trigger OnAction()
                begin
                    CurrPage.SaveRecord();
                    ExitWorkflow.RequestCancellation(Rec, Rec."Cancellation Reason");
                    CurrPage.Update(false);
                end;
            }
            action(ApprovalEntries)
            {
                ApplicationArea = All;
                Caption = 'Approval Entries';
                Image = Approvals;

                trigger OnAction()
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    ApprovalsMgmt.OpenApprovalEntriesPage(Rec.RecordId);
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        SetPageState();
    end;

    local procedure SetPageState()
    begin
        RequestIsOpen := Rec.Status = Rec.Status::Open;
        ApprovalIsPending :=
            (Rec.Status = Rec.Status::PendingApproval) or
            (Rec.Status = Rec.Status::PendingHRApproval) or
            (Rec.Status = Rec.Status::CancellationPending);
        IsTransfer := Rec."Request Type" = Rec."Request Type"::Transfer;
        IsResignation := Rec."Request Type" = Rec."Request Type"::Resignation;
        IsExitInterview := Rec."Request Type" = Rec."Request Type"::ExitInterview;
        CanRequestCancellation :=
            (Rec.Status = Rec.Status::Approved) and
            (Rec."Request Type" in [Rec."Request Type"::Transfer, Rec."Request Type"::Resignation]);
        CancellationVisible := Rec."Cancellation Requested" or CanRequestCancellation;

        case Rec.Status of
            Rec.Status::Approved, Rec.Status::Completed:
                StatusStyle := 'Favorable';
            Rec.Status::Rejected, Rec.Status::Cancelled:
                StatusStyle := 'Unfavorable';
            Rec.Status::PendingApproval, Rec.Status::PendingHRApproval, Rec.Status::CancellationPending:
                StatusStyle := 'Ambiguous';
            else
                StatusStyle := 'Standard';
        end;
    end;

    var
        ExitWorkflow: Codeunit "Portal Employee Exit Workflow";
        RequestIsOpen: Boolean;
        ApprovalIsPending: Boolean;
        CanRequestCancellation: Boolean;
        CancellationVisible: Boolean;
        IsTransfer: Boolean;
        IsResignation: Boolean;
        IsExitInterview: Boolean;
        StatusStyle: Text;
}
