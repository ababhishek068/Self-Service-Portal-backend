Report 50043 "Vehicle Movement Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/VehicleMovementReport.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("A-Vehicle Movement"; "A-Vehicle Movement")
        {
            column(ReportForNavId_1; 1) { }
            column(No_AVehicleMovement; "A-Vehicle Movement"."No.") { }
            column(Date_AVehicleMovement; "A-Vehicle Movement".Date) { }
            column(VehicleRegNo_AVehicleMovement; "A-Vehicle Movement"."Vehicle Reg No.") { }
            column(VehicleType_AVehicleMovement; "A-Vehicle Movement"."Vehicle Type") { }
            column(TicketNo_AVehicleMovement; "A-Vehicle Movement"."Ticket No") { }
            column(DepartmentCode_AVehicleMovement; "A-Vehicle Movement"."Department Code") { }
            column(DispatchedBy_AVehicleMovement; "A-Vehicle Movement"."Dispatched By") { }
            column(DispatchDate_AVehicleMovement; "A-Vehicle Movement"."Dispatch Date") { }
            column(CurrentODOReading_AVehicleMovement; "A-Vehicle Movement"."Current ODO Reading") { }
            column(ClosedOn_AVehicleMovement; "A-Vehicle Movement"."Closed On") { }
            column(ClosedBy_AVehicleMovement; "A-Vehicle Movement"."Closed By") { }
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }
}

