Page 50078 "Phase Reporting SchedulesAudit"
{
    PageType = List;
    SourceTable = "Phase Reporting Schedules";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Phase; Rec.Phase)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Phase field.';
                }
                field(TableID; Rec."Table ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Table ID field.';
                }
                field(PartnerDonor; Rec."Partner/Donor")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Partner/Donor field.';
                }
                field(Project; Rec.Project)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Project field.';
                }
                field(Months; Rec.Months)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Months field.';
                }
                field(ReportingDate; Rec."Reporting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Reporting Date field.';
                }
                field(Notified; Rec.Notified)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Notified field.';
                }
                field(AuditDates; Rec."Audit Dates")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Audit Dates field.';
                }
                field(AlertSent; Rec.AlertSent)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the AlertSent field.';
                }
            }
        }
    }

    actions { }
}

