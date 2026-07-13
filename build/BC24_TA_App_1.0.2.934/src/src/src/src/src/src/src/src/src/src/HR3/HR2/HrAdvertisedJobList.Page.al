Page 51085 "Hr Advertised Job List"
{
    CardPageID = "Hr Advertised Job Card";
    PageType = List;
    SourceTable = "HR Employee Requisitions";
    SourceTableView = where(Advertised = filter(true));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(JobID; Rec."Job ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Job ID field.';
                }
                field(RequisitionDate; Rec."Requisition Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Requisition Date field.';
                }
                field(Priority; Rec.Priority)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Priority field.';
                }
                field(Positions; Rec.Positions)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Positions field.';
                }
                field(Approved; Rec.Approved)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Approved field.';
                }
                field(DateApproved; Rec."Date Approved")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Approved field.';
                }
                field(JobDescription; Rec."Job Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Job Description field.';
                }
                field(Stage; Rec.Stage)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Stage field.';
                }
                field(Score; Rec.Score)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Score field.';
                }
                field(StageCode; Rec."Stage Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Stage Code field.';
                }
                field(Qualified; Rec.Qualified)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Qualified field.';
                }
                field(JobSupervisorManager; Rec."Job Supervisor/Manager")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Job Supervisor/Manager field.';
                }
                field(GlobalDimension2Code; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.';
                }
                field(TurnAroundTime; Rec."Turn Around Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Turn Around Time field.';
                }
                field(GracePeriod; Rec."Grace Period")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Grace Period field.';
                }
                field(Closed; Rec.Closed)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Closed field.';
                }
                field(RequisitionType; Rec."Requisition Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Requisition Type field.';
                }
                field(ClosingDate; Rec."Closing Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Closing Date field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field(RequiredPositions; Rec."Required Positions")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Required Positions field.';
                }
                field(VacantPositions; Rec."Vacant Positions")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Vacant Positions field.';
                }
                field(ReasonforRequestOther; Rec."Reason for Request(Other)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Reason for Request(Other) field.';
                }
                field(AnyAdditionalInformation; Rec."Any Additional Information")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Any Additional Information field.';
                }
                field(JobGrade; Rec."Job Grade")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Job Grade field.';
                }
                field(TypeofContractRequired; Rec."Type of Contract Required")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Type of Contract Required field.';
                }
                field(RequisitionNo; Rec."Requisition No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Requisition No. field.';
                }
                field(Gender; Rec.Gender)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Gender field.';
                }
                field(JobRefNo; Rec."Job Ref No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Job Ref No field.';
                }
                field(Advertised; Rec.Advertised)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Advertised field.';
                }
                field(OpeningDate; Rec."Opening Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Opening Date field.';
                }
            }
        }
    }

    actions { }
}

