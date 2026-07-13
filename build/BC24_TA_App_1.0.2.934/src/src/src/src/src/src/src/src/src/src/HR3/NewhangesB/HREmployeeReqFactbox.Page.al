Page 51104 "HR Employee Req. Factbox"
{
    PageType = ListPart;
    SourceTable = "HR Jobs";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            field(JobID; Rec."Job ID")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the Job ID field.';
            }

            field(PositionReportingto; Rec."Position Reporting to")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the Position Reporting to field.';
            }
            field(OccupiedPositions; Rec."Occupied Positions")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the Occupied Positions field.';
            }
            field(VacantPositions; Rec."Vacant Positions")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the Vacant Positions field.';
            }

        }
    }

    actions { }
}

