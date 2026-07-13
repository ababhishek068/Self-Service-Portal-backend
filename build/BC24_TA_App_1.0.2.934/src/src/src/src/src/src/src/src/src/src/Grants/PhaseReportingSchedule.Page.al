Page 50449 "Phase Reporting Schedule"
{
    DelayedInsert = true;
    Editable = false;
    PageType = Card;
    SourceTable = "Phase Reporting Schedules";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                field(Project; Rec.Project)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Project field.';
                }
                field(Phase; Rec.Phase)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Phase field.';
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
            }
        }
    }

    actions { }
}

