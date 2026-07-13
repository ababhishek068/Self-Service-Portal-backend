report 50304 "Registration Service Report"
{
    UsageCategory = Administration;
    ApplicationArea = All;

    dataset
    {
        dataitem("Registration Form"; "Registration Form")
        {
            RequestFilterFields = Status, "Current Station", "Current Main Duty", "Current Sub Duty";
            column(Service_No; "Serial No") { }
            column(Full_Names; "Full Names") { }
            column(Gender; Gender) { }
            column(ID_Number; "ID Number") { }
            column(Current_Station; "Current Station") { }
            column(Current_Main_Duty; "Current Main Duty") { }
            column(Current_Sub_Duty; "Current Sub Duty") { }
            column(Status; Status) { }
        }
    }
}