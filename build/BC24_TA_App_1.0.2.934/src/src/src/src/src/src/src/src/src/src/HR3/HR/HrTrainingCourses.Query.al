namespace Hijra.Hijra;

query 50109 "Hr Training Courses"
{
    Caption = 'Hr Training Courses';
    QueryType = Normal;
    
    elements
    {
        dataitem(HRTrainingCourses; "HR Training Courses")
        {
            column(CourseCode; "Course Code")
            {
            }
            column(CourseTittle; "Course Tittle")
            {
            }
            column(StartDate; "Start Date")
            {
            }
            column(EndDate; "End Date")
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
            column(ReAssessmentDate; "Re-Assessment Date")
            {
            }
            column(NeedSource; "Need Source")
            {
            }
            column(Provider; Provider)
            {
            }
            column(Posted; Posted)
            {
            }
            column(CampusCode; "Campus Code")
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
            column(ProviderName; "Provider Name")
            {
            }
            column(NoofParticipantsRequired; "No of Participants Required")
            {
            }
            column(NatureofTraining; "Nature of Training")
            {
            }
            column(TrainingType; "Training Type")
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
            column(ClosingStatus; "Closing Status")
            {
            }
            column(QuarterOffered; "Quarter Offered")
            {
            }
            column(CampusName; "Campus Name")
            {
            }
            column(DepartmentName; "Department Name")
            {
            }
            column(StationCode; "Station Code")
            {
            }
            column(StationName; "Station Name")
            {
            }
        }
    }
    
    trigger OnBeforeOpen()
    begin
    
    end;
}
