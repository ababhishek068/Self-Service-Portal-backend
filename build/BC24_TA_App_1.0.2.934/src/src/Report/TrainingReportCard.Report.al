report 50310 "Training Report Card"
{
    UsageCategory = Administration;
    ApplicationArea = All;

    dataset
    {
        dataitem("HR Training Applications"; "HR Training Applications")
        {
            //RequestFiltercolumns = "Current Station";
            column(Application_No; "Application No") { }
            column(Application_Date; "Application Date") { }
            column(User_ID; "User ID") { }
            column(Supervisor; Supervisor) { }
            column(Supervisor_Name; "Supervisor Name") { }
            column(Training_Category; "Training Category") { }
            column(Employee_No; "Employee No.") { }
            column(Employee_Name; "Employee Name") { }
            column(Global_Dimension_1; "Global Dimension 1") { }
            column(Global_Dimension_2; "Global Dimension 2") { }

            column(Station; Station) { }
            column(Course_Title; "Course Title") { }
            column(Description; Description) { }

            column(PurposeofTraining; "Purpose of Training") { }
            column(FromDate; "From Date") { }
            column(ToDate; "To Date") { }
            column(Duration; Duration) { }
            column(DurationUnits; "Duration Units") { }
            column(Sponsor; Sponsor) { }
            column(Specify; Specify) { }
            column(Location; Location) { }
            column(Country; Country) { }
            column(Region; Region) { }
            column(CostOfTraining; "Cost Of Training") { }
            column(Trainer; Trainer) { }
            column(Trainin_Institution; "Training Institution") { }

            column(Status; Status) { }
            column(Training_Status; "Training Status") { }
            column(Training_Evaluation_Results; "Training Evaluation Results") { }
            column(NoofParticipants; "No of Participants") { }
        }
    }
}