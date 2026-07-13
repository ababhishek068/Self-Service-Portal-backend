Page 50195 "Int. Audit Setups"
{
    InsertAllowed = true;
    PageType = Card;
    SourceTable = "Int. Audit Setups";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(WorkplanNoSeries; Rec."Workplan No. Series")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Workplan No. Series field.';
                }
                field(AuditNoSeries; Rec."Audit No. Series")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Audit No. Series field.';
                }
                field(QuarterNoSeries; Rec."Quarter No. Series")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Quarter No. Series field.';
                }
                field(AuditorNoSeries; Rec."Auditor No. Series")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Auditor No. Series field.';
                }
                field(MeetingsNoSeries; Rec."Meetings No. Series")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Meetings No. Series field.';
                }
                field(AgendaNoSeries; Rec."Agenda No. Series")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Agenda No. Series field.';
                }
                field(AttendanceNoSeries; Rec."Attendance No. Series")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Attendance No. Series field.';
                }
                field("Minutes No. Series"; Rec."Minutes No. Series")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Minutes No. Series field.';
                }
                field(AuditAreaNoSeries; Rec."Audit Area No. Series")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Audit Area No. Series field.';
                }
                field(ResolutionsNoSeries; Rec."Resolutions No. Series")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Resolutions No. Series field.';
                }
            }
        }
    }

    actions { }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        if Rec.Count > 0 then
            Error('You are not allowed to add a new record');
    end;
}

