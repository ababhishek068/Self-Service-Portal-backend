Page 50146 "Int. Audit Meeting Minutes"
{
    PageType = List;
    SourceTable = "Int. Audit Meeting Minutes";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Minute Description"; Rec."Minute Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Minute Description field.';
                }
            }
        }
    }

    actions { }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        if Rec.Code = '' then begin
            TbAuditSetup.FindFirst();
            Rec.Code := NoSeriesMgt.GetNextNo(TbAuditSetup."Minutes No. Series", 0D, true);
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
            if TbUserSetup."Internal Auditor?" = false then
                Error('Oops! Permission denied. Only the Assigned Internal Auditor is permitted.');
        end
        else begin
            Error('Oops! Permission denied. Only the Assigned Internal Auditor is permitted.');
        end;
    end;
}

