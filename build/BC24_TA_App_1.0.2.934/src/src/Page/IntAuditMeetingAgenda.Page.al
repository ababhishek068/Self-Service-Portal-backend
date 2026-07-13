Page 50141 "Int. Audit Meeting Agenda"
{
    PageType = List;
    SourceTable = "Int. Audit Meeting Agenda";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Agenda; Rec."Agenda")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Agenda field.';
                }
                field(Discussed; Rec."Discussed?")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Discussed? field.';
                }
            }
        }
    }

    actions { }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        if Rec.Code = '' then begin
            TbAuditSetup.FindFirst();
            Rec.Code := NoSeriesMgt.GetNextNo(TbAuditSetup."Agenda No. Series", 0D, true);
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

