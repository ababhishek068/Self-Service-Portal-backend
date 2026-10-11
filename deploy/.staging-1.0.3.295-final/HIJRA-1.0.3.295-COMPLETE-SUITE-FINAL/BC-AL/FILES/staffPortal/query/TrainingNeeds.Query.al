namespace Hijra.Hijra;

query 50105 "Training Needs"
{
    Caption = 'Training Needs';
    QueryType = Normal;
    
    elements
    {
        dataitem(HRTrainingNeedsAnalysis; "HR Training Needs Analysis")
        {
            column("Code"; "Code")
            {
            }
            column(Description; Description)
            {
            }
            column(ProposedStartDate; "Proposed Start Date")
            {
            }
            column(ProposedEndDate; "Proposed End Date")
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
            column(NeedSource; "Need Source")
            {
            }
            column(Directorate; Directorate)
            {
            }
            column(Department; Department)
            {
            }
            column(Closed; Closed)
            {
            }
            column(QualificationCode; "Qualification Code")
            {
            }
            column(QualificationType; "Qualification Type")
            {
            }
            column(QualificationDescription; "Qualification Description")
            {
            }
            column(TrainingApplicants; "Training Applicants")
            {
            }
            column(TrainingApplicantsPassed; "Training Applicants (Passed)")
            {
            }
            column(TrainingApplicantsFailed; "Training Applicants (Failed)")
            {
            }
            column(NoofRequiredParticipants; "No of Required Participants")
            {
            }
            column(NatureofTraining; "Nature of Training")
            {
            }
            column(TrainingMethod; "Training Method")
            {
            }
            column(CourseVersion; "Course Version")
            {
            }
            column(CourseVersionDescription; "Course Version Description")
            {
            }
            column(IndividualCourse; "Individual Course")
            {
            }
            column(Status; Status)
            {
            }
            column(QuarterOffered; "Quarter Offered")
            {
            }
            column(ApplicationDate; "Application Date")
            {
            }
            column(UserID; "User ID")
            {
            }
            column(Trainingcategory; "Training category")
            {
            }
            column(NoofParticipants; "No of Participants")
            {
            }
            column(DirectorateName; "Directorate Name")
            {
            }
            column(DepartmentName; "Department Name")
            {
            }
            column(EmployeeName; "Employee Name")
            {
            }
            column(Station; Station)
            {
            }
            column(CourseCode; "Course Code")
            {
            }
            column(TrainingStatus; "Training Status")
            {
            }
            column(TableID; "Table ID")
            {
            }
            column(EmployeeNo; "Employee No.")
            {
            }
            column(StationName; "Station Name")
            {
            }
            column(NoSeries; "No. Series")
            {
            }
            column(EntryNo; "Entry No")
            {
            }
            column(SystemCreatedAt; SystemCreatedAt)
            {
            }
            column(SystemCreatedBy; SystemCreatedBy)
            {
            }
            column(SystemId; SystemId)
            {
            }
            column(SystemModifiedAt; SystemModifiedAt)
            {
            }
            column(SystemModifiedBy; SystemModifiedBy)
            {
            }
        }
    }
    
    trigger OnBeforeOpen()
    begin
    
    end;
}
