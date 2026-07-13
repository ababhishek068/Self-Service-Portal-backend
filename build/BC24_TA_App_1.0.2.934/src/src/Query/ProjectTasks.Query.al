Query 50007 "Project Tasks"
{
    OrderBy = ascending(Entry_No);

    elements
    {
        dataitem(Project_Task_Allocation; "Project Task Allocation")
        {
            column(Project_No; "Project No") { }
            column(Project_Activity; "Project Activity") { }
            column(Project_Module; "Project Module") { }
            column(Start_Date; "Start Date") { }
            column(End_Date; "End Date") { }
            column(Status; Status) { }
            column(Staff_No; "Staff No") { }
            column(Entry_No; "Entry No") { }
            column(Allocation_Type; "Allocation Type") { }
            column(Support_Entry_No; "Support Entry No") { }
            column(Allocation_Remarks; "Allocation Remarks") { }
            column(Solution_Remarks; "Solution Remarks") { }
            column(Solution_Type; "Solution Type") { }
            column(Support_Issue_Description; "Support Issue Description") { }
            column(Customer; Customer) { }
            column(Staff_Name; "Staff Name") { }
            column(Consoltant_Status; "Consoltant Status") { }
        }
    }
}

