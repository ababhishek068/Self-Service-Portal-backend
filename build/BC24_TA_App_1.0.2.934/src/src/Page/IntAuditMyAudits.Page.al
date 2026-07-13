Page 50143 "Int. Audit My Audits"
{
    PageType = List;
    SourceTable = "Int. Audit Auditors";
    CardPageId = "Int. Audit My Audit Card";
    ApplicationArea = All;

    layout
    {
        area(content)
        {

            repeater(Group)
            {
                field("Workplan Name"; Rec."Workplan Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Workplan Name field.';
                }
                field("Audit Area Name"; Rec."Audit Area Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Audit Area Name field.';
                }
                field(Quarter; Rec."Quarter Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Quarter Name field.';
                }
                field(Auditor; Rec."Auditor ID")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Auditor ID field.';
                }
                field(Auditee; Rec.Auditee)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Auditee field.';
                }
                field("Auditee Name"; Rec."Auditee Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Auditee Name field.';
                }
                field(Findings1; Rec.Findings)
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
                field(AuditeeResponse; Rec."Auditee Response")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Auditee Response field.';
                }
                field("Auditee Submission Date"; Rec."Auditee Submission Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Auditee Submission Date field.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Notification)
            {
                ApplicationArea = Basic;
                RunObject = Page "Int. Audit Notifications";
                RunPageLink = Quarter = field("Quarter Code"),
                              Auditor = field("Auditor ID");
                ToolTip = 'Executes the Notification action.';
            }
            action("Audit Card")
            {
                ApplicationArea = Basic;
                RunObject = Page "Audit Card";
                ToolTip = 'Executes the Audit Card action.';
                // RunPageLink ="Audit No."=field()
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
    trigger OnOpenPage()
    begin
        Rec.setfilter("Auditor ID", Database.UserId);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        if TbUserSetup.Get(UserId) then begin
            if TbUserSetup."Chief Internal Auditor?" = false then
                Error('Oops! Permission denied. Only the Chief Internal Auditor is permitted.');
        end
        else begin
            Error('Oops! Permission denied. Only the Chief Internal Auditor is permitted.');
        end;
    end;

    var
        TbUserSetup: Record "User Setup";
}

