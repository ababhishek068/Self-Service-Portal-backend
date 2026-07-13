report 50306 "Staff Welfare"
{
    UsageCategory = Administration;
    ApplicationArea = All;

    dataset
    {
        dataitem("Company Activities"; "Company Activities")
        {
            //RequestFiltercolumns = "Current Station";
            column("Code"; Code) { }
            column(Description; Description) { }
            column(Day; Day) { }
            column(Venue; Venue) { }
            column(Attachement; Attachement) { }
            column(Responsibility; Responsibility) { }
            column(Costs; Costs) { }
            column(Control1000000022; Post) { }
            column(Posted; Posted) { }
            column(Name; "First Name" + '  ' + "Middle Name" + '  ' + "Last Name") { }
            column(FirstName; "First Name") { }
            column(MiddleName; "Middle Name") { }
            column(LastName; "Last Name") { }
            column(Attachments; Attachments) { }
        }
    }
}