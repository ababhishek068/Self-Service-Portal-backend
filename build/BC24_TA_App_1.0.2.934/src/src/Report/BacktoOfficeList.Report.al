report 50311 "Back to Office List"
{
    UsageCategory = Administration;
    ApplicationArea = All;

    dataset
    {
        dataitem("HRBack To Office Form"; "HRBack To Office Form")
        {
            //RequestFiltercolumns = "Current Station";
            column(DocumentNo; "Document No") { }
            column(CourseTitle; "Course Title") { }
            column(FromDate; "From Date") { }
            column(ToDate; "To Date") { }
            column(DurationUnits; "Duration Units") { }
            column(Duration; Duration) { }
            column(CostOfTraining; "Cost Of Training") { }
            column(Location; Location) { }
            column(Description; Description) { }
            column(TrainingEvaluationResults; "Training Evaluation Results") { }
            column(Trainer; Trainer) { }
            column(PurposeofTraining; "Purpose of Training") { }
            column(Status; Status) { }
            column(EmployeeNo; "Employee No.") { }
            column(NoSeries; "No. Series") { }
            column(UserID; "User ID") { }
            column(ResponsibilityCenter; "Responsibility Center") { }
            column(Campus; Campus) { }
            column(EmployeeName; "Employee Name") { }
            column(TrainingInstitution; "Training Institution") { }
            column(Trainingcategory; "Training category") { }
            column(Supervisor; Supervisor) { }
            column(SupervisorName; "Supervisor Name") { }
            column(Department; Department) { }
            column(TrainingStatus; "Training Status") { }
        }
    }
}