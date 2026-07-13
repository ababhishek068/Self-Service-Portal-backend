page 50051 "Int. Audit Workplan Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Int. Audit Work Plans";
    Caption = 'Workplan Details';

    layout
    {
        area(Content)
        {
            group("Audit Workplan Details")
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Audits")
            {
                ApplicationArea = All;
                RunObject = page "Int. Audits";
                RunPageLink = "Work Plan" = field(Code);
                ToolTip = 'Executes the Audits action.';
            }
            action("Send for Approval")
            {
                ApplicationArea = Basic;
                Image = Approve;
                Promoted = false;
                ToolTip = 'Executes the Send for Approval action.';

                trigger OnAction()
                begin
                    VarVariant := Rec;
                    if CustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) then begin
                        CustomApprovals.OnSendDocForApproval(VarVariant);
                    end;
                end;
            }

        }
        area(Reporting)
        {
            action("Annual Work Plan")
            {
                ApplicationArea = Basic;
                Promoted = false;
                RunObject = Report "Int. Audit Annual Work Plan";
                ToolTip = 'Executes the Annual Work Plan action.';
            }
            action("Quarterly Work Plan")
            {
                ApplicationArea = Basic;
                Promoted = false;
                RunObject = Report "Int. Audit Quarterly Work Plan";
                ToolTip = 'Executes the Quarterly Work Plan action.';
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        CheckPermission();
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        if Rec.Code = '' then begin
            TbAuditSetup.FindFirst();
            Rec.Code := NoSeriesMgt.GetNextNo(TbAuditSetup."Workplan No. Series", 0D, true);
        end;
    end;

    var
        TbUserSetup: Record "User Setup";
        NoSeriesMgt: Codeunit "No. Series";
        TbAuditSetup: Record "Int. Audit Setups";
        CustomApprovals: Codeunit "Custom Approvals Codeunit";
        VarVariant: Variant;

    local procedure CheckPermission()
    begin
        if TbUserSetup.Get(UserId) then begin
            if TbUserSetup."Chief Internal Auditor?" = false then
                Error('Oops! Permission denied. Only the Chief Internal Auditor is permitted.');
        end
        else begin
            Error('Oops! Permission denied. Only the Chief Internal Auditor is permitted.');
        end;
    end;
}