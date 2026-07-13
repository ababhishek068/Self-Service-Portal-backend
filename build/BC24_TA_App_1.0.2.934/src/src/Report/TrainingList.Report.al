report 50309 "Training List"
{
    UsageCategory = Administration;
    ApplicationArea = All;

    dataset
    {
        dataitem("HR Training Applications"; "HR Training Applications")
        {
            //RequestFiltercolumns = "Current Station";
            column(Application_No; "Application No") { }
            column(Training_Category; "Training Category") { }
            column(User_ID; "User ID") { }
            column(Course_Title; "Course Title") { }
            column(Description; Description) { }
            column(PurposeofTraining; "Purpose of Training") { }
            column(FromDate; "From Date") { }
            column(ToDate; "To Date") { }
            column(CostOfTraining; "Cost Of Training") { }
            column(Provider; "Training Institution") { }
            column(Status; Status) { }
        }
    }
}