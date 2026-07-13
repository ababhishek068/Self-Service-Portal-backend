report 50011 "HrEmployee List"
{
    Caption = 'Hr Employee List';
    ApplicationArea = All;
    dataset
    {
        dataitem(HREmployee; "HR-Employee")
        {
            column(No; "No.") { }
            column(FullName; "Full Name") { }
            column(Gender; Gender) { }
            column(Grade; Grade) { }
        }
        dataitem("HR Leave Application"; "HR Leave Application")

        {
            //DataItemLink ="Employee No."=field("No.");

        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName) { }
            }
        }
        actions
        {
            area(processing) { }
        }
    }
}
