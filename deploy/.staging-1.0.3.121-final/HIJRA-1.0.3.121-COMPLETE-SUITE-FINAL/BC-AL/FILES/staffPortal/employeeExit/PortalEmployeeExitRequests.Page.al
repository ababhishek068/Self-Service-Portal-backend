page 52101 "Portal Employee Exit Requests"
{
    Caption = 'Employee Exit Requests';
    PageType = List;
    SourceTable = "Portal Employee Exit Request";
    CardPageId = "Portal Employee Exit Card";
    ApplicationArea = All;
    UsageCategory = Lists;
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Requests)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Request Type"; Rec."Request Type")
                {
                    ApplicationArea = All;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                }
                field("Current Department"; Rec."Current Department")
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
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Cancellation Requested"; Rec."Cancellation Requested")
                {
                    ApplicationArea = All;
                }
                field("Created On"; Rec."Created On")
                {
                    ApplicationArea = All;
                }
                field("Submitted On"; Rec."Submitted On")
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
            action(ApproveExit)
            {
                ApplicationArea = All;
                Caption = 'Approve';
                Image = Approve;
                ToolTip = 'Approve the selected pending Employee Exit request.';
                Enabled = CanDecide;
                trigger OnAction()
                var
                    ExitWorkflow: Codeunit "Portal Employee Exit Workflow";
                begin
                    ExitWorkflow.ApproveRequest(Rec);
                    CurrPage.Update(false);
                end;
            }
            action(RejectExit)
            {
                ApplicationArea = All;
                Caption = 'Reject';
                Image = Reject;
                ToolTip = 'Reject the selected pending Employee Exit request.';
                Enabled = CanDecide;
                trigger OnAction()
                var
                    ExitWorkflow: Codeunit "Portal Employee Exit Workflow";
                begin
                    ExitWorkflow.RejectRequest(Rec);
                    CurrPage.Update(false);
                end;
            }
            action(CompleteExit)
            {
                ApplicationArea = All;
                Caption = 'Mark Completed';
                Image = Completed;
                ToolTip = 'Mark an approved Employee Exit request as completed.';
                trigger OnAction()
                var
                    ExitWorkflow: Codeunit "Portal Employee Exit Workflow";
                begin
                    ExitWorkflow.CompleteRequest(Rec);
                    CurrPage.Update(false);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        ApprovalEntry.SetRange("Record ID to Approve", Rec.RecordId);
        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Open);
        ApprovalEntry.SetRange("Approver ID", CopyStr(UserId, 1, MaxStrLen(ApprovalEntry."Approver ID")));
        CanDecide := not ApprovalEntry.IsEmpty();
    end;

    var
        CanDecide: Boolean;
}
