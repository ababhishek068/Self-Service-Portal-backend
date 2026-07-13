Page 51332 "HR Jobs Factbox"
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
            field(JobDescription; Rec."Job Description")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the Job Description field.';
            }
            field("No of Posts"; Rec."No of Posts")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the No of Posts field.';
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

            field("Job Grade";"Job Grade")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the Grade field.';
            }


            field(Status; Rec.Status)
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the Status field.';
            }
            field(ResponsibilityCenter; Rec."Responsibility Center")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the Responsibility Center field.';
            }
            field(DateCreated; Rec."Date Created")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the Date Created field.';
            }
        }
    }

    actions { }
}

