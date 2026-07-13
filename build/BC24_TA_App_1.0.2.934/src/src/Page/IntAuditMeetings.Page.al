Page 50140 "Int. Audit Meetings"
{
    PageType = List;
    SourceTable = "Int. Audit Meetings";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Description; Rec."Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(Category; Rec.Category)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Category field.';
                }
                field(MeetingDate; Rec."Meeting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Meeting Date field.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Meeting Agenda")
            {
                ApplicationArea = Basic;
                RunObject = Page "Int. Audit Meeting Agenda";
                RunPageLink = "Meeting Code" = field(Code);
                ToolTip = 'Executes the Meeting Agenda action.';
            }
            action("Meeting Attendance")
            {
                ApplicationArea = Basic;
                RunObject = Page "Int. Audit Meeting Attendance";
                RunPageLink = "Meeting Code" = field(Code);
                ToolTip = 'Executes the Meeting Attendance action.';
            }
            action("Meeting Minutes")
            {
                ApplicationArea = Basic;
                RunObject = Page "Int. Audit Meeting Minutes";
                RunPageLink = "Meeting Code" = field(Code);
                ToolTip = 'Executes the Meeting Minutes action.';
            }
            action(Resolutions)
            {
                ApplicationArea = Basic;
                RunObject = Page "Int. Audit Resolutions";
                RunPageLink = "Meeting Code" = field(Code);
                ToolTip = 'Executes the Resolutions action.';
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        if Rec.Code = '' then begin
            TbAuditSetup.FindFirst();
            Rec.Code := NoSeriesMgt.GetNextNo(TbAuditSetup."Meetings No. Series", 0D, true);
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

