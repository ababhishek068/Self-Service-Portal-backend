Page 50043 "Int. Audit Quarters"
{
    PageType = List;
    SourceTable = "Int. Audit Quarters";
    Caption = 'Audit Quarters';
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Quarter; Rec.Quarter)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Quarter field.';
                }
                field(Stage; Rec.Stage)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Stage field.';
                }
                field(ExpectedSubmissionDate; Rec."Expected Submission Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Expected Submission Date field.';
                }
                field(ActualSubmissionDate; Rec."Actual Submission Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Actual Submission Date field.';
                }
                field(Comments; Rec.Comments)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Comments field.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Quarter Auditors")
            {
                ApplicationArea = Basic;
                RunObject = Page "Int. Audit Auditors";
                RunPageLink = "Quarter Code" = field(Code);
                ToolTip = 'Executes the Quarter Auditors action.';
            }
            action(Meetings)
            {
                ApplicationArea = Basic;
                RunObject = Page "Int. Audit Meetings";
                RunPageLink = Quarter = field(code);
                ToolTip = 'Executes the Meetings action.';
            }
        }
        area(reporting)
        {
            action("Meeting Report")
            {
                ApplicationArea = Basic;
                RunObject = Report "Int. Audit Meeting Report";
                ToolTip = 'Executes the Meeting Report action.';
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        if Rec.Code = '' then begin
            TbAuditSetup.FindFirst();
            Rec.Code := NoSeriesMgt.GetNextNo(TbAuditSetup."Quarter No. Series", 0D, true);
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

