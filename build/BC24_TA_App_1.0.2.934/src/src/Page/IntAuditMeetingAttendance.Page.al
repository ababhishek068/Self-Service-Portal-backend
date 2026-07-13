Page 50142 "Int. Audit Meeting Attendance"
{
    PageType = List;
    SourceTable = "Int. Audit Meeting Attendance";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Attendee; Rec.Attendee)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Attendee field.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Name field.';
                }
            }
        }
    }

    actions { }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        if Rec.Code = '' then begin
            TbAuditSetup.FindFirst();
            Rec.Code := NoSeriesMgt.GetNextNo(TbAuditSetup."Attendance No. Series", 0D, true);
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

