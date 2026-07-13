Query 50008 "Project Support"
{
    OrderBy = descending(Project_No);

    elements
    {
        dataitem(Project_Support; "Project Support")
        {
            column(Project_No; "Project No") { }
            column(Entry_No; "Entry No") { }
            column(Reported_Date; "Reported Date") { }
            column(Project_Module; "Project Module") { }
            column(Urgency_Level; "Urgency Level") { }
            column(Issue_Description; "Issue Description") { }
            column(Status; Status) { }
            column(Closing_Date; "Closing Date") { }
            column(Closed_By; "Closed By") { }
            column(Client_Closing_Remarks; "Client Closing Remarks") { }
            column(Client_Remarks; "Client Remarks") { }
            column(Assigned_Staff_No; "Assigned Staff No") { }
            column(Report_Source; "Report Source") { }
            column(Project_Type; "Project Type") { }
            column(Client; Client) { }
        }
    }
}

