Query 50013 "Project List"
{
    OrderBy = ascending(No);

    elements
    {
        dataitem(Projects; Projects)
        {
            column(No; No) { }
            column(Customer_No; "Customer No") { }
            column(Project_Type; "Project Type") { }
            column(Start_Date; "Start Date") { }
            column(End_Date; "End Date") { }
            column(Status; Status) { }
            column(Project_Owner; "Project Owner") { }
            column(No_Series; "No. Series") { }
            column(Customer_Name; "Customer Name") { }
            column(Project_Description; "Project Description") { }
            column(Cost; Cost) { }
            column(Project_Status_Summary; "Project Status Summary") { }
        }
    }
}

