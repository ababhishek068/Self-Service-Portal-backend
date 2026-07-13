Page 50137 "Int. Audit Areas"
{
    PageType = List;
    SourceTable = "Int. Audit Areas";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(AreaofAudit; Rec."Area of Audit")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Area of Audit field.';
                }
                field("Section Code"; Rec."Section Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Section Code field.';
                }
                field(Objectives; Rec.Objectives)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Objectives field.';
                }
                field(Indicators; Rec.Indicators)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Indicators field.';
                }
            }
        }
    }

    actions { }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        if Rec.Code = '' then begin
            TbAuditSetup.FindFirst();
            Rec.Code := NoSeriesMgt.GetNextNo(TbAuditSetup."Audit Area No. Series", 0D, true);
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

