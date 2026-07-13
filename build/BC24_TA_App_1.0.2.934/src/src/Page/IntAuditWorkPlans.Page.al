Page 50041 "Int. Audit Work Plans"
{
    PageType = List;
    SourceTable = "Int. Audit Work Plans";
    CardPageId = "Int. Audit Workplan Card";
    Caption = 'Internal Audit Work Plans';
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
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
            action("Quartely Work Plan")
            {
                ApplicationArea = Basic;
                RunObject = Report "Int. Audit Quarterly Work Plan";
                ToolTip = 'Executes the Quartely Work Plan action.';
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        if Rec.Code = '' then begin
            TbAuditSetup.FindFirst();
            Rec.Code := NoSeriesMgt.GetNextNo(TbAuditSetup."Workplan No. Series", 0D, true);
        end;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        CheckPermission();
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

