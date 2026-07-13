Query 50014 "Project Travel Requests"
{
    OrderBy = descending(Code);

    elements
    {
        dataitem(Project_Travel_Requests; "Project Travel Requests")
        {
            column("Code"; "Code") { }
            column(Project; Project) { }
            column(Project_Activity; "Project Activity") { }
            column(Date_Requested; "Date Requested") { }
            column(Status; Status) { }
            column(Client; Client) { }
            column(No_of_Teams; "No of Teams") { }
        }
    }
}

