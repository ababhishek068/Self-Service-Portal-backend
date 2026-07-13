Page 50190 "Int. Audit Sections"
{
    PageType = List;
    SourceTable = "Int. Audit Sections";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(Responsibility; Rec.Responsibility)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Responsibility field.';
                }
                field(Ranking; Rec.Ranking)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Ranking field.';
                }
                field("Expected Days"; Rec."Expected Days")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Expected Days field.';
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

