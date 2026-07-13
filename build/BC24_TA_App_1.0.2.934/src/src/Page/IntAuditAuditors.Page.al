Page 50138 "Int. Audit Auditors"
{
    PageType = List;
    SourceTable = "Int. Audit Auditors";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(AuditorID; Rec."Auditor ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Auditor ID field.';
                }
                field(AuditorName; Rec."Auditor Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Auditor Name field.';
                }
                field(Auditee; Rec.Auditee)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Auditee field.';
                }
                field("Auditee Department"; Rec."Auditee Department")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Auditee Department field.';
                }
                field(AuditeeResponse; Rec."Auditee Response")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Auditee Response field.';
                }
                field(Findings; Rec.Findings)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Findings field.';
                }
                field(Risk; Rec.Risk)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Risk field.';
                }
                field(Remommendation; Rec.Remommendation)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Remommendation field.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Notifications)
            {
                ApplicationArea = Basic;
                RunObject = Page "Int. Audit Notifications";
                RunPageLink = Quarter = field("Quarter Code"),
                              Auditor = field("Auditor ID"),
                              Auditee = field(Auditee);
                ToolTip = 'Executes the Notifications action.';
            }
        }
        area(reporting)
        {
            action("Draft Report")
            {
                ApplicationArea = Basic;
                RunObject = Report "Int. Audit Draft Report";
                ToolTip = 'Executes the Draft Report action.';
            }
            action("Final Report")
            {
                ApplicationArea = Basic;
                RunObject = Report "Int. Audit Final Report";
                ToolTip = 'Executes the Final Report action.';
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        TbQuarters.Reset();
        TbQuarters.SetRange(TbQuarters.Code, Rec."Quarter Code");
        if TbQuarters.findfirst() then begin
            TbAudits.Reset();
            TbAudits.SetRange(TbAudits.Code, TbQuarters.Audit);
            if TbAudits.FindFirst() then begin
                Rec.Workplan := TbAudits."Work Plan";
                Rec."Audit Area" := TbAudits."Audit Area";
            end;
        end;

    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        CheckPermission();
    end;

    var
        TbUserSetup: Record "User Setup";
        TbAudits: Record "Int. Audits";
        TbQuarters: Record "Int. Audit Quarters";

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

