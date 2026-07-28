namespace Hijra.Hijra;

query 50103 "Training Application Header"
{
    Caption = 'Training Application Header';
    QueryType = Normal;
    
    elements
    {
        dataitem(HRTrainingApplications; "HR Training Applications")
        {
            column(ApplicationNo; "Application No")
            {
            }
            column(CourseTitle; "Course Title")
            {
            }
            column(FromDate; "From Date")
            {
            }
            column(ToDate; "To Date")
            {
            }
            column(DurationUnits; "Duration Units")
            {
            }
            column("Duration"; "Duration")
            {
            }
            column(CostOfTraining; "Cost Of Training")
            {
            }
            column(Location; Location)
            {
            }
            column(Posted; Posted)
            {
            }
            column(Description; Description)
            {
            }
            column(TrainingEvaluationResults; "Training Evaluation Results")
            {
            }
            column(Year; Year)
            {
            }
            column(Trainer; Trainer)
            {
            }
            column(PurposeofTraining; "Purpose of Training")
            {
            }
            column(Status; Status)
            {
            }
            column(EmployeeNo; "Employee No.")
            {
            }
            column(ApplicationDate; "Application Date")
            {
            }
            column(NoSeries; "No. Series")
            {
            }
            column(Address; Address)
            {
            }
            column(Recommendations; Recommendations)
            {
            }
            column(UserID; "User ID")
            {
            }
            column(ResponsibilityCenter; "Responsibility Center")
            {
            }
            column(GlobalDimension1; "Global Dimension 1")
            {
            }
            column(EmployeeName; "Employee Name")
            {
            }
            column(TrainingInstitution; "Training Institution")
            {
            }
            column(TrainingCategory; "Training Category")
            {
            }
            column(TableID; "Table ID")
            {
            }
            column(Supervisor; Supervisor)
            {
            }
            column(SupervisorName; "Supervisor Name")
            {
            }
            column(IndividualCourseCode; "Individual Course Code")
            {
            }
            column(IndividualCourseDescription; "Individual Course Description")
            {
            }
            column(NoofParticipants; "No of Participants")
            {
            }
            column(GlobalDimension2; "Global Dimension 2")
            {
            }
            column(NoofRequiredParticipants; "No of Required Participants")
            {
            }
            column(Station; Station)
            {
            }
            column(QuarterOffered; "Quarter Offered")
            {
            }
            column(TrainingStatus; "Training Status")
            {
            }
            column(Dim2Name; "Dim2 Name")
            {
            }
            column(StationName; "Station Name")
            {
            }
            column(Dim1Name; "Dim1 Name")
            {
            }
            column(EntryNo; "Entry No")
            {
            }
            column(Sponsor; Sponsor)
            {
            }
            column(Specify; Specify)
            {
            }
            column(Country; Country)
            {
            }
            column(Region; Region)
            {
            }
            column(IsHOD; "Is HOD")
            {
            }
            column(SystemId; SystemId)
            {
            }
        }
    }
    
    trigger OnBeforeOpen()
    begin
    
    end;
}
