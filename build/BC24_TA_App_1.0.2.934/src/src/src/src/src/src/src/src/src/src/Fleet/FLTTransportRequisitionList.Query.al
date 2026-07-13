query 50058 "FLT-Transport Requisition List"
{
    QueryType = Normal;

    elements
    {
        dataitem(TransportRequisition; "FLT-Transport Requisition")
        {
            column(Transport_Requisition_No; "Transport Requisition No") { }
            column(From; Commencement) { }
            column(RequestType; "Vehicle Type"){}            
            column("To"; Destination) { }
            column(Responsibility_Center; "Responsibility Center") { }
            column(Date_of_Trip; "Date of Trip") { }
            column(Time_of_trip; "Time of trip") { }
            column(No_Of_Passangers; "No Of Passangers") { }
            column(No_of_Days_Requested; "No of Days Requested") { }
            column(Requested_By; "Requested By") { }
            column(Date_of_Request; "Date of Request") { }
            column(Time_Requisition_Received; "Time Requisition Received") { }
            column(Status; Status) { }
            column(Vehicle_Allocated; "Vehicle Allocated") { }
            column(Driver_Allocated; "Driver Allocated") { }
            column(Driver_Allocated2; "Driver Allocated2") { }
            column(Driver_Allocated3; "Driver Allocated3") { }
            column(Opening_Odometer_Reading; "Opening Odometer Reading") { }
            column(Clossing_ODO; "Clossing ODO") { }
            column(Purpose_of_Trip; "Purpose of Trip") { }
            column(Comments; Comments) { }
            column(Empoyee_No; "Empoyee No") { }
            column(No_of_External_Passengers; "No of External Passengers") { }
            column(Driver_Name; "Driver Name") { }
            column(Fuel_Card_No; "Fuel Card No") { }
            column(External_Driver; "External Driver") { }
            column(External_Vehicle; "External Vehicle") { }
        }

    }

    trigger OnBeforeOpen()
    begin

    end;
}
