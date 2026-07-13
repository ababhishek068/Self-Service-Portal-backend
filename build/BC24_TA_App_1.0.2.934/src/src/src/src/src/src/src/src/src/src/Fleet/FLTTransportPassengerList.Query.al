query 50059 "FLT-Transport Passenger List"
{
    QueryType = Normal;

    elements
    {
        dataitem(TransportReqPassenger; "FLT-Travel Requisition Staff")
        {
            column(Passenger_Type; "Passenger Type") { }
            column(No; No) { }
            column(Name; Name) { }
            column(Position; Position) { }
            column(Req_No; "Req No") { }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
