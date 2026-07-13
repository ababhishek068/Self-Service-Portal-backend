Query 50012 "Client Support Visit"
{
    OrderBy = ascending(Code);

    elements
    {
        dataitem(Client_Support_Visits; "Client Support Visits")
        {
            column("Code"; "Code") { }
            column(Project_No; "Project No") { }
            column(Client; Client) { }
            column(Date_Created; "Date Created") { }
            column(Staff_No; "Staff No") { }
            column(Staff_Name; "Staff Name") { }
            column(Claimed; Claimed) { }
            column(Date_of_Visit; "Date of Visit") { }
            column(Status; Status) { }
        }
    }
}

