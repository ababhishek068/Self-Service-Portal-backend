Page 50002 "Admission Number Setup"
{
    PageType = List;
    SourceTable = "Admissions Number Setup";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field(Degree; Rec.Degree)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Degree field.';
                }
                field(DegreeName; Rec."Degree Name")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Degree Name field.';
                }
                field(ProgrammePrefix; Rec."Programme Prefix")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Programme Prefix field.';
                }
                field(JABPrefix; Rec."JAB Prefix")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the JAB Prefix field.';
                }
                field(SSPPrefix; Rec."SSP Prefix")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the SSP Prefix field.';
                }
                field(NoSeries; Rec."No. Series")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No. Series field.';
                }
                field(Year; Rec.Year)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Year field.';
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

