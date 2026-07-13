report 50312 "Back to Office Report"
{
    UsageCategory = Administration;
    ApplicationArea = All;

    dataset
    {
        dataitem("HRBack To Office Form"; "HRBack To Office Form")
        {
            //RequestFiltercolumns = "Current Station";
            column(Document_No; "Document No") { }
            column(Course_Title; "Course Title") { }
            column(Description; Description) { }
            column(FromDate; "From Date") { }
            column(ToDate; "To Date") { }
            column(Location; Location) { }
            column(Trainer; Trainer) { }
            column(Training_Institution; "Training Institution") { }
            column(PurposeofTraining; "Purpose of Training") { }
            column(Employee_No; "Employee No.") { }
            column(Employee_Name; "Employee Name") { }
            column(Campus; Campus) { }
            column(Department; Department) { }
            column(Status; Status) { }
            column(Training_Objective; "Training Objective") { }
            column(Course_Content; "Course Content") { }
            column(Text_1; "Text 1") { }
            column(Text_2; "Text 2") { }

            column(Text_3; "Text 3") { }
            column(Text_4; "Text 4") { }
        }
    }
}