Query 50017 "Employee Task Allocations"
{
    OrderBy = ascending(Staff_Name);

    elements
    {
        dataitem(Emplyees_Task_Allocations; "Emplyees Task Allocations")
        {
            column("Code"; "Code") { }
            column(Client; Client) { }
            column(Client_Name; "Client Name") { }
            column(Task; Task) { }
            column(Source; Source) { }
            column(Current_Status; "Current Status") { }
            column(Start_Date; "Start Date") { }
            column(Completion_Date; "Completion Date") { }
            column(Staff_No; "Staff No") { }
            column(Line_No; "Line No") { }
            column(Staff_Name; "Staff Name") { }
            column(Archived; Archived)
            {
                ColumnFilter = Archived = filter(false);
            }
            dataitem(Task_Allocation_Setup; "Task Allocation Setup")
            {
                DataItemLink = Code = Emplyees_Task_Allocations.Code;
                DataItemTableFilter = Current = filter(true);
            }
        }
    }
}

