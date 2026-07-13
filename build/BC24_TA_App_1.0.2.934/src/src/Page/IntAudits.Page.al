Page 50240 "Int. Audits"
{
    PageType = List;
    SourceTable = "Int. Audits";
    Caption = 'Audits';
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Work Plan"; Rec."Work Plan")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Work Plan field.';
                }
                field(AuditArea; Rec."Audit Area")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Audit Area field.';
                }
                field(RiskLevel; Rec."Risk Level")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Risk Level field.';
                }
                field(Objectives1; Rec.Objectives)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Objectives field.';
                }
                field(Indicators1; Rec.Indicators)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Indicators field.';
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
        area(processing)
        {
            action("Audit Quarters")
            {
                ApplicationArea = Basic;
                RunObject = Page "Int. Audit Quarters";
                RunPageLink = Audit = field(Code);
                ToolTip = 'Executes the Audit Quarters action.';
            }
        }
    }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        if Rec.Code = '' then begin
            TbAuditSetup.FindFirst();
            Rec.Code := NoSeriesMgt.GetNextNo(TbAuditSetup."Audit No. Series", 0D, true);
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

